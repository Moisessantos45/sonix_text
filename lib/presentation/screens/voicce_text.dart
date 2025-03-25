import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/utils/character.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';

class VoiceTextScreen extends ConsumerStatefulWidget {
  final String id;
  const VoiceTextScreen({super.key, this.id = ""});

  @override
  ConsumerState<VoiceTextScreen> createState() => _VoiceTextScreenState();
}

class _VoiceTextScreenState extends ConsumerState<VoiceTextScreen> {
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  final uuid = Uuid();
  bool _speechEnabled = false;
  String _lastWords = '';

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (result.finalResult) {
        if (textEditingController.text.isNotEmpty) {
          textEditingController.text += ' $_lastWords';
        } else {
          textEditingController.text = _lastWords;
        }
        replaceAllMapped();
      }
    });
  }

  void replaceAllMapped() {
    final String textReplaced = textEditingController.text
        .toLowerCase()
        .replaceAllMapped(
            RegExp(symbolMap.keys
                .map((palabra) => RegExp.escape(palabra))
                .join('|')),
            (match) => symbolMap[match.group(0)] ?? match.group(0)!);
    textEditingController.text = textReplaced;
  }

  void getGrade() {
    if (widget.id.isEmpty) return;
    final grade =
        ref.read(gradeNotifierProvider).firstWhere((t) => t.id == widget.id);
    titleEditingController.text = grade.title;
    textEditingController.text = grade.content;
  }

  Future<void> addGrade() async {
    try {
      final grade = EntityGrade(
        id: uuid.v4(),
        title: titleEditingController.text,
        content: textEditingController.text,
        date: DateTime.now().toString(),
        dueDate: DateTime.now().toString(),
        status: "Pending",
        priority: "Normal",
        category: "General",
        color: "blue",
        point: 0,
      );

      await ref.read(gradeNotifierProvider.notifier).addTask(grade);
      clearFields();
      showNotification("Success", "Note added successfully");
    } catch (e) {
      showNotification("Error", "Error adding note", error: true);
    }
  }

  Future<void> updateGrade() async {
    try {
      final task = EntityGrade(
        id: widget.id,
        title: titleEditingController.text,
        content: textEditingController.text,
        date: DateTime.now().toString(),
        dueDate: DateTime.now().toString(),
        status: "Pending",
        priority: "Normal",
        category: "General",
        color: "blue",
        point: 0,
      );

      await ref.read(gradeNotifierProvider.notifier).updateTask(task);
      clearFields();
      showNotification("Success", "Note updated successfully");
    } catch (e) {
      showNotification("Error", "Error updating note", error: true);
    }
  }

  Future<void> removeGrade() async {
    try {
      final id = widget.id;
      final task =
          ref.read(gradeNotifierProvider).firstWhere((t) => t.id == id);
      await ref.read(gradeNotifierProvider.notifier).removeTask(task);
      clearFields();
      showNotification("Success", "Note deleted successfully");
    } catch (e) {
      showNotification("Error", "Error deleting note", error: true);
    }
  }

  void clearFields() {
    setState(() {
      titleEditingController.text = "";
      textEditingController.text = "";
    });
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    getGrade();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: Colors.amber,
        actions: widget.id.isEmpty
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: removeGrade,
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleEditingController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'Note Title',
                border: InputBorder.none,
              ),
            ),
            const Divider(height: 20),
            Expanded(
              child: TextField(
                controller: textEditingController,
                maxLines: null,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Start typing or use voice input...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: widget.id.isEmpty ? "btnSave" : "btnUpdate",
              onPressed: () {
                if (widget.id.isEmpty) {
                  addGrade();
                } else {
                  updateGrade();
                }
              },
              backgroundColor: Colors.amber,
              child: const Icon(Icons.save),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: "btnMic",
              onPressed: _speechToText.isNotListening
                  ? _startListening
                  : _stopListening,
              backgroundColor:
                  _speechToText.isNotListening ? Colors.grey : Colors.red,
              child: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }
}
