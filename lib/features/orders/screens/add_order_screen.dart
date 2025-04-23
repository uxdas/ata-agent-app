// lib/features/orders/screens/add_order_screen.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:agent_pro/core/models/order_model.dart';
import 'package:agent_pro/core/services/order_api_service.dart';
import 'package:agent_pro/core/network/api_client.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({Key? key}) : super(key: key);

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clientCtrl = TextEditingController();
  final TextEditingController _distributorCtrl = TextEditingController();
  final ValueNotifier<DateTime> _dateCtrl = ValueNotifier<DateTime>(DateTime.now());

  final List<OrderItemModel> _items = [];
  String? _selectedProduct;
  int _quantity = 1;
  final List<String> _products = ['Шоколад АТА', 'Карамель АТА'];
  final Map<String, double> _prices = {
    'Шоколад АТА': 150.0,
    'Карамель АТА': 100.0
  };

  bool _isLoading = false;

  void _addItem() {
    if (_selectedProduct == null || _quantity <= 0) return;

    setState(() {
      _items.add(OrderItemModel(
        productName: _selectedProduct!,
        price: _prices[_selectedProduct!]!,
        quantity: _quantity,
      ));
      _selectedProduct = null;
      _quantity = 1;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate() || _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля и добавьте товары')),
      );
      return;
    }

    final totalSum = _items.fold(0.0, (sum, item) => sum + item.total);

    final order = OrderModel(
      id: const Uuid().v4(),
      clientName: _clientCtrl.text.trim(),
      distributorName: _distributorCtrl.text.trim(),
      orderType: 'Оптовый',
      orderDate: _dateCtrl.value,
      items: List.from(_items),
      total: totalSum,
    );

    setState(() => _isLoading = true);

    try {
      await OrderApiService(ApiClient()).sendOrder(order);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Заказ успешно создан!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _clientCtrl.dispose();
    _distributorCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый заказ'),
        actions: [
          if (_items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${_items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}₽',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _clientCtrl,
                decoration: const InputDecoration(
                  labelText: 'Клиент',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Укажите клиента' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _distributorCtrl,
                decoration: const InputDecoration(
                  labelText: 'Дистрибьютор',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Укажите дистрибьютора' : null,
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<DateTime>(
                valueListenable: _dateCtrl,
                builder: (_, date, __) {
                  return InkWell(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        _dateCtrl.value = selectedDate;
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Дата заказа',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        '${date.day}.${date.month}.${date.year}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text('Товары:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: _selectedProduct,
                      items: _products.map((product) {
                        return DropdownMenuItem(
                          value: product,
                          child: Text(product),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedProduct = value),
                      decoration: const InputDecoration(
                        labelText: 'Товар',
                        border: OutlineInputBorder(),
                      ),
                      validator: (_) => _items.isEmpty && _selectedProduct == null
                          ? 'Добавьте хотя бы один товар'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Кол-во',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final qty = int.tryParse(value) ?? 1;
                        if (qty > 0) _quantity = qty;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, size: 32),
                    onPressed: _addItem,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(item.productName),
                    subtitle: Text('${item.quantity} × ${item.price.toStringAsFixed(2)}₽'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${item.total.toStringAsFixed(2)}₽'),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Создать заказ', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}