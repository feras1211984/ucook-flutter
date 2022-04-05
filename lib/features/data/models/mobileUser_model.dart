import 'package:ucookfrontend/features/domain/entities/user.dart';
import 'package:ucookfrontend/features/domain/enums/userstatus.dart';

class MobileUser extends User {
  MobileUser({
    required String token,
    required UserStatus status,
  }) : super(
            token: token,
            status: status);

  factory MobileUser.fromJson(Map<String, dynamic> json) {
    return MobileUser(
      token: json['access_token'],
      status: UserStatus.values[json['status']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'status': status,
    };
  }
}
