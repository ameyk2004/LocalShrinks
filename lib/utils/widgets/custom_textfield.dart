import 'package:flutter/material.dart';
import 'package:local_shrinks/utils/widgets/widget_support.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final bool obscureText;
  final TextEditingController textEditingController;

  const CustomTextField({super.key, required this.hintText, required this.icon, required this.obscureText, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style : AppWidget.boldTextStyle(),
      obscureText: obscureText,
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppWidget.boldTextStyle(),
          prefixIcon: icon,
          border: OutlineInputBorder(borderSide: const BorderSide(width: 1), borderRadius: BorderRadius.circular(15))
      ),
    );
  }
}
