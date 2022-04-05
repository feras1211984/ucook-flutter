import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/core/error/exceptions.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/network/network_info.dart';
import 'package:ucookfrontend/features/data/models/article_model.dart';
import 'package:ucookfrontend/features/domain/entities/article_media.dart';
import 'package:ucookfrontend/features/domain/usecases/get_article.dart';
import '../datasources/ucook_remote_data_source.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

typedef Future<Article> _ArticleChooser();
typedef Future<List<ArticleMedia>> _ArticleMediaChooser();
typedef Future<List<ArticleModel>> _ArticlesChooser();

class ArticleRepositoryImpl implements ArticleRepository {
  final UcookRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ArticleRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Article>> getArticle(
    int categoryId,
  ) async {
    return await _getArticle(() {
      return remoteDataSource.getArticle(categoryId);
    });
  }

  Future<Either<Failure, Article>> _getArticle(
    _ArticleChooser getArticle,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticle = await getArticle();
        return Right(remoteArticle);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ArticleMedia>>> getArticleMedia(
    String articleId,
  ) async {
    return await _getArticleMedia(() {
      return remoteDataSource.getArticleMedia(articleId);
    });
  }

  Future<Either<Failure, List<ArticleMedia>>> _getArticleMedia(
    _ArticleMediaChooser getArticle,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticle = await getArticle();
        return Right(remoteArticle);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ArticleModel>>> getArticles(
      int categoryId, int page) async {
    return await _getArticles(() {
      return remoteDataSource.getArticles(categoryId, page);
    });
  }

  Future<Either<Failure, List<ArticleModel>>> _getArticles(
    _ArticlesChooser getArticles,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticle = await getArticles();
        return Right(remoteArticle);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getAllArticles() async {
    return await _getAllArticles(() {
      return remoteDataSource.getAllArticles();
    });
  }

  Future<Either<Failure, List<ArticleModel>>> _getAllArticles(
      _ArticlesChooser getArticles) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticle = await getArticles();
        return Right(remoteArticle);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> searchArticles(
      SearchParams params) async {
    return await _searchArticles(() {
      return remoteDataSource.searchArticles(params);
    });
  }

  Future<Either<Failure, List<ArticleModel>>> _searchArticles(
      _ArticlesChooser getArticles) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticle = await getArticles();
        return Right(remoteArticle);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }
}
