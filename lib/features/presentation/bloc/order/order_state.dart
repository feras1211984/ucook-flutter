import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderPageInitial extends OrderState {}

class Loading extends OrderState {}

class GetOrdersError extends OrderState {
  final String message;

  GetOrdersError({required this.message});

  @override
  List<Object> get props => [message];
}

class OrderPageLoadedState extends OrderState {
  final List<WebOrder> orders;
  OrderPageLoadedState({required this.orders});
}

class FetchingOrdersSuccessState extends OrderState {
  final List<WebOrder> orders;
  FetchingOrdersSuccessState({required this.orders});
}
