import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:proyecto1/dto/person_dto.dart';
import 'package:proyecto1/dto/register_request_dto.dart';
import 'package:proyecto1/dto/tipo_documento_dto.dart';
import 'package:proyecto1/dto/user_dto.dart';
import 'package:proyecto1/pages/login_page.dart';
import 'package:proyecto1/services/api_service.dart';

const Color primaryBlue = Color(0xFF0A2342);

class RegisterFormPage extends StatefulWidget {
  final String email;
  final String password;

  const RegisterFormPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  bool _isLoading = false;

  // Controladores para el formulario de persona
  final TextEditingController documentNumberController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController firstLastNameController = TextEditingController();
  final TextEditingController secondLastNameController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController bornDateController = TextEditingController();

  // Para el dropdown de tipo de documento
  List<TipoDocumentoDTO> _tiposDocumento = [];
  int? _selectedDocumentTypeId;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDocumentTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona un tipo de documento'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 1. Crear los DTOs
    final userDTO = UserDTO(
      login: widget.email, // Usar el email como login
      email: widget.email,
      password: widget.password,
    );

    final personDTO = PersonDTO(
      documentNumber: int.parse(documentNumberController.text),
      firstName: firstNameController.text,
      secondName: secondNameController.text.isNotEmpty
          ? secondNameController.text
          : null,
      firstLastName: firstLastNameController.text,
      secondLastName: secondLastNameController.text.isNotEmpty
          ? secondLastNameController.text
          : null,
      phoneNumber: int.parse(phoneNumberController.text),
      bornDate: bornDateController.text.isNotEmpty
          ? bornDateController.text
          : null,
      documentTypeId: _selectedDocumentTypeId!,
    );

    final registerRequest = RegisterRequestDTO(
      userDTO: userDTO,
      personDTO: personDTO,
    );

    // --- LOGS DE DEPURACIÓN ---
    debugPrint(
      "ID de tipo de documento seleccionado: $_selectedDocumentTypeId",
    );
    debugPrint(
      "Cuerpo de la petición a enviar: ${jsonEncode(registerRequest.toJson())}",
    );
    // -------------------------

    // 2. Llamar al servicio de API
    final success = await apiService.register(registerRequest);

    setState(() {
      _isLoading = false;
    });

    // 3. Manejar la respuesta
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Registro exitoso! Ahora puedes iniciar sesión.'),
          backgroundColor: Colors.green,
        ),
      );
      // Navegar a la página de login, limpiando las rutas anteriores
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error en el registro. Verifica tus datos o inténtalo más tarde.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTiposDocumento();
  }

  Future<void> _loadTiposDocumento() async {
    final data = await apiService.getTipoDocumentos();
    setState(() {
      _tiposDocumento = data;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        bornDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Completa tu Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Datos Personales',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: firstNameController,
                label: 'Primer Nombre',
                icon: Icons.person_outline,
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: secondNameController,
                label: 'Segundo Nombre (Opcional)',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: firstLastNameController,
                label: 'Primer Apellido',
                icon: Icons.person_outline,
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: secondLastNameController,
                label: 'Segundo Apellido (Opcional)',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: documentNumberController,
                label: 'Número de Documento',
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              _tiposDocumento.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<int>(
                      initialValue: _selectedDocumentTypeId,
                      hint: const Text('Tipo de Documento'),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.credit_card,
                          color: primaryBlue,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _tiposDocumento.map((tipo) {
                        return DropdownMenuItem<int>(
                          value: tipo.id,
                          child: Text(tipo.documentName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDocumentTypeId = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Campo obligatorio' : null,
                    ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: phoneNumberController,
                label: 'Número de Teléfono',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: bornDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: primaryBlue,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Finalizar Registro',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryBlue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
}
