import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../data/datasources/local/database_helper.dart';
import '../../../data/models/models.dart';
import '../../providers/data_providers.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  final String billId;
  const InvoiceScreen({super.key, required this.billId});
  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  Bill? _bill;
  Reservation? _res;
  Guest? _guest;
  Room? _room;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await DatabaseHelper.instance.database;
    final b = await db.query('bills', where: 'id=?', whereArgs: [widget.billId], limit: 1);
    if (b.isEmpty) return;
    final bill = Bill.fromMap(b.first);
    final r = await db.query('reservations', where: 'id=?', whereArgs: [bill.reservationId], limit: 1);
    final res = Reservation.fromMap(r.first);
    final g = await db.query('guests', where: 'id=?', whereArgs: [res.guestId], limit: 1);
    final rm = await db.query('rooms', where: 'id=?', whereArgs: [res.roomId], limit: 1);
    if (!mounted) return;
    setState(() {
      _bill = bill; _res = res;
      _guest = Guest.fromMap(g.first); _room = Room.fromMap(rm.first);
    });
  }

  Future<void> _printPdf() async {
    final doc = pw.Document();
    final fmt = NumberFormat.currency(symbol: '\$');
    final df = DateFormat('MMM d, y');
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('HOTEL MANAGER', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.Text('Invoice #${_bill!.id.substring(0, 8)}'),
          pw.SizedBox(height: 20),
          pw.Text('Guest: ${_guest!.name}'),
          pw.Text('Phone: ${_guest!.phone}'),
          pw.Text('${_guest!.idType}: ${_guest!.idNumber}'),
          pw.SizedBox(height: 12),
          pw.Text('Room: ${_room!.number} (${_room!.type})'),
          pw.Text('Check-in: ${df.format(DateTime.parse(_res!.checkIn))}'),
          pw.Text('Check-out: ${df.format(DateTime.parse(_res!.checkOut))}'),
          pw.Divider(),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Room Charges'), pw.Text(fmt.format(_bill!.roomCharges))]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Service Charges'), pw.Text(fmt.format(_bill!.serviceCharges))]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Tax (10%)'), pw.Text(fmt.format(_bill!.tax))]),
          pw.Divider(),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('TOTAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text(fmt.format(_bill!.total), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16))]),
          pw.SizedBox(height: 20),
          pw.Text('Status: ${_bill!.status}'),
          pw.SizedBox(height: 24),
          pw.Text('Thank you for your stay!', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
        ])));
    await Printing.layoutPdf(onLayout: (f) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    if (_bill == null || _guest == null || _room == null || _res == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final fmt = NumberFormat.currency(symbol: '\$');
    final df = DateFormat('MMM d, y');
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice'), actions: [
        IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: _printPdf),
      ]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(child: Padding(padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('HOTEL MANAGER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    QrImageView(data: 'BILL:${_bill!.id}', size: 80),
                  ]),
                  Text('Invoice #${_bill!.id.substring(0, 8)}', style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 24),
                  Text('Guest: ${_guest!.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(_guest!.phone),
                  Text('${_guest!.idType}: ${_guest!.idNumber}'),
                  const SizedBox(height: 12),
                  Text('Room: ${_room!.number} (${_room!.type})'),
                  Text('${df.format(DateTime.parse(_res!.checkIn))} → ${df.format(DateTime.parse(_res!.checkOut))}'),
                  const Divider(height: 24),
                  _row('Room Charges', fmt.format(_bill!.roomCharges)),
                  _row('Service Charges', fmt.format(_bill!.serviceCharges)),
                  _row('Tax (10%)', fmt.format(_bill!.tax)),
                  const Divider(),
                  _row('TOTAL', fmt.format(_bill!.total), bold: true),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Text('Status: '),
                    Chip(label: Text(_bill!.status, style: const TextStyle(color: Colors.white)),
                        backgroundColor: _bill!.status == 'Paid' ? Colors.green
                            : _bill!.status == 'Partial' ? Colors.blue : Colors.orange),
                  ]),
                ]))),
            const SizedBox(height: 12),
            if (_bill!.status != 'Paid') Row(children: [
              Expanded(child: OutlinedButton(onPressed: () async {
                await updateBillStatus(_bill!.id, 'Partial');
                ref.invalidate(billsProvider); _load();
              }, child: const Text('Mark Partial'))),
              const SizedBox(width: 8),
              Expanded(child: FilledButton(onPressed: () async {
                await updateBillStatus(_bill!.id, 'Paid');
                ref.invalidate(billsProvider); _load();
              }, child: const Text('Mark Paid'))),
            ]),
          ])),
    );
  }

  Widget _row(String label, String val, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 16 : 14)),
        Text(val, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 16 : 14)),
      ]));
}