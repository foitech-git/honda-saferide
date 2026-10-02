import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/feedback/app_feedback.dart';
import '../../../domain/entities/community/community_report.dart';

class ReportBottomSheet extends StatefulWidget {
  final Future<bool> Function(ReportType type, String? description) onSubmit;

  const ReportBottomSheet({super.key, required this.onSubmit});

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  ReportType _selectedType = ReportType.pothole;
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _reportTypes = [
    {'type': ReportType.pothole, 'label': 'Pothole', 'icon': Icons.warning_amber},
    {'type': ReportType.accident, 'label': 'Accident', 'icon': Icons.car_crash},
    {'type': ReportType.roadWork, 'label': 'Road Work', 'icon': Icons.construction},
    {'type': ReportType.poorLighting, 'label': 'Poor Lighting', 'icon': Icons.lightbulb_outline},
    {'type': ReportType.flooding, 'label': 'Flooding', 'icon': Icons.water_drop},
    {'type': ReportType.unsafeArea, 'label': 'Unsafe Area', 'icon': Icons.gpp_bad},
    {'type': ReportType.traffic, 'label': 'Traffic', 'icon': Icons.traffic},
    {'type': ReportType.other, 'label': 'Other', 'icon': Icons.report_problem},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() {
      _isSubmitting = true;
    });

    final success = await widget.onSubmit(_selectedType, _descriptionController.text.trim());
    
    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      if (success) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 24.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Report Hazard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'What did you encounter?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _reportTypes.map((item) {
              final isSelected = _selectedType == item['type'];
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedType = item['type'] as ReportType;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.warning.withOpacity(0.1) : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.warning : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 16,
                        color: isSelected ? AppColors.warning : AppColors.secondaryText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.warning : AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          AppTextField(
            labelText: 'Description (Optional)',
            hintText: 'Add any helpful details...',
            controller: _descriptionController,
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            label: 'Add Photo (Optional)',
            icon: Icons.camera_alt,
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Submit Report',
            isLoading: _isSubmitting,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
