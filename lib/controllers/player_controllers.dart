import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';

class PlayerController extends GetxController {
  late RealtimeChannel _broadcastChannel;
  RxInt health = startingHealth.obs;

  void setBroadcastChannel(RealtimeChannel broadcastChannel) {
    _broadcastChannel = broadcastChannel;
  }

  void sendUpdates() {
    _broadcastChannel.sendBroadcastMessage(
        event: 'opponent_update', payload: {'health': health.value});
  }
}

class YouController extends PlayerController {}

class OpponentController extends PlayerController {}
