import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_website_v2/core/app/app_theme.dart';
import 'package:personal_website_v2/feature/provider/ai_provider.dart';
import 'package:personal_website_v2/feature/provider/app_provider.dart';
import 'package:personal_website_v2/feature/screen/mobile_screen.dart';
import 'package:personal_website_v2/feature/screen/website_screen.dart';
import 'package:personal_website_v2/feature/supabase_data/s_config.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MivoAiProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Personal Website',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            home: kIsWeb ? const WebsiteScreen() : const QrCreate(),
          );
        },
      ),
    );
  }
}
