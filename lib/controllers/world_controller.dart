import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';

class WorldController extends GetxController {
  late RealtimeChannel _broadcastChannel;
  final Rx<Weather> _currentWeather = Weather.clear.obs;

  Weather get currentWeather => _currentWeather.value;

  set currentWeather(Weather value) {
    _currentWeather.value = value;
    sendUpdates();
  }

  void setBroadcastChannel(RealtimeChannel broadcastChannel) {
    _broadcastChannel = broadcastChannel;
  }

  void sendUpdates() {
    _broadcastChannel.sendBroadcastMessage(
        event: 'weather_update',
        payload: {'currentWeatherIndex': _currentWeather.value.index});
  }

  void reset() {
    _currentWeather.value = Weather.clear;
  }
}
