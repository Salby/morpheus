import 'package:flutter/material.dart';

import 'package:morpheus/morpheus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.light();
    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
        primaryColor: colorScheme.primary,
        accentColor: colorScheme.secondary,
        scaffoldBackgroundColor: colorScheme.background,
      ),
      title: 'Morpheus example app',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/profile':
            return MorpheusPageRoute(
              builder: (_) => ProfileScreen(),
              settings: settings,
            );
            break;
          case '/settings':
            return MorpheusPageRoute(
              builder: (_) => SettingsScreen(),
              settings: settings,
            );
            break;
          case '/':
          default:
            return MaterialPageRoute(
              builder: (_) => HomeScreen(),
              settings: settings,
            );
            break;
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final profileKey = GlobalKey();
  final settingsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            key: profileKey,
            title: Text('Profile'),
            onTap: () => Navigator.of(context).pushNamed(
              '/profile',
              arguments: MorpheusRouteArguments(
                parentKey: profileKey,
              ),
            ),
          ),
          Divider(height: 1.0),
          ListTile(
            key: settingsKey,
            title: Text('Settings'),
            onTap: () => Navigator.of(context).pushNamed(
              '/settings',
              arguments: MorpheusRouteArguments(
                parentKey: settingsKey,
              ),
            ),
          ),
          Divider(height: 1.0),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
    );
  }
}
