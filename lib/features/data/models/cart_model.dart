import 'package:ucookfrontend/features/domain/entities/article.dart';
import 'package:ucookfrontend/features/domain/entities/cart.dart';

class CartModel extends Cart {
  List<Article> articles;
  double _cartTotal = 0;
  double tax;
  double delivery;
  double discount;
  double total;
  CartModel(
      {required this.articles,
      required this.delivery,
      required this.discount,
      required this.tax,
      required this.total})
      : super(
            articles: articles,
            delivery: delivery,
            discount: discount,
            tax: tax,
            total: total);

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        articles: json['articles'],
        tax: json['tax'],
        delivery: json['delivery'],
        discount: json['discount'],
        total: json['total']);
  }

  Map<String, dynamic> toJson() {
    return {
      'articles': articles,
      'tax': tax,
      'delivery': delivery,
      'discount': discount,
      'total': total
    };
  }
}
