import 'package:flutter/material.dart';

class IncomingChallengePage extends StatelessWidget {
  const IncomingChallengePage(
      {super.key, required this.changeState, required this.challengerName});
  final Function changeState;
  final String challengerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("You are being challenged by $challengerName"),
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
