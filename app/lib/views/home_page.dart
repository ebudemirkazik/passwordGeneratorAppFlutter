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
    final options = vm.options;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS grouped background rengi
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Password Generator',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            tooltip: 'Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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

                      IconButton(
                        onPressed: vm.generatedPassword.isNotEmpty
                            ? () {
                                Clipboard.setData(
                                  ClipboardData(text: vm.generatedPassword),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Password copied to clipboard',
                                    ),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.copy, size: 20),
                        tooltip: 'Copy',
                        color: CupertinoColors.activeBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //copy board
            if (vm.generatedPassword.isNotEmpty)
              Padding(
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
              ),

            const SizedBox(height: 16),

            // Şifre Uzunluğu
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

            const SizedBox(height: 16),

            // Karakter Seçenekleri
            _buildCheckbox(
              context,
              "Uppercase Letters (A-Z)",
              options.includeUppercase,
              (val) => _updateOption(context, 'uppercase', val),
            ),
            _buildCheckbox(
              context,
              "Lowercase Letters (a-z)",
              options.includeLowercase,
              (val) => _updateOption(context, 'lowercase', val),
            ),
            _buildCheckbox(
              context,
              "Numbers (0-9)",
              options.includeNumbers,
              (val) => _updateOption(context, 'numbers', val),
            ),
            _buildCheckbox(
              context,
              "Symbols (!@#…)",
              options.includeSymbols,
              (val) => _updateOption(context, 'symbols', val),
            ),

            if (vm.generatedPassword.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: vm.addToFavorites,
                    icon: const Icon(Icons.star_border),
                    label: const Text("Add to Favorites"),
                  ),
                ),
              ),

            const Spacer(),

            // Oluştur Butonu
            SizedBox(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(
    BuildContext context,
    String label,
    bool value,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _updateOption(BuildContext context, String type, bool? val) {
    final vm = Provider.of<PasswordViewModel>(context, listen: false);
    final opt = vm.options;
    if (val == null) return;

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
