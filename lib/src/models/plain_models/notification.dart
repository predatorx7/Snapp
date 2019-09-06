class Notification {
  String userid, text, postid;
  bool ispost;
  Notification(this.userid, this.text, this.postid, this.ispost);

  String getUserid() {
    return userid;
  }

  void setUserid(String userid) {
    this.userid = userid;
  }

  String getText() {
    return text;
  }

  void setText(String text) {
    this.text = text;
  }

  String getPostid() {
    return postid;
  }

  void setPostid(String postid) {
    this.postid = postid;
  }

  bool isIspost() {
    return ispost;
  }

  void setIspost(bool ispost) {
    this.ispost = ispost;
  }
}
