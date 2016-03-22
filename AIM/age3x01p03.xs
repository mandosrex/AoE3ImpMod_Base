//==============================================================================
/* age3x01p03.xs
   
   This is a standard AI.  Main AI enemy.  Player 3 Iroquois.  This player is supposed to be susceptible to attacks on his Copper-mining Villies.
*/
//==============================================================================


include "aiHeader.xs";     // Gets global vars, function forward declarations
include "aiMain.xs";       // The bulk of the AI 


//==============================================================================
/*	preInit()

	This function is called in main() before any of the normal initialization 
	happens.  Use it to override default values of variables as needed for 
	personality or scenario effects.
*/
//==============================================================================
void preInit(void)
{
	aiEcho("preInit() starting.");
	cvMaxAge = cAge3;			// AI is capped at Age3, just like Player.  
	cvOkToFortify = true;		// Okay to build Outposts if he wants to.
	cvOkToBuildForts = true;    // I'll let him build a fort.  For now.  JSB 8-16-05.
	// cvOkToAttack = false;	// "False" prohibits launching of any new attacks.
	// gDelayAttacks = true;	// AI cannot attack on easy if he's not been attacked by player first.  JSB 6-8-06.  This should work this way without this line - JSB/MK 6-29-06
	cvPrimaryArmyUnit = cUnitTypexpMusketWarrior;  // Force him to build mostly MusketWarriors, because they cost Coin.  JSB 2-22-06
	cvSecondaryArmyUnit = cUnitTypexpRifleRider;	// If not building Musket Warriors (above), he should mostly build RifleRiders, which have a high COin cost.  JSB 2-22-06.
}


//==============================================================================
/*	postInit()

	This function is called in main() after the normal initialization is 
	complete.  Use it to override settings and decisions made by the startup logic.
*/
//==============================================================================
void postInit(void)
{
   aiEcho("postInit() starting.");
   // btRushBoom = 0.2;		// NOTE: Setting btRushBoom to 1.0 would create an extreme rusher, setting it to -1.0 would create an extreme boomer.
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.73);  // Handicap.  85% would be 85% as strong as a non-handicapped AI.
   aiEcho("My new handicap is "+kbGetPlayerHandicap(cMyID));	// This is so he tell us his handicap setting.
}


//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================