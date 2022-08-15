class FxRateModel {
  final double rate;
  final String time;

  FxRateModel(
      {required this.rate,
        required this.time});
  factory FxRateModel.fromJson(Map<String, dynamic> json) {
    return FxRateModel(
      rate: json['rate'].toDouble(),
      time: json['time'].toString(),
    );
  }
}