import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/subscription.dart';
import '../providers/subscription_provider.dart';

class SubscriptionFormScreen extends StatefulWidget {
  const SubscriptionFormScreen({super.key, this.subscription});

  final Subscription? subscription;

  @override
  State<SubscriptionFormScreen> createState() => _SubscriptionFormScreenState();
}

class _SubscriptionFormScreenState extends State<SubscriptionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _dueDayController;
  late final TextEditingController _notesController;
  late String _category;
  late String _paymentMethod;
  late SubscriptionStatus _status;

  static const List<String> _categories = [
    'Streaming',
    'Música',
    'Jogos',
    'Nuvem',
    'Saúde',
    'Educação',
    'Outros',
  ];

  static const List<String> _paymentMethods = [
    'Cartão de crédito',
    'Pix',
    'Boleto',
    'Débito automático',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();
    final subscription = widget.subscription;
    _nameController = TextEditingController(text: subscription?.name ?? '');
    _priceController = TextEditingController(
      text: subscription == null ? '' : subscription.price.toStringAsFixed(2).replaceAll('.', ','),
    );
    _dueDayController = TextEditingController(text: subscription?.dueDay.toString() ?? '');
    _notesController = TextEditingController(text: subscription?.notes ?? '');
    _category = subscription?.category ?? _categories.first;
    _paymentMethod = subscription?.paymentMethod ?? _paymentMethods.first;
    _status = subscription?.status ?? SubscriptionStatus.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _dueDayController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.subscription != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? 'Editar assinatura' : 'Nova assinatura',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              const Text(
                'Informações principais',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.edit_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome da assinatura.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor mensal',
                  prefixIcon: Icon(Icons.payments_rounded),
                ),
                validator: (value) {
                  final parsed = _parsePrice(value);
                  if (parsed == null || parsed <= 0) {
                    return 'Informe um valor maior que zero.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _dueDayController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Dia de vencimento',
                  prefixIcon: Icon(Icons.event_rounded),
                ),
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed < 1 || parsed > 31) {
                    return 'Informe um dia entre 1 e 31.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              const Text(
                'Categoria',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories
                    .map(
                      (category) => ChoiceChip(
                        selected: _category == category,
                        label: Text(category),
                        onSelected: (_) => setState(() => _category = category),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Forma de pagamento',
                  prefixIcon: Icon(Icons.credit_card_rounded),
                ),
                items: _paymentMethods
                    .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                    .toList(),
                onChanged: (value) => setState(() => _paymentMethod = value ?? _paymentMethod),
              ),
              const SizedBox(height: 20),
              const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              SegmentedButton<SubscriptionStatus>(
                segments: SubscriptionStatus.values
                    .map(
                      (status) => ButtonSegment<SubscriptionStatus>(
                        value: status,
                        label: Text(status.label),
                      ),
                    )
                    .toList(),
                selected: {_status},
                onSelectionChanged: (value) => setState(() => _status = value.first),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _notesController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _save,
                icon: Icon(editing ? Icons.save_rounded : Icons.add_rounded),
                label: Text(editing ? 'Salvar alterações' : 'Cadastrar assinatura'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? _parsePrice(String? value) {
    if (value == null) {
      return null;
    }
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '.').trim());
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<SubscriptionProvider>();
    final price = _parsePrice(_priceController.text)!;
    final dueDay = int.parse(_dueDayController.text);
    final existing = widget.subscription;

    if (existing == null) {
      await provider.addSubscription(
        name: _nameController.text,
        price: price,
        dueDay: dueDay,
        category: _category,
        status: _status,
        paymentMethod: _paymentMethod,
        notes: _notesController.text,
      );
    } else {
      await provider.updateSubscription(
        existing.copyWith(
          name: _nameController.text.trim(),
          price: price,
          dueDay: dueDay,
          category: _category,
          status: _status,
          paymentMethod: _paymentMethod,
          notes: _notesController.text.trim(),
        ),
      );
    }

    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }
}
