import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text form container which wrap TextFormField and optional label.
class TextFormContainer extends StatefulWidget {
  final String? caption;
  final String labelText;
  final int? maxLength;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  /// Constructor.
  const TextFormContainer({
    Key? key,
    this.caption = '',
    this.labelText = '',
    this.maxLength,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.controller,
    this.validator,
  }) : super(key: key);

  /// Money constructor.
  factory TextFormContainer.money({
    Key? key,
    String? caption = '',
    String labelText = '',
    bool readOnly = false,
    TextEditingController? controller,
  }) {
    return TextFormContainer(
      caption: caption,
      labelText: labelText,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d{0,12}(\.\d{0,2})?'),
        ),
      ],
      controller: controller,
    );
  }

  /// Quantity constructor.
  factory TextFormContainer.quantity({
    Key? key,
    String? caption = '',
    String labelText = '',
    bool readOnly = false,
    TextEditingController? controller,
  }) {
    return TextFormContainer(
      caption: caption,
      labelText: labelText,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d{0,9}'),
        ),
      ],
      controller: controller,
    );
  }

  @override
  _TextFormContainerState createState() => _TextFormContainerState();
}

class _TextFormContainerState extends State<TextFormContainer> {
  static const spaceBetweenLabelAndText = 4.0;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (widget.caption != null) {
      children.add(_buildTextFormLabel());
      children.add(const Padding(
        padding: EdgeInsets.only(bottom: spaceBetweenLabelAndText),
      ));
    }
    children.add(_buildTextFormField());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildTextFormLabel() {
    return Text(widget.caption ?? '');
  }

  Widget _buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
      ),
      maxLength: widget.maxLength,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      controller: widget.controller,
      validator: widget.validator,
    );
  }
}
