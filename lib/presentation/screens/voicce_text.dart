import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/presentation/riverpod/riverpod.dart';
import 'package:sonix_text/presentation/utils/utils.dart';
import 'package:sonix_text/presentation/widgets/options_grade.dart';

class VoiceTextScreen extends ConsumerStatefulWidget {
  final String id;
  const VoiceTextScreen({super.key, this.id = ""});

  @override
  ConsumerState<VoiceTextScreen> createState() => _VoiceTextScreenState();
}

class _VoiceTextScreenState extends ConsumerState<VoiceTextScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController categoryEditingController =
      TextEditingController(text: 'Tecnología');
  final TextEditingController priorityEditingController =
      TextEditingController(text: 'Normal');
  final TextEditingController statusEditingController =
      TextEditingController(text: 'Pending');
  bool isSmartModeEnabled = false;

  String registerDate = "";

  final String currentDate = formatDateTimeToString(DateTime.now());

  final uuid = Uuid();
  String _lastWords = '';

  void _initSpeech() async {
    await _speechToText.initialize();
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
    if (!isSmartModeEnabled) return;

    final String textReplaced = textEditingController.text
        .toLowerCase()
        .replaceAllMapped(
            RegExp(symbolMap.keys
                .map((palabra) => RegExp.escape(palabra))
                .join('|')),
            (match) => symbolMap[match.group(0)] ?? match.group(0)!);
    textEditingController.text = textReplaced;
  }

  bool checkText() {
    final validString = isValidString(titleEditingController.text);

    if (!validString) {
      showNotification("Error", "Algunos campos no son válidos", error: true);
      return false;
    }

    if (titleEditingController.text.isEmpty) {
      showNotification("Error", "El título no puede estar vacío", error: true);
      return false;
    }

    if (textEditingController.text.isEmpty) {
      showNotification("Error", "El contenido no puede estar vacío",
          error: true);
      return false;
    }

    return true;
  }

  void getGrade() {
    if (widget.id.isEmpty || widget.id == "0") return;
    final grade =
        ref.read(gradeNotifierProvider).firstWhere((t) => t.id == widget.id);
    titleEditingController.text = grade.title;
    textEditingController.text = grade.content;
    categoryEditingController.text = grade.category;
    priorityEditingController.text = grade.priority;
    statusEditingController.text = grade.status;

    ref.read(selectDateProvider.notifier).state = grade.dueDate;

    registerDate = grade.date;
  }

  Future<void> addGrade() async {
    try {
      if (!checkText()) return;

      await ref.read(allGradesProvider.notifier).addGrade(
          titleEditingController.text.trim(),
          textEditingController.text.trim(),
          ref.read(selectDateProvider),
          statusEditingController.text,
          priorityEditingController.text,
          categoryEditingController.text,
          ref.read(selectColor));
      await ref.read(allGradesProvider.notifier).loadGrades();
      clearFields();
      Navigator.pop(context);
      showNotification("Nota", "Nota añadida correctamente");
    } catch (e) {
      showNotification("Error", "Error al añadir la nota", error: true);
    }
  }

  Future<void> updateGrade() async {
    try {
      if (!checkText()) return;
      final valueLevel = ref.watch(multiplyLevelProvider);

      await ref.read(allGradesProvider.notifier).updateGrade(
          widget.id,
          titleEditingController.text.trim(),
          textEditingController.text.trim(),
          ref.read(selectDateProvider),
          statusEditingController.text,
          priorityEditingController.text,
          categoryEditingController.text,
          ref.read(selectColor),
          statusEditingController.text == "Completed" ? 1 * valueLevel : 1);

      clearFields();
      showNotification("Nota", "Nota actualizada correctamente");
    } catch (e) {
      showNotification("Error", "Error al actualizar la nota", error: true);
    }
  }

  Future<void> removeGrade() async {
    try {
      final id = widget.id;
      final task =
          ref.read(gradeNotifierProvider).firstWhere((t) => t.id == id);
      await ref.read(allGradesProvider.notifier).removeGrade(task);
      clearFields();
      showNotification("Success", "Note deleted successfully");
    } catch (e) {
      showNotification("Error", "Error deleting note", error: true);
    }
  }

  void clearFields() {
    ref.read(initialDateProvider.notifier).state =
        DateTime.now().add(const Duration(days: 1));
    ref.read(selectDateProvider.notifier).state = currentDate;

    ref.read(indexColor.notifier).state = 0;
    ref.read(selectColor.notifier).state = 0xFF4fc3f7;

    setState(() {
      titleEditingController.text = "";
      textEditingController.text = "";
      categoryEditingController.text = "General";
      priorityEditingController.text = "Normal";
      statusEditingController.text = "Pending";
      _lastWords = "";
      registerDate = formatDateTimeToString(DateTime.now());

      _speechToText.stop();
    });
  }

  void _showSmartModeInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modo Inteligente',
              style: TextStyle(color: Color(0xFF2C3E50))),
          content: const Text(
              'El modo inteligente permite la conversión automática de palabras a símbolos mientras hablas.\n\nPor ejemplo:\n- "coma" → ","\n- "punto" → "."\n- "paréntesis" → "()"\n\nEsto hace que la entrada por voz sea más natural y eficiente.',
              style: TextStyle(color: Color(0xFF2C3E50))),
          backgroundColor: const Color(0xFFD6EAF8).withAlpha(240),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              child: const Text('Entendido',
                  style: TextStyle(color: Color(0xFF3498DB))),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getGrade();
    });
  }

  @override
  void dispose() {
    _speechToText.stop();
    titleEditingController.dispose();
    textEditingController.dispose();
    categoryEditingController.dispose();
    priorityEditingController.dispose();
    statusEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final unitWidth = screenWidth / 100;
    final unitHeight = screenHeight / 100;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
      appBar: AppBar(
        title: Text(
          widget.id.isEmpty ? 'Nueva Nota' : 'Editar Nota',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: unitWidth * 5,
          ),
        ),
        backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
        surfaceTintColor: const Color(0xFFD6EAF8).withAlpha(50),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        actions: widget.id.isEmpty || widget.id == "0"
            ? null
            : [
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: Color(0xFFE74C3C), size: unitWidth * 6),
                  onPressed: removeGrade,
                ),
              ],
      ),
      body: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: unitWidth * 5,
              right: unitWidth * 5,
            ),
            child: Column(
              children: [
                TextField(
                  controller: titleEditingController,
                  style: TextStyle(
                    fontSize: unitWidth * 6,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Título de la nota',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color(0xFFBDC3C7),
                      fontSize: unitWidth * 6,
                    ),
                  ),
                ),
                Divider(height: unitHeight * 2, color: Color(0xFFECF0F1)),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text(
                          'Modo Inteligente',
                          style: TextStyle(
                            color: Color(0xFF2C3E50),
                            fontSize: unitWidth * 4,
                          ),
                        ),
                        value: isSmartModeEnabled,
                        onChanged: (bool? value) {
                          setState(() {
                            isSmartModeEnabled = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF3498DB),
                        checkColor: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Color(0xFF3498DB),
                        size: unitWidth * 6,
                      ),
                      onPressed: _showSmartModeInfo,
                    ),
                  ],
                ),
                Divider(height: unitHeight * 1, color: Color(0xFFECF0F1)),
                TextField(
                  controller: textEditingController,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: unitWidth * 4,
                    color: Color(0xFF2C3E50),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Empieza a escribir o usa el micrófono...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color: Color(0xFFBDC3C7), fontSize: unitWidth * 4),
                  ),
                ),
                SizedBox(height: unitHeight * 2),
              ],
            ),
          )),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, -MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GradeOptionsWidget(
              id: widget.id,
              category: categoryEditingController,
              status: statusEditingController,
              priority: priorityEditingController,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: unitHeight * 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "btnSave",
              onPressed: widget.id.isEmpty || widget.id == "0"
                  ? addGrade
                  : updateGrade,
              backgroundColor: const Color(0xFF3498DB),
              child: Icon(
                Icons.save,
                size: unitWidth * 7,
              ),
            ),
            SizedBox(height: unitHeight * 2),
            FloatingActionButton(
              heroTag: "btnMic",
              onPressed: _speechToText.isNotListening
                  ? _startListening
                  : _stopListening,
              backgroundColor: _speechToText.isNotListening
                  ? const Color(0xFF95A5A6)
                  : const Color(0xFFE74C3C),
              child: Icon(
                _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                size: unitWidth * 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
