import 'package:flutter/material.dart';
import 'package:projeto_1/widgets/splashScreen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const Splash(),
      },
    );
  }
}