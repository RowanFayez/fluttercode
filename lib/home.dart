import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Welcome, $userName!',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to the Firefighting App!',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Expanded(
            // Display the SmartDevicesScreen inside HomeScreen
            child: SmartDevicesScreen(userName: userName), // Pass the userName
          ),
        ],
      ),
    );
  }
}

class SmartDevicesScreen extends StatefulWidget {
  final String userName;

  const SmartDevicesScreen({super.key, required this.userName});

  @override
  State<SmartDevicesScreen> createState() => _SmartDevicesScreenState();
}

class _SmartDevicesScreenState extends State<SmartDevicesScreen> {
  bool isWaterPumpOn = false; // Water pump state
  bool isRobotOn = false; // Robot state

  void _onDeviceStateChanged(String device, bool isOn) {
    setState(() {
      if (device == 'Water Pump') {
        isWaterPumpOn = isOn;
      } else if (device == 'Robot') {
        isRobotOn = isOn;
      }
    });
    // Handle state change, e.g., publish MQTT messages
    print('$device is ${isOn ? 'On' : 'Off'}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${widget.userName}', // Dynamically display user name
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Smart Devices',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SmartDeviceControl(
                    icon: Icons.opacity,
                    label: 'Water Pump',
                    isOn: isWaterPumpOn,
                    onStateChanged: (value) {
                      _onDeviceStateChanged('Water Pump', value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SmartDeviceControl(
                    icon: Icons.fire_extinguisher,
                    label: 'Flame Sensors',
                    isOn: isRobotOn,
                    onStateChanged: (value) {
                      _onDeviceStateChanged('Robot', value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmartDeviceControl extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isOn;
  final Function(bool) onStateChanged;

  const SmartDeviceControl({
    super.key,
    required this.icon,
    required this.label,
    required this.isOn,
    required this.onStateChanged,
  });

  @override
  _SmartDeviceControlState createState() => _SmartDeviceControlState();
}

class _SmartDeviceControlState extends State<SmartDeviceControl> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isOn ? Colors.red : Colors.grey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.icon,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Switch(
            value: isOn,
            onChanged: (value) {
              setState(() {
                isOn = value;
                widget.onStateChanged(isOn);
              });
            },
            activeColor: Colors.green,
            inactiveTrackColor: Colors.grey[400],
            inactiveThumbColor: Colors.white,
          ),
          Text(
            isOn ? "On" : "Off",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isOn ? Colors.red : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
