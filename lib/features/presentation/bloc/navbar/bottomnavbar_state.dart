part of 'bottomnavbar_bloc.dart';

class BottomNavigationState extends Equatable {
  BottomNavigationState(props);
  @override
  List<Object> get props => [];
}

class CurrentIndexChanged extends BottomNavigationState {
  final int currentIndex;

  CurrentIndexChanged({required this.currentIndex}) : super([currentIndex]);

  @override
  String toString() => 'CurrentIndexChanged to $currentIndex';
}

class PageLoading extends BottomNavigationState {
  PageLoading(props) : super(props);

  @override
  String toString() => 'PageLoading';
}

class FirstPageLoaded extends BottomNavigationState {
  final String text;
  FirstPageLoaded({required this.text}) : super([text]);
  @override
  String toString() => 'FirstPageLoaded with text: $text';
}
class SecondPageLoaded extends BottomNavigationState {
  final int number;

  SecondPageLoaded({required this.number}) : super([number]);

  @override
  String toString() => 'SecondPageLoaded with number: $number';
}
