import 'package:checkfront/theme/language_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/nav_shell.dart';
import 'Authentication/login_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dtoajgamslmknatxqjxr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR0b2FqZ2Ftc2xta25hdHhxanhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIyODAyNzQsImV4cCI6MjA4Nzg1NjI3NH0.4NGGne0WlLENc-zvTi64NG_zOYI2JGJ6TKcLjXskmbQ',
  );

  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadFromPrefs();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: themeNotifier),
          ChangeNotifierProvider(create: (_) => LanguageNotifier()), // ✅ add this
        ],
        child: const CheckAiApp(),
      ),
);
}


class CheckAiApp extends StatelessWidget {
  const CheckAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final languageNotifier = context.watch<LanguageNotifier>();

    return MaterialApp(
      title: 'CheckAi',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeNotifier.themeMode,

      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
      locale: languageNotifier.currentLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const AuthGate(),
    );
  }
}

/// Shows NavShell if logged in, otherwise LoginScreen.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;

        // While auth stream initializes, show a small loader
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (session != null) {
          return const NavShell(); // ✅ your existing home (tabs/shell)
        }

        return const LoginScreen(); // ✅ login/register flow
      },
    );
  }
}
