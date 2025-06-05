import 'dart:convert';

import 'package:http/http.dart' as http;

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
        'https://api.chess.com/pub/player/$username/games/$year/${month.toString().padLeft(2, '0')}');
    final response = await _client.get(url);
    if (response.statusCode != 200) {
      throw http.ClientException('Failed to load games', url);
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final games = (data['games'] as List)
        .map((e) => GameDto.fromJson(e as Map<String, dynamic>))
        .toList();
    return games;
  }
}
