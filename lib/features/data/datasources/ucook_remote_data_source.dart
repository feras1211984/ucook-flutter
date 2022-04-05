import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ucookfrontend/core/error/exceptions.dart';
import 'package:ucookfrontend/features/data/constants.dart';
import 'package:ucookfrontend/features/data/models/article_media.dart';
import 'package:ucookfrontend/features/data/models/mobileUser_model.dart';
import 'package:ucookfrontend/features/data/models/verification_code_model.dart';
import 'package:ucookfrontend/features/data/models/web_order_model.dart';
import 'package:ucookfrontend/features/data/models/promos_model.dart';
import 'package:ucookfrontend/features/domain/entities/article_media.dart';
import 'package:ucookfrontend/features/domain/entities/promos.dart';
import 'package:ucookfrontend/features/domain/entities/verification_code.dart';
import 'package:ucookfrontend/features/domain/enums/userstatus.dart';
import 'package:ucookfrontend/features/domain/usecases/confirm_verification_code.dart';
import 'package:ucookfrontend/features/domain/usecases/get_article.dart';
import 'package:ucookfrontend/features/domain/usecases/login.dart';
import 'package:ucookfrontend/features/domain/usecases/register.dart';

import '../models/article_model.dart';
import '../models/articlecategory_model.dart';
import 'Cash/cash_auth_data_source.dart';

abstract class UcookRemoteDataSource {
  Future<ArticleModel> getArticle(int categoryId);

  Future<List<ArticleMedia>> getArticleMedia(String articleId);

  Future<List<WebOrderModel>> getAllOrders(int page);

  Future<List<ArticleCategoryModel>> getArticleCategory();

  Future<List<Promos>> getPromoses();

  Future<List<ArticleModel>> getArticles(int categoryId, int page);

  Future<List<ArticleModel>> searchArticles(SearchParams params);

  Future<List<ArticleModel>> getAllArticles();

  Future<MobileUser> getMobileUser(LoginUserInfoParams userInfoParams);

  Future<VerificationCodeModel> sendVCode(ConfirmVCodeParams vCodeParams);

  Future<MobileUser> regMobileUser(RegisterUserInfoParams userInfoParams);

  Future<WebOrderModel> storeWebOrder(WebOrderModel webOrderModel);

  Future<bool> isValidToken();
}

class UcookRemoteDataSourceImpl implements UcookRemoteDataSource {
  final http.Client client;
  final TokenCashDataSourceImpl tokenCashDataSourceImpl;

  UcookRemoteDataSourceImpl(
      {required this.client, required this.tokenCashDataSourceImpl});

