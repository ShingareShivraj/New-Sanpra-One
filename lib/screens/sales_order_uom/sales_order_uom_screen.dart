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
  const SalesOrderUomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesOrderUomViewModel>.reactive(
      viewModelBuilder: () => SalesOrderUomViewModel(),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text(
              "Sales Order",
              style: TextStyle(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _HeaderCard(model: model),
                    const SizedBox(height: 16),
                    _ItemsSection(model: model),
                    const SizedBox(height: 24),
                    _CreateButton(model: model),
                    const SizedBox(height: 20),
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

class _HeaderCard extends StatelessWidget {
  final SalesOrderUomViewModel model;

  const _HeaderCard({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [

          _DropdownField(
            label: "Customer",
            icon: Icons.person_outline,
            value: model.selectedCustomer,
            items: model.customers,
            hint: "Select customer",
            onChanged: model.setCustomer,
          ),

          const SizedBox(height: 15),

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

        const SizedBox(height: 12),

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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ItemImage(item: item),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.itemCode,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () => model.removeItem(index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
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

              const SizedBox(width: 10),

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
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    prefixIcon: const Icon(
                      Icons.numbers_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (orderItem.selectedUom != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "1 ${orderItem.selectedUom!.uom} = "
                    "${orderItem.selectedUom!.conversionFactor}"
                    " ${item.stockUom}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
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

  const _ItemImage({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    if (item.image == null || item.image!.isEmpty) {
      return Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.inventory_2_outlined,
          color: Colors.black26,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: '$baseurl${item.image}',
        width: 55,
        height: 55,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) {
          return Container(
            width: 55,
            height: 55,
            color: Colors.grey.shade100,
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Colors.black26,
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
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
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

class _CreateButton extends StatelessWidget {
  final SalesOrderUomViewModel model;

  const _CreateButton({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
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
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}