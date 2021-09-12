import 'package:flutter/material.dart';
import 'package:morpheus/morpheus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme.light();
    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
        primaryColor: colorScheme.primary,
        scaffoldBackgroundColor: colorScheme.background,
      ),
      title: 'Morpheus example app',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/profile':
            return MorpheusPageRoute(
              builder: (_) => const ProfileScreen(),
              settings: settings,
            );
          case '/settings':
            return MorpheusPageRoute(
              builder: (_) => SettingsScreen(),
              settings: settings,
            );
          case '/settings/cookies':
            return MorpheusPageRoute(
              builder: (_) => const CookiesScreen(),
              settings: settings,
            );
          case '/create':
            return MorpheusPageRoute(
              builder: (_) => const CreateScreen(),
              settings: settings,
            );
          case '/':
          default:
            return MorpheusPageRoute(
              builder: (_) => const HomeScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final profileKey = GlobalKey();
  final settingsKey = GlobalKey();
  final createKey = GlobalKey();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MorpheusTabView(
        child: <Widget>[
          const ProfileScreen(
            key: Key('profile'),
          ),
          SettingsScreen(
            key: const Key('settings'),
          ),
        ][_currentIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        key: createKey,
        icon: const Icon(Icons.add),
        label: const Text('Create'),
        onPressed: () => Navigator.of(context).pushNamed(
          '/create',
          arguments: MorpheusRouteArguments(
            parentKey: createKey,
            transitionColor:
                Theme.of(context).floatingActionButtonTheme.backgroundColor,
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final cookiesKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            key: cookiesKey,
            title: const Text('Cookies'),
            onTap: () => Navigator.of(context).pushNamed(
              '/settings/cookies',
              arguments: MorpheusRouteArguments(
                parentKey: cookiesKey,
              ),
            ),
          ),
          const Divider(height: 1.0),
        ],
      ),
    );
  }
}

class CreateScreen extends StatelessWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Create'),
            expandedHeight: 224.0,
          ),
        ],
      ),
    );
  }
}

class CookiesScreen extends StatelessWidget {
  const CookiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Cookies'),
            expandedHeight: 224.0,
          ),
        ],
      ),
    );
  }
}
