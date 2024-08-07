import 'package:buddymensia/colors.dart';
import 'package:buddymensia/widgets/buttons/outlined_btn_widget.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:buddymensia/widgets/textfields/general_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AddGuessMeScreen extends StatefulWidget {
  const AddGuessMeScreen({super.key});

  @override
  State<AddGuessMeScreen> createState() => _AddGuessMeScreenState();
}

class _AddGuessMeScreenState extends State<AddGuessMeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _judulInformasiController =
      TextEditingController();
  final TextEditingController _jawabanInformasiController =
      TextEditingController();

  bool _isBottomBarOpen = false;

  void _toggleSidebar() {
    setState(() {
      _isBottomBarOpen = !_isBottomBarOpen;
    });
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 170,
                      child: Image.asset(
                          'assets/images/addphoto_Illustration.png'),
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
                        handler: () {
                          print('clicked');
                        },
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
                          controller: _nameController),
                    ),
                    const SizedBox(height: 8),
                    //Textfield Hubungan
                    SizedBox(
                      width: 300,
                      child: GeneralTextfieldWidget(
                          labelText: 'Hubungan',
                          hintText: 'Pilih Hubungan',
                          inputType: TextInputType.text,
                          isRequired: true,
                          controller: _relationshipController),
                    ),
                    const SizedBox(height: 8),
                    //Textfield Tgl Lahir
                    SizedBox(
                      width: 300,
                      child: GeneralTextfieldWidget(
                          labelText: 'Tanggal Lahir',
                          hintText: 'Pilih Tanggal Lahir',
                          inputType: TextInputType.text,
                          isRequired: true,
                          controller: _dateOfBirthController),
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
                          controller: _locationController),
                    ),
                    const SizedBox(height: 54),
                    //Button Tambah Informasi
                    SizedBox(
                      width: 300,
                      child: OutlinedButton(
                          onPressed: () {
                            _toggleSidebar();
                          },
                          
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                          handler: () {}),
                    ),
                    const SizedBox(height: 36),
                  ],
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
                                controller: _judulInformasiController),
                            SizedBox(height: 8),
                            GeneralTextfieldWidget(
                                labelText: 'Jawaban Informasi',
                                hintText: 'Masukkan Jawaban Informasi',
                                inputType: TextInputType.text,
                                isRequired: true,
                                controller: _jawabanInformasiController),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: 300,
                        height: 40,
                        child: PrimaryBtnWidget(
                            buttonText: 'Simpan',
                            color: AppColors.hijauTuaSecondary,
                            handler: () {}),
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
