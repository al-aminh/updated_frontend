import 'package:checkfront/l10n/app_strings.dart';
import 'package:checkfront/screens/out_of_tokens_screen.dart';
import 'package:checkfront/theme/token_notifier.dart';
import 'package:flutter/material.dart';
import '../services/text_detector_service.dart';
import 'package:provider/provider.dart';

class TextDetectorScreen extends StatefulWidget {
  const TextDetectorScreen({super.key});

  @override
  State<TextDetectorScreen> createState() => _TextDetectorScreenState();
}

class _TextDetectorScreenState extends State<TextDetectorScreen> {
  final controller = TextEditingController();
  final service = TextDetectorService();

  bool loading = false;
  bool showResult = false;

  int percent = 0;
  String verdict = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Color get barColor => const Color(0xFF16A34A);
  Color get buttonColor => const Color(0xFF2EC653);


  Future<void> _detect() async {
  final text = controller.text.trim();
  if (text.isEmpty) return;

  const cost = 30;


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
    
    final res = await service.detect(text);

    final aiProb = (res['ai_probability'] as num).toDouble();
    final v = (res['verdict'] ?? '').toString();


    await tokenProvider.spend(cost);

    setState(() {
      percent = (aiProb * 100).round();
      verdict = v;
      showResult = true;
    });

  } catch (e, st) {
    debugPrint("TEXT DETECT ERROR: $e");
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
    return Container(
      height: 150,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: barColor, width: 2),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppStrings.enterText(context),
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
        title: Text(AppStrings.checkText(context)),
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
                    : Text(AppStrings.checkAi(context)),
              ),
            ),
            const SizedBox(height: 40),
            if (showResult) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Result",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
                "of this text is likely AI",
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                verdict,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ],
        ),
      ),
    );
  }
}