import 'package:flutter/material.dart';

class CustomTextField
    extends StatelessWidget {

  final String hint;
  final IconData icon;

  const CustomTextField({

    super.key,

    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      decoration: InputDecoration(

        hintText: hint,

        prefixIcon: Icon(icon),

        filled: true,
        fillColor: Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}