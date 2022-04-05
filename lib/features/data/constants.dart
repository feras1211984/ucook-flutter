class RemoteConstants {
  static const String REMOTE_URL = "http://ucook.alkhazensoft.net";
  static const String BASE_URL = REMOTE_URL + "/api";
}

class Endpoints {
  static const String LOGIN = "/loginMobile";
  static const String SEND_VERIFICATION_CODE = "/sendVerificationCode";
  static const String GET_PROMOS = "/promos";
  static const String REGISTER = "/registerMobile";
  static const String GET_ARTICLES = "/articles/category/";
  static const String GET_ALL_ARTICLES = "/articles";
  static const String GET_ALL_ORDERS = "/webOrder/orders";
  static const String STORE_ORDER = "/webOrder";
  static const String SEARCH_GET_ARTICLES = "/articles/searchArticle";
  static const String IS_VALID_TOKEN = "/isValidToken";
  static const String GET_ARTICLE_MEDIA = "/ArticleMedia/getArticleMedia";
}

class StatusCodes {
  static const SUCCESS = 200;
  static const SERVER_ERROR = 500;
  static const UNAUTHORIZED_USER = 401;
  static const EXPIRED_TOKEN = 434;
  static const MUST_LOGIN_AGAIN = 436;
  static const UNKNOWN_ERROR = 402;
  static const UNVERIFIED_ACCOUNT = 406;
  static const NETWORK_ERROR = 0;
}

class ConnectionValues {
  static const int MAX_RESPONSE_TIME = 20; //seconds
}
