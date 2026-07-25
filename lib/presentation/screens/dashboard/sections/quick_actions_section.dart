import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActionsSection extends StatelessWidget {
  final bool isAdmin;

  const QuickActionsSection({
    super.key,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.meeting_room_rounded,
        label: 'Rooms',
        color1: const Color(0xFF2563EB),
        color2: const Color(0xFF3B82F6),
        route: '/rooms',
      ),
      _ActionItem(
        icon: Icons.people_alt_rounded,
        label: 'Guests',
        color1: const Color(0xFF059669),
        color2: const Color(0xFF10B981),
        route: '/guests',
      ),
      _ActionItem(
        icon: Icons.event_available_rounded,
        label: 'Reservations',
        color1: const Color(0xFFEA580C),
        color2: const Color(0xFFF97316),
        route: '/reservations',
      ),
      _ActionItem(
        icon: Icons.receipt_long_rounded,
        label: 'Billing',
        color1: const Color(0xFF7C3AED),
        color2: const Color(0xFF8B5CF6),
        route: '/billing',
      ),
      if (isAdmin)
        _ActionItem(
          icon: Icons.badge_rounded,
          label: 'Staff',
          color1: const Color(0xFF0F766E),
          color2: const Color(0xFF14B8A6),
          route: '/staff',
        ), _ActionItem(
        icon: Icons.analytics,
        label: 'Analytics',
        color1: const Color(0xFF7C3AED),
        color2: const Color(0xFF8B5CF6),
        route: '/analytics',
      ),
      //_NavTile(icon: Icons.analytics, label: 'Analytics', onTap: () => context.push('/analytics')),

    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.grid_view_rounded, color: Color(0xFF1E88E5)),
            SizedBox(width: 8),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final item = actions[index];

            return InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.push(item.route),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [item.color1, item.color2],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: item.color1.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            item.icon,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Bottom text
                    Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Tap to open',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color1;
  final Color color2;
  final String route;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color1,
    required this.color2,
    required this.route,
  });
}