class PersonDTO {
  final int documentNumber;
  final String firstName;
  final String? secondName;
  final String firstLastName;
  final String? secondLastName;
  final int phoneNumber;
  final String? bornDate; // Formato YYYY-MM-DD
  final int documentTypeId; // Solo el ID del tipo de documento

  PersonDTO({
    required this.documentNumber,
    required this.firstName,
    this.secondName,
    required this.firstLastName,
    this.secondLastName,
    required this.phoneNumber,
    this.bornDate,
    required this.documentTypeId,
  });

  Map<String, dynamic> toJson() => {
        'documentNumber': documentNumber,
        'firstName': firstName,
        'secondName': secondName,
        'firstLastName': firstLastName,
        'secondLastName': secondLastName,
        'phoneNumber': phoneNumber,
        'bornDate': bornDate,
        'documentTypeId': documentTypeId, // Corregido para enviar solo el ID
      };
}
