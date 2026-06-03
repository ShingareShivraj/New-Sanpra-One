import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/quotation_list_model.dart';
import '../../../router.router.dart';
import '../../../services/list_quotation_services.dart';


class ListQuotationModel extends BaseViewModel {
  final QuotationServices _service = QuotationServices();

  List<QuotationList> quotationlist = [];
  List<QuotationList> filterquotationlist = [];

  List<String> customer = [];
  final List<String> quotation = ["Customer", "Lead"];

  String _searchQuery = "";

  Future<void> initialise(BuildContext context) async {
    setBusy(true);
    try {
      final results = await Future.wait([
        _service.fetchquotation(),
      ]);

      quotationlist = List<QuotationList>.from(results[0]);
      filterquotationlist = List<QuotationList>.from(quotationlist);
    } catch (_) {
      quotationlist = [];
      filterquotationlist = [];
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  //======================= share quatation adeed by shivraj===============
  Future<void> shareQuotation(QuotationList quotation) async {
    try {
      setBusy(true);

      // Step 1: Download quotation PDF from ERPNext
      File file = await _service.downloadQuotationPDF(
        quotation.name ?? "",
      );

      setBusy(false);

      // Step 2: Open Share Sheet
      await Share.shareXFiles(
        [XFile(file.path)],
        text: "Please find your quotation attached.",
      );
    } catch (e) {
      setBusy(false);
      print(e);
    }
  }



  void onRowClick(BuildContext context, QuotationList? qList) {
    Navigator.pushNamed(
      context,
      Routes.addQuotationView,
      arguments: AddQuotationViewArguments(
        quotationid: qList?.name ?? "",
      ),
    );
  }

  Color getColorForStatus(String status) {
    switch (status) {
      case 'Draft':
        return Colors.grey.shade500;
      case 'Open':
        return Colors.orangeAccent;
      case 'Partially Ordered':
        return Colors.amber;
      case 'Ordered':
        return Colors.green;
      case 'Lost':
        return Colors.grey;
      case 'Expired':
        return Colors.red;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  Color getQuotationForStatus(String status) {
    switch (status) {

      case 'Lead':
        return Colors.orange;
      case 'Customer':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  Future<void> refresh() async {
    try {
      final data = await _service.fetchquotation();
      quotationlist = List<QuotationList>.from(data);
      _applyLocalFilters(notify: true);
    } catch (_) {
      notifyListeners();
    }
  }



  void searchPartyName(String value) {
    _searchQuery = value.trim().toLowerCase();
    _applyLocalFilters(notify: true);
  }

  void _applyLocalFilters({bool notify = false}) {
    if (_searchQuery.isEmpty) {
      filterquotationlist = List<QuotationList>.from(quotationlist);
    } else {
      filterquotationlist = quotationlist.where((q) {
        final partyName = (q.customerName ?? "").toLowerCase();
        final quotationId = (q.name ?? "").toLowerCase();
        return partyName.contains(_searchQuery) ||
            quotationId.contains(_searchQuery);
      }).toList();
    }

    if (notify) {
      notifyListeners();
    }
  }
}