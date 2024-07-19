import 'package:hive/hive.dart';

part 'milestone.g.dart';

@HiveType(typeId: 0)
class Milestone extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime date;

  Milestone({required this.title, required this.date});

 
    // Implement the delete logic here
  }



