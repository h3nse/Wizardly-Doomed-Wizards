import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/controllers/ingredient_controller.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';
import 'package:wizardly_fucked_wizards/other/id_to_ingredient.dart';
import 'package:wizardly_fucked_wizards/pages/scanner/QR_scanner.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Player(text: "You"), Player(text: "Opponent")],
            ),
            Potion(),
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

class Potion extends StatefulWidget {
  const Potion({super.key});

  @override
  State<Potion> createState() => _PotionState();
}

class _PotionState extends State<Potion> {
  IngredientController ingredientController = Get.put(IngredientController());
  PotionState _potionState = PotionState.empty;

  @override
  Widget build(BuildContext context) {
    late Widget potionView;
    switch (_potionState) {
      case PotionState.empty:
        potionView = EmptyPotion(
          changePotionState: changePotionState,
        );
        break;
      case PotionState.mixing:
        potionView = const MixingPotion();
        break;
      case PotionState.finished:
        potionView = const FinishedPotion();
    }
    return Column(
      children: [
        potionView,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () async {
                  if (_potionState != PotionState.empty) {
                    return;
                  }
                  String result = await Get.to(const QRScanner());
                  if (result == '') return;
                  final ingredientId = int.tryParse(result);
                  ingredientController.ingredients.add(ingredientId);
                },
                child: const Text("Scan Ingredient")),
            ElevatedButton(
                onPressed: () {}, child: const Text("Pour Potion Out"))
          ],
        )
      ],
    );
  }

  void changePotionState(PotionState potionState) {
    setState(() {
      _potionState = potionState;
    });
  }
}

class EmptyPotion extends StatefulWidget {
  const EmptyPotion({super.key, required this.changePotionState});
  final Function changePotionState;

  @override
  State<EmptyPotion> createState() => _EmptyPotionState();
}

class _EmptyPotionState extends State<EmptyPotion> {
  IngredientController ingredientController = Get.put(IngredientController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.changePotionState(PotionState.mixing);
      },
      child: SizedBox(
        height: 200,
        width: 200,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: Theme.of(context).colorScheme.primary),
          ),
          child: Center(
            child: Column(
              children: [
                const Text('Empty Potion'),
                Obx(() => ListView.builder(
                      shrinkWrap: true,
                      itemCount: ingredientController.ingredients.length,
                      itemBuilder: (context, index) => Text(idToIngredient[
                          ingredientController.ingredients[index]]!),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MixingPotion extends StatelessWidget {
  const MixingPotion({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FinishedPotion extends StatelessWidget {
  const FinishedPotion({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
