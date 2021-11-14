import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yea_nay/domain/models/vote_model.dart';
import 'package:yea_nay/presentation/helpers/event_helper.dart';

class VoteController extends GetxController {
  final _colection = FirebaseFirestore.instance.collection('votes');

  Future<List<VoteModel>> getPostVotes(String postId) async {
    return _colection.where('post_id', isEqualTo: postId).get().then((voteDocList) {
      List<VoteModel> voteList = [];

      for (var voteDoc in voteDocList.docs) {
        voteList.add(VoteModel.fromJson(voteDoc.data()));
      }

      return voteList;
    });
  }

  Future<List<VoteModel>> getUserVotes(String userId) async {
    return _colection.where('user_id', isEqualTo: userId).get().then((voteDocList) {
      List<VoteModel> voteList = [];

      for (var voteDoc in voteDocList.docs) {
        voteList.add(VoteModel.fromJson(voteDoc.data()));
      }

      return voteList;
    });
  }

  Future<void> submitVote({required String postId, required String value}) async {
    EventHelper.openLoadingDialog();
    _colection.add({}).then((voteDoc) async {
      await _colection.doc(voteDoc.id).set({
        'id': voteDoc.id,
        'post_id': postId,
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'value': value,
      });

      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('feeds').doc(postId).delete().then((value) {
        EventHelper.closeLoadingDialog();
      });
    });
  }
}

class VoteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VoteController());
  }
}
