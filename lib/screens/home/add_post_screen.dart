import 'dart:io';

import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/guess_me.dart';
import 'package:buddymensia/models/post.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/services/guessme_services.dart';
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
  final TextEditingController _memoryController = TextEditingController();
  final List<String> selectedMembers = [];
  final List<String> memoryWords = [];

  bool _isLoading = false;
  bool _isAnggotaEmpty = false;
  bool _isMemoryEmpty = false;

  void post() async {
    if (_formKey.currentState!.validate()) {
      if (selectedMembers.isEmpty) {
        setState(() {
          _isAnggotaEmpty = true;
        });
        return;
      } else {
        setState(() {
          _isAnggotaEmpty = false;
        });
      }

      if (memoryWords.isEmpty) {
        setState(() {
          _isMemoryEmpty = true;
        });
        return;
      } else {
        setState(() {
          _isMemoryEmpty = false;
        });
      }

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
                createdAt: DateTime.now(),
                date: DateFormat('EEEE, d MMMM y', 'id_ID')
                    .parse(_dateController.text),
                anggotaKeluarga: selectedMembers,
                kataMemory: memoryWords
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

  void _addMemoryWord() {
    final String text = _memoryController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        memoryWords.add(text);
      });
      _memoryController.clear();
    }
  }

  void _removeMemoryWord(String word) {
    setState(() {
      memoryWords.remove(word);
    });
  }

  @override
  Widget build(BuildContext context) {
    GuessMeService guessMeProvider = Provider.of<GuessMeService>(context);
    List<GuessMe?> persons = guessMeProvider.items;

    double width = MediaQuery.of(context).size.width;

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
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width,
                  ),
                  Text(
                    'Anggota Keluarga',
                    style: GoogleFonts.istokWeb(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: persons.map((member) {
                      bool isSelected = selectedMembers.contains(member!.nama!);
                      return ChoiceChip(
                        label: Text(member.nama!),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedMembers.add(member.nama!);
                            } else {
                              selectedMembers.remove(member.nama!);
                            }
                          });
                        },
                        selectedColor: AppColors.hijauTuaSecondary,
                        side: const BorderSide(color: AppColors.hijauMuda),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: AppColors.hijauMuda,
                        labelStyle: const TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                  _isAnggotaEmpty
                      ? Text(
                          'Pilih anggota keluarga.',
                          style: GoogleFonts.istokWeb(
                              color: Colors.red[900], fontSize: 12),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width,
                  ),
                  Text(
                    'Kata Memori',
                    style: GoogleFonts.istokWeb(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: memoryWords.map((word) {
                      return Chip(
                        label: Text(
                          word,
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        deleteIcon: Icon(
                          Icons.close,
                          color: Colors.teal[700],
                        ),
                        onDeleted: () => _removeMemoryWord(word),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            width: 1.5,
                            color: AppColors.hijauMuda,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _memoryController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Kata Memori',
                            hintStyle: GoogleFonts.istokWeb(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 5),
                              child: Icon(Icons.memory,
                                  color: Colors.grey[400], size: 30),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.hijauTuaPrimary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey[400]!, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.cyan, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.hijauTuaSecondary,
                            shape: const CircleBorder(),
                          ),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: _addMemoryWord,
                        ),
                      ),
                    ],
                  ),
                  _isMemoryEmpty
                      ? Text(
                          'Tambahkan Kata Memory.',
                          style: GoogleFonts.istokWeb(
                              color: Colors.red[900], fontSize: 12),
                        )
                      : Container(),
                ],
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
                      handler: post),
            ],
          ),
        ),
      ),
    );
  }
}
