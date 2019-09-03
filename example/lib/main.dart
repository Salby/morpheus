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

class HomeScreen extends StatefulWidget {
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
          ProfileScreen(
            key: Key('profile'),
          ),
          SettingsScreen(
            key: Key('settings'),
          ),
        ][_currentIndex],
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key key}) : super(key: key);

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
  SettingsScreen({Key key}) : super(key: key);

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
