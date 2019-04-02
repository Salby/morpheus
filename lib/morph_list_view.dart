import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class MorphListView extends StatelessWidget {

  MorphListView({
    this.shrinkWrap = false,
    this.padding = EdgeInsets.zero,
    this.itemCount,
    this.children,
  })  : itemBuilder = null,
        separatorBuilder = null;

  MorphListView.builder({
    this.shrinkWrap = false,
    this.padding = EdgeInsets.zero,
    this.itemCount,
    @required this.itemBuilder,
  })  : separatorBuilder = null,
        children = null;

  MorphListView.separated({
    this.shrinkWrap = false,
    this.padding = EdgeInsets.zero,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.separatorBuilder,
  })  : children = null;

  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (itemBuilder != null && separatorBuilder == null) {
      return _builder();
    } else if (itemBuilder != null && separatorBuilder != null) {
      return _separated();
    } else {
      return _default();
    }
  }

  Widget _default() {
    return ListView(
      shrinkWrap: shrinkWrap,
      padding: padding,
      children: children,
    );
  }

  Widget _builder() {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemBuilder: itemBuilder,
    );
  }

  Widget _separated() {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: separatorBuilder,
      itemBuilder: itemBuilder,
    );
  }

}