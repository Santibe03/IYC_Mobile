import 'package:flutter/material.dart';

class ReservationFormPage extends StatefulWidget {
  const ReservationFormPage({super.key});

  @override
  State<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  // Controladores
  final TextEditingController documentoCtrl = TextEditingController();
  final TextEditingController primerNombreCtrl = TextEditingController();
  final TextEditingController primerApellidoCtrl = TextEditingController();
  final TextEditingController telefonoCtrl = TextEditingController();
  final TextEditingController asistentesCtrl = TextEditingController();

  final TextEditingController fechaReservaCtrl = TextEditingController();
  final TextEditingController fechaEventoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // ✔ Fecha de reserva predeterminada: HOY
    fechaReservaCtrl.text = DateTime.now().toIso8601String();
  }

  // Selector para fecha del evento (solo fechas futuras)
  Future<void> _selectEventDate() async {
    DateTime today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,          // ✔ No permite fechas anteriores
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      fechaEventoCtrl.text = picked.toIso8601String();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        title: const Text("Reservar Mesa"),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Formulario de Reserva",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _buildTextField("Número de documento", documentoCtrl,
                keyboard: TextInputType.number),

            const SizedBox(height: 15),

            _buildTextField("Primer nombre", primerNombreCtrl),

            const SizedBox(height: 15),

            _buildTextField("Primer apellido", primerApellidoCtrl),

            const SizedBox(height: 15),

            _buildTextField("Número de teléfono", telefonoCtrl,
                keyboard: TextInputType.number),

            const SizedBox(height: 15),

            // ✔ Fecha de Reserva (solo lectura)
            TextField(
              controller: fechaReservaCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Fecha de reserva (automática)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ✔ Fecha evento (solo fechas futuras)
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

            _buildTextField("Número de personas", asistentesCtrl,
                keyboard: TextInputType.number),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2342),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                foregroundColor: Colors.white,
              ),
              child: const Text("Enviar Reserva"),
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

  void _submitForm() {
    final data = {
      "aplicationDate": DateTime.now().toIso8601String(),
      "reservationDate": fechaReservaCtrl.text,
      "attendat": int.tryParse(asistentesCtrl.text) ?? 0,
      "person": {
        "documentNumber": int.tryParse(documentoCtrl.text) ?? 0,
        "firstName": primerNombreCtrl.text,
        "firstLastName": primerApellidoCtrl.text,
        "phoneNumber": int.tryParse(telefonoCtrl.text) ?? 0,
      },
      "barraMesa": {
        "id": 0,
      }
    };

    print(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reserva lista para enviar")),
    );
  }
}
