import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                      trailing: messages[index]['type'] == 'user' ? const Icon(Icons.person) : null,
                      title: Row(
                        children: [
                          SizedBox(
                            width: messages[index]['type'] == 'user' ? 100 : 0,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                messages[index]['message'],
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              color: messages[index]['type'] == 'user'
                                  ? Colors.amberAccent
                                  : Colors.lightBlueAccent,
                              padding: EdgeInsets.all(10),
                            ),
                          ),
                          SizedBox(
                            width: messages[index]['type'] == 'bot' ? 100 : 0,
                          )
                        ],
                      ),
                      leading: messages[index]['type'] != 'user'
                          ? const Icon(Icons.assistant)
                          : null,
                    ),
                    Divider(
                      height: 5,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                );
              },
            )),
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
                    String query = controller.text;
                    var openAIUrl =
                        Uri.https("api.openai.com", "/v1/chat/completions");
                    Map<String, String> headers = {
                      "Content-Type": "application/json",
                      "Authorization":
                          "Bearer sk-proj-oaTfEqHz7gENYrigObR8T3BlbkFJaqoirFK4dtxEul0WiMws"
                    };

                    var prompt = {
                      "model": "gpt-3.5-turbo",
                      "messages": [
                        {"role": "user", "content": query}
                      ],
                      "temperature": 0.7
                    };
                    http
                        .post(openAIUrl,
                            headers: headers, body: json.encode(prompt))
                        .then((value) {
                      var response = json.decode(value.body);
                      String responseContent =
                          response['choices'][0]['message']['content'];
                      setState(() {
                        messages.add({"message": query, "type": "user"});
                        messages
                            .add({"message": responseContent, "type": "bot"});
                      });
                      controller.clear();
                    }, onError: (e) {
                      print("Error: $e");
                    });
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
