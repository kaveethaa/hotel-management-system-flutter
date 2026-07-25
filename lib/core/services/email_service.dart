import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../data/models/models.dart';

class EmailService {
  // ⚠️ Replace with your SMTP creds. Use Gmail App Passwords: https://myaccount.google.com/apppasswords
  static const _senderEmail = 'kaveethaa@gmail.com';
  static const _appPassword = 'KavithaRN*12';
  static const _senderName  = 'Hotel Manager';

  static Future<bool> sendBookingConfirmation({
    required Guest guest, required Room room, required Reservation res,
  }) async {
    if (guest.email.isEmpty) return false;
    final smtp = gmail(_senderEmail, _appPassword);
    final msg = Message()
      ..from = Address(_senderEmail, _senderName)
      ..recipients.add("kaveethaa@gmail.com")
      ..subject = 'Booking Confirmed - Room ${room.number}'
      ..html = '''
      <div style="font-family:Arial;max-width:600px;margin:auto;">
        <div style="background:#1A2B4A;color:#D4AF37;padding:20px;text-align:center;">
          <h1>Hotel Manager</h1><p>Booking Confirmation</p>
        </div>
        <div style="padding:20px;background:#FAF6ED;">
          <h2>Hello ${guest.name},</h2>
          <p>Your reservation has been confirmed!</p>
          <table style="width:100%;border-collapse:collapse;">
            <tr><td><b>Room:</b></td><td>${room.number} (${room.type})</td></tr>
            <tr><td><b>Check-in:</b></td><td>${res.checkIn.substring(0, 10)}</td></tr>
            <tr><td><b>Check-out:</b></td><td>${res.checkOut.substring(0, 10)}</td></tr>
            <tr><td><b>Total:</b></td><td>\$${res.total.toStringAsFixed(2)}</td></tr>
            <tr><td><b>Booking ID:</b></td><td>${res.id.substring(0, 8)}</td></tr>
          </table>
          <p style="margin-top:20px;">We look forward to hosting you!</p>
        </div>
      </div>''';
    try {
      await send(msg, smtp);
      return true;
    } catch (e) {
      return false;
    }
  }
}