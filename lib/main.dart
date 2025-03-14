import 'package:app_diary/adddataPage.dart';
import 'package:app_diary/showdes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, 
      ),
      home: const DiaryHomePage(),
    );
  }
}

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({super.key});

  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addDiaryEntry() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddDataPage()),
  );
}


  void _deleteEntry(String id) async {
    await _firestore.collection('Diary').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0), // Adjust the height of the AppBar
        child: AppBar(
          backgroundColor: Colors.white, 
          title: const Text(
            'My Diary',
            style: TextStyle(
              fontFamily: 'Varela',
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true, // Center the title in the AppBar
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Diary').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data!.docs;

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              var entry = entries[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 0.8, // Border width
                    ),
                    borderRadius: BorderRadius.circular(8), // Border radius to round the corners
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      entry['title'],
                      style: const TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Mood ${entry['mood']}",
                      style: const TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 15),
                    ),
                    
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowDesPage(entry: entry)),
                      );
                    },
                    trailing: Container(
                      width: 30, 
                      height: 30, 
                      decoration: BoxDecoration(
                        color: Colors.amber, 
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_rounded, 
                          color: Color.fromARGB(255, 0, 0, 0), 
                          size: 15,
                        ),
                        onPressed: () => _deleteEntry(entry.id),
                      ),
                    ),
                  ),
                )
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.amber,
        onPressed: _addDiaryEntry,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
