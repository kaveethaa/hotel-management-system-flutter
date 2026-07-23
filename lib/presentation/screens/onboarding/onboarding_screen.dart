import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pc = PageController();
  int _index = 0;

  final _pages = const [
    _OB(icon: Icons.meeting_room, title: 'Room Management',
        subtitle: 'Add, edit and track every room in real-time'),
    _OB(icon: Icons.event_available, title: 'Smart Reservations',
        subtitle: 'Prevent double bookings with auto-checks'),
    _OB(icon: Icons.receipt_long, title: 'Instant Billing',
        subtitle: 'Generate PDF invoices and QR codes in seconds'),
  ];

  Future<void> _done() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('onboarding_seen', true);
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: PageView.builder(
              controller: _pc,
              onPageChanged: (i) => setState(() => _index = i),
              itemCount: _pages.length,
              itemBuilder: (_, i) => _pages[i],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_pages.length,
                  (i) => AnimatedContainer(duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _index == i ? 24 : 8, height: 8,
                  decoration: BoxDecoration(color: _index == i ? const Color(0xFF1E88E5) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4))))),
          Padding(padding: const EdgeInsets.all(24),
              child: Row(children: [
                TextButton(onPressed: _done, child: const Text('Skip')),
                const Spacer(),
                FilledButton(onPressed: () {
                  if (_index == _pages.length - 1) {
                    _done();
                  } else {
                    _pc.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                  }
                }, child: Text(_index == _pages.length - 1 ? 'Get Started' : 'Next')),
              ])),
        ]),
      ),
    );
  }
}

class _OB extends StatelessWidget {
  final IconData icon; final String title, subtitle;
  const _OB({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 120, color: const Color(0xFF1E88E5)),
        const SizedBox(height: 32),
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 16)),
      ]));
}