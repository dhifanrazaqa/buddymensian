import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/guess_me.dart';
import 'package:buddymensia/screens/guessme/detect_screen.dart';
import 'package:buddymensia/widgets/buttons/outlined_btn_widget.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:buddymensia/widgets/textfields/general_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class KuisGuessMeScreen extends StatefulWidget {
  final GuessMe person;
  const KuisGuessMeScreen({super.key, required this.person});

  @override
  State<KuisGuessMeScreen> createState() => _KuisGuessMeScreenState();
}

class _KuisGuessMeScreenState extends State<KuisGuessMeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _answerController = TextEditingController();
  int currentQuestionIndex = 0;
  List<String> questions = [
    'Siapakah nama Dia?',
    'Kapan tanggal lahirnya?',
    'Apa hubungan Anda dengannya?',
    'Dimana domisili tempat tinggalnya?',
  ];
  final Map<String, dynamic> answers = {};
  int _currentAnswer = 2;
  String correctAns = '';

  @override
  void initState() {
    questions = questions + widget.person.additionalInfo!.keys.toList();
    super.initState();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  String containsValueIgnoreCase(String key, String value) {
    String lowerCaseValue = value.toLowerCase();
    String ans = '';
    for (var entry in widget.person.additionalInfo!.entries) {
      if (entry.value.toLowerCase() == lowerCaseValue && entry.key == key) {
        return '';
      } else if (entry.key == key) {
        ans = entry.value;
      }
    }
    return ans;
  }

  void nextQuestion() {
    setState(() {
      _currentAnswer = 2;
      correctAns = '';
      currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
      _answerController.clear();
    });
  }

  void checkAnswer() {
    if (_formKey.currentState!.validate()) {
      String question = questions[currentQuestionIndex];
      String userAnswer = _answerController.text;
      switch (question) {
        case 'Siapakah nama Dia?':
          if (userAnswer.toLowerCase() == widget.person.nama!.toLowerCase()) {
            _currentAnswer = 0;
            Future.delayed(const Duration(seconds: 5), () {
              Future.delayed(const Duration(seconds: 5), () {
                nextQuestion();
              });
            });
          } else {
            _currentAnswer = 1;
            setState(() {
              correctAns = widget.person.nama!;
            });
          }
          break;
        case 'Kapan tanggal lahirnya?':
          if (userAnswer.toLowerCase() ==
              DateFormat('dd MMMM yyyy', "id_ID")
                  .format(widget.person.date!)
                  .toLowerCase()) {
            _currentAnswer = 0;
            Future.delayed(const Duration(seconds: 5), () {
              nextQuestion();
            });
          } else {
            setState(() {
              correctAns = DateFormat('dd MMMM yyyy', "id_ID")
                  .format(widget.person.date!);
            });
            _currentAnswer = 1;
          }
          break;
        case 'Apa hubungan Anda dengannya?':
          if (userAnswer.toLowerCase() == widget.person.status!.toLowerCase()) {
            _currentAnswer = 0;
            Future.delayed(const Duration(seconds: 5), () {
              nextQuestion();
            });
          } else {
            setState(() {
              correctAns = widget.person.status!;
            });
            _currentAnswer = 1;
          }
          break;
        case 'Dimana domisili tempat tinggalnya?':
          if (userAnswer.toLowerCase() == widget.person.kota!.toLowerCase()) {
            _currentAnswer = 0;
            Future.delayed(const Duration(seconds: 5), () {
              nextQuestion();
            });
          } else {
            setState(() {
              correctAns = widget.person.kota!;
            });
            _currentAnswer = 1;
          }
          break;
        default:
          {
            final ans = containsValueIgnoreCase(question, userAnswer);
            if (ans == '') {
              _currentAnswer = 0;
              Future.delayed(const Duration(seconds: 5), () {
                nextQuestion();
              });
            } else {
              setState(() {
                correctAns = ans;
              });
              _currentAnswer = 1;
            }
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          child: Image.network(
                            widget.person.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        questions[currentQuestionIndex],
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
                          ? JawabanSalah(
                              correctAns: correctAns,
                            )
                          : SizedBox(
                              width: 5,
                            )),

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
                      child: Form(
                        key: _formKey,
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
                                handler: () async {
                                  final ans = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TextRecognitionPage()));
                                  if (ans != null) {
                                    setState(() {
                                      _answerController.text = ans;
                                    });
                                  }
                                },
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
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
                        // _currentAnswer = Random().nextInt(3);
                        checkAnswer();
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
                    handler: nextQuestion),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class JawabanBenar extends StatelessWidget {
  const JawabanBenar({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'assets/icons/ic_ceklis.png',
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
}

class JawabanSalah extends StatelessWidget {
  final String correctAns;
  const JawabanSalah({super.key, required this.correctAns});

  @override
  Widget build(BuildContext context) {
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
                    'assets/icons/ic_silang.png',
                    height: 24,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Maaf, Jawaban Kamu Salah :(',
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0XFFA71818))),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Jawaban Benar: ',
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              )),
            ),
            Text(
              correctAns,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              )),
            ),
          ],
        )
      ],
    );
  }
}
