import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/article/article_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/article/article_event.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';

class SearchAppBar extends StatefulWidget {
  @override
  SearchAppBarState createState() => SearchAppBarState();
}

class SearchAppBarState extends State<SearchAppBar> {
  final searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Row(
          children: <Widget>[
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 28,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ],
            ),
            Container(
              width: SharedController().scaledWidth(context, 252),
              child: TextFormField(
                controller: searchTextController,
                onFieldSubmitted: (text) {
                  BlocProvider.of<ArticleBloc>(context)
                      .add(ArticleSearchEvent(searchText: text));
                },
                textInputAction: TextInputAction.search,
                autofocus: true,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontFamily: "Bahnschrift",
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: getLang(context, "app-bar-search-hint") ?? '',
                    suffixIcon: searchTextController.text.length > 0
                        ? IconButton(
                            onPressed: () {
                              searchTextController.clear();
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.clear,
                              size: 18,
                              color: Colors.black,
                            ))
                        : null),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          child: IconButton(
            icon: Icon(
              Icons.search,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {
              BlocProvider.of<ArticleBloc>(context).add(
                  ArticleSearchEvent(searchText: searchTextController.text));
            },
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    );
  }
}
