import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/features/domain/entities/article_media.dart';
import 'package:ucookfrontend/features/domain/usecases/get_article.dart';

import '../entities/article.dart';

abstract class ArticleRepository {
  Future<Either<Failure, Article>> getArticle(int categoryId);
  Future<Either<Failure, List<ArticleMedia>>> getArticleMedia(String articleId);
  Future<Either<Failure, List<Article>>> getArticles(int categoryId, int page);
  Future<Either<Failure, List<Article>>> getAllArticles();
  Future<Either<Failure, List<Article>>> searchArticles(SearchParams params);
}
