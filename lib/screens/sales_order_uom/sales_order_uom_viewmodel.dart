import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

import 'sales_order_uom_model.dart';
import 'sales_order_uom_service.dart';

class SalesOrderUomViewModel extends BaseViewModel {
  final SalesOrderUomService _service = SalesOrderUomService();

  final formKey = GlobalKey<FormState>();

  List<String> customers = [];
  List<UomItem> items = [];

  String? selectedCustomer;

  DateTime selectedDate = DateTime.now();

  final List<UomOrderItem> selectedItems = [];

  Future<void> initialise() async {
    setBusy(true);

    try {
      final masters = await _service.fetchMasters();

      if (masters != null) {
        customers = masters.customers ?? [];
      }

      items = await _service.fetchUomItems();

      print("========== UOM FORM DATA ==========");
      print("Customers: ${customers.length}");
      print("Items: ${items.length}");
      print("===================================");
    } catch (e) {
      print("UOM initialise error: $e");

      Fluttertoast.showToast(
        msg: "Failed to load order data",
      );
    }

    setBusy(false);
  }
  void setCustomer(String? value) {
    selectedCustomer = value;
    notifyListeners();
  }
  void setSelectedItems(List<UomOrderItem> items) {
    selectedItems
      ..clear()
      ..addAll(items);

    notifyListeners();
  }


  void setUom(
      int index,
      UomOption? value,
      ) {
    if (value == null) return;

    selectedItems[index].selectedUom = value;

    notifyListeners();
  }

  void setQuantity(
      int index,
      String value,
      ) {
    final quantity = double.tryParse(value);

    if (quantity == null || quantity <= 0) {
      return;
    }

    selectedItems[index].quantity = quantity;

    notifyListeners();
  }

  void addItem(UomItem item) {
    final alreadyExists = selectedItems.any(
          (element) => element.item.itemCode == item.itemCode,
    );

    if (alreadyExists) {
      Fluttertoast.showToast(
        msg: "${item.itemName} already added",
      );
      return;
    }

    selectedItems.add(
      UomOrderItem(
        item: item,
        selectedUom: item.uoms.isNotEmpty
            ? item.uoms.first
            : null,
        quantity: 1,
      ),
    );

    notifyListeners();
  }

  void removeItem(int index) {
    selectedItems.removeAt(index);
    notifyListeners();
  }

  String get formattedDate {
    final d = selectedDate;

    return "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  Future<bool> createOrder(BuildContext context) async {
    if (selectedCustomer == null ||
        selectedCustomer!.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please select customer",
      );
      return false;
    }



    if (selectedItems.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please select at least one item",
      );
      return false;
    }

    for (final item in selectedItems) {
      if (item.selectedUom == null) {
        Fluttertoast.showToast(
          msg: "Please select UOM for ${item.item.itemName}",
        );
        return false;
      }

      if (item.quantity <= 0) {
        Fluttertoast.showToast(
          msg: "Quantity must be greater than 0",
        );
        return false;
      }
    }

    setBusy(true);

    try {
      final orderName = await _service.createOrder(
        customer: selectedCustomer!,
        deliveryDate: formattedDate,
        items: selectedItems,
      );

      if (orderName.isNotEmpty) {
        if (context.mounted) {
          Navigator.pop(context, true);
        }

        return true;
      }

      return false;
    } finally {
      setBusy(false);
    }
  }
}