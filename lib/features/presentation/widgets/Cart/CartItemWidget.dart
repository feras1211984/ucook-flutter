import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_event.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_direction.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_text.dart';
import 'package:ucookfrontend/features/presentation/utils/number_display.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/Article/article_quantity_cart.dart';

class CartItemWidget extends StatefulWidget {
  CartItemWidget({Key? key, required this.detail}) : super(key: key);
  final WebOrderDetail detail;

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            shape: RoundedRectangleBorder(
              side:
                  BorderSide(color: Theme.of(context).primaryColor, width: 0.3),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              //height: SharedController().scaledHeight(context, 125),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10, right: 10),
                      //   child: CartItemImgWidget(
                      //     detail: widget.detail,
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: _articleInfo(widget.detail),
                      ),
                      _inc()
                    ],
                  ),
                ],
              ),
            )));
  }

  Widget _articleInfo(WebOrderDetail detail) {
    final display = createDisplay();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width) - 110,
              child: MarqueeText(
                align: TextAlign.start,
                speed: 15,
                textDirection: TextDirection.rtl,
                marqueeDirection: MarqueeDirection.ltr,
                text: detail.unitname,
                style: TextStyle(
                    fontFamily: "Bahnschrift",
                    fontWeight: FontWeight.w500,
                    color: ColorHelper().colorFromHex("#354449"),
                    fontSize:
                        SharedController().getAdaptiveTextSize(context, 22)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              getLang(context, "cart-item-widget-article-price") ?? '',
              style: TextStyle(
                  fontFamily: "Bahnschrift",
                  fontSize: SharedController().getAdaptiveTextSize(context, 12),
                  fontWeight: FontWeight.w500,
                  color: ColorHelper().colorFromHex("#354449")),
            ),
            Text(
              display(detail.price),
              style: TextStyle(
                  fontFamily: "Bahnschrift",
                  fontSize: SharedController().getAdaptiveTextSize(context, 16),
                  fontWeight: FontWeight.w500,
                  color: ColorHelper().colorFromHex("#354449")),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              getLang(context, "cart-item-widget-article-total") ?? '',
              style: TextStyle(
                  fontFamily: "Bahnschrift",
                  fontSize: SharedController().getAdaptiveTextSize(context, 12),
                  fontWeight: FontWeight.w500,
                  color: ColorHelper().colorFromHex("#354449")),
            ),
            Text(
              display(detail.price * detail.quantity).toString(),
              style: TextStyle(
                  fontFamily: "Bahnschrift",
                  fontSize: SharedController().getAdaptiveTextSize(context, 16),
                  fontWeight: FontWeight.w500,
                  color: ColorHelper().colorFromHex("#354449")),
            ),
          ],
        )
      ],
    );
  }

  Widget _inc() {
    return Flexible(
        child: Container(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            // height: 36,
            child: IconButton(
              iconSize: SharedController().getAdaptiveTextSize(context, 20),
              icon: Icon(Icons.add),
              splashColor: Theme.of(context).splashColor,
              color: Theme.of(context).primaryColor,
              disabledColor: Color.fromRGBO(150, 150, 150, 1),
              onPressed: () {
                BlocProvider.of<CartBloc>(context).add(
                  ItemAddingCartEvent(
                    articleId: this.widget.detail.article_id,
                    unitName: this.widget.detail.unitname,
                    unitPrice: this.widget.detail.price,
                  ),
                );
              },
            ),
          ),
          Container(
            // height: 28,
            child: ArticleQuantityCart(
              articleId: widget.detail.article_id,
              number: widget.detail.quantity,
              color: ColorHelper().colorFromHex("#354449"),
            ),
          ),
          Container(
            // height: 36,
            child: IconButton(
              iconSize: SharedController().getAdaptiveTextSize(context, 20),
              icon: Icon(Icons.remove),
              color: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).splashColor,
              onPressed: () {
                BlocProvider.of<CartBloc>(context).add(
                  ItemDeleteCartEvent(
                    articleId: this.widget.detail.article_id,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
