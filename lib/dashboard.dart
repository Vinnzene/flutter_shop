import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk parsing JSON
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Impor intl untuk memformat angka
import 'login.dart'; // Impor halaman login
import 'productdetail.dart'; // Impor halaman ProductDetailPage
import 'cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // Latar belakang aplikasi hitam
        drawerTheme: DrawerThemeData(
        backgroundColor: Colors.black,  // Latar belakang Drawer hitam
        scrimColor: Colors.black.withOpacity(0.5), // Efek transparan di luar Drawer
        elevation: 16, // Elevasi drawer
      ),
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white), // Semua teks putih di aplikasi
      ),
      ),
        home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List products = [];
  List cartItems = [];
  List filteredProducts = []; // Menyimpan produk yang telah difilter
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController searchController = TextEditingController();
  bool isSearchVisible = false;
  bool isFocused = false;

  
  // Fungsi untuk mengambil data produk dari API
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/xampp_fluttershop/get_products.php'),
      );

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          filteredProducts = products; // Set produk yang ditampilkan awalnya adalah semua produk
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });
  }

  // Fungsi untuk memfilter produk berdasarkan input pencarian
  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) => product['product']
              .toLowerCase()
              .contains(query.toLowerCase())) // Menyaring berdasarkan judul produk
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(() {
      filterProducts(searchController.text);
    });
  }

  
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('GadgetHub', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: Colors.white, // Background app bar hitam
        actions: [
          IconButton(
            icon: Icon(isSearchVisible ? Icons.close : Icons.search),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,  // Background Drawer hitam
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255), // Background Drawer hitam
                ),
                accountName: Text('Vinnzene Fernando Karim', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))), // Nama pengguna putih
                accountEmail: Text('GadgetHub@gmail.com', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))), // Email putih
                currentAccountPicture: CircleAvatar(
                  radius: 40, // Ukuran lingkaran avatar
                  backgroundImage: NetworkImage('https://i.ibb.co/vc801Td/DSC06656.png'),
                  onBackgroundImageError: (error, stackTrace) {
                    // Jika gagal memuat gambar
                    debugPrint('Gagal memuat gambar: $error');
                  },
                  child: Icon(Icons.person, size: 40, color: Colors.white), // Fallback jika tidak ada gambar
                ),
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart, color: const Color.fromARGB(255, 0, 0, 0)),  // Ikon keranjang putih
                title: Text('Keranjang Belanja', style: TextStyle(color: const Color.fromARGB(255, 21, 21, 21))),  // Teks putih
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage(cartItems: cartItems)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: const Color.fromARGB(255, 0, 0, 0)),  // Ikon riwayat putih
                title: Text('Riwayat Belanja', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),  // Teks putih
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.settings, color: const Color.fromARGB(255, 0, 0, 0)),  // Ikon pengaturan putih
                title: Text('Setting', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),  // Teks putih
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.login, color: const Color.fromARGB(255, 0, 0, 0)),  // Ikon login putih
                title: Text('Halaman Login', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),  // Teks putih
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: const Color.fromARGB(255, 0, 0, 0)),  // Ikon logout putih
                title: Text('Logout', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),  // Teks putih
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,  // Background utama hitam
          padding: const EdgeInsets.all(16.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSearchVisible)            // Search bar dengan background hitam
                TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.white), // Teks putih di dalam TextField
                  decoration: InputDecoration( 
                    hintText: isFocused ? null : 'Cari Produk...',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Label putih
                    prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 0, 0, 0)), // Ikon pencarian putih
                    filled: true, // Mengaktifkan background hitam
                    fillColor: const Color.fromARGB(255, 255, 255, 255), // Background TextField hitam
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Tambahkan border radius di sini
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                        ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.white)))
                        : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: filteredProducts.length, // Gunakan filteredProducts
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return Card(
                                elevation: 4,
                                color: const Color.fromARGB(255, 255, 255, 255), // Background Card hitam
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10),
                                        ),
                                        child: Image.network(
                                          product['image'],
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
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['product'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(255, 35, 35, 35), // Teks judul putih
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            formatCurrency(product['price']),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color.fromARGB(255, 35, 35, 35), // Teks harga abu-abu terang
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              addToCart(product);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailPage(
                                                    productName: product['product'] ?? 'Unknown Product',
                                                    productPrice: formatCurrency(product['price'] ?? '0'),
                                                    productImage: product['image'] ?? '',
                                                    productDescription: product['description'] ?? 'No description',
                                                    productId: product['idproduct'] ?? '0',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text('Beli'),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.black, backgroundColor: const Color.fromARGB(255, 231, 231, 231), minimumSize: Size(double.infinity, 36), // Teks tombol hitam
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
             
              ),
            ],
          ),
        ),
      ),
    );
  }
}
