import 'package:flutter/material.dart';
import 'package:calculator/dataclass/calculation.dart';
class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}
class _HistoryState extends State<History> {
  List<Calculation> data=[];
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as List<Calculation>;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text('History',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.surface
        ),),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: ListTile(
              title: GestureDetector(
                onTap: () => Navigator.pop(context,data[index].exp),
                child: Text(data[index].exp,
                  style: Theme.of(context).textTheme.titleMedium,),
              ),
              subtitle: GestureDetector(
                onTap: () => Navigator.pop(context,data[index].answer),
                child: Text('=${data[index].answer}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary
                  ),),
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        disabledElevation: 0,
        backgroundColor: (data.length==0) ? Theme.of(context).colorScheme.surfaceVariant:null,
        onPressed: (data.length==0) ? null : () => Navigator.pop(context,'clear'),
        label: Row(
          children: [Icon(Icons.close),Text('Clear History')],
        ),
      ),
    );
  }
}
