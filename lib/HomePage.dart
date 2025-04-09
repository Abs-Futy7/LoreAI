import 'package:chatbot/message.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [
    Message("Hi", true),
    Message("Hello", false),
    Message("How are you?", true),
    Message("I'm good, how about you?", false),
  ];

  callGeminiModel() async {
    try {
      if (_controller.text.isNotEmpty) {
        setState(() {
          _messages.add(Message(_controller.text, true));
        });
      }

      final model = GenerativeModel(
        model: "gemini-1.5-pro",
        apiKey: dotenv.env['GOOGLE_API_KEY'] ?? '',
      );

      final prompt =
          "You are a helpful AI assistant. Respond conversationally.\nUser: ${_controller.text.trim()}";
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);

      setState(() {
        _messages.add(Message(response.text ?? "No response from AI.", false));
      });

      _controller.clear();
    } catch (e) {
      print("Error: $e");
      setState(() {
        _messages.add(Message("Error fetching AI response.", false));
      });
    }
  }

  void _sendMessage() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(Message(text, true));
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE9CE),

      appBar: AppBar(
        backgroundColor: Color(0xFF4E51BF),
        title: Row(
          children: [
            Image(image: AssetImage("assets/images/bot.png"), height: 35),
            SizedBox(width: 10),
            Text("LoreAI", style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
      ),

      body: Column(
        children: [
          /// CHAT MESSAGES LIST
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Align(
                  alignment:
                      message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width *
                          0.75, // Limit width to 75% of screen
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            message.isUser
                                ? Color(0xFF4E51BF)
                                : Color(0xFFFFDD83),
                        border:
                            message.isUser
                                ? null
                                : Border.all(
                                  color: Color(0xFF4E51BF),
                                  width: 1,
                                ),
                        borderRadius:
                            message.isUser
                                ? BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )
                                : BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color:
                              message.isUser
                                  ? Colors.white
                                  : Color.fromARGB(255, 52, 55, 130),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// MESSAGE INPUT FIELD
          Padding(
            padding: EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF4E51BF),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                          color: Colors.white,
                        ), // Message text color white
                        decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(
                            color: Colors.white70,
                          ), // Hint text slightly faded white
                          filled: true,
                          fillColor: Color(
                            0xFF6B6ECF,
                          ), // Slightly lighter purple for the input field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none, // No visible border
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      //_sendMessage();
                      callGeminiModel();
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF4E51BF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
