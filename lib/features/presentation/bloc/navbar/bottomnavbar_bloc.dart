import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottomnavbar_event.dart';
part 'bottomnavbar_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  int currentIndex = 0;

  BottomNavigationBloc() : super(PageLoading('constructor'));

  @override
  BottomNavigationState get initialState => PageLoading('PageLoading');
  @override
  Stream<BottomNavigationState> mapEventToState(
      BottomNavigationEvent event) async* {
    if (event is AppStarted) {
      PageTapped(index: this.currentIndex);
    }
    if (event is PageTapped) {
      this.currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: this.currentIndex);
      yield PageLoading('PageLoaded');

      if (this.currentIndex == 0) {
      } else if (this.currentIndex == 1) {
      } else if (this.currentIndex == 2) {
      } else if (this.currentIndex == 3) {}
    }
  }
}
