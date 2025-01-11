import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';

import 'screens/splashscreen.dart';
void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return Sizer( 
  builder: (context, orientation, screenType) {
      return MaterialApp( 
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.ibmPlexSansTextTheme()),
        home: const SplashScreen()
      );
  });
    
    }
} 