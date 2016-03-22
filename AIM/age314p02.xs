//==============================================================================
/* age314p02.xs
   
   Main AI.  Full econ, base, etc.
*/

//==============================================================================
/* age314p02
   
   Summary:
   This is main AI for Scenario 14.  Warwick has a pre-built town (to which he can add buidings).  
   This AI is supposed to build up, build some army, perhaps several groups, and go out and attack Native Villages, 
   with the aim of killing the chief in each village.  There are 5 Villages, and when all the chiefs are dead, the player loses.  
   This AI should also launch some attacks against the player's town itself, and of course defend it's own resource-gathering efforts
   and town. 

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
	transportArrive(-1);		//Tells the ai to start.  
   	cvOkToBuildWalls = false;	// He already has the walls I gave him.
	cvOkToFortify = true;		// Okay to build Outposts if he wants to.
	cvOkToBuildForts = true;    // I'll let him build a fort.  For now.  JSB 8-16-05.
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