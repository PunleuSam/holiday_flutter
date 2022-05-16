import 'package:flutter/material.dart';
import 'package:holiday_flutter/resources/auth_methods.dart';
import 'package:holiday_flutter/responsive/mobile_screen_layout.dart';
import 'package:holiday_flutter/responsive/responsive.dart';
import 'package:holiday_flutter/responsive/web_screen_layout.dart';
import 'package:holiday_flutter/screens/signup_screen.dart';
import 'package:holiday_flutter/utils/colors.dart';
import 'package:holiday_flutter/utils/global_variable.dart';
import 'package:holiday_flutter/utils/utils.dart';

import '../widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  //func login user
  void loginUser() async {
    setState(() {
      _isLoading = false;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    // check if success move on
    // else fall
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,

        // padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //flex layout
            Flexible(
              child: Container(),
              flex: 2,
            ),
            //image
            Image.asset(
              "assets/images/holiday_textAsset 1xxxhdpi.png",
              height: 100,
            ),
            const SizedBox(height: 24),
            //text email
            TextFieldInput(
              textEditingController: _emailController,
              hintText: 'email',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 24,
            ), //space
            //text pass
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'password',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 24,
            ), //space

            //button
            InkWell(
              onTap: loginUser,
              child: Container(
                child: !_isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text(
                        'Login',
                      ),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: buttonColor,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ), //space
            Flexible(
              child: Container(),
              flex: 2,
            ),

            //don't have account yet
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text(
                    "Don't have account yet?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  ),
                  child: Container(
                    child: const Text(
                      " Sign up",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
