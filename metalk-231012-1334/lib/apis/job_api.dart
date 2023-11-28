import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/model/job_vo.dart';

class JobApi {
  static final CollectionReference _jobsRef = FirebaseFirestore.instance.collection('jobs');

  static Future<JobVo?> getJob(String id) async {
    DocumentSnapshot documentSnapshot = await _jobsRef.doc(id).get();
    if (documentSnapshot.exists) {
      JobVo jobVo = JobVo.fromQueryDocumentSnapshot(documentSnapshot);
      return jobVo;
    } else {
      return null;
    }
  }

  static Future<List<JobVo>> getJobs() async {
    QuerySnapshot querySnapshot = await _jobsRef.get();
    List<JobVo> results = List<JobVo>.from(querySnapshot.docs.map((e) => JobVo.fromQueryDocumentSnapshot(e)));
    if (results.isEmpty) {
      results = await initJobs();
    }
    return results;
  }

  static Future<JobVo> createJob({
    required String title,
    required DateTime createDt,
  }) async {
    DocumentReference res = await _jobsRef.add({
      'title': title,
      'createDt': createDt,
    });
    return JobVo.fromQueryDocumentSnapshot(await res.get());
  }

  static Future<List<JobVo>> initJobs() async {
    for (int i = 0; i < 9; i++) {
      await createJob(
        title: '직업',
        createDt: DateTime.now(),
      );
    }

    return await getJobs();
  }
}