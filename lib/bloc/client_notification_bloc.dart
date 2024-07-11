import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Notification Event
abstract class ClientNotificationEvent extends Equatable {
  const ClientNotificationEvent();

  @override
  List<Object?> get props => [];
}

class ClientSendNotification extends ClientNotificationEvent {
  final String notificationMessage;

  const ClientSendNotification(this.notificationMessage);

  @override
  List<Object?> get props => [notificationMessage];
}

// Notification State
abstract class ClientNotificationState extends Equatable {
  const ClientNotificationState();

  @override
  List<Object?> get props => [];
}

class ClientNotificationInitial extends ClientNotificationState {}

class ClientNotificationReceived extends ClientNotificationState {
  final String notificationMessage;

  ClientNotificationReceived(this.notificationMessage);

  @override
  List<Object?> get props => [notificationMessage];
}

class ClientNotificationError extends ClientNotificationState {
  final String message;

  const ClientNotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientNotificationBloc extends Bloc<ClientNotificationEvent, ClientNotificationState> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  ClientNotificationBloc() : super(ClientNotificationInitial()) {
    _configureFirebaseMessaging();
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Client received message: ${message.notification?.title}");
      if (message.notification != null) {
        add(ClientSendNotification('${message.notification!.title}\n${message.notification!.body}'));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Client opened from message: ${message.notification?.title}");
      // Handle notification when app is in background but opened by tapping on notification
    });

    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
      // Send this token to your server or use it to send notifications to this device
    });
  }

  @override
  Stream<ClientNotificationState> mapEventToState(ClientNotificationEvent event) async* {
    if (event is ClientSendNotification) {
      yield ClientNotificationReceived(event.notificationMessage);
    }
  }
}
