import 'package:flutter/material.dart';
import '../models/password_options.dart';
import '../services/password_generator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordViewModel extends ChangeNotifier {
  PasswordOptions options = PasswordOptions(length: 12);
  String generatedPassword = '';
  String passwordStrength = 'Medium';

  void updateOptions(PasswordOptions newOptions) {
    options = newOptions;
    notifyListeners();
  }

  void generatePassword() {
    generatedPassword = PasswordGeneratorService.generate(options);
    passwordStrength = _calculateStrength(generatedPassword);
    notifyListeners();
  }

  String _calculateStrength(String password) {
    if (password.length < 6) return 'Weak';
    if (password.length < 18) return 'Medium';
    if (password.length >= 10 && _hasAllTypes(password)) return 'Strong';
    return 'Medium';
  }

  bool _hasAllTypes(String password) {
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSymbol = password.contains(
      RegExp(r'[!@#\$%^&*()_\-+=<>?/{}\[\]|]'),
    );

    return hasUpper && hasLower && hasNumber && hasSymbol;
  }

  List<String> favoritePasswords = [];

  Future<void> addToFavorites() async {
    if (generatedPassword.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    if (!favoritePasswords.contains(generatedPassword)) {
      favoritePasswords.add(generatedPassword);
      await prefs.setStringList('favorites', favoritePasswords);
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    favoritePasswords = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<void> removeFromFavorites(String password) async {
    final prefs = await SharedPreferences.getInstance();

    favoritePasswords.remove(password);
    await prefs.setStringList('favorites', favoritePasswords);
    notifyListeners();
  }
}
