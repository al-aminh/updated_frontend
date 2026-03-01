// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../theme/token_notifier.dart';

// class TokenScreen extends StatelessWidget {
//   const TokenScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//     final tokens = context.watch<TokenNotifier>().tokens;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Tokens"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             color: theme.colorScheme.surface.withOpacity(isDark ? 0.12 : 0.92),
//             border: Border.all(
//               color: theme.colorScheme.onSurface.withOpacity(isDark ? 0.10 : 0.08),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Your Tokens",
//                 style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "$tokens",
//                 style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
//               ),
//               const SizedBox(height: 14),
//               Text(
//                 "Costs:",
//                 style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
//               ),
//               const SizedBox(height: 8),
//               _row(theme, "Text detection", "30"),
//               _row(theme, "Image detection", "60"),
//               _row(theme, "Audio detection", "50"),
//               _row(theme, "Video detection", "70"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _row(ThemeData theme, String a, String b) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               a,
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: theme.colorScheme.onSurface.withOpacity(0.8),
//               ),
//             ),
//           ),
//           Text(
//             b,
//             style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/token_notifier.dart';

class TokenScreen extends StatelessWidget {
  const TokenScreen({super.key});

  static const String paypalUrl =
      "https://www.paypal.com/invoice/p/#44QE7K9YFD3MC5B8";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tokens = context.watch<TokenNotifier>().tokens;

    Color surface =
        theme.colorScheme.surface.withOpacity(isDark ? 0.12 : 0.92);
    Color border =
        theme.colorScheme.onSurface.withOpacity(isDark ? 0.10 : 0.08);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tokens"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 CARD 1 — Your Tokens
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: surface,
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Tokens",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "$tokens",
                    style: theme.textTheme.displayMedium
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 16),

                  // Buy Button
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

            const SizedBox(height: 18),

            // 🔹 CARD 2 — Costs
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: surface,
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Token Costs Per Usage :",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  _row(theme, "Text detection", "30"),
                  _row(theme, "Image detection", "60"),
                  _row(theme, "Audio detection", "50"),
                  _row(theme, "Video detection", "70"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, String a, String b) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              a,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
          Text(
            b,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}