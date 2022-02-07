import 'package:flutter/material.dart';

/// A padding between two widgets.
class PaddingBetween extends StatefulWidget {
  final bool half;
  final bool vertical;

  const PaddingBetween({
    Key? key,
    this.half = false,
    this.vertical = false,
  }) : super(key: key);

  @override
  _PaddingBetweenState createState() => _PaddingBetweenState();
}

class _PaddingBetweenState extends State<PaddingBetween> {
  @override
  Widget build(BuildContext context) {
    final size = widget.half ? 8.0 : 16.0;
    if (!widget.vertical) {
      return Padding(padding: EdgeInsets.only(bottom: size));
    } else {
      return Padding(padding: EdgeInsets.only(right: size));
    }
  }
}
