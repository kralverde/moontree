// dart --no-sound-null-safety test test/account_test.dart
import 'package:test/test.dart';

import 'package:bip39/bip39.dart' as bip39;

import 'package:raven/env.dart' as env;
import 'package:raven/account.dart';
import 'package:raven/test_artifacts.dart' as tests;
import 'package:raven/raven_networks.dart';
import 'package:raven/electrum_client.dart';
import 'package:raven/electrum_client/connect.dart';

class Generated {
  String phrase;
  Account account;
  ElectrumClient client;
  Generated(this.phrase, this.account, this.client);
}

Future<Generated> generate() async {
  var phrase = await env.getMnemonic();
  var account = Account(ravencoinTestnet, seed: bip39.mnemonicToSeed(phrase));
  var client = ElectrumClient(await connect('testnet.rvn.rocks'));
  await client.serverVersion(protocolVersion: '1.8');
  await account.deriveNodes(client);
  return Generated(phrase, account, client);
}

void main() async {
  var gen = await tests.generate();

  test('getBalance', () async {
    expect((gen.account.internals.isEmpty), false);
    var balance = gen.account.getBalance();
    if (gen.phrase.startsWith('smile')) {
      expect(balance, 0.0);
    } else {
      expect((balance > 0), true);
    }
  });

  test('collectUTXOs for amount smaller than smallest UTXO', () {
    var utxos = gen.account.collectUTXOs(100);
    expect(utxos.length, 1);
    expect(utxos[0].unspent.value, 4000000);
  });

  test('collectUTXOs for amount just smaller than largest UTXO', () {
    var utxos = gen.account.collectUTXOs(5000087912000 - 1);
    expect(utxos.length, 1);
    expect(utxos[0].unspent.value, 5000087912000);
  });

  test('collectUTXOs for amount larger than largest UTXO', () {
    var utxos = gen.account.collectUTXOs(5000087912000 + 1);
    expect(utxos.length, 2);
    expect(utxos[0].unspent.value + utxos[1].unspent.value,
        5000087912000 + 4000000);
  });

  test('collectUTXOs for amount more than we have', () {
    try {
      var utxos = gen.account.collectUTXOs(5000087912000 * 2);
      expect(utxos, []);
    } on InsufficientFunds catch (e) {
      //print(e);
    }
  });
}
