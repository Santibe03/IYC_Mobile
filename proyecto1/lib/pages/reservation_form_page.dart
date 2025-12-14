import 'package:flutter/material.dart';
import 'package:proyecto1/services/api_service.dart';

class ReservationFormPage extends StatefulWidget {
  final Map<String, dynamic>? preFilledData;

  const ReservationFormPage({super.key, this.preFilledData});

  @override
  State<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final ApiService _apiService = ApiService(); // Servicio API

  // Controladores
  final TextEditingController mesaIdCtrl = TextEditingController();
  final TextEditingController asistentesCtrl = TextEditingController();

  final TextEditingController fechaReservaCtrl = TextEditingController();
  final TextEditingController fechaEventoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fecha de reserva predeterminada: HOY
    fechaReservaCtrl.text = DateTime.now().toIso8601String();

    if (widget.preFilledData != null) {
      _loadData();
    }
  }

  void _loadData() {
    final data = widget.preFilledData!;
    mesaIdCtrl.text = data['barTableId']?.toString() ?? '';
    asistentesCtrl.text = data['attendat']?.toString() ?? '';
    fechaEventoCtrl.text = data['reservationDate'] ?? '';
  }

  // Selector para fecha y hora del evento
  Future<void> _selectEventDate() async {
    DateTime now = DateTime.now();

    // 1. Seleccionar Fecha
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      if (!mounted) return;

      // 2. Seleccionar Hora
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // 3. Combinar Fecha y Hora
        final DateTime eventDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // 4. Convertir a ISO 8601 UTC (Backend espera ZonedDateTime)
        // Ejemplo: 2025-12-24T18:30:00.000Z
        fechaEventoCtrl.text = eventDateTime.toUtc().toIso8601String();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.preFilledData != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        title: Text(isEditing ? "Editar Reserva" : "Reservar Mesa"),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              isEditing ? "Modificar Reserva" : "Formulario de Reserva",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildTextField(
              "ID de Mesa",
              mesaIdCtrl,
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 15),

            // Fecha de Reserva (automática)
            TextField(
              controller: fechaReservaCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Fecha de reserva (automática)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Fecha evento
            TextField(
              controller: fechaEventoCtrl,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Fecha del evento",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectEventDate,
                ),
              ),
            ),
            const SizedBox(height: 15),

            _buildTextField(
              "Número de personas",
              asistentesCtrl,
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2342),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                foregroundColor: Colors.white,
              ),
              child: Text(isEditing ? "Actualizar Reserva" : "Enviar Reserva"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _submitForm() async {
    // Validar campos básicos
    if (mesaIdCtrl.text.isEmpty || fechaEventoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor complete todos los campos")),
      );
      return;
    }

    final data = {
      "personId": widget.preFilledData != null
          ? widget.preFilledData!['personId']
          : ApiService.currentPersonId ?? 0,
      "barTableId": int.tryParse(mesaIdCtrl.text) ?? 0,
      // Enviar solo fecha YYYY-MM-DD
      "reservationDate": fechaEventoCtrl.text, // ZonedDateTime
      "attendat": int.tryParse(asistentesCtrl.text) ?? 1,
      "condition": "PENDING",
    };

    if (widget.preFilledData == null) {
      // CREAR
      data["aplicationDate"] = DateTime.now().toIso8601String().split('T')[0];
      print("Enviando reserva: $data");
      bool success = await _apiService.createReservation(data);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("¡Reserva creada con éxito!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al crear la reserva")),
          );
        }
      }
    } else {
      // ACTUALIZAR
      int id = widget.preFilledData!['id'];
      data['id'] = id; // Asegurar ID
      data['condition'] = widget.preFilledData!['condition']; // Mantener estado
      // No re-enviamos aplicationDate necesariamente, pero el backend lo mantiene si no lo mandamos

      print("Actualizando reserva $id: $data");
      bool success = await _apiService.updateReservation(id, data);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("¡Reserva actualizada con éxito!")),
          );
          Navigator.pop(context, true); // Retornar true para recargar lista
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al actualizar la reserva")),
          );
        }
      }
    }
  }
}
