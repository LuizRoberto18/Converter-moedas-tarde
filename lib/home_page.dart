import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  double dolar;
  double euro;
  double libra;

  TextEditingController realCtrl = TextEditingController();
  TextEditingController dolarCtrl = TextEditingController();
  TextEditingController euroCtrl = TextEditingController();
  TextEditingController libraCtrl = TextEditingController();

  void _converterReal(String text) {
    double real = double.parse(text);
    dolarCtrl.text = (real / dolar).toStringAsPrecision(2);
    euroCtrl.text = (real / euro).toStringAsPrecision(2);
    libraCtrl.text = (real /libra).toStringAsPrecision(2);
  }

  void _converterDolar(String text) {
    double dolar = double.parse(text);
    realCtrl.text = (dolar * this.dolar).toStringAsPrecision(2);
    euroCtrl.text = (dolar * this.dolar / euro).toStringAsPrecision(2);
    libraCtrl.text = (dolar * this.dolar / libra).toStringAsPrecision(2);

  }

  void _converterEuro(String text) {
    double euro = double.parse(text);
    realCtrl.text = (euro * this.euro).toStringAsPrecision(2);
    dolarCtrl.text = (euro * this.euro / dolar).toStringAsPrecision(2);
    libraCtrl.text = (euro * this.euro / libra).toStringAsPrecision(2);
  }
  
  void _converterLibra(String text){
    double libra = double.parse(text);
    realCtrl.text = (libra * this.libra).toStringAsPrecision(2);
    dolarCtrl.text = (libra * this.libra / dolar).toStringAsPrecision(2);
    euroCtrl.text = (libra * this.libra / euro).toStringAsPrecision(2);

  }

  void _resetarInputs() {
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      realCtrl.clear();
      dolarCtrl.clear();
      euroCtrl.clear();
    });
  }


  Widget campoDeTexto(
    String label, String prefix, TextEditingController control, Function f) {
  return TextField(
    controller: control,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

Future<Map> getDados() async {
  String url = "https://api.hgbrasil.com/finance?key=42839985";
  var response = await http.get(url);

  return convert.json.decode(response.body);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          "\$ Conversor \$",
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      body: FutureBuilder<Map>(
          future: getDados(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados... ",
                    style: TextStyle(color: Colors.green, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados... ",
                      style: TextStyle(color: Colors.green, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.copyright,
                          size: 180.0,
                          color: Colors.green,
                        ),
                        campoDeTexto(
                            "Reais", "R\$ ", realCtrl, _converterReal),
                        Divider(),
                        campoDeTexto(
                            "Dólares", "US\$ ", dolarCtrl, _converterDolar),
                        Divider(),
                        campoDeTexto(
                            "Euros", "€ ", euroCtrl, _converterEuro),
                          campoDeTexto("Libra", "♎", libraCtrl, _converterLibra),
                          Divider(),
                            RaisedButton(
              onPressed: () {
                _resetarInputs();
              }
                            )
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}
