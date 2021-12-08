import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Input_Field extends StatelessWidget {
  const Input_Field({
    Key? key,
    // required this.label,
    required this.textlabel,
    required this.controller,
    required this.keyboardType,
    required this.text,
    // required this.icon,
  }) : super(key: key);

  // final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String textlabel;
  final String text;
  // final IconData icon;

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = new FocusNode();
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
            color: myFocusNode.hasFocus ? Colors.blue : Colors.black),
        // prefixIcon: Icon(
        //   icon,
        //   color: const Color(
        //     0xFF8C8FA5,
        //   ),
        // ),
        fillColor: const Color(0xFFF3F4F8),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return text;
        }
      },
    );
  }
}
