//Data source object for weather widget
class WeatherModel {
  final double temp;
  WeatherModel(
      {required this.temp});
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temp: json['main']['temp'].toDouble()
    );
  }
}