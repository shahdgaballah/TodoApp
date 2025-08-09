import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool isPassword;
  final double? radius;
  final Color background;
  final IconData prefix;
  final IconData? suffix;
  final String text;
  final bool isUppercase;
  final Function()? onSuffixPressed;
  const MyFormField({
    super.key,
    required this.controller,
    required this.type,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.isPassword = false,
    this.radius,
    this.background = Colors.black,
    required this.prefix,
    this.suffix,
    required this.text,
    this.isUppercase = true,
    this.onSuffixPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide(
            color: background,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide(
            color: background,
          ),
        ),
        prefixIcon: Icon(prefix, color: theme.iconTheme.color),
        suffixIcon: suffix != null ?
        IconButton(onPressed: onSuffixPressed,icon: Icon(suffix))
            : null,
        labelText: isUppercase ? text.toUpperCase() : text,
        labelStyle: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }
}