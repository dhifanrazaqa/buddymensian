import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/widgets/homepage/container_widget.dart';
import 'package:buddymensia/widgets/homepage/header_home_widget.dart';
import 'package:buddymensia/widgets/homepage/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AuthService authProvider = Provider.of<AuthService>(context);
    User? user = authProvider.user;

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 160,
        flexibleSpace:
            HeaderHomeWidget(name: user!.fullname!, username: user.email!),
      ),
      body: SingleChildScrollView(
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
                      value: '3'),
                  ContainerWidget(
                      width: width * 0.4,
                      title: 'Rutinitas Hari Ini',
                      value: '2'),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const SocialMediaPost(
                userName: 'Hadiano Sutomo',
                timeAgo: '10 mins ago',
                imageUrl:
                    'https://picsum.photos/seed/picsum/200/300', // Replace with actual image URL
                caption:
                    'Bahagia sekali, ulang tahun sederhana dengan anak dan cucu tercinta.',
                likes: 90,
                comments: 3,
                shares: 10,
              ),
              const SizedBox(
                height: 12,
              ),
              const SocialMediaPost(
                userName: 'Hadiano Sutomo',
                timeAgo: '10 mins ago',
                imageUrl:
                    'https://picsum.photos/seed/picsum/200/300', // Replace with actual image URL
                caption:
                    'Bahagia sekali, ulang tahun sederhana dengan anak dan cucu tercinta.',
                likes: 90,
                comments: 3,
                shares: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
