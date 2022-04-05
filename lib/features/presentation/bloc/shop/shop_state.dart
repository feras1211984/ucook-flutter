import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/features/domain/entities/article.dart';
import 'package:ucookfrontend/features/domain/entities/article_media.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

class ShopInitial extends ShopState {}

class ShopPageLoadedState extends ShopState {
  final List<Article> shopData;
  final List<Article> cartData;

  ShopPageLoadedState({required this.cartData, required this.shopData});
}

class FetchingSuccessState extends ShopState {
  final List<Article> shopData;
  final List<Article> cartData;

  FetchingSuccessState({required this.cartData, required this.shopData});
}

class ArticleMediaLoaddedState extends ShopState {
  final List<ArticleMedia> items;

  ArticleMediaLoaddedState({required this.items});
}

class LoadingState extends ShopState {}

class Error extends ShopState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
