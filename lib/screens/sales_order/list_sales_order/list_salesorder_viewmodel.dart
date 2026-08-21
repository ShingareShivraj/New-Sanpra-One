import 'package:flutter/material.dart';
import 'package:geolocation/services/add_order_services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../../model/order_list_model.dart';
import '../../../router.router.dart';
import '../../../services/order_services.dart';
import '../../../services/home_services.dart';

class ListOrderModel extends BaseViewModel {
  final _orderService = OrderServices();
  final _addOrderService = AddOrderServices();
  final customerController = TextEditingController();
  final _homeService = HomeServices();

  List<String> availableDocTypes = [];

  List<OrderList> _orderList = []; // full list
  List<OrderList> _filteredOrderList = [];
  List<OrderList> get filteredOrderList => _filteredOrderList;

  List<String> _searchCustomerList = [""];
  List<String> get searchCustomerList => _searchCustomerList;

  String? _selectedCustomer;
  String? get selectedCustomer => _selectedCustomer;

  String? _selectedDate;
  String? get selectedDate => _selectedDate;

  String? selectedStatus;
  List<String> statusList = [
    "Pending",
    "Accepted",
    "Partially Delivered",
    "Fully Delivered",
    "Cancelled",
    "Closed",
  ];

  DateTime? _selectedDeliveryDate;
  void setCustomer(String customer) {
    _selectedCustomer = customer;
    applyFilters(); // live filtering
  }

  /// Initial fetch
  Future<void> initialise(BuildContext context) async {
    setBusy(true);

    try {
      final results = await Future.wait([
        _orderService.fetchSalesOrder(),
        _homeService.fetchRoles(),
      ]);

      final fetchedOrders = results[0] as List<OrderList>;

      _orderList = List.from(fetchedOrders);
      _filteredOrderList = List.from(fetchedOrders);

      availableDocTypes =
          (results[1] as List).map((e) => e.toString()).toList();
      print("========== AVAILABLE ROLES ==========");
      print(availableDocTypes);
      print("UOM ROLE = ${isFormAvailableForDocType("Mobile Sales Order UOM")}");
      print("====================================");

    } catch (e) {
      debugPrint('Error in initialise: $e');
    }

    setBusy(false);
  }
  bool isFormAvailableForDocType(String docType) {
    if (docType == "Mobile Sales Order") {
      return availableDocTypes.contains("Sales Order");
    }

    return availableDocTypes.contains(docType);
  }
  @override
  void dispose() {
    customerController.dispose();
    super.dispose();
  }

  /// Update customer selection

  /// Update status selection
  void setStatus(String? status) {
    selectedStatus = status;
    notifyListeners();
  }

  /// Date selection
  Future<void> selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDeliveryDate) {
      _selectedDeliveryDate = picked;
      _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  /// Refresh full list from server
  Future<void> refresh() async {
    setBusy(true);
    try {
      final freshOrders = await _orderService.fetchSalesOrder();
      _orderList = List.from(freshOrders);
      applyFilters(); // reapply current filters
    } catch (e) {
      debugPrint('Refresh failed: $e');
    }
    setBusy(false);
  }

  String getOrderDisplayStatus(String? status, String? deliveryStatus) {
    final s = (status ?? "").toLowerCase();
    final d = (deliveryStatus ?? "").toLowerCase();

    if (s == "draft" && d == "not delivered") {
      return "Pending";
    } else if (s == "to deliver and bill" && d == "not delivered") {
      return "Accepted";
    } else if (s == "to deliver and bill" && d == "partly delivered") {
      return "Partially Delivered";
    } else if (s == "to bill" && d == "fully delivered") {
      return "Fully Delivered";
    } else if (s == "cancelled" && d == "not delivered") {
      return "Cancelled";
    } else if (s == "closed" && d == "not delivered") {
      return "Closed";
    }

    // Optional fallback
    switch (s) {
      case "draft":
        return "Pending";
      case "to deliver and bill":
        return "Accepted";
      case "to bill":
        return "Pending Billing";
      case "completed":
        return "Completed";
      case "cancelled":
        return "Cancelled";
      case "closed":
        return "Closed";
      default:
        return "Processing";
    }
  }

  /// Apply all filters (customer, date, status)
  void applyFilters() {
    _filteredOrderList = _orderList.where((order) {
      // Customer filter: partial match, case-insensitive
      final customerMatch = _selectedCustomer == null ||
          _selectedCustomer!.isEmpty ||
          order.customerName!
              .toLowerCase()
              .contains(_selectedCustomer!.toLowerCase());

      // Status filter: exact match, case-insensitive
      final statusMatch = selectedStatus == null ||
          selectedStatus!.isEmpty ||
          getOrderDisplayStatus(order.status, order.deliveryStatus)
              .toLowerCase()
              .contains(selectedStatus!.toLowerCase());

      return customerMatch && statusMatch;
    }).toList();

    notifyListeners();
  }

  /// Apply filter from bottom sheet
  void setFilter(String? customer, String? date, String? status) {
    _selectedCustomer = customer;
    _selectedDate = date;
    selectedStatus = status;
    applyFilters();
  }

  /// Clear filters
  void clearFilter() {
    customerController.clear();
    selectedStatus = null;
    _filteredOrderList = List.from(_orderList);
    notifyListeners();
  }

  /// Navigate to order screen
  Future<void> onRowClick(BuildContext context, OrderList? order) async {
    if (order?.name == null) return;

    final result = await Navigator.pushNamed(
      context,
      Routes.addOrderScreen,
      arguments: AddOrderScreenArguments(orderid: order!.name!),
    );

    if (result == true) {
      await refresh();
    }
  }
}
