import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/guess_me.dart';
import 'package:buddymensia/screens/guessme/add_guess_me_screen.dart';
import 'package:buddymensia/screens/guessme/detail_guess_me_screen.dart';
import 'package:buddymensia/services/guessme_services.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GuessMeScreen extends StatelessWidget {
  const GuessMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GuessMeService guessMeProvider = Provider.of<GuessMeService>(context);
    List<GuessMe?> persons = guessMeProvider.items;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Spacer(),
                Column(
                  children: [
                    Text(
                      'Guess Me',
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                    ),
                    Text(
                      'Silahkan Tambahkan dan Pilih Data',
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )),
                    )
                  ],
                ),
                const Spacer(),
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
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 8,
                bottom: 16,
              ),
              child: persons.isEmpty ? Center(child: NoDataWidget()) : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: persons.map((person) {
                  return GuessMeGridView(person: person!);
                }).toList(),
              ),
            ),

            //Tampilan Ketika Tidak Ada Data
            // Center(
            //   child: NoDataWidget(),
            // ),

            //Btn Tambah Data
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: SizedBox(
                        width: 250,
                        height: 40,
                        child: PrimaryBtnWidget(
                          buttonText: 'Tambahkan Data Guess Me',
                          color: AppColors.hijauTuaSecondary,
                          handler: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const AddGuessMeScreen()));
                          },
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

Widget NoDataWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/nodata_illustration.png',
        height: 174,
      ),
      Text(
        'Belum Ada Data Yang Ditambahkan',
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.hijauTuaSecondary,
        )),
      ),
      Text(
        'Silahkan Tambahkan Data Yang Ditambahkan',
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        )),
      ),
    ],
  );
}

class GuessMeGridView extends StatelessWidget {
  final GuessMe person;
  const GuessMeGridView({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuessMeDetail(
              person: person,
            ),
          ),
        );
      },
      child: Card(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            person.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        person.nama!,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        )),
                      ),
                      Text(
                        person.status!,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.abuTua,
                        )),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
