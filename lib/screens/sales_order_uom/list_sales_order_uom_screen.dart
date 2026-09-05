import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/model/order_list_model.dart';
import 'package:geolocation/screens/sales_order_uom/sales_order_uom_screen.dart';
import 'package:geolocation/widgets/full_screen_loader.dart';
import 'package:stacked/stacked.dart';

import 'list_sales_order_uom_viewmodel.dart';

class ListSalesOrderUomScreen extends StatelessWidget {
  const ListSalesOrderUomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListSalesOrderUomModel>.reactive(
      viewModelBuilder: () => ListSalesOrderUomModel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: const Text('Sales Order'),
        ),
        body: fullScreenLoader(
          context: context,
          loader: model.isBusy,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFDBEAFE),
                          ),
                        ),
                        child: TextField(
                          controller: model.customerController,
                          onChanged: model.setCustomer,
                          decoration: const InputDecoration(
                            hintText: 'Search customer',
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 19,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // STATUS FILTER
                    Expanded(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFDBEAFE),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: model.selectedStatus,
                            isExpanded: true,
                            hint: const Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 19,
                            ),
                            items: model.statusList.map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(
                                  status,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF334155),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: model.setStatus,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // CLEAR FILTER
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFDBEAFE),
                        ),
                      ),
                      child: IconButton(
                        tooltip: 'Clear filters',
                        onPressed: model.clearFilter,
                        icon: const Icon(
                          Icons.filter_alt_off_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: model.filteredOrderList.isEmpty
                      ? _emptyState()
                      : RefreshIndicator(
                          onRefresh: model.refresh,
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: model.filteredOrderList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              return _UomOrderCard(
                                order: model.filteredOrderList[index],
                                model: model,
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
          heroTag: "create_Sales_order",
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SalesOrderUomScreen(),
              ),
            );

            if (result == true) {
              await model.refresh();
            }
          },
          icon: const Icon(Icons.straighten),
          label: const Text("Create Sales Order"),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 44,
              color: Color(0xFF93C5FD),
            ),
            SizedBox(height: 10),
            Text(
              'No sales orders found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UomOrderCard extends StatelessWidget {
  final OrderList order;
  final ListSalesOrderUomModel model;

  const _UomOrderCard({
    required this.order,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final status = model.getOrderDisplayStatus(
      order.status,
      order.deliveryStatus,
    );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => model.openOrderDetails(context, order),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.customerName ?? 'Unknown Customer',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusPill(status: status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 13,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    order.transactionDate ?? 'No date',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.local_shipping_outlined,
                    size: 13,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    order.deliveryDate ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFEFF6FF)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _Info(
                      label: 'Order ID',
                      value: order.name ?? 'N/A',
                      breakLong: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Info(
                      label: 'Items',
                      value: '${order.totalQty ?? 0}',
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

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color background;

    switch (status) {
      case 'Pending':
        color = const Color(0xFFD97706);
        background = const Color(0xFFFEF3C7);
        break;
      case 'Accepted':
        color = const Color(0xFF2563EB);
        background = const Color(0xFFEFF6FF);
        break;
      case 'Fully Delivered':
        color = const Color(0xFF059669);
        background = const Color(0xFFD1FAE5);
        break;
      case 'Cancelled':
        color = const Color(0xFFDC2626);
        background = const Color(0xFFFEE2E2);
        break;
      default:
        color = const Color(0xFF64748B);
        background = const Color(0xFFF1F5F9);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;
  final bool breakLong;

  const _Info({
    required this.label,
    required this.value,
    this.breakLong = false,
  });

  @override
  Widget build(BuildContext context) {
    final display = breakLong ? value.split('').join('\u200B') : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        AutoSizeText(
          display,
          maxLines: 2,
          minFontSize: 10,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E3A8A),
          ),
        ),
      ],
    );
  }
}
