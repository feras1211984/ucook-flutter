import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CarouselEvent extends Equatable
{
  @override
  List<Object> get props => [];
}
class GetCarouselItem extends CarouselEvent {
  GetCarouselItem();

  @override
  List<Object> get props => [];
}