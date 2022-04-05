import 'package:bloc/bloc.dart';
import 'package:ucookfrontend/shared_variables_and_methods.dart';
import '../../../data/datasources/databases/notifications_database.dart';
import 'notifications_events.dart';
import 'notifications_states.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsAreLoading()) {
    on<GetNotifications>((event, emit) async {
      emit(NotificationsAreLoading());
      notifications.clear();
      notifications = await NotificationsDatabase.getAll();
      emit(NotificationsAreReady());
    });

    on<NotificationReceived>((event, emit) async {
      emit(NotificationsAreLoading());
      await NotificationsDatabase.save(event.notification);
      notifications.clear();
      notifications = await NotificationsDatabase.getAll();
      emit(NotificationsAreReady());
    });

    on<DeleteNotification>((event, emit) async {
      emit(NotificationsAreLoading());
      await NotificationsDatabase.delete(event.notification);
      notifications.clear();
      notifications = await NotificationsDatabase.getAll();
      emit(NotificationsAreReady());
    });

    on<OpenNotification>((event, emit) async {
      emit(NotificationsAreLoading());
      event.notification.opened = true;
      await NotificationsDatabase.update(event.notification);
      notifications.clear();
      notifications = await NotificationsDatabase.getAll();
      emit(NotificationsAreReady());
    });
  }
}
