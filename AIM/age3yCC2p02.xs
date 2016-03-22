//==============================================================================
/* age3ycc2 - P2
   
  AI file for the Indians
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
   btRushBoom = 0.8;
   btOffenseDefense = 0.5;
   btBiasInf = 0.9;
   cvOkToAllyNatives = false;
   cvMaxAge = cAge3;
   cvOkToBuildForts = false;
   cvOkToExplore = true;
   cvOkToGatherNuggets = false;
   cvOkToBuildWalls = false;
   
   cvOkToBuildConsulate = false;
   
   cvPrimaryArmyUnit = cUnitTypeypRajput;
   cvSecondaryArmyUnit = cUnitTypeypSowar;
   cvTertiaryArmyUnit = cUnitTypeypMahout;
   
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