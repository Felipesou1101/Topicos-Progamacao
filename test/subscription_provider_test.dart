import 'package:assinaturas_ninja/models/subscription.dart';
import 'package:assinaturas_ninja/providers/subscription_provider.dart';
import 'package:assinaturas_ninja/services/subscription_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSubscriptionStorage implements SubscriptionStorage {
  FakeSubscriptionStorage({this.hasSavedData = true, List<Subscription>? stored})
    : stored = stored ?? [];

  bool hasSavedData;
  List<Subscription> stored;

  @override
  Future<bool> hasStoredSubscriptions() async => hasSavedData;

  @override
  Future<List<Subscription>> loadSubscriptions() async => List.of(stored);

  @override
  Future<void> saveSubscriptions(List<Subscription> subscriptions) async {
    hasSavedData = true;
    stored = List.of(subscriptions);
  }
}

Subscription subscription({
  required String id,
  required String name,
  required double price,
  required int dueDay,
  String category = 'Streaming',
  SubscriptionStatus status = SubscriptionStatus.active,
}) {
  return Subscription(
    id: id,
    name: name,
    price: price,
    dueDay: dueDay,
    category: category,
    status: status,
    paymentMethod: 'Cartao de credito',
    notes: '',
    createdAt: DateTime(2026, 5, 1),
    updatedAt: DateTime(2026, 5, 1),
  );
}

