import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/billing/billing_screen.dart';
import '../../presentation/screens/billing/invoice_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/guests/guest_form_screen.dart';
import '../../presentation/screens/guests/guests_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/reservations/reservation_form_screen.dart';
import '../../presentation/screens/reservations/reservations_screen.dart';
import '../../presentation/screens/rooms/room_form_screen.dart';
import '../../presentation/screens/rooms/rooms_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/staff/staff_screen.dart';


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