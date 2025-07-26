import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/password_view_model.dart';
import 'package:flutter/services.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PasswordViewModel>(context);
    final favorites = vm.favoritePasswords;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Passwords')),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet."))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final password = favorites[index];
                return ListTile(
                  title: Text(
                    password,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: password));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Copied to clipboard"),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Remove',
                        onPressed: () {
                          vm.removeFromFavorites(password);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Removed from favorites"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
