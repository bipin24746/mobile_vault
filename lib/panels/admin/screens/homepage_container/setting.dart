import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/admin/screens/settings.dart';

class settingAdmin extends StatelessWidget {
  const settingAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 130,
          width: 130,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Setting()));
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.orange,
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
