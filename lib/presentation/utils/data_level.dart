import 'package:sonix_text/infrastructure/level_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

List<LevelModel> generateLevels(int maxTareasPorDia) {
  int diasParaCompletar = 5;

  return List.generate(20, (index) {
    int level = index + 1;

    int point = (maxTareasPorDia * diasParaCompletar * pow(level, 1.2)).toInt();

    int multiplier = 1 + log(level + 1) ~/ log(2);

    List<String> messages = [
      '¡Bienvenido! El viaje apenas comienza. 💪',
      '¡Sigues avanzando! No te detengas. 🔥',
      '¡Increíble! Te estás volviendo un experto. 🏆',
      '¡Wow! Tu esfuerzo está dando frutos. 🚀',
      '¡Mitad del camino! Mantén el ritmo. 🏃‍♂️',
      '¡Eres una máquina de productividad! 🤖',
      '¡Nada te detiene! Sigue así. 💯',
      '¡Nivel Pro! Eres un crack. 🔥',
      '¡Leyenda! Estás a un paso de la grandeza. 🏅',
      '¡Maestro absoluto! Lo has logrado. 🎖',
      '¡Sigues superándote! Esto no tiene fin. 🚀',
      '¡Nivel Élite! Pocos llegan hasta aquí. 🔥',
      '¡Dominador total! Eres imparable. 💪',
      '¡Líder absoluto! Deja tu marca. 🏆',
      '¡Nivel Supremo! No hay límites para ti. 🚀',
      '¡Grandioso! Eres inspiración para todos. 💯',
      '¡Nivel Leyenda! Solo los mejores llegan. 🏅',
      '¡Cima del Éxito! Eres inigualable. 🎖',
      '¡Último nivel! Un verdadero campeón. 🏆',
      '¡Felicidades! Has conquistado todos los niveles. 🎉',
    ];

    return LevelModel(
      id: Uuid().v4(),
      title: 'Level $level',
      level: level,
      point: point,
      multiplier: multiplier,
      message: messages[index],
      isClaimed: false,
    );
  });
}
