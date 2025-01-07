import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormFieldConfig {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;

  FormFieldConfig({
    required this.label,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });
}

class ReusableForm extends StatefulWidget {
  final List<FormFieldConfig> fields;
  final void Function(List<String>) onSubmit;
  final String submitButtonText;
  final Color? submitButtonColor;
  final TextStyle? submitButtonTextStyle;
  final double fieldSpacing;
  final Color textColor;
  final double borderRadius;
  final Color focusColor;
  final EdgeInsets? submitButtonPadding;
  final Border? submitButtonBorder;

  const ReusableForm({
    Key? key,
    required this.fields,
    required this.onSubmit,
    this.submitButtonText = 'Submit',
    this.submitButtonColor,
    this.submitButtonTextStyle,
    this.fieldSpacing = 16.0,
    this.borderRadius = 12.0,
    this.textColor = Colors.white,
    this.focusColor = Colors.green,
    this.submitButtonPadding,
    this.submitButtonBorder,
  }) : super(key: key);

  @override
  State<ReusableForm> createState() => _ReusableFormState();
}

class _ReusableFormState extends State<ReusableForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<int, bool> _passwordVisibility = {};
  final Map<int, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.fields.length; i++) {
      if (widget.fields[i].isPassword) {
        _passwordVisibility[i] = false;
      }
      _focusNodes[i] = FocusNode();
    }
  }

  @override
  void dispose() {
    _focusNodes.values.forEach((node) => node.dispose());
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label, int index,
      {Widget? suffixIcon}) {
    final bool isFocused = _focusNodes[index]?.hasFocus == true;
    final bool hasText = widget.fields[index].controller.text.isNotEmpty;

    return InputDecoration(
      // Only show hint when not focused and empty
      hintText: (!isFocused && !hasText) ? label : null,
      hintStyle: TextStyle(
        color: widget.textColor.withOpacity(0.5),
        fontSize: 16.sp, // Increased font size
      ),
      // Make the field larger with more padding
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 16.h, // Increased vertical padding
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: widget.textColor.withOpacity(0.3),
          width: 1.5.w, // Slightly thicker border
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: widget.focusColor,
          width: 2.0.w,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.5.w,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0.w,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
      ),
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: 12.w), // Add padding to suffix icon
        child: suffixIcon,
      ),
    );
  }

  Widget _buildFormField(FormFieldConfig field, int index) {
    return TextFormField(
      controller: field.controller,
      focusNode: _focusNodes[index],
      style: TextStyle(
        color: widget.textColor,
        fontSize: 16.sp, // Increased font size
      ),
      keyboardType: field.keyboardType,
      obscureText: field.isPassword && !(_passwordVisibility[index] ?? false),
      textAlign: TextAlign.left,
      cursorColor: widget.focusColor,
      cursorHeight: 22.h, // Taller cursor
      decoration: _buildInputDecoration(
        field.label,
        index,
        suffixIcon: field.isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisibility[index] ?? false
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: _focusNodes[index]?.hasFocus == true
                      ? widget.focusColor
                      : widget.textColor.withOpacity(0.7),
                  size: 24.sp, // Larger icon size
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisibility[index] =
                        !(_passwordVisibility[index] ?? false);
                  });
                },
              )
            : null,
      ),
      validator: field.validator,
      onTap: () {
        setState(() {
          _focusNodes[index]?.requestFocus();
        });
      },
      // Listen for text changes to refresh hint visibility
      onChanged: (value) {
        setState(() {}); // Trigger rebuild to update hint visibility
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ...List.generate(
            widget.fields.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: widget.fieldSpacing.h),
              child: _buildFormField(widget.fields[index], index),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                border: widget.submitButtonBorder,
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.submitButtonColor ?? Colors.blue,
                  padding: widget.submitButtonPadding ??
                      EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius.r),
                  ),
                  minimumSize: Size(double.infinity, 56.h), // Taller button
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final values = widget.fields
                        .map((field) => field.controller.text)
                        .toList();
                    widget.onSubmit(values);
                  }
                },
                child: Text(
                  widget.submitButtonText,
                  style: widget.submitButtonTextStyle ??
                      TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
