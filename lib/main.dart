import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'app_database.dart';
import 'firebase_options.dart';
import 'pages/auth_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/devices_page.dart';
import 'pages/energy_page.dart';
import 'pages/notifications_page.dart';
import 'pages/settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SmartRoomEnergyApp());
}

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
    home: const AuthGate(),
  );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // Initial administrator. Firebase Database rules remain the authority for
  // device writes, so this only controls the client UI while role reads load.
  static const _bootstrapAdminUids = {
    'UrSxJRpKYIRSzG76nsnIlu3PcO82',
  };

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (!snapshot.hasData) return const AuthPage();
      final roleRef = appDatabase.ref('users/${snapshot.data!.uid}/role');
      return StreamBuilder<DatabaseEvent>(
        stream: roleRef.onValue,
        builder: (context, roleSnapshot) {
          if (roleSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final rawRole = roleSnapshot.data?.snapshot.value?.toString();
          final role = rawRole == 'admin' ||
                  _bootstrapAdminUids.contains(snapshot.data!.uid)
              ? 'admin'
              : 'user';
          return AppShell(
            role: role,
            roleStatus: roleSnapshot.hasError
                ? 'Database error: ${roleSnapshot.error}'
                : 'Database role: ${rawRole ?? 'not found'}',
          );
        },
      );
    },
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.role, required this.roleStatus});

  final String role;
  final String roleStatus;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(onDevicesTap: () => setState(() => index = 1)),
      DevicesPage(isAdmin: widget.role == 'admin'),
      const EnergyPage(),
      const NotificationsPage(),
      SettingsPage(role: widget.role, roleStatus: widget.roleStatus),
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
