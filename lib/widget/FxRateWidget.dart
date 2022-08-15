import 'dart:async';

import 'package:farmington/model/FxRateModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


//FXRate widget
class FxRateWidget extends StatefulWidget {
  const FxRateWidget({super.key});

  @override
  _FxRateWidgetState createState() => _FxRateWidgetState();
}

class _FxRateWidgetState extends State<FxRateWidget> {
  late FxRateModel _fxRate;

  @override
  void initState() {
    getFxRate();
    Timer.periodic(
        const Duration(seconds: 300), (timer) => getFxRate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          this._fxRate = snapshot.data as FxRateModel;
          if (this._fxRate == null) {
            return LoadingFxRateBox();
          } else {
            return FxRateBox(_fxRate);
          }
        } else {
          return LoadingFxRateBox();
        }
      },
      future: getFxRate(),
    );
  }
}

//loading view
Widget LoadingFxRateBox() {
  return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
    Container(
        margin: const EdgeInsets.all(10.0),
        child: const Text(
          "Exchange Rate (CAD/USD)",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
              decoration: TextDecoration.none),
        )),
    Container(
      child : CircularProgressIndicator()
    )
  ]);
}

Widget FxRateBox(FxRateModel _fxRate) {
  return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
    Container(
        margin: const EdgeInsets.all(10.0),
        child: const Text(
          "Exchange Rate (CAD/USD)",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
              decoration: TextDecoration.none),
        )),
    Container(
        margin: const EdgeInsets.all(10.0),
        child: Text(
          "${_fxRate.rate}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xFF00C853)),
        )),
  ]);
}

Future getFxRate() async {
  var url =
      "https://rest.coinapi.io/v1/exchangerate/USD/CAD";
  final response = await http.get(Uri.parse(url), headers: {
    "X-CoinAPI-Key": "2F4CCEDF-DF3E-40E3-AA1E-23720C0EC4E4"
    }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return FxRateModel.fromJson(jsonDecode(response.body));
  }
  else{
    print(response.body.toString());
  }

  return null;
}