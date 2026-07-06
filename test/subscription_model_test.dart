import 'package:assinaturas_ninja/models/subscription.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Subscription due date logic', () {
    test('calculates the next charge in the current month when due day is ahead', () {
      final subscription = Subscription(
        id: '1',
        name: 'Spotify',
        price: 21.90,
        dueDay: 15,
        category: 'Musica',
        status: SubscriptionStatus.active,
        paymentMethod: 'Cartao de credito',
        notes: '',
        createdAt: DateTime(2026, 5, 1),
        updatedAt: DateTime(2026, 5, 1),
      );

      expect(subscription.nextChargeDate(DateTime(2026, 5, 12)), DateTime(2026, 5, 15));
    });

    test('calculates the next charge in the next month when due day has passed', () {
      final subscription = Subscription(
        id: '1',
        name: 'Netflix',
        price: 39.90,
        dueDay: 10,
        category: 'Streaming',
        status: SubscriptionStatus.active,
        paymentMethod: 'Cartao de credito',
        notes: '',
        createdAt: DateTime(2026, 5, 1),
        updatedAt: DateTime(2026, 5, 1),
      );

      expect(subscription.nextChargeDate(DateTime(2026, 5, 12)), DateTime(2026, 6, 10));
    });

    test('marks due soon only when the next charge is within five days', () {
      final dueSoon = Subscription(
        id: '1',
        name: 'Google Drive',
        price: 9.99,
        dueDay: 17,
        category: 'Nuvem',
        status: SubscriptionStatus.active,
        paymentMethod: 'Cartao de credito',
        notes: '',
        createdAt: DateTime(2026, 5, 1),
        updatedAt: DateTime(2026, 5, 1),
      );

      final notDueSoon = dueSoon.copyWith(dueDay: 23);

      expect(dueSoon.isDueSoon(DateTime(2026, 5, 12)), isTrue);
      expect(notDueSoon.isDueSoon(DateTime(2026, 5, 12)), isFalse);
    });
  });

  test('serializes and restores all subscription fields', () {
    final createdAt = DateTime(2026, 5, 1, 10, 30);
    final updatedAt = DateTime(2026, 5, 2, 8, 15);
    final subscription = Subscription(
      id: 'abc',
      name: 'Academia',
      price: 89.90,
      dueDay: 5,
      category: 'Saude',
      status: SubscriptionStatus.canceled,
      paymentMethod: 'Pix',
      notes: 'Plano mensal',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    final restored = Subscription.fromMap(subscription.toMap());

    expect(restored.id, 'abc');
    expect(restored.name, 'Academia');
    expect(restored.price, 89.90);
    expect(restored.dueDay, 5);
    expect(restored.category, 'Saude');
    expect(restored.status, SubscriptionStatus.canceled);
    expect(restored.paymentMethod, 'Pix');
    expect(restored.notes, 'Plano mensal');
    expect(restored.createdAt, createdAt);
    expect(restored.updatedAt, updatedAt);
  });
}
