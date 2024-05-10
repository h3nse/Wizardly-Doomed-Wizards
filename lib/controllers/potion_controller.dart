import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';

class PotionController extends GetxController {
  Rx<PotionState> potionState = PotionState.empty.obs;
  RxInt potionId = 0.obs;

  void reset() {
    potionId.value = 0;
    potionState.value = PotionState.empty;
  }
}
