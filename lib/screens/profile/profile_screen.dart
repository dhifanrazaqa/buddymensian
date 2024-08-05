import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/widgets/profile/profile_header_widget.dart';
import 'package:buddymensia/widgets/profile/profile_posts_widget.dart';
import 'package:buddymensia/widgets/profile/profile_schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authProvider = Provider.of<AuthService>(context);
    User? user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Spacer(),
              CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  child: const Icon(
                    Icons.notifications,
                    color: AppColors.hijauTuaPrimary,
                  )),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeaderWidget(
                name: user!.fullname!,
              ),
              const ProfileScheduleWidget(),
              const ProfilePostsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
