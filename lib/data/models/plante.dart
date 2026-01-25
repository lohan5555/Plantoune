class Plante {
  final int? id;
  final String name;
  final String? text;
  final double? latitude;
  final double? longitude;
  final String? imagePath;

  const Plante(
      {
        this.id,
        required this.name,
        this.text,
        this.latitude,
        this.longitude,
        this.imagePath
      }
  );

  //modele de copy pour une modification propre
  Plante copyWith({
    String? name,
    String? text,
    String? imagePath,
    double? latitude,
    double? longitude,
  }) {
    return Plante(
      id: id,
      name: name ?? this.name,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'text': text,
      'latitude': latitude,
      'longitude': longitude,
      'imagePath': imagePath
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, text: $text, latitude: $latitude, '
        'longitude: $longitude, imagePath: $imagePath}';
  }
}
