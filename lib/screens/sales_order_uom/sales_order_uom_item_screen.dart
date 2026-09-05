import 'package:flutter/material.dart';

import 'sales_order_uom_model.dart';

class SalesOrderUomItemScreen extends StatefulWidget {
  final List<UomItem> items;
  final List<UomOrderItem> selectedItems;

  const SalesOrderUomItemScreen({
    super.key,
    required this.items,
    required this.selectedItems,
  });

  @override
  State<SalesOrderUomItemScreen> createState() =>
      _SalesOrderUomItemScreenState();
}

class _SalesOrderUomItemScreenState
    extends State<SalesOrderUomItemScreen> {
  final TextEditingController _searchController = TextEditingController();

  late List<UomItem> _filteredItems;

  /// Keeps the selected order items.
  final List<UomOrderItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();

    _filteredItems = List<UomItem>.from(widget.items);

    // Restore already selected items when coming back to this screen.
    _selectedItems.addAll(widget.selectedItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _searchItems(String value) {
    final query = value.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredItems = List<UomItem>.from(widget.items);
      } else {
        _filteredItems = widget.items.where((item) {
          final itemName =
          (item.itemName ?? '').toLowerCase();

          final itemCode =
          (item.itemCode ?? '').toLowerCase();

          return itemName.contains(query) ||
              itemCode.contains(query);
        }).toList();
      }
    });
  }

  // ============================================================
  // CHECK SELECTED
  // ============================================================

  bool _isSelected(UomItem item) {
    return _selectedItems.any(
          (orderItem) =>
      orderItem.item.itemCode == item.itemCode,
    );
  }

  UomOrderItem? _getSelectedOrderItem(UomItem item) {
    for (final orderItem in _selectedItems) {
      if (orderItem.item.itemCode == item.itemCode) {
        return orderItem;
      }
    }

    return null;
  }

  // ============================================================
  // SELECT / REMOVE ITEM
  // ============================================================

  void _toggleItem(UomItem item) {
    setState(() {
      final existing = _getSelectedOrderItem(item);

      if (existing != null) {
        _selectedItems.remove(existing);
        return;
      }

      // Select first available UOM by default.
      UomOption? defaultUom;

      if (item.uoms.isNotEmpty) {
        defaultUom = item.uoms.first;
      }

      _selectedItems.add(
        UomOrderItem(
          item: item,
          selectedUom: defaultUom,
          quantity: 1,
        ),
      );
    });
  }

  // ============================================================
  // CHANGE UOM
  // ============================================================

  void _changeUom(
      UomItem item,
      String? uomName,
      ) {
    if (uomName == null) return;

    final index = _selectedItems.indexWhere(
          (orderItem) =>
      orderItem.item.itemCode == item.itemCode,
    );

    if (index == -1) return;

    UomOption? selectedUom;

    for (final uom in item.uoms) {
      if (uom.uom == uomName) {
        selectedUom = uom;
        break;
      }
    }

    if (selectedUom == null) return;

    setState(() {
      _selectedItems[index] = UomOrderItem(
        item: _selectedItems[index].item,
        selectedUom: selectedUom,
        quantity: _selectedItems[index].quantity,
      );
    });
  }

  // ============================================================
  // CHANGE QUANTITY
  // ============================================================

  void _changeQuantity(
      UomItem item,
      String value,
      ) {
    final quantity = double.tryParse(value);

    if (quantity == null || quantity <= 0) {
      return;
    }

    final index = _selectedItems.indexWhere(
          (orderItem) =>
      orderItem.item.itemCode == item.itemCode,
    );

    if (index == -1) return;

    setState(() {
      _selectedItems[index] = UomOrderItem(
        item: _selectedItems[index].item,
        selectedUom: _selectedItems[index].selectedUom,
        quantity: quantity,
      );
    });
  }

  // ============================================================
  // DONE
  // ============================================================

  void _done() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one item.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    Navigator.pop(
      context,
      List<UomOrderItem>.from(_selectedItems),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Select Items',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_selectedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_selectedItems.length} Selected',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      body: Column(
        children: [
          // ======================================================
          // SEARCH
          // ======================================================

          Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12,
            ),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _searchItems,
              decoration: InputDecoration(
                hintText: 'Search item or item code',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                ),
                suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _searchItems('');
                  },
                )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF5F6F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          // ======================================================
          // SELECTED SUMMARY
          // ======================================================

          if (_selectedItems.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              color: theme.colorScheme.primary
                  .withOpacity(0.05),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedItems.length} item${_selectedItems.length == 1 ? '' : 's'} selected',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

          // ======================================================
          // ITEM LIST
          // ======================================================

          Expanded(
            child: _filteredItems.isEmpty
                ? _EmptyState(
              searchText: _searchController.text,
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                14,
                16,
                110,
              ),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];

                return _UomItemCard(
                  key: ValueKey(item.itemCode),
                  item: item,
                  isSelected: _isSelected(item),
                  selectedOrderItem:
                  _getSelectedOrderItem(item),
                  onToggle: () {
                    _toggleItem(item);
                  },
                  onUomChanged: (value) {
                    _changeUom(item, value);
                  },
                  onQuantityChanged: (value) {
                    _changeQuantity(item, value);
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ==========================================================
      // BOTTOM DONE BUTTON
      // ==========================================================

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed:
              _selectedItems.isEmpty ? null : _done,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_rounded),
                  const SizedBox(width: 8),
                  Text(
                    _selectedItems.isEmpty
                        ? 'Select Items'
                        : 'Done • ${_selectedItems.length} Item${_selectedItems.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =================================================================
// ITEM CARD
// =================================================================

class _UomItemCard extends StatelessWidget {
  final UomItem item;
  final bool isSelected;
  final UomOrderItem? selectedOrderItem;

  final VoidCallback onToggle;
  final ValueChanged<String?> onUomChanged;
  final ValueChanged<String> onQuantityChanged;

  const _UomItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.selectedOrderItem,
    required this.onToggle,
    required this.onUomChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : const Color(0xFFE4E7EC),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isSelected ? 0.06 : 0.03,
            ),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withOpacity(0.10)
                        : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey.shade600,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    item.itemName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: onToggle,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => onToggle(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),

            if (isSelected) ...[
              const SizedBox(height: 6),
              const Divider(height: 1),
              const SizedBox(height: 6),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _FieldContainer(
                      label: 'UOM',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedOrderItem?.selectedUom?.uom,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                          ),
                          hint: const Text(
                            'Select UOM',
                            style: TextStyle(fontSize: 12),
                          ),
                          items: item.uoms
                              .map(
                                (uom) => DropdownMenuItem<String>(
                              value: uom.uom,
                              child: Text(
                                uom.uom,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                              .toList(),
                          onChanged: item.uoms.isEmpty
                              ? null
                              : onUomChanged,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    flex: 2,
                    child: _FieldContainer(
                      label: 'QTY',
                      child: TextFormField(
                        initialValue:
                        selectedOrderItem?.quantity.toString() ?? '1',
                        keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: onQuantityChanged,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'Qty',
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =================================================================
// FIELD CONTAINER
// =================================================================

class _FieldContainer extends StatelessWidget {
  final String label;
  final Widget child;

  const _FieldContainer({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        9,
        4,
        7,
        5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE2E5EA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 1),
          SizedBox(
            height: 24,
            child: child,
          ),
        ],
      ),
    );
  }
}

// =================================================================
// EMPTY STATE
// =================================================================

class _EmptyState extends StatelessWidget {
  final String searchText;

  const _EmptyState({
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                searchText.isEmpty
                    ? Icons.inventory_2_outlined
                    : Icons.search_off_rounded,
                size: 38,
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              searchText.isEmpty
                  ? 'No Items Available'
                  : 'No Items Found',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              searchText.isEmpty
                  ? 'There are no items available for this order.'
                  : 'Try searching with a different item name or code.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}