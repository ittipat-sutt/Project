import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/device.dart';
import '../widgets/app_card.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});
  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  Future<void> _schedule(SmartDevice device) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && mounted)
      setState(() => device.schedule = 'Starts at ${time.format(context)}');
  }

  @override
  Widget build(BuildContext context) => SafeArea(
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
          '${devices.where((d) => d.isOn).length} of ${devices.length} devices currently active',
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
                        onChanged: (value) => setState(() => d.isOn = value),
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
                        onPressed: () => _schedule(d),
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
}
