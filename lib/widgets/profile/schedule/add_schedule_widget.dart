import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/jadwal.dart';
import 'package:buddymensia/services/jadwal_services.dart';
import 'package:buddymensia/widgets/buttons/outlined_btn_widget.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:buddymensia/widgets/textfields/dropdown_textfield_widget.dart';
import 'package:buddymensia/widgets/textfields/general_textfield_widget.dart';
import 'package:buddymensia/widgets/textfields/time_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddScheduleWidget extends StatefulWidget {
  final DateTime selectedDay;
  final bool isUser;
  const AddScheduleWidget(
      {super.key, required this.selectedDay, required this.isUser});

  @override
  State<AddScheduleWidget> createState() => _AddScheduleWidgetState();
}

class _AddScheduleWidgetState extends State<AddScheduleWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  String? _selectedType;
  TimeOfDay _selectedTime = TimeOfDay.now();

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await Provider.of<JadwalServices>(context, listen: false)
          .uploadData(Jadwal(
        nama: _nameController.text,
        deskripsi: _descriptionController.text,
        tipe: _selectedType,
        createdAt: DateTime.now(),
        eventAt: combineDateAndTime(widget.selectedDay, _selectedTime),
      ));
      if (result == 'Success') {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal Unggah.')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tambahkan Jadwal',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              DropdownFieldWidget(
                labelText: 'Tipe Jadwal',
                hintText: 'Rutinitas/Kegiatan',
                isRequired: true,
                items: const ['Rutinitas', 'Kegiatan'],
                value: _selectedType,
                icon: Icons.tag,
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              GeneralTextfieldWidget(
                labelText: 'Nama Aktivitas ',
                hintText: 'Masukkan Nama Aktivitas',
                inputType: TextInputType.name,
                isRequired: true,
                controller: _nameController,
                icon: Icons.subtitles,
              ),
              const SizedBox(height: 16),
              GeneralTextfieldWidget(
                labelText: 'Deskripsi Aktivitas',
                hintText: 'Masukkan Deskripsi',
                inputType: TextInputType.multiline,
                isRequired: true,
                controller: _descriptionController,
                maxLines: 1,
                icon: Icons.subtitles,
              ),
              const SizedBox(height: 16),
              TimeFieldWidget(
                labelText: 'Waktu',
                hintText: 'Pilih Waktu',
                isRequired: true,
                value: _selectedTime,
                onChanged: (newTime) {
                  setState(() {
                    _selectedTime = newTime!;
                  });
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? CircularProgressIndicator(
                      color: widget.isUser ? AppColors.hijauTuaSecondary : AppColors.unguCaregiver,
                    )
                  : Column(
                      children: [
                        PrimaryBtnWidget(
                            buttonText: 'Simpan',
                            color: widget.isUser ? AppColors.hijauTuaSecondary : AppColors.unguCaregiver,
                            handler: simpan),
                        const SizedBox(height: 8),
                        OutlinedBtnWidget(
                          borderColor: widget.isUser ? AppColors.hijauTuaSecondary : AppColors.unguCaregiver,
                          handler: cancel,
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.istokWeb(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: widget.isUser ? AppColors.hijauTuaSecondary : AppColors.unguCaregiver
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}
