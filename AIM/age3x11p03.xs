//==============================================================================
/* age3x11p03.xs
   
   This is a standard AI.  One of 3 "parallel" AI's.  Each is handicapped. This is computer player 3, Sioux.
   Created 3-13-06.  JSB. 
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
   cvOkToBuildWalls = false; // He already has the walls I gave him. -- Sioux cannot build walls anyway.
   cvOkToFortify = true;	 // Okay to build Outposts if he wants to.
   cvMaxAge = cAge4;		 // Capped at Age4, just like Player.  JSB 4-25-06.
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
   btRushBoom = 0.3;   // NOTE: Setting btRushBoom to 1.0 would create an extreme rusher, setting it to -1.0 would create an extreme boomer.
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.82);  // Handicap him, since the player must fight three AI's. 
   aiEcho("My new handicap is "+kbGetPlayerHandicap(cMyID)); // This is to announce the handicap setting.
 }


//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================