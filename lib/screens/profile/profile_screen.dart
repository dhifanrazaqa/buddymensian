import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/screens/auth/login_screen.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
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
                  backgroundColor: user!.role == 'user' ? Colors.blue[50] : Colors.purple[50],
                  child: Icon(
                    Icons.notifications,
                    color: user.role == 'user' ? AppColors.hijauTuaPrimary : AppColors.unguCaregiver,
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
                name: user.fullname!,
                isUser: user.role == 'user',
              ),
              ProfileScheduleWidget(isUser: user.role == 'user',),
              const ProfilePostsWidget(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 40,
                  child: PrimaryBtnWidget(
                      buttonText: user.role != 'user' ? 'Mode Penderita' : 'Mode Caregiver',
                      color: user.role != 'user' ? AppColors.hijauTuaSecondary: AppColors.unguCaregiver,
                      handler: () async {
                        await authProvider.changeMode(user.role != 'user' ? 'user' : 'caregiver');
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: SizedBox(
                  height: 40,
                  child: PrimaryBtnWidget(
                      buttonText: 'Logout',
                      color: user.role == 'user' ? AppColors.hijauTuaSecondary : AppColors.unguCaregiver,
                      handler: () async {
                        await authProvider.signOut();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }),
                ),
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
