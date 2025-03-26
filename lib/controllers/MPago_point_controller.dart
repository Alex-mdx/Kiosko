import 'package:kiosko/models/MPago_point_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

String nombreDb = "points";

class MpagoPointController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDb(
        id TEXT,
        pos_id INTEGER,
        store_id INTEGER,
        external_pos_id TEXT,
        operating_mode TEXT
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_pos_$nombreDb.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> insert({required MPagoPointModel point}) async {
    final db = await database();
    await db.delete(nombreDb);
    await db.insert(nombreDb, point.toJson());
  }

  static Future<MPagoPointModel?> getItem() async {
    final db = await database();
    final data = (await db.query(nombreDb)).firstOrNull;
    return data == null ? null : MPagoPointModel.fromJson(data);
  }
}
