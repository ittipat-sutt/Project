import 'dart:async';

import 'package:flutter/material.dart';

import '../services/telemetry_api.dart';
import '../widgets/app_card.dart';

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key});

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> {
  double voltage = 220.5;
  double current = 3.42;
  double temperature = 27.0;
  double humidity = 60.0;
  bool motion = false;
  bool sending = false;
  bool autoSend = false;
  double energy = 0;
  Timer? timer;

  double get power => voltage * current;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => sending = true);
    try {
      energy += power / 3600000; // approximate kWh for one simulated second
      await TelemetryApi.send({
        'voltage': double.parse(voltage.toStringAsFixed(1)),
        'current': double.parse(current.toStringAsFixed(2)),
        'power': double.parse(power.toStringAsFixed(1)),
        'energy': double.parse(energy.toStringAsFixed(4)),
        'temperature': double.parse(temperature.toStringAsFixed(1)),
        'humidity': double.parse(humidity.toStringAsFixed(1)),
        'motion': motion,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Telemetry sent to API')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Send failed: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  void _toggleAutoSend(bool value) {
    setState(() => autoSend = value);
    timer?.cancel();
    if (value) {
      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!sending) _send();
      });
    }
  }

  Widget _slider(String label, double value, double min, double max,
      String unit, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(label == 'Current' ? 2 : 1)} $unit'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('ESP32 Simulator')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Simulate sensor readings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            const Text('Values are sent to the Node.js API, then saved in Firebase.'),
            const SizedBox(height: 18),
            AppCard(
              child: Column(children: [
                _slider('Voltage', voltage, 180, 250, 'V',
                    (v) => setState(() => voltage = v)),
                _slider('Current', current, 0, 15, 'A',
                    (v) => setState(() => current = v)),
                _slider('Temperature', temperature, 15, 45, '°C',
                    (v) => setState(() => temperature = v)),
                _slider('Humidity', humidity, 20, 95, '%',
                    (v) => setState(() => humidity = v)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('PIR motion detected'),
                  value: motion,
                  onChanged: (v) => setState(() => motion = v),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Row(children: [
                const Icon(Icons.bolt_rounded, color: Color(0xFFFFA000)),
                const SizedBox(width: 10),
                Expanded(child: Text('Calculated power\n${power.toStringAsFixed(1)} W')),
                Switch(value: autoSend, onChanged: _toggleAutoSend),
                const Text('Every 3 s'),
              ]),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: sending ? null : _send,
              icon: sending
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send_rounded),
              label: Text(sending ? 'Sending...' : 'Send telemetry now'),
            ),
          ],
        ),
      );
}
