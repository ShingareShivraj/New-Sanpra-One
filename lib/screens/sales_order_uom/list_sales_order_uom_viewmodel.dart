import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../model/order_list_model.dart';
import '../../../router.router.dart';
import '../../../services/home_services.dart';
import '../../../services/order_services.dart';
import 'sales_order_uom_screen.dart';

class ListSalesOrderUomModel extends BaseViewModel {
  final _orderService = OrderServices();
  final _homeService = HomeServices();

  final customerController = TextEditingController();

  List<OrderList> _orderList = [];
  List<OrderList> _filteredOrderList = [];

  List<OrderList> get filteredOrderList => _filteredOrderList;

  String _customerSearch = '';
  String? selectedStatus;

  final List<String> statusList = [
    'Pending',
    'Accepted',
    'Partially Delivered',
    'Fully Delivered',
    'Cancelled',
    'Closed',
  ];

  Future<void> initialise(BuildContext context) async {
    setBusy(true);

    try {
      /*
       * IMPORTANT:
       * The current backend stores UOM orders in the same Sales Order
       * doctype as normal orders. Therefore the existing fetchSalesOrder()
       * API cannot reliably distinguish UOM orders from normal orders.
       *
       * For now we load the existing Sales Order list so the screen/UI
       * is ready. Once the dedicated UOM list API is added, replace only
       * the fetch below with that API.
       */
      final orders = await _orderService.fetchSalesOrder();

      _orderList = List<OrderList>.from(orders);



      applyFilters();
    } catch (e) {
      debugPrint('UOM sales order list error: $e');
      _orderList = [];
      _filteredOrderList = [];
    }

    setBusy(false);
  }

  void setCustomer(String value) {
    _customerSearch = value.trim().toLowerCase();
    applyFilters();
  }
  void setStatus(String? value) {
    selectedStatus = value;
    applyFilters();
  }

  void applyFilters() {
    _filteredOrderList = _orderList.where((order) {
      final customer = (order.customerName ?? '').toLowerCase();
      final name = (order.name ?? '').toLowerCase();

      final customerMatch =
          _customerSearch.isEmpty ||
              customer.contains(_customerSearch) ||
              name.contains(_customerSearch);

      final orderStatus = getOrderDisplayStatus(
        order.status,
        order.deliveryStatus,
      );

      final statusMatch =
          selectedStatus == null ||
              selectedStatus!.isEmpty ||
              orderStatus == selectedStatus;

      return customerMatch && statusMatch;
    }).toList();

    notifyListeners();
  }

  void clearFilter() {
    customerController.clear();

    _customerSearch = '';
    selectedStatus = null;

    _filteredOrderList = List<OrderList>.from(_orderList);

    notifyListeners();
  }

  Future<void> refresh() async {
    setBusy(true);

    try {
      final orders = await _orderService.fetchSalesOrder();

      _orderList = List<OrderList>.from(orders);



      applyFilters();
    } catch (e) {
      debugPrint('UOM sales order refresh error: $e');
    } finally {
      setBusy(false);
    }
  }

  String getOrderDisplayStatus(String? status, String? deliveryStatus) {
    final s = (status ?? '').toLowerCase();
    final d = (deliveryStatus ?? '').toLowerCase();

    if (s == 'draft' && d == 'not delivered') {
      return 'Pending';
    }

    if (s == 'to deliver and bill' && d == 'not delivered') {
      return 'Accepted';
    }

    if (s == 'to deliver and bill' && d == 'partly delivered') {
      return 'Partially Delivered';
    }

    if (s == 'to bill' && d == 'fully delivered') {
      return 'Fully Delivered';
    }

    if (s == 'cancelled') {
      return 'Cancelled';
    }

    if (s == 'closed') {
      return 'Closed';
    }

    return 'Processing';
  }

  Future<void> createUomOrder(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SalesOrderUomScreen(),
      ),
    );

    if (result == true) {
      await refresh();
    }
  }

  Future<void> openOrderDetails(
      BuildContext context,
      OrderList order,
      ) async {
    if (order.name == null || order.name!.isEmpty) return;

    debugPrint('Open UOM Sales Order: ${order.name}');

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SalesOrderUomScreen(
          orderId: order.name!,
        ),
      ),
    );

    if (result == true) {
      await refresh();
    }
  }

  @override
  void dispose() {
    customerController.dispose();
    super.dispose();
  }
}
