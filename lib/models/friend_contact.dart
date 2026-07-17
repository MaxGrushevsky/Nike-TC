class FriendContact {
  const FriendContact({
    required this.id,
    required this.displayName,
    this.subtitle,
  });

  final String id;
  final String displayName;
  final String? subtitle;
}
