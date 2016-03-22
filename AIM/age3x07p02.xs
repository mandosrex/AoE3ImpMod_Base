//==============================================================================
/* age3x07p02.xs
   
   This is a standard AI.  Main AI enemy.  One of 3 "parallel" AI's. Player 2, German (Hessian), Colonel Kuechler's "forward base", closest to player.
   Created 1-31-06.  JSB.

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
   cvMaxAge = cAge3;		 // Capped at Age3, just like Player.  JSB 3-30-06.
   cvOkToExplore = false;    // No nugget-gathering large assault group exploring!  Normal, pathetic 1 unit exploring will still be allowed.  - JSB 2-22-06
   cvOkToBuildWalls = false; // He already has the walls I gave him.
   cvOkToFortify = true;	 // Okay to build Outposts if he wants to.

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
   btRushBoom = 0.6;   // NOTE: Setting btRushBoom to 1.0 would create an extreme rusher, setting it to -1.0 would create an extreme boomer.
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.85);  // Cut handicap to some % of normal here. 
   aiEcho("My new handicap is "+kbGetPlayerHandicap(cMyID)); // This is so he tells us his handicap setting.
}


//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================