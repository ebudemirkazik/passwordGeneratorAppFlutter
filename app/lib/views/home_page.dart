import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/password_view_model.dart';
import '../models/password_options.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'favorites_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PasswordViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(),
        actions: const [
          FavoriteButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GeneratedPasswordCard(vm: vm),
            
            if (vm.generatedPassword.isNotEmpty)
              PasswordStrengthIndicator(vm: vm),

            const SizedBox(height: 16),

            PasswordLengthSlider(vm: vm),

            const SizedBox(height: 16),

            CharacterOptionsSection(vm: vm),

            if (vm.generatedPassword.isNotEmpty)
              AddToFavoritesButton(vm: vm),

            const Spacer(),

            GeneratePasswordButton(vm: vm),
          ],
        ),
      ),
    );
  }
}

// AppBar Title Component - iOS 18 Style
class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
            height: 1.0,
          ),
        ),
        Text(
          'Generator',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.08,
            color: Colors.black.withOpacity(0.6),
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

// Favorite Button Component
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.star),
      tooltip: 'Favorites',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesPage()),
        );
      },
    );
  }
}

// Generated Password Card Component
class GeneratedPasswordCard extends StatelessWidget {
  final PasswordViewModel vm;
  
  const GeneratedPasswordCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Generated Password",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  vm.generatedPassword.isNotEmpty
                      ? vm.generatedPassword
                      : 'Not generated yet',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Courier',
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              CopyPasswordButton(vm: vm),
            ],
          ),
        ],
      ),
    );
  }
}

// Copy Password Button Component
class CopyPasswordButton extends StatelessWidget {
  final PasswordViewModel vm;
  
  const CopyPasswordButton({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: vm.generatedPassword.isNotEmpty
          ? () {
              Clipboard.setData(
                ClipboardData(text: vm.generatedPassword),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password copied to clipboard'),
                ),
              );
            }
          : null,
      icon: const Icon(Icons.copy, size: 20),
      tooltip: 'Copy',
      color: CupertinoColors.activeBlue,
    );
  }
}

// Password Strength Indicator Component
class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordViewModel vm;
  
  const PasswordStrengthIndicator({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const Text(
            "Strength:",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(
            vm.passwordStrength,
            style: TextStyle(
              color: _getStrengthColor(vm.passwordStrength),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStrengthColor(String strength) {
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// Password Length Slider Component
class PasswordLengthSlider extends StatelessWidget {
  final PasswordViewModel vm;
  
  const PasswordLengthSlider({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final options = vm.options;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password Length: ${options.length}"),
        Slider(
          min: 4,
          max: 32,
          divisions: 28,
          value: options.length.toDouble(),
          label: options.length.toString(),
          onChanged: (value) {
            vm.updateOptions(
              PasswordOptions(
                length: value.toInt(),
                includeUppercase: options.includeUppercase,
                includeLowercase: options.includeLowercase,
                includeNumbers: options.includeNumbers,
                includeSymbols: options.includeSymbols,
              ),
            );
          },
        ),
      ],
    );
  }
}

// Character Options Section Component
class CharacterOptionsSection extends StatelessWidget {
  final PasswordViewModel vm;
  
  const CharacterOptionsSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final options = vm.options;
    
    return Column(
      children: [
        CharacterOptionCheckbox(
          label: "Uppercase Letters (A-Z)",
          value: options.includeUppercase,
          onChanged: (val) => _updateOption(context, 'uppercase', val),
        ),
        CharacterOptionCheckbox(
          label: "Lowercase Letters (a-z)",
          value: options.includeLowercase,
          onChanged: (val) => _updateOption(context, 'lowercase', val),
        ),
        CharacterOptionCheckbox(
          label: "Numbers (0-9)",
          value: options.includeNumbers,
          onChanged: (val) => _updateOption(context, 'numbers', val),
        ),
        CharacterOptionCheckbox(
          label: "Symbols (!@#…)",
          value: options.includeSymbols,
          onChanged: (val) => _updateOption(context, 'symbols', val),
        ),
      ],
    );
  }

  void _updateOption(BuildContext context, String type, bool? val) {
    if (val == null) return;
    
    final opt = vm.options;
    vm.updateOptions(
      PasswordOptions(
        length: opt.length,
        includeUppercase: type == 'uppercase' ? val : opt.includeUppercase,
        includeLowercase: type == 'lowercase' ? val : opt.includeLowercase,
        includeNumbers: type == 'numbers' ? val : opt.includeNumbers,
        includeSymbols: type == 'symbols' ? val : opt.includeSymbols,
      ),
    );
  }
}

// Character Option Checkbox Component
class CharacterOptionCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool?) onChanged;
  
  const CharacterOptionCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}

// Add to Favorites Button Component
class AddToFavoritesButton extends StatelessWidget {
  final PasswordViewModel vm;
  
  const AddToFavoritesButton({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: vm.addToFavorites,
          icon: const Icon(Icons.star_border),
          label: const Text("Add to Favorites"),
        ),
      ),
    );
  }
}

// Generate Password Button Component
class GeneratePasswordButton extends StatelessWidget {
  final PasswordViewModel vm;
  
  const GeneratePasswordButton({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: vm.generatePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: CupertinoColors.activeBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "Generate Password",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}