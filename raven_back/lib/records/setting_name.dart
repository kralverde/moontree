import 'package:hive/hive.dart';

import '_type_id.dart';

part 'setting_name.g.dart';

/// Namespace_SettingName

@HiveType(typeId: TypeId.SettingName)
enum SettingName {
  @HiveField(0)
  Electrum_Url,

  @HiveField(1)
  Electrum_Port,

  @HiveField(2)
  Account_Current,

  @HiveField(3)
  Account_Preferred,

  @HiveField(4)
  Password_SaltedHash,
}
