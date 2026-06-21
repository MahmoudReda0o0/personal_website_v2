import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.hintText,
    this.suffixIcon,
    this.maxLines,
    this.minLines,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.textInputType,
    this.obscureText = false,
    this.autofocus = false,
    this.errorText,
  });

  final TextEditingController controller;
  final bool enabled;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool obscureText;
  final bool autofocus;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines ?? 1,
      minLines: minLines,
      obscureText: obscureText,
      autofocus: autofocus,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
    );
  }
}
