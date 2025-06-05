// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:chess/chess.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';

import '../models/game_dto.dart';

class ChessApi {
  final http.Client _client;

  ChessApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<GameDto>> fetchMonthlyArchive({
    required String username,
    required int year,
    required int month,
  }) async {
    final url = Uri.parse(
      'https://api.chess.com/pub/player/$username/games/$year/${month.toString().padLeft(2, '0')}',
    );
    final response = await _client.get(url);
    if (response.statusCode != 200) {
      throw http.ClientException('Failed to load games', url);
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final games =
        (data['games'] as List)
            .map((e) => GameDto.fromJson(e as Map<String, dynamic>))
            .toList();
    return games;
  }
}

void main() async {
  final Stockfish stockfish = Stockfish();
  
  // Create a subscribtion on stdout : subscription that you'll have to cancel before disposing Stockfish.
  final stockfishSubscription = stockfish.stdout.listen((message) {
    print(message);
  });

  // Create a subscribtion on stderr : subscription that you'll have to cancel before disposing Stockfish.
  final stockfishErrorsSubscription = stockfish.stderr.listen((message) {
    print(message);
  });

  final pos =
      'CurrentPosition "8/2k5/p1p3R1/1pP1P3/5P2/PP4P1/5KB1/8 w - - 1 47"';
  // Chess chess = Chess.fromFEN();
  // print(chess);
  // final client = http.Client();
  // final api = ChessApi(client: client);
  // final games = await api.fetchMonthlyArchive(username: "tirex300", year: 2025, month: 6);
  // print(games.first);

  // for (final game in games) {
  //   print(game);
  // }

  // print(response.body);
  // client.close();
}
