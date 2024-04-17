import 'package:flutter/material.dart';

class FindOpponentPage extends StatelessWidget {
  FindOpponentPage({super.key});
  final TextEditingController inputFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Hello PlayerName!"),
            TextFormField(
              controller: inputFieldController,
              decoration:
                  const InputDecoration(labelText: ("Enter an opponents name")),
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text("Challenge Opponent")),
            const SizedBox(
              height: 300,
            )
          ],
        ),
      ),
    );
  }
}
