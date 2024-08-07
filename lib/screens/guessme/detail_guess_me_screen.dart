import 'package:buddymensia/colors.dart';
import 'package:buddymensia/widgets/buttons/outlined_btn_widget.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuessMeDetail extends StatelessWidget {
  final Map<String, String> item;

  const GuessMeDetail({Key? key, required this.item}) : super(key: key);

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
                'Detail Data Guess Me',
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Data Detail
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
                              item['photo']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          item['name']!,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                        ),
                        Text(
                          'Hubungan: ${item['relation']}',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 119, 119, 119),
                          )),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                //Kelola Data
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 145,
                      height: 40,
                      child: PrimaryBtnWidget(
                        buttonText: 'Edit Data',
                        color: AppColors.hijauTuaSecondary,
                        handler: () {},
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    SizedBox(
                      width: 145,
                      height: 40,
                      child: PrimaryBtnWidget(
                        buttonText: 'Hapus Data',
                        color: Colors.red,
                        handler: () {},
                      ),
                    ),
                    Spacer(),
                  ],
                ),

                SizedBox(
                  height: 16,
                ),

                Card(
                  color: Colors.white,
                  child: Container(
                      height: 170,
                      width: 320,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 36),
                        child: Column(
                          children: [
                            Spacer(),
                            Text(
                              'Detail Informasi',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tanggal Lahir: ',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '10 Januari 2024',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Domisili: ',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Jakarta Selatan',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                            Text(
                              'Informasi Lainnya',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tanggal Lahir: ',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '10 Januari 2024',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      )),
                ),

                const SizedBox(height: 64),
                //Button Kuis
                SizedBox(
                  width: 300,
                  height: 40,
                  child: PrimaryBtnWidget(
                      buttonText: 'Mulai Kuis Guess Me',
                      color: AppColors.hijauTuaSecondary,
                      handler: () {}),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: OutlinedBtnWidget(
                      borderColor: AppColors.hijauTuaSecondary,
                      child: Text('kembali'),
                      handler: () {}),
                ),
                
                
                const SizedBox(height: 36),
              ],
            ),
          ),
        ));
  }
}
