//==============================================================================
/* age3x08p02.xs
   
   This is a standard AI.  Main AI enemy.  Player 2, British.  This player is will be very defensive.  

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
	cvOkToFortify = false;		// Okay to build Outposts if he wants to.
	gDelayAttacks = true;		// AI can attack on easy even if he's not been attacked.  JSB 8-16-05.
	btBiasArt = 0.0;			// Medium tendency to build artillery
    btBiasInf = 0.25;			// High tendency to build Infantry
    btBiasCav = -0.25;		    // Low tendency to build Cavalry
	btOffenseDefense = .5;     // Higher tendency to attack.  A personality pushed toward defensive will add towers and upgrade them.
	cvOkToExplore = false;  // Not Okay Explore the map.
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
   //btRushBoom = -0.5;   // NOTE: Setting btRushBoom to 1.0 would create an extreme rusher, setting it to -1.0 would create an extreme boomer.
   //kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.99);  // Handicap.  99% would be 99% as strong as a non-handicapped AI.
   //aiEcho("My new handicap is "+kbGetPlayerHandicap(cMyID)); // This is so he tell us his handicap setting.
}


//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================

void myFunc(int x=0)

{
    if (x > 0)
	{
        btRushBoom = -0.25;
	}
    else
	{
        btRushBoom = 0.50;
		cvOkToExplore = true;
	}
}
