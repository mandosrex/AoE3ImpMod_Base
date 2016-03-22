//==============================================================================
/* aiLoaderStandard.xs
   
   Create a new loader file for each personality.  Always specify loader
   file names (not the main or header files) in scenarios.
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
   btBiasInf = 1.0;
   btBiasArt = 1.0;
   btBiasCav = 0.0;
   cvOkToBuildWalls = false; 
   btOffenseDefense = 0.7;
   btRushBoom = 0.8; 

   cvMaxAge = cAge3;
   cvOkToGatherNuggets = false;
   cvDefenseReflexRadiusActive = 60.0;
   cvDefenseReflexRadiusPassive = 30.0;
   cvDefenseReflexSearchRadius = 80.0;
   cvOkToBuildForts = false;
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