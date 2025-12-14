class TipoDocumentoDTO {
  final int id;
  final String documentName;

  TipoDocumentoDTO({required this.id, required this.documentName});

  factory TipoDocumentoDTO.fromJson(Map<String, dynamic> json) {
    return TipoDocumentoDTO(
      id: json['id'],
      documentName: json['documentName'],
    );
  }
}
