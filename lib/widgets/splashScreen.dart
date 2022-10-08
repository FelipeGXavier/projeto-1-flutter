import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_1/widgets/imcCalculator.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Future.delayed(const Duration(seconds: 3)).then((_) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ImcCalculator()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.amber[200],
        child: Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset("assets/splash.png"),
          ),
        ));
  }
}
