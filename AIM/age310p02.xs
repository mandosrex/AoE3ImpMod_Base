//==============================================================================
/* aiLoaderStandard.xs
   
   Create a new loader file for each personality.  Always specify loader
   file names (not the main or header files) in scenarios.
   
   AI for Scenario 310, Player 2: British Group that comes in part way through the 
   Scenario after the player is ambushed by the British at the Cherokee Camp.
   AI Start is created inside the player's old town.
   
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
   
   // No Natives or Trade Routes, so turn them off.  
   cvOkToSelectMissions = false;
   cvOkToAllyNatives = false;
   cvOkToClaimTrade = false;
   cvOkToResign  = false;
   cvOkToBuildWalls = false;
   cvMaxAge = cAge4;
   
   if (aiGetWorldDifficulty() == cDifficultyEasy)
		cvOkToBuildForts = false;
	
   
   
   
   // Note:  Leaving cvOkToAttack true so that this script WILL be able to follow attack orders from triggers.

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



// Called by the aiFunc() trigger effect.  Tells the AI that it's now OK to go ahead and select missions, although
// he still won't be allowed to get native allies or trade sites.
void goAheadAndAttack(int bogus = -1)
{
	cvOkToSelectMissions = true;
	aiEcho("goAheadAndAttack is running");
}