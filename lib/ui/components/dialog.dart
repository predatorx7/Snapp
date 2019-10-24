import 'package:flutter/material.dart';
import 'package:instagram/commons/styles.dart';

Future<bool> basicDialog({
  BuildContext context,
  String title,
  String details,
}) async {
  bool decision = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 35, bottom: 10),
                child: Text(
                  title,
                  style: actionTitleStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 30),
                child: Text(
                  details,
                  style: body4Style(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('[Alert Box] Popping Alert Box');
                decision = true;
                Navigator.maybePop(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: new Text(
                      'Yes',
                      style: actionTapStyle(),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                decision = false;
                Navigator.maybePop(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: new Text(
                      'No',
                      style: body3Style(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
  return decision;
}
