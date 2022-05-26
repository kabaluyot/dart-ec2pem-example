import 'dart:typed_data';

class MathUtils {
  // http://phoenix.yizimg.com/ethereumdart/rlp/blob/master/lib/src/pointycastle-utils.dart
  /// Decode a BigInt from bytes in big-endian encoding.
  static BigInt decodeBigInt(List<int> bytes) {
    BigInt result = new BigInt.from(0);
    for (int i = 0; i < bytes.length; i++) {
      result += new BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  /// Encode a BigInt into bytes using big-endian encoding.
  static Uint8List encodeBigInt(BigInt number) {
    final _byteMask = BigInt.from(0xff);

    // Not handling negative numbers. Decide how you want to do that.
    int size = (number.bitLength + 7) >> 3;
    var result = new Uint8List(size);
    for (int i = 0; i < size; i++) {
      result[size - i - 1] = (number & _byteMask).toInt();
      number = number >> 8;
    }
    return result;
  }
}
