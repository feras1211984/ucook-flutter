import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartPageInitializedEvent extends CartEvent {}

class ItemAddingCartEvent extends CartEvent {
  final int articleId;
  final String unitName;
  final double unitPrice;

  ItemAddingCartEvent(
      {required this.articleId,
      required this.unitName,
      required this.unitPrice});
}

class ItemDeleteCartEvent extends CartEvent {
  final int articleId;

  ItemDeleteCartEvent({required this.articleId});
}

class AllCartEvent extends CartEvent {
  AllCartEvent();
}

class RemoveCartEvent extends CartEvent {
  RemoveCartEvent();
}

class StoreOrderEvent extends CartEvent {
  final WebOrder webOrder;
  StoreOrderEvent({required this.webOrder});
}
