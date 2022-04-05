part of 'bottomnavbar_bloc.dart';

abstract class BottomNavigationEvent  extends Equatable {
  BottomNavigationEvent (props);
  @override
  List<Object> get props => [];
}

class AppStarted extends BottomNavigationEvent  {
  AppStarted(props) : super(props);

  @override
  String toString() => 'AppStarted';
}

class PageTapped extends BottomNavigationEvent  {
  final int index;

  PageTapped({required this.index}) : super([index]);

  @override
  String toString() => 'PageTapped: $index';
}
