
import 'package:checkfront/l10n/app_strings.dart';
import 'package:checkfront/screens/about_screen.dart';
import 'package:checkfront/screens/token_screen.dart';
import 'package:checkfront/screens/tutorial_screen.dart';
import 'package:checkfront/theme/language_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Authentication/login_screen.dart';
import '../theme/theme_notifier.dart';
import '../screens/nav_shell.dart'; 

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget menuItem({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.9)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                ),
              ],
            ),
          ),
        ),
      );
    }

   
    final user = Supabase.instance.client.auth.currentUser;
    final displayName =
        (user?.userMetadata?['username']?.toString().trim().isNotEmpty ?? false)
            ? user!.userMetadata!['username'].toString()
            : (user?.email ?? "User");

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A1224), Color(0xFF060B14)],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF7F7FA), Color(0xFFFFFFFF)],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF1E2A44),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? "",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.65),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(
                          isDark ? 0.18 : 0.9,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Menu
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Dark mode toggle
                      Consumer<ThemeNotifier>(
                        builder: (context, notifier, _) {
                          return Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withOpacity(
                                isDark ? 0.10 : 0.92,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  isDark ? 0.10 : 0.06,
                                ),
                              ),
                            ),
                            child: SwitchListTile.adaptive(
                              value: notifier.isDarkMode,
                              onChanged: (v) => notifier.setDarkMode(v),
                              title: Text(
                                "Dark Mode",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              secondary: Icon(
                                notifier.isDarkMode
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                                color: theme.colorScheme.onSurface.withOpacity(0.85),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      Consumer<LanguageNotifier>(
                        builder: (context, langNotifier, _) {
                          return Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withOpacity(
                                isDark ? 0.10 : 0.92,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  isDark ? 0.10 : 0.06,
                                ),
                              ),
                            ),
                            child: SwitchListTile.adaptive(
                              value: langNotifier.isBangla,
                              onChanged: (_) => langNotifier.toggleLanguage(),
                              title: Text(
                                "বাংলা",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              secondary: Icon(
                                Icons.language_rounded,
                                color: theme.colorScheme.onSurface.withOpacity(0.85),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(
                            isDark ? 0.10 : 0.92,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withOpacity(
                              isDark ? 0.10 : 0.06,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            
                            menuItem(
                              icon: Icons.history_rounded,
                              title: AppStrings.history(context),
                              onTap: () {
                                Navigator.pop(context); // close drawer
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const NavShell(initialIndex: 1),
                                  ),
                                );
                              },
                            ),

                            menuItem(
                              icon: Icons.school_rounded,
                              title: AppStrings.tutorial(context),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const TutorialScreen()),
                                );
                              },
                          ),

                            
                          menuItem(
                              icon: Icons.info_outline_rounded,
                              title: AppStrings.about(context),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AboutScreen(),
                                  ),
                                );
                              },
                            ),

                          menuItem(
                            icon: Icons.confirmation_number_rounded,
                            title: AppStrings.tokens(context), // later we can translate too
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const TokenScreen()),
                              );
                            },
                          ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await Supabase.instance.client.auth.signOut();
                        if (!context.mounted) return;

                        
                        Navigator.pop(context);

                        // Go to Login and clear stack
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Logout failed: $e")),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD93B3B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}