import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:farmington/model/WeatherModel.dart';
import 'dart:convert';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late WeatherModel _weather;

  @override
  void initState() {
    getCurrentWeather();
    Timer.periodic(
        const Duration(seconds: 300), (timer) => getCurrentWeather());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          this._weather = snapshot.data as WeatherModel;
          if (this._weather == null) {
            return Text("Unable to retrive");
          } else {
            return weatherBox(_weather);
          }
        } else {
          return LoadingWeatherBox();
        }
      },
      future: getCurrentWeather(),
    );
  }
}

Widget LoadingWeatherBox() {
  return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
    Container(
        margin: const EdgeInsets.all(10.0),
        child: const Text(
          "Weather Barrie",
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

Widget weatherBox(WeatherModel _weather) {
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
                image: NetworkImage("https://static.wikia.nocookie.net/logopedia/images/3/37/Weatherios15beta.png/revision/latest?cb=20210625083003"),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(10.0),
                    child: const Text(
                      "Weather (Barrie)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          decoration: TextDecoration.none),
                    )),
                Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Text(
                      "${_weather.temp}°C",
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

Future getCurrentWeather() async {
  late WeatherModel weather;
  var url =
      "https://api.openweathermap.org/data/2.5/weather?q=barrie&units=metric&appid=c36ffcd6dbd3d32e3deb52499600743c";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    weather = WeatherModel.fromJson(jsonDecode(response.body));
  }

  return weather;
}