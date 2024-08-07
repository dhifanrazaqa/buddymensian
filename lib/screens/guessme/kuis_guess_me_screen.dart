import 'dart:math';

import 'package:buddymensia/colors.dart';
import 'package:buddymensia/widgets/buttons/outlined_btn_widget.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:buddymensia/widgets/textfields/general_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KuisGuessMeScreen extends StatefulWidget {
  const KuisGuessMeScreen({super.key});

  @override
  State<KuisGuessMeScreen> createState() => _KuisGuessMeScreenState();
}

class _KuisGuessMeScreenState extends State<KuisGuessMeScreen> {
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int _currentAnswer = Random().nextInt(3);

    return Scaffold(
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
              'Kuis Guess Me',
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Card(
                color: Colors.white,
                child: Container(
                  height: 220,
                  child: Column(
                    children: [
                      Container(
                        height: 160,
                        width: 320,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.asset(
                            'assets/images/placeholder_guessme.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Siapakah Nama Dia?',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                child: _currentAnswer == 0
                ? JawabanBenar()
                : _currentAnswer == 1
                ? JawabanSalah()
                : SizedBox(width: 5,)
              ),

              const SizedBox(height: 12),

              //Card Jawaban
              Card(
                color: Colors.white,
                child: Container(
                    height: 250,
                    width: 320,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 36),
                      child: Column(
                        children: [
                          Spacer(),
                          GeneralTextfieldWidget(
                              labelText: 'Ketik Jawaban',
                              hintText: 'Masukkan Jawaban Anda',
                              inputType: TextInputType.text,
                              isRequired: true,
                              controller: _answerController),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Atau',
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Jawab Dengan Tulisan Tangan',
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            )),
                          ),
                          Text(
                            'Silahkan Masukkan Foto Jawaban Tulis Tangan',
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 40,
                            width: 230,
                            child: PrimaryBtnWidget(
                              buttonText: 'Ambil Gambar',
                              color: AppColors.hijauTuaSecondary,
                              handler: () {
                                print('clicked');
                              },
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    )),
              ),

              const SizedBox(height: 24),

              //Buttton Jawab
              SizedBox(
                width: 300,
                height: 40,
                child: PrimaryBtnWidget(
                    buttonText: 'Jawab Pertanyaan',
                    color: AppColors.hijauTuaSecondary,
                    handler: () {
                      setState(() {
                        _currentAnswer = Random().nextInt(3); 
                      });
                    }),
              ),
              const SizedBox(height: 8),
              //Button Kembali
              SizedBox(
                width: 300,
                height: 40,
                child: OutlinedBtnWidget(
                    borderColor: AppColors.hijauTuaSecondary,
                    child: Text('Lewati Pertanyaan'),
                    handler: () {}),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

Widget JawabanBenar() {
  return Column(
    children: [
      Container(
          width: 320,
          decoration: BoxDecoration(
              color: Color(0xffABD1C6),
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo/Logo v1.png',
                  height: 24,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Selamat, Jawaban Anda Benar !',
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff004643))),
                )
              ],
            ),
          )),
      SizedBox(
        height: 8,
      ),
      Text(
        '5 Detik, Menuju Halaman Selanjutnya',
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        )),
      ),
    ],
  );
}

Widget JawabanSalah() {
  return Column(
    children: [
      Container(
          width: 320,
          decoration: BoxDecoration(
              color: Color(0XFFD1ABAC),
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo/Logo v1.png',
                  height: 24,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Selamat, Jawaban Anda Benar !',
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0XFFA71818))),
                )
              ],
            ),
          )),
    ],
  );
}