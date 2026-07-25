import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/local/database_helper.dart';
import '../../data/models/models.dart';
import 'package:sqflite/sqflite.dart';
const _uuid = Uuid();

// ROOMS
final roomsProvider = FutureProvider<List<Room>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.query('rooms', orderBy: 'number');
  return rows.map(Room.fromMap).toList();
});

Future<void> saveRoom(Room r, {bool isNew = true}) async {
  final db = await DatabaseHelper.instance.database;
  if (isNew) {
    await db.insert('rooms', r.toMap());
  } else {
    await db.update('rooms', r.toMap(), where: 'id=?', whereArgs: [r.id]);
  }
}

Future<void> deleteRoom(String id) async {
  final db = await DatabaseHelper.instance.database;
  await db.delete('rooms', where: 'id=?', whereArgs: [id]);
}

// GUESTS
final guestsProvider = FutureProvider<List<Guest>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.query('guests', orderBy: 'name');
  return rows.map(Guest.fromMap).toList();
});

Future<void> saveGuest(Guest g, {bool isNew = true}) async {
  final db = await DatabaseHelper.instance.database;
  if (isNew) {
    await db.insert('guests', g.toMap());
  } else {
    await db.update('guests', g.toMap(), where: 'id=?', whereArgs: [g.id]);
  }
}

Future<void> deleteGuest(String id) async {
  final db = await DatabaseHelper.instance.database;
  await db.delete('guests', where: 'id=?', whereArgs: [id]);
}

// RESERVATIONS
final reservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.query('reservations', orderBy: 'check_in DESC');
  return rows.map(Reservation.fromMap).toList();
});

Future<bool> isRoomAvailable(String roomId, DateTime ci, DateTime co, {String? excludeId}) async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.query('reservations',
      where: 'room_id=? AND status!=? AND NOT(check_out<=? OR check_in>=?)',
      whereArgs: [roomId, 'Cancelled', ci.toIso8601String(), co.toIso8601String()]);
  if (excludeId == null) return rows.isEmpty;
  return rows.every((r) => r['id'] == excludeId);
}

Future<void> saveReservation(Reservation r, {bool isNew = true}) async {
  final db = await DatabaseHelper.instance.database;
  if (isNew) {
    await db.insert('reservations', r.toMap());
  } else {
    await db.update('reservations', r.toMap(), where: 'id=?', whereArgs: [r.id]);
  }
  // sync room status
  final status = r.status == 'Checked-In' ? 'Occupied'
      : r.status == 'Reserved' ? 'Reserved'
      : r.status == 'Checked-Out' ? 'Cleaning' : 'Available';
  await db.update('rooms', {'status': status}, where: 'id=?', whereArgs: [r.roomId]);
}

Future<void> cancelReservation(String id, String roomId) async {
  final db = await DatabaseHelper.instance.database;
  await db.update('reservations', {'status': 'Cancelled'}, where: 'id=?', whereArgs: [id]);
  await db.update('rooms', {'status': 'Available'}, where: 'id=?', whereArgs: [roomId]);
}

Future<void> deleteReservation(String id) async {
  final db = await DatabaseHelper.instance.database;

  // Get reservation details before deleting
  final reservation = await db.query(
    'reservations',
    where: 'id=?',
    whereArgs: [id],
    limit: 1,
  );
}
// BILLS
final billsProvider = FutureProvider<List<Bill>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.query('bills', orderBy: 'created_at DESC');
  return rows.map(Bill.fromMap).toList();
});

Future<String> generateBill(Reservation r, double servicesTotal) async {
  final db = await DatabaseHelper.instance.database;
  final tax = (r.total + servicesTotal) * 0.1;
  final id = _uuid.v4();
  await db.insert('bills', {
    'id': id, 'reservation_id': r.id, 'room_charges': r.total,
    'service_charges': servicesTotal, 'tax': tax,
    'total': r.total + servicesTotal + tax, 'status': 'Pending',
    'created_at': DateTime.now().toIso8601String(),
  });
  return id;
}

Future<void> updateBillStatus(String id, String status) async {
  final db = await DatabaseHelper.instance.database;
  await db.update('bills', {'status': status}, where: 'id=?', whereArgs: [id]);
}

// STAFF
final staffProvider = FutureProvider<List<Staff>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.query('staff', orderBy: 'name');
  return rows.map(Staff.fromMap).toList();
});

Future<void> saveStaff(Staff s, {bool isNew = true}) async {
  final db = await DatabaseHelper.instance.database;
  if (isNew) {
    await db.insert('staff', s.toMap());
  } else {
    await db.update('staff', s.toMap(), where: 'id=?', whereArgs: [s.id]);
  }
}

Future<void> deleteStaff(String id) async {
  final db = await DatabaseHelper.instance.database;
  await db.delete('staff', where: 'id=?', whereArgs: [id]);
}

// DASHBOARD
class DashboardStats {
  final int total, available, occupied, checkInsToday, checkOutsToday;
  final double occupancy, revenue;
  DashboardStats(this.total, this.available, this.occupied,
      this.checkInsToday, this.checkOutsToday, this.occupancy, this.revenue);
}

final dashboardProvider = FutureProvider<DashboardStats>((ref) async {
  final db = await DatabaseHelper.instance.database;
  final rooms = await db.query('rooms');
  final total = rooms.length;
  final avail = rooms.where((r) => r['status'] == 'Available').length;
  final occ = rooms.where((r) => r['status'] == 'Occupied').length;

  final today = DateTime.now();
  final start = DateTime(today.year, today.month, today.day).toIso8601String();
  final end = DateTime(today.year, today.month, today.day, 23, 59).toIso8601String();

  final ci = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM reservations WHERE check_in BETWEEN ? AND ?', [start, end])) ?? 0;
  final co = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM reservations WHERE check_out BETWEEN ? AND ?', [start, end])) ?? 0;

  final revRows = await db.rawQuery('SELECT SUM(total) as s FROM bills WHERE status=?', ['Paid']);
  final revenue = (revRows.first['s'] as num?)?.toDouble() ?? 0.0;
  final occRate = total == 0 ? 0.0 : (occ / total) * 100;

  return DashboardStats(total, avail, occ, ci, co, occRate, revenue);
});