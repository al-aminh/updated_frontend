import 'dart:io';
import 'package:checkfront/l10n/app_strings.dart';
import 'package:checkfront/screens/out_of_tokens_screen.dart';
import 'package:checkfront/theme/token_notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import '../models/picked_media.dart';
import '../services/audio_detector_service.dart';

class AudioDetectorScreen extends StatefulWidget {
  const AudioDetectorScreen({super.key});

  @override
  State<AudioDetectorScreen> createState() => _AudioDetectorScreenState();
}

class _AudioDetectorScreenState extends State<AudioDetectorScreen> {
  final service = AudioDetectorService();

  bool loading = false;
  bool showResult = false;

  PickedMedia? selected;
  int percent = 0;
  String verdict = '';

  Color get barColor => const Color(0xFF5B22B7);
  Color get buttonColor => const Color(0xFF6D2AEF);

  Future<void> _pickAudio() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
      allowMultiple: false,
      withData: kIsWeb, 
    );
    if (picked == null) return;

    final f = picked.files.single;

    
    final detectedMime = lookupMimeType(f.name) ?? 'audio/mpeg';

    final media = PickedMedia(
      name: f.name,
      mimeType: detectedMime,
      file: (!kIsWeb && f.path != null) ? File(f.path!) : null,
      bytes: kIsWeb ? f.bytes : null,
    );

    setState(() {
      selected = media;
      showResult = false;
      verdict = '';
      percent = 0;
    });
  }

Future<void> _detect() async {
  if (selected == null) {
    _showError("Please upload an audio file first.");
    return;
  }

  const cost = 50;

  
  final tokenProvider = context.read<TokenNotifier>();
  if (!tokenProvider.canSpend(cost)) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OutOfTokensScreen()),
    );
    return;
  }

  setState(() {
    loading = true;
    showResult = false;
    verdict = '';
    percent = 0;
  });

  try {
    
    final res = await service.detect(selected!);

    final fakeProb = (res['fake_probability'] as num).toDouble();
    final v = (res['verdict'] ?? '').toString();

    
    await tokenProvider.spend(cost);

    setState(() {
      percent = (fakeProb * 100).round();
      verdict = v;
      showResult = true;
    });
  } catch (e, st) {
    debugPrint("AUDIO DETECT ERROR: $e");
    debugPrint("$st");
    _showError(e.toString());
  } finally {
    if (mounted) setState(() => loading = false);
  }
}


  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  Widget _inputBox() {
    return GestureDetector(
      onTap: loading ? null : _pickAudio,
      child: Container(
        height: 150,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: barColor, width: 2),
        ),
        child: Center(
          child: Text(
            selected == null
                ? "Upload Audio\n.mp3 / .wav / .m4a"
                : "Audio Selected ✅\n${selected!.name}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: barColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.checkAudio(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: [
            _inputBox(),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: loading ? null : _detect,
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    :  Text(AppStrings.checkAi(context)),
              ),
            ),
            const SizedBox(height: 40),
            if (showResult) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Result",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "$percent%",
                style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "of this Audio is likely AI",
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                verdict,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}