import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/features/data/datasources/ucook_remote_data_source.dart';
import 'package:ucookfrontend/features/data/models/mobileUser_model.dart';
import 'package:ucookfrontend/features/data/models/verification_code_model.dart';
import 'package:ucookfrontend/features/domain/repositories/mobile_user_repository.dart';
import 'package:ucookfrontend/features/domain/usecases/confirm_verification_code.dart';
import 'package:ucookfrontend/features/domain/usecases/login.dart';
import 'package:ucookfrontend/features/domain/usecases/register.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';

typedef Future<MobileUser> _UserManager();
typedef Future<VerificationCodeModel> _VCodeManager();

class MobileUserRepositoryImpl implements MobileUserRepository {
  final UcookRemoteDataSource loginDataSource;
  final NetworkInfo networkInfo;

  MobileUserRepositoryImpl(
      {required this.loginDataSource, required this.networkInfo});
  @override
  Future<bool> isValidToken() async {
    return await loginDataSource.isValidToken();
  }

  @override
  Future<Either<Failure, VerificationCodeModel>> sendVCode(
      ConfirmVCodeParams mobileUser) async {
    return await _sendVCode(() {
      return loginDataSource.sendVCode(mobileUser);
    });
  }

  @override
  Future<Either<Failure, MobileUser>> logIn(
      LoginUserInfoParams mobileUser) async {
    return await _login(() {
      return loginDataSource.getMobileUser(mobileUser);
    });
  }

  Future<Either<Failure, VerificationCodeModel>> _sendVCode(
    _VCodeManager _vCodeManager,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final userManager = await _vCodeManager();
        return Right(userManager);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, MobileUser>> _login(
    _UserManager _userManager,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final userManager = await _userManager();
        return Right(userManager);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, MobileUser>> register(
      RegisterUserInfoParams mobileUser) async {
    return await _register(() {
      return loginDataSource.regMobileUser(mobileUser);
    });
  }

  Future<Either<Failure, MobileUser>> _register(
    _UserManager _userManager,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final userManager = await _userManager();
        return Right(userManager);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }
}
