
class KeyAndValue {
  final String name;
  final String id;
  const KeyAndValue({
    required this.id,
    required this.name
    });

  KeyAndValue fromJson(Map<String, dynamic> json) => KeyAndValue(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {'name': name, 'id': id};

   @override
  String toString() {
    return  name;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is KeyAndValue
        && other.name == name
        && other.id == id;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
