import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/feature/provider/app_provider.dart';
import 'package:mivo/feature/screen/widgets/github_activity_line.dart';
import 'package:provider/provider.dart';

/// Dark card with a light tint of the accent: the name stays readable
/// (light text on a dark surface) and the accent still shows, so a hot
/// reload visibly re-tints it.
class WebsiteHeader extends StatelessWidget {
  const WebsiteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Consumer<AppProvider>(
      builder: (context, data, _) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(
                  scheme.primary.withValues(alpha: 0.30),
                  scheme.surface,
                ),
                scheme.surface,
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            // Uniform border: a one-sided border can't be combined with
            // borderRadius.
            border: Border.all(
              color: scheme.primary.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primary.withValues(alpha: 0.22),
                  border: Border.all(
                    color: scheme.secondary.withValues(alpha: 0.7),
                    width: 1.5,
                  ),
                ),
                child: Icon(Icons.person, color: scheme.onSurface, size: 26),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.personalInfo.name,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      data.personalInfo.job,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const GitHubActivityLine(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
