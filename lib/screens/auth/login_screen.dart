import 'package:buddymensia/colors.dart';
import 'package:buddymensia/screens/auth/register_screen.dart';
import 'package:buddymensia/screens/main_screen.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/widgets/buttons/outlined_btn_widget.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:buddymensia/widgets/buttons/text_btn_widget.dart';
import 'package:buddymensia/widgets/textfields/general_textfield_widget.dart';
import 'package:buddymensia/widgets/textfields/secure_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  String errorMessage = '';

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final message = await AuthService().login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (message!.contains('Success')) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        setState(() {
          print(message);
          errorMessage = message;
        });
      }
    }
  }

  void loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    String? status = await AuthService().signInWithGoogle();
    Navigator.of(context).popUntil((route) => route.isFirst);
    print(status);
    if (status == 'Success Create') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                height: height * 0.05,
              ),
              Image.asset('assets/images/logo/Logo v1 - rounded.png'),
              Text(
                'Login',
                style: GoogleFonts.istokWeb(
                    fontSize: 24, fontWeight: FontWeight.w800),
              ),
              Row(
                children: [
                  Text(
                    "Belum punya akun,",
                    style: GoogleFonts.istokWeb(
                        fontSize: 14, color: Colors.grey[700]),
                  ),
                  TextBtnWidget(
                    text: 'Daftar Disini',
                    handler: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                    },
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    GeneralTextfieldWidget(
                      controller: _emailController,
                      labelText: 'Email ',
                      hintText: 'email@example.com',
                      inputType: TextInputType.emailAddress,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    SecureTextfieldWidget(
                      labelText: 'Password ',
                      hintText: 'Password',
                      inputType: TextInputType.text,
                      isRequired: true,
                      controller: _passwordController,
                      isObscured: _obscureText,
                      handler: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextBtnWidget(text: 'Lupa Password?', handler: () {})
                ],
              ),
              if (errorMessage != '')
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.hijauTuaSecondary,
                      ),
                    )
                  : Column(
                      children: [
                        PrimaryBtnWidget(
                          buttonText: 'Login',
                          color: AppColors.hijauTuaSecondary,
                          handler: login,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        OutlinedBtnWidget(
                          borderColor: Colors.grey,
                          handler: loginWithGoogle,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/logo/googleic.png',
                              ),
                              Text(
                                'Masuk dengan Google',
                                style: GoogleFonts.istokWeb(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: height * 0.15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RichText(
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  text: TextSpan(
                    style: GoogleFonts.istokWeb(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                        text: 'Dengan Login, Anda Menyetujui ',
                        style: GoogleFonts.istokWeb(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Kebijakan Privasi',
                        style: GoogleFonts.istokWeb(
                          color: AppColors.biruLink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' dan ',
                        style: GoogleFonts.istokWeb(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Syarat & Ketentuan',
                        style: GoogleFonts.istokWeb(
                          color: AppColors.biruLink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: GoogleFonts.istokWeb(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
