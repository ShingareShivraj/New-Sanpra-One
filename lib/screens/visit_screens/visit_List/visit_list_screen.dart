import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../model/add_visit_model.dart';
import '../../../router.router.dart';
import '../../../widgets/full_screen_loader.dart';
import 'visit_list_model.dart';

class VisitScreen extends StatelessWidget {
  const VisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VisitViewModel>.reactive(
      viewModelBuilder: () => VisitViewModel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          title: const Text('My Visits'),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: _dateFilterBar(context, model),
          ),
        ),
        body: fullScreenLoader(
          loader: model.isBusy,
          context: context,
          child: RefreshIndicator(
            onRefresh: model.refresh,
            child: model.visitList.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                    itemCount: model.visitList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final visit = model.visitList[index];
                      return _VisitCard(
                        visit: visit,
                        onTap: () async {
                          model.onRowClick(context, visit);
                          await model.refresh();
                        },
                      );
                    },
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.pushNamed(
              context,
              Routes.addVisitScreen,
              arguments:
              AddVisitScreenArguments(
                VisitId:
                model.activeVisit?.status == "In Progress"
                    ? model.activeVisit!.name!
                    : "",
              ),
            );
            await model.refresh();
          },
          icon: const Icon(Icons.add),
          label: Text(
            model.activeVisit?.status == "In Progress"
                ? "Resume Visit"
                : "Create Visit",
          ),
        ),
      ),
    );
  }

  Widget _dateFilterBar(BuildContext context, VisitViewModel model) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 📅 Date Filters Row
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: "From Date",
                  value: model.fromDateLabel,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: model.fromDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      model.updateFromDate(picked);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DateField(
                  label: "To Date",
                  value: model.toDateLabel,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: model.toDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      model.updateToDate(picked);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔍 Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: TextField(
              controller: model.searchController,
              onChanged: model.setCustomerFilter,
              decoration: const InputDecoration(
                hintText: "Search visitors...",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined, size: 18, color: cs.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/* =========================
   VISIT CARD
========================= */

class _VisitCard extends StatelessWidget {
  final AddVisitModel visit;
  final VoidCallback onTap;

  const _VisitCard({
    required this.visit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black87.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      visit.visitorsName ?? 'Unknown Customer',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _StatusChip(visit: visit),
                ],
              ),

              const SizedBox(height: 6),

              AutoSizeText(
                "${visit.name ?? ""} • ${visit.date ?? ""}",
                maxLines: 1,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// IN / OUT / DURATION
              Wrap(
                spacing: 14,
                runSpacing: 8,
                children: [
                  _TimePill(
                    icon: Icons.login,
                    color: Colors.green,
                    label: visit.visitInTime != null
                        ? _formatTime(context, visit.visitInTime!)
                        : "--",
                  ),
                  _TimePill(
                    icon: Icons.logout,
                    color: Colors.red,
                    label: visit.visitOutTime != null
                        ? _formatTime(context, visit.visitOutTime!)
                        : "--",
                  ),
                  _TimePill(
                    icon: Icons.timelapse_outlined,
                    color: cs.primary,
                    label: visit.visitOutTime != null
                        ? "${visit.duration ?? 0} min"
                        : "--",
                  ),
                ],
              ),

              if (visit.visitOutAddress?.isNotEmpty == true) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        visit.visitOutAddress!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.person, size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        visit.user!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================
   STATUS CHIP
========================= */

class _StatusChip extends StatelessWidget {
  final AddVisitModel visit;
  const _StatusChip({required this.visit});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _getStatusColor(visit, cs);
    final label = _getStatusText(visit);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

/* =========================
   TIME PILL
========================= */

class _TimePill extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _TimePill({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/* =========================
   EMPTY STATE
========================= */

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_busy_outlined, size: 34, color: cs.primary),
              const SizedBox(height: 10),
              Text(
                'No visits found',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select another date range and try again.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================
   HELPERS
========================= */

String _formatTime(BuildContext context, String dateTime) {
  final dt = DateTime.tryParse(dateTime);
  if (dt == null) return "--";
  return TimeOfDay.fromDateTime(dt).format(context);
}

String _getStatusText(AddVisitModel visit) {

  switch (visit.status) {

    case "In Progress":
      return "IN PROGRESS";

    case "Completed":
      return "COMPLETED";

    case "Cancelled":
      return "CANCELLED";

    default:
      return "PENDING";
  }
}

Color _getStatusColor(
    AddVisitModel visit,
    ColorScheme cs,
    ) {

  switch (visit.status) {

    case "In Progress":
      return Colors.orange;

    case "Completed":
      return Colors.green;

    case "Cancelled":
      return Colors.red;

    default:
      return cs.onSurfaceVariant;
  }
}
