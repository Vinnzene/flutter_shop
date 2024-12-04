import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Untuk format mata uang

class ProductDetailPage extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final String productDescription;
  final String productId;

  ProductDetailPage({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productDescription,
    required this.productId,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isWishlisted = false; // Status wishlist

  // Fungsi untuk memformat harga dengan NumberFormat
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter
        .format(int.parse(price.replaceAll(RegExp(r'[^0-9]'), '')) / 100);
  }

  Future<void> _buyProduct(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sedang memproses pembelian...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      String cleanedPrice = widget.productPrice.replaceAll(RegExp(r'[^0-9]'), '');

      final response = await http.post(
        Uri.parse('http://localhost/xampp_fluttershop/penjualan.php'),
        body: {
          'nama_produk': widget.productName,
          'harga_produk': cleanedPrice,
          'id_produk': widget.productId,
          'quantity': '1',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['value'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pembelian berhasil!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal melakukan pembelian: ${responseData['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal melakukan pembelian. Coba lagi!'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    String formattedPrice = formatCurrency(widget.productPrice);

    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Judul produk di kiri
            Text(
              widget.productName,
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          // Ikon chat di sebelah kanan AppBar
          IconButton(
            icon: Icon(Icons.chat_outlined, color: Colors.black45),
            onPressed: () {
              // Tindakan yang diambil ketika ikon chat diklik
              print('Chatbox ditekan!');
              // Bisa tambahkan navigasi ke halaman chat
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar di sisi kiri
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                widget.productImage,
                width: 350, // Perbesar gambar dengan width
                height: 350, // Perbesar gambar dengan height
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    size: 100,
                    color: Colors.red,
                  );
                },
              ),
            ),
            SizedBox(width: 16), // Jarak antara gambar dan teks
            // Penjelasan dan tombol di sisi kanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 10), // Jarak antara harga dan ikon wishlist
                      // Ikon wishlist di sebelah kanan harga
                      IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isWishlisted = !isWishlisted; // Toggle wishlist status
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    formattedPrice,
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color.fromARGB(255, 137, 198, 139),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.productDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      print('keranjang ditekan!');
                    },
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    label: Text(
                      'Keranjang',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 137, 198, 139),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _buyProduct(context),
                    child: Text(
                      'Beli Sekarang',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 137, 198, 139),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.green.shade100, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
