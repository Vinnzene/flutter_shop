import 'package:flutter/material.dart';
import 'package:flutter_shop/dashboard.dart';

class CartPage extends StatefulWidget {
  final List<dynamic> cartItems; // List to store cart products

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Function to initialize quantity if it's null
  void initializeQuantity(int index) {
    if (widget.cartItems[index]['quantity'] == null) {
      widget.cartItems[index]['quantity'] = 1; // Default quantity to 1
    }
  }

  // Function to increase or decrease the quantity of an item
  void updateQuantity(int index, int quantity) {
    setState(() {
      if (quantity > 0) {
        widget.cartItems[index]['quantity'] = quantity;
      }
    });
  }

  // Function to calculate the total price of the cart
  int calculateTotalPrice() {
    int total = 0;
    for (var item in widget.cartItems) {
      int price = int.tryParse(item['price'].toString()) ?? 0; // Convert price to int, fallback to 0 if invalid
      int quantity = item['quantity'] ?? 0; // Ensure quantity is not null

      total += price * quantity; // Calculate total price
    }
    return total;
  }

  // Function to handle adding product to the cart
  void addProductToCart(Map<String, dynamic> product) {
    setState(() {
      // Check if the product already exists in the cart
      int index = widget.cartItems.indexWhere((item) => item['id'] == product['id']);
      
      if (index == -1) {
        // If product doesn't exist, add it to the cart with quantity 1
        widget.cartItems.add({
          ...product, // Copy the product data
          'quantity': 1, // Set initial quantity to 1
        });
      } else {
        // If product exists, increase the quantity
        widget.cartItems[index]['quantity'] += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Keranjang Belanja', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage())); // Return to previous page (Dashboard)
          },
        ),
      ),
      body: widget.cartItems.isEmpty
          ? Center(child: Text('Keranjang Anda kosong!', style: TextStyle(color: Colors.white)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = widget.cartItems[index];
                      // Initialize quantity if it's null
                      initializeQuantity(index);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          child: ListTile(
                            leading: Image.network(product['image'], width: 50, height: 50),
                            title: Text(product['product']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Harga: Rp ${product['price']}'),
                                Text('Jumlah: ${product['quantity']}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.red),
                                  onPressed: () {
                                    // Decrease quantity
                                    if (product['quantity'] > 1) {
                                      updateQuantity(index, product['quantity'] - 1);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.green),
                                  onPressed: () {
                                    // Increase quantity
                                    updateQuantity(index, product['quantity'] + 1);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Total Price Display
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: Rp ${calculateTotalPrice()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
