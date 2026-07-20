class SearchableFriend {
  const SearchableFriend({
    required this.id,
    required this.name,
    required this.email,
    this.subtitle,
    this.hometown,
    this.bio,
  });

  final String id;
  final String name;
  final String email;
  final String? subtitle;
  final String? hometown;
  final String? bio;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
