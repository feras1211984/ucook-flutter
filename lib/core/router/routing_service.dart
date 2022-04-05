import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../features/presentation/pages/article_category_page.dart';
import '../../features/presentation/pages/home_page.dart';

class RoutingService {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => (HomePage()));
      case '/ArticleCategories':
        return MaterialPageRoute(builder: (_) => ArticleCategoriesPage());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
