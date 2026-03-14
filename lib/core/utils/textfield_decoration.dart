import 'package:dummyexpense/core/global.dart/global.dart';
import 'package:flutter/material.dart';

class TextFieldDecoration {
  static InputDecoration loginTextfield({
    String hintText = "",
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextStyle? hintStyle,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle:
          hintStyle ??
          customisedStyle(const Color(0xFF5B5B5B), FontWeight.w500, 12.0),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon, contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
    );
  }

  static InputDecoration searchTextfield({
    String hintText = "",
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextStyle? hintStyle,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      hintText: hintText,
      hintStyle:
          hintStyle ??
          customisedStyle(const Color(0xFF5B5B5B), FontWeight.w500, 12.0),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD9D9D9)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD9D9D9)),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD9D9D9)),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  static InputDecoration commonTextfield({
    String hintText = "",
    Widget? prefixIcon,
    Widget? prefix,
    Widget? suffixIcon,
    TextStyle? hintStyle,
    bool? isDense,
    EdgeInsetsGeometry? contentPadding,
    Color borderColor = const Color(0xFFD9D9D9),
    double borderRadius = 5.0,
  }) {
    return InputDecoration(
      prefix: prefix,
      isDense: isDense,
      contentPadding: contentPadding,
      hintText: hintText,
      hintStyle:
          hintStyle ??
          customisedStyle(const Color(0xFF5B5B5B), FontWeight.w500, 12.0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  static InputDecoration productListTextfield() {
    return InputDecoration(
      border: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8),
    );
  }

  static InputDecoration commonTextFieldDecoration({
    String hintText = "",
    Widget? prefixIcon,
    Widget? prefix,
    Widget? suffixIcon,
    Widget? suffix,
    TextStyle? hintStyle,
    bool enabled = true,
    EdgeInsetsGeometry? contentPadding,
    Color enabledColor = const Color(0xFFD9D9D9),
    Color focusedColor = const Color(0xFFD9D9D9),
    Color disabledColor = const Color(0xFFEFEFEF),
    double borderRadius = 8.0,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      prefix: prefix,
      suffixIcon: suffixIcon,
      suffix: suffix,
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey[100],
      hintStyle:
          hintStyle ??
          customisedStyle(const Color(0xFF5B5B5B), FontWeight.w500, 12.0),
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: enabledColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: focusedColor, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: disabledColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: enabledColor),
      ),
    );
  }
}
