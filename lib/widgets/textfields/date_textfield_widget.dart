import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateTextfieldWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool isRequired;
  final IconData? icon;
  final TextEditingController controller;

  const DateTextfieldWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.isRequired,
    required this.controller, this.icon,
  });

  @override
  _DateTextfieldWidgetState createState() => _DateTextfieldWidgetState();
}

class _DateTextfieldWidgetState extends State<DateTextfieldWidget> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text =
            DateFormat('EEEE, d MMMM y', 'id_ID').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.labelText,
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
          child: TextFormField(
            controller: widget.controller,
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) {
              if (widget.isRequired && (value == null || value.isEmpty)) {
                return 'Field tidak boleh kosong.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: widget.icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Icon(widget.icon, color: Colors.grey[400], size: 30),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.hijauTuaPrimary),
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
              suffixIcon: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
