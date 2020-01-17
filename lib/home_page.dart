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
  double pesoArgentino;
  double bitcoin;

  TextEditingController realCtrl = TextEditingController();
  TextEditingController dolarCtrl = TextEditingController();
  TextEditingController euroCtrl = TextEditingController();
  TextEditingController libraCtrl = TextEditingController();
  TextEditingController pesoArgentinoCtrl = TextEditingController();
  TextEditingController bitcoinCtrl = TextEditingController();

  void _converterReal(String text) {
    double real = double.parse(text);
    dolarCtrl.text = (real / dolar).toStringAsPrecision(2);
    euroCtrl.text = (real / euro).toStringAsPrecision(2);
    libraCtrl.text = (real / libra).toStringAsPrecision(2);
    pesoArgentinoCtrl.text = (real / pesoArgentino).toStringAsPrecision(4);
    bitcoinCtrl.text = (real / bitcoin).toStringAsPrecision(2);
  }

  void _converterDolar(String text) {
    double dolar = double.parse(text);
    realCtrl.text = (dolar * this.dolar).toStringAsPrecision(3);
    euroCtrl.text = (dolar * this.dolar / euro).toStringAsPrecision(3);
    libraCtrl.text = (dolar * this.dolar / libra).toStringAsPrecision(3);
    pesoArgentinoCtrl.text =
        (dolar * this.dolar / pesoArgentino).toStringAsPrecision(3);
    bitcoinCtrl.text = (dolar * this.dolar / bitcoin).toStringAsPrecision(2);
  }

  void _converterEuro(String text) {
    double euro = double.parse(text);
    realCtrl.text = (euro * this.euro).toStringAsPrecision(3);
    dolarCtrl.text = (euro * this.euro / dolar).toStringAsPrecision(3);
    libraCtrl.text = (euro * this.euro / libra).toStringAsPrecision(2);
    pesoArgentinoCtrl.text =
        (euro * this.euro / pesoArgentino).toStringAsPrecision(4);
    bitcoinCtrl.text = (euro * this.euro / bitcoin).toStringAsPrecision(2);
  }

  void _converterLibra(String text) {
    double libra = double.parse(text);
    realCtrl.text = (libra * this.libra).toStringAsPrecision(3);
    dolarCtrl.text = (libra * this.libra / dolar).toStringAsPrecision(3);
    euroCtrl.text = (libra * this.libra / euro).toStringAsPrecision(3);
    pesoArgentinoCtrl.text =
        (libra * this.libra / pesoArgentino).toStringAsPrecision(4);
    bitcoinCtrl.text = (libra * this.libra / bitcoin).toStringAsPrecision(4);
  }

  void _converterPesoArgetino(String text) {
    double pesoArgentino = double.parse(text);
    realCtrl.text = (pesoArgentino * this.pesoArgentino).toStringAsPrecision(2);
    dolarCtrl.text =
        (pesoArgentino * this.pesoArgentino / dolar).toStringAsPrecision(2);
    euroCtrl.text =
        (pesoArgentino * this.pesoArgentino / euro).toStringAsPrecision(2);
    libraCtrl.text =
        (pesoArgentino * this.pesoArgentino / libra).toStringAsPrecision(2);
    bitcoinCtrl.text =
        (pesoArgentino * this.pesoArgentino / bitcoin).toStringAsPrecision(2);
  }

  void _converterBitcoin(String text) {
    double bitcoin = double.parse(text);
    realCtrl.text = (bitcoin * this.bitcoin).toStringAsPrecision(9);
    dolarCtrl.text = (bitcoin * this.bitcoin / dolar).toStringAsPrecision(9);
    euroCtrl.text = (bitcoin * this.bitcoin / euro).toStringAsPrecision(9);
    libraCtrl.text = (bitcoin * this.bitcoin / libra).toStringAsPrecision(9);
    pesoArgentinoCtrl.text =
        (bitcoin * this.bitcoin / pesoArgentino).toStringAsPrecision(9);
  }

  void _resetarInputs() {
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      realCtrl.clear();
      dolarCtrl.clear();
      euroCtrl.clear();
      libraCtrl.clear();
      pesoArgentinoCtrl.clear();
      bitcoinCtrl.clear();
    });
  }

  Widget campoDeTexto(
      String label, String prefix, TextEditingController controlador, Function funcao) {
    return TextField(
      controller: controlador,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green),
        border: OutlineInputBorder(),
        prefixText: prefix,
        prefixStyle: TextStyle(color: Colors.green),
      ),
      style: TextStyle(
        color: Colors.green,
        fontSize: 25.0,
      ),
      onChanged: funcao,
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
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "\$ Conversor \$",
          style: TextStyle(fontSize: 25.0),
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
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
                  pesoArgentino =
                      snapshot.data["results"]["currencies"]["ARS"]["buy"];
                  bitcoin =
                      snapshot.data["results"]["currencies"]["BTC"]["buy"];

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
                          "Reais",
                          "R\$: ",
                          realCtrl,
                          _converterReal,
                        ),
                        Divider(),
                        campoDeTexto(
                          "Dólares",
                          " US\$: ",
                          dolarCtrl,
                          _converterDolar,
                        ),
                        Divider(),
                        campoDeTexto(
                          "Euros",
                          "  €: ",
                          euroCtrl,
                          _converterEuro,
                        ),
                        Divider(),
                        campoDeTexto(
                          "Libra",
                          " £: ",
                          libraCtrl,
                          _converterLibra,
                        ),
                        Divider(),
                        campoDeTexto(
                          "Peso Argetino",
                          " \$: ",
                          pesoArgentinoCtrl,
                          _converterPesoArgetino,
                        ),
                        Divider(),
                        campoDeTexto(
                          "Bitcoin",
                          " btc: ",
                          bitcoinCtrl,
                          _converterBitcoin,
                        ),
                        Divider(),
                        RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              "Limpar campos",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.green,
                            onPressed: () {
                              _resetarInputs();
                            })
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}
