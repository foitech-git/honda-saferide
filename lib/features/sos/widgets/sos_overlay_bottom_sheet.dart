import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class SOSOverlayBottomSheet extends StatelessWidget {
  const SOSOverlayBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Emergency Options',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 24),
          _buildOption(
            context: context,
            icon: Icons.warning_amber_rounded,
            color: AppColors.primaryRed,
            title: 'Emergency SOS',
            subtitle: 'Alert SafeRide and contacts immediately',
            onTap: () {
              context.pop();
              context.push('/sos');
            },
          ),
          const SizedBox(height: 16),
          _buildOption(
            context: context,
            icon: Icons.call,
            color: AppColors.danger,
            title: 'Emergency Call',
            subtitle: 'Dial local emergency services (911)',
            onTap: () {
              context.pop();
              // Future: launch dialer
            },
          ),
          const SizedBox(height: 16),
          _buildOption(
            context: context,
            icon: Icons.share_location,
            color: AppColors.routeMostUsed,
            title: 'Share Live Location',
            subtitle: 'Send link to trusted contacts',
            onTap: () {
              context.pop();
              // Future: trigger share intent
            },
          ),
          const SizedBox(height: 16),
          _buildOption(
            context: context,
            icon: Icons.handyman,
            color: AppColors.routeWellLit,
            title: 'Roadside Assistance',
            subtitle: 'Request a tow or jump start',
            onTap: () {
              context.pop();
              // Future: trigger assist flow
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: title == 'Emergency SOS' ? AppColors.primaryRed : AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.border),
          ],
        ),
      ),
    );
  }
}
