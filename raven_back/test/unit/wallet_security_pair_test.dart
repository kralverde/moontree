// dart --sound-null-safety test test/integration/account_test.dart --concurrency=1 --chain-stack-traces
import 'package:raven_back/records/records.dart';
import 'package:raven_back/records/security.dart';
import 'package:reservoir/change.dart';
import 'package:test/test.dart';

import 'package:raven_back/services/wallet_security_pair.dart';

import '../fixtures/fixtures.dart' as fixtures;

void main() async {
  setUp(fixtures.useFixtureSources1);

  test('WalletSecurityPair is unique in Set', () {
    var s = <WalletSecurityPair>{};
    var wallet = fixtures.wallets['0']!; // from old map sources...
    var pair = WalletSecurityPair(
        wallet, Security(symbol: 'RVN', securityType: SecurityType.Crypto));
    s.add(pair);
    s.add(pair);
    expect(s.length, 1);
  });

  test('securityPairsFromVoutChanges', () {
    var wallet = fixtures.wallets['0']!;
    var changes = [
      Added(0, histories().map['0']),
      Added(1, histories().map['1']),
      Updated(0, histories().map['0'])
    ];
    var pairs = securityPairsFromVoutChanges(changes);
    expect(pairs, {
      WalletSecurityPair(wallet, res.securities.RVN),
      WalletSecurityPair(wallet, res.securities.USD),
    });
  });
}
