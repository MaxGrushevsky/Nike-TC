import '../mock/inbox_mock_data.dart';
import '../../models/inbox_message.dart';
import '../../services/inbox_persistence_service.dart';

class InboxRepository {
  Future<List<InboxMessage>> loadMessages() async {
    final dismissedIds = await InboxPersistenceService.loadDismissedIds();
    final cachedMessages = await InboxPersistenceService.loadMessages();
    final source = cachedMessages ?? InboxMockData.messages;

    return source.where((message) => !dismissedIds.contains(message.id)).toList();
  }

  Future<List<InboxMessage>> refresh() async {
    final dismissedIds = await InboxPersistenceService.loadDismissedIds();
    final messages = await InboxMockData.fetchMessages();
    final visibleMessages = messages
        .where((message) => !dismissedIds.contains(message.id))
        .toList();

    await InboxPersistenceService.saveMessages(visibleMessages);
    return visibleMessages;
  }

  Future<List<InboxMessage>> dismissMessage(
    String messageId,
    List<InboxMessage> currentMessages,
  ) async {
    await InboxPersistenceService.addDismissedId(messageId);

    final updatedMessages = currentMessages
        .where((message) => message.id != messageId)
        .toList();
    await InboxPersistenceService.saveMessages(updatedMessages);
    return updatedMessages;
  }

  Future<void> seedIfNeeded() async {
    final cachedMessages = await InboxPersistenceService.loadMessages();
    if (cachedMessages != null) {
      return;
    }

    await InboxPersistenceService.saveMessages(InboxMockData.messages);
  }
}
