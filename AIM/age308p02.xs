//==============================================================================
/* age308p02.xs
   
   This the main enemy AI for this scenario.  "Lake of the Moon" scenario.  
   AI has Fort walls, starting base are, econ, navy, everything.  
   It would be great if this AI would both periodically attack with it's boats and tranny some units via boats to the south shore of the lake, attack.

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
   cvMaxAge = cAge3;			// AI is capped at Age3, just like Player.  JSB 8-4-05.
   transportArrive(-1);      //Tells the ai to start.  
   	vector location = kbUnitGetPosition(getUnit(cUnitTypeLogicalTypeNavalMilitary, cMyID, cUnitStateAlive));
	int explorePlan = aiPlanCreate("Water Explore", cPlanExplore);                // Makes navy explore, as it won't otherwise. 5-24-05
	aiPlanSetVariableBool(explorePlan, cExplorePlanReExploreAreas, 0, false);
	aiPlanSetInitialPosition(explorePlan, location);
	aiPlanSetDesiredPriority(explorePlan, 25);   
	aiPlanAddUnitType(explorePlan, cUnitTypeLogicalTypeNavalMilitary, 1, 1, 1);
	aiPlanSetEscrowID(explorePlan, cEconomyEscrowID);
	aiPlanSetVariableBool(explorePlan, cExplorePlanDoLoops, 0, false);
	aiPlanSetActive(explorePlan);
	cvOkToBuildWalls = false;  // He already has the walls I gave him.
	cvOkToFortify = true;	   // Okay to build Outposts if he wants to.
	cvPrimaryArmyUnit = cUnitTypeBoneguard;  // Force Alain to build mostly Boneguard.  JSB 8-16-05
	cvSecondaryArmyUnit = cUnitTypeUhlan;	// If Alain is not building Boneguard, he should mostly build Uhlan.  JSB 8-16-05
	cvOkToBuildForts = true;    // I'll let him build a fort.  For now.  JSB 8-16-05.
	gDelayAttacks = false;		// AI can attack on easy even if he's not been attacked.  JSB 8-16-05.
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
   btRushBoom = 0.0;   //Set personality to neutral on rushBoom scale.  
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.80);  // Handicap him.  80% of previous value.
   aiEcho("My new handicap is "+kbGetPlayerHandicap(cMyID)); //This is so he tells you.
   
}




//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================