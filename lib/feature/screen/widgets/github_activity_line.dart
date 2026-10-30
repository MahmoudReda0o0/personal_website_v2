import 'package:flutter/material.dart';
import 'package:mivo/feature/github_data/github_activity.dart';
import 'package:mivo/feature/provider/ai_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// "● Pushed to personal_website_v2 · 2h ago" under the name in the header.
/// Shows only if the latest public push is at most 3 days old; otherwise
/// (or if GitHub can't be reached) nothing is shown at all.
class GitHubActivityLine extends StatefulWidget {
  const GitHubActivityLine({super.key});

  @override
  State<GitHubActivityLine> createState() => _GitHubActivityLineState();
}

class _GitHubActivityLineState extends State<GitHubActivityLine>
    with SingleTickerProviderStateMixin {
  GitHubPush? _push;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    GitHubActivity.latestPush().then((push) {
      if (!mounted || push == null || !push.isRecent()) return;
      setState(() => _push = push);
      _pulse.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final push = _push;
    if (push == null) return const SizedBox.shrink();

    final arabic = context.select<MivoAiProvider, bool>(
      (ai) => ai.visitorLang == 'ar',
    );
    final ago = GitHubActivity.timeAgo(push.pushedAt, arabic: arabic);
    final text = arabic
        ? 'رفع كود على ${push.repo} · $ago'
        : 'Pushed to ${push.repo} · $ago';

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: InkWell(
        onTap: () => launchUrl(
          Uri.parse(push.repoUrl),
          mode: LaunchMode.externalApplication,
        ),
        borderRadius: BorderRadius.circular(6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: Tween<double>(begin: 0.45, end: 1).animate(_pulse),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF2EE56B),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
