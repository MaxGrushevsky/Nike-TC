import '../models/inbox_message.dart';

abstract final class InboxMockData {
  InboxMockData._();

  static const _images = [
    'assets/images/login_background.jpg',
    'assets/images/login_background_2.jpg',
  ];

  static final List<InboxMessage> messages = [
    InboxMessage(
      id: '1',
      title: 'New workout plan ready',
      description:
          'Your 4-week strength plan is ready. Start with day one and build momentum.',
      receivedAt: DateTime(2026, 7, 6, 9, 30),
      imageAsset: _images[0],
      url: 'https://www.nike.com/',
    ),
    InboxMessage(
      id: '2',
      title: 'Weekly progress summary',
      description:
          'You completed 3 workouts this week. Keep going to hit your goal.',
      receivedAt: DateTime(2026, 7, 5, 18, 15),
      imageAsset: _images[1],
      url: 'https://www.nike.com/running',
    ),
    InboxMessage(
      id: '3',
      title: 'Coach tip: recovery day',
      description:
          'Take a light mobility session today to stay consistent and avoid burnout.',
      receivedAt: DateTime(2026, 7, 4, 8, 0),
      imageAsset: _images[0],
      url: 'https://www.nike.com/training',
    ),
    InboxMessage(
      id: '4',
      title: 'New collection: Core Strength',
      description:
          'Explore focused core workouts designed for all fitness levels.',
      receivedAt: DateTime(2026, 7, 2, 14, 45),
      imageAsset: _images[1],
      url: 'https://www.nike.com/w',
    ),
    InboxMessage(
      id: '5',
      title: 'Member reward unlocked',
      description:
          'You earned a new badge for completing five workouts in a row.',
      receivedAt: DateTime(2026, 6, 30, 11, 20),
      imageAsset: _images[0],
      url: 'https://www.nike.com/help',
    ),
  ];

  static Future<List<InboxMessage>> refresh() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return List<InboxMessage>.unmodifiable(messages);
  }
}
