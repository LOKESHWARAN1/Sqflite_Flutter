import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class Emp {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "empdetails.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE empolyer(id INTEGER PRIMARY KEY AUTO INCREMENT, name TEXT, email TEXT) ");
      });
    }
  }

  Future<int> insertEmpDetails(EmpDetails empolyer) async {
    await openDb();
    // ignore: missing_required_param
    return await _database.insert('empolyer', empolyer.toMap());
  }

  Future<List<EmpDetails>> getEmpDetailsList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('empolyer');
    return List.generate(maps.length, (i) {
      return EmpDetails(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
      );
    });
  }

  Future<int> updateEmpDetails(EmpDetails empolyer) async {
    await openDb();
    // ignore: missing_required_param
    return await _database.update('empolyer', empolyer.toMap(),
        where: "id=?", whereArgs: [empolyer.id]);
  }

  Future<void> deleteEmpDetails(int id) async {
    await openDb();
    await _database.delete('empolyer', where: "id=?", whereArgs: [id]);
  }
}

class EmpDetails {
  int id;
  String name;
  String email;
  EmpDetails({@required this.name, @required this.email, @required this.id});
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email};
  }
}
