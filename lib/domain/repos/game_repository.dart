import 'package:chess_engine/domain/entities/pgn_game.dart';

abstract class GameRepository {
  Future<List<PgnGame>> fetchGames({
    required String username,
    required int year,
    required int month,
  });
}
