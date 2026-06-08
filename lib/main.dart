import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MivoAiProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      builder: (context, child) {
        return ScreenUtilInit(
          designSize: const Size(414, 896),
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              home: kIsWeb ? const WebsiteScreen() : const QrCreate(),
            );
          },
        );
      },
    );
    // return ChangeNotifierProvider(
    //   create: (context) {
    //     AppProvider appProvider = AppProvider();
    //     // appProvider.fetchInitialData();
    //     return appProvider;
    //   },
    //   child:
    // );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(title: 'Todos', home: HomePage());
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final _future = Supabase.instance.client.from('todos').select();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: _future,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final todos = snapshot.data!;
//           return const QrCreate();
//           // return ListView.builder(
//           //   itemCount: todos.length,
//           //   itemBuilder: ((context, index) {
//           //     final todo = todos[index];
//           //     return ListTile(title: Text(todo['name']));
//           //   }),
//           // );
//         },
//       ),
//     );
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     // options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) {
//         AppProvider appProvider = AppProvider();
//         appProvider.fetchInitialData();
//         return appProvider;
//       },
//       child: ScreenUtilInit(
//         designSize: const Size(414, 896),
//         builder: (context, child) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'Flutter Demo',
//             theme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             ),
//             home: const QrCreate(),
//           );
//         },
//       ),
//     );
//   }
// }
