import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/devices_page.dart';
import 'pages/energy_page.dart';
import 'pages/notifications_page.dart';
import 'pages/settings_page.dart';

void main() => runApp(const SmartRoomEnergyApp());

class SmartRoomEnergyApp extends StatelessWidget {
  const SmartRoomEnergyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Smart Room Energy',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A9E8)),
      scaffoldBackgroundColor: const Color(0xFFF4F7FB),
    ),
    home: const AppShell(),
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(onDevicesTap: () => setState(() => index = 1)),
      const DevicesPage(),
      const EnergyPage(),
      const NotificationsPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.power_outlined),
            selectedIcon: Icon(Icons.power_rounded),
            label: 'Devices',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Energy',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
