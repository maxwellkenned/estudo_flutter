import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _textInfo = "Informe seus dados!";

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _textInfo = "Informe seus dados!";
      _resetFocus();
    });
  }

  void _calcularIMC() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100;
    double imc = weight / pow(height, 2);
    setState(() {
      _setInfoImc(imc);
      _resetFocus();
    });
  }

  void _resetFocus() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
  void _setInfoImc(double imc) {
    if (imc < 18.5) {
      _textInfo =
          "IMC (${imc.toStringAsFixed(2)})\nVocê está abaixo do peso ideal!";
      return;
    }
    if (imc < 25.0) {
      _textInfo =
          "IMC (${imc.toStringAsFixed(2)})\nParábens você está no seu peso ideal!";
      return;
    }
    if (imc < 30.0) {
      _textInfo =
          "IMC (${imc.toStringAsFixed(2)})\nVocê está acima do seus peso!";
      return;
    }
    if (imc < 35.0) {
      _textInfo = "IMC (${imc.toStringAsFixed(2)})\nObesidade grau I";
      return;
    }
    if (imc < 40.0) {
      _textInfo = "IMC (${imc.toStringAsFixed(2)})\nObesidade grau II";
      return;
    }
    _textInfo = "IMC (${imc.toStringAsFixed(2)})\nObesidade grau III";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora de IMC"),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.person_outline, size: 150.0, color: Colors.green),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle: TextStyle(color: Colors.green, fontSize: 25.0)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                  controller: weightController,
                  validator: (value){
                    if(value.isEmpty){
                     return "Insira seu Peso!";
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Altura (cm)",
                      labelStyle: TextStyle(color: Colors.green, fontSize: 25.0)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                  controller: heightController,
                  validator: (value){
                    if(value.isEmpty){
                      return "Insira sua Altura!";
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                  child: Container(
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: () {
                          if(_formKey.currentState.validate()) {
                            _calcularIMC();
                          }
                        },
                        child: Text(
                          "Calcular",
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                        color: Colors.green,
                      )),
                ),
                Text(
                  _textInfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                )
              ],
            ),
          ),
        ));
  }
}
