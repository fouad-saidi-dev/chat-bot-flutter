import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  ChatBotPage({Key? key}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List messages = [
    {"message": "Hello", "type": "user"},
    {"message": "Hi", "type": "bot"},
  ];

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text(
            'Chat Bot',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(messages[index]['message']),
                      leading: messages[index]['type'] == 'user'
                          ? const Icon(Icons.person)
                          : const Icon(Icons.assistant),
                    ),
                    Divider(
                      height: 5,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                );
              },
            )
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        messages.add({"message": controller.text, "type": "user"});
                      });
                      controller.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.redAccent,
                    ),
                )
              ],
            )
          ],
        ));
  }
}
