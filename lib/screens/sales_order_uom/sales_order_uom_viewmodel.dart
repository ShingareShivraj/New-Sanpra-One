import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

import 'sales_order_uom_model.dart';
import 'sales_order_uom_service.dart';

class SalesOrderUomViewModel extends BaseViewModel {
  final SalesOrderUomService _service = SalesOrderUomService();

  // Used by the Form in sales_order_uom_screen.dart
  final formKey = GlobalKey<FormState>();
  final termsController = TextEditingController();

  // Master data
  List<String> customers = [];
  List<UomItem> items = [];

  // Header
  String? selectedCustomer;
  DateTime selectedDate = DateTime.now();

  // Items selected for the order
  final List<UomOrderItem> selectedItems = [];

  // Existing order name.
  // null/empty = create mode
  // value     = update mode
  String? orderId;

  bool get isEditMode =>
      orderId != null && orderId!.trim().isNotEmpty;

  // ---------------------------------------------------------------------------
  // INITIALISE
  // ---------------------------------------------------------------------------

  Future<void> initialise({
    String? orderId,
  }) async {
    this.orderId = orderId;

    setBusy(true);

    try {
      final masters = await _service.fetchMasters();

      if (masters != null) {
        customers = masters.customers ?? [];
      } else {
        customers = [];
      }

      items = await _service.fetchUomItems();

      // If an existing order was opened, load its values after
      // the UOM item master has been loaded.
      if (isEditMode) {
        await loadOrder(this.orderId!);
      }

      debugPrint("========== UOM FORM DATA ==========");
      debugPrint("Customers: ${customers.length}");
      debugPrint("Items: ${items.length}");
      debugPrint("Edit mode: $isEditMode");
      debugPrint("Order ID: ${this.orderId}");
      debugPrint("===================================");
    } catch (e) {
      debugPrint("UOM initialise error: $e");

      Fluttertoast.showToast(
        msg: "Failed to load order data",
      );
    } finally {
      setBusy(false);
    }
  }

  // ---------------------------------------------------------------------------
  // LOAD EXISTING ORDER
  // ---------------------------------------------------------------------------

  Future<void> loadOrder(String orderName) async {
    try {
      final Map<String, dynamic>? order =
      await _service.fetchOrder(orderName);

      if (order == null) {
        Fluttertoast.showToast(
          msg: "Unable to load order",
        );
        return;
      }

      // Keep the actual order name.
      orderId = orderName;

      // Customer
      selectedCustomer = order["customer"]?.toString();
      termsController.text = order["terms"]?.toString() ?? "";

      // Delivery date
      final rawDate = order["delivery_date"]?.toString();

      if (rawDate != null && rawDate.isNotEmpty) {
        final parsedDate = DateTime.tryParse(rawDate);

        if (parsedDate != null) {
          selectedDate = parsedDate;
        }
      }

      // Items
      selectedItems.clear();

      final rawItems = order["items"];

      if (rawItems is List) {
        for (final raw in rawItems) {
          if (raw is! Map) continue;

          final itemCode = raw["item_code"]?.toString() ?? "";

          if (itemCode.isEmpty) continue;

          // Find the complete UOM item from the already loaded item master.
          UomItem? uomItem;

          for (final item in items) {
            if (item.itemCode == itemCode) {
              uomItem = item;
              break;
            }
          }

          if (uomItem == null) {
            debugPrint(
              "UOM item not found in item master: $itemCode",
            );
            continue;
          }

          final savedUom = raw["uom"]?.toString();

          UomOption? selectedUom;

          if (savedUom != null && savedUom.isNotEmpty) {
            for (final option in uomItem.uoms) {
              if (option.uom == savedUom) {
                selectedUom = option;
                break;
              }
            }
          }

          // If the saved UOM isn't returned in the current item's UOM list,
          // fall back to the first available UOM.
          selectedUom ??=
          uomItem.uoms.isNotEmpty ? uomItem.uoms.first : null;

          final quantity =
              double.tryParse(raw["qty"]?.toString() ?? "") ?? 1;

          selectedItems.add(
            UomOrderItem(
              item: uomItem,
              selectedUom: selectedUom,
              quantity: quantity > 0 ? quantity : 1,
            ),
          );
        }
      }

      debugPrint("Loaded UOM order: $orderId");
      debugPrint("Customer: $selectedCustomer");
      debugPrint("Items loaded: ${selectedItems.length}");

      notifyListeners();
    } catch (e) {
      debugPrint("Load UOM order error: $e");

      Fluttertoast.showToast(
        msg: "Failed to load order",
      );
    }
  }

