import 'dart:async';
import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/controllers/player_controllers.dart';

const int lightningInAPotionID = 7;
const int overchargeID = 8;

class PotionFactory {
  static Potion getPotionById(int id) {
    switch (id) {
      case 0:
        return DefaultPotion();
      case 1:
        return PotionOfHealing();
      case 2:
        return ExplodingPotion();
      case 3:
        return PotionOfHeat();
      case 4:
        return PotionOfCold();
      case 5:
        return PotionOfDarkSkies();
      case 6:
        return PotionOfThunder();
      case lightningInAPotionID:
        return LightningInAPotion();
      case overchargeID:
        return Overcharge();
      case 9:
        return PotionOfRegeneration();
      default:
        throw Exception("Invalid Potion ID: $id");
    }
  }
}

abstract class Potion {
  final String name;
  final YouController youController = Get.put(YouController());

  Potion(this.name);

  void applyPotion();
}

class DefaultPotion extends Potion {
  DefaultPotion() : super("Default Potion");

  @override
  void applyPotion() {}
}

class PotionOfHealing extends Potion {
  PotionOfHealing() : super("Potion of Healing");

  @override
  void applyPotion() {
    youController.heal(5);
  }
}

class ExplodingPotion extends Potion {
  ExplodingPotion() : super("Exploding Potion");

  @override
  void applyPotion() {
    youController.takeDamage(5);
  }
}

class PotionOfHeat extends Potion {
  PotionOfHeat() : super("Potion of Heat");

  @override
  void applyPotion() {
    youController.temperature += 15;
  }
}

class PotionOfCold extends Potion {
  PotionOfCold() : super("Potion of Cold");

  @override
  void applyPotion() {
    youController.cool(15);
  }
}

class PotionOfDarkSkies extends Potion {
  PotionOfDarkSkies() : super("Potion of Dark Skies");

  final int secondsPerTick = 1;
  final int ticks = 4;

  @override
  void applyPotion() {
    youController.hasRainCloud = true;
    Timer.periodic(Duration(seconds: secondsPerTick), (timer) {
      youController.isWet = true;

      if (timer.tick == ticks) {
        timer.cancel();
        youController.hasRainCloud = false;
      }
    });
  }
}

class PotionOfThunder extends Potion {
  PotionOfThunder() : super("Potion of Thunder");

  @override
  void applyPotion() {
    youController.takeDamage(10);
    youController.isCharged = true;
  }
}

class LightningInAPotion extends Potion {
  LightningInAPotion() : super("Lightning in a Potion");

  @override
  void applyPotion() {
    youController.isCharged = true;
  }
}

class Overcharge extends Potion {
  Overcharge() : super("Overcharge");

  @override
  void applyPotion() {
    youController.takeDamage(30);
    youController.isCharged = true;
  }
}

class PotionOfRegeneration extends Potion {
  PotionOfRegeneration() : super("Potion of Regeneration");

  final int secondsPerTick = 1;
  final int ticks = 20;

  @override
  void applyPotion() {
    Timer.periodic(
      Duration(seconds: secondsPerTick),
      (timer) {
        youController.heal(1);

        if (timer.tick == ticks) {
          timer.cancel();
        }
      },
    );
  }
}
