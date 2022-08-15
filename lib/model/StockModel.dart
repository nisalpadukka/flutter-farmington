//Data source object for stock info widget
class StockModel {
  final double price;
  final String time;

  StockModel(
      {required this.price,
        required this.time});
  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      price: json['c'].toDouble(),
      time: json['t'].toString(),
    );
  }
}