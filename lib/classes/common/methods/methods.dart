import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

clearCache() {
  debugPrint('========');
  debugPrint('=======');
  debugPrint('======');
  debugPrint('=====');
  debugPrint('====');
  debugPrint('===');
  debugPrint('==');
  debugPrint('= CLEARED =');
  debugPrint('==');
  debugPrint('===');
  debugPrint('====');
  debugPrint('=====');
  debugPrint('======');
  debugPrint('=======');
  DefaultCacheManager manager = DefaultCacheManager();
  manager.emptyCache();
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut().then((value) => {
        //
      });
}
