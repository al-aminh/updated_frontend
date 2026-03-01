import 'package:flutter/material.dart';

class AppStrings {
  static String homeTitle(BuildContext context) =>
      _isBn(context) ? "চেকএআই" : "CheckAi";

  static String checkText(BuildContext context) =>
      _isBn(context) ? "টেক্সট যাচাই করুন" : "Check Text";

  static String checkImage(BuildContext context) =>
      _isBn(context) ? "ছবি যাচাই করুন" : "Check Image";

  static String checkVideo(BuildContext context) =>
      _isBn(context) ? "ভিডিও যাচাই করুন" : "Check Video";

  static String checkAudio(BuildContext context) =>
      _isBn(context) ? "অডিও যাচাই করুন" : "Check Audio";

  static String history(BuildContext context) =>
      _isBn(context) ? "ইতিহাস" : "History";

  static String about(BuildContext context) =>
      _isBn(context) ? "আমাদের সম্পর্কে" : "About";

  static String enterText(BuildContext context) =>
      _isBn(context) ? "এখানে টেক্সট লিখুন..." : "Enter Text here....";

  static String checkAi(BuildContext context) =>
      _isBn(context) ? "এআই যাচাই করুন" : "Check Ai";
  
  static String everydayChecker(BuildContext context) =>
    _isBn(context)
        ? "আপনার প্রতিদিনের\nএআই যাচাই সঙ্গী :)"
        : "Your Everyday\nAi Checker :)";

  static String tutorial(BuildContext context) =>
    _isBn(context) ? "টিউটোরিয়াল" : "Tutorial";

static String quickTutorials(BuildContext context) =>
    _isBn(context) ? "দ্রুত নির্দেশিকা" : "Quick Tutorials";

static String tutorialDescription(BuildContext context) =>
    _isBn(context)
        ? "যে ডিটেক্টরের টিউটোরিয়াল দেখতে চান সেটি নির্বাচন করুন।"
        : "Choose a detector tutorial.";

static String textTutorial(BuildContext context) =>
    _isBn(context)
        ? "টেক্সট ডিটেক্টর টিউটোরিয়াল"
        : "Text Detector Tutorial";

static String imageTutorial(BuildContext context) =>
    _isBn(context)
        ? "ইমেজ ডিটেক্টর টিউটোরিয়াল"
        : "Image Detector Tutorial";

static String videoTutorial(BuildContext context) =>
    _isBn(context)
        ? "ভিডিও ডিটেক্টর টিউটোরিয়াল"
        : "Video Detector Tutorial";

static String audioTutorial(BuildContext context) =>
    _isBn(context)
        ? "অডিও ডিটেক্টর টিউটোরিয়াল"
        : "Audio Detector Tutorial";

  static bool _isBn(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'bn';
}