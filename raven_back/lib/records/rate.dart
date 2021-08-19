import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:raven/records/security.dart';

import '_type_id.dart';

part 'rate.g.dart';

@HiveType(typeId: TypeId.Rate)
class Rate with EquatableMixin {
  @HiveField(0)
  Security base;

  @HiveField(1)
  Security quote;

  @HiveField(2)
  double rate;

  Rate({
    required this.base,
    required this.quote,
    required this.rate,
  });

  @override
  List<Object?> get props => [base, quote, rate];
}
