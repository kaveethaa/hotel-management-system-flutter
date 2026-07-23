import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _u = TextEditingController(text: 'admin');
  final _p = TextEditingController(text: 'admin123');
  bool _loading = false;
  String? _err;

  Future<void> _login() async {
    setState(() { _loading = true; _err = null; });
    final ok = await ref.read(authProvider.notifier).login(_u.text.trim(), _p.text.trim());
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      context.go('/dashboard');
    } else {
      setState(() => _err = 'Invalid username or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                const Icon(Icons.hotel, size: 72, color: Color(0xFF1E88E5)),
                const SizedBox(height: 16),
                const Text('Welcome Back', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Login to manage your hotel', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                TextField(controller: _u, decoration: const InputDecoration(
                    labelText: 'Username', prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextField(controller: _p, obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password',
                        prefixIcon: Icon(Icons.lock), border: OutlineInputBorder())),
                if (_err != null) Padding(padding: const EdgeInsets.only(top: 12),
                    child: Text(_err!, style: const TextStyle(color: Colors.red))),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, height: 50,
                    child: FilledButton(onPressed: _loading ? null : _login,
                        child: _loading ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Login', style: TextStyle(fontSize: 16)))),
                const SizedBox(height: 16),
                Container(padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                    child: const Column(children: [
                      Text('Demo credentials:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('admin / admin123  (Admin)'),
                      Text('recep / recep123  (Receptionist)'),
                    ])),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}