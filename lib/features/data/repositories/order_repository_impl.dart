import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/core/error/exceptions.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/network/network_info.dart';
import 'package:ucookfrontend/features/data/datasources/ucook_remote_data_source.dart';
import 'package:ucookfrontend/features/data/models/web_order_model.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';
import 'package:ucookfrontend/features/domain/repositories/order_repository.dart';

typedef Future<List<WebOrder>> _OrderChooser();
typedef Future<WebOrder> _OrderManager();

class OrderRepositoryImpl implements OrderRepository {
  final UcookRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<WebOrder>>> getAllOrders(int page) async {
    return await _getOrders(() {
      return remoteDataSource.getAllOrders(page);
    });
  }

  @override
  Future<Either<Failure, WebOrder>> storeOrder(WebOrderModel params) async {
    // return await _storeOrder(() => remoteDataSource.storeWebOrder(params));
    return await _getOrder(() {
      return remoteDataSource.storeWebOrder(params);
    });
  }

  Future<Either<Failure, WebOrder>> _getOrder(
    _OrderManager getOrders,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await getOrders();
        return Right(remoteOrders);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, List<WebOrder>>> _getOrders(
    _OrderChooser getOrders,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await getOrders();
        return Right(remoteOrders);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }
}
