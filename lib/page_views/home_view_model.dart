import 'package:scoped_model/scoped_model.dart';

import '../models/post_model.dart';
import '../services/services.dart';

class HomeScoped extends Model {

  bool isLoading = false;
  List<Post> items = [];

  //////// bring post
  void apiPostList() async {
    isLoading = true;
    notifyListeners();

    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());

    if (response != null) {
      items = Network.parsePostList(response);
    } else {
      items = [];
    }
    isLoading = false;
    notifyListeners();
  }


  ///// delete post
  Future<bool> apiPostDelete(Post post) async {
    isLoading = true;
    notifyListeners();

    var response = await Network.GET(
        Network.API_DELETE + post.id.toString(), Network.paramsEmpty());

    isLoading = false;
    notifyListeners();

    apiPostList();
    return response != null;
  }
}