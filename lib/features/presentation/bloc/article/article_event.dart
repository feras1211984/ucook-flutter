import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ucookfrontend/features/domain/entities/article.dart';

@immutable
abstract class ArticleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetArticle extends ArticleEvent {
  final int categoryId;

  GetArticle(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ItemAddingCartEvent extends ArticleEvent {
  List<Article> cartItems;

  ItemAddingCartEvent(this.cartItems);
}

class ItemAddedCartEvent extends ArticleEvent {
  List<Article> cartItems;

  ItemAddedCartEvent(this.cartItems);
}

class ItemDeleteCartEvent extends ArticleEvent {
  List<Article> cartItems;
  int index;
  ItemDeleteCartEvent(this.cartItems, this.index);
}

class ArticleFetchEvent extends ArticleEvent {
  final int categoryId;
  ArticleFetchEvent({required this.categoryId});
}

class ArticleSearchEvent extends ArticleEvent {
  final String searchText;
  ArticleSearchEvent({required this.searchText});
}
