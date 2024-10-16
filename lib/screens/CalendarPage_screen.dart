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

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

 void _loadEvents() async {
  final ventas = await DBHelper().getAllVentas();
  print("Ventas cargadas: $ventas"); // Verifica que las ventas se carguen correctamente

  setState(() {
    _events = {};
    for (var venta in ventas) {
      DateTime fecha = DateTime.parse(venta['fecha']);
      _events[fecha] = _events[fecha] ?? [];
      _events[fecha]!.add({
        'estatus': venta['estatus'],
        'nombreCliente': venta['nombreCliente'],
      });
    }
  });

  print("Eventos cargados: $_events"); // Verifica que los eventos se carguen correctamente
}

  Color _getColorFromEstatus(String estatus) {
    switch (estatus) {
      case 'Por cumplir':
        return Colors.green;
      case 'Cancelado':
        return Colors.red;
      case 'Completado':
        return Colors.blue; // Cambié a azul para diferenciarlos
      default:
        return Colors.grey;
    }
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
            focusedDay: _selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
              _showEventDetails(context, selectedDay, _events[selectedDay] ?? []);
            },
            eventLoader: (date) {
              return _events[date] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final markers = <Widget>[];

                // Obtén el color del primer evento si hay al menos uno
                if (events.isNotEmpty) {
                  final color = _getColorFromEstatus(events[0]['estatus'] ?? '');

                  markers.add(
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color, // Color del círculo
                        ),
                      ),
                    
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: markers,
                );
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
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Eventos del ${date.toLocal()}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(event['nombreCliente'] ?? ''),
                      subtitle: Text(event['estatus'] ?? ''),
                      leading: Icon(_getIconFromEstatus(event['estatus'] ?? '')),
                      tileColor: _getColorFromEstatus(event['estatus'] ?? ''),
                    );
                  },
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
  }

  // Método para obtener el ícono según el estatus
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
