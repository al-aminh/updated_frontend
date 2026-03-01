import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/token_notifier.dart';

class OutOfTokensScreen extends StatelessWidget {
  const OutOfTokensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Out of Tokens"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: theme.colorScheme.surface.withOpacity(isDark ? 0.12 : 0.92),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(isDark ? 0.10 : 0.08),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_rounded, size: 52, color: theme.colorScheme.onSurface),
                const SizedBox(height: 12),
                Text(
                  "You have no tokens left.",
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Upgrade your plan for further use.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.75),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),

                // UI only: Reset button (optional for testing)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.read<TokenNotifier>().reset();
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text("Reset Tokens (UI only)"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}