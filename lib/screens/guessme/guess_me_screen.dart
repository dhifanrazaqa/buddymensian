import 'package:buddymensia/colors.dart';
import 'package:buddymensia/screens/guessme/add_guess_me_screen.dart';
import 'package:buddymensia/screens/guessme/detail_guess_me_screen.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuessMeScreen extends StatelessWidget {
  const GuessMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                left: 8,
                right: 8,
                top: 8,
                bottom: 16,
              ),
              child: Center(
                child: GuessMeGridView(),
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

class GuessMeGridView extends StatefulWidget {
  const GuessMeGridView({Key? key}) : super(key: key);

  @override
  State<GuessMeGridView> createState() => _GuessMeGridViewState();
}

class _GuessMeGridViewState extends State<GuessMeGridView> {
  List<Map<String, String>> items = [
    {
      "name": "Alice",
      "relation": "teman",
      "photo": "assets/images/logo/Logo v1.png"
    },
    {
      "name": "Bob",
      "relation": "teman",
      "photo": "assets/images/addphoto_Illustration.png"
    },
    {
      "name": "Charlie",
      "relation": "teman",
      "photo": "assets/images/nodata_illustration.png"
    },
    {
      "name": "David",
      "relation": "teman",
      "photo": "assets/images/placeholder_guessme.png"
    },
    {
      "name": "Eve",
      "relation": "teman",
      "photo": "assets/images/placeholder_guessme.png"
    },
    {
      "name": "Frank",
      "relation": "teman",
      "photo": "assets/images/placeholder_guessme.png"
    },
    {
      "name": "Alice",
      "relation": "teman",
      "photo": "assets/images/logo/Logo v1.png"
    },
    {
      "name": "Bob",
      "relation": "teman",
      "photo": "assets/images/addphoto_Illustration.png"
    },
    {
      "name": "Charlie",
      "relation": "teman",
      "photo": "assets/images/nodata_illustration.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuessMeDetail(
                  item: items[index],
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
                              child: Image.asset(
                                items[index]['photo']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            items[index]['name']!,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            )),
                          ),
                          Text(
                            items[index]['relation']!,
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
      },
    );
  }
}

