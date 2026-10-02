import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/layout/app_layout.dart';
import '../../../core/utils/providers.dart';
import '../../../domain/entities/history/history_entities.dart';

class PartsRecordScreen extends ConsumerWidget {
  const PartsRecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming vehicle 'v1' is selected for this demo
    final partsAsyncValue = ref.watch(partsRecordProvider('v1'));

    return SafeRideScaffold(
      title: 'Parts Record',
      body: partsAsyncValue.when(
        data: (records) {
          if (records.isEmpty) {
            return const Center(child: Text('No parts records found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: records.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildPartCard(records[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildPartCard(PartRecord record) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: const Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.settings, color: AppColors.primaryRed, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.partName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      Text(
                        record.manufacturer,
                        style: const TextStyle(color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Installed', '${record.installationDate.day} ${_getMonth(record.installationDate.month)} ${record.installationDate.year}'),
                const SizedBox(height: 12),
                _buildDetailRow('Mileage at Install', '${record.mileageAtInstall} km'),
                const SizedBox(height: 12),
                _buildDetailRow('Service Provider', record.serviceProvider),
                if (record.replacementDate != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow('Replaced', '${record.replacementDate!.day} ${_getMonth(record.replacementDate!.month)} ${record.replacementDate!.year}', valueColor: AppColors.danger),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color valueColor = AppColors.primaryText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryText)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
        ),
      ],
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
