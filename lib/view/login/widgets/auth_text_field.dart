import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool isNumber;
  final TextInputAction textInputAction;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;

  const AuthTextField({
    Key? key,
    this.hintText,
    required this.controller,
    this.isPassword = false,
    this.isNumber = false,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: TextFormField(
        obscureText: isPassword,
        textInputAction: textInputAction,
        controller: controller,
        inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
        keyboardType: isNumber ? TextInputType.number : keyboardType,
        // style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
