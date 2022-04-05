import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/usecases/usecase.dart';
import 'package:ucookfrontend/features/data/models/web_order_model.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';
import 'package:ucookfrontend/features/domain/repositories/order_repository.dart';

class OrderUseCase implements UseCase<WebOrder, WebOrderModel> {
  final OrderRepository repository;

  OrderUseCase(this.repository);

  @override
  Future<Either<Failure, WebOrder>> call(WebOrderModel params) async {
    return await repository.storeOrder(params);
  }

  Future<Either<Failure, WebOrder>> storeOrder(WebOrderModel params) async {
    return await repository.storeOrder(params);
  }

  Future<Either<Failure, List<WebOrder>>> getAllOrders(int page) async {
    return await repository.getAllOrders(page);
  }
}
