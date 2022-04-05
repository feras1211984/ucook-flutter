import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartPageLoadedState extends CartState {
  WebOrder cartData;

  CartPageLoadedState({required this.cartData});
}

class ItemAddingCartState extends CartState {
  List<WebOrderDetail> cartItems;

  ItemAddingCartState({required this.cartItems});
}

class ItemAddedCartState extends CartState {
  final int quantity;
  final int articleId;

  ItemAddedCartState({required this.quantity, required this.articleId});

  @override
  List<Object> get props => [quantity, articleId];
}

class ItemDeletedCartState extends CartState {
  final int quantity;
  final int articleId;

  ItemDeletedCartState({required this.quantity, required this.articleId});

  @override
  List<Object> get props => [quantity, articleId];
}

class AllCartState extends CartState {
  final WebOrder cartItems;

  AllCartState({required this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class RemovedCartState extends CartState {
  final WebOrder cartItems;

  RemovedCartState({required this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class StoreOrderState extends CartState {}

class StoreError extends CartState {
  final String message;

  StoreError({required this.message});

  @override
  List<Object> get props => [message];
}
