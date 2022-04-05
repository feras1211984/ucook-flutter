import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/features/domain/entities/article.dart';
import 'package:ucookfrontend/features/domain/usecases/get_article.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_state.dart';
import '../Constant.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final GetArticleUseCase getArticlesUseCase;
  int page = 1;
  bool isFetching = false;

  ShopBloc({required GetArticleUseCase getArticles})
      : getArticlesUseCase = getArticles,
        super(ShopInitial());

  @override
  Stream<ShopState> mapEventToState(
    ShopEvent event,
  ) async* {
    if (event is ShopPageInitializedEvent) {
      final failureOrArticles = await getArticlesUseCase
          .getArticles(Params(categoryId: event.categoryId, page: page));
      yield* _eitherLoadedOrErrorState(failureOrArticles);
      page++;
    }
    if (event is ArticleFetchEvent) {
      yield LoadingState();
      final failureOrArticles = await getArticlesUseCase
          .getArticles(Params(categoryId: event.categoryId, page: page));
      yield failureOrArticles.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (articles) =>
            FetchingSuccessState(shopData: articles, cartData: articles),
      );
      page++;
    }
    if (event is GetArticleMediaEvent) {
      yield LoadingState();
      final failureOrArticles = await getArticlesUseCase
          .getArticleMedia(MediaParams(articleId: event.articleId));
      yield failureOrArticles.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (items) => ArticleMediaLoaddedState(items: items),
      );
    }
  }

  Stream<ShopState> _eitherLoadedOrErrorState(
    Either<Failure, List<Article>> failureOrData,
  ) async* {
    yield failureOrData.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (articles) => ShopPageLoadedState(cartData: articles, shopData: articles),
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
}
