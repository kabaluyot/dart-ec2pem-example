import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_ecdsa/CryptoUtils.dart';
import 'package:dart_ecdsa/MathUtils.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/ecc/api.dart';

void main() {
  // generate key pairs
  final AsymmetricKeyPair<PublicKey, PrivateKey> ec =
      CryptoUtils.generateEcKeyPair(curve: "secp256k1");
  final ECPrivateKey privKey = ec.privateKey as ECPrivateKey;
  final ECPublicKey pubKey = ec.publicKey as ECPublicKey;

  // convert to pem
  String privKeyPem = CryptoUtils.encodeEcPrivateKeyToPem(privKey);
  String pubKeyPem =
      CryptoUtils.encodeEcPublicKeyToPem(pubKey, curve: "secp256k1");

  print('PrivKey PEM:\n$privKeyPem');
  print('PubKey PEM:\n$pubKeyPem');

  // convert pem to base64
  String pubKeyBase64 = base64Encode(pubKeyPem.codeUnits);
  print('PubKey base64: $pubKeyBase64');

  // decode public key from prem
  final ECPublicKey decodedPubKey = CryptoUtils.ecPublicKeyFromPem(pubKeyPem);

  // sign message
  final Uint8List message = Uint8List.fromList("Hello world!".codeUnits);
  final ECSignature signature = CryptoUtils.ecSign(privKey, message,
      algorithmName: 'SHA-1/ECDSA'); // can be SHA-256/ECDSA or other
  Uint8List rUint8ListV2 = MathUtils.encodeBigInt(signature.r);
  Uint8List sUint8ListV2 = MathUtils.encodeBigInt(signature.s);
  var bbV2 = BytesBuilder();
  bbV2.add(rUint8ListV2);
  bbV2.add(sUint8ListV2);
  String encodedSignature = base64.encode(bbV2.toBytes());
  print('Signature in base64: $encodedSignature');

  // verify message using ECSignature
  bool isVerifiedByECSignature =
      CryptoUtils.ecVerify(decodedPubKey, message, signature);
  print('ECSignature verification result: $isVerifiedByECSignature');

  // verify message using Signature in Base64
  var decodedSignature = base64.decode(encodedSignature);
  BigInt r =
      MathUtils.decodeBigInt(Uint8List.sublistView(decodedSignature, 0, 32));
  BigInt s =
      MathUtils.decodeBigInt(Uint8List.sublistView(decodedSignature, 32, 64));
  ECSignature ecSignature = ECSignature(r, s);
  bool isVerifiedByBase64Signature = CryptoUtils.ecVerify(
      pubKey, message, ecSignature,
      algorithm: 'SHA-1/ECDSA'); // can be SHA-256/ECDSA or other
  print('Base64Signature verification result: $isVerifiedByBase64Signature');
}
