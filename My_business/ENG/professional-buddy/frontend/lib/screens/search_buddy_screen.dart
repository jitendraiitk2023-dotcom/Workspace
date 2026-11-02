import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/buddy_service.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';

class SearchBuddyScreen extends StatefulWidget {
  const SearchBuddyScreen({super.key});

  @override
  State<SearchBuddyScreen> createState() => _SearchBuddyScreenState();
}

class _SearchBuddyScreenState extends State<SearchBuddyScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<AppUser> _results = [];
  final Set<String> _requested = {};
  bool _searching = false;

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (query.trim().isEmpty) {
        setState(() => _results = []);
        return;
      }
      setState(() => _searching = true);
      final svc = context.read<BuddyService>();
      final results = await svc.search(query.trim());
      if (mounted) setState(() { _results = results; _searching = false; });
    });
  }

  Future<void> _sendRequest(AppUser user) async {
    final svc = context.read<BuddyService>();
    try {
      await svc.sendRequest(user.id);
      setState(() => _requested.add(user.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          decoration: const InputDecoration(
            hintText: 'Buddy search...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _searching
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? Center(
                  child: Text(
                    _controller.text.isEmpty ? 'Search by name to find buddies' : 'No users found',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, i) {
                    final user = _results[i];
                    final alreadyRequested = _requested.contains(user.id);
                    return ListTile(
                      leading: UserAvatar(name: user.name, colorHex: user.avatarColor, imageUrl: user.avatarUrl),
                      title: Text(user.name),
                      subtitle: user.bio != null ? Text(user.bio!, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
                      trailing: alreadyRequested
                          ? const Text('Requested', style: TextStyle(color: AppColors.textSecondary))
                          : TextButton(
                              onPressed: () => _sendRequest(user),
                              child: const Text('Add'),
                            ),
                    );
                  },
                ),
    );
  }
}
