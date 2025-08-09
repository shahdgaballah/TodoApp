import 'package:flutter/material.dart';
import '../../layout/todo/controller/cubit.dart';

class BuildTaskItem extends StatefulWidget {
  final Map model;
  const BuildTaskItem({super.key, required this.model});

  @override
  State<BuildTaskItem> createState() => _BuildTaskItemState();
}

class _BuildTaskItemState extends State<BuildTaskItem> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = (widget.model['status'] == 'done');
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Widget buildDeleteBackground({required bool alignStart}) {
      final Color bgColor = Colors.red.shade600;
      final Color textColor = Colors.white;
      final Widget content = Row(
        mainAxisAlignment:
            alignStart ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (alignStart) const SizedBox(width: 20.0),
          Icon(Icons.delete_outline, color: textColor),
          const SizedBox(width: 8.0),
          Text(
            'Delete',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!alignStart) const SizedBox(width: 20.0),
        ],
      );
      return Container(color: bgColor, child: content);
    }

    final Map model = widget.model;

    return Dismissible(
      key: Key(model['id'].toString()),
      background: buildDeleteBackground(alignStart: true),
      secondaryBackground: buildDeleteBackground(alignStart: false),
      onDismissed: (direction){
        AppCubit.get(context).deleteDataFromDatabase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[300] : Colors.teal,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  model['time'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.black : Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model['date'],
                    style: TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ],
              ),
            ),
            if (cubit.currentIndex == 0) ...[
              Checkbox(
                value: isChecked,
                onChanged: (value) async {
                  if (value == true) {
                    setState(() {
                      isChecked = true;
                    });
                    await Future.delayed(const Duration(milliseconds: 250));
                    if (!mounted) return;
                    AppCubit.get(context).updateDateFromDatabase(status: 'done', id: model['id']);
                  }
                },
                activeColor: Colors.green,
                checkColor: Colors.white,
                side: BorderSide(color: isDarkMode ? Colors.white : Colors.black45),
              ),
              IconButton(
                onPressed: (){
                  AppCubit.get(context).updateDateFromDatabase(status: 'archive', id: model['id']);
                }, 
                icon: Icon(Icons.archive_outlined, color: isDarkMode ? Colors.grey : Colors.black45)
              ),
            ],
          ],
        ),
      ),
    );
  }
}