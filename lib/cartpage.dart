import 'package:flutter/material.dart';
import 'package:flutter_shop/dashboard.dart';
import 'cart.dart';
import 'paymentpage.dart'; // Import PaymentPage

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<bool> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    List<CartItem> items = Cart.getItems(); // Mendapatkan semua item di keranjang

    // Initialize selectedItems list based on the number of items
    if (selectedItems.length != items.length) {
      selectedItems = List<bool>.filled(items.length, false);
    }

    // Check if dark mode is enabled
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()), // Kembali ke halaman sebelumnya tanpa menghilangkan data cart
            );
          },
        ),
        title: Text('Keranjang Belanja'),
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? Center(child: Text('Keranjang kosong!'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      CartItem item = items[index];
                      return Card(
                        color: Theme.of(context).iconTheme.color,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Gambar produk
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
                              
                              // Kolom untuk menampilkan nama, harga, dan kuantitas produk
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.black : Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Harga: ${item.productPrice}',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.black : Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, color: isDarkMode ? Colors.black : Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            if (item.quantity > 1) {
                                              item.quantity--;
                                            } else {
                                              _showDeleteConfirmationDialog(item);
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        'x${item.quantity}',
                                        style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.black : Colors.white),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, color: isDarkMode ? Colors.black : Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            item.quantity++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              
                              // Checkbox untuk memilih item
                              Spacer(),
                              Checkbox(
                                value: selectedItems[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedItems[index] = value!;
                                  });
                                },
                                activeColor: isDarkMode ? Colors.black : Colors.white,  
                                checkColor: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Collect the selected items
                  List<CartItem> selectedCartItems = [];
                  for (int i = 0; i < items.length; i++) {
                    if (selectedItems[i]) {
                      selectedCartItems.add(items[i]);
                    }
                  }

                  // Navigate to PaymentPage with the selected items
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        selectedItems: selectedCartItems,
                      ),
                    ),
                  );
                },
                child: Text('Lanjutkan ke Pembayaran', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 137, 198, 139),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Function to show confirmation dialog when quantity is 1 or less
  Future<void> _showDeleteConfirmationDialog(CartItem item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Barang'),
          content: Text('Apakah Anda yakin ingin menghapus barang ini?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  Cart.removeItem(item.productId); // Assuming Cart.removeItem removes the item
                });
                Navigator.of(context).pop();
              },
              child: Text('Ya', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );
  }
}
