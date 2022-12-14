import 'package:flutter/material.dart';
import 'package:projeto_1/app.dart';
import 'package:projeto_1/widgets/splashScreen.dart';

void main() => runApp(const App());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Teste",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}
