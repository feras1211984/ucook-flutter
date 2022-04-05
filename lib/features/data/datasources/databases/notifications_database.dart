import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/notification.dart';

abstract class NotificationsDatabase {
  static late Database database;
  static Future<void> open() async {
    try {
      database = await openDatabase(
        join(await getDatabasesPath(), 'notifications.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE notifications(id TEXT PRIMARY KEY,time INTEGER NOT NULL,title TEXT NOT NULL,details TEXT NOT NULL,image_url TEXT,opened BOOLEAN NOT NULL CHECK(opened IN (0, 1)))',
          );
        },
        version: 1,
      );
    } catch (e) {}
  }

  static Future<void> save(Notification notification) async {
    try {
      await open();
      await database.insert("notifications", notification.toMap());
      database.close();
    } catch (e) {}
  }

  static Future<void> delete(Notification notification) async {
    try {
      await open();
      await database
          .delete("notifications", where: "id=?", whereArgs: [notification.id]);
      database.close();
    } catch (e) {}
  }

  static Future<List<Notification>> getAll() async {
    try {
      await open();
      var notifications =
          (await database.query("notifications", orderBy: "time DESC"))
              .map((NotificationMap) {
        return Notification.fromMap(NotificationMap);
      }).toList();
      database.close();
      return notifications;
    } catch (e) {
      return <Notification>[];
    }
  }

  static Future<void> update(Notification notification) async {
    try {
      await open();
      await database.update("notifications", notification.toMap(),
          where: "id=?", whereArgs: [notification.id]);
      database.close();
    } catch (e) {}
  }
}
