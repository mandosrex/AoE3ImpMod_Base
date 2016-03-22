//==============================================================================
/* age303p02.xs
   
   This is the main enemy AI.  Lizzie's pirates, with full econ, land and naval units (possibly including fireships, although I may control those with an inactive AI and triggers instead).  
   This AI starts the game on a large island, but it would be great if it would launch tranny invasions on other islands sometimes.

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
   cvMaxAge = cAge3;			// Lizzie is capped at Age3, just like Player.  JSB 8-4-05.
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
	cvOkToBuildWalls = false;	// He already has the walls I gave him.
	cvOkToFortify = true;		// Okay to build Outposts if he wants to.
	cvOkToBuildForts = false;	// I don't want Lizzie filling her tiny island with a Fort.  JSB 8-16-05
	cvPrimaryArmyUnit = cUnitTypeSPCBuccaneer;  // Force Lizzie to build mostly Buccaneers
	cvSecondaryArmyUnit = cUnitTypePikeman;	// If Lizzie is not building Buccaneers, she should mostly build Pikemen.

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
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.75);  // Cut handicap to 75% of normal here.  8-23-05 JSB

}




//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
		
*/
//==============================================================================
