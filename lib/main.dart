import 'package:flutter/material.dart';
import 'package:quiz237/screens/audio_service.dart';
import 'package:quiz237/screens/start_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le service audio
  await AudioService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz237',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}