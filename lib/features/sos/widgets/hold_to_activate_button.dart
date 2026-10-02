import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HoldToActivateButton extends StatefulWidget {
  final VoidCallback onActivated;

  const HoldToActivateButton({super.key, required this.onActivated});

  @override
  State<HoldToActivateButton> createState() => _HoldToActivateButtonState();
}

class _HoldToActivateButtonState extends State<HoldToActivateButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isActivated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isActivated) {
        _isActivated = true;
        widget.onActivated();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isActivated) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isActivated) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (!_isActivated) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - (_controller.value * 0.05); // scale-95 interaction
          return Transform.scale(
            scale: scale,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: _controller.value,
                    strokeWidth: 8,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.danger),
                    backgroundColor: AppColors.border,
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryRed.withOpacity(_controller.value * 0.2 + 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRed.withOpacity(0.5),
                        blurRadius: 20 * _controller.value + 10,
                        spreadRadius: 10 * _controller.value,
                      )
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_rounded, color: Colors.white, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          _controller.value > 0 ? 'HOLDING...' : 'SOS',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
