import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final VoidCallback? onSuffixIconTap;
  final ValueChanged<String>? onChanged; // <-- Add this

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onSuffixIconTap,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Montserrat',
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor:  Colors.grey[200],
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontFamily: 'Montserrat',
        ),
        prefixIcon:prefixIcon!=null? Icon(
          prefixIcon,
          color: Colors.grey[700],
        ):null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
          onTap: onSuffixIconTap,
          child: Icon(
            suffixIcon,
            color: Colors.grey[700],
          ),
        )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color:  Color(0xFF000000), width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}