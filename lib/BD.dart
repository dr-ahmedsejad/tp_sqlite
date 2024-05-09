import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BD {
  static Database? _bd;

  Future<Database?> verifie_bd() async {
    if (_bd == null) {
      _bd = await intialisation_BD();
      return _bd;
    } else {
      return _bd;
    }
  }

  intialisation_BD() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'task.db');
    Database ma_db = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return ma_db;
  }

  _onCreate(Database bd, int version) async {
    await bd.execute('''
   CREATE TABLE "tasks" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "task" TEXT NOT NULL,
    "completed" INTEGER NOT NULL DEFAULT 0
  )
 ''');
    print("##############################################");
    print("onCreate");
    print("##############################################");
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("##############################################");
    print("onUpgrade");
    print("##############################################");
  }

  Afficher(String sql) async {
    Database? ma_bd = await verifie_bd();
    List<Map> response = await ma_bd!.rawQuery(sql);
    return response;
  }

  Ajouter(String sql) async {
    Database? ma_bd = await verifie_bd();
    int response = await ma_bd!.rawInsert(sql);
    print(response);
    return response;
  }

  Modifier(String sql) async {
    Database? ma_bd = await verifie_bd();
    int response = await ma_bd!.rawUpdate(sql);
    print("############################");
    print(response);
    print("############################");
    return response;
  }

  Supprimer(String sql) async {
    Database? ma_bd = await verifie_bd();
    int response = await ma_bd!.rawDelete(sql);
    print("############################");
    print(response);
    print("############################");
    return response;
  }
}
