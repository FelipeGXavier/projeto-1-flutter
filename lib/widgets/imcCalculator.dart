import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImcCalculator extends StatefulWidget {
  const ImcCalculator({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ImcCalculatorState();
  }
}

class _ImcCalculatorState extends State {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text("Calcular IMC")),
      body: ListView(
        children: <Widget>[
          GridView.count(
            childAspectRatio: (1 / .4),
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16.0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Idade'),
                onSaved: (newValue) => {},
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Altura (cm)'),
                onSaved: (newValue) => {},
              ),
              _genderSelector(),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Peso (kg)'),
                onSaved: (newValue) => {},
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () => {}, child: const Text("Calcular")),
          )
        ],
      ),
    ));
  }

  Widget _genderSelector() {
    return Row(
      children: [
        const Text("Gênero:   "),
        GestureDetector(
          onTap: () => setState(() => _value = 0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _value == 0 ? Colors.grey : Colors.transparent),
            height: 32,
            width: 32,
            child: Image.asset("assets/human-male.png", width: 32, height: 32),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => setState(() => _value = 1),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _value == 1 ? Colors.grey : Colors.transparent),
            height: 32,
            width: 32,
            child:
                Image.asset("assets/human-female.png", width: 32, height: 32),
          ),
        ),
      ],
    );
  }
}
