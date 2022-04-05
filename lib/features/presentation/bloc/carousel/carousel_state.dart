import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/domain/entities/promos.dart';

enum CarouselStatus { initial, success, failure }

class CarouselState extends Equatable {
  final String name;
  final int count;
  final int position;

  final CarouselStatus carouselStatus;
  final List<Promos> promos;
  const CarouselState({
    this.carouselStatus = CarouselStatus.initial,
    this.promos = const <Promos>[],
    this.name = "",
    this.count = 0,
    this.position = 0,
  });

  @override
  List<Object?> get props => [carouselStatus, promos];

  CarouselState copyWith({
    CarouselStatus? status,
    List<Promos>? promos,
    bool? hasReachedMax,
    String? name,
    int? count,
    int? position,
  }) {
    return CarouselState(
      carouselStatus: status ?? this.carouselStatus,
      promos: promos ?? this.promos,
      name: name ?? this.name,
      count: count ?? this.count,
      position: position ?? this.position,
    );
  }
}

class Empty extends CarouselState {}

class Loading extends CarouselState {}

class Loaded extends CarouselState {
  final List<Promos> promos;

  Loaded({required this.promos});

  @override
  List<Object> get props => [promos];
}

class Error extends CarouselState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
