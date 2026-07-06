enum SubscriptionStatus {
  active,
  paused,
  canceled;

  String get label {
    switch (this) {
      case SubscriptionStatus.active:
        return 'Ativa';
      case SubscriptionStatus.paused:
        return 'Pausada';
      case SubscriptionStatus.canceled:
        return 'Cancelada';
    }
  }
}

class Subscription {
  const Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.dueDay,
    required this.category,
    required this.status,
    required this.paymentMethod,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final double price;
  final int dueDay;
  final String category;
  final SubscriptionStatus status;
  final String paymentMethod;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription copyWith({
    String? id,
    String? name,
    double? price,
    int? dueDay,
    String? category,
    SubscriptionStatus? status,
    String? paymentMethod,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      dueDay: dueDay ?? this.dueDay,
      category: category ?? this.category,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  DateTime nextChargeDate([DateTime? from]) {
    final base = from ?? DateTime.now();
    final today = DateTime(base.year, base.month, base.day);
    final thisMonth = _safeDate(today.year, today.month, dueDay);

    if (!thisMonth.isBefore(today)) {
      return thisMonth;
    }

    return _safeDate(today.year, today.month + 1, dueDay);
  }

  int daysUntilDue([DateTime? from]) {
    final base = from ?? DateTime.now();
    final today = DateTime(base.year, base.month, base.day);
    return nextChargeDate(today).difference(today).inDays;
  }

  bool isDueToday([DateTime? from]) => daysUntilDue(from) == 0;

  bool isDueSoon([DateTime? from]) {
    final days = daysUntilDue(from);
    return days >= 0 && days <= 5;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'dueDay': dueDay,
      'category': category,
      'status': status.name,
      'paymentMethod': paymentMethod,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      dueDay: map['dueDay'] as int,
      category: map['category'] as String,
      status: SubscriptionStatus.values.byName(map['status'] as String),
      paymentMethod: map['paymentMethod'] as String,
      notes: map['notes'] as String? ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  static DateTime _safeDate(int year, int month, int day) {
    final normalizedMonth = DateTime(year, month);
    final lastDay = DateTime(normalizedMonth.year, normalizedMonth.month + 1, 0).day;
    return DateTime(normalizedMonth.year, normalizedMonth.month, day.clamp(1, lastDay));
  }
}
