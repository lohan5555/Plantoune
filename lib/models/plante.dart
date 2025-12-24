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
