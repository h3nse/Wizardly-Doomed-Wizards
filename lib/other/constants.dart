enum OpponentPageState { findOpponent, outgoingChallenge, incomingChallenge }

enum PotionState { empty, mixing, finished }

const int potionShakeIntervalMs = 1000;
const int potionShakeThreshold = 6;
const int maxMixLevel = 10;
const int mixLevelIncrease = 1;

const int updateDelayMs = 200;
const int temperatureDelayMs = 2000;

const int startingHealth = 50;
const int temperatureLimitMin = -20;
const int temperatureLimitMax = 20;

const int fireThreshold = 15;
const int heatDamageThreshold = 10;
const int brittleThreshold = -15;
const int freezeThreshold = -18;
const int wetAndChargedDamage = 15;
const int wetCooldownThreshold = 10;
const int wetCooldownAmount = 5;
