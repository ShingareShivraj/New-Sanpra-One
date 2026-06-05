import 'package:flutter/material.dart';
import 'package:geolocation/model/add_visit_model.dart';
import 'package:geolocation/services/list_visit_service.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../../router.router.dart';
import '../../../services/add_visit_services.dart';

class VisitViewModel extends BaseViewModel {
  VisitViewModel({ListVisitServices? services})
      : _services = services ?? ListVisitServices();
  final TextEditingController searchController = TextEditingController();

  final ListVisitServices _services;
  AddVisitModel? activeVisit;

  // Data
  List<AddVisitModel> _visitList = const [];
  List<AddVisitModel> get visitList => _visitList;
  List<AddVisitModel> _allVisitList = [];

  // Date range
  DateTime? _fromDate;
  DateTime? get fromDate => _fromDate;

  DateTime? _toDate;
  DateTime? get toDate => _toDate;

  String get fromDateLabel =>
      _fromDate == null ? "-" : _uiFmt.format(_fromDate!);
  String get toDateLabel => _toDate == null ? "-" : _uiFmt.format(_toDate!);

  // Formatters
  final DateFormat _apiFmt = DateFormat('yyyy-MM-dd');
  final DateFormat _uiFmt = DateFormat('dd MMM, yyyy');

  // Cache: "from|to" -> list
  final Map<String, List<AddVisitModel>> _cache = {};

  // Prevent stale responses overwriting latest
  int _requestId = 0;
  void setCustomerFilter(String query) {
    if (query.isEmpty) {
      _visitList = _allVisitList;
    } else {
      _visitList = _allVisitList.where((visit) {
        return (visit.visitorsName ?? "")
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  Future<void> initialise(BuildContext context) async {
    // Default: current month start -> today
    final now = DateTime.now();
    _fromDate ??= DateTime(now.year, now.month, now.day);
    _toDate ??= DateTime(now.year, now.month, now.day);

    activeVisit =
    await AddVisitServices().getActiveVisit();

    await _loadVisits(
      from: _fromDate!,
      to: _toDate!,
      useCache: true,
      showBusy: true,
    );
  }

  Future<void> refresh() async {
    if (_fromDate == null || _toDate == null) return;

    await _loadVisits(
      from: _fromDate!,
      to: _toDate!,
      useCache: false,
      showBusy: true,
    );
  }

  /// Call this when user selects From Date
  void updateFromDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);

    // if toDate exists and becomes invalid, auto-fix
    if (_toDate != null && normalized.isAfter(_toDate!)) {
      _toDate = normalized;
    }

    if (_fromDate != null &&
        _fromDate!.year == normalized.year &&
        _fromDate!.month == normalized.month &&
        _fromDate!.day == normalized.day) {
      return;
    }

    _fromDate = normalized;
    notifyListeners();

    if (_toDate != null) {
      _loadVisits(
          from: _fromDate!, to: _toDate!, useCache: true, showBusy: true);
    }
  }

  /// Call this when user selects To Date
  void updateToDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);

    // if fromDate exists and becomes invalid, auto-fix
    if (_fromDate != null && normalized.isBefore(_fromDate!)) {
      _fromDate = normalized;
    }

    if (_toDate != null &&
        _toDate!.year == normalized.year &&
        _toDate!.month == normalized.month &&
        _toDate!.day == normalized.day) {
      return;
    }

    _toDate = normalized;
    notifyListeners();

    if (_fromDate != null) {
      _loadVisits(
          from: _fromDate!, to: _toDate!, useCache: true, showBusy: true);
    }
  }

  /// Optional: set both together (when using a date range picker)
  Future<void> setDateRange(DateTime from, DateTime to) async {
    final f = DateTime(from.year, from.month, from.day);
    final t = DateTime(to.year, to.month, to.day);

    _fromDate = f.isAfter(t) ? t : f;
    _toDate = t.isBefore(f) ? f : t;

    notifyListeners();

    await _loadVisits(
        from: _fromDate!, to: _toDate!, useCache: true, showBusy: true);
  }

  void onRowClick(
      BuildContext context,
      AddVisitModel visit,
      ) {

    if (visit.status == "In Progress") {

      Navigator.pushNamed(
        context,
        Routes.addVisitScreen,
        arguments: AddVisitScreenArguments(
          VisitId: visit.name ?? "",
        ),
      );

    } else {

      Navigator.pushNamed(
        context,
        Routes.updateVisitScreen,
        arguments: UpdateVisitScreenArguments(
          updateId: visit.name ?? "",
        ),
      );

    }
  }

  // ---------------- Internal ----------------

  Future<void> _loadVisits({
    required DateTime from,
    required DateTime to,
    required bool useCache,
    required bool showBusy,
  }) async {
    final fromStr = _apiFmt.format(from);
    final toStr = _apiFmt.format(to);
    final key = '$fromStr|$toStr';

    // ✅ Use cache
    if (useCache && _cache.containsKey(key)) {
      _allVisitList = _cache[key]!;
      _visitList = _cache[key]!;
      notifyListeners();
      return;
    }

    final int currentReq = ++_requestId;

    Future<void> task() async {
      try {
        final result = await _services.fetchVisitByDateRange(fromStr, toStr);

        if (currentReq != _requestId) return;

        _cache[key] = result;

        // 🔥 IMPORTANT FIX
        _allVisitList = result;
        _visitList = result;
      } catch (_) {
        if (currentReq != _requestId) return;

        _allVisitList = [];
        _visitList = const [];
      }

      notifyListeners();
    }

    if (showBusy) {
      await runBusyFuture(task());
    } else {
      await task();
    }
  }
}
