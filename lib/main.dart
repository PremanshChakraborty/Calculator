import 'package:calculator/pages/history.dart';
import 'package:calculator/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:calculator/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ThemeMode theme=await gettheme();
  runApp(MyApp(theme: theme,));
}

class MyApp extends StatefulWidget {
  ThemeMode theme;
  MyApp({super.key,required this.theme});

  @override
  State<MyApp> createState() => _MyAppState(theme: theme);
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode theme;
  _MyAppState({required this.theme});
  Future<void> changeTheme(ThemeMode themeMode) async{
    setState(() {
      theme=themeMode;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String th= theme==ThemeMode.dark?'dark':'light';
    pref.setString('theme',th);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'home':(context)=> Home(),
        'history':(context)=> History(),
      },
      home: Splash(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,brightness: Brightness.light),
          textTheme:TextTheme(
              displaySmall: TextStyle(
                  fontFamily: 'Rubik'
              ),
              titleLarge: TextStyle(
                  fontFamily: 'Rubik',
                fontSize: 30
              ),
              titleMedium: TextStyle(
                  fontFamily: 'Rubik',
                fontSize: 25
              ),
          )
      ),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,brightness: Brightness.dark),
              textTheme:TextTheme(
                displaySmall: TextStyle(
                  fontFamily: 'Rubik'
                ),
                  titleLarge: TextStyle(
                      fontFamily: 'Rubik',
                    fontSize: 30
                  ),
                  titleMedium: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 25
                  )


              )
      ),
      themeMode:theme
      ,

    );
  }
}
Future<ThemeMode> gettheme() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? th= pref.getString('theme');
  if(th=='light') return ThemeMode.light;
  else if(th=='dark') return ThemeMode.dark;
  else return ThemeMode.system;
}
