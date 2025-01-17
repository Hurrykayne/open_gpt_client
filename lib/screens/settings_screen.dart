import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_gpt_client/extensions/context_extension.dart';
import 'package:open_gpt_client/models/local_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: LocalData.instance.reducedApiKey,
              builder: (context, value) {
                if (!value.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chiave API (OpenAI)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(value.data!),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              tooltip: 'Copia',
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: value.data),
                                );
                                context.showSnackBar(
                                  'Chiave API copiata negli appunti',
                                );
                              },
                            ),
                            IconButton(
                              tooltip: 'Modifica',
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    final textController =
                                        TextEditingController(
                                      text: value.data,
                                    );
                                    return AlertDialog(
                                      title: const Text('Modifica chiave API'),
                                      content: TextField(
                                        controller: textController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Chiave API',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: const Text('Annulla'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (textController.text.isEmpty ||
                                                textController.text ==
                                                    value.data) {
                                              context.pop();
                                              return;
                                            }
                                            await LocalData.instance
                                                .setAPIKey(textController.text);

                                            if (!mounted) {
                                              return;
                                            }

                                            context.pop();
                                            context.showSnackBar(
                                              'Chiave API modificata!',
                                            );
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Salva',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
