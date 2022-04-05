import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';

class WebOrderDetailModel extends WebOrderDetail {
  WebOrderDetailModel({
    required int quantity,
    required int article_id,
    required double price,
    required String unitname,
  }) : super(
          article_id: article_id,
          price: price,
          quantity: quantity,
          unitname: unitname,
        );
  factory WebOrderDetailModel.fromJson(Map<String, dynamic> json) {
    return _$WebOrderDetailModelFromJson(json);
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

WebOrderDetailModel _$WebOrderDetailModelFromJson(Map<String, dynamic> json) {
  return WebOrderDetailModel(
      quantity: json['quantity'] == null
          ? 0
          : double.parse(json['quantity'].toString()).toInt(),
      article_id: json['article_id'] == null
          ? 0
          : int.parse(json['article_id'].toString()),
      price: json['price'] == null ? 0 : double.parse(json['price'].toString()),
      unitname: json['unitname'] == null ? "" : json['unitname']);
}
