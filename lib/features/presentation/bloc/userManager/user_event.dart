import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MobileUserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginUser extends MobileUserEvent {
  final String mobileNumber;
  LoginUser(this.mobileNumber);
  @override
  List<Object> get props => [];
}

class RegisterUser extends MobileUserEvent {
  final String name;
  final String mobileNumber;
  RegisterUser(this.name, this.mobileNumber);
  @override
  List<Object> get props => [];
}
