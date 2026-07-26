import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    String path;

    debugPrint("Opening database...");
    if (kIsWeb) {
      // Browser storage (IndexedDB via sqflite_common_ffi_web)

      path = 'hotel.db';
     // var db = openDatabase(path);
    } else {
      path = join(await getDatabasesPath(), 'hotel.db');
    }

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: _create,
    );

    debugPrint("Database opened");
    return db;
  }

  Future<void> _create(Database db, int v) async {
    debugPrint("DATABASE CREATED");
    await db.execute('''CREATE TABLE users(
      id TEXT PRIMARY KEY, username TEXT UNIQUE, password TEXT, role TEXT, name TEXT)''');
    await db.execute('''CREATE TABLE staff(
      id TEXT PRIMARY KEY, name TEXT, role TEXT, phone TEXT, email TEXT, salary REAL)''');
    await db.execute('''CREATE TABLE guests(
      id TEXT PRIMARY KEY, name TEXT, phone TEXT, email TEXT,
      id_type TEXT, id_number TEXT, address TEXT, created_at TEXT)''');
    await db.execute('''CREATE TABLE rooms(
      id TEXT PRIMARY KEY, number TEXT UNIQUE, type TEXT,
      status TEXT, price REAL, capacity INTEGER, description TEXT)''');
    await db.execute('''CREATE TABLE reservations(
      id TEXT PRIMARY KEY, guest_id TEXT, room_id TEXT,
      check_in TEXT, check_out TEXT, status TEXT, total REAL,
      created_at TEXT,
      FOREIGN KEY(guest_id) REFERENCES guests(id),
      FOREIGN KEY(room_id) REFERENCES rooms(id))''');
    await db.execute('''CREATE TABLE bills(
      id TEXT PRIMARY KEY, reservation_id TEXT, room_charges REAL,
      service_charges REAL, tax REAL, total REAL, status TEXT,
      created_at TEXT,
      FOREIGN KEY(reservation_id) REFERENCES reservations(id))''');
    await db.execute('''CREATE TABLE services(
      id TEXT PRIMARY KEY, bill_id TEXT, name TEXT, price REAL,
      FOREIGN KEY(bill_id) REFERENCES bills(id))''');
    await db.execute('''CREATE TABLE ratings(
      id TEXT PRIMARY KEY, guest_id TEXT, reservation_id TEXT,
      rating INTEGER, comment TEXT, created_at TEXT)''');

    debugPrint("Tables created");
  }
}