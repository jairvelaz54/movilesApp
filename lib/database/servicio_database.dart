import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'ventas_servicios.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categorias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE bienes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        categoriaId INTEGER,
        precio REAL NOT NULL,
        FOREIGN KEY (categoriaId) REFERENCES categorias (id)
      );
    ''');
    await db.execute('''
      CREATE TABLE ventasServicios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreCliente TEXT NOT NULL,
        fecha TEXT NOT NULL,
        estatus TEXT NOT NULL,
        categoriaId INTEGER,
        total REAL NOT NULL,
        recordatorioFecha TEXT,
        FOREIGN KEY (categoriaId) REFERENCES categorias (id)
      );
    ''');
    await db.execute('''
      CREATE TABLE detalleVenta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ventaId INTEGER,
        productoId INTEGER,
        cantidad INTEGER NOT NULL,
        precioUnitario REAL NOT NULL,
        FOREIGN KEY (ventaId) REFERENCES ventasServicios (id),
        FOREIGN KEY (productoId) REFERENCES bienes (id)
      );
    ''');

    // Llama al método para insertar datos iniciales después de crear las tablas
    await insertInitialData(db);
  }

  Future<void> insertInitialData(Database db) async {
    // Insertar categorías
    await db.insert('categorias', {'nombre': 'Electrónica'});
    await db.insert('categorias', {'nombre': 'Ropa'});
    await db.insert('categorias', {'nombre': 'Alimentos'});

    // Insertar bienes
    await db.insert('bienes', {'nombre': 'Televisor', 'categoriaId': 1, 'precio': 500.0});
    await db.insert('bienes', {'nombre': 'Smartphone', 'categoriaId': 1, 'precio': 300.0});
    await db.insert('bienes', {'nombre': 'Camiseta', 'categoriaId': 2, 'precio': 20.0});
    await db.insert('bienes', {'nombre': 'Pantalón', 'categoriaId': 2, 'precio': 40.0});
    await db.insert('bienes', {'nombre': 'Manzana', 'categoriaId': 3, 'precio': 1.0});
    await db.insert('bienes', {'nombre': 'Pan', 'categoriaId': 3, 'precio': 2.0});
  }

  Future<void> addNewVenta(String nombreCliente, DateTime fecha, String estatus,
      int categoriaId, double total) async {
    final db = await DBHelper().database;
    await db.insert('ventasServicios', {
      'nombreCliente': nombreCliente,
      'fecha': fecha.toIso8601String(),
      'estatus': estatus,
      'categoriaId': categoriaId,
      'total': total,
      'recordatorioFecha': fecha.subtract(Duration(days: 2)).toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllVentas() async {
    final db = await DBHelper().database;
    return await db.query('ventasServicios');
  }

  Future<void> updateEstatusVenta(int ventaId, String nuevoEstatus) async {
    final db = await DBHelper().database;
    await db.update(
      'ventasServicios',
      {'estatus': nuevoEstatus},
      where: 'id = ?',
      whereArgs: [ventaId],
    );
  }

  // Métodos para gestionar categorías
  Future<void> addCategoria(String nombre) async {
    final db = await database;
    await db.insert('categorias', {'nombre': nombre});
  }

  Future<List<Map<String, dynamic>>> getCategorias() async {
    final db = await database;
    return await db.query('categorias');
  }

  Future<void> updateCategoria(int id, String nuevoNombre) async {
    final db = await database;
    await db.update(
      'categorias',
      {'nombre': nuevoNombre},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCategoria(int id) async {
    final db = await database;
    await db.delete(
      'categorias',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para gestionar bienes
  Future<void> addBien(String nombre, int categoriaId, double precio) async {
    final db = await database;
    await db.insert('bienes', {
      'nombre': nombre,
      'categoriaId': categoriaId,
      'precio': precio,
    });
  }

  Future<List<Map<String, dynamic>>> getBienesPorCategoria(int categoriaId) async {
    final db = await database;
    return await db.query(
      'bienes',
      where: 'categoriaId = ?',
      whereArgs: [categoriaId],
    );
  }

  Future<void> updateBien(int id, String nuevoNombre, int nuevaCategoriaId, double nuevoPrecio) async {
    final db = await database;
    await db.update(
      'bienes',
      {
        'nombre': nuevoNombre,
        'categoriaId': nuevaCategoriaId,
        'precio': nuevoPrecio,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBien(int id) async {
    final db = await database;
    await db.delete(
      'bienes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para gestionar detalles de venta
  Future<void> addDetalleVenta(int ventaId, int productoId, int cantidad, double precioUnitario) async {
    final db = await database;
    await db.insert('detalleVenta', {
      'ventaId': ventaId,
      'productoId': productoId,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
    });
  }

  Future<List<Map<String, dynamic>>> getDetallesVenta(int ventaId) async {
    final db = await database;
    return await db.query(
      'detalleVenta',
      where: 'ventaId = ?',
      whereArgs: [ventaId],
    );
  }

  Future<void> updateDetalleVenta(int id, int cantidad, double precioUnitario) async {
    final db = await database;
    await db.update(
      'detalleVenta',
      {
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteDetalleVenta(int id) async {
    final db = await database;
    await db.delete(
      'detalleVenta',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
