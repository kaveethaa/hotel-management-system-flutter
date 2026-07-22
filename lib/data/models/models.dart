class Room {
  final String id, number, type, status, description;
  final double price;
  final int capacity;
  Room({required this.id, required this.number, required this.type, required this.status,
    required this.price, required this.capacity, this.description = ''});
  Map<String, dynamic> toMap() => {'id': id, 'number': number, 'type': type,
    'status': status, 'price': price, 'capacity': capacity, 'description': description};
  factory Room.fromMap(Map<String, dynamic> m) => Room(
      id: m['id'], number: m['number'], type: m['type'], status: m['status'],
      price: (m['price'] as num).toDouble(), capacity: m['capacity'] ?? 1,
      description: m['description'] ?? '');
}

class Guest {
  final String id, name, phone, email, idType, idNumber, address, createdAt;
  Guest({required this.id, required this.name, required this.phone, required this.email,
    required this.idType, required this.idNumber, required this.address, required this.createdAt});
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'phone': phone, 'email': email,
    'id_type': idType, 'id_number': idNumber, 'address': address, 'created_at': createdAt};
  factory Guest.fromMap(Map<String, dynamic> m) => Guest(
      id: m['id'], name: m['name'], phone: m['phone'], email: m['email'] ?? '',
      idType: m['id_type'] ?? '', idNumber: m['id_number'] ?? '',
      address: m['address'] ?? '', createdAt: m['created_at'] ?? '');
}

class Reservation {
  final String id, guestId, roomId, checkIn, checkOut, status, createdAt;
  final double total;
  Reservation({required this.id, required this.guestId, required this.roomId,
    required this.checkIn, required this.checkOut, required this.status,
    required this.total, required this.createdAt});
  Map<String, dynamic> toMap() => {'id': id, 'guest_id': guestId, 'room_id': roomId,
    'check_in': checkIn, 'check_out': checkOut, 'status': status,
    'total': total, 'created_at': createdAt};
  factory Reservation.fromMap(Map<String, dynamic> m) => Reservation(
      id: m['id'], guestId: m['guest_id'], roomId: m['room_id'],
      checkIn: m['check_in'], checkOut: m['check_out'], status: m['status'],
      total: (m['total'] as num).toDouble(), createdAt: m['created_at'] ?? '');
}

class Bill {
  final String id, reservationId, status, createdAt;
  final double roomCharges, serviceCharges, tax, total;
  Bill({required this.id, required this.reservationId, required this.roomCharges,
    required this.serviceCharges, required this.tax, required this.total,
    required this.status, required this.createdAt});
  Map<String, dynamic> toMap() => {'id': id, 'reservation_id': reservationId,
    'room_charges': roomCharges, 'service_charges': serviceCharges,
    'tax': tax, 'total': total, 'status': status, 'created_at': createdAt};
  factory Bill.fromMap(Map<String, dynamic> m) => Bill(
      id: m['id'], reservationId: m['reservation_id'],
      roomCharges: (m['room_charges'] as num).toDouble(),
      serviceCharges: (m['service_charges'] as num).toDouble(),
      tax: (m['tax'] as num).toDouble(), total: (m['total'] as num).toDouble(),
      status: m['status'], createdAt: m['created_at'] ?? '');
}

class Staff {
  final String id, name, role, phone, email;
  final double salary;
  Staff({required this.id, required this.name, required this.role,
    required this.phone, required this.email, required this.salary});
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'role': role,
    'phone': phone, 'email': email, 'salary': salary};
  factory Staff.fromMap(Map<String, dynamic> m) => Staff(
      id: m['id'], name: m['name'], role: m['role'], phone: m['phone'],
      email: m['email'] ?? '', salary: (m['salary'] as num).toDouble());
}

class AppUser {
  final String id, username, role, name;
  AppUser({required this.id, required this.username, required this.role, required this.name});
  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
      id: m['id'], username: m['username'], role: m['role'], name: m['name']);
}