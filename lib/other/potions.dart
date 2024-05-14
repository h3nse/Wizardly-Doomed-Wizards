import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/controllers/player_controllers.dart';

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
    youController.takePhysicalDamage(5);
  }
}

class PotionOfHeat extends Potion {
  PotionOfHeat() : super("Potion of Heat");

  @override
  void applyPotion() {
    youController.temperature += 15;
    youController.sendUpdates();
  }
}

class PotionOfCold extends Potion {
  PotionOfCold() : super("Potion of Cold");

  @override
  void applyPotion() {
    youController.cool(15);
  }
}

class PotionOfRegeneration extends Potion {
  PotionOfRegeneration() : super("Potion of Regeneration");

  @override
  void applyPotion() {
    // final regenEffect = Regenerating();

    // final regenDuration = Constants.potionEffectValues[id]!['Duration'];
    // final durationTimer = Timer(Duration(seconds: regenDuration + 1),
    //     () => gameManager.removePlayerEffect(regenEffect.name));

    // regenEffect.setGameManager(gameManager);
    // regenEffect.setDurationTimer(durationTimer);
    // gameManager.addPlayerEffect(regenEffect);
  }
}

class PotionOfDelayedExplosion extends Potion {
  PotionOfDelayedExplosion() : super("Potion of Delayed Explosion");

  @override
  void applyPotion() {
    // final aboutToExplodeEffect = AboutToExplode();
    // final explosionDelay = Constants.potionEffectValues[id]!['ExplosionDelay'];
    // final damage = Constants.potionEffectValues[id]!['Damage'];

    // final timer = Timer(Duration(seconds: explosionDelay), () {
    //   gameManager.takeDamage(damage);
    //   gameManager.removePlayerEffect(aboutToExplodeEffect.name);
    // });

    // aboutToExplodeEffect.setDurationTimer(timer);
    // gameManager.addPlayerEffect(aboutToExplodeEffect);
  }
}

class PotionOfFlames extends Potion {
  PotionOfFlames() : super("Potion of Flames");

  @override
  void applyPotion() {
    // final burningEffect = Burning();

    // final burnDuration = Constants.potionEffectValues[id]!['Duration'];
    // final durationTimer = Timer(Duration(seconds: burnDuration + 1),
    //     () => gameManager.removePlayerEffect(burningEffect.name));

    // burningEffect.setGameManager(gameManager);
    // burningEffect.setDurationTimer(durationTimer);
    // gameManager.addPlayerEffect(burningEffect);
  }
}

class PotionOfIncendiary extends Potion {
  PotionOfIncendiary() : super("Potion of Incendiary");

  @override
  void applyPotion() {
    // gameManager.takeDamage(Constants.potionEffectValues[id]!['Damage']);
    // final burningEffect = Burning();
    // final burnDuration = Constants.potionEffectValues[id]!['Duration'];

    // final durationTImer = Timer(Duration(seconds: burnDuration + 1),
    //     () => gameManager.removePlayerEffect(burningEffect.name));

    // burningEffect.setGameManager(gameManager);
    // burningEffect.setDurationTimer(durationTImer);
    // gameManager.addPlayerEffect(burningEffect);
  }
}
