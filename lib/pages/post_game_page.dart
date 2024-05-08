import 'package:flutter/material.dart';

class PostGamePage extends StatelessWidget {
  const PostGamePage({super.key, required this.winnerName});
  final String winnerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('The winner is $winnerName!'),
      ),
    );
  }
}
