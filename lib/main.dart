import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrms/start_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAUeoTlslUtZNspaBLEQzISoMNXHUjaHrY",
            authDomain: "hrms-b2fce.firebaseapp.com",
            projectId: "hrms-b2fce",
            storageBucket: "hrms-b2fce.firebasestorage.app",
            messagingSenderId: "833957864007",
            appId: "1:833957864007:web:2381da42609002b1984762",
            measurementId: "G-NFBG2K4GBK"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}
