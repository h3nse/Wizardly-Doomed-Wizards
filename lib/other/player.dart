class Player {
  static final Player _instance = Player._internal(0, '', 0, '', false);
  int id;
  String name;
  int opponentId;
  String opponentName;
  bool isManager;
  factory Player() {
    return _instance;
  }

  Player._internal(
      this.id, this.name, this.opponentId, this.opponentName, this.isManager);
}
