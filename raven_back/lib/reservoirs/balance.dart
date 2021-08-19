import 'package:raven/records.dart';
import 'package:raven/records/security.dart';
import 'package:raven/reservoir/index.dart';
import 'package:raven/reservoir/reservoir.dart';

List _paramsToKey(String accountId, Security security) => [accountId, security];

class BalanceReservoir extends Reservoir<List, Balance> {
  late MultipleIndex<dynamic, Balance> byAccount;

  BalanceReservoir([source])
      : super(source ?? HiveSource('addresses'),
            (balance) => _paramsToKey(balance.accountId, balance.security)) {
    byAccount = addMultipleIndex('account', (balance) => [balance.accountId]);
  }

  Balance getRVN(String accountId) {
    var balance = get([accountId, RVN]);
    return balance ??
        Balance(
          accountId: accountId,
          security: RVN,
          confirmed: 0,
          unconfirmed: 0,
        );
  }
}
