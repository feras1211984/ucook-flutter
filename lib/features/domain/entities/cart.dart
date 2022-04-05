import 'package:ucookfrontend/features/domain/entities/article.dart';

class Cart {
  List<Article> articles = [];
  double _totalPrice = 0;
  double tax;
  double delivery;
  double discount;
  double total;
  Cart(
      {required this.articles,
      required this.delivery,
      required this.discount,
      required this.tax,
      required this.total});
}
