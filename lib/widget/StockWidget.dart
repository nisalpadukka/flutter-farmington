import 'dart:async';

import 'package:farmington/model/StockModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


//Stock widget with image
class StockWidget extends StatefulWidget {
  const StockWidget({super.key});

  @override
  _StockModelState createState() => _StockModelState();
}

class _StockModelState extends State<StockWidget> {
  late StockModel _stockModel;

  @override
  void initState() {
    getStockInfo();
    Timer.periodic(
        const Duration(seconds: 300), (timer) => getStockInfo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot != null) {
          this._stockModel = snapshot.data as StockModel;
          if (this._stockModel == null) {
            return LoadingStockBox();
          } else {
            return StockBox(_stockModel);
          }
        } else {
          return LoadingStockBox();
        }
      },
      future: getStockInfo(),
    );
  }
}

//processing view
Widget LoadingStockBox() {
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

Widget StockBox(StockModel _stockModel) {
  return Container(
    margin: const EdgeInsets.all(12.0),
    color:Colors.white,
    child: (
        Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                height: 50,
                width: 50,
                image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/976px-Apple_logo_black.svg.png"),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Apple Stock Price",
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
                      "${_stockModel.price} USD",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xFF00C853)),
                    )),
                const Divider(
                  color: Colors.black,
                )
              ],
            )
          ],
        )
    ),
  );
}

Future getStockInfo() async {
  late StockModel fxRateModel;
  var url =
      "https://finnhub.io/api/v1/quote?symbol=AAPL";
  final response = await http.get(Uri.parse(url), headers: {
    "X-Finnhub-Token": "cbsjd82ad3i9sd7nbth0"
    }
  );

  if (response.statusCode == 200) {
    print(response.body);
    fxRateModel = StockModel.fromJson(jsonDecode(response.body));
  }

  return fxRateModel;
}