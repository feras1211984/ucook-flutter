import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/usecases/usecase.dart';
import 'package:ucookfrontend/features/data/models/mobileUser_model.dart';
import 'package:ucookfrontend/features/domain/repositories/mobile_user_repository.dart';

class LoginUseCase implements UseCase<MobileUser, LoginUserInfoParams> {
  final MobileUserRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, MobileUser>> call(LoginUserInfoParams params) async {
    return await repository.logIn(params);
  }
}

class LoginUserInfoParams extends Equatable {
  final String mobileNumber;
  LoginUserInfoParams({required this.mobileNumber});
  Map<String, String> toBody() {
    return <String, String>{'mobileNumber': this.mobileNumber};
  }

  @override
  List<Object> get props => [mobileNumber];
}
