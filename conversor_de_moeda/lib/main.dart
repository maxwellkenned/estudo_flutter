import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance/quotations?format=json&key=08570500";
void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    double valor = double.parse(text);
    dolarController.text = (valor/dolar).toStringAsFixed(2);
    euroController.text = (valor/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double valor = double.parse(text);
    realController.text = (valor*dolar).toStringAsFixed(2);
    euroController.text = ((valor*dolar)/euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double valor = double.parse(text);
    realController.text = (valor*euro).toStringAsFixed(2);
    dolarController.text = ((valor*euro)/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "\$ Conversor de Moedas \$",
          style: TextStyle(color: Colors.black, fontSize: 25.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },)
        ],
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch(snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError || snapshot.data["status"] != null) {
                  return mensagemErro();
                }

                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      buildTextField("Reais", "R\$ ", realController, _realChanged),
                      Divider(),
                      buildTextField("Dólares", "U\$ ", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euros", "\€U ", euroController, _euroChanged)
                    ],
                  ),
                );
            }
          }),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return jsonDecode(response.body);
}


Widget mensagemErro() {
  return Center(
    child: Text(
      "Erro ao carregar dados :(",
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      textAlign: TextAlign.center,
    ),
  );
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function f) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
  );
}