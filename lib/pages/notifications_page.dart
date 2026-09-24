import 'package:flutter/material.dart';
import '../widgets/app_card.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final items = <_Alert>[
      const _Alert(
        Icons.warning_amber_rounded,
        'High energy usage',
        'Power reached 754 W — above your target.',
        '10 min ago',
        Color(0xFFFF9F43),
      ),
      const _Alert(
        Icons.schedule_rounded,
        'Schedule started',
        'Light turned on at 18:00.',
        'Today, 18:00',
        Color(0xFF7668F2),
      ),
      const _Alert(
        Icons.wifi_rounded,
        'ESP32 connected',
        'Smart meter is reporting normally.',
        'Today, 08:43',
        Color(0xFF00B894),
      ),
    ];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
        children: [
          Text(
            'Notifications',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('Stay informed about your room.'),
          const SizedBox(height: 22),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: item.color.withValues(alpha: .15),
                      child: Icon(item.icon, color: item.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 3),
                          Text(item.message),
                          const SizedBox(height: 7),
                          Text(
                            item.time,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
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
}

class _Alert {
  const _Alert(this.icon, this.title, this.message, this.time, this.color);
  final IconData icon;
  final String title, message, time;
  final Color color;
}
