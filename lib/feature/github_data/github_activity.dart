import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

/// Mahmoud's latest public push on GitHub.
class GitHubPush {
  /// Repo name without the owner, e.g. "personal_website_v2".
  final String repo;
  final String repoUrl;
  final DateTime pushedAt;

  const GitHubPush({
    required this.repo,
    required this.repoUrl,
    required this.pushedAt,
  });

  /// True when the push happened within [window] (default: 3 days).
  bool isRecent({Duration window = const Duration(days: 3)}) {
    final age = DateTime.now().toUtc().difference(pushedAt.toUtc());
    return !age.isNegative && age <= window;
  }
}

/// Reads public activity from the GitHub REST API (no token needed; the
/// browser calls it directly, 60 requests/hour per visitor IP).
class GitHubActivity {
  GitHubActivity._();

  static const String user = 'MahmoudReda0o0';

  static GitHubPush? _cached;
  static DateTime? _cachedAt;

  /// Latest PushEvent, or null if none, rate-limited, or offline.
  static Future<GitHubPush?> latestPush() async {
    if (_cachedAt != null &&
        DateTime.now().difference(_cachedAt!) < const Duration(minutes: 5)) {
      return _cached;
    }
    try {
      final uri = Uri.https('api.github.com', '/users/$user/events/public', {
        'per_page': '30',
      });
      final res = await http
          .get(uri, headers: const {'Accept': 'application/vnd.github+json'})
          .timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) {
        log('github_events_status: ${res.statusCode}');
        return null;
      }
      final events = jsonDecode(res.body);
      if (events is! List) return null;

      GitHubPush? push;
      for (final e in events) {
        if (e is! Map || e['type'] != 'PushEvent') continue;
        final fullName = (e['repo'] as Map?)?['name'] as String?;
        final created = DateTime.tryParse(e['created_at'] as String? ?? '');
        if (fullName == null || created == null) continue;
        push = GitHubPush(
          repo: fullName.split('/').last,
          repoUrl: 'https://github.com/$fullName',
          pushedAt: created,
        );
        break; // Events are newest first.
      }
      _cached = push;
      _cachedAt = DateTime.now();
      return push;
    } catch (e) {
      log('github_events_error: $e');
      return null;
    }
  }

  /// "2h ago" / "من ساعتين" style text for [time].
  static String timeAgo(DateTime time, {required bool arabic}) {
    final d = DateTime.now().toUtc().difference(time.toUtc());
    final m = d.inMinutes, h = d.inHours, days = d.inDays;

    if (!arabic) {
      if (m < 1) return 'just now';
      if (m < 60) return '${m}m ago';
      if (h < 24) return '${h}h ago';
      if (days < 2) return 'yesterday';
      return '$days days ago';
    }

    String count(int n, String one, String two, String few, String many) {
      if (n == 1) return one;
      if (n == 2) return two;
      if (n <= 10) return '$n $few';
      return '$n $many';
    }

    if (m < 1) return 'دلوقتي';
    if (m < 60) return 'من ${count(m, 'دقيقة', 'دقيقتين', 'دقايق', 'دقيقة')}';
    if (h < 24) return 'من ${count(h, 'ساعة', 'ساعتين', 'ساعات', 'ساعة')}';
    if (days < 2) return 'امبارح';
    return 'من ${count(days, 'يوم', 'يومين', 'أيام', 'يوم')}';
  }
}
