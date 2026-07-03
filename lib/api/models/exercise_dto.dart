class ExerciseDto {
  const ExerciseDto({
    required this.name,
    required this.type,
    required this.muscle,
    required this.difficulty,
    this.equipments,
  });

  final String name;
  final String type;
  final String muscle;
  final String difficulty;
  final List<String>? equipments;

  factory ExerciseDto.fromJson(Map<String, dynamic> json) {
    return ExerciseDto(
      name: json['name'] as String,
      type: json['type'] as String,
      muscle: json['muscle'] as String,
      difficulty: json['difficulty'] as String,
      equipments: (json['equipments'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
    );
  }
}
