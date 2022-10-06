import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final notesTitle = TextEditingController();
  final notesContent = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<DocumentSnapshot> notes = snapshot.data!.docs;
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 40, right: 10, left: 10),
              child: Column(
                children: [
                  Text('All notes',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Column(
                                            children: [
                                              Text("UPDATE NOTES"),
                                              TextFormField(
                                                controller: notesTitle,
                                                decoration: InputDecoration(
                                                    hintText: "Notes Title"),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: notesContent,
                                                decoration: InputDecoration(
                                                    hintText: "Notes Content"),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              color: Colors.red,
                                              child: Text("Cancle"),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('notes')
                                                    .doc(notes[index].id)
                                                    .update({
                                                  'notesTitle': notesTitle.text,
                                                  'notesContent':
                                                      notesContent.text
                                                });
                                                Navigator.pop(context);
                                                notesContent.clear();
                                                notesTitle.clear();
                                              },
                                              color: Colors.green,
                                              child: Text("Update"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Do you want to delete this note?"),
                                          actions: [
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              color: Colors.red,
                                              child: Text("NO"),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('notes')
                                                    .doc(notes[index].id)
                                                    .delete();
                                                Navigator.pop(context);
                                                notesContent.clear();
                                                notesTitle.clear();
                                              },
                                              color: Colors.green,
                                              child: Text("YES"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                            title: Text(
                              notes[index].get('notesContent'),
                            ),
                            subtitle: Text(
                              notes[index].get('notesTitle'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text("ADD NOTES"),
                    TextFormField(
                      controller: notesTitle,
                      decoration: InputDecoration(hintText: "Notes Title"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: notesContent,
                      decoration: InputDecoration(hintText: "Notes Content"),
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    child: Text("Cancle"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('notes').add({
                        'notesTitle': notesTitle.text,
                        'notesContent': notesContent.text
                      });
                      Navigator.pop(context);
                      notesContent.clear();
                      notesTitle.clear();
                    },
                    color: Colors.green,
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
