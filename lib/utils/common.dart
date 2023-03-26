import 'package:fingold/utils/config.dart';
import 'package:encrypt/encrypt.dart';

class CommonFunc {
  String encrypt(String val) {
    final plainText = val;
    final key = Key.fromUtf8(Config.edKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    //final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return encrypted.base64;
  }

  String decrypted(String val) {
    //final plainText = val;
    final key = Key.fromUtf8(Config.edKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    // final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(val), iv: iv);
    return decrypted;
  }
}
