import 'package:sqflite/sqflite.dart';
import 'package:plantoune/models/plante.dart';
import 'package:plantoune/services/db.dart';

class PlanteService{

  Future<void> insertPlante(Plante plante) async {
    final db = await DatabaseService.database;

    await db?.insert(
      'plantes',
      plante.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Plante?> getPlanteById(int id) async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> planteMaps = await db!.query(
        'plantes',
        where: 'id = ?',
        whereArgs: [id]
    );

    if (planteMaps.isEmpty) return null;

    final planteMap = planteMaps.first;

    return Plante(
      id: planteMap['id'] as int,
      name: planteMap['name'] as String,
      text: planteMap['text'] as String,
      latitude: (planteMap['latitude'] as num).toDouble(),
      longitude: (planteMap['longitude'] as num).toDouble(),
      imagePath: planteMap['imagePath'] as String?,
    );
  }

  Future<List<Plante>> getAllplantes() async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> planteMaps = await db!.query('plantes');

    return [
      for (final {
        'id': id as int,
        'name': name as String,
        'text': text as String?,
        'latitude': latitude as num?,
        'longitude': longitude as num?,
        'imagePath': imagePath as String?}
      in planteMaps)
        Plante(id: id, name: name, text: text, latitude: latitude?.toDouble(), longitude: longitude?.toDouble(), imagePath: imagePath),
    ];
  }

  Future<void> updatePlante(Plante plante) async {
    final db = await DatabaseService.database;

    await db?.update(
      'plantes',
      plante.toMap(),
      where: 'id = ?',
      whereArgs: [plante.id], //to prevent SQL injection.
    );
  }

  Future<void> deletePlante(int id) async {
    final db = await DatabaseService.database;

    await db?.delete(
      'plantes',
      where: 'id = ?',
      whereArgs: [id], //to prevent SQL injection.
    );
  }

}
