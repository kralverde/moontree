/// for translating qrcode URI
import 'package:raven_front/utils/params.dart';

class QRData {
  final String? address;
  final String? addressName;
  final String? amount;
  final String? note;
  final String? symbol;

  QRData({
    required this.address,
    required this.addressName,
    required this.amount,
    required this.note,
    required this.symbol,
  });
}

QRData populateFromQR(
    {required String code, List<dynamic>? holdings, String? currentSymbol}) {
  var address;
  var addressName;
  var amount;
  var note;
  var symbol;
  if (code.startsWith('raven:')) {
    address = code.substring(6).split('?')[0];
    var params = parseReceiveParams(code);
    if (params.containsKey('to')) {
      addressName = cleanLabel(params['to']!);
    }
    if (params.containsKey('amount')) {
      amount = cleanDecAmount(params['amount']!);
    }
    if (params.containsKey('label')) {
      note = cleanLabel(params['label']!);
    }
    if (holdings != null) {
      symbol =
          requestedAsset(params, holdings: holdings, current: currentSymbol);
    }
  } else {
    if (code != '') {
      address = code;
    }
  }
  return QRData(
      address: address,
      addressName: addressName,
      amount: amount,
      note: note,
      symbol: symbol);
}
