class Team {
  final int id;
  final String name;
  final String logoUrl;
  final String? league;
  final String? stadium;
  final String? formation;

  Team({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.league,
    this.stadium,
    this.formation,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],  // Assuming 'id' is an integer in the API response
      name: json['name'],  // Assuming 'name' is a string in the API response
      logoUrl: json['logoUrl'],  // Assuming 'logoUrl' is a string in the API response
      league: json['league'],  // 'league' is optional in the API response
      stadium: json['stadium'],  // 'stadium' is optional in the API response
      formation: json['formation'],  // 'formation' is optional in the API response
    );
  }
}