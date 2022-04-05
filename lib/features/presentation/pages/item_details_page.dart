import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/domain/entities/article.dart';
import 'package:ucookfrontend/features/domain/entities/article_media.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_event.dart'
    as CartEvents;
import 'package:ucookfrontend/features/presentation/bloc/order/order_state.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_state.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_direction.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_text.dart';
import 'package:ucookfrontend/features/presentation/utils/number_display.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/Article/article_quantity_cart.dart';
import 'package:ucookfrontend/features/presentation/widgets/app_bar_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/carousel_with_indicator.dart';
import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/item-detail-name-description.dart';
import 'package:ucookfrontend/features/presentation/widgets/loading_widget.dart';
import 'package:ucookfrontend/injection_container.dart';

class ItemDetailsPage extends StatefulWidget {
  final Article article;
  ItemDetailsPage({required this.article});
  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => () {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(SharedController().scaledHeight(context, 60)),
        child: CustomAppBar(
          showSearch: true,
          showCart: false,
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(child: _body()),
    );
  }

  BlocProvider<ShopBloc> _carousel() {
    return BlocProvider(
        create: (_) => sl<ShopBloc>(),
        child: BlocBuilder<ShopBloc, ShopState>(
          builder: (context, state) {
            if (state is ShopInitial) {
              BlocProvider.of<ShopBloc>(context).add(
                  GetArticleMediaEvent(articleId: widget.article.relatedId));
              return LoadingWidget(
                withScaffold: false,
              );
            } else if (state is ArticleMediaLoaddedState) {
              return _carouselBody(state.items);
            } else if (state is Loading) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ));
  }

  Widget _body() {
    return Container(
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 2.8,
              child: _carousel()),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Stack(
              children: <Widget>[
                ItemDetailDescription(),
                _articleName(),
                _incrDecrQuantity(),
                _articleDetails()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _articleDetails() {
    return Padding(
      padding:
          EdgeInsets.only(top: SharedController().scaledHeight(context, 100)),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 430,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          _articleDetailsLable(),
          _articleDetailsContent()
        ],
      ),
    );
  }

  Widget _carouselBody(List<ArticleMedia> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 75),
      child: CarouselWithIndicator(itemList: items),
    );
  }

  Widget _articleName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: SharedController().scaledHeight(context, 10),
              right: 30,
              left: 30),
          child: Container(
            width: MediaQuery.of(context).size.width - 60,
            child: MarqueeText(
              align: TextAlign.start,
              speed: 15,
              textDirection: TextDirection.rtl,
              marqueeDirection: MarqueeDirection.ltr,
              text: widget.article.name,
              style: TextStyle(
                  fontSize: SharedController().getAdaptiveTextSize(context, 22),
                  fontFamily: "Bahnschrift",
                  fontWeight: FontWeight.bold,
                  color: ColorHelper().colorFromHex("#354449")),
            ),
          ),
        ),
      ],
    );
  }

  Widget _articlePrice() {
    final display = createDisplay();
    return Padding(
      padding: EdgeInsets.only(
        top: SharedController().scaledHeight(context, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(display(widget.article.unit1price) + ' .SP',
              // Text(widget.article.unit1price.toString() + ' .SP',
              style: TextStyle(
                  fontFamily: "Bahnschrift",
                  color: ColorHelper().colorFromHex('#354449'),
                  fontSize: SharedController().getAdaptiveTextSize(context, 22),
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _incrDecrQuantity() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 50, left: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _articlePrice(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize:
                        SharedController().getAdaptiveTextSize(context, 20),
                    alignment: Alignment.bottomCenter,
                    icon: Icon(
                      Icons.add,
                      color: ColorHelper().colorFromHex('#354449'),
                    ),
                    onPressed: () {
                      BlocProvider.of<CartBloc>(context).add(
                        CartEvents.ItemAddingCartEvent(
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
                    padding: const EdgeInsets.only(top: 10),
                    child: ArticleQuantityCart(
                      articleId: widget.article.id,
                      number: _getNumber(widget.article.id),
                      color: ColorHelper().colorFromHex('#354449'),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    iconSize:
                        SharedController().getAdaptiveTextSize(context, 20),
                    alignment: Alignment.bottomCenter,
                    icon: Icon(
                      Icons.remove,
                      color: ColorHelper().colorFromHex('#354449'),
                    ),
                    onPressed: () {
                      BlocProvider.of<CartBloc>(context).add(
                        CartEvents.ItemDeleteCartEvent(
                          articleId: this.widget.article.id,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _articleDetailsLable() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              bottom: 35,
              right: 20,
              left: 20,
              top: SharedController().scaledHeight(context, 10)),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              getLang(context, "item-detail-page-article-details-lable") ?? '',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontFamily: 'GESS',
                  color: ColorHelper().colorFromHex('#354449'),
                  fontSize: SharedController().getAdaptiveTextSize(context, 22),
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _articleDetailsContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.only(
            top: SharedController().scaledHeight(context, 50),
            right: 20,
            left: 20),
        child: Column(children: [
          Row(
            children: [
              Text(
                getLang(context,
                        "item-detail-page-article-description-lable") ??
                    '',
                style: TextStyle(
                    fontFamily: 'GESS',
                    color: ColorHelper().colorFromHex('#354449'),
                    fontSize:
                        SharedController().getAdaptiveTextSize(context, 20),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 8, left: 8),
                width: MediaQuery.of(context).size.width * 0.70,
                child: Center(
                  child: Text(
                    widget.article.model,
                    style: TextStyle(
                        fontFamily: 'Bahnschrift',
                        color: ColorHelper().colorFromHex('#354449'),
                        fontSize:
                            SharedController().getAdaptiveTextSize(context, 17),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      getLang(context,
                              "item-detail-page-article-dimensions-lable") ??
                          '',
                      style: TextStyle(
                          fontFamily: 'GESS',
                          color: ColorHelper().colorFromHex('#354449'),
                          fontSize: SharedController()
                              .getAdaptiveTextSize(context, 14),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8, left: 8),
                      child: Text(
                        widget.article.size,
                        style: TextStyle(
                            fontFamily: 'Bahnschrift',
                            color: ColorHelper().colorFromHex('#354449'),
                            fontSize: SharedController()
                                .getAdaptiveTextSize(context, 12),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Text(
                      getLang(context,
                              "item-detail-page-article-packing-lable") ??
                          '',
                      style: TextStyle(
                          fontFamily: 'GESS',
                          color: ColorHelper().colorFromHex('#354449'),
                          fontSize: SharedController()
                              .getAdaptiveTextSize(context, 14),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8, left: 8),
                      child: Text(
                        widget.article.color,
                        style: TextStyle(
                            fontFamily: 'Bahnschrift',
                            color: ColorHelper().colorFromHex('#354449'),
                            fontSize: SharedController()
                                .getAdaptiveTextSize(context, 12),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
