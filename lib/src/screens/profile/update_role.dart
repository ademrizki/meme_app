import 'package:flutter/material.dart';
import 'package:meme_app/src/providers/profile/update_role.dart';
import 'package:provider/provider.dart';

class UpdateRoleScreen extends StatelessWidget {
  static const String id = 'UpdateRoleScreen';

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UpdateRoleProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Role'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Consumer<UpdateRoleProvider>(
                builder: (context, _provider, _) => DropdownButtonFormField(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Select Role',
                    filled: true,
                  ),
                  value: _provider.role,
                  items: _provider.items,
                  onChanged: (value) => _provider.fnOnChanged(value),
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.green,
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async => await _provider.fnOnSaved(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
