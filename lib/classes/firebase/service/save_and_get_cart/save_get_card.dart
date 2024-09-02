import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ride_card_app/classes/firebase/path/path.dart';
import 'package:ride_card_app/classes/firebase/service/save_and_get_cart/model/model.dart';

Future<dynamic> getUserSavedCardDetails(String id) async {
  final snapshot = await FirebaseFirestore.instance
      .collection(PATH_SAVED_CARD)
      .where('userId', isEqualTo: id)
      .limit(1) // Since you're expecting only one result
      .get();

  if (snapshot.docs.isNotEmpty) {
    return snapshot.docs.first.data(); // Return the document data
  } else {
    return false; // Return false if no data is found
  }
}

class SavedCardService {
  static Future<bool> saveUserCardInRealDB(CardModel card) async {
    try {
      await FirebaseFirestore.instance
          .collection(PATH_SAVED_CARD)
          .doc(card.userId)
          .set(card.toMap());

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user card: $e');
      }
      return false;
    }
  }
}
