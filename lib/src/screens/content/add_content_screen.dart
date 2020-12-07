import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/src/providers/content/add_content_provider.dart';
import 'package:provider/provider.dart';

class AddContentScreen extends StatelessWidget {
  static const String id = 'AddContentScreen';

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AddContentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meme'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _provider.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Consumer<AddContentProvider>(
                  builder: (context, _provider, _) => _provider.fnCheckVideoIsExist(context),
                ),
              ),
              SizedBox(height: 10),
              Consumer<AddContentProvider>(
                builder: (context, _provider, _) => _provider.image == null
                    ? GestureDetector(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.add_circled),
                                SizedBox(height: 10),
                                Text('Add Video'),
                              ],
                            ),
                          ),
                        ),
                        onTap: () => _provider.fnOnFetchVideo(context),
                      )
                    : SizedBox(),
              ),
              SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _provider.titleController,
                validator: (value) => value.isEmpty ? "Title can't be empty" : null,
                onFieldSubmitted: (value) {
                  Focus.of(context).unfocus();
                  Focus.of(context).nextFocus();
                },
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Title',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 10),
              TextFormField(
                textInputAction: TextInputAction.go,
                controller: _provider.descriptionController,
                validator: (value) => value.isEmpty ? "Description can't be empty" : null,
                onFieldSubmitted: (value) {
                  Focus.of(context).unfocus();
                  return _provider.fnOnSaved(context);
                },
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Description',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () => _provider.fnOnSaved(context),
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
        ),
      ),
    );
  }
}
