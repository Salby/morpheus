# Morph

A Flutter library for easily implementing Material Design navigation transitions.

## Examples

### Parent-child transition

You can use `MorphPageRoute` to create a parent-child transition between your two screens.

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

  void _handleTap(BuildContext context, Key parentKey) {
    Navigator.of(context).push(MorphPageRoute(
      child: Scaffold(),
      parentKey: parentKey,
    ));
  }

}
```

## Feature roadmap
- Top-level transitions
- Parent-child transitions