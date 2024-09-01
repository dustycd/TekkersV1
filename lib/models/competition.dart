class Competition {
  final int id;
  final String name;
  final String area;

  Competition({
    required this.id,
    required this.name,
    required this.area,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      id: json['id'],
      name: json['name'],
      area: json['area']['name'],
    );
  }
}