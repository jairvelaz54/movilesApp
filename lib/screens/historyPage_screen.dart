import 'package:flutter/material.dart';
import 'package:pmsn2024b/database/servicio_database.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _historial = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final ventas = await DBHelper().getAllVentas();
    setState(() {
      _historial =
          ventas; // Aquí puedes filtrar las ventas según su estatus si lo deseas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historial de Ventas/Servicios')),
      body: ListView.builder(
        itemCount: _historial.length,
        itemBuilder: (context, index) {
          final venta = _historial[index];
          return ListTile(
            title: Text(venta['nombreCliente'] ?? ''),
            subtitle: Text(venta['estatus'] ?? ''),
            leading: Icon(_getIconFromEstatus(venta['estatus'] ?? '')),
            tileColor: _getColorFromEstatus(venta['estatus'] ?? ''),
          );
        },
      ),
    );
  }

  Color _getColorFromEstatus(String estatus) {
    switch (estatus) {
      case 'Por cumplir':
        return Colors.green;
      case 'Cancelado':
        return Colors.red;
      case 'Completado':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconFromEstatus(String estatus) {
    switch (estatus) {
      case 'Por cumplir':
        return Icons.check_circle; // Puedes cambiar el ícono a tu preferencia
      case 'Cancelado':
        return Icons.cancel;
      case 'Completado':
        return Icons.check;
      default:
        return Icons.help; // Ícono por defecto
    }
  }
}
