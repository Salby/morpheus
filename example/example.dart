import 'package:flutter/material.dart';
import 'package:morpheus/morpheus.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morpheus example',
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
    return Scaffold(
      body: MorpheusTabView(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}

class ListScreen extends StatelessWidget {
  ListScreen(this.contentType);

  final String contentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contentType),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final parentKey = GlobalKey();
          return ListTile(
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
    ));
    return;
  }
}

class PostScreen extends StatelessWidget {
  PostScreen(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Text(
          'Post $index',
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}
