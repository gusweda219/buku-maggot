import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.icon,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172331),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color(
                0xFF8C8FA5,
              ),
            ),
            fillColor: const Color(0xFFF3F4F8),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
