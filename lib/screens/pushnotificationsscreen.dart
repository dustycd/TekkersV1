// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';  // Import the permission handler package
import 'dart:io' show Platform;

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({super.key});

  @override
  _PushNotificationsScreenState createState() => _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  bool isNotificationsEnabled = false;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin?.initialize(initializationSettings);
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      if (Platform.isIOS) {
        // Request permissions for iOS
        final bool? granted = await flutterLocalNotificationsPlugin
            ?.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        if (granted != null && granted) {
          setState(() {
            isNotificationsEnabled = true;
          });
        }
      } else if (Platform.isAndroid) {
        // Handle Android 13+ POST_NOTIFICATIONS permission manually
        if (await _checkNotificationPermission()) {
          setState(() {
            isNotificationsEnabled = true;
          });
        }
      }
    } else {
      setState(() {
        isNotificationsEnabled = false;
      });
    }
  }

  // Check Android notification permissions using permission_handler
  Future<bool> _checkNotificationPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.notification.status;
      if (status.isDenied) {
        status = await Permission.notification.request();
      }
      return status.isGranted;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications'),
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text('Receive Notifications'),
          value: isNotificationsEnabled,
          onChanged: (value) {
            _toggleNotifications(value);
          },
        ),
      ),
    );
  }
}