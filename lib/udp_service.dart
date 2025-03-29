import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class UDPService {
  static final UDPService _instance = UDPService._internal();
  factory UDPService() => _instance;
  UDPService._internal();
  static const String CMD_STANDBY = 'standby:';
  static const String CMD_LAYDOWN = 'laydown:';

  static const String CMD_WALK_0 = 'walk0:';
  static const String CMD_WALK_180 = 'walk180:';

  static const String CMD_WALK_R45 = 'walkr45:';
  static const String CMD_WALK_R90 = 'walkr90:';
  static const String CMD_WALK_R135 = 'walkr135:';

  static const String CMD_WALK_L45 = 'walkl45:';
  static const String CMD_WALK_L90 = 'walkl90:';
  static const String CMD_WALK_L135 = 'walkl135:';

  static const String CMD_FASTFORWARD = 'fastforward:';
  static const String CMD_FASTBACKWARD = 'fastbackward:';

  static const String CMD_TURNLEFT = 'turnleft:';
  static const String CMD_TURNRIGHT = 'turnright:';

  static const String CMD_CLIMBFORWARD = 'climbforward:';
  static const String CMD_CLIMBBACKWARD = 'climbbackward:';

  static const String CMD_ROTATEX = 'rotatex:';
  static const String CMD_ROTATEY = 'rotatey:';
  static const String CMD_ROTATEZ = 'rotatez:';

  static const String CMD_TWIST = 'twist:';

  // Configuration
  String _targetIp = '192.168.1.100'; // Default IP
  int _targetPort = 8888; // Default port
  RawDatagramSocket? _socket;
  bool _isInitialized = false;

  // Initialize the UDP sender with target IP and port
  Future<void> initialize({String? ip, int? port}) async {
    if (_isInitialized) {
      print('UDP sender already initialized');
      return;
    }

    if (ip != null) _targetIp = ip;
    if (port != null) _targetPort = port;

    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      _isInitialized = true;
      print('UDP sender initialized on ${_socket?.address.address}:${_socket?.port}');
      print('Targeting $targetIp:$targetPort');
    } catch (e) {
      print('Failed to initialize UDP sender: $e');
      rethrow;
    }
  }

  // Send command to RC car
  void sendCommand(String command) {
    if (!_isInitialized) {
      throw Exception('UDP sender not initialized. Call initialize() first.');
    }

    if (!_isValidCommand(command)) {
      throw ArgumentError('Invalid command: $command');
    }

    final data = Uint8List.fromList(command.codeUnits);
    _socket?.send(data, InternetAddress(_targetIp), _targetPort);
    print('Sent command: $command to $_targetIp:$_targetPort');
  }

  // Update target IP and port
  void updateTarget({String? ip, int? port}) {
    if (ip != null) _targetIp = ip;
    if (port != null) _targetPort = port;
    print('Updated target to $_targetIp:$_targetPort');
  }

  // Clean up resources
  void dispose() {
    _socket?.close();
    _socket = null;
    _isInitialized = false;
    print('UDP sender disposed');
  }

  // Getters
  String get targetIp => _targetIp;
  int get targetPort => _targetPort;
  bool get isInitialized => _isInitialized;

  // Command validation
  bool _isValidCommand(String command) {
    const validCommands = [
      CMD_STANDBY,
      CMD_LAYDOWN,
      CMD_WALK_0,
      CMD_WALK_180,
      CMD_WALK_R45,
      CMD_WALK_R90,
      CMD_WALK_R135,
      CMD_WALK_L45,
      CMD_WALK_L90,
      CMD_WALK_L135,
      CMD_FASTFORWARD,
      CMD_FASTBACKWARD,
      CMD_TURNLEFT,
      CMD_TURNRIGHT,
      CMD_CLIMBFORWARD,
      CMD_CLIMBBACKWARD,
      CMD_ROTATEX,
      CMD_ROTATEY,
      CMD_ROTATEZ,
      CMD_TWIST,
    ];

    return validCommands.contains(command);
  }
}