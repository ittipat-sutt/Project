import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../app_database.dart';
import '../data/demo_data.dart';
import '../models/device.dart';
import '../widgets/app_card.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key, required this.isAdmin});

  final bool isAdmin;
  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  Future<void> _schedule(SmartDevice device) async {
    if (!widget.isAdmin) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && mounted)
      setState(() => device.schedule = 'Starts at ${time.format(context)}');
  }

  Future<void> _setDevicePower(SmartDevice device, bool value) =>
      appDatabase.ref('devices/${device.id}/isOn').set(value);

  @override
  Widget build(BuildContext context) => StreamBuilder<DatabaseEvent>(
    stream: appDatabase.ref('devices').onValue,
    builder: (context, snapshot) {
      final remoteDevices = snapshot.data?.snapshot.value as Map?;
      for (final device in devices) {
        final remote = remoteDevices?[device.id];
        if (remote is Map && remote['isOn'] is bool) {
          device.isOn = remote['isOn'] as bool;
        }
      }
      return SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
      children: [
        Text(
          'Device Control',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          widget.isAdmin
              ? '${devices.where((d) => d.isOn).length} of ${devices.length} devices currently active'
              : 'View-only mode: device controls are managed by an admin',
        ),
        const SizedBox(height: 24),
        ...devices.map(
          (d) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: d.color.withValues(alpha: .16),
                        child: Icon(d.icon, color: d.color, size: 27),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              d.isOn ? 'Active • ${d.power}' : 'Turned off',
                              style: TextStyle(
                                color: d.isOn
                                    ? const Color(0xFF009F70)
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: d.isOn,
                        onChanged: widget.isAdmin
                            ? (value) => _setDevicePower(d, value)
                            : null,
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 19),
                      const SizedBox(width: 8),
                      Expanded(child: Text(d.schedule ?? 'No schedule set')),
                      TextButton.icon(
                        onPressed: widget.isAdmin ? () => _schedule(d) : null,
                        icon: const Icon(Icons.add_alarm_rounded, size: 18),
                        label: const Text('Schedule'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
      );
    },
  );
}
