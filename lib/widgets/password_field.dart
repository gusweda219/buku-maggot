import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isHiddenPassword = true;

  void _togglePasswordView() {
    if (_isHiddenPassword) {
      setState(() {
        _isHiddenPassword = false;
      });
    } else {
      setState(() {
        _isHiddenPassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
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
          controller: widget.controller,
          obscureText: _isHiddenPassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Color(
                0xFF8C8FA5,
              ),
            ),
            suffixIcon: InkWell(
              onTap: _togglePasswordView,
              child: _isHiddenPassword
                  ? const Icon(
                      Icons.visibility,
                      color: Color(
                        0xFF8C8FA5,
                      ),
                    )
                  : const Icon(
                      Icons.visibility_off,
                      color: Color(
                        0xFF8C8FA5,
                      ),
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
