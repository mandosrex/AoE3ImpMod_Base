// Silk Road 
// PJJ
// Sept 2006 ~ started with a modified version of pampas

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

  int whichVersion = rmRandInt(1,3);
  //~ whichVersion = 3; 
 
  // initialize map type variables
  string nativeCiv1 = "";
  string nativeCiv2 = "";
  
  string nativeString1= "";
  string nativeString2= "";
 
  string baseMix = "";
  string baseTerrain = "";
 
  string forestType = "";
  string startTreeType = "";
  
  string patchTerrain = "";
  string patchType1 = "";
  string patchType2 = "";
  
  string mapType1 = "";
  string mapType2 = "";
  
  string herdableType = "";
  string huntable1 = "";
  string huntable2 = "";
  
  string lightingType = "";
  
  string guardianType = "";
  string guardianDistance = "35.0";
  int numberPosts = 5;
  int triggerCounter = 0; 
  
  string tradeRouteType = "";
  
  // Grassy - Yellow River
  if(whichVersion == 1) {
    nativeCiv1 = "Shaolin";
    nativeCiv2 = "Zen";
    nativeString1 = "native shaolin temple yr 0";
    nativeString2 = "native zen temple yr 0";
    baseMix = "yellow_river_a";
    baseTerrain = "patagonia\ground_dirt1_pat";
    startTreeType = "ypTreeBamboo";
    forestType = "Yellow River Forest";
    patchTerrain = "yellow_river\grass1_yellow_riv";
    patchType1 = "yellow_river\grass2_yellow_riv";
    patchType2 = "yellow_river\stone1_yellow_riv";
    mapType1 = "silkRoad1";
    mapType2 = "grass";
    herdableType = "ypWaterBuffalo";
    huntable1 = "ypIbex";
    huntable2 = "ypMarcoPoloSheep";
    lightingType = "borneo";
    tradeRouteType = "water";  
    guardianType = "ypBlindMonk";
  }
  
  // Desert/Plains - Mongolia
  else if (whichVersion == 2) {
    nativeCiv1 = "sufi";
    nativeCiv2 = "shaolin";
    nativeString1 = "native sufi mosque mongol ";
    nativeString2 = "native shaolin temple mongol 0";
    baseMix = "mongolia_grass_b";
    baseTerrain = "Mongolia\ground_grass4_mongol";
    forestType = "Mongolian Forest";
    startTreeType = "ypTreeSaxaul";
    patchTerrain = "Mongolia\ground_grass4_mongol";
    patchType1 = "Mongolia\ground_grass5_mongol";
    patchType2 = "Mongolia\ground_grass2_mongol";
    mapType1 = "silkRoad2";
    mapType2 = "grass";
    herdableType = "ypYak";
    huntable1 = "ypSaiga";
    huntable2 = "ypMuskDeer";    
    lightingType = "mongolia";
    tradeRouteType = "water";
    guardianType = "ypWokou";
  }
  
  // Snowy - Himalayas
  else {
    nativeCiv1 = "bhakti";
    nativeCiv2 = "udasi";
    nativeString1 = "native bhakti village himal ";
    nativeString2 = "native udasi village himal ";
    baseMix = "himalayas_a";
    baseTerrain = "himalayas\ground_dirt5_himal";
    forestType = "Himalayas Forest";
    startTreeType = "ypTreeHimalayas";
    patchTerrain = "himalayas\ground_dirt5_himal";
    patchType1 = "himalayas\ground_dirt8_himal";
    patchType2 = "himalayas\ground_dirt7_himal";
    mapType1 = "silkRoad3";
    mapType2 = "grass";
    herdableType = "ypYak";
    huntable1 = "ypSerow";
    huntable2 = "ypIbex";   
    lightingType = "himalayas";
    tradeRouteType = "water";
    guardianType = "ypWaywardRonin";
  }
  
// Natives
   int subCiv0=-1;
   int subCiv1=-1;

  if (rmAllocateSubCivs(2) == true) {
    // 1st Native Civ
    subCiv0=rmGetCivID(nativeCiv1);
    if (subCiv0 >= 0)
      rmSetSubCiv(0, nativeCiv1);

    // 2nd Native Civ
    subCiv1=rmGetCivID(nativeCiv2);
    if (subCiv1 >= 0)
      rmSetSubCiv(1, nativeCiv2);
  }
	
// Map Basics
	int playerTiles = 25000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 24000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 23000;		

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 10, 0.4, 7.0);
	rmSetMapElevationHeightBlend(1);
	
	rmSetSeaLevel(1.0);
	rmSetLightingSet(lightingType);

	rmSetBaseTerrainMix(baseMix);
	rmTerrainInitialize(baseTerrain, 0.0);
	rmEnableLocalWater(false);
  rmSetMapType(mapType1);
	rmSetMapType(mapType2);
	rmSetMapType("land");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);

	chooseMercs();
	
// Classes
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classPatch");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("classNugget");
	rmDefineClass("natives");

  bool weird = false;
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
    
  if (cNumberTeams > 2 || (teamZeroCount - teamOneCount) > 2 || (teamOneCount - teamZeroCount) > 2)
    weird = true;

