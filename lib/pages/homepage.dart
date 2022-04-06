import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constrants/AppStrings.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n.dart';
import '../provider/localProvider.dart';
import '../widgets/myBehaviour.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var language_value;

  List<String> languageCodes=[
    'en',
    'bn',
    'hi',
    'ar',
    'ms'
  ];

  TextEditingController languageController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    language_value=languageCodes[0];
  }


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Column(
        children: [
          Text(AppLocalizations.of(context)!.translate('language')!),
          SizedBox(height: 50,),
          Row(
            children: [
              Text('Language'),
              SizedBox(width: 20,),
              Expanded(
                child: TextField(
                  controller: languageController,
                  decoration: InputDecoration(
                    labelText: '${AppLocalizations.of(context)!.translate('language')!}'
                  ),
                ),
              )
            ],
          ),
          TextButton(
            onPressed: (){
              setState(() {
                changeLanguageText();
              });
            },
            child: Text('change'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          buildBottomSheet(size);
        },
        child: Icon(Icons.language),
      ),
    );
  }

  Future buildBottomSheet(Size size){
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context){
        return buildLanguageRadio(size);
      },
    );
  }

  Widget buildLanguageRadio(Size size){
    return Container(
      alignment: Alignment.center,
      height: size.height*0.45,
      padding: EdgeInsets.only(top: size.height*0.03),
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          itemCount: language.length,
          itemBuilder: (context, index){
            return RadioListTile(
              visualDensity: const VisualDensity(vertical: -2),
              title: Text(language[index]),
              value: languageCodes[index],
              groupValue: language_value,
              onChanged: (val){
                setState(() {
                  language_value=val.toString();
                  final provider=Provider.of<LocalProvider>(context,listen: false);
                  provider.setLocale(L10n.all[index]);
                });

                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  void changeLanguageText()async{
    var data =  await DefaultAssetBundle.of(context).loadString("lang/${language_value}.json");

    var jsonData = json.decode(data);

    jsonData['language']= languageController.text;
    print(jsonData['language']);


    languageController.clear();
  }
}
