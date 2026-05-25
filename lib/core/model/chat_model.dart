class Chat {
  String? id;
  String? object;
  int? created;
  String? model;
  List<Choices>? choices;

  Chat({this.id, this.object, this.created, this.model, this.choices});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    created = json['created'];
    model = json['model'];
    if (json['choices'] != null) {
      choices = <Choices>[];
      json['choices'].forEach((v) {
        choices!.add(new Choices.fromJson(v));
      });
    }
  }
}

class Choices {
  int? index;
  Message? message;
  String? finishReason;

  Choices({this.index, this.message, this.finishReason});

  Choices.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    message = json['message'] != null
        ? new Message.fromJson(json['message'])
        : null;
    finishReason = json['finish_reason'];
  }
}

class Message {
  String? role;
  String? content;

  Message({this.role, this.content});

  Message.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    content = json['content'];
  }
}

Map<String, dynamic> defaultChat(Chat data) {
  return {
    "id": "chatcmpl_001",
    "object": "chat.completion",
    "created": 1748172000,
    "model": "mivo-ai",
    "choices": [
      {
        "index": 0,
        "message": {
          "role": "assistant",
          "content":
              "Hey! I'm Mivo 👋\n\nI'm Mahmoud's AI assistant. Ask me anything about Mahmoud's projects, Flutter experience, or technical skills.",
        },
        "finish_reason": "stop",
      },
    ],
  };
}
