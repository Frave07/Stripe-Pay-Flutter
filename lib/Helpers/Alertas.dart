
part of 'Helpers.dart';

mostrarLoading(BuildContext context){

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text('Un momento'),
      content: LinearProgressIndicator(),
    )
  );
}


mostrarAlerta( BuildContext context, String title, String mensaje ){

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text( title ),
      content: Text( mensaje ),
      actions: [
        MaterialButton(
          child: Text('Entiendo'),
          onPressed: () => Navigator.pop(context)
        )
      ],
    )
  );

}