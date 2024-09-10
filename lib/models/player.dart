class Player {
  final int id;
  final String name;
  final String position;
  final String nationality;
  final String team;
  final String imageUrl;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.nationality,
    required this.team,
    required this.imageUrl,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      nationality: json['nationality'],
      team: json['team'],
      imageUrl: json['imageUrl'] ?? 'https://example.com/default-image.png',
    );
  }
}