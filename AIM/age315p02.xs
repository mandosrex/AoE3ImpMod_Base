//==============================================================================
/* age315p02.xs
   
	The main AI.  Warwick and his Fort and base.  He gathers resources (mainly from Supply Wagons that make it), builds up, attacks, the whole bagel.
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
	cvMaxAge = cAge4;			// AI is capped at Age4, just like Player.  JSB 8-4-05.
	cvMaxCivPop = 5;			// I added this per MK's instructions on 11-1-04. JSB.
   	cvOkToBuildWalls = false;	// He already has the walls I gave him.
	cvOkToFortify = true;		// Okay to build Outposts if he wants to.
	cvOkToBuildForts = false;   // No more forts for him. JSB 8-16-05.
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
   
}




//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================