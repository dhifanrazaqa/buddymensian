import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeFieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isRequired;
  final TimeOfDay? value;
  final Function(TimeOfDay?) onChanged;

  const TimeFieldWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.isRequired,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          labelText,
          style: GoogleFonts.istokWeb(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: value ?? TimeOfDay.now(),
              );
              if (picked != null) {
                onChanged(picked);
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.hijauTuaPrimary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.cyan, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value != null ? value!.format(context) : hintText,
                    style: TextStyle(
                        color: value != null ? Colors.black : Colors.grey),
                  ),
                  Icon(Icons.access_time, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
