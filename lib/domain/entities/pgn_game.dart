import 'package:equatable/equatable.dart';

class PgnGame extends Equatable {
  final String pgn;
  final DateTime endTime;

  const PgnGame({required this.pgn, required this.endTime});

  @override
  List<Object?> get props => [pgn, endTime];
}
