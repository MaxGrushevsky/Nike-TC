class InboxMessage {
  const InboxMessage({
    required this.id,
    required this.title,
    required this.description,
    required this.receivedAt,
    required this.imageAsset,
    required this.url,
  });

  final String id;
  final String title;
  final String description;
  final DateTime receivedAt;
  final String imageAsset;
  final String url;

  factory InboxMessage.fromJson(Map<String, dynamic> json) {
    return InboxMessage(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      receivedAt: DateTime.parse(json['receivedAt'] as String),
      imageAsset: json['imageAsset'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'receivedAt': receivedAt.toIso8601String(),
      'imageAsset': imageAsset,
      'url': url,
    };
  }
}
