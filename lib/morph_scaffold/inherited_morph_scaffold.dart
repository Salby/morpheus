import 'package:flutter/material.dart';
import './morph_scaffold.dart';

class InheritedMorphScaffold extends InheritedWidget {

  InheritedMorphScaffold({
    Key key,
    @required this.data,
    @required Widget child
  }) : super(key: key, child: child);

  final MorphScaffoldState data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

}