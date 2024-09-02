import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class MyData extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String role;

  MyData(this.userId, this.role);
}

class MyDataAdapter extends TypeAdapter<MyData> {
  @override
  final int typeId = 0;

  @override
  MyData read(BinaryReader reader) {
    final userId = reader.readString();
    final userName = reader.readString();
    return MyData(userId, userName);
  }

  @override
  void write(BinaryWriter writer, MyData obj) {
    writer.writeString(obj.userId);
    writer.writeString(obj.role);
  }
}
