part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeFetching extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PgnGame> games;
  const HomeLoaded(this.games);

  @override
  List<Object?> get props => [games];
}

class HomePagination extends HomeLoaded {
  const HomePagination(List<PgnGame> games) : super(games);
}
