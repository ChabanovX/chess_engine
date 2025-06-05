import 'package:chess_engine/data/models/game_dto.dart';
import 'package:chess_engine/data/sources/chess_api.dart';
import 'package:chess_engine/domain/entities/pgn_game.dart';
import 'package:chess_engine/domain/repos/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final ChessApi api;

  GameRepositoryImpl(this.api);

  @override
  Future<List<PgnGame>> fetchGames({
    required String username,
    required int year,
    required int month,
  }) async {
    final List<GameDto> dtos = await api.fetchMonthlyArchive(
      username: username,
      year: year,
      month: month,
    );

    return dtos
        .map(
          (dto) => PgnGame(
            pgn: dto.pgn,
            endTime: DateTime.fromMillisecondsSinceEpoch(dto.endTime * 1000),
          ),
        )
        .toList();
  }
}
