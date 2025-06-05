import 'dart:io';

import 'package:chess_engine/data/repos/game_repository_impl.dart';
import 'package:chess_engine/domain/repos/game_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import 'package:chess_engine/data/sources/chess_api.dart';
import 'package:chess_engine/domain/usecases/fetch_games_usecase.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('FetchGamesUseCase', () {
    late MockHttpClient client;
    late ChessApi api;
    late FetchGamesUseCase useCase;
    late GameRepository repo;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      client = MockHttpClient();
      api = ChessApi(client: client);
      repo = GameRepositoryImpl(api);
      useCase = FetchGamesUseCase(repo);
    });

    test('parses and sorts games by end_time desc', () async {
      final fixture =
          File('test/fixtures/hikaru_2025_05.json').readAsStringSync();
      when(
        () => client.get(any()),
      ).thenAnswer((_) async => http.Response(fixture, 200));

      final games = await useCase(username: 'hikaru', year: 2025, month: 5);

      expect(games, hasLength(2));
      expect(games.first.endTime.isAfter(games.last.endTime), isTrue);
    });
  });
}
