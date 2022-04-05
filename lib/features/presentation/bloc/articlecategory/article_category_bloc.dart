import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/usecases/usecase.dart';
import 'package:ucookfrontend/core/util/input_converter.dart';

import '../../../domain/entities/articlecategory.dart';
import '../../../domain/usecases/get_article_category.dart';
import '../Constant.dart';
import 'article_category_event.dart';
import 'article_category_state.dart';

const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class ArticleCategoryBloc
    extends Bloc<ArticleCategoryEvent, ArticleCategoryState> {
  final GetArticleCategoryUseCase getArticleCategory;
  final InputConverter inputConverter;

  ArticleCategoryBloc({
    required GetArticleCategoryUseCase concrete,
    required this.inputConverter,
  })  : getArticleCategory = concrete,
        super(Empty());
  @override
  Stream<ArticleCategoryState> mapEventToState(ArticleCategoryEvent event) async* {
    if (event is GetArticleCategory) {
      yield Loading();
      final failureOrCategories = await getArticleCategory(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrCategories);
    }
  }

  Stream<ArticleCategoryState> _eitherLoadedOrErrorState(
    Either<Failure, List<ArticleCategory>> failureOrCategories,
  ) async* {
    yield failureOrCategories.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (articleCategory) => Loaded(articleCategories: articleCategory),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case AuthFailure:
        return AUTH_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
