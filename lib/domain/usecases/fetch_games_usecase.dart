import 'package:chess_engine/domain/repos/game_repository.dart';

import '../entities/pgn_game.dart';

class FetchGamesUseCase {
  final GameRepository repo;

  FetchGamesUseCase(this.repo);

  Future<List<PgnGame>> call({
    required String username,
    required int year,
    required int month,
  }) async {
    final games = await repo.fetchGames(
      username: username,
      year: year,
      month: month,
    );
    games.sort((a, b) => b.endTime.compareTo(a.endTime));
    return games;
  }
}
