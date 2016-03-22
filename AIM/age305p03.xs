//==============================================================================
/* age305p03.xs
   
   This is an inactive AI.  Used for Mine guard groups to have defend plans around the mines.  Also used for periodic triggered attacking armies 
   on Aztec City area.
   
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
   
   // Turn off almost everything.  No TC, no units, no training, nothing.
   cvInactiveAI = true;
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