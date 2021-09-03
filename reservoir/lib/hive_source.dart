import 'package:hive/hive.dart';
import 'package:collection/collection.dart';

import 'change.dart';
import 'source.dart';

class HiveSource<Record> extends Source<Record> {
  final String name;
  late final Map? defaults;

  Box<Record> get box => Hive.box<Record>(name);

  HiveSource(this.name, {this.defaults});

  // Return initial Hive box records to be used to populate Reservoir
  @override
  Iterable<Record> initialLoad() {
    var items = box.toMap();
    var merged = mergeMaps(defaults ?? {}, items,
        value: (itemValue, defaultValue) => itemValue ?? defaultValue);
    return merged.entries.map((entry) => entry.value);
  }

  @override
  Future<Change?> save(String key, Record record) async {
    var existing = box.get(key);
    if (existing == record) {
      return null;
    } else if (existing == null) {
      await box.put(key, record);
      return Added(key, record);
    } else {
      await box.put(key, record);
      return Updated(key, record);
    }
  }

  @override
  Future<Change?> remove(String key) async {
    var existing = box.get(key);
    if (existing == null) {
      return null;
    } else {
      await box.delete(key);
      return Removed(key, existing);
    }
  }
}
