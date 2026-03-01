import 'package:checkfront/l10n/app_strings.dart';
import 'package:checkfront/theme/token_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_tile.dart';

import 'text_detector_screen.dart';
import 'image_detector_screen.dart';
import 'video_detector_screen.dart';
import 'audio_detector_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 202,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0B2D46), Color(0xFF3B8DBE)],
                    ),
                  ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.everydayChecker(context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.22)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Tokens",
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${context.watch<TokenNotifier>().tokens}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1.05,
                children: [
                  GradientTile(
                    title: AppStrings.checkText(context),
                    icon: Icons.description_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF7EF0A3), Color(0xFF00A553)],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TextDetectorScreen()),
                    ),
                  ),
                  GradientTile(
                    title: AppStrings.checkImage(context),
                    icon: Icons.image_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFF0A0), Color(0xFFD88D00)],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ImageDetectorScreen()),
                    ),
                  ),
                  GradientTile(
                    title: AppStrings.checkVideo(context),
                    icon: Icons.ondemand_video_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFA6A6), Color(0xFFFF2A2A)],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VideoDetectorScreen()),
                    ),
                  ),
                  GradientTile(
                    title: AppStrings.checkAudio(context),
                    icon: Icons.multitrack_audio_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFCDA9FF), Color(0xFF5B22B7)],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AudioDetectorScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}