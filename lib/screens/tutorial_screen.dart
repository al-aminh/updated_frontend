import 'package:checkfront/l10n/app_strings.dart';
import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color surface = theme.colorScheme.surface.withOpacity(isDark ? 0.12 : 0.92);
    Color border = theme.colorScheme.onSurface.withOpacity(isDark ? 0.10 : 0.08);

    Widget tutorialTile({
      required String title,
      required IconData icon,
      required VoidCallback onTap,
    }) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(isDark ? 0.22 : 0.85),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border),
                  ),
                  child: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.9)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
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

    void dummyOpen(String which) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$which tutorial link will be added later."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.tutorial(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card (matches your clean look)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border),
                color: surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.quickTutorials(context),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.tutorialDescription(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.75),
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            tutorialTile(
              title: AppStrings.textTutorial(context),
              icon: Icons.description_rounded,
              onTap: () => dummyOpen("Text Detector"),
            ),
            const SizedBox(height: 12),
            tutorialTile(
              title: AppStrings.imageTutorial(context),
              icon: Icons.image_rounded,
              onTap: () => dummyOpen("Image Detector"),
            ),
            const SizedBox(height: 12),
            tutorialTile(
              title: AppStrings.videoTutorial(context),
              icon: Icons.ondemand_video_rounded,
              onTap: () => dummyOpen("Video Detector"),
            ),
            const SizedBox(height: 12),
            tutorialTile(
              title: AppStrings.audioTutorial(context),
              icon: Icons.multitrack_audio_rounded,
              onTap: () => dummyOpen("Audio Detector"),
            ),
          ],
        ),
      ),
    );
  }
}