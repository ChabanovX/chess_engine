// ignore_for_file: avoid_print
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('UseOfStockfish (iOS)', () {
    late Stockfish stockfish;
    late StreamSubscription<String> outsub;
    late StreamSubscription<String> errsub;

    setUp(() async {
      stockfish = Stockfish();
      print(stockfish.state);
      outsub = stockfish.stdout.listen(print);
      errsub = stockfish.stderr.listen(print);

      await Future.delayed(const Duration(milliseconds: 1500));
      stockfish.stdin = 'uci';
      await Future.delayed(const Duration(milliseconds: 3000));
      stockfish.stdin = 'isready';

      print(stockfish.state);
    });

    tearDown(() async {
      await outsub.cancel();
      await errsub.cancel();
      stockfish.dispose();
    });

    testWidgets('Evaluate FEN', (tester) async {
      const pos = r'8/2k5/p1p3R1/1pP1P3/5P2/PP4P1/5KB1/8 w - - 1 47';

      stockfish.stdin = 'position startpos';
      stockfish.stdin = 'position fen $pos';
      stockfish.stdin = 'go movetime 1500';

      final bestLine = await stockfish.stdout
          .firstWhere((l) => l.startsWith('bestmove'))
          .timeout(const Duration(seconds: 5));

      expect(bestLine.startsWith('bestmove'), isTrue);
      print(bestLine); // e.g. “bestmove g2f3”
    });
  });
}
