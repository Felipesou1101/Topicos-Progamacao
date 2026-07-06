import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/subscription.dart';
import 'subscription_storage.dart';

class SubscriptionStorageService implements SubscriptionStorage {
  static const String _subscriptionsKey = 'subscriptions';
  static const String _initializedKey = 'subscriptions_initialized';

  @override
  Future<bool> hasStoredSubscriptions() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_initializedKey) ?? false;
  }

  @override
  Future<List<Subscription>> loadSubscriptions() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_subscriptionsKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Subscription.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveSubscriptions(List<Subscription> subscriptions) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode(subscriptions.map((item) => item.toMap()).toList());
    await preferences.setString(_subscriptionsKey, encoded);
    await preferences.setBool(_initializedKey, true);
  }
}
