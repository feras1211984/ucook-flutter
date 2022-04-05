import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class VerificationCodeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendVerificationCodeEvent extends VerificationCodeEvent {
  final String mobileNumber;
  SendVerificationCodeEvent(this.mobileNumber);
  @override
  List<Object> get props => [];
}

class CheckVerificationCodeEvent extends VerificationCodeEvent {
  final int code;
  CheckVerificationCodeEvent(this.code);
  @override
  List<Object> get props => [];
}
