import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

import '../../../router.router.dart';
import '../../../widgets/drop_down.dart';
import '../../../widgets/full_screen_loader.dart';
import '../../../widgets/text_button.dart';
import 'list_quotation_model.dart';
class ListQuotationScreen extends StatelessWidget {
  const ListQuotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ViewModelBuilder<ListQuotationModel>.reactive(
      viewModelBuilder: () => ListQuotationModel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLowest,

        /// APPBAR
        appBar: AppBar(
          title: const Text("Quotations"),
          centerTitle: true,

        ),

        /// BODY
        body: fullScreenLoader(
          context: context,
          loader: model.isBusy,
          child: Column(
            children: [

              /// SEARCH BAR
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: TextField(
                    onChanged: model.searchPartyName,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: "Search quotation / customer",
                      prefixIcon: Icon(Icons.search_rounded, size: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              /// LIST
              Expanded(
                child: model.filterquotationlist.isNotEmpty
                    ? RefreshIndicator(
                  onRefresh: () => model.refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: model.filterquotationlist.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),

                    itemBuilder: (context, index) {
                      final item = model.filterquotationlist[index];

                      return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => model.onRowClick(context, item),

                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// 🔝 HEADER (Customer + Status)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    /// 👤 CUSTOMER NAME + ID
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.customerName ?? "Unknown Customer",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.name ?? "",
                                            style: const TextStyle(
                                              fontSize: 11.5,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// STATUS
                                    _statusDotPill(
                                      item.status ?? "",
                                      model.getColorForStatus(item.status ?? ""),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// 🧾 TYPE + DATE ROW
                                Row(
                                  children: [

                                    /// TYPE
                                    _softTag(
                                      item.quotationTo ?? "",
                                      model.getQuotationForStatus(item.quotationTo ?? ""),
                                    ),

                                    const SizedBox(width: 10),

                                    /// DATE
                                    Row(
                                      children: [
                                        const Icon(Icons.schedule, size: 12, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.transactionDate ?? "",
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                /// 💰 AMOUNT (highlighted)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.currency_rupee, size: 16, color: Color(0xFF059669)),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${item.grandTotal ?? 0}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF059669),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${item.totalQty ?? 0} items",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 12),

                                /// ⚡ ACTION ROW
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    /// LEFT SIDE INFO
                                    Row(
                                      children: [
                                        const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.customerName ?? "",
                                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                                        ),
                                      ],
                                    ),

                                    /// RIGHT ACTIONS
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.share_outlined, size: 20),
                                          onPressed: () => model.shareQuotation(item),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEEF2FF),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                                            onPressed: () => model.onRowClick(context, item),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                      );
                    },
                  ),
                )
                    : const _EmptyState(),
              ),
            ],
          ),
        ),

        /// CREATE BUTTON
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("New Quote"),
          onPressed: () {
            Navigator.pushNamed(
              context,
              Routes.addQuotationView,
              arguments: const AddQuotationViewArguments(quotationid: ""),
            );
          },
        ),
      ),
    );
  }

  Widget _statusDotPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _softTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _pill({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _infoBlock(String label, String? value, {Color? color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value ?? "",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color ?? const Color(0xFF1E3A8A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFFDBEAFE),
    );
  }

  /// SMALL INFO TILE
  Widget _infoTile(String label, String? value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        Text(
          value ?? "",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.description_outlined,
              size: 60, color: Colors.grey.shade500),
          const SizedBox(height: 10),
          const Text(
            "No Quotations Found",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}