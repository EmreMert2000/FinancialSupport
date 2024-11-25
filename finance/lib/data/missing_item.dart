class MissingItem {
  final int? id;
  final String name;

  MissingItem({this.id,required this.name});

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
