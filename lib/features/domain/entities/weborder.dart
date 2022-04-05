import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';

class WebOrder extends Equatable {
  final int id;
  final String deliveryAddress;
  final String orderStatus;
  late String remark;
  final String orderType;
  final List<WebOrderDetail> webOrderDetails;
  final String created_at;
  final String exported;
  final String updated_at;
  late bool expanded = false;

  WebOrder({
    required this.id,
    required this.deliveryAddress,
    required this.orderStatus,
    required this.orderType,
    required this.remark,
    required this.webOrderDetails,
    required this.created_at,
    required this.updated_at,
    required this.exported,
  });

  @override
  List<Object> get props => [
        id,
        deliveryAddress,
        orderType,
        orderStatus,
        remark,
        webOrderDetails,
        exported,
        created_at,
        updated_at
      ];
}
