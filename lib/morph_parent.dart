import 'package:flutter/material.dart';

class MorphParent extends StatelessWidget {

  MorphParent({
    this.child,
    this.morphChild,
    this.onMorphed,
  });

  final Widget child;
  final Widget morphChild;
  final VoidCallback onMorphed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => _morph(),
        child: child,
      ),
    );
  }

  void _morph() async {
    // TODO: Handle pushing morphChild screen.
    onMorphed();
  }

}