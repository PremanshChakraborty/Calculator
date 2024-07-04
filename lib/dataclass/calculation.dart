class Calculation{
  String exp;
  String answer;
  Calculation({required this.exp,required this.answer});
  static List<Calculation> tocalc(List<String> data){
    List<Calculation> list=[];
    for(String st in data){
      list.add(Calculation(exp: st.split(' ').first, answer: st.split(' ').last));
    }
    return list;
  }
  static List<String> tostring(List<Calculation> data){
    List<String> list=[];
    for(Calculation calculation in data){
      list.add('${calculation.exp} ${calculation.answer}');
    }
    return list;
  }
}