// East India Trading Company - Deccan
// August 06 - PJJ
// Started with Amazonia script

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

  // Text
  // These status text lines are used to manually animate the map generation progress bar
  rmSetStatusText("",0.01);

  // determines map orientation - 1 is E/W, 2 is N/S
  int whichVersion = rmRandInt(1,2);
  
  // version switcher for testing
  // whichVersion = 2;
  
  //Bhakti/Udasi appear on this map
  int subCiv0=-1;
  int subCiv1=-1;
  int subCiv2=-1;

  if (rmAllocateSubCivs(3) == true) {
		subCiv0=rmGetCivID("Udasi");
		rmEchoInfo("subCiv0 is Udasi "+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Udasi");

		subCiv1=rmGetCivID("Bhakti");
		rmEchoInfo("subCiv1 is Bhakti "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Bhakti");
    
    subCiv2=rmGetCivID("Sufi");
		rmEchoInfo("subCiv1 is Sufi "+subCiv2);
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "Sufi");
	}

   // Picks the map size
	int playerTiles = 20000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 18000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 16000;			

  int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
  rmEchoInfo("Map size="+size+"m x "+size+"m");
  rmSetMapSize(size, size);

	rmSetWindMagnitude(2);

  // Picks a default water height
  rmSetSeaLevel(-3.0);

   // Picks default terrain and water
	//	rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
	rmSetMapElevationParameters(cElevTurbulence, 0.06, 1, 0.4, 3.0);
  rmSetMapElevationHeightBlend(0.6);
	rmSetMapType("deccan");
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetWorldCircleConstraint(true);
  rmSetLightingSet("deccan");

  // Init map.
  rmSetBaseTerrainMix("deccan_grassy_Dirt_a");
  rmTerrainInitialize("Deccan\ground_grass2_deccan", -2);

	chooseMercs();

	// Make it rain
  rmSetGlobalRain( 0.3 );

  // Define some classes. These are used later for constraints.
  int classPlayer=rmDefineClass("player");
  rmDefineClass("classForest");
  rmDefineClass("importantItem");
  rmDefineClass("socketClass");
  int foodClass = rmDefineClass("FoodClass");

  // -------------Define constraints
  // These are used to have objects and areas avoid each other
   
  // Map edge constraints
  int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int resourceEdgeConstraint=rmCreatePieConstraint("resource edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int forestMidConstraint=rmCreatePieConstraint("dense middle forests", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.16), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int edgeForestConstraint=rmCreatePieConstraint("Ring for sparse forests near edge of map", 0.5, 0.5, rmXFractionToMeters(0.24), rmXFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

  // Player constraints
  int playerConstraint=rmCreateClassDistanceConstraint("avoid players", classPlayer, 10.0);
  int playerConstraintMid=rmCreateClassDistanceConstraint("resources avoid players", classPlayer, 15.0);
  int playerConstraintFar=rmCreateClassDistanceConstraint("resources avoid players far", classPlayer, 35.0);
  int playerConstraintNative=rmCreateClassDistanceConstraint("natives avoid players far", classPlayer, 35.0);
  int playerConstraintNugget=rmCreateClassDistanceConstraint("nuggets avoid players far", classPlayer, 65.0);
  int avoidTC = rmCreateTypeDistanceConstraint("avoid TCs", "TownCenter", 20.0);
 
  // Nature avoidance
  int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
  int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 25.0);
  int forestConstraintSmall=rmCreateClassDistanceConstraint("forest vs. forest less", rmClassID("classForest"), 15.0);
  int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
  int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "mine", 70.0);
  int avoidGold=rmCreateTypeDistanceConstraint("avoid gold", "minegold", 60.0);
  int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
  int avoidFood = rmCreateClassDistanceConstraint("avoid foods", foodClass, 12.0);
  int avoidFoodMid = rmCreateClassDistanceConstraint("avoid foods mid", foodClass, 25.0);
  int avoidFoodFar = rmCreateClassDistanceConstraint("avoid foods far", foodClass, 45.0);
  int avoidElephants = rmCreateTypeDistanceConstraint("avoid elephants far", "ypWildElephant", 60.0);
  int avoidHerdables=rmCreateTypeDistanceConstraint("avoids cattle", "ypWaterBuffalo", 65.0); 
  int avoidImportantItem=rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 5.0);
  int avoidImportantItemFar=rmCreateClassDistanceConstraint("important stuff avoids each other far", rmClassID("importantItem"), 15.0);
  int avoidBerries = rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 65.0);
  
  // Avoid impassable land
  int avoidImpassableLandShort=rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 4.0);
  int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
  int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 12.5);
  
  // Constraint to avoid water.
  int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
  int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 10.0);
  
  // Constraint for grassy area to seek water
  int riverGrass = rmCreateTerrainMaxDistanceConstraint("stay near the water", "land", false, 5.0);

  // Unit avoidance
  int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 10.0);

  // general avoidance
  int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 5.0);

  // Trade route avoidance.
  int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
  int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 35.0);
  int avoidTradeRouteSocketsFar=rmCreateTypeDistanceConstraint("avoid trade route sockets far", "socketTradeRoute", 25.0);
  int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid trade route sockets", "socketTradeRoute", 5.0);

  // Player placing  
  
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
  
  // determine where the river is going to be now so we can push the player on the dry side out a bit
  int randomRiver = rmRandInt(1,2);
  //~ whichVersion = 2;
  //~ randomRiver = 1;
  
  if (cNumberTeams == 2)	{
    
    if(whichVersion == 1) {
      rmSetPlacementTeam(0);
      
      if(randomRiver == 1)
        rmSetPlacementSection(0.78, 0.95);
      
      else 
        rmSetPlacementSection(0.81, 0.98);
      
      if(teamZeroCount == 1)
        rmSetPlacementSection(.87, .88);
      rmPlacePlayersCircular(.36, .36, 0);

      rmSetPlacementTeam(1);
      
      if(randomRiver == 1)
        rmSetPlacementSection(.30, .47);
      
      else 
        rmSetPlacementSection(.27, .44);  
      
      if(teamOneCount == 1)
        rmSetPlacementSection(.37, .38);
      rmPlacePlayersCircular(.36, .36, 0);
    }
    
    else {
      rmSetPlacementTeam(0);
      
      if(randomRiver == 1)
        rmSetPlacementSection(0.06, 0.23);
      
      else 
        rmSetPlacementSection(0.03, 0.2);

      if(teamZeroCount == 1)
        rmSetPlacementSection(.15, .16);
      rmPlacePlayersCircular(.36, .36, 0);

      rmSetPlacementTeam(1);
      
      if(randomRiver == 1)
        rmSetPlacementSection(.53, .70);
      
      else 
        rmSetPlacementSection(.56, .73);

      if(teamOneCount == 1)
        rmSetPlacementSection(.64, .65);
      rmPlacePlayersCircular(.36, .36, 0);
    }
	}

  // FFA
  else {
    rmPlacePlayersCircular(0.225, 0.225, 0.0);
  }

  // Text
  rmSetStatusText("",0.10);

  float playerFraction=rmAreaTilesToFraction(100);
  for(i=1; <cNumberPlayers) {
    // Create the area.
    int id=rmCreateArea("Player"+i);
    // Assign to the player.
    rmSetPlayerArea(i, id);
    // Set the size.
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classPlayer); 
    rmAddAreaConstraint(id, playerConstraint); 
    rmAddAreaConstraint(id, playerEdgeConstraint); 
    rmAddAreaConstraint(id, avoidImpassableLand);
    rmAddAreaConstraint(id, avoidTradeRoute);
    rmAddAreaConstraint(id, avoidWater10);
    rmSetAreaCoherence(id, 1.0);
    //rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, false);
  }
  
  rmBuildAllAreas();
  
  // Text
  rmSetStatusText("",0.25);

  // Placement order
  // Rivers & Cliffs -> Trade route -> Resources -> Nuggets

  // Rivers and cliffs
  // Half the time there will be a river to the north, half to the south (same with v2 of the map)
  
  int northRiver = rmRiverCreate(-1, "Deccan Plateau River", 5, 5, 5, 5);
  int southRiver = rmRiverCreate(-1, "Deccan Plateau River", 5, 5, 5, 5);
  float riverXLoc = 0;
  float riverYLoc = 0;
  
  // north/west river
  if (randomRiver == 1) {
    if(whichVersion == 1) {
      rmRiverAddWaypoint(northRiver, 0.40, 1.0);
      rmRiverAddWaypoint(northRiver, .73, .73);
      riverXLoc = .73;
      riverYLoc = .73;
      rmRiverAddWaypoint(northRiver, 1.0, 0.40);
    }
    
    else {
      rmRiverAddWaypoint(northRiver, 0.64, 1.0);
      rmRiverAddWaypoint(northRiver, .3, .7);
      riverXLoc = .3;
      riverYLoc = .7;
      rmRiverAddWaypoint(northRiver, 0.0, 0.375);
    }
    
    rmRiverSetShallowRadius(northRiver, 5);
    rmRiverAddShallow(northRiver, rmRandFloat(0.15, 0.25));
    rmRiverAddShallow(northRiver, rmRandFloat(0.45, 0.55));
    rmRiverAddShallow(northRiver, rmRandFloat(0.75, 0.85));
    rmRiverSetBankNoiseParams(northRiver, 0.07, 2, 15.0, 15.0, 0.667, 1.8);
    rmRiverBuild(northRiver);
  }
  
  // south/east river  
  else {
    if(whichVersion == 1) {
      rmRiverAddWaypoint(southRiver, 0.0, 0.65);
      rmRiverAddWaypoint(southRiver, .29, .29);
      riverXLoc = .29;
      riverYLoc = .29;
      rmRiverAddWaypoint(southRiver, 0.65, 0.0);
    }
    
    else {
      rmRiverAddWaypoint(southRiver, 1.0, 0.64);
      rmRiverAddWaypoint(southRiver, .7, .3);
      riverXLoc = .7;
      riverYLoc = .3;
      rmRiverAddWaypoint(southRiver, 0.375, 0.0);
    } 
    
    rmRiverSetShallowRadius(southRiver, 5);
    rmRiverAddShallow(southRiver, rmRandFloat(0.15, 0.25));
    rmRiverAddShallow(southRiver, rmRandFloat(0.45, 0.55));
    rmRiverAddShallow(southRiver, rmRandFloat(0.75, 0.85));
    rmRiverSetBankNoiseParams(southRiver, 0.07, 2, 15.0, 15.0, 0.667, 1.8);
    rmRiverBuild(southRiver);
  }

  // Paint some grass near the river
  int grassPatch=rmCreateArea("grassy area near river");
  rmSetAreaSize(grassPatch, .5, .5);
  rmSetAreaLocation(grassPatch, riverXLoc, riverYLoc);
  rmSetAreaWarnFailure(grassPatch, false);
  rmSetAreaSmoothDistance(grassPatch, 10);
  rmSetAreaCoherence(grassPatch, .6);
  rmSetAreaMix(grassPatch, "deccan_grass_b");
  rmAddAreaConstraint(grassPatch, riverGrass);
  rmBuildArea(grassPatch);
  
  // Cliff only present in non-FFA games
  int startingCliff1=rmCreateArea("Plateau");
  rmSetAreaSize(startingCliff1, .125, .125);
  rmSetAreaLocation(startingCliff1, .5, .5);
  rmSetAreaWarnFailure(startingCliff1, false);
  rmSetAreaSmoothDistance(startingCliff1, 10);
  rmSetAreaCoherence(startingCliff1, .6);
  rmSetAreaCliffType(startingCliff1, "Deccan Plateau");
  rmSetAreaCliffEdge(startingCliff1, 6, .14, 0, 1.0, 0);
  if(cNumberTeams == 2) 
    rmSetAreaCliffHeight(startingCliff1, 8, 2.0, 0.5);

  else
    rmSetAreaCliffHeight(startingCliff1, 0, 0.0, 0.5);
    
  rmSetAreaTerrainType(startingCliff1, "Deccan\ground_grass4_deccan");
  rmSetAreaMix(startingCliff1, "deccan_grass_a");
  //rmSetAreaCliffPainting(startingCliff1, true, true, true, 0, true);
  rmAddAreaConstraint(startingCliff1, avoidWater10);
  rmBuildArea(startingCliff1);
  
  // south/east trade route
  int tradeRouteID = rmCreateTradeRoute();
  int socketID=rmCreateObjectDef("south trade route");
  rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

  rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
  rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
  rmSetObjectDefMinDistance(socketID, 6.0);
  rmSetObjectDefMaxDistance(socketID, 8.0);

  // When S/E river present, don't push trade routes towards middle
  if (randomRiver == 2) {
    // south
    if(whichVersion == 1) {
      rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.4);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.1, 0.3);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.1);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.4, 0.0);
    }
    
    // east
    else {
      rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.4);
      rmAddTradeRouteWaypoint(tradeRouteID, .6, 0.0);
    }
  }

  // When N/W river present, push trade routes towards center
  else {
    // South
    if(whichVersion == 1) {
      rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.55);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.275, 0.275);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.0);
    }
    
    // east
    else {
      rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.55);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.675, 0.275);
      rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.0);
    }
  }
  
  bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "water");
  if(placedTradeRoute == false)
    rmEchoError("Failed to place trade route"); 
  
  if(randomRiver == 1)
    vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
  
  else 
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.25);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
  // Extra socket for more players or on long route side
  if(cNumberNonGaiaPlayers > 3 || randomRiver == 1) {
    if(cNumberTeams > 2 && cNumberNonGaiaPlayers == 3) {
      // No center TP for this setup
    }
    
    else {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    }
  }

  if(randomRiver == 1)
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
  
  else 
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  // north/west trade route
  int tradeRoute2ID = rmCreateTradeRoute();
  socketID=rmCreateObjectDef("north trade route");
  rmSetObjectDefTradeRouteID(socketID, tradeRoute2ID);

  rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
  rmSetObjectDefMinDistance(socketID, 6.0);
  rmSetObjectDefMaxDistance(socketID, 8.0);
  rmAddObjectDefToClass(socketID, rmClassID("socketClass"));

  // When N/W river present, don't push trade routes
  if(randomRiver == 1) {
    // north
    if(whichVersion == 1) {
      rmAddTradeRouteWaypoint(tradeRoute2ID, 1.0, 0.6);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.7, 0.9);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.9, 0.7);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.6, 1.0);
    }
    
    // west
    else {
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.0, 0.6);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.4, 1.0);
    }
  }
  
  // When S/E river present, push routes to center a bit
  else {
    // north
    if(whichVersion == 1) {
      rmAddTradeRouteWaypoint(tradeRoute2ID, 1.0, 0.45);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.725, 0.725);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.45, 1.0);
    }
    
    // west
    else {
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.0, 0.45);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.275, 0.725);
      rmAddTradeRouteWaypoint(tradeRoute2ID, 0.55, 1.0);
    }    
  }
  
  placedTradeRoute = rmBuildTradeRoute(tradeRoute2ID, "water");
  if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 
  
	// add the sockets along the trade route.
  if(randomRiver == 2)
    socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.2);
  
  else 
    socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.25);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  // Extra socket for more players or on long route side
  if(cNumberNonGaiaPlayers > 3 || randomRiver == 2) {
    if(cNumberTeams > 2 && cNumberNonGaiaPlayers == 3) {
      // No center TP for this setup
    }
    
    else {
      socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    }
  }
   
  if(randomRiver == 2)
    socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.8);
  
  else 
    socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.75);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
  // Natives
  
  int randomNative1 = rmRandInt(1,3);
  int randomNative2 = rmRandInt(1,3);
  
  string nativeString1 = "native udasi village ";
  string nativeString2 = "native bhakti village ";
  string nativeString3 = "native sufi mosque deccan ";
  
  string stringNative1 = "";
  string stringNative2 = "";
  
  if(randomNative1 == 1)
    stringNative1 = nativeString1;
  
  else if (randomNative1 == 2)
    stringNative1 = nativeString2;
  
  else
    stringNative1 = nativeString3;
    
  if(randomNative2 == 1)
    stringNative2 = nativeString1;
  
  else if (randomNative2 == 2)
    stringNative2 = nativeString2;
  
  else
    stringNative2 = nativeString3;
  
  
  if (subCiv0 == rmGetCivID("Udasi")) {  
    int udasiVillageAID = -1;
    int udasiVillageType = rmRandInt(1,5);
    udasiVillageAID = rmCreateGrouping("Udasi village A", stringNative1+udasiVillageType);
    rmSetGroupingMinDistance(udasiVillageAID, 0.0);
    rmSetGroupingMaxDistance(udasiVillageAID, 10.0);
    rmAddGroupingConstraint(udasiVillageAID, avoidImpassableLandFar);
    rmAddGroupingConstraint(udasiVillageAID, playerConstraint);
    rmAddGroupingConstraint(udasiVillageAID, avoidImportantItemFar);
    rmAddGroupingToClass(udasiVillageAID, rmClassID("importantItem"));
    
    if(cNumberTeams > 2) {
      if(whichVersion == 1)
        rmPlaceGroupingAtLoc(udasiVillageAID, 0, 0.2, 0.8); 
    
      else
        rmPlaceGroupingAtLoc(udasiVillageAID, 0, 0.8, 0.8);
    }
    
    else {
      //~ rmPlaceGroupingInArea(udasiVillageAID, 0, startingCliff1, 1);
      rmPlaceGroupingAtLoc(udasiVillageAID, 0, 0.5, 0.6);
    }
  }
    
  if (subCiv1 == rmGetCivID("Bhakti")) {   
      int bhaktiVillageAID = -1;
      int bhaktiVillageType = rmRandInt(1,5);
      bhaktiVillageAID = rmCreateGrouping("Bhakti village A", stringNative2+bhaktiVillageType);
      rmSetGroupingMinDistance(bhaktiVillageAID, 0.0);
      rmSetGroupingMaxDistance(bhaktiVillageAID, 10.0);
      rmAddGroupingConstraint(bhaktiVillageAID, avoidImpassableLandFar);
      rmAddGroupingToClass(bhaktiVillageAID, rmClassID("importantItem"));
      rmAddGroupingConstraint(bhaktiVillageAID, playerConstraint);
      rmAddGroupingConstraint(bhaktiVillageAID, avoidImportantItemFar);
      
    if(cNumberTeams > 2) {
      if(whichVersion == 1)
        rmPlaceGroupingAtLoc(bhaktiVillageAID, 0, 0.8, 0.2);  
      
      else
        rmPlaceGroupingAtLoc(bhaktiVillageAID, 0, 0.2, 0.2);
	  } 
    
    else {
      //~ rmPlaceGroupingInArea(bhaktiVillageAID, 0, startingCliff1, 1);
      rmPlaceGroupingAtLoc(bhaktiVillageAID, 0, 0.5, 0.4);
    }
  }
  
   // Text
   rmSetStatusText("",0.45);

	// PLAYER STARTING RESOURCES

   rmClearClosestPointConstraints();

	// Player placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 8.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
  
	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart()) {
			rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
  }
	else {
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
  }

  rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 5.0);

	rmAddObjectDefConstraint(TCID, avoidTownCenter);
	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
	rmAddObjectDefConstraint(TCID, avoidImpassableLand);

	int playerSilverID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerSilverID, "minegold", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerSilverID, avoidTownCenter);
	rmSetObjectDefMinDistance(playerSilverID, 12.0);
	rmSetObjectDefMaxDistance(playerSilverID, 16.0);
  rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);

	int playerFoodID=rmCreateObjectDef("player nilgai");
  rmAddObjectDefItem(playerFoodID, "ypNilgai", 8, 6.0);
  rmAddObjectDefToClass(playerFoodID, foodClass);
  rmSetObjectDefMinDistance(playerFoodID, 8);
  rmSetObjectDefMaxDistance(playerFoodID, 14);
	rmAddObjectDefConstraint(playerFoodID, avoidAll);
  rmAddObjectDefConstraint(playerFoodID, avoidFood);
  rmAddObjectDefConstraint(playerFoodID, avoidImpassableLand);
  rmSetObjectDefCreateHerd(playerFoodID, false);

	int playerTreeID=rmCreateObjectDef("player trees");
  rmAddObjectDefItem(playerTreeID, "ypTreeDeccan", 7, 13);
  rmSetObjectDefMinDistance(playerTreeID, 8);
  rmSetObjectDefMaxDistance(playerTreeID, 12);
	rmAddObjectDefConstraint(playerTreeID, avoidAll);
  rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
  
  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 15.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 20.0);
  rmAddObjectDefConstraint(playerNuggetID, avoidAll);
  rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  
  int playerCrateID=rmCreateObjectDef("bonus starting crates");
  rmAddObjectDefItem(playerCrateID, "crateOfFood", 3, 7.0);
  rmAddObjectDefItem(playerCrateID, "crateOfWood", 2, 4.0);
  rmAddObjectDefItem(playerCrateID, "crateOfCoin", 2, 4.0);
  rmSetObjectDefMinDistance(playerCrateID, 10);
  rmSetObjectDefMaxDistance(playerCrateID, 12);
	rmAddObjectDefConstraint(playerCrateID, avoidAll);
  rmAddObjectDefConstraint(playerCrateID, avoidImpassableLand);
  
  int playerBerryID=rmCreateObjectDef("player berries");
  rmAddObjectDefItem(playerBerryID, "berryBush", 4, 4.0);
  rmSetObjectDefMinDistance(playerBerryID, 10);
  rmSetObjectDefMaxDistance(playerBerryID, 15);
	rmAddObjectDefConstraint(playerBerryID, avoidAll);
  rmAddObjectDefConstraint(playerBerryID, avoidImpassableLand);

	for(i=1; <cNumberPlayers) {
	  rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	  vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

	  rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	  rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	  rmPlaceObjectDefAtLoc(playerFoodID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerCrateID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerBerryID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    
    // Japanese
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
  }
  
  rmClearClosestPointConstraints();
  
  // Text
  rmSetStatusText("",0.55);
  
	int silverID = -1;
	int silverCount = 3;
  
  if (cNumberNonGaiaPlayers < 5)
    silverCount = 4;
  
	rmEchoInfo("silver count = "+silverCount);

  int rightSilverID = rmCreateObjectDef("silver "+i);
  rmAddObjectDefItem(rightSilverID, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(rightSilverID, rmXFractionToMeters(0.2));
  rmSetObjectDefMaxDistance(rightSilverID, rmXFractionToMeters(0.48));
  rmAddObjectDefConstraint(rightSilverID, avoidAll);
  rmAddObjectDefConstraint(rightSilverID, avoidCoin);    
  rmAddObjectDefConstraint(rightSilverID, avoidGold);
  rmAddObjectDefConstraint(rightSilverID, avoidImpassableLand);
  rmAddObjectDefConstraint(rightSilverID, avoidImportantItem);
  rmAddObjectDefConstraint(rightSilverID, avoidWater10);
  rmAddObjectDefConstraint(rightSilverID, avoidTradeRoute);
  rmAddObjectDefConstraint(rightSilverID, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(rightSilverID, playerConstraintFar);
  rmPlaceObjectDefPerPlayer(rightSilverID, false, silverCount);
  
  int numTries=4*cNumberNonGaiaPlayers;
  int failCount=0;
  
  // Text
  rmSetStatusText("",0.60);

  // heavier forests in central area
  for (i=0; <numTries) {   
    int forest=rmCreateArea("foresta"+i, startingCliff1);
    rmSetAreaWarnFailure(forest, false);
    rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(250));
    rmSetAreaForestType(forest, "Deccan Forest");
    rmSetAreaForestDensity(forest, 0.6);
    rmSetAreaForestClumpiness(forest, 0.4);
    rmSetAreaForestUnderbrush(forest, 0.0);
    rmSetAreaCoherence(forest, 0.7);
    rmAddAreaToClass(forest, rmClassID("classForest"));
    rmAddAreaConstraint(forest, forestConstraintSmall);
    rmAddAreaConstraint(forest, forestObjConstraint);
    rmAddAreaConstraint(forest, forestMidConstraint);
    rmAddAreaConstraint(forest, avoidImportantItem);
    rmAddAreaConstraint(forest, playerConstraintMid);
    rmAddAreaConstraint(forest, avoidWater4); 
    rmAddAreaConstraint(forest, avoidTradeRoute);

     if(rmBuildArea(forest)==false)
     {
        // Stop trying once we fail 3 times in a row.
        failCount++;
        if(failCount==3)
           break;
     }
     else
        failCount=0; 
  } 
 
  // sparser forests around the outside where the gold is
  numTries=7*cNumberNonGaiaPlayers;
  failCount=0;
  
  for (i=0; <numTries) {   
    int outerForest=rmCreateArea("forestb"+i);
    rmSetAreaWarnFailure(outerForest, false);
    rmSetAreaSize(outerForest, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
    rmSetAreaForestType(outerForest, "Deccan Forest");
    rmSetAreaForestDensity(outerForest, 0.4);
    rmSetAreaForestClumpiness(outerForest, 0.45);
    rmSetAreaForestUnderbrush(outerForest, 0.0);
    rmSetAreaCoherence(outerForest, 0.5);
    rmAddAreaToClass(outerForest, rmClassID("classForest"));
    rmAddAreaConstraint(outerForest, forestConstraint);
    rmAddAreaConstraint(outerForest, forestObjConstraint);
    rmAddAreaConstraint(outerForest, edgeForestConstraint);
    rmAddAreaConstraint(outerForest, avoidImportantItem);
    rmAddAreaConstraint(outerForest, avoidWater4); 
    rmAddAreaConstraint(outerForest, playerConstraintMid); 
    rmAddAreaConstraint(outerForest, avoidTradeRoute);
    rmAddAreaConstraint(outerForest, avoidTradeRouteSockets);

    if(rmBuildArea(outerForest)==false)
    {
      // Stop trying once we fail 3 times in a row.
      failCount++;
      if(failCount==3)
        break;
    }
    else
      failCount=0; 
  } 
    
  // Text
  rmSetStatusText("",0.75);

  int foodCount = rmRandInt(6,8);

  int foodID=rmCreateObjectDef("nilgai");
  rmAddObjectDefItem(foodID, "ypNilgai", foodCount, 6.0);
  rmAddObjectDefToClass(foodID, foodClass);
  rmSetObjectDefMinDistance(foodID, 0.0);
  rmSetObjectDefMaxDistance(foodID, rmXFractionToMeters(0.15));
  rmAddObjectDefConstraint(foodID, avoidImpassableLand);
  rmAddObjectDefConstraint(foodID, playerConstraintMid);
  rmAddObjectDefConstraint(foodID, avoidFoodMid);
  rmAddObjectDefConstraint(foodID, avoidImportantItem); 
  rmSetObjectDefCreateHerd(foodID, true);
  rmPlaceObjectDefAtLoc(foodID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
  
  // smaller herds around the map edges
  foodCount = rmRandInt(4,5);
  
  int food2ID=rmCreateObjectDef("more nilgai");
  rmAddObjectDefItem(food2ID, "ypNilgai", foodCount, 4.0);
  rmAddObjectDefToClass(food2ID, foodClass);
  rmSetObjectDefMinDistance(food2ID, 0.0);
  rmSetObjectDefMaxDistance(food2ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(food2ID, avoidImpassableLand);
  rmAddObjectDefConstraint(food2ID, avoidFoodFar);
  rmAddObjectDefConstraint(food2ID, playerConstraintMid);
  rmAddObjectDefConstraint(food2ID, avoidWater4);
  rmAddObjectDefConstraint(food2ID, avoidImportantItem); 
  rmAddObjectDefConstraint(food2ID, edgeForestConstraint);
  rmSetObjectDefCreateHerd(food2ID, true);
  rmPlaceObjectDefAtLoc(food2ID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
  
  foodCount = rmRandInt(2,2);
  
  int food3ID=rmCreateObjectDef("ephelants!");
  rmAddObjectDefItem(food3ID, "ypWildElephant", foodCount, 3.0);
  rmAddObjectDefToClass(food3ID, foodClass);
  rmSetObjectDefMinDistance(food3ID, rmXFractionToMeters(0.25));
  rmSetObjectDefMaxDistance(food3ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(food3ID, avoidImpassableLand);
  rmAddObjectDefConstraint(food3ID, playerConstraintFar);
  rmAddObjectDefConstraint(food3ID, avoidFoodMid);
  rmAddObjectDefConstraint(food3ID, avoidTradeRoute);
  rmAddObjectDefConstraint(food3ID, avoidElephants);
  rmSetObjectDefCreateHerd(food3ID, true);
  rmPlaceObjectDefAtLoc(food3ID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
  
  int herdID=rmCreateObjectDef("water buffalo");
  rmAddObjectDefItem(herdID, "ypWaterBuffalo", 2, 2.5);
  rmSetObjectDefMinDistance(herdID, 0.0);
  rmSetObjectDefMaxDistance(herdID, rmXFractionToMeters(0.225));
  rmAddObjectDefConstraint(herdID, avoidHerdables);
  rmAddObjectDefConstraint(herdID, avoidAll);
  rmAddObjectDefConstraint(herdID, avoidTradeRoute);
  rmAddObjectDefConstraint(herdID, avoidImpassableLandShort);
  rmAddObjectDefConstraint(herdID, avoidTC);
  rmPlaceObjectDefAtLoc(herdID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2); 
  
  // Berries
  int berriesID=rmCreateObjectDef("berries");
	rmAddObjectDefItem(berriesID, "berrybush", 4, 3.0);
	rmSetObjectDefMinDistance(berriesID, 0);
	rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(berriesID, avoidTradeRoute);
  rmAddObjectDefConstraint(berriesID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(berriesID, playerConstraintFar); 
  rmAddObjectDefConstraint(berriesID, avoidBerries);
  rmAddObjectDefConstraint(berriesID, avoidImportantItem);
  rmAddObjectDefConstraint(berriesID, avoidResource);
  rmPlaceObjectDefAtLoc(berriesID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);  

  // Text
  rmSetStatusText("",0.90);
  

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.075;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
  
  // some crazy nuggets
	int crazyNugget= rmCreateObjectDef("nugget crazy"); 
	rmAddObjectDefItem(crazyNugget, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(4, 4);
	rmSetObjectDefMinDistance(crazyNugget, 0.0);
	rmSetObjectDefMaxDistance(crazyNugget, rmXFractionToMeters(0.25));
	rmAddObjectDefConstraint(crazyNugget, avoidImpassableLand);
  rmAddObjectDefConstraint(crazyNugget, avoidNugget);
  rmAddObjectDefConstraint(crazyNugget, avoidTradeRouteFar);
  rmAddObjectDefConstraint(crazyNugget, avoidWater4);
  rmAddObjectDefConstraint(crazyNugget, avoidAll);
  rmAddObjectDefConstraint(crazyNugget, playerConstraintNugget);
  rmAddObjectDefConstraint(crazyNugget, resourceEdgeConstraint);
  rmAddObjectDefConstraint(crazyNugget, avoidImportantItem);
  rmAddObjectDefConstraint(crazyNugget, avoidTradeRouteSockets); 
  rmPlaceObjectDefAtLoc(crazyNugget, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
  
  // some hard nuggets
	int hardNugget= rmCreateObjectDef("nugget hard"); 
	rmAddObjectDefItem(hardNugget, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(hardNugget, 0.0);
	rmSetObjectDefMaxDistance(hardNugget, rmXFractionToMeters(0.25));
	rmAddObjectDefConstraint(hardNugget, avoidImpassableLand);
  rmAddObjectDefConstraint(hardNugget, avoidNugget);
  rmAddObjectDefConstraint(hardNugget, avoidTradeRouteFar);
  rmAddObjectDefConstraint(hardNugget, avoidWater4);
  rmAddObjectDefConstraint(hardNugget, avoidAll);
  rmAddObjectDefConstraint(hardNugget, playerConstraintNugget);
  rmAddObjectDefConstraint(hardNugget, resourceEdgeConstraint);
  rmAddObjectDefConstraint(hardNugget, avoidImportantItem);
  rmAddObjectDefConstraint(hardNugget, avoidTradeRouteSockets); 
  rmPlaceObjectDefAtLoc(hardNugget, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
  
  // medium nuggets
  int mediumNugget= rmCreateObjectDef("nugget medium"); 
	rmAddObjectDefItem(mediumNugget, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
  rmSetObjectDefMinDistance(mediumNugget, rmXFractionToMeters(0.15));
	rmSetObjectDefMaxDistance(mediumNugget, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(mediumNugget, avoidImpassableLand);
  rmAddObjectDefConstraint(mediumNugget, avoidNugget);
  rmAddObjectDefConstraint(mediumNugget, avoidTradeRoute);
	rmAddObjectDefConstraint(mediumNugget, avoidWater4);
  rmAddObjectDefConstraint(mediumNugget, avoidAll);
  rmAddObjectDefConstraint(mediumNugget, playerConstraintNugget);
	rmAddObjectDefConstraint(mediumNugget, resourceEdgeConstraint);
  rmAddObjectDefConstraint(mediumNugget, avoidImportantItem);
  rmAddObjectDefConstraint(mediumNugget, avoidTradeRouteSockets); 
  rmPlaceObjectDefAtLoc(mediumNugget, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);

  // easy nuggets 
  int easyNugget= rmCreateObjectDef("easy nuggets"); 
	rmAddObjectDefItem(easyNugget, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
  rmSetObjectDefMinDistance(easyNugget, rmXFractionToMeters(0.25));
	rmSetObjectDefMaxDistance(easyNugget, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(easyNugget, avoidImpassableLand);
  rmAddObjectDefConstraint(easyNugget, avoidNugget);
  rmAddObjectDefConstraint(easyNugget, avoidTradeRoute);
	rmAddObjectDefConstraint(easyNugget, avoidWater4);
  rmAddObjectDefConstraint(easyNugget, avoidAll);
  rmAddObjectDefConstraint(easyNugget, playerConstraintFar);
	rmAddObjectDefConstraint(easyNugget, resourceEdgeConstraint);
  rmAddObjectDefConstraint(easyNugget, avoidImportantItem); 
  rmAddObjectDefConstraint(easyNugget, avoidTradeRouteSockets); 
  rmPlaceObjectDefAtLoc(easyNugget, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);
  
  // Team nuggets
  if(cNumberTeams == 2 && cNumberNonGaiaPlayers > 2){
    rmSetNuggetDifficulty(12, 12);
	  rmPlaceObjectDefAtLoc(easyNugget, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
  }
  
  // Text
  rmSetStatusText("",1.0);
      
}  
