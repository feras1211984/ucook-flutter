import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucookfrontend/features/data/datasources/Cash/cache_cart_data_source.dart';
import 'package:ucookfrontend/features/data/repositories/article_repository_impl.dart';
import 'package:ucookfrontend/features/data/repositories/mobile_user_repository_impl.dart';
import 'package:ucookfrontend/features/data/repositories/order_repository_impl.dart';
import 'package:ucookfrontend/features/domain/repositories/order_repository.dart';
import 'package:ucookfrontend/features/domain/repositories/promos_repository.dart';
import 'package:ucookfrontend/features/domain/usecases/confirm_verification_code.dart';
import 'package:ucookfrontend/features/domain/usecases/get_promos.dart';
import 'package:ucookfrontend/features/domain/usecases/login.dart';
import 'package:ucookfrontend/features/domain/usecases/order.dart';
import 'package:ucookfrontend/features/presentation/bloc/article/article_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/carousel/carousel_bloc.dart';
import 'package:ucookfrontend/features/domain/usecases/register.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/order/order_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/userManager/user_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/verificationcode/vcode_bloc.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/data/datasources/Cash/cash_auth_data_source.dart';
import 'features/data/datasources/ucook_remote_data_source.dart';
import 'features/data/repositories/article_category_repository_impl.dart';
import 'features/data/repositories/promos_repository_impl.dart';
import 'features/domain/repositories/article_category_repository.dart';
import 'features/domain/repositories/article_repository.dart';
import 'features/domain/repositories/mobile_user_repository.dart';
import 'features/domain/usecases/get_article.dart';
import 'features/domain/usecases/get_article_category.dart';
import 'features/presentation/bloc/articlecategory/article_category_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerFactory(
    () => ArticleCategoryBloc(concrete: sl(), inputConverter: sl()),
  );
  sl.registerFactory(
      () => CarouselBloc(getPromosUseCase: sl(), inputConverter: sl()));
  sl.registerFactory(() => ArticleBloc(getArticle: sl(), inputConverter: sl()));
  sl.registerFactory(
      () => MobileUserBloc(loginUseCase: sl(), registerUseCase: sl()));
  sl.registerFactory(() => ShopBloc(getArticles: sl()));
  sl.registerFactory(() => CartBloc(orderUseCase: sl()));
  sl.registerFactory(() => OrderBloc(orderUseCase: sl()));
  sl.registerFactory(() => VerificationCodeBloc(confirmVCodeUseCase: sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmVCodeUseCase(sl()));
  sl.registerLazySingleton(() => GetArticleCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetArticleUseCase(sl()));
  sl.registerLazySingleton(() => GetPromosUseCase(sl()));
  sl.registerLazySingleton(() => OrderUseCase(sl()));

  sl.registerLazySingleton<ArticleCategoryRepository>(
    () => ArticleCategoryRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<MobileUserRepository>(
    () => MobileUserRepositoryImpl(loginDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<PromosRepository>(
      () => PromosRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));

  sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));
  sl.registerLazySingleton<ArticleRepository>(
      () => ArticleRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));
  sl.registerLazySingleton<UcookRemoteDataSourceImpl>(
    () =>
        UcookRemoteDataSourceImpl(client: sl(), tokenCashDataSourceImpl: sl()),
  );
  sl.registerLazySingleton<TokenCashDataSourceImpl>(
    () => TokenCashDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CartCashDataSourceImpl>(
    () => CartCashDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<UcookRemoteDataSource>(
    () =>
        UcookRemoteDataSourceImpl(client: sl(), tokenCashDataSourceImpl: sl()),
  );
  sl.registerLazySingleton<TokenCashDataSource>(
      () => TokenCashDataSourceImpl(sl<SharedPreferences>()));

  sl.registerLazySingleton<CartCashDataSource>(
      () => CartCashDataSourceImpl(sl<SharedPreferences>()));
  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
