class Match {
  final int id;
  final String homeTeam;
  final String awayTeam;
  final String score;
  final String status;

  Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.status,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      homeTeam: json['homeTeam']['name'],
      awayTeam: json['awayTeam']['name'],
      score: json['score']['fullTime']['homeTeam'].toString() +
          ' - ' +
          json['score']['fullTime']['awayTeam'].toString(),
      status: json['status'],
    );
  }
}