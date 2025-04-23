// lib/features/points/screens/create_point_screen.dart

import 'package:agent_pro/core/constants/server.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/point_service.dart';

class CreatePointScreen extends StatefulWidget {
  const CreatePointScreen({super.key});

  @override
  State<CreatePointScreen> createState() => _CreatePointScreenState();
}

class _CreatePointScreenState extends State<CreatePointScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'title': TextEditingController(),
    'contact_name': TextEditingController(),
    'contact_phone': TextEditingController(),
    'contact_phone_secondary': TextEditingController(),
    'address': TextEditingController(),
    'inn': TextEditingController(),
  };

  int? typeId;
  bool _loading = false;

  @override
  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print('Токен: $token');  // Отладка токена

      if (token == null) throw Exception('Токен не найден');

      // Собираем данные из полей формы
      final data = {
        "title": _controllers['title']!.text.trim(),
        "type_id": typeId ?? 1,
        "contact_name": _controllers['contact_name']!.text.trim(),
        "contact_phone": _controllers['contact_phone']!.text.trim(),
        "contact_phone_secondary": _controllers['contact_phone_secondary']!.text.trim(),
        "region_id": 3,
        "city_id": 2,
        "address": _controllers['address']!.text.trim(),
        "coordinates": "2342342342",
        "inn": _controllers['inn']!.text.trim(),
      };

      print('Отправляемые данные: $data');

      final dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: {'Authorization': 'Token $token'},
      ));

      final response = await dio.post(
        '/agents/create-retail-point/',
        data: data,
        options: Options(contentType: Headers.jsonContentType),
      );

      print('Ответ сервера: ${response.data}');

      if ([200, 201].contains(response.statusCode)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Точка успешно добавлена!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Ошибка: ${response.statusCode}');
      }
    } on DioException catch (e) {  // Ловим DioError отдельно
      print('DioError: ${e.response?.data}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.response?.data ?? e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить точку')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('title', 'Название точки'),
              _buildTextField('contact_name', 'Имя контактного лица'),
              _buildTextField('contact_phone', 'Телефон'),
              _buildTextField('contact_phone_secondary', 'Доп. телефон (опционально)'),
              _buildTextField('address', 'Адрес'),
              _buildTextField('inn', 'ИНН'),
              const SizedBox(height: 12),
              _buildDropdown('Тип', [1, 2, 3], (value) => setState(() => typeId = value)),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Создать точку'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => (value == null || value.isEmpty) ? 'Обязательное поле' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<int> values, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        value: null,
        items: values
            .map((v) => DropdownMenuItem(value: v, child: Text('$label #$v')))
            .toList(),
        onChanged: (v) => onChanged(v!),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v == null ? 'Выберите значение' : null,
      ),
    );
  }
}
