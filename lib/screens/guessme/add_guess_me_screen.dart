import 'dart:io';

import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/guess_me.dart';
import 'package:buddymensia/services/guessme_services.dart';
import 'package:buddymensia/widgets/buttons/outlined_btn_widget.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:buddymensia/widgets/textfields/date_textfield_widget.dart';
import 'package:buddymensia/widgets/textfields/dropdown_textfield_widget.dart';
import 'package:buddymensia/widgets/textfields/general_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddGuessMeScreen extends StatefulWidget {
  const AddGuessMeScreen({super.key});

  @override
  State<AddGuessMeScreen> createState() => _AddGuessMeScreenState();
}

class _AddGuessMeScreenState extends State<AddGuessMeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formInformasiKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _judulInformasiController =
      TextEditingController();
  final TextEditingController _jawabanInformasiController =
      TextEditingController();
  final _picker = ImagePicker();

  bool _isLoading = false;
  File? _image;
  bool _isBottomBarOpen = false;
  String? _selectedType;
  String _imageError = '';
  Map<String, dynamic> _additionalInfo = {};

  void _toggleSidebar() {
    setState(() {
      _isBottomBarOpen = !_isBottomBarOpen;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          _imageError = '';
        });
      }
    });
  }

  void addAditionalInfo() {
    if (_formInformasiKey.currentState!.validate()) {
      setState(() {
        _additionalInfo[_judulInformasiController.text] =
            _jawabanInformasiController.text;
      });
      _toggleSidebar();
      _judulInformasiController.text = '';
      _jawabanInformasiController.text = '';
    }
  }

  void upload() async {
    if (_formKey.currentState!.validate() && _image != null) {
      setState(() {
        _isLoading = true;
      });

      final result = await Provider.of<GuessMeService>(context, listen: false)
          .uploadData(
              _image!,
              GuessMe(
                  nama: _nameController.text,
                  status: _selectedType,
                  kota: _locationController.text,
                  date: DateFormat('EEEE, d MMMM y', 'id_ID')
                      .parse(_dateOfBirthController.text),
                  additionalInfo: _additionalInfo));

      if (result == 'Success') Navigator.of(context).pop();

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _imageError = 'Silahkan pilih gambar.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isBottomBarOpen) {
          _toggleSidebar();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambahkan Data Guess Me',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    // Handle tap event here
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    child: Image.asset(
                      'assets/icons/ic_help.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                  child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 170,
                          child: _image == null
                              ? Image.asset(
                                  'assets/images/addphoto_Illustration.png')
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      _imageError == ''
                          ? Container()
                          : Text(
                              _imageError,
                              style: GoogleFonts.istokWeb(color: Colors.red),
                            ),
                      SizedBox(
                        height: 16,
                      ),
                      //Btn Galery
                      SizedBox(
                        height: 40,
                        width: 230,
                        child: PrimaryBtnWidget(
                          buttonText: 'Buka Galeri',
                          color: AppColors.hijauTuaSecondary,
                          handler: _pickImage,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      //Textfield Nama
                      SizedBox(
                        width: 300,
                        child: GeneralTextfieldWidget(
                          labelText: 'Nama Lengkap',
                          hintText: 'Masukkan Nama Orang Tersebut',
                          inputType: TextInputType.text,
                          isRequired: true,
                          controller: _nameController,
                          icon: Icons.person,
                        ),
                      ),
                      const SizedBox(height: 8),
                      //Textfield Hubungan
                      SizedBox(
                        width: 300,
                        child: DropdownFieldWidget(
                          labelText: 'Hubungan',
                          hintText: 'Pilih Hubungan',
                          isRequired: true,
                          items: const [
                            'Anak',
                            'Cucu',
                            'Kakak',
                            'Adik',
                            'Ayah',
                            'Ibu',
                            'Paman',
                            'Bibi',
                            'Keponakan',
                            'Sepupu',
                            'Lainnya'
                          ],
                          value: _selectedType,
                          icon: Icons.tag,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedType = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      //Textfield Tgl Lahir
                      SizedBox(
                        width: 300,
                        child: DateTextfieldWidget(
                          labelText: 'Tanggal Lahir',
                          hintText: 'Pilih Tanggal Lahir',
                          isRequired: true,
                          controller: _dateOfBirthController,
                          icon: Icons.calendar_month_sharp,
                        ),
                      ),
                      const SizedBox(height: 8),
                      //Textfield Kota
                      SizedBox(
                        width: 300,
                        child: GeneralTextfieldWidget(
                          labelText: 'Kota Domisili',
                          hintText: 'Masukkan Nama Kota Domisili',
                          inputType: TextInputType.text,
                          isRequired: true,
                          controller: _locationController,
                          icon: Icons.location_on_sharp,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: _additionalInfo.entries.map((entry) {
                            return ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                '${entry.key}: ${entry.value}',
                                style: GoogleFonts.istokWeb(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _additionalInfo.remove(entry.key);
                                  });
                                },
                              ),
                            );
                          }).toList(), // Convert Iterable to List,
                        ),
                      ),
                      const SizedBox(height: 24),
                      //Button Tambah Informasi
                      _isLoading
                          ? CircularProgressIndicator(
                              color: AppColors.hijauTuaSecondary,
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: OutlinedButton(
                                      onPressed: () {
                                        _toggleSidebar();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icons/ic_plus.png',
                                            height: 24,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('Tambah Informasi Lainnya')
                                        ],
                                      )),
                                ),
                                const SizedBox(height: 8),
                                //Button Simpan
                                SizedBox(
                                  width: 300,
                                  height: 40,
                                  child: PrimaryBtnWidget(
                                      buttonText: 'Simpan',
                                      color: AppColors.hijauTuaSecondary,
                                      handler: upload),
                                ),
                              ],
                            ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isBottomBarOpen ? 400 : 0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 90,
                      spreadRadius: 0,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Form(
                          key: _formInformasiKey,
                          child: Column(
                            children: [
                              SizedBox(height: 12),
                              Text(
                                'Informasi Lainnya',
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              GeneralTextfieldWidget(
                                  labelText: 'Judul Informasi',
                                  hintText: 'Masukkan Judul Informasi',
                                  inputType: TextInputType.text,
                                  isRequired: true,
                                  controller: _judulInformasiController, 
                                  icon: Icons.subtitles,),
                              SizedBox(height: 8),
                              GeneralTextfieldWidget(
                                  labelText: 'Jawaban Informasi',
                                  hintText: 'Masukkan Jawaban Informasi',
                                  inputType: TextInputType.text,
                                  isRequired: true,
                                  controller: _jawabanInformasiController, 
                                  icon: Icons.question_answer,),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: 300,
                        height: 40,
                        child: PrimaryBtnWidget(
                            buttonText: 'Simpan',
                            color: AppColors.hijauTuaSecondary,
                            handler: addAditionalInfo),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: 300,
                        height: 40,
                        child: OutlinedBtnWidget(
                            borderColor: AppColors.hijauTuaSecondary,
                            child: Text('kembali'),
                            handler: () {
                              _toggleSidebar();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
