import 'package:flutter/material.dart';
import 'package:flutter_shop/cart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'purchasehistoryitem.dart';

class PaymentPage extends StatefulWidget {
  final List<CartItem> selectedItems;

  PaymentPage({required this.selectedItems});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;
  String errorMessage = '';
  String successMessage = '';

  // Fungsi untuk menghitung total harga
  double _calculateTotal(List<CartItem> selectedItems) {
    double total = 0;
    for (var item in selectedItems) {
      double price = double.parse(item.productPrice.replaceAll(RegExp(r'[^0-9]'), '')) / 100.0;
      total += price * item.quantity; // Kalikan harga dengan jumlah
    }
    return total;
  }

  Future<void> _buyProduct(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sedang memproses pembayaran...'),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      // Iterasi setiap item yang dipilih dan lakukan proses pembelian
      for (CartItem item in widget.selectedItems) {
        String cleanedPrice = item.productPrice.replaceAll(RegExp(r'[^0-9]'), '');

        final response = await http.post(
          Uri.parse('http://localhost/xampp_fluttershop/penjualan.php'),
          body: {
            'nama_produk': item.productName,
            'harga_produk': cleanedPrice,
            'id_produk': item.productId,
            'quantity': item.quantity.toString(),
          },
        );

        if (response.statusCode != 200 || json.decode(response.body)['value'] != 1) {
          throw Exception('Gagal memproses pembayaran untuk ${item.productName}');
        }

        // Tambahkan item ke dalam riwayat pembelian
        PurchaseHistory.addHistoryItem(
          PurchaseHistoryItem(
            productId: item.productId,
            productName: item.productName,
            productPrice: item.productPrice,
            productImage: item.productImage,
            quantity: item.quantity,
            purchaseDate: DateTime.now(), // Tanggal pembelian
          ),
        );
      }

      // Jika semua berhasil, tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pembayaran berhasil diproses!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // Navigasi ke halaman berikutnya atau reset keranjang
      setState(() {
        Cart.clearItems(); // Menghapus semua item di keranjang
      });
      Navigator.pop(context); // Kembali ke halaman sebelumnya

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double total = _calculateTotal(widget.selectedItems); // Hitung total harga
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show the selected items in cards
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedItems.length,
                itemBuilder: (context, index) {
                  CartItem item = widget.selectedItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: Theme.of(context).iconTheme.color,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              item.productImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.black : Colors.white,
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Harga: ${item.productPrice}',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.black : Colors.white,
                                ),
                              ),
                              Text(
                                'Jumlah: x${item.quantity}',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.black : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Menampilkan total harga
            SizedBox(height: 20),
            Text(
              'Total Pembayaran: Rp ${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(total)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode 
                    ? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _buyProduct(context), // Memanggil fungsi _buyProduct
              child: Text('Proses Pembayaran', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 137, 198, 139),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
