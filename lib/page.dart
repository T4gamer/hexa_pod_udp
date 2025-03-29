import 'package:flutter/material.dart';

class RcCarControlPage extends StatefulWidget {
  const RcCarControlPage({super.key});

  @override
  State<RcCarControlPage> createState() => _RcCarControlPageState();
}

class _RcCarControlPageState extends State<RcCarControlPage> {
  // Variables to track button states
  bool isForwardPressed = false;
  bool isBackwardPressed = false;
  bool isLeftPressed = false;
  bool isRightPressed = false;

  // Function button states
  bool lightOn = false;
  bool hornOn = false;
  bool turboOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RC Car Controller'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.lightbulb, color: lightOn ? Colors.yellow : Colors.grey),
                Icon(Icons.volume_up, color: hornOn ? Colors.blue : Colors.grey),
                Icon(Icons.bolt, color: turboOn ? Colors.orange : Colors.grey),
              ],
            ),
            const SizedBox(height: 20),

            // Main control grid
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3x3 Grid
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        _buildControlButton(Icons.arrow_upward, isForwardPressed, () {
                          setState(() => isForwardPressed = true);
                          // Send forward command
                        }, () {
                          setState(() => isForwardPressed = false);
                          // Send stop command
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        _buildControlButton(Icons.arrow_back, isLeftPressed, () {
                          setState(() => isLeftPressed = true);
                          // Send left command
                        }, () {
                          setState(() => isLeftPressed = false);
                          // Send stop turning command
                        }),
                        _buildControlButton(Icons.stop, false, () {
                          // Send stop all command
                        }, () {}),
                        _buildControlButton(Icons.arrow_forward, isRightPressed, () {
                          setState(() => isRightPressed = true);
                          // Send right command
                        }, () {
                          setState(() => isRightPressed = false);
                          // Send stop turning command
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        _buildControlButton(Icons.arrow_downward, isBackwardPressed, () {
                          setState(() => isBackwardPressed = true);
                          // Send backward command
                        }, () {
                          setState(() => isBackwardPressed = false);
                          // Send stop command
                        }),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                // Function buttons column
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFunctionButton('Lights', Icons.lightbulb_outline, lightOn, () {
                      setState(() => lightOn = !lightOn);
                      // Toggle lights
                    }),
                    _buildFunctionButton('Horn', Icons.volume_up, hornOn, () {
                      setState(() => hornOn = !hornOn);
                      // Toggle horn
                    }),
                    _buildFunctionButton('Turbo', Icons.bolt, turboOn, () {
                      setState(() => turboOn = !turboOn);
                      // Toggle turbo
                    }),
                    _buildFunctionButton('Mode', Icons.settings, false, () {
                      // Change driving mode
                    }),
                    _buildFunctionButton('Emergency', Icons.emergency, false, () {
                      // Emergency stop
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, bool isPressed, Function onPressed, Function onReleased) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      onTapUp: (_) => onReleased(),
      onTapCancel: () => onReleased(),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isPressed ? Colors.blue : Colors.blue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade800, width: 2),
        ),
        child: Icon(icon, size: 40, color: Colors.white),
      ),
    );
  }

  Widget _buildFunctionButton(String label, IconData icon, bool isActive, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.blue : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}