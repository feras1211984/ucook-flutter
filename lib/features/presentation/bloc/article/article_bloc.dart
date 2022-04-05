import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/util/input_converter.dart';

import '../../../domain/entities/article.dart';
import '../../../domain/usecases/get_article.dart';
import 'article_event.dart';
import 'article_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetArticleUseCase getArticle;
  final InputConverter inputConverter;
  int page = 1;
  bool isFetching = false;

  ArticleBloc({
    required GetArticleUseCase getArticle,
    required this.inputConverter,
  })  : assert(getArticle != null),
        assert(inputConverter != null),
        this.getArticle = getArticle,
        super(ArticleState());

  @override
  ArticleState get initialState => Empty();

  @override
  Stream<ArticleState> mapEventToState(
    ArticleEvent event,
  ) async* {
    if (event is GetArticle) {
      yield Loading();
      final failureOrArticles = await getArticle
          .getArticles(Params(categoryId: event.categoryId, page: page));
      yield* _eitherLoadedOrErrorState(failureOrArticles);
      page++;
    }
    if (event is ItemAddingCartEvent) {
      yield ItemAddingCartState(event.cartItems);
    }
    if (event is ItemAddedCartEvent) {
      yield ItemAddedCartState(event.cartItems);
    }
    if (event is ItemDeleteCartEvent) {
      yield ItemDeletingCartState(event.cartItems);
    }
    if (event is ArticleFetchEvent) {
      final failureOrArticles = await getArticle
          .getArticles(Params(categoryId: event.categoryId, page: page));
      yield* _eitherLoadedOrErrorState(failureOrArticles);
      page++;
    }
    if (event is ArticleSearchEvent) {
      yield Loading();
      final failureOrArticles =
          await getArticle.searchArticles(SearchParams(name: event.searchText));
      yield* failureOrArticles.fold((failure) async* {
        yield Error(message: _mapFailureToMessage(failure));
      }, (reuslt) async* {
        if (reuslt.isEmpty)
          yield ArticleSearchNoResultState();
        else
          yield ArticleSearchResultsState(result: reuslt);
      });
    }
  }
}

Stream<ArticleState> _eitherLoadedOrErrorState(
  Either<Failure, List<Article>> failureOrArticles,
) async* {
  yield failureOrArticles.fold(
    (failure) => Error(message: _mapFailureToMessage(failure)),
    (article) => ShopPageLoadedState(article, article),
  );
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected error';
  }
}
