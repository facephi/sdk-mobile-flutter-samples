class FlowsResult
{
  final String id;
  final String name;
  final String operationType;

  const FlowsResult({
    required this.id,
    required this.name,
    required this.operationType
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'operationType': operationType
    };
  }

  static FlowsResult fromMap(Map<dynamic, dynamic> map) {
    return FlowsResult(
        id: map['id'] ?? "",
        name: map['name'] ?? "",
        operationType: map['operationType'] ?? ""
    );
  }
}