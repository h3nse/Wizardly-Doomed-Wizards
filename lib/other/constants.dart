enum OpponentPageState { findOpponent, outgoingChallenge, incomingChallenge }

enum PotionState { empty, mixing, finished }

const int potionShakeIntervalMs = 1000;
const int potionShakeThreshold = 6;
const int maxMixLevel = 10;
const int mixLevelIncrease = 1;

const int tickDelayMs = 500;
const int ticksPerTemperatureUpdate = 4;

const int startingHealth = 50;
const int temperatureLimitMin = -20;
const int temperatureLimitMax = 20;
