import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowDesPage extends StatefulWidget {
  final DocumentSnapshot entry;

  const ShowDesPage({super.key, required this.entry});

  @override
  _ShowDesPageState createState() => _ShowDesPageState();
}

class _ShowDesPageState extends State<ShowDesPage> {
  late TextEditingController _titleController;
  late TextEditingController _moodController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry['title']);
    _moodController = TextEditingController(text: widget.entry['mood']);
    _descriptionController = TextEditingController(text: widget.entry['description']);
  }

  void _updateEntry() async {
    await FirebaseFirestore.instance.collection('Diary').doc(widget.entry.id).update({
      'mood': _moodController.text,
      'description': _descriptionController.text,
    });

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _isEditing ? "Edit Story" : "Your Diary", 
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black), 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              _titleController.text,
              style: const TextStyle(
                fontFamily: 'Varela',
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            // Mood - Editable
            SizedBox(height: 10),
            _isEditing
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: _moodController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        border: InputBorder.none,
                        hintText: 'Enter your mood',
                      ),
                    ),
                  )
                : Text(
                    "Mood ${_moodController.text}",
                    style: const TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            const SizedBox(height: 20),

            // Description - Editable
            SizedBox(height: 10),
            _isEditing
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        border: InputBorder.none,
                        hintText: 'Enter your description',
                      ),
                    ),
                  )
                : Text(
                    _descriptionController.text,
                    style: const TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 16,
                    ),
                  ),

            const SizedBox(height: 30),
            Center(
              child: Container(
                width: double.infinity, // Make the button stretch to full width
                child: ElevatedButton(
                  onPressed: () {
                    if (_isEditing) {
                      _updateEntry();
                    } else {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  child: Text(_isEditing ? "Save Changes" : "Edit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 15), // Remove horizontal padding
                    textStyle: const TextStyle(
                      fontFamily: 'Varela',
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
