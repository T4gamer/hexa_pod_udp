import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexapod_udp/udp_service.dart';

class HexaPodControlPage extends StatefulWidget {
  const HexaPodControlPage({super.key});

  @override
  State<HexaPodControlPage> createState() => _HexaPodControlPageState();
}

class _HexaPodControlPageState extends State<HexaPodControlPage> {
  bool isForwardPressed = false;
  bool isBackwardPressed = false;
  bool isLeftPressed = false;
  bool isRightPressed = false;
  bool isRightUpPressed = false;
  bool isRightDownPressed = false;
  bool isLeftUpPressed = false;
  bool isLeftDownPressed = false;
  bool isStandbyPressed = false;

  bool rotateLeft = false;
  bool rotateRight = false;
  bool turboOn = false;
  late StreamSubscription<String> _dataSubscription;

  @override
  void dispose() {
    // _dataSubscription.cancel();
    UDPService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                StreamBuilder<String>(
                  stream: UDPService().receiveDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final receivedMessage = snapshot.data!;
                      final parts = receivedMessage.split(' ');
                      String humidity = '';
                      String temperature = '';
                      String airQuality = ''; // Changed variable name

                      for (final part in parts) {
                        if (part.startsWith('Humidity:')) {
                          humidity = part.split(':')[1];
                        } else if (part.startsWith('Temperature:')) {
                          temperature = part.split(':')[1];
                        } else if (part.startsWith('Gas:')) {
                          airQuality =
                              part.split(
                                ':',
                              )[1]; // Assigning to the new variable
                        }
                      }

                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Humidity: $humidity',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Temperature: $temperature °C',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Air Quality: $airQuality ppm',
                              // Changed the label here
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Text('Waiting for data...');
                    }
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFunctionButton(
                  'rotate Left',
                  Icons.rotate_left,
                  rotateLeft,
                  () {
                    UDPService().sendCommand(UDPService.CMD_TURNLEFT);
                    setState(() => rotateLeft = true);
                  },
                  onReleased: () {
                    UDPService().sendCommand(UDPService.CMD_STANDBY);
                    setState(() => rotateLeft = false);
                  },
                ),
                _buildFunctionButton(
                  'rotate Right',
                  Icons.rotate_right,
                  rotateRight,
                  () {
                    UDPService().sendCommand(UDPService.CMD_TURNRIGHT);
                    setState(() => rotateRight = true);
                  },
                  onReleased: () {
                    UDPService().sendCommand(UDPService.CMD_STANDBY);
                    setState(() => rotateRight = false);
                  },
                ),
                _buildFunctionButton('Turbo', Icons.bolt, turboOn, () {
                  setState(() => turboOn = !turboOn);
                }),
                _buildFunctionButton('twist', Icons.settings, false, () {
                  UDPService().sendCommand(UDPService.CMD_TWIST);
                }),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rotate_left,
                      color: rotateLeft ? Colors.yellow : Colors.grey,
                      size: 30,
                    ),
                    Icon(
                      Icons.rotate_right,
                      color: rotateRight ? Colors.yellow : Colors.grey,
                      size: 30,
                    ),
                    Icon(
                      Icons.bolt,
                      color: turboOn ? Colors.orange : Colors.grey,
                      size: 30,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildImageControlButton(
                          "images/left_up_arrow.png",
                          isLeftUpPressed,
                          () {
                            UDPService().sendCommand(UDPService.CMD_WALK_L45);
                            setState(() {
                              isLeftUpPressed = true;
                            });
                          },
                          () {
                            UDPService().sendCommand(UDPService.CMD_STANDBY);
                            setState(() {
                              isLeftUpPressed = false;
                            });
                          },
                        ),
                        _buildControlButton(
                          Icons.arrow_upward,
                          isForwardPressed,
                          () {
                            if (turboOn) {
                              UDPService().sendCommand(
                                UDPService.CMD_FASTFORWARD,
                              );
                            } else {
                              UDPService().sendCommand(UDPService.CMD_WALK_0);
                            }
                            setState(() => isForwardPressed = true);
                          },
                          () {
                            UDPService().sendCommand(UDPService.CMD_STANDBY);
                            setState(() => isForwardPressed = false);
                          },
                        ),
                        _buildImageControlButton(
                          "images/right_up_arrow.png",
                          isRightUpPressed,
                          () {
                            UDPService().sendCommand(UDPService.CMD_WALK_R45);
                            setState(() {
                              isRightUpPressed = true;
                            });
                          },
                          () {
                            UDPService().sendCommand(UDPService.CMD_STANDBY);
                            setState(() {
                              isRightUpPressed = false;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildControlButton(
                          Icons.arrow_back,
                          isLeftPressed,
                          () {
                            UDPService().sendCommand(UDPService.CMD_WALK_L90);
                            setState(() => isLeftPressed = true);
                          },
                          () {
                            UDPService().sendCommand(UDPService.CMD_STANDBY);
                            setState(() => isLeftPressed = false);
                          },
                        ),
                        _buildControlButton(
                          Icons.stop,
                          isStandbyPressed,
                          () {
                            UDPService().sendCommand(UDPService.CMD_STANDBY);
                            setState(() => isStandbyPressed = true);
                          },
                          () {
                            setState(() => isStandbyPressed = false);
                          },
                        ),
                        _buildControlButton(
                          Icons.arrow_forward,
                          isRightPressed,
                          () {
                            UDPService().sendCommand(UDPService.CMD_WALK_R90);
                            setState(() => isRightPressed = true);
                          },
                          () {
                            UDPService().sendCommand(UDPService.CMD_STANDBY);
                            setState(() => isRightPressed = false);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildImageControlButton(
                          "images/left_down_arrow.png",
                          isLeftDownPressed,
                          () {
                            UDPService().sendCommand(UDPService.CMD_WALK_L135);
                            setState(() {
                              isLeftDownPressed = true;
                            });
                          },
                          () {
                            UDPService().sendCommand(UDPService.CMD_STANDBY);
                            setState(() {
                              isLeftDownPressed = false;
                            });
                          },
                        ),
                        _buildControlButton(
                          Icons.arrow_downward,
                          isBackwardPressed,
                          () {
                            if (turboOn) {
                              UDPService().sendCommand(
                                UDPService.CMD_FASTBACKWARD,
                              );
                            } else {
                              UDPService().sendCommand(UDPService.CMD_WALK_180);
                            }
                            setState(() => isBackwardPressed = true);
                          },
                          () {
                            UDPService().sendCommand(UDPService.CMD_STANDBY);
                            setState(() => isBackwardPressed = false);
                          },
                        ),
                        _buildImageControlButton(
                          "images/right_down_arrow.png",
                          isRightDownPressed,
                          () {
                            UDPService().sendCommand(UDPService.CMD_WALK_R135);
                            setState(() {
                              isRightDownPressed = true;
                            });
                          },
                          () {
                            UDPService().sendCommand(UDPService.CMD_STANDBY);
                            setState(() {
                              isRightDownPressed = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    IconData icon,
    bool isPressed,
    Function onPressed,
    Function onReleased,
  ) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      onTapUp: (_) => onReleased(),
      onTapCancel: () => onReleased(),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isPressed ? Colors.blue : Colors.blue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade800, width: 2),
          boxShadow: [
            if (isPressed)
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Icon(icon, size: 36, color: Colors.white),
      ),
    );
  }

  Widget _buildFunctionButton(
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onPressed, {
    VoidCallback? onReleased,
  }) {
    return Flexible(
      flex: 2,
      child: GestureDetector(
        onTapDown: (_) => onPressed(),
        onTapUp: (_) => onReleased?.call(),
        onTapCancel: onReleased?.call,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: isActive ? Colors.blue : Colors.grey[600],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageControlButton(
    String imagePath,
    bool isPressed,
    Function onPressed,
    Function onReleased,
  ) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      onTapUp: (_) => onReleased(),
      onTapCancel: () => onReleased(),
      child: Container(
        margin: const EdgeInsets.all(6),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color:
              isPressed
                  ? Colors.blue.withOpacity(0.7)
                  : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPressed ? Colors.blue.shade800 : Colors.grey.shade600,
            width: 2,
          ),
          boxShadow: [
            if (isPressed)
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            imagePath,
            color: isPressed ? Colors.white : Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
