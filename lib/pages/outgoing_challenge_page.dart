import 'package:flutter/material.dart';

class OutgoingChallengePage extends StatelessWidget {
  const OutgoingChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Waiting for opponent to accept..."),
            ElevatedButton(onPressed: () {}, child: const Text("Cancel")),
            const SizedBox(
              height: 300,
            )
          ],
        ),
      ),
    );
  }
}
