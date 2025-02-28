import 'package:raven_back/records/node_exposure.dart';
import 'package:test/test.dart';
import 'package:raven_back/utils/derivation_path.dart';

void main() {
  test('derive', () {
    expect(getDerivationPath(0), "m/44'/175'/0'/0/0");
    expect(getDerivationPath(0, exposure: NodeExposure.External),
        "m/44'/175'/0'/0/0");
    expect(getDerivationPath(0, exposure: NodeExposure.Internal),
        "m/44'/175'/0'/1/0");
    expect(getDerivationPath(1, exposure: NodeExposure.Internal),
        "m/44'/175'/0'/1/1");
  });
}
