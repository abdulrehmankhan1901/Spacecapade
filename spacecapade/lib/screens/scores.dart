import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'mainmenu.dart';

class Scores extends StatelessWidget {
  const Scores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "SCORES",
                  style: TextStyle(fontSize: 40, shadows: [
                    Shadow(
                        blurRadius: 20,
                        color: Colors.white,
                        offset: Offset(0, 0))
                  ]),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> scores = snapshot.data!.docs;
                    return Center(
                      child: ListView(
                          children: scores
                              .map(
                                (doc) => Card(
                                  child: ListTile(
                                    title: Text(
                                        doc['username'] + "   " + doc['score']),
                                  ),
                                ),
                              )
                              .toList()),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MainMenu()));
                  },
                  child: const Icon(Icons.arrow_back_ios_new),
                )),
          ],
        ),
      ),
    );
  }
}
