import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_level.dart';
import 'package:sonix_text/presentation/riverpod/select_date.dart';
import 'package:sonix_text/presentation/riverpod/seletc_color.dart';
import 'package:sonix_text/presentation/utils/character.dart';
import 'package:sonix_text/presentation/utils/parse_date.dart';
import 'package:sonix_text/presentation/utils/validate_string.dart';
import 'package:sonix_text/presentation/widgets/options_grade.dart';
import 'package:sonix_text/presentation/widgets/options_grade_static.dart';
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
      TextEditingController(text: 'Tecnología');
  final TextEditingController priorityEditingController =
      TextEditingController(text: 'Normal');
  final TextEditingController statusEditingController =
      TextEditingController(text: 'Pending');
  bool isChangeStatus = false;
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
    final splitDueteDate = grade.dueDate.split('/');
    DateTime dateTime = DateTime(
      int.parse(splitDueteDate[2]),
      int.parse(splitDueteDate[1]),
      int.parse(splitDueteDate[0]),
    );

    DateTime fechaActual = DateTime.now();
    DateTime fechaActualSinHora =
        DateTime(fechaActual.year, fechaActual.month, fechaActual.day);
    DateTime dateTimeSinHora =
        DateTime(dateTime.year, dateTime.month, dateTime.day);
    isChangeStatus = dateTimeSinHora.isBefore(fechaActualSinHora) ||
        grade.status == "Completed";
  }

  Future<void> addGrade() async {
    try {
      if (!checkText()) return;
      final grade = EntityGrade(
        id: uuid.v4(),
        title: titleEditingController.text.trim(),
        content: textEditingController.text.trim(),
        date: currentDate,
        dueDate: ref.read(selectDateProvider),
        status: statusEditingController.text,
        priority: priorityEditingController.text,
        category: categoryEditingController.text,
        color: ref.read(selectColor),
        point: 1,
      );

      await ref.read(allGradesProvider.notifier).addGrade(grade);
      clearFields();
      showNotification("Nota", "Nota añadida correctamente");
    } catch (e) {
      showNotification("Error", "Error al añadir la nota", error: true);
    }
  }

  Future<void> updateGrade() async {
    try {
      if (!checkText()) return;
      final valueLevel = ref.watch(multiplyLevelProvider);

      final task = EntityGrade(
        id: widget.id,
        title: titleEditingController.text.trim(),
        content: textEditingController.text.trim(),
        date: registerDate.isEmpty ? currentDate : registerDate,
        dueDate: ref.read(selectDateProvider),
        status: statusEditingController.text,
        priority: priorityEditingController.text,
        category: categoryEditingController.text,
        color: ref.read(selectColor),
        point: statusEditingController.text == "Completed" ? 1 * valueLevel : 1,
      );

      await ref.read(allGradesProvider.notifier).updateGrade(task);

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
    return Scaffold(
      backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
      appBar: AppBar(
        title: Text(
          widget.id.isEmpty ? 'Nueva Nota' : 'Editar Nota',
          style: const TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
        surfaceTintColor: const Color(0xFFD6EAF8).withAlpha(50),
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
        decoration: BoxDecoration(
          color: Color(0xFFD6EAF8).withAlpha(50),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: titleEditingController,
                readOnly: isChangeStatus,
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
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text(
                        'Modo Inteligente',
                        style: TextStyle(
                          color: Color(0xFF2C3E50),
                          fontSize: 16,
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
                    icon: const Icon(
                      Icons.info_outline,
                      color: Color(0xFF3498DB),
                    ),
                    onPressed: _showSmartModeInfo,
                  ),
                ],
              ),
              const Divider(height: 10, color: Color(0xFFECF0F1)),
              isChangeStatus
                  ? GradeOptionsDisplay(
                      category: categoryEditingController.text,
                      status: statusEditingController.text,
                      priority: priorityEditingController.text,
                      dueDate: ref.watch(selectDateProvider))
                  : GradeOptionsWidget(
                      category: categoryEditingController,
                      status: statusEditingController,
                      priority: priorityEditingController,
                    ),
              const Divider(height: 20, color: Color(0xFFECF0F1)),
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  maxLines: null,
                  readOnly: isChangeStatus,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: widget.id.isEmpty ? "btnSave" : "btnUpdate",
              onPressed: widget.id.isEmpty ? addGrade : updateGrade,
              backgroundColor: const Color(0xFF3498DB),
              child: const Icon(Icons.save),
            ),
            const SizedBox(height: 16),
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
