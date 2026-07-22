import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


final routerProvider = Provider<GoRouter>((ref) {
return GoRouter(
initialLocation: '/splash',
routes: [
GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
GoRoute(path: '/rooms', builder: (_, __) => const RoomsScreen()),
GoRoute(path: '/rooms/form', builder: (c, s) => RoomFormScreen(roomId: s.uri.queryParameters['id'])),
GoRoute(path: '/guests', builder: (_, __) => const GuestsScreen()),
GoRoute(path: '/guests/form', builder: (c, s) => GuestFormScreen(guestId: s.uri.queryParameters['id'])),
GoRoute(path: '/reservations', builder: (_, __) => const ReservationsScreen()),
GoRoute(path: '/reservations/form', builder: (c, s) => ReservationFormScreen(reservationId: s.uri.queryParameters['id'])),
GoRoute(path: '/billing', builder: (_, __) => const BillingScreen()),
GoRoute(path: '/billing/invoice/:id', builder: (c, s) => InvoiceScreen(billId: s.pathParameters['id']!)),
GoRoute(path: '/staff', builder: (_, __) => const StaffScreen()),
],
);
});