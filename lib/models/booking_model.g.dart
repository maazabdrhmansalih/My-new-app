// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingModelAdapter extends TypeAdapter<BookingModel> {
  @override
  final int typeId = 1;

  @override
  BookingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingModel(
      status:  fields[10] as String,
      id: fields[0] as String,
      userId: fields[1] as String,
      userName: fields[2] as String,
      staffId: fields[3] as String,
      staffName: fields[4] as String,
      serviceId: fields[5] as String,
      serviceName: fields[6] as String,
      date: fields[7] as String,
      time: fields[8] as String,
      duration: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BookingModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.userName)
      ..writeByte(3)
      ..write(obj.staffId)
      ..writeByte(4)
      ..write(obj.staffName)
      ..writeByte(5)
      ..write(obj.serviceId)
      ..writeByte(6)
      ..write(obj.serviceName)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.time)
      ..writeByte(9)
      ..write(obj.duration)
      ..writeByte(10)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
