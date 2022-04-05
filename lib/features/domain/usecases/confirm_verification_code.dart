import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/usecases/usecase.dart';
import 'package:ucookfrontend/features/data/models/verification_code_model.dart';
import 'package:ucookfrontend/features/domain/repositories/mobile_user_repository.dart';

class ConfirmVCodeUseCase
    implements UseCase<VerificationCodeModel, ConfirmVCodeParams> {
  final MobileUserRepository repository;

  ConfirmVCodeUseCase(this.repository);

  @override
  Future<Either<Failure, VerificationCodeModel>> call(
      ConfirmVCodeParams params) async {
    return await repository.sendVCode(params);
  }
}

class ConfirmVCodeParams extends Equatable {
  final String mobileNumber;
  ConfirmVCodeParams({required this.mobileNumber});
  Map<String, String> toBody() {
    return <String, String>{'mobileNumber': this.mobileNumber};
  }

  @override
  List<Object> get props => [mobileNumber];
}
