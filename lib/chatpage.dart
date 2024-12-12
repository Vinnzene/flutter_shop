import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart'; // Import emoji picker
import 'package:file_picker/file_picker.dart'; // Import file_picker
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome for WhatsApp Icon

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = []; // Store chat messages

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        // Add the user's message to the chat
        messages.add({'sender': 'user', 'message': _controller.text});
        _controller.clear();
      });

      // Simulate a customer service response after a delay
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          // Add a mock response from customer service
          messages.add({'sender': 'cs', 'message': 'Terima kasih atas pertanyaannya! Kami akan segera membantu :).'});
        });
      });
    }
  }

  Future<void> _attachFile() async {
    try {
      // Buka file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        // Ambil path file yang dipilih
        String filePath = result.files.single.path ?? "File tidak ditemukan";
        setState(() {
          // Tambahkan file ke daftar pesan
          messages.add({'sender': 'user', 'message': 'File attached: $filePath'});
        });
        print('File attached: $filePath');
      } else {
        // Jika pengguna membatalkan
        print('File picker dibatalkan.');
      }
    } catch (e) {
      print('Error saat membuka file picker: $e');
    }
  }

  // Menampilkan emoji picker dalam modal bottom sheet
  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return EmojiPicker(
          onEmojiSelected: (category, emoji) {
            setState(() {
              _controller.text += emoji.emoji; // Add emoji to text input
            });
            Navigator.pop(context); // Close the emoji picker
          },
          config: Config(
            columns: 7, // Number of emoji columns
            emojiSizeMax: 32.0, // Set emoji size
            verticalSpacing: 0, // Set space between emojis
            horizontalSpacing: 0, // Set space between emojis
            bgColor: Colors.white, // Background color
            indicatorColor: Colors.blue, // Indicator color when emoji is selected
            initCategory: Category.SMILEYS, // Default category
          ),
        );
      },
    );
  }

  // Function to launch WhatsApp
  void _launchWhatsApp() async {
    final phoneNumber = '+6281279161897'; // Change to your WhatsApp number
    final url = 'https://wa.me/$phoneNumber?text=Hello'; // URL to open WhatsApp with a predefined message

    // Check if the URL can be launched (if WhatsApp is installed)
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          message['message']!,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan apakah dark mode aktif
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Support Chat'),
        actions: [
          // WhatsApp icon button in the app bar with Tooltip
          Tooltip(
            message: 'Chat with us on WhatsApp', // The label that appears when the icon is hovered or clicked
            child: IconButton(
              padding: EdgeInsets.symmetric(horizontal: 16),
              icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.green), // Using FontAwesome Icon
              onPressed: _launchWhatsApp, // Open WhatsApp when clicked
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Chat messages list
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(messages[index]);
                },
              ),
            ),
            // Input area
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  // Emoji button to show the emoji picker
                  IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined, color: Theme.of(context).iconTheme.color),
                    onPressed: _showEmojiPicker,
                  ),
                  // Attach file button
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Theme.of(context).iconTheme.color),
                    onPressed: _attachFile,
                  ),
                  // Text input field
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.black : Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDarkMode ? Color(0xFFF5F5F5) : Color(0xFFDDDDDD),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                      onSubmitted: (text) {
                        _sendMessage(); // Send message when Enter is pressed
                      },
                    ),
                  ),
                  // Microphone button
                  IconButton(
                    icon: Icon(Icons.mic, color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      print('Microphone button pressed');
                    },
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
