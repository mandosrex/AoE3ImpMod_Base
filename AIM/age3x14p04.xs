//==============================================================================
/* age3x14p04.xs 
   
   This is a standard AI.  This is a SEVERELY handicapped player's ally AI.  This AI is essentially present to give a nearby Sioux the illusion of life.  
   It is not really meant to help the player, and the enemy cannot even attack it.  Created 6-14-06.  JSB.
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
   cvOkToBuildWalls = false; // He already has the walls I gave him.  - Sioux cannot build walls anyway, but hey.
   cvOkToFortify = true;	 // Okay to build Outposts if he wants to.
   cvMaxAge = cAge3;		 // Capped at Age3.
   cvOkToExplore = false;    // No nugget-gathering large assault group exploring!  Normal, pathetic 1 unit exploring will still be allowed.  - JSB 4-25-06
   //btBiasArt = -0.5;		 // Low tendency to build artillery
   //btBiasInf = 0.5;		 // High tendency to build Infantry
   //btBiasCav = 0.5;		 // High tendency to build Cavalry
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
   btRushBoom = -1.0;   // NOTE: Setting btRushBoom to 1.0 would create an extreme rusher, setting it to -1.0 would create an extreme boomer.
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.05);  // Extremely handicapped.  I want him to gather, but nothing with significant nutrition. 
   aiEcho("My new handicap is "+kbGetPlayerHandicap(cMyID)); // This is to announce the handicap setting.
 }

//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================