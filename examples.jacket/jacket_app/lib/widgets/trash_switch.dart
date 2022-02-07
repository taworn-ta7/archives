import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';

/// A trash view or normal view switching.
class TrashSwitch extends StatefulWidget {
  final bool isChecked;
  final void Function(bool isChecked)? onRefresh;

  const TrashSwitch({
    Key? key,
    this.isChecked = false,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _TrashSwitchState createState() => _TrashSwitchState();
}

class _TrashSwitchState extends State<TrashSwitch> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isChecked) {
      return IconButton(
        icon: const Icon(Icons.delete),
        tooltip: t.trash.trash,
        onPressed: () => widget.onRefresh?.call(true),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.description),
        tooltip: t.trash.normal,
        onPressed: () => widget.onRefresh?.call(false),
      );
    }
  }
}
