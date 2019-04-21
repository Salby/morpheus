# ![Morph](assets/logobar.png)

A Flutter library for easily implementing Material Design navigation transitions.

## Examples

### Parent-child transition

You can use `MorphPageRoute` to create a [parent-child transition](https://material.io/design/navigation/navigation-transitions.html#hierarchical-transitions) between two screens.

```dart
import 'package:morph/morph.dart';

class MyList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        final _parentKey = GlobalKey();
        return ListTile(
          key: _parentKey,
          leading: CircleAvatar(child: Text((index + 1).toString())),
          title: Text('Item ${index + 1}'),
          onTap: () => _handleTap(context, _parentKey),
        );
      }
    );
  }

  void _handleTap(BuildContext context, GlobalKey parentKey) {
    Navigator.of(context).push(MorphPageRoute(
      child: Scaffold(),
      parentKey: parentKey,
      /// If you have a widget above [MyList], e.g. an
      /// [AppBar], you should set an offset.
      offset: kToolbarHeight,
    ));
  }

}
```

### Top-level transition

You can use the `MorphTabView` widget to create a [top-level transition](https://material.io/design/navigation/navigation-transitions.html#peer-transitions) when the child widget changes.

```dart
import 'package:morph/morph.dart';

class MyTabScreen extends StatefulWidget {

  @override
  _MyTabScreenState createState() => _MyTabScreenState();

}

class _MyTabScreenState extends State<MyTabScreen> {

  final List<Widget> _screens = [
    Scaffold(backgroundColor: Colors.green),
    Scaffold(backgroundColor: Colors.red),
    Scaffold(backgroundColor: Colors.blue),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MorphScaffold(
      body: MorphTabView(
        child: _screens[_currentIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            title: Text('Trending'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Saved'),
          ),
        ],
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }

}
```