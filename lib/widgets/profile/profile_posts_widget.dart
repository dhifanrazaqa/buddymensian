import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/post.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/services/post_services.dart';
import 'package:buddymensia/widgets/profile/post/post_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePostsWidget extends StatelessWidget {
  const ProfilePostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PostServices postProvider = Provider.of<PostServices>(context);
    List<Post?> posts = postProvider.getMyPosts();

    AuthService authProvider = Provider.of<AuthService>(context);
    User? user = authProvider.user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Postingan',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        posts.isEmpty ? Center(child: NoDataWidget(),) : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: posts.map((post) {
              return PostItemWidget(post: post!, fullname: user!.fullname!,);
            }).toList(),
          ),
        ),
      ],
    );
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
            textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.hijauTuaSecondary,
        )),
      ),
      Text(
        'Silahkan Tambahkan Data Yang Ditambahkan',
        style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        )),
      ),
    ],
  );
}