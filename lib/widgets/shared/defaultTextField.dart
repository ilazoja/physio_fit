import 'package:flutter/material.dart';

typedef VoidCallback = void Function(String val, bool isValidated);

class DefaultTextField extends StatelessWidget {
  DefaultTextField(
      {this.textController,
      this.text,
      this.hintText,
      this.errorText,
      this.keyboardType = TextInputType.text,
      this.required,
      this.callback,
      this.maxLines});

  final TextEditingController textController;
  final String text, errorText, hintText;
  final TextInputType keyboardType;
  final VoidCallback callback;
  bool required;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    required = required ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      color: Theme.of(context).scaffoldBackgroundColor,

      child: TextFormField(
        maxLines: maxLines == null ? 1 : maxLines,
        keyboardAppearance: Theme.of(context).brightness,
        controller: textController,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintMaxLines: 3,
          alignLabelWithHint: true,
            labelText:  required ? hintText + '*' : hintText,
          fillColor: Theme.of(context).cursorColor,
          border: InputBorder.none
        ),
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
        cursorColor: Colors.black38,
        validator: (String value) {
          return requiredValidator(value);
        },
      ),
    );
  }

  String requiredValidator(String value) {
    if (required && value.isEmpty) {
      callback(value, false);
      return errorText;
    }
  }
}
