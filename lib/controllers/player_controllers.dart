import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';

class PlayerController extends GetxController {
  late RealtimeChannel _broadcastChannel;
  final RxInt _health = startingHealth.obs;

  int get health => _health.value;

  set health(int value) {
    if (value < 0) value = 0;
    if (value > startingHealth) value = startingHealth;
    _health.value = value;
  }

  void setBroadcastChannel(RealtimeChannel broadcastChannel) {
    _broadcastChannel = broadcastChannel;
  }

  void sendUpdates() {
    _broadcastChannel.sendBroadcastMessage(
        event: 'opponent_update', payload: {'health': _health.value});
  }
}

class YouController extends PlayerController {}

class OpponentController extends PlayerController {}
