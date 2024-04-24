class Player {
  static final Player _instance = Player._internal(0, '');
  int id;
  String name;
  factory Player() {
    return _instance;
  }

  Player._internal(
    this.id,
    this.name,
  );
}
