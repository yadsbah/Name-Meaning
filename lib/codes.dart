import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:http/http.dart';

class Codes{
  static Future<List<String>> geta(String name) async{
      List<String> list = new List<String>();
       var x = await http.get("https://www.names.org/n/$name/about");
      if(x.statusCode==200){
      var document = parse(x.body);
      for(Element htmlelment in document.getElementsByClassName("col-md-10")){
        for(Element x in htmlelment.getElementsByTagName("ul")){
          for(Element v in x.getElementsByTagName("li")){
            print(v.text);
            var h = v.text.split('"')[1];
          if(!h.contains(' ')) list.add(h.toLowerCase());
         } 
        }
      }
    }
    list = list.toSet().toList();
    return list;
  }

  
void k () async{
  var y = ['glory','love'];
              
}
}
