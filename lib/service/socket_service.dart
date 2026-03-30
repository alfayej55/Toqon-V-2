import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../helpers/prefs_helpers.dart';
import '../utils/app_constants.dart';

/// Connection states for the socket
enum SocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  failed,
}

/// User presence status
enum UserPresenceStatus {
  online,
  offline,
  away,
  busy,
}

/// Socket event types for type safety
class SocketEvents {
  static const String connect = 'connect';
  static const String disconnect = 'disconnect';
  static const String connectError = 'connect_error';
  static const String reconnect = 'reconnect';
  static const String reconnectAttempt = 'reconnect_attempt';
  static const String reconnectError = 'reconnect_error';
  static const String reconnectFailed = 'reconnect_failed';

  // Custom events - customize based on your backend

  static const String newMessage = 'newMessage';
  static const String messageDelivered = 'message_delivered';
  static const String messageRead = 'message_read';
  static const String typing = 'typing';
  static const String stopTyping = 'stop_typing';
  static const String userOnline = 'user_online';
  static const String userOffline = 'user_offline';
  static const String presenceUpdate = 'presence_update';
  static const String joinRoom = 'join_room';
  static const String leaveRoom = 'leave_room';
  static const String error = 'error';
}

/// Message model for queue
class QueuedMessage {
  final String event;
  final dynamic data;
  final DateTime timestamp;
  final String? id;

  QueuedMessage({
    required this.event,
    required this.data,
    this.id,
  }) : timestamp = DateTime.now();
}

/// Socket Service - Production Ready
/// Supports: Live messaging, presence tracking, auto-reconnection
class SocketService {
  // Singleton instance
  static SocketService? _instance;
  static SocketService get instance => _instance ??= SocketService._internal();

  factory SocketService() => instance;
  SocketService._internal();

  // Socket instance
  io.Socket? _socket;

  // Configuration
   String? _baseUrl;
   String? _authToken;
  String? _userId;
  Map<String, dynamic>? _extraHeaders;

  // Connection state management
  final _connectionStateController = StreamController<SocketConnectionState>.broadcast();
  Stream<SocketConnectionState> get connectionState => _connectionStateController.stream;
  SocketConnectionState _currentState = SocketConnectionState.disconnected;
  SocketConnectionState get currentConnectionState => _currentState;

  // Presence tracking
  final _presenceController = StreamController<Map<String, UserPresenceStatus>>.broadcast();
  Stream<Map<String, UserPresenceStatus>> get presenceStream => _presenceController.stream;
  final Map<String, UserPresenceStatus> _userPresence = {};

  // Message streams
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  // Typing indicator streams
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;

  // Generic event stream for custom events
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get eventStream => _eventController.stream;

  // Message queue for offline support
  final Queue<QueuedMessage> _messageQueue = Queue<QueuedMessage>();
  static const int _maxQueueSize = 100;

  // Reconnection settings
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  // Event listeners storage for cleanup
  final Map<String, List<Function(dynamic)>> _eventListeners = {};

  // Logging
  bool _enableLogging = kDebugMode;

  /// Initialize socket with configuration


