import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/app_card.dart';
import 'simulator_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.role, required this.roleStatus});

  final String role;
  final String roleStatus;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool alerts = true;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
      children: [
        Text(
          'Settings',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 22),
        AppCard(
          child: const Column(
            children: [
              _Setting(
                icon: Icons.meeting_room_rounded,
                title: 'Room name',
                value: 'Engineering Laboratory',
              ),
              Divider(),
              _Setting(
                icon: Icons.payments_rounded,
                title: 'Electricity rate',
                value: '฿4.60 / kWh',
              ),
              Divider(),
              _Setting(
                icon: Icons.speed_rounded,
                title: 'Energy limit',
                value: '1,000 W',
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        AppCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.account_circle_rounded),
                title: Text(
                  'Signed in as: ${FirebaseAuth.instance.currentUser?.email ?? ''}',
                ),
                subtitle: Text(
                  'UID: ${FirebaseAuth.instance.currentUser?.uid ?? ''}\n'
                  '${widget.roleStatus}',
                ),
                isThreeLine: true,
                trailing: Chip(label: Text(widget.role.toUpperCase())),
              ),
              const Divider(),
              if (widget.role == 'admin')
                ListTile(
                  leading: const Icon(Icons.developer_board_rounded),
                  title: const Text('ESP32 Simulator'),
                  subtitle: const Text('Send simulated sensor values through the API'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SimulatorPage()),
                  ),
                ),
              if (widget.role == 'admin') const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.notifications_active_rounded),
                title: const Text('Energy alerts'),
                subtitle: const Text('Notify when usage exceeds your limit'),
                trailing: Switch(
                  value: alerts,
                  onChanged: (v) => setState(() => alerts = v),
                ),
              ),
              const Divider(),
              const _Setting(
                icon: Icons.memory_rounded,
                title: 'IoT device',
                value: 'ESP32 • Connected',
              ),
              const Divider(),
              const _Setting(
                icon: Icons.info_outline_rounded,
                title: 'About project',
                value: 'Smart Room Energy v1.0',
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Sign out'),
                onTap: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Setting extends StatelessWidget {
  const _Setting({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title, value;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(title),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: Theme.of(context).textTheme.bodySmall),
        const Icon(Icons.chevron_right_rounded),
      ],
    ),
  );
}
