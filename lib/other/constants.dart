enum OpponentPageState { findOpponent, outgoingChallenge, incomingChallenge }

enum PotionState { empty, mixing, finished }

const int potionShakeIntervalMs = 2000;
const int potionShakeThreshold = 10;
const int maxMixLevel = 10;
const double mixLevelIncrease = 1.0;
