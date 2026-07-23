import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../data/mock/searchable_friends_mock_data.dart';
import '../../models/searchable_friend.dart';
import '../../redux/app_state.dart';
import '../../redux/profile/profile_actions.dart';
import '../../router.dart';

class FriendSearchPage extends StatefulWidget {
  const FriendSearchPage({super.key});

  @override
  State<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<SearchableFriend> _results = const [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      StoreProvider.of<AppState>(
        context,
      ).dispatch(const LoadBlockedFriendsAction());
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _runSearch(String query, Set<String> blockedIds) {
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
        blockedIds: blockedIds,
      );
    });
  }

  void _onCancel() {
    _controller.clear();
    setState(() {
      _results = const [];
      _hasSearched = false;
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _openDetails(SearchableFriend friend) async {
    final blocked = await AppRouter.openFriendSearchDetails(context, friend);
    if (blocked != true || !mounted) return;

    final blockedIds =
        StoreProvider.of<AppState>(context).state.profile.blockedFriendIds;
    _runSearch(_controller.text, blockedIds);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Set<String>>(
      converter: (store) => store.state.profile.blockedFriendIds,
      onDidChange: (previous, blockedIds) {
        if (_controller.text.trim().length >= 3) {
          _runSearch(_controller.text, blockedIds);
        }
      },
      builder: (context, blockedIds) {
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
                          onChanged: (value) => _runSearch(value, blockedIds),
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
      },
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
