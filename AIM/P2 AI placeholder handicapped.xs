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
   btRushBoom = 0.0;											//Set personality to neutral on rushBoom scale.  
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.75);  // Handicap him.  75% of previous value.
   aiEcho("My new handicap is "+kbGetPlayerHandicap(cMyID));	//This is so he tells you.

}




//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================