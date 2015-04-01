//==============================================================================
/* aiLoaderStandard.xs
   
   Includes the main and header files for the Draugur AI by Felix Hermansson
*/
//==============================================================================



include "aiDraugurHeader.xs";     // Gets global vars, function forward declarations
include "aiDraugurMain.xs";       // The bulk of the Draugur AI



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