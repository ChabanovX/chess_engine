class GameDto {
  final String pgn;
  final int endTime;

  GameDto({required this.pgn, required this.endTime});

  factory GameDto.fromJson(Map<String, dynamic> json) {
    return GameDto(
      pgn: json['pgn'] as String,
      endTime: json['end_time'] as int,
    );
  }

  @override
  String toString() {
    return "Game: pgn - $pgn; endTime - $endTime";
  }
}
