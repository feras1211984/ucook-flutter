import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/features/data/models/mobileUser_model.dart';
import 'package:ucookfrontend/features/data/models/verification_code_model.dart';
import 'package:ucookfrontend/features/domain/usecases/confirm_verification_code.dart';
import 'package:ucookfrontend/features/domain/usecases/login.dart';
import 'package:ucookfrontend/features/domain/usecases/register.dart';
import '../../../core/error/failures.dart';

abstract class MobileUserRepository {
  Future<Either<Failure, MobileUser>> logIn(LoginUserInfoParams mobileUser);
  Future<Either<Failure, MobileUser>> register(
      RegisterUserInfoParams mobileUser);
  Future<Either<Failure, VerificationCodeModel>> sendVCode(
      ConfirmVCodeParams mobileUser);
  Future<bool> isValidToken();
}
