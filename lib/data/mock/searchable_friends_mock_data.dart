import '../../models/searchable_friend.dart';

abstract final class SearchableFriendsMockData {
  SearchableFriendsMockData._();

  static const friends = [
    SearchableFriend(
      id: 'sf-1',
      name: 'Alex Johnson',
      email: 'alex.johnson@email.com',
      subtitle: '3 mutual friends',
      hometown: 'Portland, OR',
      bio: 'Runner and basketball fan.',
    ),
    SearchableFriend(
      id: 'sf-2',
      name: 'Maria Garcia',
      email: 'maria.garcia@email.com',
      subtitle: 'Works out near you',
      hometown: 'Los Angeles, CA',
      bio: 'Yoga and strength training.',
    ),
    SearchableFriend(
      id: 'sf-3',
      name: 'Chris Lee',
      email: 'chris.lee@email.com',
      subtitle: 'Recently joined Nike Training Club',
      hometown: 'Seattle, WA',
      bio: 'Training for my first marathon.',
    ),
    SearchableFriend(
      id: 'sf-4',
      name: 'Jordan Smith',
      email: 'jordan.smith@email.com',
      subtitle: '5 mutual friends',
      hometown: 'Chicago, IL',
      bio: 'HIIT workouts every morning.',
    ),
    SearchableFriend(
      id: 'sf-5',
      name: 'Sam Patel',
      email: 'sam.patel@email.com',
      subtitle: 'Member since 2021',
      hometown: 'New York, NY',
      bio: 'Cycling and outdoor runs.',
    ),
    SearchableFriend(
      id: 'sf-6',
      name: 'Taylor Kim',
      email: 'taylor.kim@email.com',
      subtitle: '2 mutual friends',
      hometown: 'Austin, TX',
      bio: 'Boxing and mobility work.',
    ),
  ];

  static List<SearchableFriend> search(
    String query, {
    required Set<String> blockedIds,
  }) {
    final normalized = query.trim().toLowerCase();
    if (normalized.length < 3) {
      return const [];
    }

    return friends
        .where((friend) => !blockedIds.contains(friend.id))
        .where((friend) {
          return friend.name.toLowerCase().contains(normalized) ||
              friend.email.toLowerCase().contains(normalized);
        })
        .toList();
  }
}
