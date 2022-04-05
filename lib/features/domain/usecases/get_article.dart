import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/usecases/usecase.dart';
import 'package:ucookfrontend/features/domain/entities/article_media.dart';

import '../entities/article.dart';
import '../repositories/article_repository.dart';

class GetArticleUseCase implements UseCase<Article, Params> {
  final ArticleRepository repository;

  GetArticleUseCase(this.repository);

  @override
  Future<Either<Failure, Article>> call(Params params) async {
    return await repository.getArticle(params.categoryId);
  }

  Future<Either<Failure, List<Article>>> getArticles(Params params) async {
    return await repository.getArticles(params.categoryId, params.page);
  }

  Future<Either<Failure, List<Article>>> getAllArticles() async {
    return await repository.getAllArticles();
  }

  Future<Either<Failure, List<Article>>> searchArticles(
      SearchParams params) async {
    return await repository.searchArticles(params);
  }

  Future<Either<Failure, List<ArticleMedia>>> getArticleMedia(
      MediaParams params) async {
    return await repository.getArticleMedia(params.articleId);
  }
}

class Params extends Equatable {
  final int categoryId;
  final int page;

  Params({required this.categoryId, required this.page});

  @override
  List<Object> get props => [categoryId, page];
}

class SearchParams extends Equatable {
  final String name;

  // final int page;
  SearchParams({required this.name});

  @override
  List<Object> get props => [name];

  Map<String, String> toJson() => {
        'name': name,
      };
}

class MediaParams extends Equatable {
  final String articleId;

  // final int page;
  MediaParams({required this.articleId});

  @override
  List<Object> get props => [articleId];

  Map<String, String> toJson() => {
        'articleId': articleId,
      };
}
