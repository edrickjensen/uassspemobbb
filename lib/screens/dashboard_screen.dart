import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('sketches').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Image.network(doc['imageUrl']),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Uploaded at: ${doc['timestamp']}"),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
