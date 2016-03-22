//==============================================================================
/* 
   age3x05p03.xs
   
   Saratoga - Kuchler's AI
   
   This AI will be entirely trigger-driven.
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
   
   // Turn off almost everything.  No TC, no units, to training, nothing.
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





// ***********OLD AI***********


//==============================================================================
/* age3x05p02.xs
   
   Saratoga - Kuchler's AI

   This is a standard AI.  Support AI enemy.
*/
//==============================================================================


/*
include "aiHeader.xs";     // Gets global vars, function forward declarations
include "aiMain.xs";       // The bulk of the AI 
*/


//==============================================================================
/*	preInit()

	This function is called in main() before any of the normal initialization 
	happens.  Use it to override default values of variables as needed for 
	personality or scenario effects.
*/
//==============================================================================

/*
void preInit(void)
{
	aiEcho("preInit() starting.");
	cvMaxAge = cAge3;          // AI is capped at Age3, just like Player.
	cvOkToBuildWalls = false;  // He already has the walls I gave him.
   btRushBoom = 1.0;          // Rush like crazy.
   btOffenseDefense = 1.0;    // Very aggressive.
	gDelayAttacks = false;     // AI can attack on easy even if he's not been attacked.
}
*/



//==============================================================================
/*	postInit()

	This function is called in main() after the normal initialization is 
	complete.  Use it to override settings and decisions made by the startup logic.
*/
//==============================================================================

/*
void postInit(void)
{
   aiEcho("postInit() starting.");
}
*/



//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================
