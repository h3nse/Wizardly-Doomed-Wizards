import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';

class PlayerController extends GetxController {
  RxInt health = startingHealth.obs;
}

class YouController extends PlayerController {}

class OpponentController extends PlayerController {}
