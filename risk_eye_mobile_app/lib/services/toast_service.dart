import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static Future<bool?> showToast(String msg) {
    return Fluttertoast.showToast(msg: msg);
  }
}
