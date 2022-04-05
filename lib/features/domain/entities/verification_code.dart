import 'package:equatable/equatable.dart';

class VerificationCode extends Equatable {
  final int code;
  final String status;

  VerificationCode({
    required this.code,
    required this.status,
  });
  @override
  List<Object> get props => [code];
}
