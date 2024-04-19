import 'package:flutter/material.dart';

class IncomingChallengePage extends StatelessWidget {
  const IncomingChallengePage({super.key, required this.changeState});
  final Function changeState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Waiting for opponent to accept..."),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("Reject")),
                ElevatedButton(onPressed: () {}, child: const Text("Accept"))
              ],
            ),
            const SizedBox(
              height: 300,
            )
          ],
        ),
      ),
    );
  }
}
