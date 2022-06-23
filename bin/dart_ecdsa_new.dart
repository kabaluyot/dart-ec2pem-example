import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';

void main() {
  var ec = getS256();

  // generate secp256k1 key pair
  // print('---generated key pair---');
  // var priv = ec.generatePrivateKey();
  // var pub = priv.publicKey;

  // hex to key pair (for importing)
  print('---hex to key pair---');
  var priv = PrivateKey.fromHex(ec,
      'd04b6af44bdaca5a3dd10f33572bd917def5697f72823213c8e8da5d07cff7f4'); // sample private key
  var pub = priv.publicKey;

  print('private key: ${priv.toString()}'); // raw hex encoded private key
  print('public key: ${pub.toString()}'); // raw hex encoded public key

  var hashHex = sha256
      .convert(utf8.encode(
          '{"amount":60000,"login_token":"lt_5dpm7sdc4xk7tbm5","to":"stuart@coinmode.com","to_type":"email","wallet":"gbpx_main"}'))
      .toString(); // hash of message to be signed

  var hash = List<int>.generate(hashHex.length ~/ 2,
      (i) => int.parse(hashHex.substring(i * 2, i * 2 + 2), radix: 16));
  var sig = signature(priv, hash);
  print('signature: ${sig.toDERHex()}'); // signature in hex

  var result = verify(pub, hash, sig);
  print('verification result: $result');
}
