class MyInfoModel {
  final int id;
  final String name;
  final String job;
  final int age;

  MyInfoModel({
    required this.id,
    required this.name,
    required this.job,
    required this.age,
  });

  factory MyInfoModel.fromJson(Map<String, dynamic> json) {
    return MyInfoModel(
      id: json['id'],
      name: json['name'] ?? '',
      job: json['job'] ?? '',
      age: json['age'] ?? 0,
    );
  }

  factory MyInfoModel.defaultMyInfo() {
    return MyInfoModel(
      id: 0,
      name: 'Ahmed Reda',
      job: 'Back end Developer',
      age: 25,
    );
  }
}
