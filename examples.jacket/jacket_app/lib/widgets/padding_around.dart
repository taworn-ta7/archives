import 'package:flutter/material.dart';

/// A padding around widgets.
class PaddingAround extends StatefulWidget {
  final Widget child;
  final bool half;

  const PaddingAround({
    Key? key,
    required this.child,
    this.half = false,
  }) : super(key: key);

  @override
  _PaddingAroundState createState() => _PaddingAroundState();
}

class _PaddingAroundState extends State<PaddingAround> {
  @override
  Widget build(BuildContext context) {
    final size = widget.half ? 16.0 : 32.0;
    return Container(
      padding: EdgeInsets.all(size),
      child: widget.child,
    );
  }
}
