import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/controllers/ingredient_controller.dart';
import 'package:wizardly_fucked_wizards/controllers/player_controllers.dart';
import 'package:wizardly_fucked_wizards/controllers/potion_controller.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';
import 'package:wizardly_fucked_wizards/other/convertions.dart';
import 'package:wizardly_fucked_wizards/other/potions.dart';
import 'package:wizardly_fucked_wizards/pages/scanner/QR_scanner.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:collection/collection.dart';

class PotionView extends StatefulWidget {
  const PotionView({super.key});

  @override
  State<PotionView> createState() => _PotionViewState();
}

class _PotionViewState extends State<PotionView> {
  IngredientController ingredientController = Get.put(IngredientController());
  PotionController potionController = Get.put(PotionController());
  YouController youController = Get.put(YouController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          late Widget potionView;
          switch (potionController.potionState.value) {
            case PotionState.empty:
              potionView = EmptyPotion(
                changePotionState: changePotionState,
              );
              break;
            case PotionState.mixing:
              potionView = MixingPotion(
                changePotionState: changePotionState,
              );
              break;
            case PotionState.finished:
              potionView = Obx(() =>
                  FinishedPotion(potionId: potionController.potionId.value));
          }
          return potionView;
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () async {
                  if (youController.isFrozen) return;
                  if (potionController.potionState.value != PotionState.empty) {
                    return;
                  }
                  String? result = await Get.to(const QRScanner());
                  if (result == '' || result == null) return;
                  final ingredientId = int.tryParse(result);
                  ingredientController.ingredients.add(ingredientId);
                },
                child: const Text("Scan Ingredient")),
            ElevatedButton(
                onPressed: () {
                  if (youController.isFrozen) return;
                  ingredientController.ingredients.clear();
                  potionController.potionId.value = 0;
                  changePotionState(PotionState.empty);
                },
                child: const Text("Pour Potion Out"))
          ],
        ),
      ],
    );
  }

  void changePotionState(PotionState potionState) {
    setState(() {
      potionController.potionState.value = potionState;
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
  YouController youController = Get.put(YouController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (youController.isFrozen) return;
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
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: ingredientController.ingredients.length,
                    itemBuilder: (context, index) => Text(idToIngredient[
                        ingredientController.ingredients[index]]!),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MixingPotion extends StatefulWidget {
  const MixingPotion({super.key, required this.changePotionState});
  final Function changePotionState;

  @override
  State<MixingPotion> createState() => _MixingPotionState();
}

class _MixingPotionState extends State<MixingPotion> {
  IngredientController ingredientController = Get.put(IngredientController());
  PotionController potionController = Get.put(PotionController());
  YouController youController = Get.put(YouController());
  late StreamSubscription accelerometerSubscription;
  RxInt mixLevel = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Obx(() => Image.asset(
            'assets/PotionMixState${(mixLevel.value / 2).floor()}.png')));
  }

  @override
  void initState() {
    accelerometerSubscription = userAccelerometerEventStream(
            samplingPeriod: const Duration(milliseconds: potionShakeIntervalMs))
        .listen((event) {
      if (youController.isFrozen) return;
      if (event.x.abs() > potionShakeThreshold ||
          event.y.abs() > potionShakeThreshold ||
          event.z.abs() > potionShakeThreshold) {
        setState(() {
          mixLevel.value = mixLevel.value + mixLevelIncrease;
        });
        if (mixLevel.value >= maxMixLevel) {
          createPotion();
          widget.changePotionState(PotionState.finished);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    accelerometerSubscription.cancel();
    super.dispose();
  }

  createPotion() {
    List ingredients = ingredientController.ingredients;
    ingredients.sort();
    Function eq = const ListEquality().equals;
    int potionId = 0;
    for (var i = 0; i < ingredientsToPotion.length; i++) {
      if (eq(ingredientsToPotion[i][1], ingredients)) {
        potionId = ingredientsToPotion[i][0];
        break;
      }
    }
    potionController.potionId.value = potionId;
    ingredientController.ingredients.clear();
  }
}

class FinishedPotion extends StatelessWidget {
  const FinishedPotion({super.key, required this.potionId});
  final int potionId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200, child: Text(PotionFactory.getPotionById(potionId).name));
  }
}
