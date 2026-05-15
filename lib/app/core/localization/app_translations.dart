import 'package:get/get.dart';
import 'bn_bd.dart';
import 'en_us.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'bn_BD': bnBd,
      };
}
