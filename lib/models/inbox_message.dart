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
}
