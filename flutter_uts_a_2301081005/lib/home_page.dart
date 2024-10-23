import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uts_a_2301081005/drawer.dart';
import 'package:intl/intl.dart';

  class MyHome extends StatefulWidget {
      static const routesName = '/home';
  const MyHome({Key? key}) : super(key: key);
  

  @override
  _FormEntryScreenState createState() => _FormEntryScreenState();
}

class _FormEntryScreenState extends State<MyHome> {
  final TextEditingController _kodePelangganController = TextEditingController();
  final TextEditingController _namaPelangganController = TextEditingController();
  final TextEditingController _tglMasukController = TextEditingController();
  final TextEditingController _jamMasukController = TextEditingController();
  final TextEditingController _jamKeluarController = TextEditingController();
  String? _jenisPelanggan;

  void _submitForm() {
    final int? jamMasuk = int.tryParse(_jamMasukController.text);
    final int? jamKeluar = int.tryParse(_jamKeluarController.text);

    if (jamMasuk == null || jamKeluar == null || _jenisPelanggan == null || _kodePelangganController.text.isEmpty || _namaPelangganController.text.isEmpty || _tglMasukController.text.isEmpty) {
      _showSnackBar('Masukkan semua data yang diperlukan');
      return;
    }

    if (jamKeluar <= jamMasuk) {
      _showSnackBar('Jam keluar harus lebih besar dari jam masuk');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          kodePelanggan: _kodePelangganController.text,
          namaPelanggan: _namaPelangganController.text,
          tglMasuk: _tglMasukController.text,
          jamMasuk: jamMasuk,
          jamKeluar: jamKeluar,
          jenisPelanggan: _jenisPelanggan!,
        ),
      ),
    );
  }

  

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _tglMasukController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengisian Pelanggan Warnet"),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _kodePelangganController,
              decoration: const InputDecoration(labelText: 'Kode Pelanggan'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _namaPelangganController,
              decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tglMasukController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: const InputDecoration(labelText: 'Tanggal Masuk'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _jamMasukController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Jam Masuk'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _jamKeluarController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Jam Keluar'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Jenis Pelanggan'),
              value: _jenisPelanggan,
              onChanged: (newValue) {
                setState(() {
                  _jenisPelanggan = newValue;
                });
              },
              items: const [
                DropdownMenuItem(value: 'VIP', child: Text('VIP')),
                DropdownMenuItem(value: 'GOLD', child: Text('GOLD')),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Hitung Total Bayar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ResultScreen extends StatelessWidget {
  final String kodePelanggan;
  final String namaPelanggan;
  final String tglMasuk;
  final int jamMasuk;
  final int jamKeluar;
  final String jenisPelanggan;

  const ResultScreen({
    Key? key,
    required this.kodePelanggan,
    required this.namaPelanggan,
    required this.tglMasuk,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.jenisPelanggan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int tarifPerJam = 10000;
    final int lama = jamKeluar - jamMasuk;

    double diskon = 0.0;
    if (jenisPelanggan == 'VIP' && lama > 2) {
      diskon = 0.02;
    } else if (jenisPelanggan == 'GOLD' && lama > 2) {
      diskon = 0.05;
    }

    final double totalTarif = lama * tarifPerJam.toDouble();
    final double totalDiskon = totalTarif * diskon;
    final double totalBayar = totalTarif - totalDiskon;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biaya Perhitungan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Kode Pelanggan', kodePelanggan),
            _buildInfoRow('Nama Pelanggan', namaPelanggan),
            _buildInfoRow('Tanggal Masuk', tglMasuk),
            _buildInfoRow('Jenis Pelanggan', jenisPelanggan),
            _buildInfoRow('Lama Pemakaian', '$lama jam'),
            _buildInfoRow('Total Tarif', 'Rp ${totalTarif.toStringAsFixed(0)}'),
            _buildInfoRow('Diskon', 'Rp ${totalDiskon.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            _buildInfoRow('Total Bayar', 'Rp ${totalBayar.toStringAsFixed(0)}',
                isBold: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
