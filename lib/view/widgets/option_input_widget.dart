import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class OptionInputWidget extends StatelessWidget {
  const OptionInputWidget({
    Key? key,
    required this.name,
    required this.index,
    required this.onClearPressed,
    required this.onChanged,
  }) : super(key: key);

  final int index;
  final String name;
  final VoidCallback? onClearPressed;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      onChanged: onChanged,
      cursorColor: Colors.black,
      maxLength: 40,
      textAlignVertical: TextAlignVertical.center,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context),
      ]),
      decoration: InputDecoration(
        hintText: "Your option",
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
        prefixIcon: IconButton(
          onPressed: null,
          icon: Center(
            child: Text(
              index == 0
                  ? "A"
                  : index == 1
                      ? "B"
                      : index == 2
                          ? "C"
                          : "D",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        suffixIcon: onClearPressed != null
            ? IconButton(
                onPressed: onClearPressed,
                icon: const Icon(Icons.clear),
              )
            : null,
      ),
    );
  }
}
