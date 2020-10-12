import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class ReloadScreenWidget extends StatelessWidget {
  final String error;
  final Future<void> Function() reload;

  const ReloadScreenWidget({@required this.error, @required this.reload});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          RaisedButton(
            onPressed: reload,
            child: Text(R.strings.reload),
          ),
        ],
      ),
    );
  }
}
