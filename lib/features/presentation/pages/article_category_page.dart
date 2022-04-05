import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ucookfrontend/features/domain/entities/articlecategory.dart';
import 'package:ucookfrontend/features/presentation/bloc/Constant.dart';
import 'package:ucookfrontend/features/presentation/bloc/articlecategory/article_category_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/articlecategory/article_category_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/articlecategory/article_category_state.dart';
import 'package:ucookfrontend/features/presentation/bloc/carousel/carousel_bloc.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/routes.dart';
import 'package:ucookfrontend/features/presentation/widgets/carousel_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/categories_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/message_display.dart';
import 'package:ucookfrontend/injection_container.dart';

class ArticleCategoriesPage extends StatefulWidget {
  ArticleCategoriesPage({Key? key}) : super(key: key);

  @override
  _ArticleCategoriesState createState() => _ArticleCategoriesState();
}

class _ArticleCategoriesState extends State<ArticleCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          BlocProvider(
            create: (context) =>
                CarouselBloc(getPromosUseCase: sl(), inputConverter: sl()),
            child: CarouselWidget(),
          ),
          buildBody(context),
        ],
      ),
    );
  }

  BlocProvider<ArticleCategoryBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticleCategoryBloc>(),
      child: BlocBuilder<ArticleCategoryBloc, ArticleCategoryState>(
        builder: (context, state) {
          if (state is Empty) {
            BlocProvider.of<ArticleCategoryBloc>(context)
                .add(GetArticleCategory());
          } else if (state is Loading) {
            return _shimmerWidget();
          } else if (state is Loaded) {
            return Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.88),
                itemBuilder: (context, index) => Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: ColorHelper().colorFromHex('#f9f9f9'),
                      border: Border.all(
                        color: ColorHelper().colorFromHex('#989cb8'),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(17),
                      ),
                    ),
                    child: CategoriesWidget(state.articleCategories[index])),
                itemCount: state.articleCategories.length,
                padding: const EdgeInsets.only(top: 0),
              ),
            );
          } else if (state is Error) {
            if (state.message == AUTH_FAILURE_MESSAGE) {
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pushNamed(context, LOGIN_ROUTE);
              });
              return MessageDisplay(
                message: state.message,
                withScaffold: false,
              );
            } else {
              return MessageDisplay(
                message: state.message,
                withScaffold: false,
              );
            }
          }
          return _shimmerWidget();
        },
      ),
    );
  }

  Expanded _shimmerWidget() {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.black54,
        enabled: true,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.88),
          itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ColorHelper().colorFromHex('#f9f9f9'),
                border: Border.all(
                  color: ColorHelper().colorFromHex('#989cb8'),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(17),
                ),
              ),
              child: CategoriesWidget(new ArticleCategory(
                  image: '',
                  name: '',
                  name2: '',
                  relatedId: '0',
                  clientId: '0',
                  id: 0))),
          itemCount: 20,
          padding: const EdgeInsets.only(top: 0),
        ),
      ),
    );

    // return Expanded(
    //   child: Shimmer.fromColors(
    //     baseColor: Colors.grey,
    //     highlightColor: Colors.black54,
    //     enabled: true,
    //     child: ListView.builder(
    //       itemBuilder: (context, index) => CategoriesWidget(
    //         new ArticleCategory(
    //             image: '',
    //             name: '',
    //             name2: '',
    //             relatedId: '0',
    //             clientId: '0',
    //             id: 0),
    //       ),
    //       itemCount: 20,
    //       padding: const EdgeInsets.only(top: 0),
    //     ),
    //   ),
    // );
  }
}
