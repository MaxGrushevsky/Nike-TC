class SuggestedFriend {
  const SuggestedFriend({
    required this.id,
    required this.name,
    required this.subtitle,
  });

  final String id;
  final String name;
  final String subtitle;
}

abstract final class SuggestedFriendsMockData {
  SuggestedFriendsMockData._();

  static const friends = [
    SuggestedFriend(
      id: '1',
      name: 'Alex Johnson',
      subtitle: '3 mutual friends',
    ),
    SuggestedFriend(
      id: '2',
      name: 'Maria Garcia',
      subtitle: 'Works out near you',
    ),
    SuggestedFriend(
      id: '3',
      name: 'Chris Lee',
      subtitle: 'Recently joined Nike Training Club',
    ),
  ];
}
