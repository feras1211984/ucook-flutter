import 'package:equatable/equatable.dart';

import '../../../domain/entities/articlecategory.dart';

enum ArticleCategoryStatus { initial, success, failure }

class ArticleCategoryState extends Equatable {
  final ArticleCategoryStatus status;
  final List<ArticleCategory> articleCategory;
  final bool hasReachedMax;

  const ArticleCategoryState({
    this.status = ArticleCategoryStatus.initial,
    this.articleCategory = const <ArticleCategory>[],
    this.hasReachedMax = false,
  });
  ArticleCategoryState copyWith({
    ArticleCategoryStatus? status,
    List<ArticleCategory>? articles,
    bool? hasReachedMax,
  }) {
    return ArticleCategoryState(
      status: status ?? this.status,
      articleCategory: articles ?? this.articleCategory,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ArticleCategoryState { status: $status, hasReachedMax: $hasReachedMax, articleCategory: ${articleCategory.length} }''';
  }

  @override
  List<Object?> get props => [status, articleCategory, hasReachedMax];
}

class Empty extends ArticleCategoryState {}

class Loading extends ArticleCategoryState {}

class Loaded extends ArticleCategoryState {
  final List<ArticleCategory> articleCategories;

  Loaded({required this.articleCategories});

  @override
  List<Object> get props => [articleCategories];
}

class Error extends ArticleCategoryState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
