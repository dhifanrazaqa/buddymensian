import 'dart:io';

import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/post.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/services/post_services.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:buddymensia/widgets/textfields/date_textfield_widget.dart';
import 'package:buddymensia/widgets/textfields/general_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  final File image;
  const AddPostScreen({super.key, required this.image});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  // final TextEditingController _keywordController = TextEditingController();

  bool _isLoading = false;

  void post() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final result =
          await Provider.of<PostServices>(context, listen: false).uploadData(
              widget.image,
              Post(
                author: User(),
                judul: _judulController.text,
                caption: _captionController.text,
                createdAt: DateFormat('EEEE, d MMMM y', 'id_ID')
                    .parse(_dateController.text),
              ));
      if (result == 'Success') {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal Unggah.')),
        );
      }
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tambahkan Data Scenario',
          style:
              GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(widget.image),
              GeneralTextfieldWidget(
                labelText: 'Judul Foto',
                hintText: 'Masukkan Judul Foto',
                inputType: TextInputType.name,
                isRequired: true,
                controller: _judulController,
                icon: Icons.subtitles,
              ),
              const SizedBox(height: 16),
              GeneralTextfieldWidget(
                labelText: 'Captions',
                hintText: 'Masukkan Captions',
                inputType: TextInputType.multiline,
                isRequired: true,
                controller: _captionController,
                maxLines: 3,
                icon: Icons.subtitles,
              ),
              const SizedBox(height: 16),
              DateTextfieldWidget(
                  labelText: 'Tanggal Foto',
                  hintText: 'Pilih Tanggal',
                  isRequired: true,
                  controller: _dateController,
                  icon: Icons.calendar_month_sharp,
                  ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.hijauTuaSecondary,
                      ),
                    )
                  : PrimaryBtnWidget(
                      buttonText: 'Unggah',
                      color: AppColors.hijauTuaSecondary,
                      handler: post)
            ],
          ),
        ),
      ),
    );
  }
}
