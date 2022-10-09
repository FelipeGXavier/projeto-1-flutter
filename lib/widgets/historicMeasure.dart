import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart';

import '../services/databaseService.dart';
import 'bottomBar.dart';

class HistoricMeasure extends StatefulWidget {
  const HistoricMeasure({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HistoricMeasureState();
  }
}

class _HistoricMeasureState extends State {
  late List<MeasureData> _data = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    var db = DatabaseService();

    var result = await db.measures();

    setState(() => _data = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Histórico")),
      body: Column(children: [
        ListView.separated(
          padding: const EdgeInsets.only(top: 16.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.amber,
              child: Center(
                child: Column(children: [
                  Text("Idade: ${_data[index].age}"),
                  Text("Altura: ${_data[index].height}"),
                  Text("Peso: ${_data[index].weight}"),
                  Text(
                      "Sexo: ${_data[index].gender ? 'Masculino' : 'Feminino'}"),
                  Text("Data: ${_data[index].date}"),
                  Text("IMC: ${_data[index].imc}")
                ]),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
        const Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: BottomNav(),
          ),
        ),
      ]),
    );
  }
}

class MeasureData {
  late int? id;
  late int age;
  late int height;
  late bool gender;
  late double weight;
  late String date;
  late double imc;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender ? 1 : 0,
      'date': date,
      'imc': imc
    };
  }

  static MeasureData fromMap(Map<String, dynamic> map) {
    var measure = MeasureData();
    measure.id = map['id']?.toInt() ?? 0;
    measure.age = map['age'] ?? 0;
    measure.height = map['height'] ?? 0;
    measure.gender = map['gender'] == 0 ? false : true;
    measure.weight = map['weight'] ?? 0.0;
    measure.date = map['date'] ?? '';
    measure.imc = map['imc'] ?? 0.0;
    return measure;
  }
}
