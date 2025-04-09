import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GenerateImage extends StatefulWidget {
  GenerateImage({super.key});

  @override
  _GenerateImageState createState() => _GenerateImageState();
}

class _GenerateImageState extends State<GenerateImage> {
  final TextEditingController _queryController = TextEditingController();
  final StabilityAI _ai = StabilityAI();
  final String apiKey = dotenv.env['STABILITY_AI_API_KEY'] ?? '';
  final ImageAIStyle imageAIStyle = ImageAIStyle.digitalPainting;
  bool isItems = false;
  Uint8List? _generatedImage;

  // Function to generate an image based on the input query
  Future<void> _generate() async {
    if (_queryController.text.isEmpty) return;

    setState(() {
      isItems = true; // Show loading indicator
      _generatedImage = null; // Reset image before new generation
    });

    try {
      final Uint8List image = await _ai.generateImage(
        apiKey: apiKey, // API key from .env
        prompt: _queryController.text, // User input prompt
        imageAIStyle: imageAIStyle, // Image style
      );

      setState(() {
        isItems = false; // Hide loading indicator
        _generatedImage = image; // Store the generated image
      });
    } catch (e) {
      setState(() {
        isItems = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating image: $e')),
      );
    }
  }  

  // Dispose method to clean up the controller when the widget is removed from the tree
  @override
  void dispose() {
    _queryController.dispose(); // Dispose of the controller
    super.dispose(); // Call the super class dispose method
  }

  void _downloadImage() {
    // Implement download functionality here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download functionality not implemented yet!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE9CE),
      appBar: AppBar(
        backgroundColor: Color(0xFF4E51BF),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_back, color: Color(0xFFFFE9CE)),
              ),
              Text(
                "Image Generator",
                style: TextStyle(color: Color(0xFFFFE9CE)),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 70),
              Text(
                'Text To Image',
                style: TextStyle(fontSize: 30, color: Color(0xFF4E51BF)),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 55,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFFFDD83),
                ),
                child: TextField(
                  controller: _queryController, // Link the text field to the controller
                  decoration: const InputDecoration(
                    hintText: 'Enter your prompt',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15, top: 5),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Color(0xFFFFDD83),
                  border: Border.all(color: Color(0xFF4E51BF), width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: isItems
                      ? CircularProgressIndicator() // Show loading animation
                      : _generatedImage != null
                          ? Image.memory(
                              _generatedImage!,
                            ) // Show generated image
                          : Text(
                              'Image',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF4E51BF),
                              ),
                            ),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _generate, // ✅ Fixed function call
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4E51BF), // Background color
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ), // Padding
                    ),
                    child: Text(
                      'Generate',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _generatedImage != null ? _downloadImage : null, // ✅ Fixed function call
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4E51BF), // Background color
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ), // Padding
                    ),
                    child: Text(
                      'Download',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
