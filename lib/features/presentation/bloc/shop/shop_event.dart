import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/features/domain/entities/article.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class ShopPageInitializedEvent extends ShopEvent {
  final int categoryId;

  ShopPageInitializedEvent({required this.categoryId});
}

class ItemAddingCartEvent extends ShopEvent {
  final int articleId;

  ItemAddingCartEvent({required this.articleId});
}

class ItemAddedCartEvent extends ShopEvent {
  List<Article> cartItems;

  ItemAddedCartEvent({required this.cartItems});
}

class ItemDeleteCartEvent extends ShopEvent {
  List<Article> cartItems;
  int index;

  ItemDeleteCartEvent({required this.cartItems, required this.index});
}

class ArticleFetchEvent extends ShopEvent {
  final int categoryId;

  ArticleFetchEvent({required this.categoryId});
}

class GetArticleMediaEvent extends ShopEvent {
  final String articleId;

  GetArticleMediaEvent({required this.articleId});
}

class IncreaseArticleQuantityEvent extends ShopEvent {}
