//==============================================================================
/* age3y - CC4 - P02
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
   btRushBoom = 1.0;
   btOffenseDefense = 0.7;
   cvOkToAllyNatives = false;
   cvMaxAge = cAge2;
   cvOkToBuildForts = false;
   cvOkToExplore = false;
   cvOkToGatherNuggets = false;
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