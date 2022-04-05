import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderPageInitializedEvent extends OrderEvent {}

class OrderFetchEvent extends OrderEvent {}
