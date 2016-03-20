//==============================================================================
// aiDraugurHeader.xs
// by Felix Hermansson (hoodncloak@hotmail.com)
// 20 April 2008
//
// This file contains all personality trait and control variable definitions.
// It is almost identical to the original 'The Asian Dynasties' aiHeader file by  
// Ensemble Studios and Big Huge Games, except for the changes listed below.
// 
// The file is included by the loader file, above the inclusion of 
// aiDraugurMain.xs.
// 
// This file is intended primarily as a reference for the variables that
// can be safely set by the loader file.
//==============================================================================
// Changes introduced:
// 
// - New control variable cvOkToBuildDeck added
//
// - Several minor editorial changes introduced
//==============================================================================




//==============================================================================
// Behavior Traits.
//
// These global variables all range from -1.0 to +1.0, with 0.0 as a neutral value.
// All names start with bt for Behavior Trait, followed by two words that are 
// opposites.  A value above zero emphasizes the first word, a negative value 
// emphasizes the second word.  Setting btRushBoom to 1.0 would create an extreme
// rusher, setting it to -1.0 would create an extreme boomer.

// NOTE!  *** in a comment means this variable has not yet been implemented.  Stay tuned for updates.

extern float   btRushBoom = 0.0;       /* Affects emphasis and timing of early attacks.
                                          Extreme rushers will attack early and relentlessly
                                          Extreme boomers invest in economic upgrades, gamble on
                                          a later, more powerful attack.
                                          In ages 3+, 'rushers' focus a bit more on military, 'boomers' a bit more on econ, 
                                          but the differences are more subtle.
                                       */
                                       
extern float   btOffenseDefense = 0.0; /* A defensive personality will add towers and upgrade them.  An offense-oriented 
                                          personality will skip these investments in favor
                                          of a larger and more upgraded army.  
                                       */


extern float   btBiasCav = 0.0;        // These variables control a personality's bias toward or away
extern float   btBiasArt = 0.0;        // from each unit line.  0.0 is neutral.  1.0 means heavily favor
extern float   btBiasInf = 0.0;        // this unit line.  -1.0 means avoid when possible. 

extern float   btBiasNative = 0.0;     // Range -1.0 to +1.0, positive numbers increase emphasis on claiming native allies
extern float   btBiasTrade = 0.0;      // Ditto for trade routes.









//==============================================================================
// Control Variables.
//
// Control variables are generally set in the loader file's preInit() function,
// to shape AI behavior while isolating the loader file from ongoing script development.
//==============================================================================

// NOTE!  *** in a comment means this variable has not yet been implemented.  Stay tuned for updates.

// Permission-oriented control variables
extern bool    cvInactiveAI = false;         // Setting this true in preInit() will disable all upper AI functions (attack, defend, gather, etc.)
extern bool    cvOkToSelectMissions = true;  // False prevents the AI from activating any missions
extern bool    cvOkToAttack = true;          // False prohibits launching of any new attacks
extern bool    cvOkToTrainArmy = true;       // False prohibits training land mil units
extern bool    cvOkToTrainNavy = true;       // False prohibits training naval units
extern bool    cvOkToFortify = true;         // False prohibits outposts      
extern bool    cvOkToTaunt = true;           // False prohibits routine ambience (personality development) chats.  NOTE that this defaults to FALSE in SPC/campaign games.
extern bool    cvOkToChat = true;            // False prohibits all planning-oriented comms, like requests for defense, joint ops, tribute requests, etc.
extern bool    cvOkToAllyNatives = true;     // False prohibits native alliances and victory points
extern bool    cvOkToClaimTrade = true;      // False prohibits trade posts on trade routes
extern bool    cvOkToBuild = true;           // False prohibits buildings.
extern bool    cvOkToBuildWalls = true;      // False prohibits any wall-building
extern bool    cvOkToBuildForts = true;      // False prohibits fort building

extern bool    cvOkToBuildConsulate = true;  // False prohibits consulate building

