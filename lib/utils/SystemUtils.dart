import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_im/common/Application.dart';
import 'package:flutter_im/provider/AppStateProvide.dart';
import 'package:flutter_im/router/MyRouter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class SystemUtils {
  static StreamSubscription<ConnectivityResult> _connectivitySubscription;

  static void scrollToBottom(ScrollController scrollController) {
    Timer(Duration(milliseconds: 100), () => scrollController.jumpTo(scrollController.position.maxScrollExtent));
  }

  static Future hideKeyBoard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
  static Future showKeyBoard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.show');
  }
  static Future vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 100, amplitude: 200);
    }
  }

  //网络初始状态
  static void connectivityInitState(){
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          print(result.toString());
          if(result == ConnectivityResult.none){
            Provider.of<AppStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).changeHomeTitle(Application.TITLE_CONNECT_FAILED);
          } else {
            Provider.of<AppStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).changeHomeTitle(Application.TITLE_CONNECT);
          }
        });
  }

  //网络进行监听
  static Future<Null> initConnectivity() async {
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
    try {
      ConnectivityResult connectionStatus = (await Connectivity().checkConnectivity());
      print(connectionStatus.toString());
      if (connectionStatus == ConnectivityResult.none) {
        Provider.of<AppStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).changeHomeTitle(Application.TITLE_CONNECT_FAILED);
      } else {
        Provider.of<AppStateProvide>(MyRouter.navigatorKey.currentContext, listen: false).changeHomeTitle(Application.TITLE_CONNECT);
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  //网络结束监听
  static void connectivityDispose(){
    _connectivitySubscription.cancel();
  }

  static Future<PickedFile> onImageButtonPressed(ImageSource source,
      {BuildContext context}) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 300,
        maxHeight: 300,
      );
      return pickedFile;
    } catch (e) {
      return null;
    }
  }

  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      {int bitLength = 512}) {
    // Create an RSA key generator and initialize it
    SecureRandom secureRandom = _exampleSecureRandom();
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom));

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  static SecureRandom _exampleSecureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }

  static Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  static Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

    return _processInBlocks(decryptor, cipherText);
  }

  static Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

}