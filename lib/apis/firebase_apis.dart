import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foundation/model/coffee.dart';
import 'package:serverless_app/utils.dart';

class FirebaseApi {
  static Stream<List<Coffee>> getCoffee() {
    print("Call getCoffee");
    var coffee = FirebaseFirestore.instance
        .collection('coffee')
        .orderBy('stock', descending: true);
    return coffee.snapshots().transform(Utils.transformer(Coffee.fromJson));
  }

  static Future<String> validateUser(String userId) async {
    print("Call validateUser: " + userId);
    String name = "";
    var users = FirebaseFirestore.instance.collection('users');
    await users
        .where('user_id', isEqualTo: userId)
        .get()
        .then((QuerySnapshot value) {
      for (var doc in value.docs) {
        name = doc["name"];
      }
    });
    return name;
  }

  static Future updateStock(Map<String, num> cart) async {
    print("Call updateStock: ");
    cart.forEach((key, orderedStock) {
      if (orderedStock > 0) {
        var coffee = FirebaseFirestore.instance.collection('coffee');
        coffee.where('name', isEqualTo: key).get().then((value) {
          String uid = "";
          num stock = 0;
          for (var doc in value.docs) {
            uid = doc.id;
            stock = doc['stock'];
          }
          coffee.doc(uid).update({'stock': (stock - orderedStock)});
        });
      }
    });
  }

  // static Future uploadMessage(String idUser, String message) async {
  //   final refMessages =
  //       FirebaseFirestore.instance.collection('chats/$idUser/messages');

  //   final newMessage = Message(
  //     idUser: myId,
  //     urlAvatar: myUrlAvatar,
  //     username: myUsername,
  //     message: message,
  //     createdAt: DateTime.now(),
  //   );
  //   await refMessages.add(newMessage.toJson());

  //   final refUsers = FirebaseFirestore.instance.collection('users');
  //   await refUsers
  //       .doc(idUser)
  //       .update({UserField.lastMessageTime: DateTime.now()});
  // }

  // static Stream<List<Message>> getMessages(String idUser) =>
  //     FirebaseFirestore.instance
  //         .collection('chats/$idUser/messages')
  //         .orderBy(MessageField.createdAt, descending: true)
  //         .snapshots()
  //         .transform(Utils.transformer(Message.fromJson));

  // static Future addRandomUsers(List<User> users) async {
  //   final refUsers = FirebaseFirestore.instance.collection('users');

  //   final allUsers = await refUsers.get();
  //   if (allUsers.size != 0) {
  //     return;
  //   } else {
  //     for (final user in users) {
  //       final userDoc = refUsers.doc();
  //       final newUser = user.copyWith(idUser: userDoc.id);

  //       await userDoc.set(newUser.toJson());
  //     }
  //   }
  // }
}
