import 'package:flutter/material.dart';

/// A page button.
class PageButton extends StatefulWidget {
  final Icon? icon;
  final String caption;
  final bool usePositiveNagative;
  final bool negativeButton;
  final bool lastInList;
  final void Function()? onPressed;

  const PageButton({
    Key? key,
    this.icon,
    required this.caption,
    this.usePositiveNagative = false,
    this.negativeButton = false,
    this.lastInList = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  _PageButtonState createState() => _PageButtonState();
}

class _PageButtonState extends State<PageButton> {
  static const paddingButtonIcon = 20.0;
  static const paddingButton = 22.0;
  static const paddingNext = 16.0;

  @override
  Widget build(BuildContext context) {
    if (widget.icon != null) {
      if (!widget.lastInList) {
        return Row(
          children: [
            ElevatedButton.icon(
              style: _buildButtonStyle(),
              icon: widget.icon!,
              label: Text(widget.caption),
              onPressed: widget.onPressed,
            ),
            const Padding(
              padding: EdgeInsets.only(right: paddingNext),
            ),
          ],
        );
      } else {
        return Expanded(
          child: ElevatedButton.icon(
            style: _buildButtonStyle(),
            icon: widget.icon!,
            label: Text(widget.caption),
            onPressed: widget.onPressed,
          ),
        );
      }
    } else {
      if (!widget.lastInList) {
        return Row(
          children: [
            ElevatedButton(
              style: _buildButtonStyle(),
              child: Text(widget.caption),
              onPressed: widget.onPressed,
            ),
            const Padding(
              padding: EdgeInsets.only(right: paddingNext),
            ),
          ],
        );
      } else {
        return Expanded(
          child: ElevatedButton(
            style: _buildButtonStyle(),
            child: Text(widget.caption),
            onPressed: widget.onPressed,
          ),
        );
      }
    }
  }

  ButtonStyle _buildButtonStyle() {
    final useIcon = widget.icon != null;
    if (widget.usePositiveNagative) {
      return ElevatedButton.styleFrom(
        primary: widget.negativeButton ? Colors.red : Colors.blue,
        padding: EdgeInsets.all(useIcon ? paddingButtonIcon : paddingButton),
      );
    } else {
      return ElevatedButton.styleFrom(
        padding: EdgeInsets.all(useIcon ? paddingButtonIcon : paddingButton),
      );
    }
  }
}
