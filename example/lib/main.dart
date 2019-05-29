import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/morpheus.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morpheus example',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.tealAccent,
      ),
      home: TabScreen(),
    );
  }
}

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Widget> _screens = [
    ListScreen('Trending'),
    ListScreen('New'),
    ListScreen('Saved'),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: MorpheusTabView(
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) setState(() => _currentIndex = index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              title: Text('Trending'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              title: Text('New'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text('Saved'),
            ),
          ],
        ),
      ),
    );
  }
}

class ListScreen extends StatelessWidget {
  ListScreen(this.contentType);

  final String contentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          final parentKey = GlobalKey();
          return ListTile(
            key: parentKey,
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text('$contentType ${index + 1}'),
            onTap: () => _handleTap(context, index + 1, parentKey),
          );
        },
      ),
    );
  }

  Future<void> _handleTap(context, int index, GlobalKey parentKey) async {
    await Navigator.of(context).push(MorpheusPageRoute(
      builder: (context) => PostScreen(index),
      parentKey: parentKey,
      transitionColor: Theme.of(context).scaffoldBackgroundColor,
      transitionDuration: Duration(milliseconds: 325),
    ));
    return;
  }
}

class PostScreen extends StatelessWidget {
  PostScreen(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black12,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Post'),
        ),
        body: Center(
          child: Text(
            'Post $index',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }
}