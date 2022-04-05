import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ArticleCategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetArticleCategory extends ArticleCategoryEvent {
    GetArticleCategory();

  @override
  List<Object> get props => [];
}
