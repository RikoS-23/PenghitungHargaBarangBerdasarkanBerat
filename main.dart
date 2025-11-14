import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

void main() {
  runApp(const HargaBarangApp());
}

class HargaBarangApp extends StatelessWidget {
  const HargaBarangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6FA5),
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const HargaBarangPage(),
    );
  }
}

class HargaBarangPage extends StatefulWidget {
  const HargaBarangPage({super.key});

  @override
  State<HargaBarangPage> createState() => _HargaBarangPageState();
}

class _HargaBarangPageState extends State<HargaBarangPage> {
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController(); 
  double totalHarga = 0;

  @override
  void dispose() {
    _beratController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void hitungHarga() {
    final String hargaText = _hargaController.text.replaceAll(',', '').trim();
    final String beratText = _beratController.text.replaceAll(',', '').trim();

    final double hargaPerKg = double.tryParse(hargaText) ?? 0;
    final double berat = double.tryParse(beratText) ?? 0;

    setState(() {
      totalHarga = berat * hargaPerKg;
    });
  }

  String formatRupiah(double value) {
    if (value == 0) return '0';
    String s = value.toStringAsFixed(0);
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.black26,
        backgroundColor: const Color(0xFF4A6FA5),
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.scale, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Hitung Harga Barang',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/3/3f/Digital_Scale.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Masukkan harga per KG',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hargaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // hanya angka dan titik
              ],
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.price_change_outlined),
                hintText: 'Contoh: 20000',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Masukkan berat barang (KG)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _beratController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // hanya angka dan titik
              ],
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.monitor_weight_outlined),
                hintText: 'Contoh: 2.5',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: hitungHarga,
                icon: const Icon(Icons.calculate),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6FA5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                label: const Text(
                  'Hitung Harga',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            _infoCard(
              icon: Icons.payments,
              title: 'Harga per KG',
              value: 'Rp ${formatRupiah(double.tryParse(_hargaController.text.replaceAll(',', '').trim() ) ?? 0)}',
            ),
            const SizedBox(height: 10),
            _infoCard(
              icon: Icons.shopping_cart_checkout,
              title: 'Total Harga',
              value: 'Rp ${formatRupiah(totalHarga)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required IconData icon, required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: const Color(0xFF4A6FA5)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}