// Constraints
    
	// Map edge constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(12), rmZTilesToFraction(12), 1.0-rmXTilesToFraction(12), 1.0-rmZTilesToFraction(12), 0.01);

	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 25.0);
  int longPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players long", classPlayer, 45.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players medium", classPlayer, 15.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 5.0);
  int playerConstraintNugget = rmCreateClassDistanceConstraint("nuggets stay away from players long", classPlayer, 55.0);
  int avoidKOTH = rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 6.0);
  int nativePlayerConstraint = rmCreateTypeDistanceConstraint("avoid TCs", "TownCenter", 70.0);
  int avoidTC = rmCreateTypeDistanceConstraint("tc avoid", "TownCenter", 35.0);
  //~ int nativePlayerConstraint = rmCreateClassDistanceConstraint("avoid TCs", classPlayer, 45.0);

	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int shortAvoidResource=rmCreateTypeDistanceConstraint("resource avoid resource short", "resource", 5.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);
	   
	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

  // resource avoidance
	int avoidSilver=rmCreateTypeDistanceConstraint("gold avoid gold", "Mine", 85.0);
	int mediumAvoidSilver=rmCreateTypeDistanceConstraint("medium gold avoid gold", "Mine", 30.0);
	int avoidHuntable1=rmCreateTypeDistanceConstraint("avoid deer", huntable1, 60.0);
	int avoidHuntable2=rmCreateTypeDistanceConstraint("avoid tapir", huntable2, 60.0);
	int avoidNuggets=rmCreateTypeDistanceConstraint("nugget vs. nugget", "AbstractNugget", 20.0);
	int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget vs. nugget far", "AbstractNugget", 70.0);
  int avoidHerdable=rmCreateTypeDistanceConstraint("herdables avoid herdables", herdableType, 75.0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int circleConstraintTwo=rmCreatePieConstraint("circle Constraint 2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Unit avoidance
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), rmXFractionToMeters(0.2));
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 12.0);
	int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other short", rmClassID("importantItem"), 7.0);
	int farAvoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives alot", rmClassID("natives"), 80.0);

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);

	// Trade route avoidance.
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route short", 6.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
	int avoidTradeRouteSocketsShort=rmCreateTypeDistanceConstraint("avoid trade route sockets short", "ypTradingPostCapture", 4.0);
  int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid trade route sockets", "ypTradingPostCapture", 20.0);
	int avoidTradeRouteSocketsFar=rmCreateTypeDistanceConstraint("avoid trade route sockets far", "ypTradingPostCapture", 40.0);
	int avoidMineSockets=rmCreateTypeDistanceConstraint("avoid mine sockets", "mine", 10.0);

