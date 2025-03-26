import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/utils/character.dart';
import 'package:sonix_text/presentation/widgets/options_grade.dart';
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
  final TextEditingController categoryEditingController =
      TextEditingController(text: 'General');
  final TextEditingController priorityEditingController =
      TextEditingController(text: 'Normal');
  final TextEditingController statusEditingController =
      TextEditingController(text: 'Pending');

  final DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  final TextEditingController dueDateEditingController = TextEditingController(
      text:
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}');

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
    categoryEditingController.text = grade.category;
    priorityEditingController.text = grade.priority;
    statusEditingController.text = grade.status;
    dueDateEditingController.text = grade.dueDate;
  }

  Future<void> addGrade() async {
    try {
      final grade = EntityGrade(
        id: uuid.v4(),
        title: titleEditingController.text,
        content: textEditingController.text,
        date: '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
        dueDate: dueDateEditingController.text,
        status: statusEditingController.text,
        priority: priorityEditingController.text,
        category: categoryEditingController.text,
        color: "0xFF0000FF",
        point: 0,
      );

      await ref.read(gradeNotifierProvider.notifier).addGrade(grade);
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
        status: "pending",
        priority: "Normal",
        category: "Personal",
        color: "0xFF0000FF",
        point: 0,
      );

      await ref.read(gradeNotifierProvider.notifier).updateGrade(task);
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
      await ref.read(gradeNotifierProvider.notifier).removeGrade(task);
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
      categoryEditingController.text = "General";
      priorityEditingController.text = "Normal";
      statusEditingController.text = "Pending";
      dueDateEditingController.text = "";
      _lastWords = "";
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          widget.id.isEmpty ? 'Nueva Nota' : 'Editar Nota',
          style: const TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        actions: widget.id.isEmpty
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFE74C3C)),
                  onPressed: removeGrade,
                ),
              ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: titleEditingController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
                decoration: const InputDecoration(
                  hintText: 'Título de la nota',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0xFFBDC3C7)),
                ),
              ),
              const Divider(height: 20, color: Color(0xFFECF0F1)),
              GradeOptionsWidget(
                category: categoryEditingController,
                status: statusEditingController,
                priority: priorityEditingController,
                dueDate: dueDateEditingController,
              ),
              const Divider(height: 20, color: Color(0xFFECF0F1)),
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2C3E50),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Empieza a escribir o usa el micrófono...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Color(0xFFBDC3C7)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: widget.id.isEmpty ? "btnSave" : "btnUpdate",
              onPressed: widget.id.isEmpty ? addGrade : updateGrade,
              backgroundColor: const Color(0xFF3498DB),
              child: const Icon(Icons.save),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: "btnMic",
              onPressed: _speechToText.isNotListening
                  ? _startListening
                  : _stopListening,
              backgroundColor: _speechToText.isNotListening
                  ? const Color(0xFF95A5A6)
                  : const Color(0xFFE74C3C),
              child: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }
}
