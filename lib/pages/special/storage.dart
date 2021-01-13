import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/esp-ip.txt');
  }

  Future<String> readEspIp() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } catch (e) {
      return "";
    }
  }

  Future<File> writeEspIp(String ip) async {
    final file = await _localFile;
    return file.writeAsString(ip);
  }
}