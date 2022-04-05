import 'package:equatable/equatable.dart';

class WebOrderDetail extends Equatable {
  int quantity = 0;
  final int article_id;
  final double price;
  final String unitname;

  WebOrderDetail(
      {required this.unitname,
      required this.article_id,
      required this.price,
      required this.quantity});
  @override
  List<Object?> get props => [quantity, article_id, price, unitname];
  factory WebOrderDetail.fromJson(Map<String, dynamic> json) {
    return _$WebOrderDetailFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'article_id': article_id,
      'price': price,
      'unitname': unitname,
    };
  }
}

WebOrderDetail _$WebOrderDetailFromJson(Map<String, dynamic> json) {
  return WebOrderDetail(
      quantity:
          json['quantity'] == null ? 0 : int.parse(json['quantity'].toString()),
      article_id: json['article_id'] == null
          ? 0
          : int.parse(json['article_id'].toString()),
      price: json['price'] == null ? 0 : double.parse(json['price'].toString()),
      unitname: json['unitname'] == null ? "" : json['unitname']);
}
