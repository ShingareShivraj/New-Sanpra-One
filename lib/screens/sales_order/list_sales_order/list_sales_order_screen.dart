import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/model/order_list_model.dart';
import 'package:geolocation/widgets/full_screen_loader.dart';
import 'package:stacked/stacked.dart';
import '../../sales_order_uom/sales_order_uom_screen.dart';
import '../../../router.router.dart';
import 'list_salesorder_viewmodel.dart';

class ListOrderScreen extends StatelessWidget {
  const ListOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListOrderModel>.reactive(
      viewModelBuilder: () => ListOrderModel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Sales Order'),
        ),
        body: fullScreenLoader(
          context: context,
          loader: model.isBusy,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ------------------------
                // Filters Row
                // ------------------------
                Column(
                  children: [
                    Row(
                      children: [
                        // ── Search field ──
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFDBEAFE)),
                            ),
                            child: TextField(
                              controller: model.customerController,
                              onChanged: model.setCustomer,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1E3A8A),
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Search customer",
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  size: 18,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // ── Status dropdown ──
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFDBEAFE)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: model.selectedStatus,
                                hint: const Text(
                                  "Status",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                items: model.statusList
                                    .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s,style: TextStyle(color: Colors.black),),
                                ))
                                    .toList(),
                                onChanged: (v) {
                                  model.setStatus(v);
                                  model.applyFilters();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // ── Clear filters ──
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: model.clearFilter,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.close_rounded,
                                size: 13,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Clear filters",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // ------------------------
                // Order List
                // ------------------------
                Expanded(
                  child: model.filteredOrderList.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () => model.refresh(),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: model.filteredOrderList.length,
                            itemBuilder: (context, index) {
                              final order = model.filteredOrderList[index];
                              model.getOrderDisplayStatus(
                                  order.status, order.deliveryStatus);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _OrderCard(
                                  order: order,
                                  model: model,
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.pushNamed(
              context,
              Routes.addOrderScreen,
              arguments: const AddOrderScreenArguments(
                orderid: "",
              ),
            );

            if (result == true) {
              await model.refresh();
            }
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text("Create Sales Order"),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'No orders found!',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderList order;
  final ListOrderModel model;

  const _OrderCard({required this.order, required this.model});

  Color _statusColor(String status) {
    switch (status) {
      case "Pending":             return const Color(0xFFD97706);
      case "Accepted":            return const Color(0xFF2563EB);
      case "Partially Delivered": return const Color(0xFF0F766E);
      case "Fully Delivered":     return const Color(0xFF059669);
      case "Cancelled":           return const Color(0xFFDC2626);
      case "Closed":              return const Color(0xFF64748B);
      default:                    return const Color(0xFF64748B);
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case "Pending":             return const Color(0xFFFEF3C7);
      case "Accepted":            return const Color(0xFFEFF6FF);
      case "Partially Delivered": return const Color(0xFFCCFBF1);
      case "Fully Delivered":     return const Color(0xFFD1FAE5);
      case "Cancelled":           return const Color(0xFFFEE2E2);
      case "Closed":              return const Color(0xFFF1F5F9);
      default:                    return const Color(0xFFF1F5F9);
    }
  }

  Color _statusBorder(String status) {
    switch (status) {
      case "Pending":             return const Color(0xFFFCD34D);
      case "Accepted":            return const Color(0xFFBFDBFE);
      case "Partially Delivered": return const Color(0xFF5EEAD4);
      case "Fully Delivered":     return const Color(0xFF86EFAC);
      case "Cancelled":           return const Color(0xFFFCA5A5);
      case "Closed":              return const Color(0xFFCBD5E1);
      default:                    return const Color(0xFFCBD5E1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusText  = model.getOrderDisplayStatus(order.status, order.deliveryStatus);
    final dotColor    = _statusColor(statusText);
    final pillBg      = _statusBg(statusText);
    final pillBorder  = _statusBorder(statusText);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => model.onRowClick(context, order),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Top: name + status ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName ?? "Unknown Customer",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: Color(0xFF1E3A8A),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 12, color: Color(0xFF93C5FD)),
                            const SizedBox(width: 4),
                            Text(
                              order.transactionDate ?? "No date",
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF93C5FD),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.local_shipping_outlined,
                                size: 12, color: Color(0xFF93C5FD)),
                            const SizedBox(width: 4),
                            Text(
                              order.deliveryDate ?? "N/A",
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF93C5FD),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: pillBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: pillBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: dotColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ── Warehouse ──
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.warehouse_outlined,
                        size: 13, color: Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      order.warehouse ?? "—",
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A8A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(color: Color(0xFFEFF6FF), height: 1),
              const SizedBox(height: 10),

              // ── Info row ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _InfoBlock(
                      label: "Order ID",
                      value: order.name ?? "N/A",
                      breakLong: true,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: const Color(0xFFDBEAFE),
                  ),
                  Expanded(
                    flex: 1,
                    child: _InfoBlock(
                      label: "Items",
                      value: "${order.totalQty ?? 0}",
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: const Color(0xFFDBEAFE),
                  ),
                  Expanded(
                    flex: 2,
                    child: _InfoBlock(
                      label: "Amount",
                      value: "₹${(order.grandTotal ?? 0).toStringAsFixed(0)}",
                      valueColor: const Color(0xFF059669),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ── Owner ──
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded,
                      size: 13, color: Color(0xFF93C5FD)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      order.owner ?? "N/A",
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF93C5FD),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Info Block ────────────────────────────────────────────────────────────────

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool breakLong;

  const _InfoBlock({
    required this.label,
    required this.value,
    this.valueColor,
    this.breakLong = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue =
    breakLong ? value.split('').join('\u200B') : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF93C5FD),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        AutoSizeText(
          displayValue,
          maxLines: 2,
          minFontSize: 10,
          stepGranularity: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? const Color(0xFF1E3A8A),
          ),
        ),
      ],
    );
  }
}
