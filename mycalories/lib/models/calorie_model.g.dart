// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calorie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodItemAdapter extends TypeAdapter<FoodItem> {
  @override
  final int typeId = 1;

  @override
  FoodItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodItem(
      name: fields[0] as String,
      calories: fields[1] as int,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.calories)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 2;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      dailyTarget: fields[0] as int,
      fastingStartTime: fields[1] as DateTime?,
      fastingTargetHours: fields[2] as int,
      userName: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dailyTarget)
      ..writeByte(1)
      ..write(obj.fastingStartTime)
      ..writeByte(2)
      ..write(obj.fastingTargetHours)
      ..writeByte(3)
      ..write(obj.userName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FastingTaskAdapter extends TypeAdapter<FastingTask> {
  @override
  final int typeId = 3;

  @override
  FastingTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FastingTask(
      title: fields[0] as String,
      isCompleted: fields[1] as bool,
      date: fields[2] as DateTime,
      targetTime: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FastingTask obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.targetTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastingTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
