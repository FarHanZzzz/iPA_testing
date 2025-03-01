import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chatt_app/components/chat_bubble.dart';
import 'package:my_chatt_app/components/my_textfield.dart';
import 'package:my_chatt_app/services/auth/auth_service.dart';
import 'package:my_chatt_app/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat & Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Scroll controller
  final ScrollController scrollController = ScrollController();

  // Focus node for text field
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // Scroll down when keyboard opens
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    // Scroll to the latest message on page load
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // Scroll to the bottom of the chat
  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  // Send messages
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black54,
      ),
      body: Column(
        children: [
          // Display messages
          Expanded(
            child: _buildMessageList(),
          ),

          // User input field
          _buildUserInput(),
        ],
      ),
    );
  }

  // Build the message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) return const Text("Loading...");

        // Scroll down when new messages arrive
        WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());

        return ListView(
          controller: scrollController,
          reverse: true, // ✅ Ensures latest messages appear at the bottom
          children: snapshot.data!.docs.reversed.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // Build each message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Check if the current user is the sender
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ChatBubble(
        message: data["message"],
        isCurrentUser: isCurrentUser,
      ),
    );
  }

  // Build user input field
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // Text field takes most of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          // Send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
