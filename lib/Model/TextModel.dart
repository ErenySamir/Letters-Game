class TextModel {
  List<String>? word;
//String?word;
  TextModel({this.word});

  TextModel.fromJson(List<dynamic> json) {
    word = [];
    //forEach to loop for every element in array
    json.forEach((v) {
      //add word from list
      word!.add(v['word']);
    });

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    return data;
  }
}