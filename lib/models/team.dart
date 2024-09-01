class Team {
  final int id;
  final String name;
  final String logoUrl;

  Team({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'] ?? 'https://example.com/default-logo.png',
    );
  }
}