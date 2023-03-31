extension Filetype on String {
  bool isNetworkFile() {
    return contains('http') ? true : false;
  }
}
