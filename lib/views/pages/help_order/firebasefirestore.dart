import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> sendMessageToFirebase() async {
  try {
    // Assuming you have a Firebase Firestore instance
    final firestore = FirebaseFirestore.instance;

    // The message content
    final message = {
      'userId': "userId", // Assuming user ID is in the order
      'message': "Customer's message", // Replace with the actual message content
      'timestamp': "FieldValue",
    };

    // Assuming you have a collection for messages
    await firestore.collection('sport').add(message);

    print("Message sent to Firebase");
  } catch (e) {
    print("Failed to send message: $e");
  }
}