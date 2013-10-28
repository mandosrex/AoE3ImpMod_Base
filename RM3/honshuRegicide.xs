// Japan
// March 2006, PJJ
// Main entry point for random map script    

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// initialize map type variables
  string nativeCiv1 = "";
  string nativeCiv2 = "";
 
  string baseMix = "coastal_japan_b";
  string baseTerrain = "water";
  string seaType = "Coastal Japan";
  string cliffType = "Coastal Japan";
 
  string forestType = "Coastal Japan Forest";
  string startTreeType = "ypTreeJapaneseMaple";
  
  string baseIslandTerrain = "coastal_japan_c";
  string islandTerrain = "coastal_japan_b";
  string mapType1 = "Japan";
  
  string huntable1 = "ypSerow";
  string huntable2 = "ypGiantSalamander";
  string fish1 = "ypFishCatfish";
  string fish2 = "ypSquid";
  string whale1 = "HumpbackWhale";
  
  string patchMix = "coastal_japan_forest";
  string patchTerrain = "coastal_japan\ground_grass3_co_japan";
  string patchType1 = "coastal_japan\ground_grass2_co_japan";
  string patchType2 = "coastal_japan\ground_grass1_co_japan";
  
  string lightingType = "Honshu";
  
  // Initialize constraints for use in placement functions. Have to be defined above where they used in the script for compiler to accept them.

  int classSmallIsland = 0;

  int avoidAll = 0;
  int avoidAllForests = 0;
  int avoidWater4 = 0;
  int avoidRandomBerries = 0;
  int avoidNugget = 0;
  int nuggetVsCoin = 0;
  int islandConstraint = 0; 
  int avoidSmallIslands = 0;
  int nuggetAvoidsBerries = 0;
  int forestVsNugget = 0;
  int forestVsCoin = 0;
  int islandEdgeConstraint = 0;
  int forestConstraintShort = 0;
  int avoidImpassableLand = 0;
  int avoidImpassableLandLong = 0;
  int avoidNuggetShort = 0;
  int avoidCoinShort = 0;
  int shortAvoidTradeRoute = 0;
	int avoidTradeRouteSocketsShort = 0;
  int avoidTradeRouteSocketsNear = 0;
  

  int goldCounter = 0;
  int berryCounter = 0;
  int nuggetCounter = 0;
  int forestCounter = 0;
  int huntCounter = 0;
  float randomIslandStuff = 0.0;

//places mines on the extra islands
void sfIslandGold (int islandID = 0, string mineType = "mine", int mineCount = 1)
{
  int islandGoldID = rmCreateObjectDef("random gold"+goldCounter);
  rmAddObjectDefItem(islandGoldID, mineType, 1, 0);
  rmSetObjectDefMinDistance(islandGoldID, 0.0);
  rmSetObjectDefMaxDistance(islandGoldID, 6.0);    
  rmAddObjectDefConstraint(islandGoldID, avoidImpassableLandLong);    
  rmAddObjectDefConstraint(islandGoldID, avoidAll);    
  rmAddObjectDefConstraint(islandGoldID, avoidTradeRouteSocketsShort);   
  rmAddObjectDefConstraint(islandGoldID, shortAvoidTradeRoute);   
  rmAddObjectDefConstraint(islandGoldID, avoidCoinShort);    
  rmAddObjectDefConstraint(islandGoldID, avoidNuggetShort);    
  rmPlaceObjectDefInArea(islandGoldID, 0, islandID, mineCount);
  goldCounter = goldCounter + 1;
}

//places berries on the extra islands
void sfIslandBerries (int islandID = 0, int berryLow = 0, int berryHigh = 0)
{
  int islandBerriesID=rmCreateObjectDef("random berries"+berryCounter);
  rmAddObjectDefItem(islandBerriesID, "berrybush", rmRandInt(berryLow,berryHigh), 6.0); 
  rmSetObjectDefMinDistance(islandBerriesID, 0.0);
  rmSetObjectDefMaxDistance(islandBerriesID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(islandBerriesID, avoidRandomBerries);
  rmAddObjectDefConstraint(islandBerriesID, avoidImpassableLand);  
  rmAddObjectDefConstraint(islandBerriesID, avoidTradeRouteSocketsShort);   
  rmAddObjectDefConstraint(islandBerriesID, shortAvoidTradeRoute);   
  rmAddObjectDefConstraint(islandBerriesID, avoidAll);    
  rmPlaceObjectDefInArea(islandBerriesID, 0, islandID, 1); 
  berryCounter = berryCounter + 1;
}

//places treasures on the extra islands
void sfIslandNuggets (int islandID = 0, int nuggetLow = 0, int nuggetHigh = 0)
{
  int nuggetID= rmCreateObjectDef("nugget"+nuggetCounter); 
  rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
  rmSetObjectDefMinDistance(nuggetID, 0.0);
  rmSetNuggetDifficulty(nuggetLow, nuggetHigh);
  rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nuggetID, nuggetAvoidsBerries);
  rmAddObjectDefConstraint(nuggetID, avoidAll);
  rmAddObjectDefConstraint(nuggetID, avoidImpassableLandLong);
  rmAddObjectDefConstraint(nuggetID, forestVsNugget);
  rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
  rmAddObjectDefConstraint(nuggetID, avoidWater4);
  rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSocketsShort);   
  rmAddObjectDefConstraint(nuggetID, shortAvoidTradeRoute);   
  rmAddObjectDefConstraint(nuggetID, islandEdgeConstraint);
  rmPlaceObjectDefInArea(nuggetID, 0, islandID, 1);
  nuggetCounter = nuggetCounter + 1;
}

void sfIslandForests(int islandID = 0, int forestLow = 0, int forestHigh = 0) {
  int forest=rmCreateArea("Island Forest "+forestCounter, islandID);
  rmSetAreaWarnFailure(forest, false);
  rmSetAreaSize(forest, rmAreaTilesToFraction(forestLow), rmAreaTilesToFraction(forestHigh));
  rmSetAreaForestType(forest, forestType);
  rmSetAreaForestDensity(forest, 0.5);
  rmSetAreaForestClumpiness(forest, 0.55);
  rmSetAreaForestUnderbrush(forest, 0.0);
  rmSetAreaCoherence(forest, 0.4);
  //~ rmAddAreaConstraint(forest, forestVsCoin); 
  rmAddAreaConstraint(forest, avoidWater4);
  rmAddAreaConstraint(forest, avoidAllForests);
  rmAddAreaConstraint(forest, islandEdgeConstraint);
  rmAddAreaConstraint(forest, avoidTradeRouteSocketsShort);
  rmAddAreaConstraint(forest, shortAvoidTradeRoute);
  //~ rmAddAreaConstraint(forest, forestVsNugget);
  rmBuildArea(forest);
  forestCounter++;
}

