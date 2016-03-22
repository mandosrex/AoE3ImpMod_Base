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
   btRushBoom = 1.0;
   btOffenseDefense = 1.0;
   btBiasArt = 0.2;
   btBiasInf = 1.0;
   btBiasCav = 0.5;

   cvMaxAge = cAge3;
   cvDefenseReflexRadiusActive = 60.0;
   cvDefenseReflexRadiusPassive = 30.0;
   cvDefenseReflexSearchRadius = 60.0;
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