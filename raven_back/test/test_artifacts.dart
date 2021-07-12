// dart --no-sound-null-safety test test/raven_tx_test.dart
import 'package:bip39/bip39.dart' as bip39;

import 'package:raven_electrum_client/raven_electrum_client.dart';

import 'package:raven/raven_networks.dart';
import 'package:raven/account.dart';
import 'package:raven/env.dart' as env;
import 'package:raven/boxes.dart' as memory;

class Generated {
  String phrase;
  Account account;
  RavenElectrumClient client;
  memory.Truth truth;
  Generated(this.phrase, this.account, this.client, this.truth);
}

Future<Generated> generate() async {
  var truth = memory.Truth.instance;
  await truth.open();
  var phrase = await env.getMnemonic();
  var account =
      Account.bySeed(ravencoinTestnet, seed: bip39.mnemonicToSeed(phrase));
  var client = await RavenElectrumClient.connect('testnet.rvn.rocks');
  await truth.saveAccount(account);
  return Generated(phrase, account, client, truth);
}


//Future<Generated> generateFromMemory() async {
//  var truth = memory.Truth.instance;
//  var account = Account(ravencoinTestnet, seed: truth.boxes['accounts']['seed']);
//  var client = await ElectrumClient.connect('testnet.rvn.rocks');
//  await truth.saveAccount(account);
//  await account.deriveNodes(client);
//  await truth.saveAccountBalance(account);
//  return Generated(phrase, account, client);
//}