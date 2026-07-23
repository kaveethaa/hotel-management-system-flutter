import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/database_helper.dart';
import '../../data/models/models.dart';

class AuthState {
  final AppUser? user;
  AuthState(this.user);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(null));

  Future<bool> login(String username, String password) async {
    final db = await DatabaseHelper.instance.database;
    final res = await db.query('users',
        where: 'username=? AND password=?', whereArgs: [username, password], limit: 1);
    if (res.isEmpty) return false;
    state = AuthState(AppUser.fromMap(res.first));
    return true;
  }

  void logout() => state = AuthState(null);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());