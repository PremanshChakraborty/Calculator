import 'package:shared_preferences/shared_preferences.dart';
import 'package:calculator/dataclass/calculation.dart';
import 'package:calculator/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:function_tree/function_tree.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calculator/widget/key.dart';
import 'package:flutter/widgets.dart';
import 'package:basic_utils/basic_utils.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Calculation> history;
  TextEditingController exp =TextEditingController();
  TextEditingController answer =TextEditingController();
  void add(String ch,int pos){
    int cp=exp.selection.base.offset;
    setState(() {
      exp.text=exp.text.substring(0,pos)+ch+exp.text.substring(pos);
      if(pos==cp) exp.selection=TextSelection.collapsed(offset: pos+ch.length);
      else exp.selection=TextSelection.collapsed(offset: cp+ch.length);
    });
  }
  void replace(int index,String ch){
    int cp = exp.selection.base.offset;
    setState(() {
      exp.text=exp.text.substring(0,index)+ch+exp.text.substring(index+1);
      exp.selection=TextSelection.collapsed(offset: cp);
    });
  }
  bool trace(int cp){
    int open=0;
    int close=0;
    for(int i=0;i<cp;i++){
      if(exp.text[i]=='(') open++;
      else if(exp.text[i]==')') close++;
    }
    if(open>close) return true;
    else return false;
  }
  int trace_neg(int cp){
    for(int i=cp-1;i>=0;i--){
      if(!StringUtils.isDigit(exp.text[i])&&exp.text[i]!='.') return i+1;
    }
    return 0;
  }
  bool isoperator(String ch){
    if(ch=='+'||ch=='-'||ch=='×'||ch=='÷'||ch=='%')
      return true;

    else return false;
  }
  bool hasoperator(){
    for(int i=0;i<exp.text.length;i++){
      if(isoperator(exp.text[i])) return true;
    }
    return false;
  }
  bool isdarkmode(){
    if(Theme.of(context).brightness==Brightness.dark) return true;
    else return false;
  }
  String? solve(){
    if(hasoperator()) {
      String eqn=exp.text;
      if(trace(exp.text.length)) eqn=eqn+')';
      eqn=eqn.replaceAll('×', '*');
      eqn=eqn.replaceAll('÷', '/');
      eqn=eqn.replaceAll('%', '/(100)');
      try{return eqn.interpret().toString();}
      catch(e) {return 'error';}}
    else return null;

  }
  Future<void> getHistory() async{
    final perf= await SharedPreferences.getInstance();
    setState(() {
      history=Calculation.tocalc(perf.getStringList('history')??[]);
    });
  }
  final List<String> keys=['C','()','%','÷','7','8','9','×','4','5','6','-','1','2','3','+','+/-','0','.','='];
  @override
  void initState(){
    getHistory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
        Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.sizeOf(context).height-(MediaQuery.sizeOf(context).width-30)*1.25-90,
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: exp,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.end,
                readOnly: true,
                showCursor: true,
                expands: true,
                maxLines: null,
                minLines: null,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none
                  )
                ),
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: answer,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.secondary
              ),
              textAlign: TextAlign.end,
              readOnly: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none
                  )
              ),
            ),
          ],
        ),),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Row(
              children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if(isdarkmode()) MyApp.of(context).changeTheme(ThemeMode.light);
                          else MyApp.of(context).changeTheme(ThemeMode.dark);
                        });
                      },
                      icon: Icon(isdarkmode()?Icons.light_mode_outlined:Icons.dark_mode_outlined, size: 30),
                      color: Colors.black,
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.tealAccent),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: () async{
                          dynamic result = await Navigator.pushNamed(context,'history',arguments: history);
                          int cp = exp.selection.base.offset;
                          add(result??'',cp);
                        },
                        icon: Icon(
                          Icons.history,
                          size: 32,
                        )),
                  ],
                ),
              IconButton(onPressed:(exp.text=='')? null : (){
                int cp=exp.selection.base.offset;
                if(cp>0) setState(() {
                  exp.text=StringUtils.removeCharAtPosition(exp.text, cp);
                  exp.selection=TextSelection.collapsed(offset: cp-1);
                  answer.text = (solve()) == 'error' ? '' : solve()??'';
                });
              }, color: Theme.of(context).colorScheme.primary
                  ,icon: Icon(Icons.backspace_outlined, size: 30,))],
          ),
        ),
        Divider(indent: 20,endIndent: 20,height: 30,),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 8,
              crossAxisSpacing: 15,
              crossAxisCount: 4
            ),
            itemCount: keys.length,
          itemBuilder: (BuildContext context,int index){
              //clear key
            if (index == 0) {
                  return Button(
                    ontap: () {
                      setState(() {
                        exp.text = '';
                        answer.text = '';
                      });
                    },
                    text: keys[index],
                    color: Theme.of(context).colorScheme.error,
                  );
                }
                //'%' key
              else if (keys[index] == '%') {
                  return Button(
                    ontap: () {
                      int cp = exp.selection.base.offset;
                      if (cp > 0 &&
                          (exp.text[cp - 1] == '(' ||
                              isoperator(exp.text[cp - 1])))
                        Fluttertoast.showToast(msg: 'Invalid format used');
                      else if (cp > 0) {
                        add(keys[index],cp);
                        setState(() {
                          answer.text = (solve()) == 'error' ? '' : solve()??'';
                        });
                      }
                    },
                    text: keys[index],
                    color: Theme.of(context).colorScheme.primary,
                  );
                }
                // operators
              else if (isoperator(keys[index])) {
                  return Button(
                    ontap: () {
                      int cp = exp.selection.base.offset;
                      if (cp > 0 && exp.text[cp - 1] == '(')
                        Fluttertoast.showToast(msg: 'Invalid format used');
                      else if (cp > 0 && isoperator(exp.text[cp - 1])&&exp.text[cp - 1]!='%') {
                        replace(cp - 1, keys[index]);
                        setState(() {
                          answer.text = (solve()) == 'error' ? '' : solve()??'';
                        });
                      } else if (cp < (exp.text.length) &&
                          isoperator(exp.text[cp])) {
                        replace(cp, keys[index]);
                        setState(() {
                          answer.text = (solve()) == 'error' ? '' : solve()??'';
                        });
                      } else if (cp > 0) add(keys[index],cp);
                    },
                    text: keys[index],
                    color: Theme.of(context).colorScheme.primary,
                    fontsize: 40,
                  );
                }
                //Parenthesis
            else if (keys[index] == '()') {
                  return Button(
                    ontap: () {
                      int cp = exp.selection.base.offset;
                      if ((cp > 0 &&
                              isoperator(exp.text[cp - 1]) &&
                              exp.text[cp - 1] != '%') ||
                          cp == 0)
                        add('(', cp);
                      else if (trace(cp))
                        add(')', cp);
                      else
                        add('×(', cp);
                    },
                    text: keys[index],
                    color: Theme.of(context).colorScheme.primary,
                  );
                }
                // Equal key
              else if (keys[index] == '=') {
                  return Button(
                      ontap: () async{
                        String? ans = solve();
                        if (ans == 'error')
                          Fluttertoast.showToast(msg: 'Invalid format used');
                        else if (ans != null) {
                          SharedPreferences perf=await SharedPreferences.getInstance();
                          setState(() {
                            history.add(Calculation(exp: exp.text, answer: ans));
                            exp.text = ans;
                            answer.text = '';
                          });
                          perf.setStringList('history', Calculation.tostring(history));
                        }
                      },
                      text: keys[index],
                      color: Colors.black,
                      bgcolor: Colors.tealAccent);
                }
                //Negative key
            else if (keys[index] == '+/-') {
                  return Button(
                    ontap: () {
                      int cp = exp.selection.base.offset;
                      int pos = trace_neg(cp);
                      add('(-', pos);
                      setState(() {
                        answer.text = (solve()) == 'error' ? '' : solve()??'';
                      });
                    },
                    text: keys[index],
                    fontsize: 25,
                  );
                }
                //Decimal
              else if (keys[index] == '.') {
                  return Button(
                    ontap: () {
                      int cp = exp.selection.base.offset;
                      if (cp > 0 &&( exp.text[cp - 1] == ')'||exp.text[cp - 1] == '%')) {
                      add('×0.',cp);
                      }
                      else if ((cp > 0 && (exp.text[cp - 1] == '('||isoperator(exp.text[cp - 1])))||cp==0)
                        add('0.',cp);
                      else add(keys[index],cp);
                    },
                    text: keys[index],
                  );
                }
              //number keys
            return Button(
                    ontap: () {
                      int cp = exp.selection.base.offset;
                      if (cp > 0 &&
                          (exp.text[cp - 1] == '%' ||
                              exp.text[cp - 1] == ')')) {
                        add('×' + keys[index],cp);
                      } else {
                        add(keys[index],cp);
                      }
                      setState(() {
                        answer.text = (solve()) == 'error' ? '' : solve()??'';
                      });
                    },
                    text: keys[index]);
              },
            ),
        ))],
      )),
    );
  }
}