void main() {
  group('SubscriptionProvider dashboard calculations', () {
    test('sums only active subscriptions in the monthly total', () async {
      final provider = SubscriptionProvider(
        storage: FakeSubscriptionStorage(
          stored: [
            subscription(id: '1', name: 'Netflix', price: 39.90, dueDay: 15),
            subscription(id: '2', name: 'Spotify', price: 21.90, dueDay: 12),
            subscription(
              id: '3',
              name: 'Game Pass',
              price: 49.99,
              dueDay: 7,
              status: SubscriptionStatus.paused,
            ),
          ],
        ),
      );

      await provider.loadSubscriptions();

      expect(provider.totalMonthly, 61.80);
      expect(provider.activeCount, 2);
    });

    test('finds the most expensive active subscription only', () async {
      final provider = SubscriptionProvider(
        storage: FakeSubscriptionStorage(
          stored: [
            subscription(id: '1', name: 'Netflix', price: 39.90, dueDay: 15),
            subscription(
              id: '2',
              name: 'Game Pass',
              price: 49.99,
              dueDay: 7,
              status: SubscriptionStatus.paused,
            ),
          ],
        ),
      );

      await provider.loadSubscriptions();

      expect(provider.mostExpensive?.name, 'Netflix');
    });

    test('sorts upcoming active charges by next due date', () async {
      final provider = SubscriptionProvider(
        now: () => DateTime(2026, 5, 12),
        storage: FakeSubscriptionStorage(
          stored: [
            subscription(id: '1', name: 'Netflix', price: 39.90, dueDay: 15),
            subscription(id: '2', name: 'Spotify', price: 21.90, dueDay: 12),
            subscription(id: '3', name: 'Google Drive', price: 9.99, dueDay: 20),
          ],
        ),
      );

      await provider.loadSubscriptions();

      expect(provider.upcomingCharges.map((item) => item.name), [
        'Spotify',
        'Netflix',
        'Google Drive',
      ]);
    });
  });

  group('SubscriptionProvider CRUD and filters', () {
    test('adds, updates and deletes subscriptions while saving locally', () async {
      final storage = FakeSubscriptionStorage(stored: []);
      final provider = SubscriptionProvider(storage: storage);

      await provider.loadSubscriptions();
      await provider.addSubscription(
        name: 'Curso',
        price: 29.90,
        dueDay: 10,
        category: 'Educacao',
        status: SubscriptionStatus.active,
        paymentMethod: 'Cartao de credito',
        notes: '',
      );

      expect(provider.subscriptions.single.name, 'Curso');
      expect(storage.stored.single.name, 'Curso');

      final created = provider.subscriptions.single;
      await provider.updateSubscription(created.copyWith(name: 'Curso Pro'));

      expect(provider.subscriptions.single.name, 'Curso Pro');
      expect(storage.stored.single.name, 'Curso Pro');

      await provider.deleteSubscription(created.id);

      expect(provider.subscriptions, isEmpty);
      expect(storage.stored, isEmpty);
    });

    test('filters subscriptions by status and due soon', () async {
      final provider = SubscriptionProvider(
        now: () => DateTime(2026, 5, 12),
        storage: FakeSubscriptionStorage(
          stored: [
            subscription(id: '1', name: 'Netflix', price: 39.90, dueDay: 15),
            subscription(
              id: '2',
              name: 'Game Pass',
              price: 49.99,
              dueDay: 7,
              status: SubscriptionStatus.paused,
            ),
            subscription(id: '3', name: 'Drive', price: 9.99, dueDay: 25),
          ],
        ),
      );

      await provider.loadSubscriptions();

      provider.setFilter(SubscriptionFilter.active);
      expect(provider.filteredSubscriptions.map((item) => item.name), ['Netflix', 'Drive']);

      provider.setFilter(SubscriptionFilter.paused);
      expect(provider.filteredSubscriptions.map((item) => item.name), ['Game Pass']);

      provider.setFilter(SubscriptionFilter.dueSoon);
      expect(provider.filteredSubscriptions.map((item) => item.name), ['Netflix']);
    });
  });

  test('starts empty when storage has no saved data yet', () async {
    final storage = FakeSubscriptionStorage(hasSavedData: false);
    final provider = SubscriptionProvider(storage: storage);

    await provider.loadSubscriptions();

    expect(provider.subscriptions, isEmpty);
    expect(storage.hasSavedData, isFalse);
  });

  test('loads sample data only when explicitly requested', () async {
    final storage = FakeSubscriptionStorage(hasSavedData: false);
    final provider = SubscriptionProvider(storage: storage);

    await provider.replaceWithSampleData();

    expect(provider.subscriptions.map((item) => item.name), containsAll(['Netflix', 'Spotify']));
    expect(storage.hasSavedData, isTrue);
  });

  test('searches and sorts the filtered list', () async {
    final provider = SubscriptionProvider(
      now: () => DateTime(2026, 5, 12),
      storage: FakeSubscriptionStorage(
        stored: [
          subscription(id: '1', name: 'Netflix', price: 39.90, dueDay: 15),
          subscription(id: '2', name: 'Spotify', price: 21.90, dueDay: 12, category: 'Musica'),
          subscription(id: '3', name: 'Google Drive', price: 9.99, dueDay: 20),
        ],
      ),
    );

    await provider.loadSubscriptions();

    provider.setSearchQuery('goo');
    expect(provider.filteredSubscriptions.map((item) => item.name), ['Google Drive']);

    provider.setSearchQuery('');
    provider.setSortOrder(SubscriptionSort.highestPrice);
    expect(provider.filteredSubscriptions.map((item) => item.name), [
      'Netflix',
      'Spotify',
      'Google Drive',
    ]);
  });

  test('calculates category totals and financial insights from active subscriptions', () async {
    final provider = SubscriptionProvider(
      storage: FakeSubscriptionStorage(
        stored: [
          subscription(id: '1', name: 'Netflix', price: 39.90, dueDay: 15),
          subscription(id: '2', name: 'Spotify', price: 21.90, dueDay: 12, category: 'Musica'),
          subscription(id: '3', name: 'Prime Video', price: 14.90, dueDay: 20),
          subscription(
            id: '4',
            name: 'Game Pass',
            price: 49.99,
            dueDay: 7,
            status: SubscriptionStatus.paused,
          ),
        ],
      ),
    );

    await provider.loadSubscriptions();

    expect(provider.categoryTotals, {'Streaming': 54.80, 'Musica': 21.90});
    expect(provider.annualActiveTotal, 920.40);
    expect(provider.topCategoryName, 'Streaming');
    expect(provider.potentialMonthlySavings, 39.90);
    expect(provider.inactiveCount, 1);
  });
}
