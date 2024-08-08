import 'package:buddymensia/models/chat_message.dart';
import 'package:buddymensia/models/post.dart';
import 'package:buddymensia/services/speak_services.dart';
import 'package:buddymensia/widgets/buttons/speak/speak_btn_widget.dart';
import 'package:buddymensia/widgets/buttons/speak/utility_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class SpeakScreen extends StatefulWidget {
  final Post post;
  const SpeakScreen({super.key, required this.post});

  @override
  State<SpeakScreen> createState() => _SpeakScreenState();
}

class _SpeakScreenState extends State<SpeakScreen> {
  bool _isSpeaking = false;
  stt.SpeechToText _speech = stt.SpeechToText();
  String _recognizedText = '';
  String? _gptResponse = '';
  List<ChatMessage> _conversationHistory = [];
  FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("id-ID");
    await _flutterTts.setSpeechRate(0.8);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  void _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (mounted) {
          if (status == 'notListening') {
            setState(() {
              _isSpeaking = false;
            });
            process();
          }
        }
      },
      onError: (errorNotification) => print('onError: $errorNotification'),
    );
    if (!available) {
      print("The user has denied the use of speech recognition.");
    }
  }

  void process() async {
    if (_recognizedText.isNotEmpty) {
      _conversationHistory
          .add(ChatMessage(role: 'user', content: _recognizedText));

      _gptResponse = await SpeakServices().sendToGPT(_conversationHistory);
      if (_gptResponse != null) {
        setState(() {
          _conversationHistory
              .add(ChatMessage(role: 'assistant', content: _gptResponse!));
        });

        await _speak(_gptResponse!);
      }
    }
  }

  void _startListening() async {
    if (!_isSpeaking) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isSpeaking = true;
          _recognizedText = '';
        });
        await _speech.listen(
          onResult: (result) {
            if (mounted) {
              setState(() {
                _recognizedText = result.recognizedWords;
              });
            }
          },
          localeId: 'id_ID',
        );

        if (!_speech.isListening) {
          setState(() {
            _isSpeaking = false;
          });
        }
      }
    }
  }

  void _stopListening() {
    _speech.stop();
    if (mounted) {
      setState(() {
        _isSpeaking = false;
      });
    }
    process();
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('"${widget.post.judul}"',
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.w800)),
                Text(
                    DateFormat('d MMMM y', 'id_ID')
                        .format(widget.post.createdAt!),
                    style: GoogleFonts.istokWeb(
                        fontSize: 15, fontWeight: FontWeight.w300)),
              ],
            ),
            Container(
              width: width,
              height: height * 0.3,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(widget.post.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: width,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFD9D9D9)),
              child: Text(
                  // _recognizedText.isEmpty
                      'Tekan tombol mikrofon untuk memulai percakapan',
                      // : _recognizedText,
                  style: GoogleFonts.istokWeb(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
            // Container(
            //   width: width,
            //   alignment: Alignment.center,
            //   margin: const EdgeInsets.all(4),
            //   padding: const EdgeInsets.all(4),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       color: const Color(0xFFD9D9D9)),
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: [
            //         for (var message in _conversationHistory)
            //           Text(
            //               '${message.role == 'user' ? 'You' : 'GPT'}: ${message.content}',
            //               style: GoogleFonts.istokWeb(
            //                   color: message.role == 'user'
            //                       ? Colors.black54
            //                       : Colors.black87,
            //                   fontSize: 13,
            //                   fontWeight: FontWeight.w600)),
            //         if (_recognizedText.isNotEmpty &&
            //             !_conversationHistory
            //                 .any((msg) => msg.content == _recognizedText))
            //           Text('You: $_recognizedText',
            //               style: GoogleFonts.istokWeb(
            //                   color: Colors.black54,
            //                   fontSize: 13,
            //                   fontWeight: FontWeight.w600)),
            //       ],
            //     ),
            //   ),
            // ),
            Column(
              children: [
                Center(
                  child: SpeakBtnWidget(
                      isSpeaking: _isSpeaking,
                      handler: () {
                        if (_isSpeaking) {
                          _stopListening();
                        } else {
                          _startListening();
                        }
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    UtilityBtnWidget(
                      image: 'assets/images/chat_ic.png',
                      scale: 0.8,
                      handler: () {},
                    ),
                    UtilityBtnWidget(
                      image: 'assets/images/close_ic.png',
                      scale: 0.6,
                      handler: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
