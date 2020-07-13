import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  const CustomTextField({this.hint, this.icon, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: hint,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal.shade200),
            borderRadius: BorderRadius.all(Radius.elliptical(5, 10)),
          ),
        ),
      ),
    );
  }
}
