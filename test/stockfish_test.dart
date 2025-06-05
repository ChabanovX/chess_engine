// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';

void main() {
  group("UseOfStockfish", () {
    late Stockfish stockfish;
    late StreamSubscription stockfishSubscription;
    late StreamSubscription stockfishErrorsSubscription;

    setUp(() async {
      stockfish = Stockfish();
      stockfishSubscription = stockfish.stdout.listen((message) {
        print(message);
      });

      // Create a subscribtion on stderr : subscription that you'll have to cancel before disposing Stockfish.
      stockfishErrorsSubscription = stockfish.stderr.listen((message) {
        print(message);
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      stockfish.stdin = 'uci';
      await Future.delayed(const Duration(milliseconds: 3000));
      stockfish.stdin = 'isready';
    });

    tearDown(() {
      stockfishSubscription.cancel();
      stockfishErrorsSubscription.cancel();
      stockfish.dispose();
    });

    test("Does something", () {
      const pos = r'8/2k5/p1p3R1/1pP1P3/5P2/PP4P1/5KB1/8 w - - 1 47';

      stockfish.stdin = 'position startpos';
      stockfish.stdin = 'position fen $pos';
      stockfish.stdin = 'go movetime 1500';

      print('peins');
    });
  });
}
