import 'package:flutter/foundation.dart';
import 'package:instagram/models/plain_models/comments.dart';
import 'package:scoped_model/scoped_model.dart';

class CommentPageModel extends Model{
  bool _isButtonDisabled = true;

  bool get isButtonDisabled => _isButtonDisabled;

  void setButtonStatus(bool isButtonDisabled) {
    _isButtonDisabled = isButtonDisabled;
    notifyListeners();
  }

}

class SubCommentModel extends Model{
  Comment _selectedCommentIndex = Comment(commentKey: 'lol');

  Comment get selectedComment => _selectedCommentIndex;

  setSelectedComment(Comment selectedCommentIndex) {
    _selectedCommentIndex = selectedCommentIndex;
    print('Selected comment is: ${selectedCommentIndex.commentKey}');
    notifyListeners();
  }

}