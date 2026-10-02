import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/device_simulator.dart';
import '../../../domain/entities/telemetry.dart';

class DeviceSimulatorScreen extends ConsumerStatefulWidget {
  const DeviceSimulatorScreen({super.key});

  @override
  ConsumerState<DeviceSimulatorScreen> createState() => _DeviceSimulatorScreenState();
}

class _DeviceSimulatorScreenState extends ConsumerState<DeviceSimulatorScreen> {
  double _currentSpeed = 0.0;
  double _currentBattery = 1.0;

  @override
  Widget build(BuildContext context) {
    final simulator = ref.watch(deviceSimulatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DEV: Device Simulator'),
        backgroundColor: Colors.amber, // Warning color to indicate dev mode
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.amber.withOpacity(0.2),
              child: const Text(
                'WARNING: This screen is for development only. It must never appear in production builds.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('Connection'),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: simulator.isConnected ? null : () {
                      simulator.connect();
                      setState(() {});
                    },
                    child: const Text('Connect to WS'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: simulator.isConnected ? () {
                      simulator.disconnect();
                      setState(() {});
                    } : null,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                    child: const Text('Disconnect'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Movement & Engine'),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: simulator.isConnected && !simulator.ignition ? () {
                      simulator.startMovement();
                      setState(() {
                        _currentSpeed = simulator.speed;
                      });
                    } : null,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                    child: const Text('Start Engine'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: simulator.isConnected && simulator.ignition ? () {
                      simulator.stopMovement();
                      setState(() {
                        _currentSpeed = 0;
                      });
                    } : null,
                    child: const Text('Stop Engine'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Text('Speed: ${_currentSpeed.toStringAsFixed(1)} km/h'),
            Slider(
              value: _currentSpeed,
              min: 0,
              max: 150,
              onChanged: simulator.isConnected && simulator.ignition ? (value) {
                setState(() => _currentSpeed = value);
                simulator.setSpeed(value);
              } : null,
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Battery Level'),
            Text('Battery: ${(_currentBattery * 100).toStringAsFixed(0)}%'),
            Slider(
              value: _currentBattery,
              min: 0,
              max: 1.0,
              onChanged: simulator.isConnected ? (value) {
                setState(() => _currentBattery = value);
                simulator.setBattery(value);
              } : null,
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Events & Alerts'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: simulator.isConnected ? () {
                    simulator.triggerAlert(AlertState.sos);
                    setState(() {});
                  } : null,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed),
                  child: const Text('Trigger SOS'),
                ),
                ElevatedButton(
                  onPressed: simulator.isConnected ? () {
                    simulator.triggerAlert(AlertState.hazard);
                    setState(() {});
                  } : null,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
                  child: const Text('Trigger Hazard'),
                ),
                ElevatedButton(
                  onPressed: simulator.isConnected ? () {
                    simulator.triggerAlert(AlertState.none);
                    setState(() {});
                  } : null,
                  child: const Text('Clear Alerts'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Current State'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${simulator.isConnected ? 'Connected' : 'Disconnected'}'),
                    Text('Ignition: ${simulator.ignition ? 'ON' : 'OFF'}'),
                    Text('Location: ${simulator.latitude.toStringAsFixed(5)}, ${simulator.longitude.toStringAsFixed(5)}'),
                    Text('Active Alert: ${simulator.alertState.name}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
