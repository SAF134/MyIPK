import 'package:hive/hive.dart';
import '../static_database.dart';

class CourseItemAdapter extends TypeAdapter<CourseItem> {
  @override
  final int typeId = 1;

  @override
  CourseItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseItem(
      id: fields[0] as String,
      name: fields[1] as String,
      sks: fields[2] as int,
      grade: fields[3] as String,
      semester: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CourseItem obj) {
    writer
      ..writeByte(5) // number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sks)
      ..writeByte(3)
      ..write(obj.grade)
      ..writeByte(4)
      ..write(obj.semester);
  }
}
