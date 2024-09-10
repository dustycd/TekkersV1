class Match {
  final int id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String status;
  final String utcDate;
  final String homeTeamLogo;
  final String awayTeamLogo;

  Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.utcDate,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      homeTeam: json['homeTeam']['name'],
      awayTeam: json['awayTeam']['name'],
      homeScore: json['score']['fullTime']['homeTeam'] ?? 0,
      awayScore: json['score']['fullTime']['awayTeam'] ?? 0,
      status: json['status'],
      utcDate: json['utcDate'],
      homeTeamLogo: json['homeTeam']['crest'] ?? '',
      awayTeamLogo: json['awayTeam']['crest'] ?? '',
    );
  }
}