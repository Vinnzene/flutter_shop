import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cart.dart';

class PurchaseHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history = PurchaseHistory.getHistory();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pembelian'),
      ),
      body: history.isEmpty
          ? Center(
              child: Text('Belum ada riwayat pembelian'),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: Theme.of(context).iconTheme.color,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0), // Border radius untuk gambar
                      child: Image.network(
                        item.productImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.error,
                            size: 50,
                            color: Colors.red,
                          );
                        },
                      ),
                    ),
                    title: Text(
                      item.productName,
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.black // Teks untuk dark mode
                            : Colors.white, // Teks untuk light mode
                      ),
                    ),
                    subtitle: Text(
                      'Harga: ${item.productPrice}\nJumlah: ${item.quantity}\nTanggal: ${DateFormat('dd/MM/yyyy').format(item.purchaseDate)}',
                      style: TextStyle(
                        color: isDarkMode
                            ?  Colors.black // Teks subtitle untuk dark mode
                            :  Colors.white, // Teks subtitle untuk light mode
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
