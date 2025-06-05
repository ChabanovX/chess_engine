import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/pgn_game.dart';
import '../../domain/usecases/fetch_games_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FetchGamesUseCase _fetchGames;

  HomeCubit(this._fetchGames) : super(HomeInitial());

  Future<void> fetch(String username, int year, int month) async {
    emit(HomeFetching());
    final games =
        await _fetchGames(username: username, year: year, month: month);
    emit(HomeLoaded(games));
  }
}
