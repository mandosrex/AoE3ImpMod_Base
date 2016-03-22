//==============================================================================
/* age3x07p03.xs
   
   This is a standard AI.  One of 3 "parallel" AI's. Player 3, German (Hessian), Colonel Kuechler's eastern base.
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
   cvOkToBuildWalls = false; // He already has the walls I gave him.
   cvOkToFortify = true;	 // Okay to build Outposts if he wants to.
   btBiasArt = -0.5;		 // Low tendency to build artillery
   // btBiasInf = 0.5;		 // High tendency to build Infantry
   btBiasCav = 0.5;			 // High tendency to build Cavalry
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
   btRushBoom = -0.1;   // NOTE: Setting btRushBoom to 1.0 would create an extreme rusher, setting it to -1.0 would create an extreme boomer.
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.50);  // Handicap him, since the player must fight two AI's at this point in scn. 
   aiEcho("My new handicap is "+kbGetPlayerHandicap(cMyID)); // This is so he tell us his handicap setting.
}




//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================