import 'package:flutter/material.dart';
import '../widgets/app_card.dart';
import '../widgets/energy_chart.dart';

class EnergyPage extends StatefulWidget {
  const EnergyPage({super.key});
  @override
  State<EnergyPage> createState() => _EnergyPageState();
}

class _EnergyPageState extends State<EnergyPage> {
  int period = 0;
  final List<List<double>> values = [
    [1.3, 2.1, 1.8, 3.9, 2.8, 4.3, 4.82],
    [14.0, 18, 16, 23, 20, 27, 25],
    [54.0, 62, 48, 73, 68, 82, 77],
  ];
  @override
  Widget build(BuildContext context) {
    const names = ['Daily', 'Weekly', 'Monthly'];
    const totals = ['4.82 kWh', '143.0 kWh', '2,031 kWh'];
    final labels = period == 0
        ? const ['06', '09', '12', '15', '18', '21', 'Now']
        : const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
        children: [
          Text(
            'Energy Usage',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SegmentedButton<int>(
            segments: List.generate(
              3,
              (i) => ButtonSegment(value: i, label: Text(names[i])),
            ),
            selected: {period},
            onSelectionChanged: (v) => setState(() => period = v.first),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${names[period]} consumption',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 7),
                Text(
                  totals[period],
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Estimated cost • ${period == 0
                      ? '฿22.18'
                      : period == 1
                      ? '฿657.80'
                      : '฿9,342.60'}',
                ),
                const SizedBox(height: 20),
                EnergyChart(values: values[period], labels: labels),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Usage breakdown',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _breakdown('Air Conditioner', '48%', const Color(0xFF7668F2)),
          _breakdown('Computer', '27%', const Color(0xFF01A9E7)),
          _breakdown('Fan & Light', '25%', const Color(0xFF00B894)),
        ],
      ),
    );
  }

  Widget _breakdown(String name, String percent, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(name)),
          Text(percent, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
