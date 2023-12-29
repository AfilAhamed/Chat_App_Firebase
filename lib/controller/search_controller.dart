import 'package:chat_app/model/user_model.dart';
import 'package:flutter/material.dart';

class SearchUserController extends ChangeNotifier {
  final List<UserModel> searchList = [];
  bool isSearching = false;
}
