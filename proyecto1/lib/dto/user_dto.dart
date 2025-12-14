class UserDTO {
  final String login;
  final String email;
  final String password;

  UserDTO({
    required this.login,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'login': login,
        'email': email,
        'password': password,
        // El backend puede requerir otros campos por defecto
        'langKey': 'es', // Ejemplo: establecer un idioma por defecto
      };
}