// ************************** DEFINE OBJECTS ****************************
	
  int deerID=rmCreateObjectDef("huntable1");
	rmAddObjectDefItem(deerID, huntable1, rmRandInt(8,10), 6.0);
	rmSetObjectDefCreateHerd(deerID, true);
	rmSetObjectDefMinDistance(deerID, 0.0);
	rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(deerID, avoidResource);
	rmAddObjectDefConstraint(deerID, playerConstraint);
	rmAddObjectDefConstraint(deerID, avoidImpassableLand);
	rmAddObjectDefConstraint(deerID, avoidHuntable1);
	rmAddObjectDefConstraint(deerID, avoidHuntable2);
  rmAddObjectDefConstraint(deerID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(deerID, avoidTradeRouteSockets);
  
  int tapirID=rmCreateObjectDef("huntable2");
	rmAddObjectDefItem(tapirID, huntable2, rmRandInt(10,12), 6.0);
	rmSetObjectDefCreateHerd(tapirID, true);
	rmSetObjectDefMinDistance(tapirID, 0.0);
	rmSetObjectDefMaxDistance(tapirID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(tapirID, avoidResource);
	rmAddObjectDefConstraint(tapirID, playerConstraint);
	rmAddObjectDefConstraint(tapirID, avoidImpassableLand);
	rmAddObjectDefConstraint(tapirID, avoidHuntable1);
	rmAddObjectDefConstraint(tapirID, avoidHuntable2);
	rmAddObjectDefConstraint(tapirID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(tapirID, avoidTradeRouteSockets);
  
  int StartDeerID=rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(StartDeerID, huntable1, 7, 4.0);
	rmSetObjectDefMinDistance(StartDeerID, 12.0);
	rmSetObjectDefMaxDistance(StartDeerID, 18.0);
	rmSetObjectDefCreateHerd(StartDeerID, false);
	rmAddObjectDefConstraint(StartDeerID, avoidHuntable1);    
	rmAddObjectDefConstraint(StartDeerID, avoidHuntable2);    
   
	// -------------Done defining objects
  // Text
  rmSetStatusText("",0.10);
	
  // Trade routes
  int tradeRouteID = rmCreateTradeRoute();

  int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
  rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

  rmAddObjectDefItem(socketID, "ypTradingPostCapture", 1, 6.0);
  rmAddObjectDefItem(socketID, "Nugget", 1, 6.0);
  rmSetNuggetDifficulty(99, 99);
	rmSetObjectDefAllowOverlap(socketID, false);
  rmSetObjectDefMinDistance(socketID, 10.0);
  rmSetObjectDefMaxDistance(socketID, 12.0);
 	rmAddObjectDefConstraint(socketID, circleConstraintTwo);
  rmAddObjectDefConstraint(socketID, shortAvoidTradeRoute);

  rmAddTradeRouteWaypoint(tradeRouteID, 0, .5);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.165, .6);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.33, .4);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.5, .5);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.665, .6);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.83, .4);
  rmAddTradeRouteWaypoint(tradeRouteID, 1, .5);

  bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, tradeRouteType);
  if(placedTradeRoute == false)
    rmEchoError("Failed to place trade route"); 
  
	// add the sockets along the trade route.
  vector socketLoc  = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);

  int tempCounter = 0;

  if(cNumberNonGaiaPlayers > 3)
    numberPosts = 7;
    
  if(cNumberNonGaiaPlayers > 5) 
    numberPosts = 9;
    
  float loc0 = 0.1;
  float loc1 = 0.3;
  float loc2 = 0.5;
  float loc3 = 0.7;
  float loc4 = 0.9;
  float loc5 = 0.2;
  float loc6 = 0.8;
  float loc7 = 0.4; 
  float loc8 = 0.6;
  float tempLoc = 0.0;

  for(i = 0; < numberPosts) {
    
    if(i == 0)
      tempLoc = loc0;
    
    else if (i == 1)
      tempLoc = loc1;
    
    else if (i == 2)
      tempLoc = loc2;
    
    else if (i == 3)
      tempLoc = loc3;
    
    else if (i == 4)
      tempLoc = loc4;
    
    else if (i == 5)
      tempLoc = loc5;
    
    else if (i == 6)
      tempLoc = loc6;
      
    else if (i == 7)
      tempLoc = loc7;
      
    else if (i == 8)
      tempLoc = loc8;
    
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, tempLoc);
  
    // if we fail to place something, will be the thuggees, so knock the counter down one so the rest of the triggers still line up on the posts
    if(rmPlaceObjectDefAtPoint(socketID, 0, socketLoc) < 2) {
      tempCounter++;
    }
    
    // otherwise, set up triggers
    else {
      rmCreateTrigger("GuardianDeath"+triggerCounter);
      rmSwitchToTrigger(rmTriggerID("GuardianDeath"+triggerCounter));
      rmSetTriggerPriority(3); 
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);
        
      rmAddTriggerCondition("Units In Area");
      rmSetTriggerConditionParamInt("DstObject", rmGetUnitPlaced(socketID, triggerCounter), false);
      rmSetTriggerConditionParam("Player", "0", false);
      rmSetTriggerConditionParam("UnitType", guardianType, false);
      rmSetTriggerConditionParam("Dist", guardianDistance, false);
      rmSetTriggerConditionParam("Op", "<=", false);
      rmSetTriggerConditionParam("Count", "0", false);  
      
      rmAddTriggerEffect("Unit Action Suspend");
      rmSetTriggerEffectParamInt("SrcObject", rmGetUnitPlaced(socketID, triggerCounter), false);
      rmSetTriggerEffectParam("ActionName", "AutoConvert", false);
      rmSetTriggerEffectParam("Suspend", "False", false);
      
      rmCreateTrigger("DisableAutoconvert"+triggerCounter);
      rmSwitchToTrigger(rmTriggerID("DisableAutoconvert"+triggerCounter));
      rmSetTriggerPriority(3); 
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);
        
      rmAddTriggerCondition("Always");
      
      rmAddTriggerEffect("Unit Action Suspend");
      
      rmSetTriggerEffectParamInt("SrcObject", rmGetUnitPlaced(socketID, triggerCounter), false);
      
      rmSetTriggerEffectParam("ActionName", "AutoConvert", false);
      rmSetTriggerEffectParam("Suspend", "True", false);
      
      tempCounter = tempCounter + 2;
    }
    
    triggerCounter = tempCounter;
  }

