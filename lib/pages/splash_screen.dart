import 'package:flutter/material.dart';
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void fun() async{
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacementNamed(context,'home' );
  }
  @override
  void initState() {
    fun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Column(
        children: [
          Text('CALCULATOR',
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 1,
          ),),
          SizedBox(height: 8,),
          Text('Inspired by Samsung',
          style: TextStyle(
            letterSpacing: 2
          ),)
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    ));
  }
}
