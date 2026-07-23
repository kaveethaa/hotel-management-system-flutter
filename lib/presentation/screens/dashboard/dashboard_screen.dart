import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardProvider);
    final user = ref.watch(authProvider).user;
    final isAdmin = user?.role == 'Admin';

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${user?.name ?? "User"}'),
        actions: [
          IconButton(onPressed: () {
            ref.read(authProvider.notifier).logout();
            context.go('/login');
          }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardProvider),
        child: stats.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (s) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.count(crossAxisCount: 2, shrinkWrap: true, mainAxisSpacing: 12,
                  crossAxisSpacing: 12, childAspectRatio: 1.6,
                  physics: const NeverScrollableScrollPhysics(), children: [
                    _StatCard(icon: Icons.meeting_room, label: 'Total Rooms', value: '${s.total}', color: Colors.blue),
                    _StatCard(icon: Icons.check_circle, label: 'Available', value: '${s.available}', color: Colors.green),
                    _StatCard(icon: Icons.hotel, label: 'Occupied', value: '${s.occupied}', color: Colors.orange),
                    _StatCard(icon: Icons.percent, label: 'Occupancy', value: '${s.occupancy.toStringAsFixed(0)}%', color: Colors.purple),
                    _StatCard(icon: Icons.login, label: 'Check-ins Today', value: '${s.checkInsToday}', color: Colors.teal),
                    _StatCard(icon: Icons.logout, label: 'Check-outs Today', value: '${s.checkOutsToday}', color: Colors.pink),
                  ]),
              const SizedBox(height: 16),
              Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Total Revenue', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(NumberFormat.currency(symbol: '\$').format(s.revenue),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 16),
                SizedBox(height: 160, child: PieChart(PieChartData(sections: [
                  PieChartSectionData(value: s.available.toDouble(), color: Colors.green, title: 'Available'),
                  PieChartSectionData(value: s.occupied.toDouble(), color: Colors.orange, title: 'Occupied'),
                  PieChartSectionData(value: (s.total - s.available - s.occupied).toDouble().clamp(0, 999),
                      color: Colors.grey, title: 'Other'),
                ]))),
              ]))),
              const SizedBox(height: 16),
              const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _NavTile(icon: Icons.meeting_room, label: 'Rooms', onTap: () => context.push('/rooms')),
                _NavTile(icon: Icons.people, label: 'Guests', onTap: () => context.push('/guests')),
                _NavTile(icon: Icons.event, label: 'Reservations', onTap: () => context.push('/reservations')),
                _NavTile(icon: Icons.receipt_long, label: 'Billing', onTap: () => context.push('/billing')),
                if (isAdmin) _NavTile(icon: Icons.badge, label: 'Staff', onTap: () => context.push('/staff')),
              ]),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label, value; final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext c) => Card(child: Padding(padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(icon, color: color, size: 28),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ])));
}

class _NavTile extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _NavTile({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext c) => SizedBox(width: 100, height: 100,
      child: Card(child: InkWell(onTap: onTap, child: Column(
          mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 32, color: const Color(0xFF1E88E5)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]))));
}