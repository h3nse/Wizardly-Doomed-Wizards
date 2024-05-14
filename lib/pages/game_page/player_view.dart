import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/controllers/player_controllers.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';

class PlayerView extends StatefulWidget {
  const PlayerView(
      {super.key,
      required this.name,
      required this.onTap,
      required this.playerController,
      required this.disableOnTap});

  final String name;
  final Function onTap;
  final PlayerController playerController;
  final bool disableOnTap;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => GestureDetector(
              onTap: () {
                if (widget.disableOnTap) return;
                widget.onTap();
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ...[
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getTemperatureColor(),
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        child: Center(
                          child: Text(widget.name),
                        ),
                      ),
                    ),
                  ],
                  ..._buildOverlayWidgets()
                ],
              ),
            ),
          ),
          Obx(() => Text(widget.playerController.health.toString()))
        ],
      ),
    );
  }

  Color _getTemperatureColor() {
    double normalizedValue =
        widget.playerController.temperature / temperatureLimitMax;

    if (normalizedValue <= 0) {
      return Color.lerp(null, Colors.blue, normalizedValue.abs())!;
    } else {
      return Color.lerp(null, Colors.red, normalizedValue)!;
    }
  }

  List<Widget> _buildOverlayWidgets() {
    List<Widget> overlays = [];

    if (widget.playerController.isFrozen) {
      overlays.add(SizedBox(
          height: 110,
          width: 110,
          child: Image.asset('assets/PlayerFrozenOverlay.png')));
    }

    if (widget.playerController.isCharged) {
      overlays.add(SizedBox(
          height: 110,
          width: 110,
          child: Image.asset('assets/PlayerChargedOverlay.png')));
    }

    if (widget.playerController.isOvercharged) {
      overlays.add(SizedBox(
          height: 110,
          width: 110,
          child: Image.asset('assets/PlayerOverchargedOverlay.png')));
    }

    if (widget.playerController.isWet) {
      overlays.add(SizedBox(
          height: 110,
          width: 110,
          child: Image.asset('assets/PlayerWetOverlay.png')));
    }

    return overlays;
  }
}
