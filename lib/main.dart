import 'package:buddymensia/colors.dart';
import 'package:buddymensia/firebase_options.dart';
import 'package:buddymensia/screens/auth/login_screen.dart';
import 'package:buddymensia/screens/main_screen.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    AuthService().isUserLoggedIn().then((result) {
      setState(() {
        isLoggedIn = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Buddymensia',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            surface: AppColors.putihLatar,
            primary: AppColors.hijauTuaPrimary,
          ),
          useMaterial3: true,
        ),
        home: isLoggedIn ? const MainScreen() : const LoginScreen(),
      ),
    );
  }
}
