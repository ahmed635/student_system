import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../config/app_colors.dart';
import '../../utils/object_checker.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final Function(String?)? onSubmit;
  final Function(String?)? onChanged;
  final String? value;
  final bool required;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onSubmit,
    this.onChanged,
    this.value,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.keyboardType,
    this.required = false,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.minLines,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.value != null) {
      _controller.text = _toEmptyIfNeeded(widget.value ?? '');
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  String _toEmptyIfNeeded(String value) {
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

  String get getValue => _controller.text;

  set setValue(String value) {
    _controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      validator: widget.validator ?? (value) {
        if (ObjectChecker.isEmptyOrNull(value) && widget.required) {
          return "${translate('required_field')} ${translate(widget.labelText ?? widget.hintText ?? "")}";
        }
        return null;
      },
      keyboardType: widget.keyboardType ?? TextInputType.text,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      decoration: _defaultDecoration(),
      onChanged: !_isEditing
          ? (value) async {
              if (!_isEditing) {
                _isEditing = true;
                if (widget.onChanged != null) {
                  await widget.onChanged!(value);
                }
                setState(() {
                  _isEditing = false;
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
        setState(() {});
      },
    );
  }

  InputDecoration _defaultDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      suffixIcon: widget.suffixIcon,
      prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      hintText: widget.hintText != null ? translate(widget.hintText!) : null,
      labelText: widget.labelText != null ? translate(widget.labelText!) : null,
      hintStyle: TextStyle(color: AppColors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}