import '../../data/sources/chess_api.dart';
import '../../data/models/game_dto.dart';
import '../entities/pgn_game.dart';

class FetchGamesUseCase {
  final ChessApi api;

  FetchGamesUseCase(this.api);

  Future<List<PgnGame>> call({
    required String username,
    required int year,
    required int month,
  }) async {
    final dtos = await api.fetchMonthlyArchive(
      username: username,
      year: year,
      month: month,
    );

    final games =
        dtos
            .map(
              (dto) => PgnGame(
                pgn: dto.pgn,
                endTime: DateTime.fromMillisecondsSinceEpoch(
                  dto.endTime * 1000,
                ),
              ),
            )
            .toList();
    games.sort((a, b) => b.endTime.compareTo(a.endTime));
    return games;
  }
}
