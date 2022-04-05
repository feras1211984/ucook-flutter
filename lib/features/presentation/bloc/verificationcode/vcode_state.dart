import 'package:equatable/equatable.dart';

class VCodeStates extends Equatable {
  const VCodeStates();

  @override
  List<Object> get props => [];
}

class Error extends VCodeStates {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}

class GettingVCodeState extends VCodeStates {
  final int code;

  GettingVCodeState({required this.code});

  @override
  List<Object> get props => [code];
}

class WrongVCodeState extends VCodeStates {}

class RightVCodeState extends VCodeStates {}
