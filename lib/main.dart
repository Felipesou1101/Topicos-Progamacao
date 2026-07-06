import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'providers/subscription_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pt_BR';
  runApp(const AssinaturasNinjaApp());
}

class AssinaturasNinjaApp extends StatelessWidget {
  const AssinaturasNinjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          final theme = settings.activeTheme;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Assinaturas Ninja',
            theme: theme.toThemeData(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