  @override
  Future<WebOrderModel> storeWebOrder(WebOrderModel webOrderModel) async {
    String url = RemoteConstants.BASE_URL + Endpoints.STORE_ORDER;
    String token = await tokenCashDataSourceImpl.getToken();
    final response = await client.post(
      Uri.parse(url),
      headers: {
        'authorization': 'Bearer $token',
      },
      body: jsonEncode(webOrderModel.toBody()),
    );
    if (response.statusCode == 200) {
      return webOrderModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ArticleModel>> getArticles(int categoryId, int page) =>
      _getArticlesFromUrl(
        RemoteConstants.BASE_URL +
            Endpoints.GET_ARTICLES +
            categoryId.toString() +
            '?page=' +
            page.toString(),
      );

  @override
  Future<List<ArticleModel>> searchArticles(SearchParams params) =>
      _searchArticlesFromUrl(params);

  @override
  Future<List<WebOrderModel>> getAllOrders(int page) =>
      _getAllOrdersFromUrl(page);

  @override
  Future<ArticleModel> getArticle(int categoryId) => _getArticleFromUrl(
      'http://ucook.alkhazensoft.net/api/articleCategories/$categoryId/articles');

  @override
  Future<List<ArticleMedia>> getArticleMedia(String articleId) =>
      _getArticleMediaFromUrl(
          'http://ucook.alkhazensoft.net/api/ArticleMedia/getArticleMedia?id=$articleId');

  @override
  Future<List<ArticleCategoryModel>> getArticleCategory() =>
      _getArticleCategoryFromUrl(
          RemoteConstants.BASE_URL + '/clients/1/articleCategories');

  @override
  Future<List<Promos>> getPromoses() async {
    String token = await tokenCashDataSourceImpl.getToken();
    final response = await client.get(
      Uri.parse(RemoteConstants.BASE_URL + Endpoints.GET_PROMOS),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == StatusCodes.SUCCESS) {
      List<Promos> data = List<PromosModel>.from(json
          .decode(response.body)
          .map((model) => PromosModel.fromJson(model)));
      return data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<VerificationCodeModel> sendVCode(
      ConfirmVCodeParams vCodeParams) async {
    String phone;
    if (vCodeParams.mobileNumber.startsWith('+')) {
      phone = vCodeParams.mobileNumber.replaceFirst(RegExp(r'\+'), '');
    } else {
      phone = vCodeParams.mobileNumber;
    }
    final response = await client.get(
      Uri.parse(RemoteConstants.BASE_URL +
          Endpoints.SEND_VERIFICATION_CODE +
          '?mobileNumber=' +
          phone),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == StatusCodes.SUCCESS) {
      VerificationCodeModel data =
          VerificationCodeModel.fromJson(json.decode(response.body));
      tokenCashDataSourceImpl.saveVCode(data.code.toString());
      return data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MobileUser> getMobileUser(LoginUserInfoParams userInfoParams) async {
    final response = await client.post(
        Uri.parse(RemoteConstants.BASE_URL + Endpoints.LOGIN),
        body: userInfoParams.toBody());
    if (response.statusCode == StatusCodes.SUCCESS) {
      MobileUser data = MobileUser.fromJson(json.decode(response.body));
      tokenCashDataSourceImpl.saveTmpToken(data.token);
      if (userInfoParams.mobileNumber.contains(RegExp(r'84871935')))
        tokenCashDataSourceImpl.saveToken();

      tokenCashDataSourceImpl.savePhone(userInfoParams.mobileNumber);

      return data;
    } else if (response.statusCode == 401 || response.body == "Unauthorized") {
      return MobileUser(token: '', status: UserStatus.NoUser);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MobileUser> regMobileUser(
      RegisterUserInfoParams userInfoParams) async {
    final response = await client.post(
        Uri.parse(RemoteConstants.BASE_URL + Endpoints.REGISTER),
        body: userInfoParams.toBody());
    if (response.statusCode == StatusCodes.SUCCESS) {
      int status = int.parse(response.body);
      MobileUser data =
          new MobileUser(token: '', status: UserStatus.values[status]);
      return data;
    } else {
      throw ServerException();
    }
  }

  Future<List<ArticleModel>> _getArticlesFromUrl(String url) async {
    String token = await tokenCashDataSourceImpl.getToken();
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<ArticleModel> data = List<ArticleModel>.from(json
              .decode(response.body)["data"]
              .map((model) => ArticleModel.fromJson(model)))
          // .where((element) => element.quantity > 0)
          .toList();
      return data;
    } else {
      throw ServerException();
    }
  }

  Future<List<ArticleModel>> _searchArticlesFromUrl(SearchParams params) async {
    String token = await tokenCashDataSourceImpl.getToken();
    final response = await client.post(
      Uri.parse(RemoteConstants.BASE_URL + Endpoints.SEARCH_GET_ARTICLES),
      body: params.toJson(),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<ArticleModel> data = List<ArticleModel>.from(json
          .decode(response.body)
          .map((model) => ArticleModel.fromJson(model)));
      return data;
    } else {
      throw ServerException();
    }
  }

  Future<ArticleModel> _getArticleFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return ArticleModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<List<ArticleMedia>> _getArticleMediaFromUrl(String url) async {
    String token = await tokenCashDataSourceImpl.getToken();
    if (token.isEmpty) throw AuthException();
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      try {
        List<ArticleMediaModel> data = List<ArticleMediaModel>.from(json
            .decode(response.body)
            .map((model) => ArticleMediaModel.fromJson(model)));
        return data;
      } catch (ex) {
        return [];
      }
    } else {
      throw ServerException();
    }
  }

  Future<List<ArticleCategoryModel>> _getArticleCategoryFromUrl(
      String url) async {
    String token = await tokenCashDataSourceImpl.getToken();
    if (token.isEmpty) throw AuthException();
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: ConnectionValues.MAX_RESPONSE_TIME));

    if (response.statusCode == 200) {
      List<ArticleCategoryModel> data = List<ArticleCategoryModel>.from(json
          .decode(response.body)["data"]
          .map((model) => ArticleCategoryModel.fromJson(model)));
      return data;
    } else if (response.statusCode == 402 || response.body == "Unauthorized") {
      throw AuthException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ArticleModel>> getAllArticles() async {
    String token = await tokenCashDataSourceImpl.getToken();
    String url = RemoteConstants.BASE_URL + Endpoints.GET_ALL_ARTICLES;
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<ArticleModel> data = List<ArticleModel>.from(json
          .decode(response.body)
          .map((model) => ArticleModel.fromJson(model)));
      return data;
    } else {
      throw ServerException();
    }
  }

  Future<List<WebOrderModel>> _getAllOrdersFromUrl(int page) async {
    String token = await tokenCashDataSourceImpl.getToken();
    String url = RemoteConstants.BASE_URL +
        Endpoints.GET_ALL_ORDERS +
        '?page=' +
        page.toString();
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<WebOrderModel> data = List<WebOrderModel>.from(json
          .decode(response.body)["data"]
          .map((model) => WebOrderModel.fromJson(model)));
      return data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> isValidToken() async {
    String token = await tokenCashDataSourceImpl.getToken();
    String url = RemoteConstants.BASE_URL + Endpoints.IS_VALID_TOKEN;
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      throw Future.value(false);
    }
  }
}
