class Transfer {
  final String player;
  final String fromTeam;
  final String toTeam;
  final String transferFee;
  final String transferType;
  final String transferDate;
  final String playerImageUrl;

  Transfer({
    required this.player,
    required this.fromTeam,
    required this.toTeam,
    required this.transferFee,
    required this.transferType,
    required this.transferDate,
    required this.playerImageUrl,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      player: json['player']['data']['display_name'] ?? 'Unknown Player',
      fromTeam: json['from_team']['data']['name'] ?? 'Unknown Team',
      toTeam: json['to_team']['data']['name'] ?? 'Unknown Team',
      transferFee: json['amount'] ?? 'Unknown',
      transferType: json['type'] ?? 'Unknown',
      transferDate: json['confirmedAt'] ?? 'Unknown Date',
      playerImageUrl: json['player']['data']['image_path'] ?? 'https://example.com/default-player.png',
    );
  }
}