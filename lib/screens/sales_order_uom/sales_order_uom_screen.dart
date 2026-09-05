import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/screens/sales_order_uom/sales_order_uom_item_screen.dart';
import 'package:geolocation/widgets/full_screen_loader.dart';
import 'package:stacked/stacked.dart';

import '../../../constants.dart';
import 'sales_order_uom_model.dart';
import 'sales_order_uom_viewmodel.dart';
import 'sales_order_uom_item_screen.dart';
class SalesOrderUomScreen extends StatelessWidget {
  final String? orderId;

  const SalesOrderUomScreen({
    super.key,
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesOrderUomViewModel>.reactive(
      viewModelBuilder: () => SalesOrderUomViewModel(),
      onViewModelReady: (model) => model.initialise(
        orderId: orderId,
      ),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: Text(
              orderId == null
                  ? "Create Sales Order"
                  : "Update Sales Order",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: fullScreenLoader(
            loader: model.isBusy,
            context: context,
            child: Form(
              key: model.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  children: [
                    _HeaderCard(model: model),
                    const SizedBox(height: 10),
                    _ItemsSection(model: model),

                    const SizedBox(height: 10),

                    _DescriptionCard(model: model),
                    const SizedBox(height: 12),
                    orderId == null
                        ? _CreateButton(model: model)
                        : _UpdateButton(model: model),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// HEADER
// -----------------------------------------------------------------------------


class _SearchableCustomerField extends StatelessWidget {
  final String? value;
  final List<String> customers;
  final ValueChanged<String?> onChanged;

  const _SearchableCustomerField({
    required this.value,
    required this.customers,
    required this.onChanged,
  });

  Future<void> _showCustomerPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CustomerSearchSheet(
          customers: customers,
          selectedCustomer: value,
        );
      },
    );

    if (selected != null) {
      onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCustomerPicker(context),
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Customer",
          prefixIcon: const Icon(Icons.person_outline),
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          value?.isNotEmpty == true ? value! : "Select customer",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            fontWeight:
            value?.isNotEmpty == true
                ? FontWeight.w500
                : FontWeight.w400,
            color: value?.isNotEmpty == true
                ? Colors.black87
                : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _CustomerSearchSheet extends StatefulWidget {
  final List<String> customers;
  final String? selectedCustomer;

  const _CustomerSearchSheet({
    required this.customers,
    required this.selectedCustomer,
  });

  @override
  State<_CustomerSearchSheet> createState() =>
      _CustomerSearchSheetState();
}

class _CustomerSearchSheetState extends State<_CustomerSearchSheet> {
  late List<String> filteredCustomers;
  final TextEditingController searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCustomers = List<String>.from(widget.customers);
    searchController.addListener(_filterCustomers);
  }

  void _filterCustomers() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredCustomers = List<String>.from(widget.customers);
      } else {
        filteredCustomers = widget.customers
            .where(
              (customer) =>
              customer.toLowerCase().contains(query),
        )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController
      ..removeListener(_filterCustomers)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: bottomInset,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Color(0xFFD0D5DD),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  14,
                  16,
                  10,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Select Customer",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Search customer...",
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      onPressed: searchController.clear,
                      icon: const Icon(
                        Icons.clear_rounded,
                      ),
                    )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF8F9FB),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: filteredCustomers.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_search_outlined,
                        size: 42,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "No customer found",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.separated(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    4,
                    16,
                    16,
                  ),
                  itemCount: filteredCustomers.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final customer =
                    filteredCustomers[index];
                    final isSelected =
                        customer == widget.selectedCustomer;

                    return Material(
                      color: isSelected
                          ? Colors.blueAccent.withOpacity(0.07)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () =>
                            Navigator.pop(context, customer),
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 11,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blueAccent
                                      .withOpacity(0.10)
                                      : const Color(
                                    0xFFF2F4F7,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  size: 20,
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  customer,
                                  maxLines: 2,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.blueAccent,
                                  size: 21,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final SalesOrderUomViewModel model;

  const _HeaderCard({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [

          _SearchableCustomerField(
            value: model.selectedCustomer,
            customers: model.customers,
            onChanged: model.setCustomer,
          ),

          const SizedBox(height: 10),

          InkWell(
            onTap: () => model.selectDate(context),
            borderRadius: BorderRadius.circular(14),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Date",
                prefixIcon: const Icon(
                  Icons.calendar_today_outlined,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                model.formattedDate,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _DescriptionCard extends StatelessWidget {
  final SalesOrderUomViewModel model;

  const _DescriptionCard({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(Optional)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: model.termsController,
            minLines: 2,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: 'Add any important note for this order...',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ITEMS
// -----------------------------------------------------------------------------

class _ItemsSection extends StatelessWidget {
  final SalesOrderUomViewModel model;

  const _ItemsSection({
    required this.model,
  });

  Future<void> _showItemSelector(BuildContext context) async {
    final availableItems = model.items
        .where(
          (item) => !model.selectedItems.any(
            (selected) =>
        selected.item.itemCode == item.itemCode,
      ),
    )
        .toList();

    if (availableItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All available items are already selected"),
        ),
      );
      return;
    }

    final result = await Navigator.push<List<UomOrderItem>>(
      context,
      MaterialPageRoute(
        builder: (_) => SalesOrderUomItemScreen(
          items: availableItems,
          selectedItems: model.selectedItems,
        ),
      ),
    );

    if (result != null) {
      model.setSelectedItems(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "Items",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showItemSelector(context),
              icon: const Icon(
                Icons.add,
                size: 18,
              ),
              label: const Text("Add Item"),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (model.selectedItems.isEmpty)
          _EmptyItems()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: model.selectedItems.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _UomItemCard(
                model: model,
                index: index,
                orderItem: model.selectedItems[index],
              );
            },
          ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// ITEM CARD
// -----------------------------------------------------------------------------

class _UomItemCard extends StatelessWidget {
  final SalesOrderUomViewModel model;
  final int index;
  final UomOrderItem orderItem;

  const _UomItemCard({
    required this.model,
    required this.index,
    required this.orderItem,
  });

  @override
  Widget build(BuildContext context) {
    final item = orderItem.item;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Keep the product image, but make it compact.
              _ItemImage(item: item, size: 42),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  item.itemName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Delete icon retained because it is the action to remove
              // a selected item; no extra decorative icon is used.
              IconButton(
                onPressed: () => model.removeItem(index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 34,
                  minHeight: 34,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: _DropdownField(
                  label: "UOM",
                  icon: Icons.straighten_outlined,
                  value: orderItem.selectedUom?.uom,
                  items: item.uoms
                      .map((uom) => uom.uom)
                      .toList(),
                  hint: "Select UOM",
                  onChanged: (value) {
                    final selected = item.uoms.firstWhere(
                          (uom) => uom.uom == value,
                    );

                    model.setUom(index, selected);
                  },
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue:
                  orderItem.quantity.toStringAsFixed(0),
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (value) {
                    model.setQuantity(index, value);
                  },
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    labelText: "QTY",
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ITEM IMAGE
// -----------------------------------------------------------------------------

class _ItemImage extends StatelessWidget {
  final UomItem item;
  final double size;

  const _ItemImage({
    required this.item,
    this.size = 55,
  });

  @override
  Widget build(BuildContext context) {
    if (item.image == null || item.image!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.inventory_2_outlined,
          color: Colors.black26,
          size: 22,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: '$baseurl${item.image}',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey.shade100,
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Colors.black26,
              size: 22,
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ITEM PICKER
// -----------------------------------------------------------------------------

// class _ItemPicker extends StatelessWidget {
//   final List<UomItem> items;
//
//   const _ItemPicker({
//     required this.items,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height * 0.75,
//         child: Column(
//           children: [
//             const SizedBox(height: 12),
//
//             Container(
//               width: 45,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             const Text(
//               "Select Item",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: items.length,
//                 separatorBuilder: (_, __) =>
//                 const SizedBox(height: 8),
//                 itemBuilder: (context, index) {
//                   final item = items[index];
//
//                   return ListTile(
//                     onTap: () => Navigator.pop(
//                       context,
//                       item,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     tileColor: Colors.grey.shade50,
//                     leading: _ItemImage(item: item),
//                     title: Text(
//                       item.itemName,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: Text(item.itemCode),
//                     trailing: const Icon(
//                       Icons.arrow_forward_ios,
//                       size: 16,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// -----------------------------------------------------------------------------
// DROPDOWN
// -----------------------------------------------------------------------------

class _DropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : null,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          size: 20,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      hint: Text(hint),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}

// -----------------------------------------------------------------------------
// EMPTY
// -----------------------------------------------------------------------------

class _EmptyItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 45,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          Text(
            "No items added",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tap Add Item to add products",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CREATE BUTTON
// -----------------------------------------------------------------------------
class _UpdateButton extends StatelessWidget {
  final SalesOrderUomViewModel model;

  const _UpdateButton({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: model.isBusy
            ? null
            : () => model.updateOrder(context),
        icon: const Icon(
          Icons.check_rounded,
          color: Colors.white,
        ),
        label: const Text(
          "Update Order",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
class _CreateButton extends StatelessWidget {
  final SalesOrderUomViewModel model;

  const _CreateButton({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: model.isBusy
            ? null
            : () => model.createOrder(context),
        icon: const Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
        label: const Text(
          "Create Order",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}