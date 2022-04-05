import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/domain/entities/article.dart';
import 'package:ucookfrontend/features/presentation/bloc/article/article_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/article/article_state.dart';
import 'package:ucookfrontend/features/presentation/pages/item_details_page.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_direction.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_text.dart';
import 'package:ucookfrontend/features/presentation/utils/number_display.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/Search/search_app_bar.dart';
import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/loading_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/message_display.dart';

class ArticleSearch extends StatefulWidget {
  const ArticleSearch({Key? key}) : super(key: key);

  @override
  _ArticleSearchState createState() => _ArticleSearchState();
}

class _ArticleSearchState extends State<ArticleSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(SharedController().scaledHeight(context, 60)),
        child: SearchAppBar(),
      ),
      body: SingleChildScrollView(
        child: buildFloatingSearchBar(),
      ),
    );
  }

  buildFloatingSearchBar() {
    return BlocBuilder<ArticleBloc, ArticleState>(
      builder: (context, state) {
        if (state is Loading) {
          return _loading();
        } else if (state is ArticleSearchNoResultState) {
          return _noDataFound();
        } else if (state is ArticleSearchResultsState) {
          return _dataLoadded(state.result);
        }
        return Text('');
      },
    );
  }

  Widget _dataLoadded(List<Article> data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.white,
        elevation: 4.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: data.map((art) {
            return _articleWidget(art);
          }).toList(),
        ),
      ),
    );
  }

  Widget _noDataFound() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: MediaQuery.of(context).size.height - 130,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width) - 68,
                  child: MessageDisplay(
                    message:
                        getLang(context, "article-search-page-no-data") ?? '',
                    withScaffold: false,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  width: (MediaQuery.of(context).size.width) - 68,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('images/appicon.png'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: MediaQuery.of(context).size.height - 130,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingWidget(
                  withScaffold: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _articleWidget(Article article) {
    final display = createDisplay();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemDetailsPage(
              article: article,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 0.3),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: (MediaQuery.of(context).size.width) - 54,
                    child: MarqueeText(
                      align: TextAlign.start,
                      speed: 15,
                      textDirection: TextDirection.rtl,
                      marqueeDirection: MarqueeDirection.ltr,
                      text: article.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    getLang(context, "search-article-widget-article-price") ??
                        '',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    display(article.unit1price) + ' S.P.',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
