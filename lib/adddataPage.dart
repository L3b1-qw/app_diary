import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();  // TextField controller for mood
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveData() async {
    if (_titleController.text.isNotEmpty && _moodController.text.isNotEmpty) {
      await _firestore.collection('Diary').add({
        'title': _titleController.text,
        'mood': _moodController.text,  // Save mood from TextField
        'description': _descriptionController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Your Story",
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 23),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black), // Back button
          onPressed: () {
            Navigator.pop(context); // Return to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title",
              style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20, 
                fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
              ),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  hintText: 'Title name',
                  hintStyle: TextStyle(
                    fontFamily: 'Varela',
                    color: Colors.grey
                  )
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "How are you feeling today?",
              style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20, 
                fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: _moodController,  // TextField for mood
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  hintText: 'express you feeling',
                  hintStyle: TextStyle(
                    fontFamily: 'Varela',
                    color: Colors.grey
                  ) // Hint text for mood
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "What's your story?",
              style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20, 
                fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  hintText: 'write your story here',
                  hintStyle: TextStyle(
                    fontFamily: 'Varela',
                    color: Colors.grey
                  )
                ),
              ),
            ),
            const SizedBox(height: 50),

            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber, // Background color of the button
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Transparent button background
                    shadowColor: Colors.transparent, // No shadow
                    padding: const EdgeInsets.symmetric(horizontal: 98.4, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text(
                    "Create your story",
                    style: TextStyle(
                      fontFamily: 'Varela',
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
