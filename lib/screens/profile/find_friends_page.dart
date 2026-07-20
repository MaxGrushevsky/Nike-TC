import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../data/mock/suggested_friends_mock_data.dart';
import '../../models/friend_contact.dart';
import '../../services/contacts_service.dart';

enum FindFriendsTab {
  suggested('Suggested'),
  contacts('Contacts');

  const FindFriendsTab(this.label);

  final String label;
}

class FindFriendsPage extends StatefulWidget {
  const FindFriendsPage({super.key});

  @override
  State<FindFriendsPage> createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  FindFriendsTab _selectedTab = FindFriendsTab.suggested;

  void _onTabSelected(FindFriendsTab tab) {
    setState(() => _selectedTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FIND FRIENDS',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedTab.index,
        children: [
          const _SuggestedTab(),
          _ContactsTab(isActive: _selectedTab == FindFriendsTab.contacts),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: FindFriendsTab.values.map((tab) {
              final isSelected = _selectedTab == tab;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: tab == FindFriendsTab.suggested ? 8 : 0,
                    left: tab == FindFriendsTab.contacts ? 8 : 0,
                  ),
                  child: OutlinedButton(
                    onPressed: () => _onTabSelected(tab),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      backgroundColor: isSelected ? Colors.black : Colors.white,
                      side: BorderSide(
                        color: isSelected ? Colors.black : Colors.grey.shade400,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: Text(
                      tab.label.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _SuggestedTab extends StatelessWidget {
  const _SuggestedTab();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: SuggestedFriendsMockData.friends.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final friend = SuggestedFriendsMockData.friends[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Text(
              friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          title: Text(
            friend.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(friend.subtitle),
          trailing: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey.shade400),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Add'),
          ),
        );
      },
    );
  }
}

class _ContactsTab extends StatefulWidget {
  const _ContactsTab({required this.isActive});

  final bool isActive;

  @override
  State<_ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<_ContactsTab> {
  bool _isLoading = false;
  bool _hasRequested = false;
  ContactsAccessStatus? _accessStatus;
  List<FriendContact> _contacts = const [];

  @override
  void didUpdateWidget(covariant _ContactsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_hasRequested) {
      _loadContacts();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      _loadContacts();
    }
  }

  Future<void> _loadContacts() async {
    _hasRequested = true;
    setState(() {
      _isLoading = true;
      _accessStatus = null;
    });

    final access = await ContactsService.requestAccess();
    if (!mounted) return;

    if (access != ContactsAccessStatus.granted) {
      setState(() {
        _isLoading = false;
        _accessStatus = access;
        _contacts = const [];
      });
      return;
    }

    final contacts = await ContactsService.loadContacts();
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _accessStatus = ContactsAccessStatus.granted;
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive && !_hasRequested) {
      return const SizedBox.shrink();
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_accessStatus == ContactsAccessStatus.denied ||
        _accessStatus == ContactsAccessStatus.permanentlyDenied) {
      return _ContactsPermissionView(
        isPermanentlyDenied:
            _accessStatus == ContactsAccessStatus.permanentlyDenied,
        onRetry: _loadContacts,
      );
    }

    if (_contacts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No contacts found on this device.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _contacts.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Text(
              contact.displayName.isNotEmpty
                  ? contact.displayName[0].toUpperCase()
                  : '?',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          title: Text(
            contact.displayName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: contact.subtitle == null
              ? null
              : Text(contact.subtitle!),
          trailing: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey.shade400),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Invite'),
          ),
        );
      },
    );
  }
}

class _ContactsPermissionView extends StatelessWidget {
  const _ContactsPermissionView({
    required this.isPermanentlyDenied,
    required this.onRetry,
  });

  final bool isPermanentlyDenied;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts_outlined, size: 56, color: Colors.grey.shade500),
            const SizedBox(height: 20),
            const Text(
              'Allow access to Contacts',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This allows you to find and invite friends to Nike from your '
              'Contacts. Nike Training only sends emails from your Contacts to '
              'our servers to help you connect with other Nike members. None of '
              'the information from your Contacts is stored.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isPermanentlyDenied
                    ? FlutterContacts.permissions.openSettings
                    : onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isPermanentlyDenied ? 'OPEN SETTINGS' : 'ALLOW ACCESS',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
