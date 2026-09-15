import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocation/model/add_lead_model.dart';
import 'package:geolocation/model/notes_list.dart';
import 'package:geolocation/services/update_lead_services.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/add_lead_services.dart';
import '../../../services/call_services.dart';

class UpdateLeadModel extends BaseViewModel {
  // ──────────────────────────────────────────────────────────────
  // SERVICES
  // ──────────────────────────────────────────────────────────────
  final CallsAndMessagesService callService = CallsAndMessagesService();
  final AddLeadServices _leadService = AddLeadServices();
  final UpdateLeadServices _updateService = UpdateLeadServices();
  final Logger _logger = Logger();

  // ──────────────────────────────────────────────────────────────
  // ──────────────────────────────────────────────────────────────
  // CONTROLLERS
  // ──────────────────────────────────────────────────────────────
  final TextEditingController noteController = TextEditingController();

  // ──────────────────────────────────────────────────────────────
  // DATA
  // ──────────────────────────────────────────────────────────────
  AddLeadModel leadData = AddLeadModel();
  List<NotesList> notes = [];

  // ──────────────────────────────────────────────────────────────
  // STATE
  // ──────────────────────────────────────────────────────────────
  bool isLoading = false;
  bool isActionInProgress = false;

  // ──────────────────────────────────────────────────────────────
  // STATUS OPTIONS
  // ──────────────────────────────────────────────────────────────
  static const List<String> statusOptions = [
    "Lead",
    "Open",
    "Replied",
    "Opportunity",
    "Quotation",
    "Lost Quotation",
    "Interested",
    "Converted",
    "Do Not Contact",
  ];

  Color getStatusColor(String? status) {
    switch (status) {
      case "Lead":
        return Colors.grey;
      case "Open":
        return Colors.blue;
      case "Replied":
        return Colors.indigo;
      case "Opportunity":
      case "Quotation":
        return Colors.orange;
      case "Converted":
        return Colors.green;
      case "Lost Quotation":
      case "Do Not Contact":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // INITIALISE (PARALLEL API CALLS)
  // ──────────────────────────────────────────────────────────────
  Future<void> initialise(BuildContext context, String leadId) async {
    if (leadId.isEmpty) return;

    _setLoading(true);

    try {
      final results = await Future.wait([
        _leadService.getLead(leadId),
        _updateService.getnotes(leadId),
      ]);

      leadData = results[0] as AddLeadModel? ?? AddLeadModel();
      notes = results[1] as List<NotesList>? ?? [];

      _logger.i('Lead loaded: ${leadData.name}');
    } catch (e, stack) {
      _logger.e('Error initializing lead', error: e, stackTrace: stack);
    } finally {
      _setLoading(false);
    }
  }

  // ──────────────────────────────────────────────────────────────
  // WHATSAPP
  // ──────────────────────────────────────────────────────────────
  Future<void> openWhatsApp(String contact) async {
    if (contact.isEmpty) return;

    final message = Uri.encodeComponent('Hi, ${leadData.company ?? ''}');
    final uri = Uri.parse(
      Platform.isIOS
          ? 'https://wa.me/$contact?text=$message'
          : 'whatsapp://send?phone=$contact&text=$message',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _logger.w('WhatsApp not installed');
      }
    } catch (e, stack) {
      _logger.e('WhatsApp launch error', error: e, stackTrace: stack);
    }
  }

  // ──────────────────────────────────────────────────────────────
  // ADD NOTE (OPTIMISTIC UPDATE – 1 API CALL)
  // ──────────────────────────────────────────────────────────────
  Future<void> addNote(String leadId, String noteText) async {
    if (leadId.isEmpty || noteText.trim().isEmpty) return;

    final trimmedNote = noteText.trim();
    _setActionState(true);

    try {
      final success = await _updateService.addnotes(leadId, trimmedNote);
      if (success) {
        notes.insert(
          0,
          NotesList(
            note: trimmedNote,
          ),
        );
        noteController.clear();
        notifyListeners();
      }
    } catch (e, stack) {
      _logger.e('Error adding note', error: e, stackTrace: stack);
    } finally {
      _setActionState(false);
    }
  }

  // ──────────────────────────────────────────────────────────────
  // DELETE NOTE (OPTIMISTIC + ROLLBACK)
  // ──────────────────────────────────────────────────────────────
  Future<void> deleteNote(String leadId, int index) async {
    if (leadId.isEmpty || index < 0 || index >= notes.length) return;

    final removedNote = notes.removeAt(index);
    notifyListeners();

    try {
      await _updateService.deletenotes(leadId, index);
    } catch (e, stack) {
      notes.insert(index, removedNote);
      notifyListeners();
      _logger.e('Error deleting note', error: e, stackTrace: stack);
    }
  }

  // ──────────────────────────────────────────────────────────────
  // CHANGE STATUS
  // ──────────────────────────────────────────────────────────────
  Future<void> changeStatus(String leadId, String status) async {
    if (leadId.isEmpty || status.isEmpty) return;

    _setActionState(true);

    try {
      await _updateService.changestatus(leadId, status);

      // Update local model
      leadData.status = status;
      notifyListeners();
    } catch (e, stack) {
      _logger.e('Error changing status', error: e, stackTrace: stack);

      SnackbarService().showSnackbar(
        message: "Failed to update status",
        duration: const Duration(seconds: 2),
      );
    } finally {
      _setActionState(false);
    }
  }

  Future<bool> confirmStatusChange(BuildContext context, String status) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Change Lead Status"),
            content: Text("Change lead status to \"$status\"?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Confirm"),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ──────────────────────────────────────────────────────────────
  // STATE HELPERS
  // ──────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    setBusy(value);
    notifyListeners();
  }

  void _setActionState(bool value) {
    isActionInProgress = value;
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────
  // CLEANUP
  // ──────────────────────────────────────────────────────────────
  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