void sfIslandHunts(int islandID = 0, int huntLow = 0, int huntHigh = 0) {
  int islandHuntsID=rmCreateObjectDef("random hunts"+huntCounter);
  rmAddObjectDefItem(islandHuntsID, huntable2, rmRandInt(huntLow,huntHigh), 6.0); 
  rmSetObjectDefMinDistance(islandHuntsID, 0.0);
  rmSetObjectDefMaxDistance(islandHuntsID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(islandHuntsID, avoidWater4);  
  rmAddObjectDefConstraint(islandHuntsID, avoidAll);    
  rmAddObjectDefConstraint(islandHuntsID, islandEdgeConstraint);
  rmSetObjectDefCreateHerd(islandHuntsID, true);
  rmPlaceObjectDefInArea(islandHuntsID, 0, islandID, 1); 
  huntCounter = huntCounter + 1;
}

//builds the small extra islands
int sfBuildSmallIsland (string smallIslandName = "", float x_loc = 0, float y_loc = 0) 
{
  int smallIslandID=rmCreateArea(smallIslandName);
  rmSetAreaSize(smallIslandID, rmAreaTilesToFraction(1100), rmAreaTilesToFraction(1400));
  rmAddAreaToClass(smallIslandID, classSmallIsland);
  //~ rmSetAreaTerrainType(smallIslandID, "new_england\ground1_ne");
  rmSetAreaMix(smallIslandID, islandTerrain);
  rmSetAreaBaseHeight(smallIslandID, 2.0);
  rmAddAreaConstraint(smallIslandID, avoidSmallIslands); 
  rmAddAreaConstraint(smallIslandID, islandConstraint); 
  rmAddAreaConstraint(smallIslandID, islandEdgeConstraint);
  rmSetAreaSmoothDistance(smallIslandID, 5);
  rmSetAreaWarnFailure(smallIslandID, false);
  rmSetAreaMinBlobs(smallIslandID, 3);
  rmSetAreaMaxBlobs(smallIslandID, 4);
  rmSetAreaMinBlobDistance(smallIslandID, 8.0);
  rmSetAreaMaxBlobDistance(smallIslandID, 12.0);
  rmSetAreaCoherence(smallIslandID, 0.6);
  rmSetAreaLocation(smallIslandID, x_loc, y_loc);
  rmSetAreaCoherence(smallIslandID, .6);
  rmBuildArea(smallIslandID);  
  sfIslandBerries(smallIslandID, 4, 6);
  sfIslandNuggets(smallIslandID, 4, 4);
  
  randomIslandStuff = rmRandFloat(0,1);
  rmEchoInfo("Stuff is "+randomIslandStuff);
  
  if(randomIslandStuff > .9)
    sfIslandNuggets(smallIslandID, 3, 4);
  
  if(randomIslandStuff > .33)
    sfIslandNuggets(smallIslandID, 3, 4);
  
  sfIslandForests(smallIslandID, 125, 225);
  
  if(randomIslandStuff > .85)
    sfIslandGold(smallIslandID, "minegold", 2);
    
  else if(randomIslandStuff > .5)
    sfIslandGold(smallIslandID, "minegold", 1);
    
  else
    sfIslandGold(smallIslandID, "mine", 2);

  return(smallIslandID);
}

//builds the big extra islands
int sfBuildBigIsland (string bigIslandName = "", float x_loc = 0.0, float y_loc = 0.0, float mainlandType = 0.0)
{
  int bigIslandID=rmCreateArea(bigIslandName);
  
  if(mainlandType == 1.0) {
    rmSetAreaSize(bigIslandID, 0.11, 0.11);
  }
  
  else{
    rmSetAreaSize(bigIslandID, rmAreaTilesToFraction(1850), rmAreaTilesToFraction(2250));
    rmAddAreaConstraint(bigIslandID, islandEdgeConstraint);
  }
  
  rmAddAreaToClass(bigIslandID, classSmallIsland);  
  //~ rmSetAreaTerrainType(bigIslandID, "new_england\ground1_ne");
  rmSetAreaMix(bigIslandID, islandTerrain);
  rmSetAreaEdgeFilling(bigIslandID, 0);
  rmSetAreaBaseHeight(bigIslandID, 2.0);
  rmSetAreaSmoothDistance(bigIslandID, 5);
  rmSetAreaWarnFailure(bigIslandID, false);
  rmAddAreaConstraint(bigIslandID, avoidSmallIslands); 
  rmAddAreaConstraint(bigIslandID, islandConstraint); 
  rmSetAreaCoherence(bigIslandID, 0.55);
  rmSetAreaLocation(bigIslandID, x_loc, y_loc);  
  
  if(x_loc + y_loc > 1.0) {
    rmAddAreaInfluenceSegment(bigIslandID, 1.0, 0.8, 0.8, 1.0);
    rmAddAreaInfluenceSegment(bigIslandID, 1.0, 0.75, 0.75, 1.0);
  }
  
  
  else {
    rmAddAreaInfluenceSegment(bigIslandID, 0.0, 0.2, 0.2, 0.0);
    rmAddAreaInfluenceSegment(bigIslandID, 0.0, 0.25, 0.25, 0.0);
  }
  
  rmSetAreaCoherence(bigIslandID, .6);
  rmBuildArea(bigIslandID);
  
  if(mainlandType == 1.0) {
    int tradeRouteID = rmCreateTradeRoute();
    
    int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
    rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

    rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
    rmSetObjectDefAllowOverlap(socketID, true);
    rmSetObjectDefMinDistance(socketID, 0.0);
    rmSetObjectDefMaxDistance(socketID, 8.0);

    if(x_loc+y_loc > 1.0) {
      //~ rmAddTradeRouteWaypoint(tradeRouteID, .9, .8);
      rmAddTradeRouteWaypoint(tradeRouteID, .9, .7);
      rmAddTradeRouteWaypoint(tradeRouteID, .7, .9);
      //~ rmAddTradeRouteWaypoint(tradeRouteID, .8, .9);
      rmEchoInfo("Up top");
    }
    
    else {
      //~ rmAddTradeRouteWaypoint(tradeRouteID, 0.1, 0.2);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.1, 0.3);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.1);
      //~ rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 0.1);
      rmEchoInfo("Down below");
    }
    
    bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "water");
    if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 
    
    // add the sockets along the trade route.
    //~ vector socketLoc  = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
    //~ rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    
    vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  
    
    //~ socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
    //~ rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    
    // Place random flags
    int avoidFlags = rmCreateTypeDistanceConstraint("flags avoid flags", "ControlFlag", 70);
    for ( i =1; <11 ) {
    int flagID = rmCreateObjectDef("random flag"+i);
    rmAddObjectDefItem(flagID, "ControlFlag", 1, 0.0);
    rmSetObjectDefMinDistance(flagID, 0.0);
    rmSetObjectDefMaxDistance(flagID, rmXFractionToMeters(0.40));
    rmAddObjectDefConstraint(flagID, avoidFlags);
    rmPlaceObjectDefAtLoc(flagID, 0, 0.5, 0.5);
    }

    // check for KOTH game mode
    if(rmGetIsKOTH()) {
      
      int randLoc = rmRandInt(1,2);
      float xLoc = 0.5;
      float yLoc = 0.5;
      float walk = 0.1;
      
      if(x_loc+y_loc > 1.0)
        xLoc = .85;
      
      else
        xLoc = .15;
      
      ypKingsHillPlacer(xLoc, xLoc, walk, avoidTradeRouteSocketsNear);
      rmEchoInfo("XLOC = "+xLoc);
      rmEchoInfo("XLOC = "+yLoc);
    }
    
  }
  
  sfIslandBerries(bigIslandID, 7, 9);  
  
  if(mainlandType == 1.0) {
    sfIslandForests(bigIslandID, 300, 500);
    sfIslandForests(bigIslandID, 300, 500);
    sfIslandForests(bigIslandID, 300, 500);
    
    if (cNumberNonGaiaPlayers > 4) {
      sfIslandForests(bigIslandID, 400, 600);
      sfIslandForests(bigIslandID, 400, 600);
    }
  }
    
  else  
    sfIslandForests(bigIslandID, 500, 750);
  
  sfIslandNuggets(bigIslandID, 4, 4);
  sfIslandNuggets(bigIslandID, 3, 3);
  sfIslandNuggets(bigIslandID, 3, 3);
  
  if(cNumberNonGaiaPlayers < 4 && mainlandType == 1.0) 
    sfIslandGold(bigIslandID, "minegold", 2);
  
  else if (mainlandType == 1.0)
    sfIslandGold(bigIslandID, "minegold", 4);
  
  sfIslandHunts(bigIslandID, 6, 8);
  
  if(mainlandType == 1.0) {
    sfIslandHunts(bigIslandID, 6, 8);
    sfIslandHunts(bigIslandID, 6, 8);
    
    if (cNumberNonGaiaPlayers > 4) {
      sfIslandHunts(bigIslandID, 6, 8);
      sfIslandHunts(bigIslandID, 6, 8);
    }
  }
    
  return(bigIslandID);
}

