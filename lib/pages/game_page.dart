import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/pages/scanner/QR_scanner.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Player(text: "You"), Player(text: "Opponent")],
            ),
            const Potion(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      String? result = await Get.to(const QRScanner());
                      print(result);
                    },
                    child: const Text("Scan Ingredient")),
                ElevatedButton(
                    onPressed: () {}, child: const Text("Pour Potion Out"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Player extends StatelessWidget {
  const Player({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 100,
        width: 100,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: Theme.of(context).colorScheme.primary),
          ),
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

class Potion extends StatelessWidget {
  const Potion({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 200,
        width: 200,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: Theme.of(context).colorScheme.primary),
          ),
          child: const Center(
            child: Text("Potion"),
          ),
        ),
      ),
    );
  }
}
