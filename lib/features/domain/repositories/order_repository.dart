import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/features/data/models/web_order_model.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';

import '../../../core/error/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<WebOrder>>> getAllOrders(int page);
  Future<Either<Failure, WebOrder>> storeOrder(WebOrderModel params);
}