  // ---------------------------------------------------------------------------
  // CUSTOMER
  // ---------------------------------------------------------------------------

  void setCustomer(String? value) {
    selectedCustomer = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // ITEMS
  // ---------------------------------------------------------------------------

  void setSelectedItems(List<UomOrderItem> items) {
    selectedItems
      ..clear()
      ..addAll(items);

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
    if (index < 0 || index >= selectedItems.length) {
      return;
    }

    selectedItems.removeAt(index);
    notifyListeners();
  }

  void setUom(
      int index,
      UomOption? value,
      ) {
    if (value == null) return;

    if (index < 0 || index >= selectedItems.length) {
      return;
    }

    selectedItems[index].selectedUom = value;

    notifyListeners();
  }

  // Keep String here because the screen's TextField passes String.
  void setQuantity(
      int index,
      String value,
      ) {
    if (index < 0 || index >= selectedItems.length) {
      return;
    }

    final quantity = double.tryParse(value);

    if (quantity == null || quantity <= 0) {
      return;
    }

    selectedItems[index].quantity = quantity;

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // ITEM SELECTION SCREEN SUPPORT
  // ---------------------------------------------------------------------------

  void setSelectedItemsFromPicker(
      List<UomOrderItem> items,
      ) {
    selectedItems
      ..clear()
      ..addAll(items);

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // DATE
  // ---------------------------------------------------------------------------

  String get formattedDate {
    final d = selectedDate;

    return "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";
  }

  Future<void> selectDate(
      BuildContext context,
      ) async {
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

  // ---------------------------------------------------------------------------
  // VALIDATION
  // ---------------------------------------------------------------------------

  bool _validateOrder() {
    if (selectedCustomer == null ||
        selectedCustomer!.trim().isEmpty) {
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

    for (final orderItem in selectedItems) {
      if (orderItem.quantity <= 0) {
        Fluttertoast.showToast(
          msg: "Quantity must be greater than 0",
        );
        return false;
      }

      if (orderItem.selectedUom == null) {
        Fluttertoast.showToast(
          msg: "Please select UOM for ${orderItem.item.itemName}",
        );
        return false;
      }
    }

    return true;
  }

  // ---------------------------------------------------------------------------
  // CREATE
  // ---------------------------------------------------------------------------

  Future<bool> createOrder(
      BuildContext context,
      ) async {
    if (!_validateOrder()) {
      return false;
    }

    if (isBusy) {
      return false;
    }

    setBusy(true);

    try {
      final orderName = await _service.createOrder(
        customer: selectedCustomer!,
        deliveryDate: formattedDate,
        terms: termsController.text.trim(),
        items: selectedItems,
      );

      if (orderName.isNotEmpty) {
        if (context.mounted) {
          Navigator.pop(context, true);
        }

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Create UOM order error: $e");

      Fluttertoast.showToast(
        msg: "Failed to create order",
      );

      return false;
    } finally {
      setBusy(false);
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE
  // ---------------------------------------------------------------------------

  Future<bool> updateOrder(
      BuildContext context,
      ) async {
    if (!isEditMode) {
      Fluttertoast.showToast(
        msg: "Order ID is missing",
      );
      return false;
    }

    if (!_validateOrder()) {
      return false;
    }

    if (isBusy) {
      return false;
    }

    setBusy(true);

    try {
      final success = await _service.updateOrder(
        orderId: orderId!,
        customer: selectedCustomer!,
        deliveryDate: formattedDate,
        terms: termsController.text.trim(),
        items: selectedItems,
      );

      if (success) {
        if (context.mounted) {
          Navigator.pop(context, true);
        }

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Update UOM order error: $e");

      Fluttertoast.showToast(
        msg: "Failed to update order",
      );

      return false;
    } finally {
      setBusy(false);
    }
  }

  // ---------------------------------------------------------------------------
  // RESET
  // ---------------------------------------------------------------------------

  void resetForm() {
    orderId = null;
    selectedCustomer = null;
    selectedDate = DateTime.now();
    selectedItems.clear();
    termsController.clear();

    notifyListeners();
  }
}
