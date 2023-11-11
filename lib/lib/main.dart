import 'package:chitchat/lib/providers/file_controller.dart';
import 'package:chitchat/lib/providers/image_controller.dart';
import 'package:chitchat/lib/providers/loading_controller.dart';
import 'package:chitchat/lib/providers/post_controller.dart';
import 'package:chitchat/lib/providers/user_controller.dart';
import 'package:chitchat/lib/screens/splash/splash_screen.dart';
import 'package:chitchat/lib/themes/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageController()),
        ChangeNotifierProvider(create: (_) => LoadingController()),
        ChangeNotifierProvider(create: (_) => FileController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => PostController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: AppColors.primaryBlack,
            scaffoldBackgroundColor: Colors.black12,
            appBarTheme: AppBarTheme(
                backgroundColor: AppColors.primaryBlack,
                centerTitle: true,
                titleTextStyle: GoogleFonts.acme(
                  fontSize: 18,
                  color: AppColors.primaryWhite,
                ))),

        // home: VideoLinkScreen(),
        home: const SplashScreen(),
      ),
    );
  }
}
