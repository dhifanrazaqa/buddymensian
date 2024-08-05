import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateTextfieldWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool isRequired;
  final TextEditingController controller;

  const DateTextfieldWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.isRequired,
    required this.controller,
  }) : super(key: key);

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
        widget.controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.labelText,
              style: GoogleFonts.istokWeb(fontSize: 14),
            ),
            if (widget.isRequired)
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 18,
                offset: const Offset(0, 0),
              ),
            ],
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.cyan, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ],
    );
  }
}