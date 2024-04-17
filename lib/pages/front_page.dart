import 'package:flutter/material.dart';
import 'package:wizardly_fucked_wizards/pages/find_opponent_page.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Text(
                "Wizardly Doomed Wizards",
                style: TextStyle(fontSize: 25),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindOpponentPage()));
              },
              child: const Text("PLAY"),
            )
          ],
        ),
      ),
    );
  }
}
