import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pattern_scoped/pages/update_page.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/post_model.dart';
import '../page_views/home_view_model.dart';
import '../services/services.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeScoped scoped = HomeScoped();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scoped.apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pattern - setState"),
      ),
      body: ScopedModel<HomeScoped>(
        model: scoped,
        child: ScopedModelDescendant<HomeScoped>(
          builder: (context, child, model) {
            return  Stack(
              children: [
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: scoped.items.length,
                  itemBuilder: (ctx, index) {
                    return itemOfPost(scoped.items[index]);
                  },
                ),
                scoped.isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : SizedBox.shrink(),
              ],
            );
          }),
        ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, AddPostPage.id).then(
            (value) {
              if (value == 'done') {
                scoped.apiPostList();
              }
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget itemOfPost(Post post) {
    return Slidable(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        ////////////updated
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title!.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(post.body!),
          ],
        ),
      ),
      startActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            label: 'Update',
            backgroundColor: Colors.indigo,
            icon: Icons.edit,
            onPressed: (_) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdatePostPage(
                            post: post,
                          ))).then((value) {
                if (value == 'done') {
                  scoped.apiPostList();
                }
              });
            },
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (_) {
              scoped.apiPostDelete(post).then((value) =>
              {
                if(value) scoped.apiPostList(),
              }
              );

            },
          ),
        ],
      ),
    );
  }
}
