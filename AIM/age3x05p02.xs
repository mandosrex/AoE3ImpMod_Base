//==============================================================================
/* age3x05p02.xs
   
   Saratoga - Burgoyne's AI

   This is a standard AI.  Main AI enemy.
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
	cvMaxAge = cAge3;             // AI is capped at Age3, just like Player.
	cvOkToBuildWalls = false;     // He already has the walls I gave him.
	cvOkToFortify = true;         // Okay to build Outposts if he wants to.
	cvOkToBuildForts = false;     // AI can make forts whenever he wants.
   cvOkToGatherNuggets = false;  // More fun for the player.

   btRushBoom = -0.25;            // Boom.
   btOffenseDefense = -0.5;       // Very aggressive.
	gDelayAttacks = true;         // AI can attack on easy even if he's not been attacked.
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
   kbSetPlayerHandicap(cMyID, kbGetPlayerHandicap(cMyID)*0.70);
}



//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================

rule extraForts   // Make the AI use extra fort wagons.  If it has a forward base and notices an extra wagon, pretend we don't have a forward base yet.
minInterval 10
active
{
   if ( (gForwardBaseState == cForwardBaseStateActive) && (kbUnitCount(cMyID, cUnitTypeFortWagon, cUnitStateAlive) > 0) )
   {  
      gForwardBaseState = cForwardBaseStateNone;
      aiEcho(" ");
      aiEcho("PREPARING FOR NEW FORWARD BASE.");
      aiEcho(" ");
   }
}