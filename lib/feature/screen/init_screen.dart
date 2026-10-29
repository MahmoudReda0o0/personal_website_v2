import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mivo/feature/provider/app_provider.dart';
import 'package:mivo/feature/screen/admin_login_screen.dart';
import 'package:mivo/feature/screen/mobile_screen.dart';
import 'package:mivo/feature/supabase_data/s_auth.dart';
import 'package:mivo/feature/screen/website_screen.dart';
import 'package:provider/provider.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AppProvider>().initializeApp();

      if (!mounted) return;

      // Web = the public website. Mobile = admin settings, behind sign-in.
      final Widget next = kIsWeb
          ? const WebsiteScreen()
          : SupabaseAuth.instance.isAdminSignedIn
          ? const QrCreate()
          : const AdminLoginScreen();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => next),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
