import 'package:flutter/material.dart';

class MessageInputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark or light
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Add a public comment...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: () {
                  // Handle sending the comment
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
