import 'dart:convert';

import 'package:dart_ecdsa/CryptoUtils.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/ecc/api.dart';

void main() {
  // generate key pairs
  final AsymmetricKeyPair<PublicKey, PrivateKey> ec =
      CryptoUtils.generateEcKeyPair(curve: "secp256k1");
  final ECPrivateKey privKey = ec.privateKey as ECPrivateKey;
  final ECPublicKey pubKey = ec.publicKey as ECPublicKey;
  var a = pubKey;

  // convert to pem
  String privKeyPem = CryptoUtils.encodeEcPrivateKeyToPem(privKey);
  String pubKeyPem =
      CryptoUtils.encodeEcPublicKeyToPem(pubKey, curve: "secp256k1");

  print('PrivKey PEM:\n$privKeyPem');
  print('PubKey PEM:\n$pubKeyPem');

  // convert pem to base64
  String pubKeyBase64 = base64Encode(pubKeyPem.codeUnits);
  print('PubKey base64: $pubKeyBase64');
}
