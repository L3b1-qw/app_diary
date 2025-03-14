import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  String description;
  String mood;
  final String title;

  DiaryModel({required this.description, required this.mood, required this.title});

  // Convert a DiaryModel object to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'mood': mood,
      'title': title,
    };
  }

  // Create a DiaryModel object from a Firestore document snapshot
  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      description: map['description'] ?? '',
      mood: map['mood'] ?? '',
      title: map['title'] ?? '',
    );
  }

  // Create a DiaryModel object from a Firestore document snapshot
  factory DiaryModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return DiaryModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}
