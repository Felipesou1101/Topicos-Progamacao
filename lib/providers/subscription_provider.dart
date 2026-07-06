import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/subscription.dart';
import '../services/subscription_storage.dart';
import '../services/subscription_storage_service.dart';

enum SubscriptionFilter {
  all,
  active,
  paused,
  canceled,
  dueSoon;

  String get label {
    switch (this) {
      case SubscriptionFilter.all:
        return 'Todas';
      case SubscriptionFilter.active:
        return 'Ativas';
      case SubscriptionFilter.paused:
        return 'Pausadas';
      case SubscriptionFilter.canceled:
        return 'Canceladas';
      case SubscriptionFilter.dueSoon:
        return 'Vencendo';
    }
  }
}

enum SubscriptionSort {
  nextDue,
  highestPrice,
  lowestPrice,
  name;

  String get label {
    switch (this) {
      case SubscriptionSort.nextDue:
        return 'Vencimento';
      case SubscriptionSort.highestPrice:
        return 'Maior valor';
      case SubscriptionSort.lowestPrice:
        return 'Menor valor';
      case SubscriptionSort.name:
        return 'Nome';
    }
  }
}

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionProvider({
    SubscriptionStorage? storage,
    DateTime Function()? now,
    Uuid? uuid,
  }) : _storage = storage ?? SubscriptionStorageService(),
       _now = now ?? DateTime.now,
       _uuid = uuid ?? const Uuid();

  final SubscriptionStorage _storage;
  final DateTime Function() _now;
  final Uuid _uuid;

  final List<Subscription> _subscriptions = [];
  SubscriptionFilter _filter = SubscriptionFilter.all;
  SubscriptionSort _sortOrder = SubscriptionSort.nextDue;
  String _searchQuery = '';
  bool _isLoading = false;

  List<Subscription> get subscriptions => List.unmodifiable(_subscriptions);

  SubscriptionFilter get filter => _filter;

  SubscriptionSort get sortOrder => _sortOrder;

  String get searchQuery => _searchQuery;

  bool get isLoading => _isLoading;

  List<Subscription> get activeSubscriptions =>
      _subscriptions.where((item) => item.status == SubscriptionStatus.active).toList();

  double get totalMonthly {
    final total = activeSubscriptions.fold<double>(0, (sum, item) => sum + item.price);
    return double.parse(total.toStringAsFixed(2));
  }

  int get activeCount => activeSubscriptions.length;

  int get inactiveCount =>
      _subscriptions.where((item) => item.status != SubscriptionStatus.active).length;

  double get annualActiveTotal => double.parse((totalMonthly * 12).toStringAsFixed(2));

  double get potentialMonthlySavings => mostExpensive?.price ?? 0;

  Map<String, double> get categoryTotals {
    final totals = <String, double>{};
    for (final subscription in activeSubscriptions) {
      final total = (totals[subscription.category] ?? 0) + subscription.price;
      totals[subscription.category] = double.parse(total.toStringAsFixed(2));
    }
    return totals;
  }

  String? get topCategoryName {
    if (categoryTotals.isEmpty) {
      return null;
    }

    final entries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.first.key;
  }

  List<Subscription> get dueThisWeek {
    return upcomingCharges.where((item) => item.isDueSoon(_now())).toList();
  }

  Subscription? get mostExpensive {
    if (activeSubscriptions.isEmpty) {
      return null;
    }

    final sorted = [...activeSubscriptions]..sort((a, b) => b.price.compareTo(a.price));
    return sorted.first;
  }

  List<Subscription> get upcomingCharges {
    final current = _now();
    final items = [...activeSubscriptions];
    items.sort((a, b) => a.nextChargeDate(current).compareTo(b.nextChargeDate(current)));
    return items;
  }

  List<Subscription> get filteredSubscriptions {
    final filtered = switch (_filter) {
      SubscriptionFilter.all => _subscriptions,
      SubscriptionFilter.active => _subscriptions.where(
        (item) => item.status == SubscriptionStatus.active,
      ),
      SubscriptionFilter.paused => _subscriptions.where(
        (item) => item.status == SubscriptionStatus.paused,
      ),
      SubscriptionFilter.canceled => _subscriptions.where(
        (item) => item.status == SubscriptionStatus.canceled,
      ),
      SubscriptionFilter.dueSoon => _subscriptions.where((item) => item.isDueSoon(_now())),
    };

    final query = _searchQuery.trim().toLowerCase();
    final searched = query.isEmpty
        ? filtered.toList()
        : filtered
              .where(
                (item) =>
                    item.name.toLowerCase().contains(query) ||
                    item.category.toLowerCase().contains(query) ||
                    item.paymentMethod.toLowerCase().contains(query),
              )
              .toList();

    return _sortSubscriptions(searched);
  }

  DateTime nextChargeDate(Subscription subscription) => subscription.nextChargeDate(_now());

  int daysUntilDue(Subscription subscription) => subscription.daysUntilDue(_now());

  bool isDueToday(Subscription subscription) => subscription.isDueToday(_now());

  bool isDueSoon(Subscription subscription) => subscription.isDueSoon(_now());

  Future<void> loadSubscriptions() async {
    _isLoading = true;
    notifyListeners();

    final stored = await _storage.loadSubscriptions();
    _subscriptions
      ..clear()
      ..addAll(stored);

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(SubscriptionFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSortOrder(SubscriptionSort sortOrder) {
    _sortOrder = sortOrder;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addSubscription({
    required String name,
    required double price,
    required int dueDay,
    required String category,
    required SubscriptionStatus status,
    required String paymentMethod,
    required String notes,
  }) async {
    final now = _now();
    final subscription = Subscription(
      id: _uuid.v4(),
      name: name.trim(),
      price: price,
      dueDay: dueDay,
      category: category.trim(),
      status: status,
      paymentMethod: paymentMethod.trim(),
      notes: notes.trim(),
      createdAt: now,
      updatedAt: now,
    );

    _subscriptions.add(subscription);
    await _saveAndNotify();
  }

  Future<void> updateSubscription(Subscription subscription) async {
    final index = _subscriptions.indexWhere((item) => item.id == subscription.id);
    if (index == -1) {
      return;
    }

    _subscriptions[index] = subscription.copyWith(updatedAt: _now());
    await _saveAndNotify();
  }

  Future<void> deleteSubscription(String id) async {
    _subscriptions.removeWhere((item) => item.id == id);
    await _saveAndNotify();
  }

  Future<void> changeStatus(String id, SubscriptionStatus status) async {
    final index = _subscriptions.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }

    _subscriptions[index] = _subscriptions[index].copyWith(status: status, updatedAt: _now());
    await _saveAndNotify();
  }

  Future<void> initializeEmpty() async {
    _subscriptions.clear();
    await _saveAndNotify();
  }

  Future<void> replaceWithSampleData() async {
    _subscriptions
      ..clear()
      ..addAll(_sampleSubscriptions());
    await _saveAndNotify();
  }

  Future<void> clearAll() async {
    _subscriptions.clear();
    _filter = SubscriptionFilter.all;
    _sortOrder = SubscriptionSort.nextDue;
    _searchQuery = '';
    await _saveAndNotify();
  }

  Future<void> _saveAndNotify() async {
    await _storage.saveSubscriptions(_subscriptions);
    notifyListeners();
  }

  List<Subscription> _sortSubscriptions(List<Subscription> items) {
    final current = _now();
    final sorted = [...items];
    switch (_sortOrder) {
      case SubscriptionSort.nextDue:
        sorted.sort((a, b) => a.nextChargeDate(current).compareTo(b.nextChargeDate(current)));
      case SubscriptionSort.highestPrice:
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case SubscriptionSort.lowestPrice:
        sorted.sort((a, b) => a.price.compareTo(b.price));
      case SubscriptionSort.name:
        sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    return sorted;
  }

  List<Subscription> _sampleSubscriptions() {
    final createdAt = _now();
    return [
      Subscription(
        id: 'sample-netflix',
        name: 'Netflix',
        price: 39.90,
        dueDay: 15,
        category: 'Streaming',
        status: SubscriptionStatus.active,
        paymentMethod: 'Cartão de crédito',
        notes: '',
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Subscription(
        id: 'sample-spotify',
        name: 'Spotify',
        price: 21.90,
        dueDay: 12,
        category: 'Música',
        status: SubscriptionStatus.active,
        paymentMethod: 'Cartão de crédito',
        notes: '',
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Subscription(
        id: 'sample-game-pass',
        name: 'Game Pass',
        price: 49.99,
        dueDay: 7,
        category: 'Jogos',
        status: SubscriptionStatus.paused,
        paymentMethod: 'Cartão de crédito',
        notes: '',
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Subscription(
        id: 'sample-google-drive',
        name: 'Google Drive',
        price: 9.99,
        dueDay: 20,
        category: 'Nuvem',
        status: SubscriptionStatus.active,
        paymentMethod: 'Cartão de crédito',
        notes: '',
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Subscription(
        id: 'sample-academia',
        name: 'Academia',
        price: 89.90,
        dueDay: 5,
        category: 'Saúde',
        status: SubscriptionStatus.canceled,
        paymentMethod: 'Pix',
        notes: '',
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    ];
  }
}
