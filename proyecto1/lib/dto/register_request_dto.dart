import 'person_dto.dart';
import 'user_dto.dart';

class RegisterRequestDTO {
  final UserDTO userDTO;
  final PersonDTO personDTO;

  RegisterRequestDTO({required this.userDTO, required this.personDTO});

  Map<String, dynamic> toJson() => {
        // La estructura depende de cómo tu endpoint de registro espere los datos.
        // Asumo que espera dos objetos anidados: 'user' y 'person'.
        // Si la estructura es plana, esto necesitará un ajuste.
        'user': userDTO.toJson(),
        'person': personDTO.toJson(),
      };
}
