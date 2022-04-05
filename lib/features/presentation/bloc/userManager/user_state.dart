import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/features/data/models/mobileUser_model.dart';

enum UserStates { noUser, newUser, approvedUser, blockedUser }

class UserState extends Equatable {
  final UserStates userStates;

  const UserState({this.userStates = UserStates.noUser});
  UserState copyWith({UserStates? state}) {
    return UserState(
      userStates: userStates,
    );
  }

  @override
  String toString() {
    return '''MobileUser { status: $userStates }''';
  }

  @override
  List<Object?> get props => [userStates];
}

class Loading extends UserState {}

class NoUser extends UserState {}

class NewUser extends UserState {
  final MobileUser mobileUser;

  NewUser({required this.mobileUser});

  @override
  List<Object> get props => [mobileUser];
}

class NotApprovedUser extends UserState {
  final MobileUser mobileUser;

  NotApprovedUser({required this.mobileUser});

  @override
  List<Object> get props => [mobileUser];
}

class LoggedIn extends UserState {
  final MobileUser mobileUser;
  LoggedIn({required this.mobileUser});
  @override
  List<Object> get props => [mobileUser];
}

class BlockedUser extends UserState {
  final MobileUser mobileUser;

  BlockedUser({required this.mobileUser});

  @override
  List<Object> get props => [mobileUser];
}

class LoggingInState extends UserState {}

class SigningUpState extends UserState {}

class Error extends UserState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
