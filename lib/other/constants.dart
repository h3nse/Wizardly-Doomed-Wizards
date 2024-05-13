enum OpponentPageState { findOpponent, outgoingChallenge, incomingChallenge }

enum PotionState { empty, mixing, finished }

const int potionShakeIntervalMs = 1000;
const int potionShakeThreshold = 6;
const int maxMixLevel = 10;
const int mixLevelIncrease = 1;

const int tickDelayMs = 2000;

const int startingHealth = 20;
const int temperatureLimitMin = -20;
const int temperatureLimitMax = 20;
