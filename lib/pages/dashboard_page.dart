import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../app_database.dart';
import '../data/demo_data.dart';
import '../widgets/app_card.dart';
import '../widgets/energy_chart.dart';
import '../widgets/section_title.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.onDevicesTap});
  final VoidCallback onDevicesTap;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.home_rounded),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Room',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Text('Engineering Laboratory'),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle_outlined, size: 30),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AppCard(
          color: const Color(0xFF102B52),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF52E0A4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ESP32 Connected',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.wifi_rounded, color: Color(0xFF52E0A4)),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Current Power Usage',
                style: TextStyle(color: Color(0xFFB5C9E9)),
              ),
              const SizedBox(height: 4),
              const Text(
                '754 W',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Updated just now',
                style: TextStyle(color: Color(0xFFB5C9E9)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _LiveTelemetry(),
        const SizedBox(height: 24),
        const SectionTitle('Live monitoring'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.45,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: const [
            _Metric(
              icon: Icons.bolt_rounded,
              label: 'Voltage',
              value: '220.5',
              unit: 'V',
              color: Color(0xFF01A9E7),
            ),
            _Metric(
              icon: Icons.electric_meter_rounded,
              label: 'Current',
              value: '3.42',
              unit: 'A',
              color: Color(0xFF7668F2),
            ),
            _Metric(
              icon: Icons.energy_savings_leaf_rounded,
              label: 'Energy today',
              value: '4.82',
              unit: 'kWh',
              color: Color(0xFF00B894),
            ),
            _Metric(
              icon: Icons.payments_rounded,
              label: 'Estimated cost',
              value: '22.18',
              unit: 'THB',
              color: Color(0xFFFF9F43),
            ),
          ],
        ),
        const SizedBox(height: 26),
        SectionTitle(
          'Energy today',
          action: TextButton(
            onPressed: () {},
            child: const Text('View report'),
          ),
        ),
        const SizedBox(height: 10),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily consumption',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const EnergyChart(
                values: [0.8, 1.4, 1.0, 2.9, 2.0, 4.1, 4.82],
                labels: [
                  '06:00',
                  '09:00',
                  '12:00',
                  '15:00',
                  '18:00',
                  '21:00',
                  'Now',
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionTitle(
          'Devices',
          action: TextButton(
            onPressed: onDevicesTap,
            child: const Text('Manage'),
          ),
        ),
        const SizedBox(height: 10),
        ...devices
            .take(2)
            .map(
              (d) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: d.color.withValues(alpha: .18),
                        child: Icon(d.icon, color: d.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          d.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        d.isOn ? 'ON' : 'OFF',
                        style: TextStyle(
                          color: d.isOn ? const Color(0xFF00A878) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(value: d.isOn, onChanged: (_) {}),
                    ],
                  ),
                ),
              ),
            ),
      ],
    ),
  );
}

class _LiveTelemetry extends StatelessWidget {
  const _LiveTelemetry();

  double _number(Map<dynamic, dynamic>? value, String key) =>
      (value?[key] as num?)?.toDouble() ?? 0;

  @override
  Widget build(BuildContext context) => StreamBuilder<DatabaseEvent>(
        stream: appDatabase.ref('telemetry/latest').onValue,
        builder: (context, snapshot) {
          final data = snapshot.data?.snapshot.value as Map?;
          final power = _number(data, 'power');
          final voltage = _number(data, 'voltage');
          final current = _number(data, 'current');
          final temperature = _number(data, 'temperature');
          final motion = data?['motion'] == true;
          final hasData = data != null;
          return AppCard(
            color: const Color(0xFF102B52),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: hasData ? const Color(0xFF52E0A4) : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hasData ? 'Live telemetry' : 'Waiting for simulator or ESP32',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.wifi_rounded, color: Color(0xFF52E0A4)),
                ]),
                const SizedBox(height: 18),
                Text('${power.toStringAsFixed(1)} W',
                    style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  '${voltage.toStringAsFixed(1)} V  •  ${current.toStringAsFixed(2)} A  •  ${temperature.toStringAsFixed(1)} °C${motion ? '  •  Motion' : ''}',
                  style: const TextStyle(color: Color(0xFFB5C9E9)),
                ),
                if (snapshot.hasError) ...[
                  const SizedBox(height: 8),
                  const Text('Unable to read telemetry', style: TextStyle(color: Colors.orangeAccent)),
                ],
              ],
            ),
          );
        },
      );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });
  final IconData icon;
  final String label, value, unit;
  final Color color;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const Spacer(),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        RichText(
          text: TextSpan(
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            children: [
              TextSpan(text: value),
              TextSpan(
                text: ' $unit',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
