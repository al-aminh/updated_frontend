import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';


class OutOfTokensScreen extends StatelessWidget {
  const OutOfTokensScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const String paypalUrl =
      "https://www.paypal.com/invoice/p/#44QE7K9YFD3MC5B8";

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

                
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(paypalUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: const Icon(
                                Icons.shopping_cart_rounded,
                                color: Colors.white,
                                      ),
                      label: const Text("Buy More Tokens", style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(0, 0, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          
                        ),
                      ),
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