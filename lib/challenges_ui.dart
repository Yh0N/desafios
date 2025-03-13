import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  Box? challengesBox;
  Box? achievementsBox;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    challengesBox = Hive.box('challengesBox');
    achievementsBox = Hive.box('achievementsBox');
  }

  void _addChallenge(String challenge) {
    final newChallenge = {
      'title': challenge,
      'progress': 0,
      'isCompleted': false,
    };
    setState(() {
      challengesBox?.add(newChallenge);
    });
  }

  void _deleteChallenge(int index) {
    setState(() {
      challengesBox?.deleteAt(index);
    });
  }

  void _incrementProgress(int index) {
    final challenge = challengesBox?.getAt(index);
    challenge['progress'] += 1;

    if (challenge['progress'] >= 10) {
      _unlockAchievement(
        'Desafío Maestro',
        'Completaste 10 días en un desafío',
      );
    }
    if (challenge['progress'] >= 30) {
      _unlockAchievement(
        'Desafío Experto',
        'Completaste 30 días en un desafío',
      );
    }
    if (challenge['progress'] >= 100) {
      _unlockAchievement(
        'Desafío Legendario',
        'Completaste 100 días en un desafío',
      );
    }
    if (challenge['progress'] >= 200) {
      _unlockAchievement(
        'Desafío Supremo',
        'Completaste 200 días en un desafío',
      );
    }

    setState(() {
      challengesBox?.putAt(index, challenge);
    });
  }

  void _unlockAchievement(String title, String description) {
    if (!achievementsBox!.containsKey(title)) {
      achievementsBox!.put(title, description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Desafíos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Medallas y Logros'),
                      content:
                          achievementsBox!.isEmpty
                              ? const Text('Aún no has desbloqueado logros')
                              : Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    achievementsBox!.keys.map((key) {
                                      return ListTile(
                                        title: Text(key),
                                        subtitle: Text(
                                          achievementsBox!.get(key),
                                        ),
                                      );
                                    }).toList(),
                              ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nuevo Desafío',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _addChallenge(_controller.text);
                _controller.clear();
              }
            },
            child: const Text('Agregar Desafío'),
          ),
          Expanded(
            child:
                challengesBox != null && challengesBox!.isNotEmpty
                    ? ListView.builder(
                      itemCount: challengesBox!.length,
                      itemBuilder: (context, index) {
                        final challenge = challengesBox!.getAt(index);
                        return ListTile(
                          title: Text(challenge['title']),
                          subtitle: Text(
                            'Progreso: ${challenge['progress']} días',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _incrementProgress(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteChallenge(index),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                    : const Center(child: Text('No hay desafíos aún')),
          ),
        ],
      ),
    );
  }
}
