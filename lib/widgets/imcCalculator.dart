import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_1/services/databaseService.dart';
import 'package:projeto_1/widgets/historicMeasure.dart';

import 'bottomBar.dart';

class ImcCalculator extends StatefulWidget {
  const ImcCalculator({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ImcCalculatorState();
  }
}

class _ImcCalculatorState extends State {
  int _value = 0;
  int _age = 0;
  double _weight = 0.0;
  int _height = 0;
  double _imc = 0.0;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Calcular IMC")),
        body: Column(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: GridView.count(
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
                          onSaved: (newValue) {
                            _age = int.parse(newValue.toString());
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(hintText: 'Altura (cm)'),
                          onSaved: (newValue) {
                            _height = int.parse(newValue.toString());
                          },
                        ),
                        _genderSelector(),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(hintText: 'Peso (kg)'),
                          onSaved: (newValue) {
                            _weight = double.parse(newValue.toString());
                          },
                        ),
                      ],
                    )),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        _saveMeasure();
                      },
                      child: const Text("Calcular")),
                ),
                if (_imc > 0)
                  Center(
                    child: Text(
                      "IMC: ${_imc.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: _imcDataTable(),
                ),
              ],
            ),
            const Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: BottomNav(),
              ),
            ),
          ],
        ));
  }

  void _saveMeasure() async {
    DateTime now = DateTime.now();
    MeasureData measure = MeasureData();
    String formattedDate = DateFormat('dd/MM/yyyy – kk:mm').format(now);
    measure.age = _age;
    measure.height = _height;
    measure.weight = _weight;
    measure.gender = _value == 0 ? true : false;
    measure.date = formattedDate;
    setState(() {
      _imc = _getImc();
    });
    measure.imc = _imc;
    var db = DatabaseService();
    await db.inserMeasure(measure);
  }

  double _getImc() {
    return _weight / ((_height / 100) * (_height / 100));
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

  Widget _imcDataTable() {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Valor IMC',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Condição',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('< 18')),
            DataCell(Text('Abaixo do peso')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('18.5 - 25')),
            DataCell(Text('Pesoa ideal')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('25.1 - 30')),
            DataCell(Text('Sobrepeso')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('30.1 - 40')),
            DataCell(Text('Obesidade')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('> 40')),
            DataCell(Text('Obesidade severa')),
          ],
        ),
      ],
    );
  }
}
