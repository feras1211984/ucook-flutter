import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/domain/entities/article.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_state.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_direction.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_text.dart';
import 'package:ucookfrontend/features/presentation/utils/number_display.dart';
import 'package:ucookfrontend/features/presentation/utils/responsive_flutter_pkg/responsive_flutter.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';

import 'article_quantity_cart.dart';

class ArticleImgWidget extends StatefulWidget {
  ArticleImgWidget({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  _ArticleImgWidgetState createState() => _ArticleImgWidgetState();
}

class _ArticleImgWidgetState extends State<ArticleImgWidget> {
  double totalAmount = 0;

  void calculateTotalAmount(WebOrder items) {
    double res = 0;

    items.webOrderDetails.forEach((element) {
      res = res + element.price * element.quantity;
    });
    totalAmount = res;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _imageRow(),
              Padding(
                padding: EdgeInsets.only(
                    top: SharedController().scaledHeight(context, 6),
                    bottom: SharedController().scaledHeight(context, 6)),
                child: _nameRow(),
              ),
              _priceRow(),
              _quantityRow(),
            ],
          ),
        );
      },
    );
  }

  Widget _imageRow() {
    // var img = Image.network('https://ucook.alkhazensoft.net/storage/' + this.widget.article.image);
    String img = this.widget.article.thumbnail;
    if (img.isEmpty) {
      return Row(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: SharedController().scaledHeight(context, 10),
                bottom: SharedController().scaledHeight(context, 10)),
            width: (MediaQuery.of(context).size.width / 2.8),
            height: (MediaQuery.of(context).size.width / 2.8),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('images/appicon.png'),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: SharedController().scaledHeight(context, 10),
                bottom: SharedController().scaledHeight(context, 10)),
            width: (MediaQuery.of(context).size.width / 3.1),
            height: (MediaQuery.of(context).size.width / 3.1),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://ucook.alkhazensoft.net/storage/' + img),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _nameRow() {
    return Row(
      children: [
        Container(
          width: (MediaQuery.of(context).size.width / 2) - 66,
          child: MarqueeText(
            align: TextAlign.center,
            speed: 15,
            textDirection: TextDirection.rtl,
            marqueeDirection: MarqueeDirection.ltr,
            text: this.widget.article.name,
            style: TextStyle(
              color: SharedController().colorFromHex('#354449'),
              fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _quantityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            IconButton(
              iconSize: ResponsiveFlutter.of(context).fontSize(2.1),
              alignment: Alignment.bottomCenter,
              icon: Icon(
                Icons.add,
                color: ColorHelper().colorFromHex('#354449'),
              ),
              onPressed: () {
                BlocProvider.of<CartBloc>(context).add(
                  ItemAddingCartEvent(
                    articleId: this.widget.article.id,
                    unitName: this.widget.article.name,
                    unitPrice: this.widget.article.unit1price,
                  ),
                );
              },
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: SharedController().scaledHeight(context, 10),
              ),
              child: ArticleQuantityCart(
                articleId: widget.article.id,
                number: _getNumber(widget.article.id),
                color: ColorHelper().colorFromHex("#354449"),
              ),
            ),
          ],
        ),
        Column(
          children: [
            IconButton(
              iconSize: ResponsiveFlutter.of(context).fontSize(2.1),
              alignment: Alignment.bottomCenter,
              icon: Icon(
                Icons.remove,
                color: ColorHelper().colorFromHex('#354449'),
              ),
              onPressed: () {
                BlocProvider.of<CartBloc>(context).add(
                  ItemDeleteCartEvent(
                    articleId: this.widget.article.id,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  int _getNumber(int articleId) {
    return BlocProvider.of<CartBloc>(context)
        .webOrder
        .webOrderDetails
        .firstWhere((element) => element.article_id == articleId,
            orElse: () => WebOrderDetail(
                unitname: '', article_id: -1, price: 0, quantity: 0))
        .quantity;
  }

  Widget _priceRow() {
    final display = createDisplay();
    return Row(
      children: [
        Container(
          width: (MediaQuery.of(context).size.width / 2) - 66,
          child: MarqueeText(
            align: TextAlign.center,
            speed: 15,
            textDirection: TextDirection.rtl,
            marqueeDirection: MarqueeDirection.ltr,
            text: display(this.widget.article.unit1price) + '  ' + 'SP',
            style: TextStyle(
              color: ColorHelper().colorFromHex('#354449'),
              fontSize: ResponsiveFlutter.of(context).fontSize(2),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
