import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/data/datasources/Cash/cash_auth_data_source.dart';
import 'package:ucookfrontend/features/domain/repositories/mobile_user_repository.dart';
import 'package:ucookfrontend/features/presentation/bloc/article/article_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/verificationcode/vcode_bloc.dart';
import 'package:ucookfrontend/features/presentation/pages/article_category_page.dart';
import 'package:ucookfrontend/features/presentation/pages/articles_page.dart';
import 'package:ucookfrontend/features/presentation/pages/cart_page.dart';
import 'package:ucookfrontend/features/presentation/pages/courses_page.dart';
import 'package:ucookfrontend/features/presentation/pages/home_page.dart';
import 'package:ucookfrontend/features/presentation/pages/login_page.dart';
import 'package:ucookfrontend/features/presentation/pages/register_page.dart';
import 'package:ucookfrontend/features/presentation/pages/verification_code.dart';
import 'package:ucookfrontend/features/presentation/pages/waiting_for_register_page.dart';
import 'package:ucookfrontend/features/presentation/utils/routes.dart';
import 'package:ucookfrontend/features/presentation/widgets/Search/article_search.dart';

import 'package:ucookfrontend/injection_container.dart';

import '../pages/notification_page.dart';
import '../pages/notifications_page.dart';

class RouteGenerator {
  static MobileUserRepository mobileUserRepository = sl();
  static TokenCashDataSourceImpl _tokenCashDataSourceImpl = sl();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings
        .arguments; //the passed arguments to currently generating route.

    switch (settings.name) {
      //the name of the route
      case LOGIN_ROUTE:
        {
          String token = _tokenCashDataSourceImpl.getTokenAsString();
          if (token.isEmpty)
            return MaterialPageRoute(builder: (_) => LoginPage());
          else {
            return MaterialPageRoute(builder: (_) => HomePage());
          }
        }

      case REGISTER_ROUTE:
        return MaterialPageRoute(builder: (_) => RegisterPage());

      case HOME_ROUTE:
        {
          String token = _tokenCashDataSourceImpl.getTokenAsString();
          if (token.isEmpty)
            return MaterialPageRoute(builder: (_) => LoginPage());
          else {
            return MaterialPageRoute(builder: (_) => HomePage());
          }
        }
      case Article_Categories_ROUTE:
        return MaterialPageRoute(builder: (_) => ArticleCategoriesPage());

      case Waiting_For_Approve_Account_ROUTE:
        return MaterialPageRoute(builder: (_) => WaitingForRegister());

      case ARTICLE_SEARCH:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => sl<ArticleBloc>(),
                child: ArticleSearch()));
      case CART_ROUTE:
        return MaterialPageRoute(builder: (_) => CartPage());
      case CONFIRM_VERIFICATION_CODE_ROUTE:
        {
          {
            final args = settings.arguments as String;

            return MaterialPageRoute(
                builder: (_) => BlocProvider(
                      create: (context) =>
                          VerificationCodeBloc(confirmVCodeUseCase: sl()),
                      child: VerificationCodePage(
                        phone: args,
                      ),
                    ));
          }
        }
      // case COURSES_ROUTE:
      //   return MaterialPageRoute(builder: (_) => CouresesPage());

      case Articles_ROUTE:
        final args = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ShopBloc(
                    getArticles: sl(),
                  )..add(ShopPageInitializedEvent(categoryId: args)),
                  child: ArticlesWidget(
                    categoryId: args,
                  ),
                ));

      case NOTIFICATIONS_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => NotificationsPage());
        }
      case NOTIFICATION_ROUTE:
        {
          return MaterialPageRoute(
              builder: (_) => NotificationPage(settings.arguments));
        }
      default:
        {
          String token = _tokenCashDataSourceImpl.getTokenAsString();
          if (token.isEmpty)
            return MaterialPageRoute(builder: (_) => LoginPage());
          else {
            return MaterialPageRoute(builder: (_) => HomePage());
          }
        }
    }
  }
}
