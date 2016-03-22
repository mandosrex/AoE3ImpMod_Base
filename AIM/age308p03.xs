//==============================================================================
/* age308p03.xs
   
   This is a fully operating AI, but it is a secondary enemy to the player.  
   It starts with less stuff, and is meant to be smashed to bits early in the scenario by the player's units and mostly the Fixed Gun, 
   since almost the whole town is in range of it.

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
   cvMaxAge = cAge3;			// AI is capped at Age3, just like Player.  JSB 8-4-05.
   cvOkToBuildWalls = false;	// He already has the walls I gave him.
   cvOkToFortify = true;		// He can build Outposts if he wants to.
   cvOkToBuildForts = false;	// No fort for P3.   JSB 8-16-05.
   gDelayAttacks = false;		// AI can attack on easy even if he's not been attacked.  JSB 8-16-05.
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
   btRushBoom = 0.5;   //Set personality to about 5 on the 1-to-10 rushBoom scale.
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.70);  // Cut handicap to 70% of normal here. 
   aiEcho("My new handicap is "+kbGetPlayerHandicap(cMyID)); // This is so he tell us.
 
}




//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================