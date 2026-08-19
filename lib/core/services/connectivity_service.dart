import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isChecking = false;
  bool _lastStatus = true;

  Stream<bool> get internetStatusStream => _controller.stream;
  bool get lastStatus => _lastStatus;

  ConnectivityService() {
    _init();
  }

  void _init() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      final hasConnection = await checkHasInternet(results);
      _lastStatus = hasConnection;
      _controller.add(hasConnection);
    });

    // Run initial check
    checkCurrentStatus();
  }

  Future<bool> checkCurrentStatus() async {
    if (_isChecking) return _lastStatus;
    _isChecking = true;
    try {
      final results = await _connectivity.checkConnectivity();
      final hasInternet = await checkHasInternet(results);
      _lastStatus = hasInternet;
      _controller.add(hasInternet);
      return hasInternet;
    } finally {
      _isChecking = false;
    }
  }

  Future<bool> checkHasInternet([List<ConnectivityResult>? results]) async {
    final currentResults = results ?? await _connectivity.checkConnectivity();

    // If completely disconnected
    if (currentResults.isEmpty ||
        (currentResults.contains(ConnectivityResult.none) && currentResults.length == 1)) {
      return false;
    }

    // Double check with actual DNS lookup
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 4));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Connectivity lookup failed: $e');
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
