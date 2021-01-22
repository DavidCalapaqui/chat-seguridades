import 'package:encrypt/encrypt.dart';

String Desencriptar(String texto) {
    final plainText = texto;
    final key = Key.fromUtf8('dairsanchez_davidcalapaqui_2064_');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt16(plainText, iv: iv);
    return decrypted;
}

String Encriptar(String texto) {
  final plainText = texto;
  final key = Key.fromUtf8('dairsanchez_davidcalapaqui_2064_');
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base16;
}