import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:holiday_flutter/providers/user_provider.dart';
import 'package:holiday_flutter/responsive/mobile_screen_layout.dart';
import 'package:holiday_flutter/responsive/responsive.dart';
import 'package:holiday_flutter/responsive/web_screen_layout.dart';
import 'package:holiday_flutter/screens/login_screen.dart';
import 'package:holiday_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {

  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  //make sure firebase is initial
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAO9V8vb3y-vOfnMqbUzhskO0OQGlDuHpc",
        authDomain: "holiday-data-c5f3e.firebaseapp.com",
        projectId: "holiday-data-c5f3e",
        storageBucket: "holiday-data-c5f3e.appspot.com",
        messagingSenderId: "840046796627",
        appId: "1:840046796627:web:3412dce3dc994a6b4e0ba6",
        measurementId: "G-ZZ1NF7SNN1"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Holiday',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user 
                // is logged in then we check the width of screen 
                // and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
