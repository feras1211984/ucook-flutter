import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/domain/entities/articlecategory.dart';
import 'package:ucookfrontend/features/presentation/bloc/articlecategory/article_category_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/articlecategory/article_category_state.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_direction.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_text.dart';
import 'package:ucookfrontend/features/presentation/utils/responsive_flutter_pkg/responsive_flutter.dart';
import 'package:ucookfrontend/features/presentation/utils/routes.dart';

class CategoriesWidget extends StatelessWidget {
  final ArticleCategory articleCategory;

  const CategoriesWidget(this.articleCategory);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCategoryBloc, ArticleCategoryState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (this.articleCategory.id != 0)
              Navigator.pushNamed(context, Articles_ROUTE,
                  arguments: this.articleCategory.id);
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _imageRow(context),
                // Padding(
                //   padding: const EdgeInsets.only(top: 6, bottom: 6),
                //   child:
                _nameRow(context),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imageRow(BuildContext context) {
    String img = this.articleCategory.image;
    if (img.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // padding: EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width / 3.1),
            height: (MediaQuery.of(context).size.width / 3.1),
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
            // padding: EdgeInsets.all(10),
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

  Widget _nameRow(BuildContext context) {
    return Center(
      child: SizedBox(
        width: (MediaQuery.of(context).size.width / 2) - 66,
        child: MarqueeText(
          speed: 15,
          align: TextAlign.center,
          textDirection: TextDirection.rtl,
          marqueeDirection: MarqueeDirection.ltr,
          text: this.articleCategory.name,
          style: TextStyle(
              fontSize: ResponsiveFlutter.of(context).fontSize(2.1),
              fontWeight: FontWeight.bold,
              color: ColorHelper().colorFromHex("#354449")),
        ),
      ),
    );
  }
}
