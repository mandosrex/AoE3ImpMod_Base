//==============================================================================
/* 
   age3x05p02.xs
   
   Battle of the Little Bighorn - Benteen's AI

   This is a standard AI.  Major AI enemy.
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
	cvMaxAge = cAge4;                // AI is capped at Age4.
	cvOkToBuildWalls = false;        // He already has the walls I gave him.
	cvOkToFortify = true;            // Okay to build Outposts if he wants to.
	cvOkToBuildForts = true;         // AI can make forts whenever he wants.
   cvOkToGatherNuggets = false;     // More fun for the player.
   cvOkToAllyNatives = false;       // Not ok for Custer to have Cheyenne allies at the Battle of Little Big Horn.

   btRushBoom = -1.0;               // Boomer.
   btOffenseDefense = -1.0;         // Defensive.
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
   switch(aiGetWorldDifficulty())
   {
      case cDifficultyEasy:
      {
         kbSetPlayerHandicap(cMyID, kbGetPlayerHandicap(cMyID)*0.80);
         break;
      }
      case cDifficultyModerate:
      {
         kbSetPlayerHandicap(cMyID, kbGetPlayerHandicap(cMyID)*0.90);
         break;
      }
      case cDifficultyHard:
      {
         kbSetPlayerHandicap(cMyID, kbGetPlayerHandicap(cMyID)*0.95);
         break;
      }
   }
}




//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================

