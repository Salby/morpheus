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
          case '/settings/cookies':
            return MorpheusPageRoute(
              builder: (_) => CookiesScreen(),
              settings: settings,
            );
            break;
          case '/create':
            return MorpheusPageRoute(
              builder: (_) => CreateScreen(),
              settings: settings,
            );
            break;
          case '/':
          default:
            return MorpheusPageRoute(
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
  final createKey = GlobalKey();
  final cardKey = GlobalKey();

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              key: cardKey,
              child: Material(
                type: MaterialType.card,
                borderRadius: BorderRadius.circular(12.0),
                elevation: 4.0,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                    '/create',
                    arguments: MorpheusRouteArguments(
                      parentKey: cardKey,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Create',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        key: createKey,
        icon: Icon(Icons.add),
        label: Text('Create'),
        onPressed: () => Navigator.of(context).pushNamed(
          '/create',
          arguments: MorpheusRouteArguments(
            parentKey: createKey,
            transitionColor: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
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
  final cookiesKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            key: cookiesKey,
            title: Text('Cookies'),
            onTap: () => Navigator.of(context).pushNamed(
              '/settings/cookies',
              arguments: MorpheusRouteArguments(
                parentKey: cookiesKey,
              ),
            ),
          ),
          Divider(height: 1.0),
        ],
      ),
    );
  }
}

class CreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
