import 'package:carwash_app/core/theme/color_theme.dart';
import 'package:carwash_app/core/theme/font_theme.dart';
import 'package:flutter/material.dart';

class MyTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final bool? disabled;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final bool? isTextArea;

  const MyTextInput({
    super.key,
    this.controller,
    this.maxLines,
    this.minLines,
    this.label,
    this.hintText,
    this.validator,
    this.labelStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.disabled,
    this.fillColor,
    this.borderColor,
    this.keyboardType,
    this.readOnly,
    this.isTextArea = false,
  });

  static Widget password({
    TextEditingController? controller,
    bool disabled = false,
    String? placeholder,
    String? label,
    String? hintText,
    TextStyle? labelStyle,
    String? Function(String?)? validator,
    Color? fillColor,
    Color? borderColor,
  }) {
    final obscureText = ValueNotifier<bool>(true);

    return ValueListenableBuilder(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return MyTextInput(
          controller: controller,
          obscureText: value,
          disabled: disabled,
          label: label,
          hintText: hintText,
          labelStyle: labelStyle,
          fillColor: fillColor,
          borderColor: borderColor,
          suffixIcon: IconButton(
            onPressed: () {
              obscureText.value = !obscureText.value;
            },
            icon: value
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
          validator: validator,
        );
      },
    );
  }

  @override
  State<MyTextInput> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: widget.borderColor ?? ColorTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: widget.labelStyle ?? FontTheme.bodyText1),
          const SizedBox(height: 8),
        ],
        TextFormField(
          style: FontTheme.bodyText2,
          controller: widget.controller,
          obscureText: widget.obscureText ?? false,
          enabled: !(widget.disabled ?? false),
          validator: widget.validator ,
          maxLines: widget.isTextArea == true ? null : (widget.maxLines ?? 1),
          minLines: widget.isTextArea == true ? 3 : (widget.minLines ?? 1),
          keyboardType: widget.isTextArea == true
              ? TextInputType.multiline
              : (widget.keyboardType ?? TextInputType.text),
          readOnly: widget.readOnly ?? false,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            prefixIconColor: ColorTheme.primaryColor,
            border: _buildBorder(),
            focusedBorder: _buildBorder(),
            enabledBorder: _buildBorder(),
            disabledBorder: _buildBorder(),
            filled: true,
            isDense:
                true, 
            fillColor: widget.fillColor ?? Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
