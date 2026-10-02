import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../core/utils/providers.dart';
import '../../../domain/entities/history/history_entities.dart';

class ServiceHistoryScreen extends ConsumerWidget {
  const ServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming vehicle 'v1' is selected for this demo
    final historyAsyncValue = ref.watch(serviceHistoryProvider('v1'));

    return SafeRideScaffold(
      title: 'Service History',
      body: historyAsyncValue.when(
        data: (records) {
          if (records.isEmpty) {
            return const Center(child: Text('No service history found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            itemCount: records.length,
            itemBuilder: (context, index) {
              return _buildTimelineItem(records[index], isLast: index == records.length - 1);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildTimelineItem(ServiceRecord record, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${record.date.day} ${_getMonth(record.date.month)} ${record.date.year}',
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    record.title,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusText(record.status),
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (record.providerName != null || record.mileage != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (record.providerName != null)
                            Row(
                              children: [
                                const Icon(Icons.handyman, size: 14, color: AppColors.secondaryText),
                                const SizedBox(width: 8),
                                Text(record.providerName!, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                              ],
                            ),
                          if (record.mileage != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.speed, size: 14, color: AppColors.secondaryText),
                                const SizedBox(width: 8),
                                Text('${record.mileage} km', style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.completed: return 'Completed';
      case ServiceStatus.pending: return 'Pending';
      case ServiceStatus.inProgress: return 'In Progress';
      case ServiceStatus.cancelled: return 'Cancelled';
    }
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