// Players
  
  // Set up player areas.
  float playerFraction=rmAreaTilesToFraction(100);
  for(i=1; <cNumberPlayers) {
    int id=rmCreateArea("Player"+i);
    rmSetPlayerArea(i, id);
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classPlayer);
    rmAddAreaConstraint(id, avoidTradeRouteSockets); 
    rmAddAreaConstraint(id, shortAvoidImportantItem); 
    rmAddAreaConstraint(id, playerConstraint); 
    rmAddAreaConstraint(id, playerEdgeConstraint); 
    rmSetAreaCoherence(id, 1.0);
    //~ rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, false);
  }
  
  // Build the areas.
  rmBuildAllAreas();
  
   // Text
   rmSetStatusText("",0.20);
  
   // Players start in lines on either side of the "road"
  
  if (cNumberTeams == 2) {
    
    rmSetPlacementTeam(0);
    rmPlacePlayersLine(.3, .2, .7, .2, .05, .05);
  
    rmSetPlacementTeam(1);
    rmPlacePlayersLine(.7, .8, .3, .8, .05, .05);
  }
  
  // ffa
   else {
    rmSetTeamSpacingModifier(0.3);
    rmPlacePlayersCircular(0.3, 0.3, 0);
  }

  // starting resources
  int TCfloat = -1;
	if (cNumberNonGaiaPlayers <= 4)
		TCfloat = 15;
  else if (cNumberTeams > 2)
    TCfloat = 15;
	else if (weird)
    TCfloat = 50;
  else
		TCfloat = 20;

  int startingTCID= rmCreateObjectDef("startingTC");
	if (rmGetNomadStart()) {
			rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 5.0);
  }
		
  else {
    rmAddObjectDefItem(startingTCID, "townCenter", 1, 5.0);
  }

  rmSetObjectDefMinDistance(startingTCID, 0);
	rmSetObjectDefMaxDistance(startingTCID, TCfloat);
	rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
  rmAddObjectDefConstraint(startingTCID, avoidTC);
  rmAddObjectDefConstraint(startingTCID, avoidTradeRouteSockets);
	rmAddObjectDefToClass(startingTCID, rmClassID("player"));

  int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 8, 6.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 16);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 22);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImportantItem);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRouteSockets);

	int StartBerriesID=rmCreateObjectDef("starting berries");
	rmAddObjectDefItem(StartBerriesID, "berrybush", 4, 5.0);
	rmSetObjectDefMinDistance(StartBerriesID, 10);
	rmSetObjectDefMaxDistance(StartBerriesID, 20);
	rmAddObjectDefConstraint(StartBerriesID, avoidStartResource);
	rmAddObjectDefConstraint(StartBerriesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartBerriesID, shortPlayerConstraint);

   // Text
   rmSetStatusText("",0.30);

  int startSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(startSilverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(startSilverID, 12.0);
	rmSetObjectDefMaxDistance(startSilverID, 20.0);
	rmAddObjectDefConstraint(startSilverID, avoidAll);
	rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
  rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);

  int playerCrateID=rmCreateObjectDef("bonus starting wood");
  rmAddObjectDefItem(playerCrateID, "crateOfWood", 3, 3.0);
  rmSetObjectDefMinDistance(playerCrateID, 4);
  rmSetObjectDefMaxDistance(playerCrateID, 8);
  rmAddObjectDefConstraint(playerCrateID, avoidStartResource);
  rmAddObjectDefConstraint(playerCrateID, shortAvoidImpassableLand);
  
  	// Market
	int startResourceBuildingID=rmCreateObjectDef("starting resource building");
  rmAddObjectDefItem(startResourceBuildingID, "Market", 1, 0.0);
	rmSetObjectDefMinDistance(startResourceBuildingID, 16.0);
	rmSetObjectDefMaxDistance(startResourceBuildingID, 20.0);
  rmAddObjectDefConstraint(startResourceBuildingID, avoidAll);
	rmAddObjectDefConstraint(startResourceBuildingID, avoidImpassableLand);
  
  // Asian Market
  int startResourceBuildingAsianID=rmCreateObjectDef("starting resource building asian");
  rmAddObjectDefItem(startResourceBuildingAsianID, "ypTradeMarketAsian", 1, 0.0);
	rmSetObjectDefMinDistance(startResourceBuildingAsianID, 16.0);
	rmSetObjectDefMaxDistance(startResourceBuildingAsianID, 20.0);
  rmAddObjectDefConstraint(startResourceBuildingAsianID, avoidAll);
	rmAddObjectDefConstraint(startResourceBuildingAsianID, avoidImpassableLand);
  
  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 15.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 20.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
  
	// Text
	rmSetStatusText("",0.40);

	for(i=1; < cNumberPlayers) {
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(startSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Berry Bushes
		rmPlaceObjectDefAtLoc(StartBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(StartDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Place a nugget for the player
    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    if(rmGetNomadStart() == false) {
	    if (rmGetPlayerCiv(i) ==  rmGetCivID("Chinese") || rmGetPlayerCiv(i) == rmGetCivID("Indians")) {
        rmPlaceObjectDefAtLoc(startResourceBuildingAsianID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      }

      else if(rmGetPlayerCiv(i) ==  rmGetCivID("Japanese")) {
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
        rmPlaceObjectDefAtLoc(startResourceBuildingAsianID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));  
      }
      
      else {
        rmPlaceObjectDefAtLoc(startResourceBuildingID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      }


    }      
	}

  // Natives
  
    //1
    int nativeArea1=rmCreateArea("native1");
    rmSetAreaSize(nativeArea1, .04, .04);
    rmAddAreaConstraint(nativeArea1, circleConstraintTwo); 
    rmSetAreaCoherence(nativeArea1, 1.0);
  
    if(cNumberTeams == 2) {
      rmSetAreaLocation(nativeArea1, 0.35, 0.6);
    }
    
    else {
      rmSetAreaLocation(nativeArea1, 0.6, 0.075);
    }
    
    //2
    int nativeArea2=rmCreateArea("native2");
    rmSetAreaSize(nativeArea2, .04, .04);
    rmAddAreaConstraint(nativeArea2, circleConstraintTwo); 
    rmSetAreaCoherence(nativeArea2, 1.0);
  
    if(cNumberTeams == 2) {
      rmSetAreaLocation(nativeArea2, 0.65, 0.4);
    }
    
    else {
      rmSetAreaLocation(nativeArea2, 0.375, 0.9);
    }
    
    //3
    int nativeArea3=rmCreateArea("native3");
    rmSetAreaSize(nativeArea3, .045, .045);
    rmAddAreaConstraint(nativeArea3, circleConstraintTwo);
    rmSetAreaCoherence(nativeArea3, 1.0);
  
    if(cNumberTeams == 2) {
      rmSetAreaLocation(nativeArea3, 0.165, 0.3);
    }
    
    else {
      rmSetAreaLocation(nativeArea3, 0.95, 0.625);
    }
    
    //4
    int nativeArea4=rmCreateArea("native4");
    rmSetAreaSize(nativeArea4, .045, .045);
    rmAddAreaConstraint(nativeArea4, circleConstraintTwo); 
    rmSetAreaCoherence(nativeArea4, 1.0);
  
    if(cNumberTeams == 2) {
      rmSetAreaLocation(nativeArea4, 0.83, 0.7);
    }
    
    else {
      rmSetAreaLocation(nativeArea4, 0.05, 0.375);
    }
    
    //5
    int nativeArea5=rmCreateArea("native5");
    rmSetAreaSize(nativeArea5, .045, .045);
    rmAddAreaConstraint(nativeArea5, circleConstraintTwo); 
    rmSetAreaCoherence(nativeArea5, 1.0);
  
    if(cNumberTeams == 2) {
      rmSetAreaLocation(nativeArea5, 0.855, 0.31);
    }
    
    else {
      rmSetAreaLocation(nativeArea5, 0.8, 0.85);
    }
    
    //6
    int nativeArea6=rmCreateArea("native6");
    rmSetAreaSize(nativeArea6, .045, .045);
    rmAddAreaConstraint(nativeArea6, circleConstraintTwo); 
    rmSetAreaCoherence(nativeArea6, 1.0);
  
    if(cNumberTeams == 2) {
      rmSetAreaLocation(nativeArea6, 0.145, 0.69);
    }
    
    else {
      rmSetAreaLocation(nativeArea6, 0.2, 0.15);
    }
    
    rmBuildAllAreas();
  
  // always at least one native village of each type
  if (subCiv0 == rmGetCivID(nativeCiv1)) {  
    int nativeVillage1Type = rmRandInt(1,5);
    int nativeVillage1ID = rmCreateGrouping("native village 1", nativeString1+nativeVillage1Type);
    rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage1ID, 10.0);
    rmAddGroupingToClass(nativeVillage1ID, rmClassID("importantItem"));
    rmAddGroupingConstraint(nativeVillage1ID, nativePlayerConstraint);
    rmAddGroupingConstraint(nativeVillage1ID, avoidTradeRoute);
    rmAddGroupingConstraint(nativeVillage1ID, circleConstraintTwo);
    rmAddGroupingConstraint(nativeVillage1ID, avoidTradeRouteSockets);
    rmAddGroupingConstraint(nativeVillage1ID, avoidImportantItem);
    rmPlaceGroupingInArea(nativeVillage1ID, 0, nativeArea1, 1);
  }	

  if (subCiv1 == rmGetCivID(nativeCiv2)) {  
    int nativeVillage2Type = rmRandInt(1,5);
    int nativeVillage2ID = rmCreateGrouping("native village 2", nativeString2+nativeVillage2Type);
    rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage2ID, 10.0);
    rmAddGroupingToClass(nativeVillage2ID, rmClassID("importantItem"));
    rmAddGroupingConstraint(nativeVillage2ID, nativePlayerConstraint);
    rmAddGroupingConstraint(nativeVillage2ID, avoidTradeRoute);
    rmAddGroupingConstraint(nativeVillage2ID, circleConstraintTwo);
    rmAddGroupingConstraint(nativeVillage2ID, avoidTradeRouteSockets);
    rmAddGroupingConstraint(nativeVillage2ID, avoidImportantItem);
    rmPlaceGroupingInArea(nativeVillage2ID, 0, nativeArea2, 1);
  }   

  // Two more Natives for four and above
  int whichNative = 0;
  
  if(cNumberNonGaiaPlayers > 3) {
    int randomNativeType = rmRandInt(1,5);
    int randomNativeID = 0;
    whichNative = rmRandInt(1,2);
    if(whichNative == 1)
      randomNativeID = rmCreateGrouping("random village 1a", nativeString1+randomNativeType);
    else
      randomNativeID = rmCreateGrouping("random village 1b", nativeString2+randomNativeType);
    rmSetGroupingMinDistance(randomNativeID, 0.0);
    rmSetGroupingMaxDistance(randomNativeID, 10.0);
    rmAddGroupingToClass(randomNativeID, rmClassID("importantItem"));
    rmAddGroupingConstraint(randomNativeID, nativePlayerConstraint);
    rmAddGroupingConstraint(randomNativeID, avoidTradeRoute);
    rmAddGroupingConstraint(randomNativeID, circleConstraintTwo);
    rmAddGroupingConstraint(randomNativeID, avoidTradeRouteSockets);
    rmAddGroupingConstraint(randomNativeID, avoidImportantItem);
    rmPlaceGroupingInArea(randomNativeID, 0, nativeArea3, 1);
    
    int randomNativeType1 = rmRandInt(1,5);
    int randomNativeID1 = 0;
    whichNative = rmRandInt(1,2);
    if(whichNative == 1)
      randomNativeID1 = rmCreateGrouping("random village 2a", nativeString1+randomNativeType1);
    else
      randomNativeID1 = rmCreateGrouping("random village 2b", nativeString2+randomNativeType1);
    rmSetGroupingMinDistance(randomNativeID1, 0.0);
    rmSetGroupingMaxDistance(randomNativeID1, 10.0);
    rmAddGroupingToClass(randomNativeID1, rmClassID("importantItem"));
    rmAddGroupingConstraint(randomNativeID1, nativePlayerConstraint);
    rmAddGroupingConstraint(randomNativeID1, avoidTradeRoute);
    rmAddGroupingConstraint(randomNativeID1, circleConstraintTwo);
    rmAddGroupingConstraint(randomNativeID1, avoidTradeRouteSockets);
    rmAddGroupingConstraint(randomNativeID1, avoidImportantItem);
    rmPlaceGroupingInArea(randomNativeID1, 0, nativeArea4, 1);
  }
  
  // Two more natives for 6 and above
  if(cNumberNonGaiaPlayers > 5) {
    int randomNativeType2 = rmRandInt(1,5);
    int randomNativeID2 = 0;
    whichNative = rmRandInt(1,2);
    if(whichNative == 1)
      randomNativeID2 = rmCreateGrouping("random village 3a", nativeString1+randomNativeType2);
    else
      randomNativeID2 = rmCreateGrouping("random village 3b", nativeString2+randomNativeType2);
    rmSetGroupingMinDistance(randomNativeID2, 0.0);
    rmSetGroupingMaxDistance(randomNativeID2, 10.0);
    rmAddGroupingToClass(randomNativeID2, rmClassID("importantItem"));
    rmAddGroupingConstraint(randomNativeID2, nativePlayerConstraint);
    rmAddGroupingConstraint(randomNativeID2, avoidTradeRoute);
    rmAddGroupingConstraint(randomNativeID2, circleConstraintTwo);
    rmAddGroupingConstraint(randomNativeID2, avoidTradeRouteSockets);
    rmAddGroupingConstraint(randomNativeID2, avoidImportantItem);
    rmPlaceGroupingInArea(randomNativeID2, 0, nativeArea5, 1);
    
    int randomNativeType3 = rmRandInt(1,5);
    int randomNativeID3 = 0;
    whichNative = rmRandInt(1,2);
    if(whichNative == 1)
      randomNativeID3 = rmCreateGrouping("random village 4a", nativeString1+randomNativeType3);
    else
      randomNativeID3 = rmCreateGrouping("random village 4b", nativeString2+randomNativeType3);
    rmSetGroupingMinDistance(randomNativeID3, 0.0);
    rmSetGroupingMaxDistance(randomNativeID3, 10.0);
    rmAddGroupingToClass(randomNativeID3, rmClassID("importantItem"));
    rmAddGroupingConstraint(randomNativeID3, nativePlayerConstraint);
    rmAddGroupingConstraint(randomNativeID3, avoidTradeRoute);
    rmAddGroupingConstraint(randomNativeID3, circleConstraintTwo);
    rmAddGroupingConstraint(randomNativeID3, avoidTradeRouteSockets);
    rmAddGroupingConstraint(randomNativeID3, avoidImportantItem);
    rmPlaceGroupingInArea(randomNativeID3, 0, nativeArea6, 1);
  }
  
	// Text
	rmSetStatusText("",0.60);

  // Vary some terrain
  for (i=0; < 30) {
    int patch=rmCreateArea("first patch "+i);
    rmSetAreaWarnFailure(patch, false);
    rmSetAreaSize(patch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
    rmSetAreaMix(patch, baseMix);
    rmSetAreaTerrainType(patch, patchTerrain);
    rmAddAreaTerrainLayer(patch, patchType1, 0, 1);
    rmAddAreaToClass(patch, rmClassID("classPatch"));
    rmSetAreaMinBlobs(patch, 1);
    rmSetAreaMaxBlobs(patch, 5);
    rmSetAreaMinBlobDistance(patch, 16.0);
    rmSetAreaMaxBlobDistance(patch, 40.0);
    rmSetAreaCoherence(patch, 0.0);
    rmAddAreaConstraint(patch, shortAvoidImpassableLand);
    rmBuildArea(patch); 
  }

	// Text
	rmSetStatusText("",0.80);
      
  for (i=0; <10) {
    int dirtPatch=rmCreateArea("paint patch "+i);
    rmSetAreaWarnFailure(dirtPatch, false);
    rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
    rmSetAreaMix(dirtPatch, baseMix);
    rmSetAreaTerrainType(dirtPatch, patchTerrain);
    rmAddAreaTerrainLayer(dirtPatch, patchType2, 0, 1);
    rmAddAreaToClass(dirtPatch, rmClassID("classPatch"));
    rmSetAreaMinBlobs(dirtPatch, 1);
    rmSetAreaMaxBlobs(dirtPatch, 5);
    rmSetAreaMinBlobDistance(dirtPatch, 16.0);
    rmSetAreaMaxBlobDistance(dirtPatch, 40.0);
    rmSetAreaCoherence(dirtPatch, 0.0);
    rmSetAreaSmoothDistance(dirtPatch, 10);
    rmAddAreaConstraint(dirtPatch, shortAvoidImpassableLand);
    rmAddAreaConstraint(dirtPatch, patchConstraint);
    rmBuildArea(dirtPatch); 
  }
  
	// Text
	rmSetStatusText("",0.85);

    // Place random flags
    int avoidFlags = rmCreateTypeDistanceConstraint("flags avoid flags", "ControlFlag", 70);
    for ( i =1; <16 ) {
    int flagID = rmCreateObjectDef("random flag"+i);
    rmAddObjectDefItem(flagID, "ControlFlag", 1, 0.0);
    rmSetObjectDefMinDistance(flagID, 0.0);
    rmSetObjectDefMaxDistance(flagID, rmXFractionToMeters(0.40));
    rmAddObjectDefConstraint(flagID, avoidFlags);
    rmPlaceObjectDefAtLoc(flagID, 0, 0.5, 0.5);
    }

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    int hillLoc = rmRandInt(1,4);
    rmEchoInfo("Hill Loc = " + hillLoc);
    
    if(teamZeroCount == 1 && teamOneCount == 1 && cNumberTeams == 2){
      if (hillLoc < 3)
        ypKingsHillPlacer(0.75, 0.25, 0, avoidTradeRouteSockets);
      else
        ypKingsHillPlacer(0.25, 0.75, 0, avoidTradeRouteSockets);
    }
    
    else if(cNumberTeams > 2) {
      ypKingsHillPlacer(0.5, 0.5, 0.05, avoidTradeRouteSockets);
    }      

    else  
      ypKingsHillPlacer(0.5, 0.5, .05, avoidTradeRouteSockets);
  }
  
	// Silver
	int silverID = -1;
 	int silverID2 = -1;

  int silverCount = 0;
  
  if (whichVersion == 2)
	  silverCount = 4;	
  
  else 
    silverCount = 3;
  
	rmEchoInfo("silver count = "+silverCount);

  silverID = rmCreateObjectDef("silver mines"+i);
  rmAddObjectDefItem(silverID, "mine", rmRandInt(1,1), 5.0);
  rmSetObjectDefMinDistance(silverID, 0.0);
  rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silverID, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID, avoidSilver);
  rmAddObjectDefConstraint(silverID, avoidKOTH);
  rmAddObjectDefConstraint(silverID, longPlayerConstraint);
  rmAddObjectDefConstraint(silverID, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(silverID, avoidTradeRouteSockets);
  rmPlaceObjectDefPerPlayer(silverID, false, silverCount);
 
  silverID2 = rmCreateObjectDef("closer silver mines"+i);
  rmAddObjectDefItem(silverID2, "mine", rmRandInt(1,1), 5.0);
  rmSetObjectDefMinDistance(silverID2, rmXFractionToMeters(0.1));
  rmSetObjectDefMaxDistance(silverID2, rmXFractionToMeters(0.4));
  rmAddObjectDefConstraint(silverID2, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID2, avoidSilver);
  rmAddObjectDefConstraint(silverID2, avoidKOTH);
  rmAddObjectDefConstraint(silverID2, playerConstraint);
  rmAddObjectDefConstraint(silverID2, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(silverID2, avoidTradeRouteSockets);
  rmPlaceObjectDefPerPlayer(silverID2, false, silverCount);

// Forests
	int forestTreeID = 0;
	
	int numTries=10*cNumberNonGaiaPlayers; 
	int failCount=0;
	for (i=0; <numTries)	{   
    int forestID=rmCreateArea("forest"+i);
    rmAddAreaToClass(forestID, rmClassID("classForest"));
    rmSetAreaWarnFailure(forestID, false);
    rmSetAreaSize(forestID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
    rmSetAreaForestType(forestID, forestType);
    
    if(whichVersion == 2)
      rmSetAreaForestDensity(forestID, 0.4);
    
    else
      rmSetAreaForestDensity(forestID, 0.6);
    
    rmSetAreaForestClumpiness(forestID, 0.4);
    rmSetAreaForestUnderbrush(forestID, 0.0);
    rmSetAreaMinBlobs(forestID, 1);
    rmSetAreaMaxBlobs(forestID, 2);					
    rmSetAreaMinBlobDistance(forestID, 6.0);
    rmSetAreaMaxBlobDistance(forestID, 10.0);
    rmSetAreaCoherence(forestID, 0.4);
    rmSetAreaSmoothDistance(forestID, 10);
    rmAddAreaConstraint(forestID, playerConstraint);  
    rmAddAreaConstraint(forestID, shortAvoidResource);			
    rmAddAreaConstraint(forestID, shortAvoidTradeRoute);
    rmAddAreaConstraint(forestID, avoidTradeRouteSockets);
    rmAddAreaConstraint(forestID, avoidMineSockets);
    rmAddAreaConstraint(forestID, avoidKOTH);
    rmAddAreaConstraint(forestID, forestConstraint);
    rmAddAreaConstraint(forestID, shortAvoidImportantItem);
    if(rmBuildArea(forestID)==false)
    {
      // Stop trying once we fail 5 times in a row.  
      failCount++;
      if(failCount==5)
        break;
    }
    else
      failCount=0; 
  } 

	
// *********************** OBJECTS PLACED AFTER FORESTS ********************
	// Resources that can be placed after forests
  
  if(whichVersion == 1) {
	  rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 2.5*cNumberNonGaiaPlayers);
	  rmPlaceObjectDefAtLoc(tapirID, 0, 0.5, 0.5, 3.0*cNumberNonGaiaPlayers);
  }
  
  else if (whichVersion == 2) {
    rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
	  rmPlaceObjectDefAtLoc(tapirID, 0, 0.5, 0.5, 2.5*cNumberNonGaiaPlayers);
  }
  
  else {
    rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 2.5*cNumberNonGaiaPlayers);
	  rmPlaceObjectDefAtLoc(tapirID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
  }

	// Text
	rmSetStatusText("",0.90);
	
	// Nuggets
  
  int nugget1= rmCreateObjectDef("nugget easy"); 
  rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(1, 1);
  rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget1, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget1, shortAvoidResource);
  rmAddObjectDefConstraint(nugget1, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget1, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget1, avoidTradeRouteSocketsFar);
  rmAddObjectDefConstraint(nugget1, playerConstraint);
  rmAddObjectDefConstraint(nugget1, circleConstraint);
  rmSetObjectDefMinDistance(nugget1, 40.0);
  rmSetObjectDefMaxDistance(nugget1, 60.0);
  rmPlaceObjectDefPerPlayer(nugget1, false, 2);

  int nugget2= rmCreateObjectDef("nugget medium"); 
  rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(2, 2);
  rmSetObjectDefMinDistance(nugget2, 0.0);
  rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget2, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget2, shortAvoidResource);
  rmAddObjectDefConstraint(nugget2, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget2, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget2, avoidTradeRouteSocketsFar);
  rmAddObjectDefConstraint(nugget2, mediumPlayerConstraint);
  rmAddObjectDefConstraint(nugget2, circleConstraint);
  rmSetObjectDefMinDistance(nugget2, 80.0);
  rmSetObjectDefMaxDistance(nugget2, 120.0);
  rmPlaceObjectDefPerPlayer(nugget2, false, 1);

  int nugget3= rmCreateObjectDef("nugget hard"); 
  rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(3, 3);
  rmSetObjectDefMinDistance(nugget3, 0.0);
  rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget3, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget3, shortAvoidResource);
  rmAddObjectDefConstraint(nugget3, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget3, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget3, avoidTradeRouteSocketsFar);
  rmAddObjectDefConstraint(nugget3, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget3, circleConstraint);
  rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

  int nugget4= rmCreateObjectDef("nugget nuts"); 
  rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(4, 4);
  rmSetObjectDefMinDistance(nugget4, 0.0);
  rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget4, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget4, shortAvoidResource);
  rmAddObjectDefConstraint(nugget4, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget4, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget4, avoidTradeRouteSocketsFar);
  rmAddObjectDefConstraint(nugget4, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget4, circleConstraint);
  rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(2,3));

	int herdableID=rmCreateObjectDef("herdables");
	rmAddObjectDefItem(herdableID, herdableType, 2, 5.0);
	rmSetObjectDefMinDistance(herdableID, 0.0);
	rmSetObjectDefMaxDistance(herdableID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(herdableID, avoidHerdable);
	rmAddObjectDefConstraint(herdableID, avoidAll);
	rmAddObjectDefConstraint(herdableID, longPlayerConstraint);
	rmAddObjectDefConstraint(herdableID, avoidImpassableLand);
  rmAddObjectDefConstraint(herdableID, avoidTradeRoute);
  
  if(whichVersion == 2)
	  rmPlaceObjectDefAtLoc(herdableID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2.5);
  
  for(i = 1; < cNumberPlayers) {      
    if ( rmGetPlayerCiv(i) == rmGetCivID("Ottomans")){
      rmCreateTrigger("XP"+i);
      rmSwitchToTrigger(rmTriggerID("XP"+i));
      rmSetTriggerPriority(3); 
      rmSetTriggerActive(true);
      rmSetTriggerRunImmediately(true);
      rmSetTriggerLoop(false);
        
      rmAddTriggerCondition("Always");
      
      rmAddTriggerEffect("Grant Resources");
      rmSetTriggerEffectParamInt("PlayerID", i, false);
      rmSetTriggerEffectParam("ResName", "XP", false);
      rmSetTriggerEffectParam("Amount", "50", false);
    }
  }
    
	// Text
	rmSetStatusText("",0.99);
   
}  
