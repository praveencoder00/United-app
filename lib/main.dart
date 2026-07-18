import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:united_app/firebase_options.dart';
import 'package:united_app/pages/completed_page.dart';
import 'package:united_app/pages/invoice_preview_page.dart';
import 'package:united_app/pages/machine_detail_page.dart';
import 'package:united_app/pages/customer_worklog_page.dart';
import 'package:united_app/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:united_app/pages/billwgst_page.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
         textTheme: GoogleFonts.robotoSlabTextTheme(),
      ),
      home: HomePage(),
    ); 
  }
}

