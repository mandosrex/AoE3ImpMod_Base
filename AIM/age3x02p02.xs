//==============================================================================
/* age3x02p02.xs
   
   This is a standard AI.  Main AI enemy.  Player 2, German.
   Created 1-18-06.  JSB.
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
   cvMaxAge = cAge3;			// AI is capped at Age3, just like Player.  JSB 1-18-06.
   cvPrimaryArmyUnit = cUnitTypeSkirmisher;  // Force to build mostly Skirmishers.  
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