import 'package:flutter/material.dart';
import 'package:pmsn2024b/database/servicio_database.dart';

class NewSalePage extends StatefulWidget {
  @override
  _NewSalePageState createState() => _NewSalePageState();
}

class _NewSalePageState extends State<NewSalePage> {
  final _formKey = GlobalKey<FormState>();
  String? _nombreCliente;
  DateTime? _fecha;
  String? _estatus = 'Por cumplir';
  int? _categoriaSeleccionada;
  int _cantidad = 1;
  List<Map<String, dynamic>> _categorias = [];
  List<Map<String, dynamic>> _bienes = [];
  
  // Controlador para el campo de fecha
  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  void _loadCategorias() async {
    // Cargar categorías desde la base de datos
    final categorias = await DBHelper().getCategorias();
    setState(() {
      _categorias = categorias;
    });
  }

  void _loadBienes(int categoriaId) async {
    // Cargar bienes de la categoría seleccionada
    final bienes = await DBHelper().getBienesPorCategoria(categoriaId);
    setState(() {
      _bienes = bienes;
    });
  }

  void _registerSale() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Aquí debes registrar la venta en la base de datos
      await DBHelper().addNewVenta(_nombreCliente!, _fecha!, _estatus!, _categoriaSeleccionada!, _cantidad.toDouble());
      // Navegar a otra pantalla o mostrar un mensaje de éxito
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Nueva Venta')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Cliente'),
                validator: (value) => value!.isEmpty ? 'Por favor ingresa un nombre' : null,
                onSaved: (value) => _nombreCliente = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha'),
                readOnly: true,
                controller: _fechaController, // Asigna el controlador aquí
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _fecha = selectedDate; // Actualiza la variable _fecha
                      _fechaController.text = selectedDate.toLocal().toString().split(' ')[0]; // Formatea y muestra la fecha
                    });
                  }
                },
                validator: (value) => _fecha == null ? 'Selecciona una fecha' : null,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Categoría'),
                items: _categorias.map((categoria) {
                  return DropdownMenuItem<int>(
                    value: categoria['id'],
                    child: Text(categoria['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaSeleccionada = value;
                    _loadBienes(value!);
                  });
                },
                validator: (value) => value == null ? 'Selecciona una categoría' : null,
              ),
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: InputDecoration(labelText: 'Bienes'),
                items: _bienes.map((bien) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: bien,
                    child: Text(bien['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  // Aquí puedes manejar la selección del bien
                },
                validator: (value) => value == null ? 'Selecciona un bien' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                initialValue: _cantidad.toString(),
                onChanged: (value) => _cantidad = int.tryParse(value) ?? 1,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerSale,
                child: Text('Registrar Venta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
