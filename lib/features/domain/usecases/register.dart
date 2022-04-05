import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/usecases/usecase.dart';
import 'package:ucookfrontend/features/data/models/mobileUser_model.dart';
import 'package:ucookfrontend/features/domain/repositories/mobile_user_repository.dart';

class RegisterUseCase implements UseCase<MobileUser, RegisterUserInfoParams> {
  final MobileUserRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, MobileUser>> call(
      RegisterUserInfoParams params) async {
    return await repository.register(params);
  }
}

class RegisterUserInfoParams extends Equatable {
  final String name;
  final String mobileNumber;
  RegisterUserInfoParams({required this.name, required this.mobileNumber});
  Map<String, String> toBody() {
    return <String, String>{
      'name': this.name,
      'mobileNumber': this.mobileNumber
    };
  }

  @override
  List<Object> get props => [mobileNumber];
}
