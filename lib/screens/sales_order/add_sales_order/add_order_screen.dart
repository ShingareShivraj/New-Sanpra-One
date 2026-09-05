import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/widgets/full_screen_loader.dart';
import 'package:stacked/stacked.dart';

import '../../../constants.dart';
import '../../../model/add_order_model.dart';
import '../../../router.router.dart';
import '../../../widgets/drop_down.dart';
import '../../../widgets/text_button.dart';
import 'add_order_viewmodel.dart';

class AddOrderScreen extends StatefulWidget {
  final String orderid;
  const AddOrderScreen({super.key, required this.orderid});
  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddOrderViewModel>.reactive(
      viewModelBuilder: () => AddOrderViewModel(),
      onViewModelReady: (model) => model.initialise(context, widget.orderid),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(model.isEdit == true
                ? model.orderData.name ?? ""
                : 'Create Order'),
            actions: [
              if (model.orderData.docstatus ==
                  1) // Only show for submitted orders
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'close_order') {
                      await showConfirmationDialog(
                        context: context,
                        title: 'Close Order',
                        message: 'Are you sure you want to close this order?',
                        actionText: 'Close Order',
                        onConfirm: () => model.closeNewOrder(context),
                      );
                    }

                    if (value == 'open_order') {
                      await showConfirmationDialog(
                        context: context,
                        title: 'Re-Open Order',
                        message: 'Are you sure you want to re-open this order?',
                        actionText: 'Re-Open Order',
                        onConfirm: () => model.openNewOrder(context),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    // Show Re-Open only if status is 'Closed'
                    // Show Close only if status is NOT 'Closed'
                    if (model.orderData.status?.toLowerCase() == 'closed') {
                      return const [
                        PopupMenuItem<String>(
                          value: 'open_order',
                          child: Text('Re-Open'),
                        ),
                      ];
                    } else {
                      return const [
                        PopupMenuItem<String>(
                          value: 'close_order',
                          child: Text('Close'),
                        ),
                      ];
                    }
                  },
                ),
            ],
          ),
          body: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              return true;
            },
            child: fullScreenLoader(
              loader: model.isBusy,
              context: context,
              child: SingleChildScrollView(
                child: AbsorbPointer(
                  absorbing: model.orderData.docstatus == 1 ||
                      model.orderData.docstatus == 2,
                  child: Form(
                    key: model.formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          WarehouseDropdown(model: model),
                          const SizedBox(height: 15),
                          CustomerDropdown(model: model),
                          const SizedBox(height: 15),
                          OrderTypeAndDeliveryDateRow(model: model),
                          const SizedBox(height: 15),
                          ItemsSelector(model: model),
                          const SizedBox(height: 5),
                          const Text(
                            'Item List',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          SelectedItemList(model: model),
                          const SizedBox(height: 8),
                          BillingSection(model: model),
                          const SizedBox(height: 25),
                          OrderDescriptionField(model: model),
                          const SizedBox(height: 25),
                          if (model.orderData.docstatus != 2)
                            ActionButtons(model: model),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String actionText,
    required Future<bool> Function() onConfirm, // returns success/fail
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true); // close dialog first
                await onConfirm(); // async action
              },
              child: Text(
                actionText,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}

// Individual smaller widget examples

class OrderDescriptionField extends StatelessWidget {
  final AddOrderViewModel model;

  const OrderDescriptionField({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: model.termsController,
      maxLines: 4,
      minLines: 3,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Add any important note for this order',
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(
            bottom: 55,
          ),
          child: Icon(
            Icons.notes_outlined,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class CustomerDropdown extends StatelessWidget {
  final AddOrderViewModel model;
  const CustomerDropdown({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdownButton2(
      value: model.orderData.customer,
      prefixIcon: Icons.person_2,
      items: model.customerNames,
      hintText: 'Select the customer',
      labelText: 'Customer',
      onChanged: model.setCustomer,
    );
  }
}

class OrderTypeAndDeliveryDateRow extends StatelessWidget {
  final AddOrderViewModel model;
  const OrderTypeAndDeliveryDateRow({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded(
        //   flex: 1,
        //   child: CustomDropdownButton2(
        //     items: model.orderTypes,
        //     hintText: 'order type',
        //     onChanged: model.setOrderType,
        //     labelText: 'Order Type',
        //     value: model.orderData.orderType,
        //   ),
        // ),
        // const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: TextFormField(
            readOnly: true,
            controller: model.deliveryDateController,
            onTap: () => model.selectDeliveryDate(context),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              labelText: 'Delivery date',
              hintText: 'Delivery Date',
              prefixIcon: const Icon(Icons.calendar_today_rounded),
              labelStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              hintStyle: const TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.blue, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey, width: 2)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.black45, width: 2)),
            ),
            validator: model.validateDeliveryDate,
          ),
        ),
      ],
    );
  }
}

class WarehouseDropdown extends StatelessWidget {
  final AddOrderViewModel model;
  const WarehouseDropdown({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdownButton2(
      prefixIcon: Icons.warehouse_outlined,
      items: model.warehouses,
      hintText: 'select the distributor',
      onChanged: model.setWarehouse,
      labelText: 'Set Distributor',
      value: model.orderData.setWarehouse,
    );
  }
}

class ItemsSelector extends StatelessWidget {
  final AddOrderViewModel model;
  const ItemsSelector({required this.model, super.key});

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(msg,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      key: Key(model.displayString),
      initialValue: model.displayString,
      onTap: () async {
        if (model.orderData.customer == null ||
            model.orderData.setWarehouse == null) {
          _showSnackBar(context, "Please select the customer and warehouse");
          return;
        }

        final selectedItems = await Navigator.pushNamed(
          context,
          Routes.itemScreen,
          arguments: ItemScreenArguments(
            warehouse: model.orderData.setWarehouse ?? "",
            items: model.items,
            selectedItems: model.selectedItems,
          ),
        ) as List<Items>?;

        if (selectedItems != null) {
          model.setSelectedItems(selectedItems);
        }
      },
      decoration: InputDecoration(
        labelText: 'Items',
        hintText: 'Click here to select items',
        prefixIcon: const Icon(Icons.shopping_basket),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        labelStyle: const TextStyle(
            color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

// ─── Selected Item List ────────────────────────────────────────────────────────

class SelectedItemList extends StatefulWidget {
  final AddOrderViewModel model;
  const SelectedItemList({required this.model, super.key});

  @override
  State<SelectedItemList> createState() => _SelectedItemListState();
}

class _SelectedItemListState extends State<SelectedItemList> {
  Future<bool> _confirmDelete() async {
    if (!mounted) return false;
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Remove item?"),
        content: const Text(
            "Are you sure you want to remove this item from the order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(
              "Remove",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;

    if (model.selectedItems.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.inbox_outlined, size: 36, color: Colors.black26),
              SizedBox(height: 8),
              Text(
                "No items selected",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: model.selectedItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final selectedItem = model.selectedItems[index];
        return Dismissible(
          key: Key(selectedItem.itemCode.toString()),
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade200),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red.shade400,
              size: 28,
            ),
          ),
          direction: DismissDirection.startToEnd,
          confirmDismiss: (_) => _confirmDelete(),
          onDismissed: (_) => model.deleteItem(index),
          child: SelectedItemCard(
            item: selectedItem,
            model: model,
            index: index,
          ),
        );
      },
    );
  }
}

// ─── Selected Item Card ────────────────────────────────────────────────────────

class SelectedItemCard extends StatelessWidget {
  final Items item;
  final AddOrderViewModel model;
  final int index;

  const SelectedItemCard({
    required this.item,
    required this.model,
    required this.index,
    super.key,
  });

  Widget _inputBox(
      TextEditingController controller, {
        required Function(String) onChanged,
        double width = 70,
        String? suffix,
      }) {
    return SizedBox(
      width: width,
      height: 36,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 9),
          filled: true,
          fillColor: Colors.white,
          suffixText: suffix,
          suffixStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qtyController      = model.getQuantityController(index);
    final discountController = model.getDiscountController(index);

    final deliveredQty = (item.deliveredQty ?? 0).toDouble();
    final orderedQty   = (item.qty ?? 0).toDouble();
    final pendingQty   =
    (orderedQty - deliveredQty).clamp(0, double.infinity).toDouble();
    final rate         = (item.rate ?? 0).toDouble();
    final discountAmt  =
    ((item.discountAmount ?? 0) + (item.distributedDiscountAmount ?? 0))
        .toDouble();
    final total = item.netAmount ?? item.amount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // ── Main body ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: '$baseurl${item.image}',
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 58,
                      height: 58,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 58,
                      height: 58,
                      color: Colors.grey.shade100,
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.black26,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + rate chip
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.itemName ?? "N/A",
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(999),
                              border:
                              Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              "₹${rate.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Qty + Discount inputs
                      Row(
                        children: [
                          Text(
                            "Qty",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _inputBox(
                            qtyController,
                            width: 70,
                            onChanged: (v) {
                              final parsed = int.tryParse(v);
                              if (parsed != null) {
                                model.setItemQuantity(index, parsed);
                              }
                            },
                          ),
                          const SizedBox(width: 14),
                          Text(
                            "Disc %",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _inputBox(
                            discountController,
                            width: 80,
                            suffix: "%",
                            onChanged: (v) {
                              final parsed = double.tryParse(v);
                              if (parsed != null) {
                                model.setItemDiscount(index, parsed);
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Net + Discount amount
                      Row(
                        children: [
                          _ValueChip(
                            label: "Net",
                            value: "₹${total?.toStringAsFixed(2) ?? '0.00'}",
                            color: Colors.blueAccent,
                            bg: Colors.blue.shade50,
                            border: Colors.blue.shade100,
                          ),
                          const SizedBox(width: 8),
                          _ValueChip(
                            label: "Disc",
                            value: "₹${discountAmt.toStringAsFixed(2)}",
                            color: Colors.red.shade600,
                            bg: Colors.red.shade50,
                            border: Colors.red.shade100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ──
          Divider(height: 1, color: Colors.grey.shade100),

          // ── Status strip ──
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.local_shipping_outlined,
                    size: 14, color: Colors.green),
                const SizedBox(width: 5),
                Text(
                  "Delivered: ${deliveredQty.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.pending_outlined,
                    size: 14, color: Colors.orange),
                const SizedBox(width: 5),
                Text(
                  "Pending: ${pendingQty.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bg;
  final Color border;

  const _ValueChip({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Billing Section ───────────────────────────────────────────────────────────

class BillingSection extends StatelessWidget {
  final AddOrderViewModel model;
  const BillingSection({required this.model, super.key});

  String _money(num? v) => (v ?? 0).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: const [
              Icon(Icons.receipt_long_outlined,
                  size: 18, color: Colors.black54),
              SizedBox(width: 8),
              Text(
                "Tax & Discount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 14),

          _BillingRow(
            label: "Subtotal",
            value: "₹${_money(model.orderData.netTotal)}",
          ),
          const SizedBox(height: 10),
          _BillingRow(
            label: "Total Tax",
            value: "₹${_money(model.orderData.totalTaxesAndCharges)}",
          ),
          const SizedBox(height: 10),

          // Order discount input
          Row(
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.discount_outlined,
                        size: 15, color: Colors.black45),
                    SizedBox(width: 6),
                    Text(
                      "Order Disc %",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 90,
                height: 36,
                child: TextField(
                  controller: model.orderDiscountController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 9),
                    filled: true,
                    fillColor: Colors.white,
                    suffixText: "%",
                    suffixStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  onChanged: (v) {
                    final parsed = double.tryParse(v);
                    if (parsed != null) {
                      model.setOrderDiscountPercent(parsed);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          _BillingRow(
            label: "Discount",
            value: "- ₹${_money(model.orderData.discountAmount)}",
            valueColor: Colors.red.shade600,
          ),

          const SizedBox(height: 14),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 14),

          _BillingRow(
            label: "Grand Total",
            value: "₹${_money(model.orderData.grandTotal)}",
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _BillingRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  const _BillingRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 14,
              fontWeight:
              isTotal ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 17 : 14,
            fontWeight: FontWeight.w700,
            color: valueColor ??
                (isTotal ? Colors.black87 : Colors.black54),
          ),
        ),
      ],
    );
  }
}

// ─── Action Buttons ────────────────────────────────────────────────────────────

class ActionButtons extends StatelessWidget {
  final AddOrderViewModel model;
  const ActionButtons({required this.model, super.key});

  Future<void> _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueAccent,
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = model.orderData;
    final canShow = (order.docstatus == 0 || order.docstatus == null) &&
        !(model.isSame &&
            model.role?.toLowerCase() == "distributor");

    if (!canShow) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(
          model.isEdit
              ? Icons.save_outlined
              : Icons.add_shopping_cart_rounded,
          size: 18,
          color: Colors.white,
        ),
        label: Text(
          model.isEdit ? "Update Order" : "Create Order",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        onPressed: () => model.onSavePressed(context),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}