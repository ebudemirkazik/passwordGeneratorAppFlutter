import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/password_view_model.dart';
import 'views/home_page.dart'; // UI bileşenini ayıracağız

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final viewModel = PasswordViewModel();
        viewModel.loadFavorites(); // burada çağırılıyor
        return viewModel;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'SF Pro', // Apple fontlarına benzer
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
