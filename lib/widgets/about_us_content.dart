import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonInfo {
  final String name;
  final String title;
  final String? photoAsset; 
  final String? githubUrl;
  final String? linkedinUrl;
  final String? facebookUrl;

  const PersonInfo({
    required this.name,
    required this.title,
    this.photoAsset,
    this.githubUrl,
    this.linkedinUrl,
    this.facebookUrl,
  });
}

class AboutUsContent extends StatelessWidget {
  const AboutUsContent({super.key});

  Future<void> _openUrl(BuildContext context, String? url) async {
    if (url == null || url.trim().isEmpty) return;

    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Couldn't open link")));
    }
  }

  Widget _socialIcons(BuildContext context, PersonInfo p) {
    final theme = Theme.of(context);

    Widget iconButton(IconData icon, String? url) {
      final enabled = url != null && url.trim().isNotEmpty;
      return IconButton(
        onPressed: enabled ? () => _openUrl(context, url) : null,
        icon: Icon(icon),
        iconSize: 18,
        color:
            enabled
                ? theme.colorScheme.onSurface.withOpacity(0.8)
                : theme.colorScheme.onSurface.withOpacity(0.25),
        tooltip: enabled ? url : "No link",
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconButton(Icons.code_rounded, p.githubUrl),
        iconButton(Icons.work, p.linkedinUrl),
        iconButton(Icons.facebook_rounded, p.facebookUrl),
      ],
    );
  }

  Widget _personCard(
    BuildContext context,
    PersonInfo p, {
    bool isSupervisor = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final avatar =
        (p.photoAsset != null && p.photoAsset!.trim().isNotEmpty)
            ? CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(p.photoAsset!.trim()),
            )
            : CircleAvatar(radius: 28, child: Icon(Icons.person_rounded));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        
        color:
            isSupervisor
                ? const Color(0xFFB8860B).withOpacity(isDark ? 0.35 : 0.55)
                : theme.colorScheme.surface.withOpacity(isDark ? 0.10 : 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(isDark ? 0.10 : 0.06),
        ),
      ),
      child: Column(
        children: [
          avatar,
          const SizedBox(height: 10),
          Text(
            p.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            p.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _socialIcons(context, p),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<PersonInfo> people) {
    final theme = Theme.of(context);
    final isSupervisorSection = title.toLowerCase().contains("supervisor");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        ...people.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _personCard(context, p, isSupervisor: isSupervisorSection),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    const developers = <PersonInfo>[
      PersonInfo(
        name: "Mahbub Muhon",
        title: "CSE Student | Leading University",
        photoAsset: "assets/images/muhon.jpeg",
        githubUrl: "https://github.com/Muhon33",
        linkedinUrl: "https://www.linkedin.com/in/mahbub-muhon/",
        facebookUrl: "https://www.facebook.com/mahbuburrahman.muhon",
      ),
      PersonInfo(
        name: "Alamin Hossain",
        title: "CSE Student | Leading University",
        photoAsset: "assets/images/alamin.jpeg",
        githubUrl: "https://github.com/",
        linkedinUrl: "https://www.linkedin.com/",
        facebookUrl: "https://www.facebook.com/",
      ),
      PersonInfo(
        name: "Mahdi Hassan",
        title: "CSE Student | Leading University",
        photoAsset: "assets/images/mahdi.jpeg",
        githubUrl: "https://github.com/mahdi1014",
        linkedinUrl: "https://www.linkedin.com/in/dmmahdibd/",
        facebookUrl: "https://www.facebook.com/mahdidmbd/",
      ),
    ];

    const supervisors = <PersonInfo>[
      PersonInfo(
        name: "Jalal Uddin Chowdhury",
        title: "Lecturer | Leading University",
        photoAsset: "assets/images/jac_sir.jpeg",
        githubUrl: "",
        linkedinUrl: "https://www.linkedin.com/",
        facebookUrl: "https://www.facebook.com/",
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About Us",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Meet the people behind CheckAi.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          _section(context, "Developers", developers),
          const SizedBox(height: 8),
          _section(context, "Supervisor", supervisors),
        ],
      ),
    );
  }
}