// Resignation is handled differently in scenario and campaign games.  In them, init() sets cvOkToResign to false.  
// If you want to turn resignation back on in a scenario, the loader file must set it true in postInit().  (preInit() will
// have no effect because this value is actually set in init(), unlike the other control variables.
extern bool    cvOkToResign = true;          // AI can offer to resign when it feels overwhelmed

extern bool    cvDoAutoSaves = true;         // Setting this false will over-ride the normal auto-save setting (for scenario use)
extern bool    cvOkToExplore = true;         // Setting this false will disable all AI explore plans
extern bool    cvOkToFish = true;            // Setting it false will prevent the AI from building dock and fishing boats, and from
                                             // using the starting ship (if any) for fishing.

extern bool    cvOkToGatherFood = true;      // Setting it false will turn off food gathering.  True turns it on.
extern bool    cvOkToGatherGold = true;      // Setting it false will turn off gold gathering.  True turns it on.
extern bool    cvOkToGatherWood = true;      // Setting it false will turn off wood gathering.  True turns it on.
extern bool    cvOkToGatherCrates = true;    // Setting it false will largely eliminate crate gathering...but not entirely as entity AI still does some.

extern bool    cvOkToGatherNuggets = true;   // Setting it false will prevent the land explore plan from nugget hunting.

// Limit control variables
extern int     cvMaxArmyPop = -1;            // -1 means undefined.  0 means don't train anything.
extern int     cvMaxNavyPop = -1;            // *** Navy units no longer take up pop.
extern int     cvMaxCivPop = -1;             // -1 means undefined.  0 means don't train anything.  Until navy is working, use this for total mil pop
extern int     cvMaxAge = cAge5;             // Set this to cAge1..cAge4 to cap age upgrades.  cvMaxAge = cAge3 will let the AI go age 3, but not age 4.


// Non-boolean control variables
                                                   // To make the AI train mostly hussars and some musketeers, set cvNumArmyUnitTypes = 2; cvPrimaryArmyUnit = cUnitTypeHussar;
                                                   // and cvSecondaryArmyUnitType = cUnitTypeMusketeer;
                                                   // To return the AI to normal operation, set those same variables back to -1.
extern int     cvPrimaryArmyUnit = -1;             // This sets the AI's primary land military unit type.  -1 lets the AI decide on its own.
extern int     cvSecondaryArmyUnit = -1;           // This sets the AI's secondary land military unit type, applies only if cvNumArmyUnitTypes is >2 or set to -1.
extern int     cvTertiaryArmyUnit = -1;            // This sets the AI's tertiary land military unit type, applies only if cvNumArmyUnitTypes is >3 or set to -1.
extern int     cvNumArmyUnitTypes = -1;            // The AI will not use more than this number of unit types.  (May be less if not available).  -1 means AI can decide.

extern int     cvPlayerToAttack = -1;     // *** Leaving this at -1 will let the CP choose its own targets.  Setting it to an enemy player ID will make it focus
                                          // on that player unless it can see no bases owned by that player.
                                          
extern float   cvDefenseReflexRadiusActive = 60.0;    // When the AI is in a defense reflex, this is the engage range from that base's center.
extern float   cvDefenseReflexRadiusPassive = 30.0;   // When the AI is in a defense reflex, but hiding in its main base to regain strength, this is the main base attack range.
extern float   cvDefenseReflexSearchRadius = 60.0;    // How far out from a base to look before triggering a defense reflex.  THIS MUST NOT BE GREATER THAN 'RadiusActive' ABOVE!


// The following are more like constants once set at initialization
extern string   cvRandomMapName = "";        // *** Force this player to act as if it is on a specific map type.
extern bool     cvTransportMap = true;      // *** Set to true to force AI to prepare for transports, false to prohibit transporting.
extern bool     cvFishingMap = true;        // *** Set to true to enable fishing, false to prohibit it.

// New control variables added for the Draugur AI
extern bool     cvOkToBuildDeck = true;      // Set to false in preInit() to force the AI to use a pre-assigned deck instead of building its own. For custom scenarios only!


 
