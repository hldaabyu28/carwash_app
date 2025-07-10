import 'package:carwash_app/core/theme/color_theme.dart';
import 'package:carwash_app/core/theme/font_theme.dart';
import 'package:flutter/material.dart';

enum IconPosition {
  leading,
  trailing,
}

class MyButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final TextAlign? textAlign;
  final bool? isExpanded;
  final bool? isLoading;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  final TextStyle? textStyle;
  final Color? shadowColor;
  final BorderSide? border;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  const MyButton(
      {super.key,
      this.onPressed,
      required this.label,
      this.textAlign,
      this.isExpanded,
      this.isLoading,
      this.leading,
      this.trailing,
      this.color,
      this.textStyle,
      this.shadowColor,
      this.border,
      this.padding,
      this.borderRadius});

  static Widget bordered({
    void Function()? onPressed,
    required String label,
    TextStyle? textStyle,
    Widget? leading,
    Widget? trailing,
    Color? color,
    Color? borderColor,
    Color? textColor,
    EdgeInsetsGeometry? padding,
    bool? isLoading,
  }) {
    return MyButton(
      onPressed: onPressed,
      label: label,
      leading: leading,
      trailing: trailing,
      padding: padding,
      color: color ?? Colors.white,
      shadowColor: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      border: BorderSide(color: borderColor ?? ColorTheme.primaryColor),
      textStyle: textStyle,
      isLoading: isLoading,
      textAlign: TextAlign.center,
    );
  }

  static Widget icon({
    required void Function()? onPressed,
    required String label,
    Widget? leading,
    IconData? icon,
    double? spacing,
    Color? color,
    TextStyle? textStyle,
    Color? containerColor,
    IconPosition? iconPosition,
    BorderSide? border,
    EdgeInsetsGeometry? padding,
  }) {
    return MyButton(
      onPressed: onPressed,
      label: label,
      border: border,
      padding: padding,
      leading: leading ??
          (iconPosition == IconPosition.trailing
              ? null
              : Icon(icon ?? Icons.question_mark,
                  color: color ?? ColorTheme.primaryColor)),
      trailing: iconPosition == IconPosition.trailing
          ? Icon(icon, color: color ?? ColorTheme.primaryColor)
          : null,
      color: containerColor ?? Colors.white,
      shadowColor: Colors.transparent,
      textStyle: textStyle ??
          TextStyle(
            color: ColorTheme.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget text() {
      return Text(
        label,
        textAlign: textAlign ?? TextAlign.center,
        style:
            textStyle ?? FontTheme.buttonText.copyWith(
              color: color == null ? Colors.white : Colors.black,
            ),
      );
    }

    return ElevatedButton(
      onPressed: (isLoading ?? false) ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? ColorTheme.primaryColor,
        minimumSize: const Size(double.infinity, 0),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          side: border ?? BorderSide.none,
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
        shadowColor: shadowColor ?? Colors.transparent,
      ),
      child: (isLoading ?? false)
          ? (isExpanded ?? false)
              ? const SizedBox(
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
          : Row(
              mainAxisSize:
                  (isExpanded ?? false) ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (leading != null) leading!,
                SizedBox(width: leading != null ? 16 : 0),
                (isExpanded ?? false) ? Expanded(child: text()) : text(),
                SizedBox(width: trailing != null ? 16 : 0),
                if (trailing != null) trailing!,
              ],
            ),
    );
  }
}
