


import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/core/error/exceptions.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/network/network_info.dart';
import 'package:ucookfrontend/features/data/datasources/ucook_remote_data_source.dart';
import 'package:ucookfrontend/features/domain/entities/promos.dart';
import 'package:ucookfrontend/features/domain/repositories/promos_repository.dart';

typedef Future<List<Promos>> _PromosChooser();
class PromosRepositoryImpl implements PromosRepository
{
  final UcookRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  PromosRepositoryImpl(
  {
    required this.networkInfo,
    required this.remoteDataSource
  });
  @override
  Future<Either<Failure, List<Promos>>> getPromos() async {
    return await _getPromos(() {
      return remoteDataSource.getPromoses();
    });
  }
  Future<Either<Failure, List<Promos>>> _getPromos(
      _PromosChooser getPromos,
      ) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePromos= await getPromos();
        return Right(remotePromos);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }
}