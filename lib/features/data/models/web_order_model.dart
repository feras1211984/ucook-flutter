import 'dart:convert';
import 'package:ucookfrontend/features/data/models/web_order_detail_model.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';

class WebOrderModel extends WebOrder {
  WebOrderModel({
    required String deliveryAddress,
    required String orderStatus,
    required String remark,
    required String orderType,
    required List<WebOrderDetail> webOrderDetails,
    required String created_at,
    required int id,
    required String exported,
    required String updated_at,
  }) : super(
            id: id,
            deliveryAddress: deliveryAddress,
            orderStatus: orderStatus,
            orderType: orderType,
            remark: remark,
            webOrderDetails: webOrderDetails,
            created_at: created_at,
            exported: exported,
            updated_at: updated_at);

  factory WebOrderModel.fromJson(Map<String, dynamic> json) {
    return _$WebOrderModelFromJson(json);
  }

  Map<String, String> toBody() {
    return <String, String>{
      'id': this.id.toString(),
      'deliveryAddress': this.deliveryAddress,
      'orderStatus': this.orderStatus,
      'remark': this.remark,
      'orderType': this.orderType,
      'exported': this.exported.toString(),
      'created_at': this.created_at.toString(),
      'updated_at': this.updated_at.toString(),
      'webOrderDetails':
          jsonEncode(this.webOrderDetails.map((e) => e.toJson()).toList()),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'deliveryAddress': this.deliveryAddress,
      'orderStatus': this.orderStatus,
      'orderType': this.orderType,
      'remark': this.remark,
      'exported': this.exported.toString(),
      'created_at': this.created_at.toString(),
      'updated_at': this.updated_at.toString(),
      'webOrderDetails': this.webOrderDetails,
    };
  }
}

WebOrderModel _$WebOrderModelFromJson(Map<String, dynamic> jsonData) {
  List<WebOrderDetailModel> data = List<WebOrderDetailModel>.from(
      jsonData['web_order_details']
          .map((model) => WebOrderDetailModel.fromJson(model)));

  return WebOrderModel(
    remark: jsonData['remark'] == null ? "" : jsonData['remark'],
    deliveryAddress:
        jsonData['deliveryAddress'] == null ? "" : jsonData['deliveryAddress'],
    orderType: jsonData['orderType'] == null ? "" : jsonData['orderType'],
    orderStatus: jsonData['orderStatus'] == null ? "" : jsonData['orderStatus'],
    exported: jsonData['exported'] == null ? "" : jsonData['exported'],
    created_at: jsonData['created_at'] == null ? "" : jsonData['created_at'],
    updated_at: jsonData['updated_at'] == null ? "" : jsonData['updated_at'],
    id: jsonData['id'] == null ? "" : jsonData['id'],
    webOrderDetails: data,
  );
}
