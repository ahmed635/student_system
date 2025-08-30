import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../config/app_colors.dart';
import '../../utils/object_checker.dart';

class CustomTextFormField extends StatefulWidget {
  String? hintText;
  final TextEditingController _controller = TextEditingController();
  bool? readOnly = false;
  TextInputType? keyboardType;
  Widget? suffixIcon;
  Function(String?)? onSubmit;
  Function(String?)? onChanged;
  String? value;
  bool? required;

  CustomTextFormField({
    this.hintText,
    this.onSubmit,
    this.onChanged,
    this.value,
    this.suffixIcon,
    this.readOnly,
    this.keyboardType,
    this.required = false,
  }) {
    _controller.text = toEmptyIfNeeded(value ?? '');
  }

  String toEmptyIfNeeded(String value) {
    if (value.isEmpty || value == "null") {
      return "";
    }
    try {
      int val = int.parse(value.toString());
      if (val == 0) {
        return "";
      }
    } catch (e) {
      try {
        double val = double.parse(value.toString());
        if (val == 0) {
          return "";
        }
      } catch (e) {
        return value;
      }
    }
    return value;
  }

  get getValue {
    return _controller.text;
  }

  set setValue(String value) {
    _controller.text = value;
  }

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._controller,
      validator: (value) {
        if (ObjectChecker.isEmptyOrNull(value) && widget.required!) {
          return "${translate('required_field')} ${translate(widget.hintText ?? "")}";
        }
        return null;
      },
      keyboardType: widget.keyboardType ?? TextInputType.text,
      readOnly: widget.readOnly ?? false,
      decoration: _defaultDecoration(),
      onChanged: !isEditing
          ? (value) async {
              if (!isEditing) {
                isEditing = true;
                widget.value = widget._controller.text;
                if (widget.onChanged != null) {
                  await widget.onChanged!(value);
                }
                setState(() {
                  isEditing = false;
                });
              }
            }
          : null,
      onFieldSubmitted: (value) async {
        if (widget.onChanged != null) {
          await widget.onChanged!(value);
        }
        if (widget.onSubmit != null) {
          await widget.onSubmit!(value);
        }
        widget.value = widget._controller.text;
        setState(() {});
      },
    );
  }

  InputDecoration _defaultDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      suffixIcon: widget.suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      hintText: translate(widget.hintText ?? ""),
      label: Text(translate(widget.hintText ?? '')),
      hintStyle: TextStyle(color: AppColors.grey),
    );
  }
}
