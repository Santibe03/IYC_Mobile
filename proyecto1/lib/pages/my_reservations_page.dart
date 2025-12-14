import 'package:flutter/material.dart';
import 'package:proyecto1/services/api_service.dart';
import 'package:proyecto1/pages/reservation_form_page.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  final ApiService _apiService = ApiService();
  // removed controller
  List<dynamic> _reservations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() async {
    final personId = ApiService.currentPersonId;

    if (personId == null) {
      // Si no hay ID de usuario (no logueado o error), mostrar aviso
      setState(() {
        _isLoading = false;
      });
      // Small delay to ensure build is complete before snackbar
      await Future.delayed(Duration(milliseconds: 100));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No se identificó al usuario. Inicia sesión."),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final results = await _apiService.getReservationsByPerson(personId);

    if (mounted) {
      setState(() {
        _reservations = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        title: const Text("Mis Reservaciones"),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Eliminated manual search field

            // List of results
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _reservations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            ApiService.currentPersonId == null
                                ? "Inicia sesión para ver tus reservas."
                                : "No tienes reservaciones aún.",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _reservations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final res = _reservations[index];
                        final String date =
                            res['reservationDate'] ?? "Sin fecha";
                        final String status = res['condition'] ?? "UNKNOWN";

                        Color statusColor;
                        if (status == "CONFIRMED") {
                          statusColor = Colors.green;
                        } else if (status == "CANCELLED")
                          statusColor = Colors.red;
                        else
                          statusColor = Colors.orange;

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(
                                0xFF0A2342,
                              ).withOpacity(0.1),
                              child: const Icon(
                                Icons.event_seat,
                                color: Color(0xFF0A2342),
                              ),
                            ),
                            title: Text(
                              "Reserva Mesa #${res['barTableId']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  "Fecha: ${date.contains('T') ? date.split('T')[0] : date}",
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editReservation(res);
                                } else if (value == 'cancel') {
                                  _cancelReservation(res['id']);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        title: Text('Editar'),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'cancel',
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                        title: Text('Cancelar'),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ],
                              icon: const Icon(Icons.more_vert),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _editReservation(Map<String, dynamic> reservation) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationFormPage(preFilledData: reservation),
      ),
    );

    if (result == true) {
      _loadReservations(); // Refrescar lista si se editó
    }
  }

  void _cancelReservation(int id) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Cancelación"),
        content: const Text(
          "¿Estás seguro de que deseas cancelar esta reserva?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sí", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      bool success = await _apiService.cancelReservation(id);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Reserva cancelada.")));
          _loadReservations(); // Refrescar lista
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Error al cancelar.")));
        }
      }
    }
  }
}
