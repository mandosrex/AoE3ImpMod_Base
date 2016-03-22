//==============================================================================
/* age305p04.xs
   
   This inactive AI controls the Aztecs.  The Aztec city has no economy, but starts with some Aztec warriors and periodically gets 
   more through triggers which spawn them.  
   This AI uses these warriors to scout and defend it's city.  
   I don't really want them to attack the enemy AI city because it is really well fortified and they'll all just die and that will 
   be boring for the player.
   
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