import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/message.dart';
import 'api_client.dart';

class BuddyService extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  List<Buddy> buddies = [];
  List<BuddyRequestModel> pendingRequests = [];
  bool isLoading = false;

  Future<void> loadBuddies() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _api.get('/buddies/') as List;
      buddies = data.map((e) => Buddy.fromJson(e)).toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPendingRequests() async {
    final data = await _api.get('/buddies/pending') as List;
    pendingRequests = data.map((e) => BuddyRequestModel.fromJson(e)).toList();
    notifyListeners();
  }

  Future<List<AppUser>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final data = await _api.get('/buddies/search', query: {'q': query}) as List;
    return data.map((e) => AppUser.fromJson(e)).toList();
  }

  Future<void> sendRequest(String userId) async {
    await _api.post('/buddies/request/$userId');
  }

  Future<void> respond(String requestId, bool accept) async {
    await _api.post('/buddies/respond/$requestId?accept=$accept');
    pendingRequests.removeWhere((r) => r.id == requestId);
    notifyListeners();
    if (accept) await loadBuddies();
  }

  Future<void> removeBuddy(String buddyUserId) async {
    await _api.delete('/buddies/$buddyUserId');
    buddies.removeWhere((b) => b.user.id == buddyUserId);
    notifyListeners();
  }
}