  Future<void> initialize({
    Map<String, dynamic>? extraHeaders,
    bool enableLogging = true,
  }) async {
    // Load auth token from SharedPreferences
    _authToken = await PrefsHelper.getString(AppConstants.bearerToken);

    // Load userId if you store it
    _userId = await PrefsHelper.getString(AppConstants.userID);

    // Load base URL from your config/constants
    _baseUrl = AppConstants.socketUrl;

    _extraHeaders = extraHeaders;
    _enableLogging = enableLogging && kDebugMode;

    _log('SocketService initialized');
    _log('Base URL: $_baseUrl');
    _log('Auth Token: $_authToken');
    _log('User ID: $_userId');

    // If socket is already connected with old auth, disconnect it
    // so connect() will create fresh connection with new auth
    if (_socket != null) {
      _log('Cleaning up old socket connection for re-auth');
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
  }

  // void initialize({
  //   required String baseUrl,
  //   String? authToken,
  //   String? userId,
  //   Map<String, dynamic>? extraHeaders,
  //   bool enableLogging = true,
  // }) {
  //   _baseUrl = baseUrl;
  //   _authToken = authToken;
  //   _userId = userId;
  //   _extraHeaders = extraHeaders;
  //   _enableLogging = enableLogging && kDebugMode;
  //
  //   _log('SocketService initialized with URL: $baseUrl');
  // }

  /// Connect to socket server
  Future<bool> connect() async {
    if (_baseUrl == null) {
      _log('Error: Socket not initialized. Call initialize() first.');
      return false;
    }
    if (_socket?.connected == true) {
      _log('Socket already connected');
      return true;
    }

    // Clean up old socket if exists (prevents duplicate listeners)
    if (_socket != null) {
      _log('Cleaning up old socket before reconnecting');
      _socket!.clearListeners();
      _socket!.dispose();
      _socket = null;
    }

    _updateConnectionState(SocketConnectionState.connecting);

    try {
      _log('Connecting with auth token: ${_authToken?.substring(0, 20)}...');

      // Build options with forceNew to prevent connection caching
      final options = io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(_maxReconnectAttempts)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setTimeout(20000)
          .setAuth(_buildAuthPayload())
          .setExtraHeaders(_extraHeaders ?? {})
          .build();

      // Add forceNew to prevent socket.io from reusing cached connections
      options['forceNew'] = true;
      options['multiplex'] = false;

      _socket = io.io(_baseUrl!, options);

      _setupEventListeners();
      _socket!.connect();

      return true;
    } catch (e) {
      _log('Connection error: $e');
      _updateConnectionState(SocketConnectionState.failed);
      return false;
    }
  }

  /// Build auth payload for socket connection
  Map<String, dynamic> _buildAuthPayload() {
    return {
      if (_authToken != null) 'token': _authToken,
      if (_userId != null) 'userId': _userId,
    };
  }

  /// Setup all socket event listeners
  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      _log('Socket connected');
      _reconnectAttempts = 0;
      _updateConnectionState(SocketConnectionState.connected);
      _startHeartbeat();
      _processMessageQueue();
      _updatePresence(UserPresenceStatus.online);
    });

    _socket!.onDisconnect((_) {
      _log('Socket disconnected');
      _updateConnectionState(SocketConnectionState.disconnected);
      _stopHeartbeat();
    });

    _socket!.onConnectError((error) {
      _log('Connection error: $error');
      _updateConnectionState(SocketConnectionState.failed);
      _handleReconnection();
    });

    _socket!.onReconnect((_) {
      _log('Socket reconnected');
      _reconnectAttempts = 0;
      _updateConnectionState(SocketConnectionState.connected);
    });

    _socket!.onReconnectAttempt((attempt) {
      _log('Reconnection attempt: $attempt');
      _reconnectAttempts = attempt as int;
      _updateConnectionState(SocketConnectionState.reconnecting);
    });

    _socket!.onReconnectError((error) {
      _log('Reconnection error: $error');
    });

    _socket!.onReconnectFailed((_) {
      _log('Reconnection failed after $_maxReconnectAttempts attempts');
      _updateConnectionState(SocketConnectionState.failed);
    });

    // Message events
    _socket!.on(SocketEvents.newMessage, (data) {
      _log('New message received: $data');
      _messageController.add(_parseEventData(SocketEvents.newMessage, data));
    });

    _socket!.on(SocketEvents.messageDelivered, (data) {
      _eventController.add(_parseEventData(SocketEvents.messageDelivered, data));
    });

    _socket!.on(SocketEvents.messageRead, (data) {
      _eventController.add(_parseEventData(SocketEvents.messageRead, data));
    });

    // Typing events
    _socket!.on(SocketEvents.typing, (data) {
      _typingController.add(_parseEventData(SocketEvents.typing, data));
    });

    _socket!.on(SocketEvents.stopTyping, (data) {
      _typingController.add(_parseEventData(SocketEvents.stopTyping, data));
    });

    // Presence events
    _socket!.on(SocketEvents.userOnline, (data) {
      _handleUserPresenceChange(data, UserPresenceStatus.online);
    });

    _socket!.on(SocketEvents.userOffline, (data) {
      _handleUserPresenceChange(data, UserPresenceStatus.offline);
    });

    _socket!.on(SocketEvents.presenceUpdate, (data) {
      _handlePresenceUpdate(data);
    });

    // Error event
    _socket!.on(SocketEvents.error, (error) {
      _log('Socket error: $error');
      _eventController.add({'event': SocketEvents.error, 'error': error});
    });
  }

  /// Parse event data to standardized format
  Map<String, dynamic> _parseEventData(String event, dynamic data) {
    if (data is Map<String, dynamic>) {
      return {'event': event, ...data};
    }
    return {'event': event, 'data': data};
  }

  /// Handle user presence changes
  void _handleUserPresenceChange(dynamic data, UserPresenceStatus status) {
    final userId = data is Map ? data['userId']?.toString() : data?.toString();
    if (userId != null) {
      _userPresence[userId] = status;
      _presenceController.add(Map.from(_userPresence));
      _log('User $userId is now ${status.name}');
    }
  }

  /// Handle bulk presence update
  void _handlePresenceUpdate(dynamic data) {
    if (data is Map) {
      data.forEach((key, value) {
        final status = _parsePresenceStatus(value);
        if (status != null) {
          _userPresence[key.toString()] = status;
        }
      });
      _presenceController.add(Map.from(_userPresence));
    }
  }

  /// Parse presence status from string
  UserPresenceStatus? _parsePresenceStatus(dynamic value) {
    if (value is UserPresenceStatus) return value;
    if (value is String) {
      return UserPresenceStatus.values.firstWhere(
        (e) => e.name == value.toLowerCase(),
        orElse: () => UserPresenceStatus.offline,
      );
    }
    return null;
  }

  /// Update connection state
  void _updateConnectionState(SocketConnectionState state) {
    _currentState = state;
    _connectionStateController.add(state);
    _log('Connection state: ${state.name}');
  }

  /// Handle manual reconnection with exponential backoff
  void _handleReconnection() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _log('Max reconnection attempts reached');
      _updateConnectionState(SocketConnectionState.failed);
      return;
    }

    final delay = _calculateBackoffDelay(_reconnectAttempts);
    _log('Scheduling reconnection in ${delay}ms');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(milliseconds: delay), () {
      _reconnectAttempts++;
      connect();
    });
  }

  /// Calculate exponential backoff delay
  int _calculateBackoffDelay(int attempt) {
    const baseDelay = 1000;
    const maxDelay = 30000;
    final delay = baseDelay * (1 << attempt);
    return delay > maxDelay ? maxDelay : delay;
  }

  /// Start heartbeat for connection monitoring
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_socket?.connected == true) {
        _socket!.emit('ping', {'timestamp': DateTime.now().millisecondsSinceEpoch});
      }
    });
  }

  /// Stop heartbeat
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Update own presence status
  void _updatePresence(UserPresenceStatus status) {
    if (_socket?.connected == true && _userId != null) {
      emit(SocketEvents.presenceUpdate, {
        'userId': _userId,
        'status': status.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  // ==================== Public API ====================

  /// Emit event with data
  void emit(String event, dynamic data) {
    if (_socket?.connected == true) {
      _socket!.emit(event, data);
      _log('Emitted: $event');
    } else {
      _queueMessage(event, data);
      _log('Queued (offline): $event');
    }
  }

  /// Emit with acknowledgment and timeout

  Future<T?> emitWithAck<T>(
    String event,
    dynamic data, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (_socket?.connected != true) {
      _log('Cannot emit with ack: Socket not connected');
      return null;
    }

    final completer = Completer<T?>();
    Timer? timeoutTimer;

    timeoutTimer = Timer(timeout, () {
      if (!completer.isCompleted) {
        _log('Emit with ack timeout: $event');
        completer.complete(null);
      }
    });

    _socket!.emitWithAck(event, data, ack: (response) {
      timeoutTimer?.cancel();
      if (!completer.isCompleted) {
        _log('Ack received for: $event');
        completer.complete(response as T?);
      }
    });

    return completer.future;
  }

  /// Send a message
  Future<bool> sendMessage({
    required String conversationId,
    required String receiverId,
    required String message,
    String? messageType,
    Map<String, dynamic>? metadata,
  }) async {
    final payload = {
      'conversationId': conversationId,
      'recipientId': receiverId,
      'content': message,
      'messageType': messageType ?? 'text',
      if (metadata != null) ...metadata,
    };

    _log('SendMessage payload: $payload');

    final response = await emitWithAck<Map<String, dynamic>>(
      'sendMessage',
        payload,
    );

    _log('SendMessage response: $response');

    return response != null && response['success'] == true;

  }

  /// Join a chat room
  void joinRoom(String roomId) {
    emit(SocketEvents.joinRoom, {'roomId': roomId, 'userId': _userId});
    _log('Joined room: $roomId');
  }

  /// Leave a chat room
  void leaveRoom(String roomId) {
    emit(SocketEvents.leaveRoom, {'roomId': roomId, 'userId': _userId});
    _log('Left room: $roomId');
  }

  /// Send typing indicator
  void sendTyping(String receiverId) {
    emit(SocketEvents.typing, {'senderId': _userId, 'receiverId': receiverId});
  }

  /// Send stop typing indicator
  void sendStopTyping(String receiverId) {
    emit(SocketEvents.stopTyping, {'senderId': _userId, 'receiverId': receiverId});
  }

  /// Check if a user is online
  bool isUserOnline(String userId) {
    return _userPresence[userId] == UserPresenceStatus.online;
  }

  /// Get user presence status
  UserPresenceStatus getUserPresence(String userId) {
    return _userPresence[userId] ?? UserPresenceStatus.offline;
  }

  /// Subscribe to specific users' presence
  void subscribeToPresence(List<String> userIds) {
    emit('subscribe_presence', {'userIds': userIds});
  }

  /// Add custom event listener
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
    _eventListeners[event] ??= [];
    _eventListeners[event]!.add(callback);
  }

  /// Remove custom event listener
  void off(String event, [Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off(event, callback);
      _eventListeners[event]?.remove(callback);
    } else {
      _socket?.off(event);
      _eventListeners.remove(event);
    }
  }

  /// Queue message for later delivery
  void _queueMessage(String event, dynamic data) {
    if (_messageQueue.length >= _maxQueueSize) {
      _messageQueue.removeFirst();
    }
    _messageQueue.add(QueuedMessage(event: event, data: data));
  }

  /// Process queued messages when connection is restored
  void _processMessageQueue() {
    while (_messageQueue.isNotEmpty) {
      final message = _messageQueue.removeFirst();
      emit(message.event, message.data);
    }
    _log('Processed ${_messageQueue.length} queued messages');
  }

  /// Update auth token (useful for token refresh)
  void updateAuthToken(String token) {
    _authToken = token;
    if (_socket?.connected == true) {
      emit('auth_update', {'token': token});
    }
  }

  /// Set user ID
  void setUserId(String userId) {
    _userId = userId;
  }

  /// Check if socket is connected
  bool get isConnected => _socket?.connected == true;

  /// Get socket ID
  String? get socketId => _socket?.id;

  /// Disconnect from socket server
   disconnect() {
    _updatePresence(UserPresenceStatus.offline);
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _socket?.disconnect();
    _updateConnectionState(SocketConnectionState.disconnected);
    _log('Socket disconnected manually');
  }


  Future<void> logout() async {
    _log('Logging out - clearing all socket data');

    // Disconnect socket
    disconnect();

    // Clear all cached data
    _authToken = null;
    _userId = null;
    _userPresence.clear();
    _messageQueue.clear();

    _log('Socket logout complete');
  }

  /// Dispose and cleanup all resources
   dispose() {
    _log('Disposing SocketService...');

    // Stop all timers first
    _stopHeartbeat();
    _reconnectTimer?.cancel();

    // Clear all listeners before disconnect
    _socket?.clearListeners();

    // Disconnect socket
    _socket?.disconnect();

    // Destroy socket completely
    _socket?.destroy();
    _socket?.dispose();
    _socket = null;

    // Clear auth data
    _authToken = null;
    _userId = null;
    _baseUrl = null;

    // Close all stream controllers
    _connectionStateController.close();
    _presenceController.close();
    _messageController.close();
    _typingController.close();
    _eventController.close();

    // Clear all cached data
    _messageQueue.clear();
    _userPresence.clear();
    _eventListeners.clear();

    _instance = null;
    _log('SocketService disposed completely');
  }

  /// Logging utility
  void _log(String message) {
    if (_enableLogging) {
      debugPrint('[SocketService] $message');
    }
  }
}