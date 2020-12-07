import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/src/providers/dashboard/home.dart';
import 'package:meme_app/src/resources/widgets/video_widget.dart';
import 'package:meme_app/src/screens/content/add_content_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<HomeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
        actions: <Widget>[
          FlatButton.icon(
            color: Colors.green,
            icon: Icon(
              Icons.add_circle,
              color: Colors.white,
            ),
            label: Text(
              'Add Meme',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pushNamed(context, AddContentScreen.id),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FutureBuilder(
            future: _provider.fnFetchUserInfo(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              switch (snapshot.hasData) {
                case false:
                  return Center(child: CircularProgressIndicator());
                  break;
                default:
                  final _data = snapshot.data.data();
                  return Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                _data['image_url'],
                              ),
                            ),
                          ),
                          height: 60,
                          width: 60,
                          margin: EdgeInsets.all(10),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _data['full_name'],
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                _data['role'] == 1
                                    ? 'Level A'
                                    : _data['role'] == 2
                                        ? 'Level B'
                                        : 'Level C',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                  break;
              }
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: _provider.fnFetchContents(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.hasData) {
                  case false:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    return ListView.builder(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                      ),
                      shrinkWrap: true,
                      itemCount: _provider.fnSetItemCount(snapshot.data.docs.length),
                      itemBuilder: (context, index) {
                        final _data = snapshot.data.docs[index].data();
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _data['content_url'] != null
                                    ? VideoWidget(
                                        videoUrl: _data['content_url'],
                                      )
                                    : SizedBox(),
                                SizedBox(height: _data['content_url'] != null ? 10 : 0),
                                Text(
                                  _data['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(_data['description']),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
