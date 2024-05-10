import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';

class PlayerController extends GetxController {
  final RxInt _health = startingHealth.obs;
  final RxInt _temperature = 0.obs;
  final RxBool _isFrozen = false.obs;

  int get health => _health.value;
  int get temperature => _temperature.value;
  bool get isFrozen => _isFrozen.value;

  set health(int value) {
    _health.value = value;
  }

  set temperature(int value) {
    _temperature.value = value;
  }

  set isFrozen(bool value) {
    _isFrozen.value = value;
  }

  void reset() {
    _health.value = startingHealth;
    _temperature.value = 0;
    _isFrozen.value = false;
  }
}

class YouController extends PlayerController {
  late RealtimeChannel _broadcastChannel;
  late Function _onDeath;

  @override
  set health(int value) {
    if (value <= 0) {
      value = 0;
      _onDeath();
    }
    if (value >= startingHealth) value = startingHealth;
    _health.value = value;
  }

  @override
  set temperature(int value) {
    if (value <= temperatureLimitMin) value = temperatureLimitMin;
    if (value >= temperatureLimitMax) value = temperatureLimitMax;
    _temperature.value = value;
  }

  void setBroadcastChannel(RealtimeChannel broadcastChannel) {
    _broadcastChannel = broadcastChannel;
  }

  void setOnDeath(Function onDeath) {
    _onDeath = onDeath;
  }

  void sendUpdates() {
    _broadcastChannel.sendBroadcastMessage(event: 'opponent_update', payload: {
      'health': _health.value,
      'temperature': _temperature.value,
      'isFrozen': _isFrozen.value
    });
  }
}

class OpponentController extends PlayerController {}
