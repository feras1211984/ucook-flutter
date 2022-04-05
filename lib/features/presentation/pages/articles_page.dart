import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/data/models/cart_model.dart';
import 'package:ucookfrontend/features/domain/entities/article.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/shop/shop_state.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/Article/article_img_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/app_bar_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/loading_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/message_display.dart';

import 'item_details_page.dart';

class ArticlesWidget extends StatefulWidget {
  final int categoryId;
  late CartModel thisCart;

  ArticlesWidget({required this.categoryId});

  @override
  _ArticlesWidgetState createState() => _ArticlesWidgetState();
}

class _ArticlesWidgetState extends State<ArticlesWidget> {
  bool loadingData = true;
  List<Article> shopItems = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(SharedController().scaledHeight(context, 60)),
        child: CustomAppBar(
          showCart: true,
          showSearch: true,
          showBackButton: true,
        ),
      ),
      body: BlocConsumer<ShopBloc, ShopState>(
        listener: (context, state) {
          if (state is LoadingState) {
            final snackBar = SnackBar(
              content: const Text('Loading Data'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state is ShopInitial) {
            loadingData = true;
            return LoadingWidget(
              withScaffold: false,
            );
          } else if (state is ShopPageLoadedState) {
            BlocProvider.of<ShopBloc>(context).isFetching = false;
            shopItems.addAll(state.shopData);
            loadingData = false;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (shopItems.length <= 0)
              return MessageDisplay(
                message: getLang(context, "article-page-no-data") ?? '',
                withScaffold: false,
              );
          } else if (state is FetchingSuccessState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            shopItems.addAll(state.shopData);
            loadingData = false;
            BlocProvider.of<ShopBloc>(context).isFetching = false;
          }
          return dataLoaded();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget dataLoaded() {
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.7),
        controller: _scrollController
          ..addListener(() {
            if (_scrollController.offset ==
                    _scrollController.position.maxScrollExtent &&
                !BlocProvider.of<ShopBloc>(context).isFetching)
              BlocProvider.of<ShopBloc>(context)
                ..isFetching = true
                ..add(ArticleFetchEvent(categoryId: this.widget.categoryId));
          }),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ItemDetailsPage(
                  article: shopItems[index],
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: SharedController().scaledHeight(context, 1),
                  bottom: SharedController().scaledHeight(context, 1),
                  left: SharedController().scaledWidth(context, 1),
                  right: SharedController().scaledWidth(context, 1),
                ),
                margin: EdgeInsets.only(
                  top: SharedController().scaledHeight(context, 10),
                  bottom: SharedController().scaledHeight(context, 10),
                  left: SharedController().scaledWidth(context, 10),
                  right: SharedController().scaledWidth(context, 10),
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorHelper().colorFromHex('#989cb8'),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(17),
                  ),
                ),
                child: ArticleImgWidget(
                  article: shopItems[index],
                ),
              ),
            ],
          ),
        ),
        itemCount: shopItems.length,
      ),
    );
  }
}
