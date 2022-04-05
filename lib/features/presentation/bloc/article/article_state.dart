import 'package:equatable/equatable.dart';

import '../../../domain/entities/article.dart';

enum ArticleStatus { initial, success, failure }

class ArticleState extends Equatable {
  final ArticleStatus status;
  final List<Article> articles;
  final bool hasReachedMax;

  const ArticleState({
    this.status = ArticleStatus.initial,
    this.articles = const <Article>[],
    this.hasReachedMax = false,
  });
  ArticleState copyWith({
    ArticleStatus? status,
    List<Article>? articles,
    bool? hasReachedMax,
  }) {
    return ArticleState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ArticleState { status: $status, hasReachedMax: $hasReachedMax, articles: ${articles.length} }''';
  }

  @override
  List<Object?> get props => [status, articles, hasReachedMax];
}

class Empty extends ArticleState {}

class Loading extends ArticleState {}

class Loaded extends ArticleState {
  final Article article;

  Loaded({required this.article});

  @override
  List<Object> get props => [article];
}

class Error extends ArticleState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}

class ShopPageLoadedState extends ArticleState {
  List<Article> articles;
  List<Article> cartData;

  ShopPageLoadedState(this.cartData, this.articles);

  @override
  List<Object> get props => [articles, cartData];
}

class ItemAddingCartState extends ArticleState {
  List<Article> cartItems;

  ItemAddingCartState(this.cartItems);
}

class ItemAddedCartState extends ArticleState {
  List<Article> cartItems;

  ItemAddedCartState(this.cartItems);
}

class ItemDeletingCartState extends ArticleState {
  List<Article> cartItems;

  ItemDeletingCartState(this.cartItems);
}

class ArticleSearchNoResultState extends ArticleState {}

class ArticleSearchResultsState extends ArticleState {
  final List<Article> result;
  ArticleSearchResultsState({required this.result});
  @override
  List<Object> get props => [result];
}
