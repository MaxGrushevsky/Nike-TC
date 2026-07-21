import 'package:flutter/material.dart';

import '../../data/mock/searchable_friends_mock_data.dart';
import '../../models/searchable_friend.dart';
import '../../router.dart';
import '../../services/blocked_friends_service.dart';

class FriendSearchPage extends StatefulWidget {
  const FriendSearchPage({super.key});

  @override
  State<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Set<String> _blockedIds = {};
  List<SearchableFriend> _results = const [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadBlockedIds();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadBlockedIds() async {
    final blockedIds = await BlockedFriendsService.loadBlockedIds();
    if (!mounted) return;
    setState(() => _blockedIds = blockedIds);
    _runSearch(_controller.text);
  }

  void _runSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.length < 3) {
      setState(() {
        _results = const [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _hasSearched = true;
      _results = SearchableFriendsMockData.search(
        trimmed,
        blockedIds: _blockedIds,
      );
    });
  }

  void _onQueryChanged(String value) {
    _runSearch(value);
  }

  void _onCancel() {
    _controller.clear();
    _runSearch('');
    FocusScope.of(context).unfocus();
  }

  Future<void> _openDetails(SearchableFriend friend) async {
    final blocked = await AppRouter.openFriendSearchDetails(context, friend);
    if (blocked != true || !mounted) return;

    final blockedIds = await BlockedFriendsService.loadBlockedIds();
    if (!mounted) return;
    setState(() => _blockedIds = blockedIds);
    _runSearch(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.search,
                      onChanged: _onQueryChanged,
                      decoration: InputDecoration(
                        hintText: 'Search by name or email',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _onCancel,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (!_hasSearched) {
      return const SizedBox.shrink();
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          '0 results',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final friend = _results[index];
        return ListTile(
          onTap: () => _openDetails(friend),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Text(
              friend.initials,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          title: Text(
            friend.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(friend.email),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        );
      },
    );
  }
}
