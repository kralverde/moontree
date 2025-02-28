// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_name.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingNameAdapter extends TypeAdapter<SettingName> {
  @override
  final int typeId = 102;

  @override
  SettingName read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SettingName.Electrum_Domain0;
      case 1:
        return SettingName.Electrum_Port0;
      case 2:
        return SettingName.Electrum_Domain1;
      case 3:
        return SettingName.Electrum_Port1;
      case 4:
        return SettingName.Electrum_Domain2;
      case 5:
        return SettingName.Electrum_Port2;
      case 6:
        return SettingName.Electrum_DomainTest;
      case 7:
        return SettingName.Electrum_PortTest;
      case 8:
        return SettingName.Electrum_Net;
      case 9:
        return SettingName.Account_Current;
      case 10:
        return SettingName.Account_Preferred;
      case 11:
        return SettingName.Local_Path;
      case 12:
        return SettingName.User_Name;
      case 13:
        return SettingName.Send_Immediate;
      default:
        return SettingName.Electrum_Domain0;
    }
  }

  @override
  void write(BinaryWriter writer, SettingName obj) {
    switch (obj) {
      case SettingName.Electrum_Domain0:
        writer.writeByte(0);
        break;
      case SettingName.Electrum_Port0:
        writer.writeByte(1);
        break;
      case SettingName.Electrum_Domain1:
        writer.writeByte(2);
        break;
      case SettingName.Electrum_Port1:
        writer.writeByte(3);
        break;
      case SettingName.Electrum_Domain2:
        writer.writeByte(4);
        break;
      case SettingName.Electrum_Port2:
        writer.writeByte(5);
        break;
      case SettingName.Electrum_DomainTest:
        writer.writeByte(6);
        break;
      case SettingName.Electrum_PortTest:
        writer.writeByte(7);
        break;
      case SettingName.Electrum_Net:
        writer.writeByte(8);
        break;
      case SettingName.Account_Current:
        writer.writeByte(9);
        break;
      case SettingName.Account_Preferred:
        writer.writeByte(10);
        break;
      case SettingName.Local_Path:
        writer.writeByte(11);
        break;
      case SettingName.User_Name:
        writer.writeByte(12);
        break;
      case SettingName.Send_Immediate:
        writer.writeByte(13);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
