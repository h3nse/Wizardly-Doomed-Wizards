import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';

class PlayerController extends GetxController {
  late RealtimeChannel _broadcastChannel;
  late Function _onDeath;
  final RxInt _health = startingHealth.obs;

  int get health => _health.value;
}

class YouController extends PlayerController {
  set health(int value) {
    if (value < 0) {
      value = 0;
      _onDeath();
    }
    if (value > startingHealth) value = startingHealth;
    _health.value = value;
  }

  void setBroadcastChannel(RealtimeChannel broadcastChannel) {
    _broadcastChannel = broadcastChannel;
  }

  void setOnDeath(Function onDeath) {
    _onDeath = onDeath;
  }

  void sendUpdates() {
    _broadcastChannel.sendBroadcastMessage(
        event: 'opponent_update', payload: {'health': _health.value});
  }
}

class OpponentController extends PlayerController {
  set health(int value) {
    _health.value = value;
  }
}
