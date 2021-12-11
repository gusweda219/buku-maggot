import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    // required this.label,
    required this.textlabel,
    required this.controller,
    required this.keyboardType,
    this.validator,
    // required this.icon,
  }) : super(key: key);

  // final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String textlabel;
  final String? Function(String? value)? validator;
  // final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: textlabel,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      validator: validator,
    );
  }
}
