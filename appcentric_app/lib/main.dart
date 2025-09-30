import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/paper_provider.dart';
import 'services/cache_service.dart';
import 'screens/login_screen.dart';
import 'screens/papers_list_screen.dart';
import 'screens/paper_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  await CacheService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PaperProvider()),
      ],
      child: MaterialApp(
        title: 'Appcentric Question Papers',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/papers': (context) => const PapersListScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/paper_detail') {
            final paperId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => PaperDetailScreen(paperId: paperId),
            );
          }
          return null;
        },
      ),
    );
  }
}
