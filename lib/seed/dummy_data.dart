import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';
class DummyDataSeeder {
  static const _uuid = Uuid();

  static Future<void> seedIfEmpty(Database db) async {
    debugPrint("Step 4 seed");
    final c = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users')) ?? 0;
    if (c > 0) return;

    await db.insert('users', {'id': _uuid.v4(), 'username': 'admin', 'password': 'admin123', 'role': 'Admin', 'name': 'Hotel Admin'});
    await db.insert('users', {'id': _uuid.v4(), 'username': 'recep', 'password': 'recep123', 'role': 'Receptionist', 'name': 'Front Desk'});
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM users'),
    );

    debugPrint("Users count = $count");
    final rooms = [
      {'number': '101', 'type': 'Standard', 'price': 80.0, 'capacity': 2},
      {'number': '102', 'type': 'Standard', 'price': 80.0, 'capacity': 2},
      {'number': '103', 'type': 'Deluxe', 'price': 130.0, 'capacity': 3},
      {'number': '201', 'type': 'Deluxe', 'price': 130.0, 'capacity': 3},
      {'number': '202', 'type': 'Suite', 'price': 250.0, 'capacity': 4},
      {'number': '203', 'type': 'Suite', 'price': 250.0, 'capacity': 4},
      {'number': '301', 'type': 'Standard', 'price': 85.0, 'capacity': 2},
      {'number': '302', 'type': 'Deluxe', 'price': 135.0, 'capacity': 3},
      {'number': '303', 'type': 'Suite', 'price': 260.0, 'capacity': 4},
      {'number': '304', 'type': 'Standard', 'price': 85.0, 'capacity': 2},
    ];
    final statuses = ['Available', 'Occupied', 'Available', 'Reserved', 'Available',
      'Cleaning', 'Available', 'Occupied', 'Available', 'Maintenance'];
    final roomIds = <String>[];
    for (var i = 0; i < rooms.length; i++) {
      final id = _uuid.v4();
      roomIds.add(id);
      await db.insert('rooms', {'id': id, ...rooms[i], 'status': statuses[i],
        'description': '${rooms[i]['type']} room with modern amenities'});
    }

    final guests = [
      {'name': 'John Doe', 'phone': '+1-555-0101', 'email': 'john@example.com', 'id_type': 'Passport', 'id_number': 'P1234567', 'address': 'New York, USA'},
      {'name': 'Jane Smith', 'phone': '+1-555-0102', 'email': 'jane@example.com', 'id_type': 'Driving License', 'id_number': 'DL8888', 'address': 'Los Angeles, USA'},
      {'name': 'Raj Patel', 'phone': '+91-98765-43210', 'email': 'raj@example.com', 'id_type': 'Aadhaar', 'id_number': '1234-5678-9012', 'address': 'Mumbai, India'},
      {'name': 'Emma Wilson', 'phone': '+44-20-7946-0958', 'email': 'emma@example.com', 'id_type': 'Passport', 'id_number': 'UK998877', 'address': 'London, UK'},
      {'name': 'Chen Wei', 'phone': '+86-138-0000-1111', 'email': 'chen@example.com', 'id_type': 'Passport', 'id_number': 'CN556677', 'address': 'Shanghai, China'},
    ];
    final now = DateTime.now().toIso8601String();
    final guestIds = <String>[];
    for (final g in guests) {
      final id = _uuid.v4();
      guestIds.add(id);
      await db.insert('guests', {'id': id, ...g, 'created_at': now});
    }

    // 3 reservations
    final today = DateTime.now();
    final resList = [
      {'guest': 0, 'room': 1, 'in': today.subtract(const Duration(days: 1)), 'out': today.add(const Duration(days: 2)), 'status': 'Checked-In'},
      {'guest': 1, 'room': 3, 'in': today.add(const Duration(days: 3)), 'out': today.add(const Duration(days: 6)), 'status': 'Reserved'},
      {'guest': 2, 'room': 7, 'in': today.subtract(const Duration(days: 2)), 'out': today, 'status': 'Checked-In'},
    ];
    for (final r in resList) {
      final gi = r['guest'] as int; final ri = r['room'] as int;
      final ci = r['in'] as DateTime; final co = r['out'] as DateTime;
      final nights = co.difference(ci).inDays.abs().clamp(1, 999);
      final price = (rooms[ri]['price'] as double);
      await db.insert('reservations', {
        'id': _uuid.v4(), 'guest_id': guestIds[gi], 'room_id': roomIds[ri],
        'check_in': ci.toIso8601String(), 'check_out': co.toIso8601String(),
        'status': r['status'], 'total': price * nights, 'created_at': now,
      });
    }

    final staff = [
      {'name': 'Alice Manager', 'role': 'Manager', 'phone': '+1-555-9001', 'email': 'alice@hotel.com', 'salary': 5000.0},
      {'name': 'Bob Housekeeping', 'role': 'Housekeeping', 'phone': '+1-555-9002', 'email': 'bob@hotel.com', 'salary': 2200.0},
      {'name': 'Carol Chef', 'role': 'Chef', 'phone': '+1-555-9003', 'email': 'carol@hotel.com', 'salary': 3500.0},
      {'name': 'David Security', 'role': 'Security', 'phone': '+1-555-9004', 'email': 'david@hotel.com', 'salary': 2500.0},
    ];
    for (final s in staff) {
      await db.insert('staff', {'id': _uuid.v4(), ...s});
    }
    final count1 = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM staff'),
    );

    debugPrint("Users count = $count1");
    Fluttertoast.showToast(
      msg: "Users count = $count1",
    );
  }
}
