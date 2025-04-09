import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Summarizer extends StatefulWidget {
  @override
  _SummarizerState createState() => _SummarizerState();
}

class _SummarizerState extends State<Summarizer> {

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  String _summary = "";
  bool _isLoading = false;

  Future<void> _summarizeText() async {
    String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? "";
    if (apiKey.isEmpty) {
      setState(() {
        _summary = "API Key is missing!";
      });
      return;
    }

    if (_textController.text.isEmpty || _lengthController.text.isEmpty) {
      setState(() {
        _summary = "Please enter text and summary length.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _summary = "";
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateText?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "prompt": {
            "text":
                "Summarize the following text in ${_lengthController.text} words/sentences: ${_textController.text}"
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _summary = data['candidates'][0]['output'] ?? "No summary available.";
        });
      } else {
        setState(() {
          _summary = "Error: ${response}";
        });
      }
    } catch (e) {
      setState(() {
        _summary = "Error: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini Text Summarizer"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Enter text to summarize",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _lengthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter summary length (words/sentences)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _summarizeText,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Summarize", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Text(
              "Summary:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_summary, style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
