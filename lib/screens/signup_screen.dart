import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:holiday_flutter/resources/auth_methods.dart';
import 'package:holiday_flutter/responsive/mobile_screen_layout.dart';
import 'package:holiday_flutter/responsive/responsive.dart';
import 'package:holiday_flutter/responsive/web_screen_layout.dart';
import 'package:holiday_flutter/screens/login_screen.dart';
import 'package:holiday_flutter/utils/colors.dart';
import 'package:holiday_flutter/utils/utils.dart';
import 'package:holiday_flutter/widgets/text_field_input.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);

    // if string returned is success, 
    // user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });

      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  // function for selected image from gallary
  void selectImage() async {
    //im = image gallery
    Uint8List im = await pickImage(ImageSource.gallery);

    // set state because we need to d
    // isplay the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  void navigateToLogin(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //flex layout
            Flexible(
              child: Container(),
              flex: 2,
            ),
            //svg iamge
            // SvgPicture.asset(
            //   'assets/icons/holiday_texture-01.svg',
            //   color: primaryColor,
            //   height: 128,
            // ),
            const SizedBox(height: 64),
            // circle widget
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: Colors.red,
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg'),
                        backgroundColor: Colors.red,
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 24,
            ),

            //text username
            TextFieldInput(
              textEditingController: _usernameController,
              hintText: 'username',
              textInputType: TextInputType.text,
            ),
            const SizedBox(
              height: 24,
            ), //space
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
            //text biro
            TextFieldInput(
              textEditingController: _bioController,
              hintText: 'bio',
              textInputType: TextInputType.text,
            ),
            const SizedBox(
              height: 24,
            ), //space

            //button
            InkWell(
              // onTap: () async {
              //   String res = await AuthMethods().signUpUser(
              //     email: _emailController.text,
              //     password: _passwordController.text,
              //     username: _usernameController.text,
              //     bio: _bioController.text,
              //   );
              //   // ignore: avoid_print
              //   print(res);
              // },

              child: Container(
                child: !_isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                      )
                      : const Text('Sign up'),
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

            //singing up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text("Have account alreday?",
                  style: TextStyle(color: Colors.grey)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  // onTap: () => Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const LoginScreen(),
                  //   ),
                  // ),
                  onTap: navigateToLogin,
                  child: Container(
                    child: const Text(
                      " Login",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
