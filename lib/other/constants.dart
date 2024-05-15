enum OpponentPageState { findOpponent, outgoingChallenge, incomingChallenge }

enum PotionState { empty, mixing, finished }

enum Weather { clear, rain, heatWave, blizzard, thunderStorm }

const int potionShakeIntervalMs = 1000;
const int potionShakeThreshold = 6;
const int maxMixLevel = 10;
const int mixLevelIncrease = 1;

const int updateDelayMs = 200;
const int temperatureDelayMs = 2000;

const int startingHealth = 150;
const int temperatureLimitMin = -20;
const int temperatureLimitMax = 20;
const int weatherDelayMin = 20;
const int weatherDelayMax = 40;
const int weatherDurationMin = 15;
const int weatherDurationMax = 30;

const double lightningStrikeChance =
    0.1; // Chance to get struck within 5 seconds
const int thunderStormDamage = 5;
const int blizzardMaxTemp = 10;
const int heatwaveMinTemp = -10;

const int wetDuration = 15;
const int fireThreshold = 15;
const int heatDamageThreshold = 10;
const int heatDamage = 1;
const int brittleThreshold = -15;
const int freezeThreshold = -18;
const int wetAndChargedDamage = 10;
const int wetCooldownThreshold = 10;
const int wetCooldownAmount = 5;
const int overchargeTickDamage = 5;
