import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField(
  TextEditingController controller,
  String label, {
  int maxLines = 1,
  int? maxLength,
  bool? password = false,
  bool showCount = true,
}) {
  bool _obscureText = password ?? false;

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            counterText: showCount
                ? null
                : '', // Hides counter text but still enforces maxLength
            suffixIcon: password == true
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          maxLines: password == true ? 1 : maxLines,
          maxLength:
              maxLength, // Keeps enforcing maxLength regardless of showCount
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          obscureText: _obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            if (maxLength != null && value.length > maxLength) {
              return '$label must be at most $maxLength characters';
            }
            return null;
          },
        ),
      );
    },
  );
}