//main function
void main(void)
{
	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.10);
    rmEchoInfo("10 percent map loaded");

	// Define Natives
	int subCiv0=-1;
  int subCiv1=-1;

  if (rmAllocateSubCivs(2) == true){
		subCiv0=rmGetCivID("zen");
		rmEchoInfo("subCiv0 is zen "+subCiv0);
		if (subCiv0 >= 0)
		rmSetSubCiv(0, "zen");

		subCiv1=rmGetCivID("jesuit");
		rmEchoInfo("subCiv1 is jesuit "+subCiv1);
		if (subCiv1 >= 0)
		rmSetSubCiv(1, "jesuit");
	}

	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.20);
    rmEchoInfo("20 percent map loaded");
	
	chooseMercs();
	
	// Set size of map
	int playerTiles=35000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 32500;
	if (cNumberNonGaiaPlayers >7)
		playerTiles = 31000;
  
  if(cNumberTeams > 2)
    playerTiles = playerTiles*1.4;
  
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Set up default water type.
	rmSetSeaLevel(1.0);          
	rmSetSeaType(seaType);
  rmEnableLocalWater(false);
	rmSetBaseTerrainMix(baseMix);
	rmSetMapType(mapType1);
	rmSetMapType("grass");
	rmSetMapType("water");
	rmSetLightingSet(lightingType);

	// Initialize map.
	rmTerrainInitialize(baseTerrain);

	// Misc variables for use later
	int numTries = -1;

	// Define some classes.
	int classPlayer=rmDefineClass("player");
	int classIsland=rmDefineClass("island");
  classSmallIsland=rmDefineClass("smallIsland");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classSocket");
  rmDefineClass("classPatch");

  // -------------Define constraints----------------------------------------
  avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);    
  avoidAllForests=rmCreateTypeDistanceConstraint("avoid all forests", "all", 6.0);    
  avoidRandomBerries=rmCreateTypeDistanceConstraint("avoid random berries", "berrybush", 55.0);
  nuggetAvoidsBerries=rmCreateTypeDistanceConstraint("nuggets avoid berries", "berrybush", 5.0);
  int avoidBerries = rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 8.0);  
  
  // Create an edge of map constraint.
  int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Player area constraint.
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 25.0);
  int playerConstraintFar=rmCreateClassDistanceConstraint("stay away from player Far", classPlayer, 75.0);
  int playerConstraintNative=rmCreateClassDistanceConstraint("natives stay away from player Far", classPlayer, 100.0);
  
  // Island Halves
  int westHalf = rmCreateBoxConstraint("stay in west half", .35, .6, .65, .7);
  int eastHalf = rmCreateBoxConstraint("stay in east half", .35, .3, .65, .4);
  int middle = rmCreateBoxConstraint("stay in middle", .3, .7, .7, .3);

	// Bonus area constraint.  
	islandConstraint=rmCreateClassDistanceConstraint("stay away from main island", classIsland, 12.0);
  avoidSmallIslands = rmCreateClassDistanceConstraint("stay away from other bonus islands", classSmallIsland, 10.0);
  islandEdgeConstraint = rmCreatePieConstraint("Islands away from edge of map", 0.5, 0.5, 0, rmGetMapXSize()-12, 0, 0, 0);

	// Fish Constraints
	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", fish1, 25.0);		
	int fishVsFishTarponID=rmCreateTypeDistanceConstraint("fish v fish2", fish2, 20.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);			
	int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", whale1, 35.0);	
	int fishVsWhaleID=rmCreateTypeDistanceConstraint("fish v whale", whale1, 20.0); 
	int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 20.0);
  int whaleEdgeConstraint = rmCreatePieConstraint("whale away from edge of map", 0.5, 0.5, 0, rmGetMapXSize()-18, 0, 0, 0);

  // resource constraints
  int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 35.0);
  forestConstraintShort=rmCreateClassDistanceConstraint("vs. forest short", rmClassID("classForest"), 5.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "mine", 65.0);	
  avoidCoinShort=rmCreateTypeDistanceConstraint("avoid coin short", "minegold", 30.0);	
  int avoidGold=rmCreateTypeDistanceConstraint("avoid gold", "minegold", 55.0);	
  forestVsCoin=rmCreateTypeDistanceConstraint("forest vs. coin", "mine", 10.0);
  nuggetVsCoin=rmCreateTypeDistanceConstraint("nugget vs. coin", "mine", 8.0);
  int avoidRandomTurkeys=rmCreateTypeDistanceConstraint("avoid random turkeys", huntable1, 35.0);	
	avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "abstractNugget", 35.0); 
  forestVsNugget=rmCreateTypeDistanceConstraint("forest vs. nugget", "abstractNugget", 10.0);
  int avoidCastle=rmCreateTypeDistanceConstraint("vs Regicide Castle", "ypCastleRegicide", 5.0); 
  int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget avoid nugget far", "abstractNugget", 70.0); 
  avoidNuggetShort=rmCreateTypeDistanceConstraint("vs. nugget short", "abstractNugget", 8.0);

	// Avoid impassable land
	avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
  avoidImpassableLandLong=rmCreateTerrainDistanceConstraint("avoid impassable land long", "Land", false, 15.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
  int avoidBannerShort = rmCreateTypeDistanceConstraint("versus banners short", "ypPropsJapaneseBanner", 25.0);
  int avoidBanner = rmCreateTypeDistanceConstraint("versus banners", "ypPropsJapaneseBanner", 75.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

	// Constraint to avoid water.
	avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 5.0);
	int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 25.0);
  int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);
  int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water 8", "Land", false, 8.0);

	int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 8.0);
  int avoidImportantItemShort = rmCreateClassDistanceConstraint("secrets etc avoid each other short", rmClassID("importantItem"), 3.0);
	int avoidImportantItemFar = rmCreateClassDistanceConstraint("secrets etc avoid each other Far", rmClassID("importantItem"), 65.0);
  
  shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	avoidTradeRouteSocketsShort=rmCreateTypeDistanceConstraint("avoid trade route sockets short", "sockettraderoute", 10.0);
  avoidTradeRouteSocketsNear=rmCreateTypeDistanceConstraint("avoid trade route sockets near", "sockettraderoute", 5.0);

	// Flag constraints for HC spawn point
  int flagEdgeConstraint = rmCreatePieConstraint("flags away from edge of map", 0.5, 0.5, 0, rmGetMapXSize()-15, 0, 0, 0);
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 18.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 22); 
	
	// Text
	rmSetStatusText("",0.30);
  rmEchoInfo("30 percent map loaded");

	// Make one big island.  
	int bigIslandID=rmCreateArea("big lone island");
	rmSetAreaSize(bigIslandID, 0.275, 0.275);
  if(cNumberNonGaiaPlayers > 3)
    rmSetAreaSize(bigIslandID, 0.28, 0.29);
  if(cNumberNonGaiaPlayers > 5)
    rmSetAreaSize(bigIslandID, 0.31, 0.32);
	rmSetAreaCoherence(bigIslandID, 0.7);
	rmSetAreaBaseHeight(bigIslandID, 2.0);
	rmSetAreaSmoothDistance(bigIslandID, 20);
	rmSetAreaMix(bigIslandID, baseMix);
	rmAddAreaToClass(bigIslandID, classIsland);
	rmAddAreaConstraint(bigIslandID, islandConstraint);
	rmSetAreaObeyWorldCircleConstraint(bigIslandID, false);
	rmSetAreaElevationType(bigIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(bigIslandID, 4.0);
	rmSetAreaElevationMinFrequency(bigIslandID, 0.09);
	rmSetAreaElevationOctaves(bigIslandID, 3);
	rmSetAreaElevationPersistence(bigIslandID, 0.2);
	rmSetAreaElevationNoiseBias(bigIslandID, 1);

  rmAddAreaInfluenceSegment(bigIslandID, 0.25, 0.65, 0.35, 0.75);
  rmAddAreaInfluenceSegment(bigIslandID, 0.35, 0.55, 0.45, 0.65);
  rmAddAreaInfluenceSegment(bigIslandID, 0.48, 0.48, 0.52, 0.52);
  rmAddAreaInfluenceSegment(bigIslandID, 0.55, 0.35, 0.65, 0.45);
  rmAddAreaInfluenceSegment(bigIslandID, 0.65, 0.25, 0.75, 0.35);    

	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.40);
    rmEchoInfo("40 percent map loaded");

	rmSetAreaWarnFailure(bigIslandID, false);

	rmSetAreaLocation(bigIslandID, .5, .5);		//Put the big island in exact middle of map.
	rmBuildArea(bigIslandID);
	
    // Set up player areas and starting locs
	
	float teamStartLoc = rmRandFloat(0.0, 1.0);  //This chooses a number randomly between 0 and 1, used to pick whether team 1 is on top or bottom.
  float teamStartRadius = 0.375;
    
  if(cNumberNonGaiaPlayers > 4)
    teamStartRadius = 0.45;

  if (cNumberTeams == 2 ) {
    if (cNumberNonGaiaPlayers == 2) {
      if (teamStartLoc > 0.5) {
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.34, 0.65, 0.35, 0.65, 0.1, 0);
          
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.65, 0.34, 0.65, 0.35, 0.1, 0);                
      }
      else {
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.34, 0.65, 0.35, 0.65, 0.1, 0);    
          
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.65, 0.34, 0.65, 0.35, 0.1, 0);                  
      }
    } 
    else {
      //Team 0 starts on top
      if (teamStartLoc > 0.5) {
        rmSetPlacementTeam(0);
        rmSetPlayerPlacementArea(0.55, 0.45, 0.8, 0.2);    
        rmPlacePlayersCircular(teamStartRadius, teamStartRadius, 0); 
      
        rmSetPlacementTeam(1);
        rmSetPlayerPlacementArea(0.45, 0.55, 0.2, 0.8);    
        rmPlacePlayersCircular(teamStartRadius, teamStartRadius, 0); 
      }
      else {
        rmSetPlacementTeam(0);
        rmSetPlayerPlacementArea(0.45, 0.55, 0.2, 0.8);    
        rmPlacePlayersCircular(teamStartRadius, teamStartRadius, 0); 
          
        rmSetPlacementTeam(1);
        rmSetPlayerPlacementArea(0.55, 0.45, 0.8, 0.2);    
        rmPlacePlayersCircular(teamStartRadius, teamStartRadius, 0); 
      }     
    }
  }

	// otherwise FFA
	else
	{
    rmPlacePlayer(1, .625, .225);
    rmPlacePlayer(2, .35, .775);
    
    if(cNumberNonGaiaPlayers == 3) {
      rmPlacePlayer(3, .5, .5);
    }
    
    else {
      rmPlacePlayersLine(.225, .6, .775, .375, 0.15, 0.05);
    }
	}

	float playerFraction=rmAreaTilesToFraction(20);
	for(i=1; <cNumberPlayers)
	{
    // Create the Player's area.
    int id=rmCreateArea("Player"+i, bigIslandID);
    rmSetPlayerArea(i, id);
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaConstraint(id, avoidWater8);
    rmAddAreaToClass(id, classPlayer);
    rmSetAreaMinBlobs(id, 1);
    rmSetAreaMaxBlobs(id, 1);
    rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, true);
	}

	// Build the areas. 
	rmBuildAllAreas();

  // text
	rmSetStatusText("",0.45);
  rmEchoInfo("45 percent map loaded");

  // Natives near middle of island 

  if (subCiv0 == rmGetCivID("zen"))
  {  
    int caribs5VillageID = -1;
    int caribs5VillageType = rmRandInt(1,5);
    caribs5VillageID = rmCreateGrouping("zen temple", "native zen temple cj 0"+caribs5VillageType);
    rmAddGroupingToClass(caribs5VillageID, rmClassID("importantItem"));
    rmSetGroupingMinDistance(caribs5VillageID, 0.0);
    rmSetGroupingMaxDistance(caribs5VillageID, 10.0);
    rmAddGroupingConstraint(caribs5VillageID, avoidImpassableLand);
    rmAddGroupingConstraint(caribs5VillageID, avoidWater8);
    rmAddGroupingConstraint(caribs5VillageID, avoidImportantItemFar);
    rmAddGroupingConstraint(caribs5VillageID, playerConstraintNative);
    if(cNumberTeams > 2)
      rmAddGroupingConstraint(caribs5VillageID, westHalf);
    else
      rmAddGroupingConstraint(caribs5VillageID, middle);
    //~ rmPlaceGroupingAtLoc(caribs5VillageID, 0, .46, .59);
    rmPlaceGroupingInArea(caribs5VillageID, 0, bigIslandID, 1);
  }	

  if (subCiv1 == rmGetCivID("jesuit"))
  {  
    int caribs6VillageID = -1;
    int caribs6VillageType = rmRandInt(1,5);
    caribs6VillageID = rmCreateGrouping("jesuit mission", "native jesuit mission cj 0"+caribs6VillageType);
    rmSetGroupingMinDistance(caribs6VillageID, 0.0);
    rmSetGroupingMaxDistance(caribs6VillageID, 10.0);
    rmAddGroupingToClass(caribs6VillageID, rmClassID("importantItem"));
    rmAddGroupingConstraint(caribs6VillageID, avoidImpassableLand);
    rmAddGroupingConstraint(caribs6VillageID, avoidWater8);
    rmAddGroupingConstraint(caribs6VillageID, avoidImportantItemFar);
    rmAddGroupingConstraint(caribs6VillageID, playerConstraintNative);
    if(cNumberTeams > 2)
      rmAddGroupingConstraint(caribs6VillageID, eastHalf);
    else
      rmAddGroupingConstraint(caribs6VillageID, middle);
    //~ rmPlaceGroupingAtLoc(caribs6VillageID, 0, .54, .41);
    rmPlaceGroupingInArea(caribs6VillageID, 0, bigIslandID, 1);
  } 
  
	// text
	rmSetStatusText("",0.50);
  rmEchoInfo("50 percent map loaded");
    
   int bottomMiddleVariation = rmRandInt(1,2);
   int topMiddleVariation = rmRandInt(1,2);
   
   //spawning islands for 2 player games
   if (cNumberNonGaiaPlayers < 3) {
     if (bottomMiddleVariation == 1) {
       int bonusIslandID1 = sfBuildSmallIsland("bonus island 1", 0.37, 0.17);
       int bonusIslandID2 = sfBuildSmallIsland("bonus island 2", 0.17, 0.37);
       topMiddleVariation = 2;
     }
     else {
      int bonusIslandID3= sfBuildBigIsland("bonus island 3", 0.16, 0.16, 1.0);
      topMiddleVariation = 1;
     }
   
     if (topMiddleVariation == 1) {
       int bonusIslandID4 = sfBuildSmallIsland("bonus island 4", 0.63, 0.83);
       int bonusIslandID5 = sfBuildSmallIsland("bonus island 5", 0.83, 0.63);
     }
     else {
       int bonusIslandID6 = sfBuildBigIsland("bonus island 6", 0.84, 0.84, 1.0);
     }
   }
   
   //spawning of extra islands for 3, 4 player games
   else if (cNumberNonGaiaPlayers > 2 && cNumberNonGaiaPlayers < 5) {
     if (bottomMiddleVariation == 1) {

       int bonusIslandID39 = sfBuildSmallIsland("bonus island 39", 0.32, 0.12);
       int bonusIslandID40 = sfBuildSmallIsland("bonus island 40", 0.12, 0.32);
       topMiddleVariation = 2;
     }
     else {
      int bonusIslandID41= sfBuildBigIsland("bonus island 41", 0.11, 0.11, 1);
       topMiddleVariation = 1;
     }
   
     if (topMiddleVariation == 1) {
       int bonusIslandID42 = sfBuildSmallIsland("bonus island 42", 0.68, 0.88);
       int bonusIslandID43 = sfBuildSmallIsland("bonus island 43", 0.88, 0.68);
     }
     else {
       int bonusIslandID44 = sfBuildBigIsland("bonus island 44", 0.89, 0.89, 1);
     }         
   }
   
   //spawning of extra islands for 5-8 players
   else if (cNumberNonGaiaPlayers > 4 && cNumberNonGaiaPlayers < 7) {
     if (bottomMiddleVariation == 1) {
     // Isles of Shoals - these are set in specific locations.

       int bonusIslandID70 = sfBuildSmallIsland("bonus island 70", 0.28, 0.14);
       int bonusIslandID71 = sfBuildSmallIsland("bonus island 71", 0.14, 0.28);
       topMiddleVariation = 2;
     }
     else {
      int bonusIslandID72= sfBuildBigIsland("bonus island 72", 0.10, 0.10, 1);
       topMiddleVariation = 1;
     }
   
     if (topMiddleVariation == 1) {
       int bonusIslandID48 = sfBuildSmallIsland("bonus island 48", 0.72, 0.86);
       int bonusIslandID49 = sfBuildSmallIsland("bonus island 49", 0.86, 0.72);
     }
     else {
       int bonusIslandID50 = sfBuildBigIsland("bonus island 50", 0.90, 0.90, 1);
     }         
       
   }
   
   else if (cNumberNonGaiaPlayers > 6) {
     if (bottomMiddleVariation == 1) {
     // Isles of Shoals - these are set in specific locations.

       int bonusIslandID51 = sfBuildSmallIsland("bonus island 51", 0.29, 0.15);
       int bonusIslandID52 = sfBuildSmallIsland("bonus island 52", 0.15, 0.29);
       topMiddleVariation = 2;
     }
     else {
      int bonusIslandID53= sfBuildBigIsland("bonus island 53", 0.1, 0.1, 1);
      topMiddleVariation = 1;
     }
   
     if (topMiddleVariation == 1) {
       int bonusIslandID54 = sfBuildSmallIsland("bonus island 54", 0.71, 0.85);
       int bonusIslandID55 = sfBuildSmallIsland("bonus island 55", 0.85, 0.71);
     }
     else {
       int bonusIslandID56 = sfBuildBigIsland("bonus island 56", 0.9, 0.9, 1);
     }       
   }

	// text 
	rmSetStatusText("",0.70);
  rmEchoInfo("70 percent map loaded");
   
	// Player stuff - incl HC flag

	int TCID = rmCreateObjectDef("player TC");
	if ( rmGetNomadStart())
		rmAddObjectDefItem(TCID, "coveredWagon", 1, 0);
	else
		rmAddObjectDefItem(TCID, "townCenter", 1, 0);

	//Prepare to place TCs
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 8.0); 
	rmAddObjectDefConstraint(TCID, avoidImpassableLand);
	rmAddObjectDefConstraint(TCID, avoidWater20);
    	
	//Prepare to place Explorers, Explorer's dog, Explorer's Taun Taun, etc.
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 8.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);

	//Prepare to place player starting Mine
	int playerGoldID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(playerGoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 14.0);
	rmSetObjectDefMaxDistance(playerGoldID, 20.0);
  rmAddObjectDefConstraint(playerGoldID, avoidCastle);
  rmAddObjectDefConstraint(playerGoldID, avoidAll);
  rmAddObjectDefConstraint(playerGoldID, avoidBerries);

	//Prepare to place player starting Crates (mostly wood to get docks movin)
	int playerCrateID=rmCreateObjectDef("starting crates");
	rmAddObjectDefItem(playerCrateID, "ypDockWagon", 1, 0.0);
	rmSetObjectDefMinDistance(playerCrateID, 9.0);
	rmSetObjectDefMaxDistance(playerCrateID, 12.0);
	rmAddObjectDefConstraint(playerCrateID, avoidAll);
  rmAddObjectDefConstraint(playerCrateID, avoidCastle);
	rmAddObjectDefConstraint(playerCrateID, shortAvoidImpassableLand);

	//Prepare to place player starting Berries
	int playerBerriesID=rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerBerriesID, "berrybush", 5, 5.0);	
  rmSetObjectDefMinDistance(playerBerriesID, 16);
  rmSetObjectDefMaxDistance(playerBerriesID, 17);
	rmAddObjectDefConstraint(playerBerriesID, avoidAll);
  rmAddObjectDefConstraint(playerBerriesID, avoidCastle);
  rmAddObjectDefConstraint(playerBerriesID, avoidImpassableLand);

	//Prepare to place player starting pop block
	int playerPopBlock=rmCreateObjectDef("player pop block");
	rmAddObjectDefItem(playerPopBlock, "ypPopBlock", 1, 0.0);	
  rmSetObjectDefMinDistance(playerPopBlock, 7);
  rmSetObjectDefMaxDistance(playerPopBlock, 10);		
	rmAddObjectDefConstraint(playerPopBlock, avoidAll);
  rmAddObjectDefConstraint(playerPopBlock, avoidCastle);
  rmAddObjectDefConstraint(playerPopBlock, avoidImpassableLand);

	//Prepare to place player starting huntables
	int playerTurkeyID=rmCreateObjectDef("player food");
  rmAddObjectDefItem(playerTurkeyID, huntable1, 7, 6.0);	
  rmSetObjectDefMinDistance(playerTurkeyID, 15);
	rmSetObjectDefMaxDistance(playerTurkeyID, 20);	
	rmAddObjectDefConstraint(playerTurkeyID, avoidAll);
  rmAddObjectDefConstraint(playerTurkeyID, avoidCastle);
  rmAddObjectDefConstraint(playerTurkeyID, avoidImpassableLand);
  rmSetObjectDefCreateHerd(playerTurkeyID, false);

	//Prepare to place player starting trees
	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 14, 10.0);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidCastle);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidBerries);
	rmSetObjectDefMinDistance(StartAreaTreeID, 21.0);	
	rmSetObjectDefMaxDistance(StartAreaTreeID, 23.0);	
  
  int playerCastle=rmCreateObjectDef("Castle");
  rmAddObjectDefItem(playerCastle, "ypCastleRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerCastle, avoidAll);
  rmAddObjectDefConstraint(playerCastle, avoidImpassableLand);
	rmSetObjectDefMinDistance(playerCastle, 18.0);	
	rmSetObjectDefMaxDistance(playerCastle, 23.0);
  
  int playerWalls = rmCreateGrouping("regicide walls", "regicide_walls");
  rmAddGroupingToClass(playerWalls, rmClassID("importantItem"));
  rmSetGroupingMinDistance(playerWalls, 0.0);
  rmSetGroupingMaxDistance(playerWalls, 2.0);
  
  int playerDaimyo=rmCreateObjectDef("Daimyo"+i);
  rmAddObjectDefItem(playerDaimyo, "ypDaimyoRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerDaimyo, avoidAll);
  rmSetObjectDefMinDistance(playerDaimyo, 7.0);	
  rmSetObjectDefMaxDistance(playerDaimyo, 10.0);	
  
    // War Banner Decorations
  int startBannerID = rmCreateObjectDef("war banners");
	rmAddObjectDefItem(startBannerID, "ypPropsJapaneseBanner", 1, 0.0);
	rmAddObjectDefConstraint(startBannerID, avoidAll);
  rmAddObjectDefConstraint(startBannerID, avoidBannerShort);
	rmSetObjectDefMinDistance(startBannerID, 18.0);	
	rmSetObjectDefMaxDistance(startBannerID, 23.0);	
    
	int waterSpawnPointID = 0;
   
  // Clear out constraints for good measure.
  rmClearClosestPointConstraints(); 
   
	for(i=1; <cNumberPlayers)
   {
	    // Place TC and starting units
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
    rmPlaceObjectDefAtLoc(playerDaimyo, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceGroupingAtLoc(playerWalls, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerCastle, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));      
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));   
    rmPlaceObjectDefAtLoc(playerGoldID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));   
		rmPlaceObjectDefAtLoc(playerTurkeyID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));  										
		rmPlaceObjectDefAtLoc(playerCrateID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    //~ rmPlaceObjectDefAtLoc(startBannerID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    //~ rmPlaceObjectDefAtLoc(startBannerID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerPopBlock, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
        
		// Place player starting trees
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
     
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
     
		// Place water spawn points for the players
		waterSpawnPointID=rmCreateObjectDef("colony ship "+i);
		rmAddObjectDefItem(waterSpawnPointID, "HomeCityWaterSpawnFlag", 1, 10.0);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand); 
    rmAddClosestPointConstraint(flagEdgeConstraint); 
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(waterSpawnPointID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
    
    // place some starter fishing boats at the spawn flag. We're that nice.
    int fishingBoatID1=rmCreateObjectDef("FishingBoat1"+i);
    int fishingBoatID2=rmCreateObjectDef("FishingBoat2"+i);
    
    if (rmGetPlayerCiv(i) ==  rmGetCivID("Japanese") || rmGetPlayerCiv(i) ==  rmGetCivID("Indians") || rmGetPlayerCiv(i) ==  rmGetCivID("Chinese")) {
      rmAddObjectDefItem(fishingBoatID1, "ypFishingBoatAsian", 1, 10.0);
      rmAddObjectDefItem(fishingBoatID2, "ypFishingBoatAsian", 1, 10.0);
    }
    
    else {
      rmAddObjectDefItem(fishingBoatID1, "FishingBoat", 1, 10.0);
      rmAddObjectDefItem(fishingBoatID2, "FishingBoat", 1, 10.0);
    }
    
    rmPlaceObjectDefAtLoc(fishingBoatID1, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
    rmPlaceObjectDefAtLoc(fishingBoatID2, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));        
		
    // clear closest point for next iteration
    rmClearClosestPointConstraints();
   }
	
   	// text
	rmSetStatusText("",0.75);
   rmEchoInfo("75 percent map loaded");

	// Resource time

    // text
	rmSetStatusText("",0.80);
    rmEchoInfo("80 percent map loaded");  

	// Gold
	int goldID = rmCreateObjectDef("random silver");
	rmAddObjectDefItem(goldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(goldID, 0.0);
	rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(goldID, playerConstraintFar);
  rmAddObjectDefConstraint(goldID, avoidAll);
	rmAddObjectDefConstraint(goldID, avoidCoin);
  rmAddObjectDefConstraint(goldID, avoidGold);
  rmAddObjectDefConstraint(goldID, avoidImpassableLand);
  rmAddObjectDefConstraint(goldID, avoidImportantItem);    
	rmPlaceObjectDefInArea(goldID, 0, bigIslandID, cNumberNonGaiaPlayers*2.5);

	// Berries
	int berriesID=rmCreateObjectDef("random berries");
	rmAddObjectDefItem(berriesID, "berrybush", rmRandInt(4,6), 6.0);  // (3,5) is unit count range.  10.0 is float cluster - the range area the objects can be placed.
	rmSetObjectDefMinDistance(berriesID, 0.0);
	rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(berriesID, playerConstraint);
	rmAddObjectDefConstraint(berriesID, avoidAll);
	rmAddObjectDefConstraint(berriesID, avoidRandomBerries);
	rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
  rmAddObjectDefConstraint(berriesID, avoidImportantItem);    
	rmPlaceObjectDefInArea(berriesID, 0, bigIslandID, cNumberNonGaiaPlayers*2); 
  
  // Forests
  numTries=10*cNumberNonGaiaPlayers;
  int failCount=0;

  for (i=0; <numTries) {   
    int forest=rmCreateArea("forest "+i, bigIslandID);
    rmSetAreaWarnFailure(forest, false);
    rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(300));
    rmSetAreaForestType(forest, forestType);
    rmSetAreaForestDensity(forest, 0.5);
    rmSetAreaForestClumpiness(forest, 0.2);
    rmSetAreaForestUnderbrush(forest, 0.1);
    rmSetAreaCoherence(forest, 0.4);
    rmAddAreaToClass(forest, rmClassID("classForest")); 
    rmAddAreaConstraint(forest, forestConstraint);
    rmAddAreaConstraint(forest, avoidImportantItem); 
    rmAddAreaConstraint(forest, avoidWater4);
    rmAddAreaConstraint(forest, playerConstraint);
    rmAddAreaConstraint(forest, forestVsCoin);
    
    if(rmBuildArea(forest)==false)
     {
        // Stop trying once we fail 7 times in a row.
        failCount++;
        if(failCount==7)
           break;
     }
     else
        failCount=0; 
  } 

	// Huntables
	int turkeyID=rmCreateObjectDef("random food");
	rmAddObjectDefItem(turkeyID, huntable1, rmRandInt(3,5), 5.0);
	rmSetObjectDefMinDistance(turkeyID, 0.0);
	rmSetObjectDefMaxDistance(turkeyID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(turkeyID, playerConstraint);
	rmAddObjectDefConstraint(turkeyID, avoidRandomTurkeys);
	rmAddObjectDefConstraint(turkeyID, avoidImpassableLand);
 	rmAddObjectDefConstraint(turkeyID, avoidImportantItem); 
  rmSetObjectDefCreateHerd(turkeyID, true);
	rmPlaceObjectDefInArea(turkeyID, 0, bigIslandID, cNumberNonGaiaPlayers*2);
  
	// Easier nuggets
	int nugget1= rmCreateObjectDef("nugget easy"); 
	rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget1, 0.0);
	rmSetNuggetDifficulty(1, 2);
	rmSetObjectDefMaxDistance(nugget1, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget1, avoidNugget);
	rmAddObjectDefConstraint(nugget1, playerConstraint);
	rmAddObjectDefConstraint(nugget1, avoidAll);
  rmAddObjectDefConstraint(nugget1, avoidImportantItem); 
	rmAddObjectDefConstraint(nugget1, avoidWater4);
	rmPlaceObjectDefInArea(nugget1, 0, bigIslandID, cNumberNonGaiaPlayers*3);

  if(cNumberTeams == 2 && cNumberNonGaiaPlayers > 2){
    rmSetNuggetDifficulty(12, 12);
	  	rmPlaceObjectDefInArea(nugget1, 0, bigIslandID, cNumberNonGaiaPlayers);
  }
	// Tougher nuggets
	//~ int nugget2= rmCreateObjectDef("nugget hard"); 
	//~ rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
	//~ rmSetObjectDefMinDistance(nugget2, 0.0);
	//~ rmSetNuggetDifficulty(3, 4);
	//~ rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
	//~ rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
	//~ rmAddObjectDefConstraint(nugget2, avoidNugget);
	//~ rmAddObjectDefConstraint(nugget2, avoidAll);
  //~ rmAddObjectDefConstraint(nugget2, avoidImportantItem); 
  //~ rmAddObjectDefConstraint(nugget2, playerConstraint);
	//~ rmAddObjectDefConstraint(nugget2, avoidWater4);
	//~ rmPlaceObjectDefInArea(nugget2, 0, bigIslandID, cNumberNonGaiaPlayers);

    // --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.90);
    rmEchoInfo("90 percent map loaded");
    
  // Water nuggets
  
  int nugget2= rmCreateObjectDef("nugget water"); 
  rmAddObjectDefItem(nugget2, "ypNuggetBoat", 1, 0.0);
  rmSetNuggetDifficulty(5, 5);
  rmSetObjectDefMinDistance(nugget2, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget2, avoidLand);
  rmAddObjectDefConstraint(nugget2, avoidNuggetFar);
  rmPlaceObjectDefAtLoc(nugget2, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);

	// Random whales
	int whaleID=rmCreateObjectDef("whale");
	rmAddObjectDefItem(whaleID, whale1, 1, 0.0);
	rmSetObjectDefMinDistance(whaleID, 0.0);
	rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));		//Distance whales will be placed from the starting spot (below)
	rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
	rmAddObjectDefConstraint(whaleID, whaleLand);
  rmAddObjectDefConstraint(whaleID, whaleEdgeConstraint);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3 + rmRandInt(2,3));

	// Place Random Fish everywhere, but restrained to avoid whales ------------------------------------------------------

	int fishID=rmCreateObjectDef("fish 1");
	rmAddObjectDefItem(fishID, fish1, 1, 0.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishVsWhaleID);
	rmAddObjectDefConstraint(fishID, fishLand);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 13*cNumberNonGaiaPlayers);

	int fish2ID=rmCreateObjectDef("fish 2");
	rmAddObjectDefItem(fish2ID, fish2, 1, 0.0);
	rmSetObjectDefMinDistance(fish2ID, 0.0);
	rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fish2ID, fishVsFishTarponID);
	rmAddObjectDefConstraint(fish2ID, fishVsWhaleID);
	rmAddObjectDefConstraint(fish2ID, fishLand);
	rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);

	if (cNumberNonGaiaPlayers <5)		// If less than 5 players, place extra fish.
	{
		rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 9*cNumberNonGaiaPlayers);	
	}

  // Regicide Triggers
	for(i=1; <= cNumberNonGaiaPlayers) {
    
    // Lose on Daimyo's death
    rmCreateTrigger("DaimyoDeath"+i);
    rmSwitchToTrigger(rmTriggerID("DaimyoDeath"+i));
    rmSetTriggerPriority(4); 
    rmSetTriggerActive(true);
    rmSetTriggerRunImmediately(true);
    rmSetTriggerLoop(false);
    
    rmAddTriggerCondition("Is Dead");
    rmSetTriggerConditionParamInt("SrcObject", rmGetUnitPlacedOfPlayer(playerDaimyo, i), false);
    
    rmAddTriggerEffect("Set Player Defeated");
    rmSetTriggerEffectParamInt("Player", i, false);
    
    // Setup Bastion
    //~ rmCreateTrigger("Bastion"+i);
    //~ rmSwitchToTrigger(rmTriggerID("Bastion"+i));
    //~ rmSetTriggerPriority(3); 
    //~ rmSetTriggerActive(true);
    //~ rmSetTriggerRunImmediately(true);
    //~ rmSetTriggerLoop(false);
    
    //~ rmAddTriggerCondition("Always");
    
    //~ rmAddTriggerEffect("Set Tech Status");
    //~ rmSetTriggerEffectParamInt("PlayerID", i, false);
    //~ rmSetTriggerEffectParam("TechID", "236", false);
    //~ rmSetTriggerEffectParam("Status", "2", false);
  }
  
  // Vary some terrain
  for (i=0; < 30) {
    int patch=rmCreateArea("first patch "+i);
    rmSetAreaWarnFailure(patch, false);
    rmSetAreaSize(patch, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
    rmSetAreaMix(patch, baseMix);
    rmSetAreaTerrainType(patch, patchTerrain);
    rmAddAreaTerrainLayer(patch, patchType1, 0, 1);
    rmAddAreaToClass(patch, rmClassID("classPatch"));
    rmSetAreaCoherence(patch, 0.4);
    rmAddAreaConstraint(patch, shortAvoidImpassableLand);
    rmBuildArea(patch); 
  }
      
  for (i=0; <10) {
    int dirtPatch=rmCreateArea("paint patch "+i);
    rmSetAreaWarnFailure(dirtPatch, false);
    rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
    rmSetAreaMix(dirtPatch, baseMix);
    rmSetAreaTerrainType(dirtPatch, patchTerrain);
    rmAddAreaTerrainLayer(dirtPatch, patchType2, 0, 1);
    rmAddAreaToClass(dirtPatch, rmClassID("classPatch"));
    rmSetAreaCoherence(dirtPatch, 0.4);
    rmAddAreaConstraint(dirtPatch, shortAvoidImpassableLand);
    rmAddAreaConstraint(dirtPatch, patchConstraint);
    rmBuildArea(dirtPatch); 
  }
  
  int warBannerID = rmCreateObjectDef(" more war banners");
	rmAddObjectDefItem(warBannerID, "ypPropsJapaneseBanner", 1, 0.0);
	rmAddObjectDefConstraint(warBannerID, avoidAll);
  rmAddObjectDefConstraint(warBannerID, avoidBanner);
	rmSetObjectDefMinDistance(warBannerID, 0.0);	
	rmSetObjectDefMaxDistance(warBannerID, 400.0);
  //~ rmPlaceObjectDefPerPlayer(warBannerID, false, 2);
  
    // text
	rmSetStatusText("",0.99);
    rmEchoInfo("99 percent map loaded");
}