// dart --sound-null-safety test test/integration/account_test.dart --concurrency=1 --chain-stack-traces
import 'package:raven_back/utils/exceptions.dart';
import 'package:test/test.dart';

void main() async {
  var gen;
  setUpAll(() async {
    // 1. mock account
    // 2. mock wallet
    // 3. mock address
    // 2. mock histories
  });
  tearDownAll(() async {});

  test('getBalance', () async {
    expect((gen.account.accountInternals.isEmpty), false);
    var balance = gen.account.getBalance();
    print('balance = $balance');
    expect((balance > 0), true);
  });

  test('collectUTXOs for amount smaller than smallest UTXO', () {
    var utxos = gen.account.collectUTXOs(100);
    expect(utxos.length, 1);
    expect(utxos[0].value, 4000000);
  });

  test('collectUTXOs for amount just smaller than largest UTXO', () {
    var utxos = gen.account.collectUTXOs(5000087912000 - 1);
    expect(utxos.length, 1);
    expect(utxos[0].value, 5000087912000);
  });

  test('collectUTXOs for amount larger than largest UTXO', () {
    var utxos = gen.account.collectUTXOs(5000087912000 + 1);
    expect(utxos.length, 2);
    expect(utxos[0].value + utxos[1].value, 5000087912000 + 4000000);
  });

  test('collectUTXOs for amount more than we have', () {
    try {
      var utxos = gen.account.collectUTXOs(5000087912000 * 2);
      expect(utxos, []);
    } on InsufficientFunds catch (e) {
      print(e);
    }
  });
}
