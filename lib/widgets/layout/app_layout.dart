import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class SafeRideScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final Widget? drawer;

  const SafeRideScaffold({
    super.key,
    required this.body,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.actions,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // Ensure it fits comfortably within the 390 viewport width as requested
            constraints: const BoxConstraints(maxWidth: 600),
            child: Scaffold( // Nested Scaffold to allow inner widgets to open the endDrawer
              backgroundColor: Colors.transparent,
              endDrawer: drawer, // Moved drawer here so Builder context finds it
              body: body,
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place_outlined),
            activeIcon: Icon(Icons.place),
            label: 'Places',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_outlined),
            activeIcon: Icon(Icons.warning),
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            activeIcon: Icon(Icons.handyman),
            label: 'Assist',
          ),
        ],
      ),
    );
  }
}

class AppSideDrawer extends StatelessWidget {
  final VoidCallback onVehicleTap;
  final VoidCallback onServiceHistoryTap;
  final VoidCallback onPartsTap;
  final VoidCallback onDocumentsTap;
  final VoidCallback onEmergencyContactsTap;
  final VoidCallback onSavedPlacesTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onLogoutTap;

  const AppSideDrawer({
    super.key,
    required this.onVehicleTap,
    required this.onServiceHistoryTap,
    required this.onPartsTap,
    required this.onDocumentsTap,
    required this.onEmergencyContactsTap,
    required this.onSavedPlacesTap,
    required this.onSettingsTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryRed.withOpacity(0.1),
                    child: const Icon(Icons.person, size: 32, color: AppColors.primaryRed),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Jane Doe', // Mock Name
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.directions_car, size: 16, color: AppColors.secondaryText),
                      const SizedBox(width: 8),
                      const Text(
                        'Honda Civic',
                        style: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Connected',
                          style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildMenuItem(Icons.directions_car_outlined, 'Vehicle', onVehicleTap),
            _buildMenuItem(Icons.history, 'Service History', onServiceHistoryTap),
            _buildMenuItem(Icons.build_circle_outlined, 'Parts Record', onPartsTap),
            _buildMenuItem(Icons.description_outlined, 'Documents', onDocumentsTap),
            _buildMenuItem(Icons.contact_phone_outlined, 'Emergency Contacts', onEmergencyContactsTap),
            _buildMenuItem(Icons.bookmark_outline, 'Saved Places', onSavedPlacesTap),
            const Divider(color: AppColors.border),
            _buildMenuItem(Icons.settings_outlined, 'Settings', onSettingsTap),
            if (kDebugMode)
              _buildMenuItem(
                Icons.developer_mode, 
                'DEV: Simulator', 
                () {
                  context.pop(); // Close drawer
                  context.push('/dev-simulator');
                },
                colorOverride: Colors.amber[700],
              ),
            _buildMenuItem(Icons.logout, 'Logout', onLogoutTap, isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false, Color? colorOverride}) {
    final color = colorOverride ?? (isDestructive ? AppColors.danger : AppColors.primaryText);
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      minVerticalPadding: 16,
    );
  }
}

class AppBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle/Drag indicator
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const Divider(color: AppColors.border, height: 1),
                ],
                // Content
                Flexible(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}
