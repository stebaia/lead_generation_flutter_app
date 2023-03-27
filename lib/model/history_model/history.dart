class History {
  final String check;
  final String description;
  final String data;
  final String gate;

  History(
      {required this.check,
      required this.description,
      required this.data,
      required this.gate});

  factory History.fromMap(Map<String, dynamic> json) => History(
      check: json['check'],
      description: json['description'],
      data: json['data'],
      gate: json['gate']);

  Map<String, dynamic> toMap() {
    return {
      'check': check,
      'description': description,
      'data': data,
      'gate': gate
    };
  }
}
