import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/features/domain/enums/userstatus.dart';

class User extends Equatable {
  final String token;
  final UserStatus status;

  User({
    required this.token,
    required this.status,
  });
  @override
  List<Object> get props => [token];
}
