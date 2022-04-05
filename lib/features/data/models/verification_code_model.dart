import 'package:ucookfrontend/features/domain/entities/verification_code.dart';

class VerificationCodeModel extends VerificationCode {
  VerificationCodeModel({
    required int code,
    required String status,
  }) : super(code: code, status: status);

  factory VerificationCodeModel.fromJson(Map<String, dynamic> json) {
    return VerificationCodeModel(
      code: int.parse(json['code'].toString()),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
    };
  }
}
