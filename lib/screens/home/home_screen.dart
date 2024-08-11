import 'package:buddymensia/models/post.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/services/jadwal_services.dart';
import 'package:buddymensia/services/post_services.dart';
import 'package:buddymensia/widgets/homepage/container_widget.dart';
import 'package:buddymensia/widgets/homepage/header_home_widget.dart';
import 'package:buddymensia/widgets/homepage/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _refresh() async {
    await Provider.of<PostServices>(context, listen: false).fetchData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AuthService authProvider = Provider.of<AuthService>(context);
    User? user = authProvider.user;

    PostServices postProvider = Provider.of<PostServices>(context);
    List<Post?> posts = postProvider.items;

    JadwalServices jadwalProvider = Provider.of<JadwalServices>(context);
    int countRutinitas = jadwalProvider.items
        .where((jadwal) =>
            jadwal.tipe == 'Rutinitas' &&
            isSameDay(DateTime.now(), jadwal.eventAt))
        .length;
    int countKegiatan = jadwalProvider.items
        .where((jadwal) =>
            jadwal.tipe == 'Kegiatan' &&
            isSameDay(DateTime.now(), jadwal.eventAt))
        .length;

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 160,
        flexibleSpace:
            HeaderHomeWidget(name: user!.fullname!, username: user.email!),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ContainerWidget(
                      width: width * 0.4,
                      title: 'Kegiatan Hari Ini',
                      value: countKegiatan.toString(),
                      role: user.role!,
                    ),
                    ContainerWidget(
                      width: width * 0.4,
                      title: 'Rutinitas Hari Ini',
                      value: countRutinitas.toString(),
                      role: user.role!,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Column(
                  children: posts.map((post) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        SocialMediaPost(
                          post: post!,
                          likes: 90,
                          comments: 3,
                          shares: 10,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
