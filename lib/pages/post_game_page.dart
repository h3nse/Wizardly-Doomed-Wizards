import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostGamePage extends StatelessWidget {
  const PostGamePage({super.key, required this.winnerName});
  final String winnerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('The winner is $winnerName!'),
            const SizedBox(height: 200),
            ElevatedButton(
                onPressed: () {
                  Get.snackbar('No', '');
                },
                child: const Text('Play Again'))
          ],
        ),
      ),
    );
  }
}
