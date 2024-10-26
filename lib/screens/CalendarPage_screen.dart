import 'package:flutter/material.dart';
import 'package:pmsn2024b/database/servicio_database.dart';
import 'package:pmsn2024b/screens/historyPage_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<Map<String, String>>> _events = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final dbHelper = DBHelper();
    final ventas = await dbHelper.getAllVentas();
    final categorias = await dbHelper.getCategorias();
    final bienes = await dbHelper.getAllBienes();

    setState(() {
      _events.clear();
      for (var venta in ventas) {
        DateTime fecha = DateTime.parse(venta['fecha']).toLocal();
        final normalizedDate = DateTime(fecha.year, fecha.month, fecha.day);
        final now = DateTime.now();

        // Crear una copia mutable de 'venta'
        var ventaCopia = Map<String, dynamic>.from(venta);

        // Si la fecha ya ha pasado y el estatus no es "Cancelado", lo actualizamos en la base de datos
        if (normalizedDate.isBefore(DateTime(now.year, now.month, now.day)) && ventaCopia['estatus'] != 'Cancelado') {
          ventaCopia['estatus'] = 'Cancelado';
          dbHelper.updateEstatusVenta(ventaCopia['id'], 'Cancelado');
        }

        // Obtener la categoría y producto relacionados
        final categoria = categorias.firstWhere((cat) => cat['id'] == ventaCopia['categoriaId'], orElse: () => {'nombre': 'Desconocida'});
        final bien = bienes.firstWhere((bien) => bien['id'] == ventaCopia['bienId'], orElse: () => {'nombre': 'Producto no especificado', 'cantidad': 0});

        _events[normalizedDate] = _events[normalizedDate] ?? [];
        _events[normalizedDate]!.add({
          'id': ventaCopia['id'].toString(),
          'estatus': ventaCopia['estatus'],
          'nombreCliente': ventaCopia['nombreCliente'],
          'categoria': categoria['nombre'],
          'producto': bien['nombre'],
          'cantidad': bien['cantidad'].toString(),
        });
      }
    });
  }

  Color _getColorFromEstatus(String estatus, DateTime eventDate) {
    final now = DateTime.now();
    final normalizedNow = DateTime(now.year, now.month, now.day);
    final normalizedEventDate = DateTime(eventDate.year, eventDate.month, eventDate.day);

    if (estatus == 'Cancelado' || normalizedEventDate.isBefore(normalizedNow)) {
      return Colors.red;
    } else if (estatus == 'Por cumplir') {
      return Colors.green;
    } else if (estatus == 'Completado') {
      return Colors.yellow;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Ventas/Servicios'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Map<String, String>>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              final normalizedSelectedDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
              _showEventDetails(context, normalizedSelectedDate, _events[normalizedSelectedDate] ?? []);
            },
            eventLoader: (date) {
              final normalizedDate = DateTime(date.year, date.month, date.day);
              return _events[normalizedDate] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  final color = _getColorFromEstatus(events[0]['estatus'] ?? '', date);
                  return Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, DateTime date, List<Map<String, String>> events) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eventos del ${date.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  events.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              return ListTile(
                                title: Text(event['nombreCliente'] ?? 'Sin nombre'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Estatus: ${event['estatus'] ?? 'Sin estatus'}'),
                                    Text('Categoría: ${event['categoria'] ?? 'Sin categoría'}'),
                                  ],
                                ),
                                leading: Icon(_getIconFromEstatus(event['estatus'] ?? '')),
                                tileColor: _getColorFromEstatus(event['estatus'] ?? '', date),
                                trailing: DropdownButton<String>(
                                  value: event['estatus'],
                                  items: ['Por cumplir', 'Cancelado', 'Completado'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) async {
                                    if (newValue != null) {
                                      setModalState(() {
                                        event['estatus'] = newValue;
                                      });
                                      final dbHelper = DBHelper();
                                      await dbHelper.updateEstatusVenta(int.parse(event['id']!), newValue);
                                      _loadEvents(); // Refrescar los eventos en el calendario
                                      setState(() {});
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'No hay eventos para esta fecha.',
                            style: TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cerrar'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  IconData _getIconFromEstatus(String estatus) {
    switch (estatus) {
      case 'Por cumplir':
        return Icons.check_circle;
      case 'Cancelado':
        return Icons.cancel;
      case 'Completado':
        return Icons.check;
      default:
        return Icons.help;
    }
  }
}
