import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _verificationId;
  String? _smsCode;

  @override
  void initState() {
    super.initState();
    _checkExistingToken();
  }

  Future<void> _checkExistingToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && mounted) {
      _navigateToHome(token);
    }
  }

  Future<void> _verifyPhone() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final phone = '+7${_phoneController.text.trim()}';
      debugPrint('Отправка SMS на номер: $phone');

      // Имитация задержки отправки SMS
      await Future.delayed(const Duration(seconds: 1));

      // Генерация mock verificationId (в реальном приложении получите из Firebase)
      final mockVerificationId = 'mock_verification_${DateTime.now().millisecondsSinceEpoch}';

      setState(() {
        _verificationId = mockVerificationId;
        _isLoading = false;
      });

      _showSmsDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Ошибка отправки SMS: $e');
    }
  }

  void _showSmsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение номера'),
        content: TextField(
          onChanged: (value) => _smsCode = value,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Введите код из SMS',
            hintText: '000000',
          ),
          maxLength: 6,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: _confirmSmsCode,
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSmsCode() async {
    if (_smsCode == null || _smsCode!.length != 6) {
      _showError('Введите 6-значный код');
      return;
    }

    setState(() => _isLoading = true);
    Navigator.pop(context);

    try {
      // Генерация уникального токена (без const)
      final mockToken = 'user_token_${DateTime.now().millisecondsSinceEpoch}';

      // Сохраняем токен
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', mockToken);

      // Переход на главный экран с токеном
      _navigateToHome(mockToken);

    } catch (e) {
      _showError('Ошибка входа: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToHome(String token) {
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {'token': token},
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Вход по номеру телефона',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Номер телефона',
                  prefixText: '+7 ',
                  border: OutlineInputBorder(),
                  hintText: '9001234567',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите номер';
                  if (value.length != 10) return 'Номер должен содержать 10 цифр';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyPhone,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Получить код по SMS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}