
// Nov 06 - Yp update

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

  // Text
   rmSetStatusText("",0.01);

	int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;

   if (rmAllocateSubCivs(3) == true)
   {
		subCiv0=rmGetCivID("caribs");
      rmEchoInfo("subCiv0 is caribs "+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "caribs");

      subCiv1=rmGetCivID("caribs");
      rmEchoInfo("subCiv1 is caribs "+subCiv1);
      if (subCiv1 >= 0)
			rmSetSubCiv(1, "caribs");
  
		subCiv2=rmGetCivID("caribs");
		rmEchoInfo("subCiv2 is caribs "+subCiv2);
		if (subCiv2 >= 0)
				rmSetSubCiv(2, "caribs");
	}
	
   // Set size.
   int playerTiles=24000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 17000;
	if (cNumberNonGaiaPlayers >7)
		playerTiles = 19000;			
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   // Set up default water.
   rmSetSeaLevel(2.0);
   rmSetSeaType("caribbean coast");
 	rmSetBaseTerrainMix("caribbean grass");
	rmSetMapType("caribbean");
	rmSetMapType("grass");
	rmSetMapType("water");
   rmSetLightingSet("caribbean");

   // Init map.
   rmTerrainInitialize("water");

   // Define some classes.
   int classPlayer=rmDefineClass("player");
   int classIsland=rmDefineClass("island");
   int classBonusIsland=rmDefineClass("bonusIsland");
   int classTeamIsland=rmDefineClass("teamIsland");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
	rmDefineClass("classSocket");

	chooseMercs();

   // -------------Define constraints
   
   // Create a edge of map constraint.
   int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Player area constraint.
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 25.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("long stay away from players", classPlayer, 60.0);
   int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 20.0);
   int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);
   int nearWaterDock = rmCreateTerrainDistanceConstraint("near water for Dock", "Water", true, 0.0);
	int avoidTC=rmCreateTypeDistanceConstraint("stay away from TC", "TownCenter", 29.0);
	int avoidTCshort=rmCreateTypeDistanceConstraint("stay away from TC by a little bit", "TownCenter", 8.0);
  
  // Using the medium constraint for testing in YP update - PJJ
  int avoidTCMedium=rmCreateTypeDistanceConstraint("stay away from TC by a bit", "TownCenter", 8.0);
	int avoidCW=rmCreateTypeDistanceConstraint("stay away from CW", "CoveredWagon", 15.0);
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 50.0);

   int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);


   // Bonus area constraint.
   int islandConstraint=rmCreateClassDistanceConstraint("islands avoid each other", classIsland, 55.0);
  // int bonusIslandConstraint=rmCreateClassDistanceConstraint("bonus islands avoid islands", classIsland, 30.0);
   int avoidBonusIslands=rmCreateClassDistanceConstraint("stuff avoids bonus islands", classBonusIsland, 30.0);
   int avoidTeamIslands=rmCreateClassDistanceConstraint("stuff avoids team islands", classTeamIsland, 30.0);
 
	// Resource constraint
	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fishSalmon", 20.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "HumpbackWhale", 50.0);
   int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 25.0);
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 40.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "mine", 35.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "abstractNugget", 50.0);
    int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);



   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 13.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);

	// Constraint to avoid water.
   int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 8.0);
	int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 20.0);


   int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 10.0);
   int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 25);
   int flagEdgeConstraint = rmCreatePieConstraint("flags away from edge of map", 0.5, 0.5, rmGetMapXSize()-200, rmGetMapXSize()-100, 0, 0, 0);
   rmAddClosestPointConstraint(avoidWater8);
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
   int avoidSocket = rmCreateClassDistanceConstraint("avoid socket", rmClassID("classSocket"), 10.0);
   int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 50.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);


  // --------------------------------------------------------------------------------Done defining objects


	// Text
	rmSetStatusText("",0.20);

	// Player areas
//	rmSetPlayerPlacementArea(0, 0, 0.6, 0.6);
//	if (cNumberNonGaiaPlayers > 2)
//	  	rmSetPlacementSection(0.12, 0.38);
//	else

		int IslandLoc = rmRandInt(1,4);
		// IslandLoc 1 = N
		// IslandLoc 2 = E
		// IslandLoc 3 = S
		// IslandLoc 4 = W
		//IslandLoc = 3;

		// Northern Island
      int bigIslandID=rmCreateArea("big lone island");
      rmSetAreaSize(bigIslandID, 0.14, 0.14);
      rmSetAreaMinBlobs(bigIslandID, 10);
      rmSetAreaMaxBlobs(bigIslandID, 15);
      rmSetAreaMinBlobDistance(bigIslandID, 8.0);
      rmSetAreaMaxBlobDistance(bigIslandID, 10.0);
      rmSetAreaCoherence(bigIslandID, 0.55);
      rmSetAreaBaseHeight(bigIslandID, 2.0);
      rmSetAreaSmoothDistance(bigIslandID, 20);
		rmSetAreaMix(bigIslandID, "caribbean grass");
      rmAddAreaToClass(bigIslandID, classIsland);
      rmAddAreaConstraint(bigIslandID, islandConstraint);
      rmSetAreaObeyWorldCircleConstraint(bigIslandID, false);
      rmSetAreaElevationType(bigIslandID, cElevTurbulence);
      rmSetAreaElevationVariation(bigIslandID, 4.0);
      rmSetAreaElevationMinFrequency(bigIslandID, 0.09);
      rmSetAreaElevationOctaves(bigIslandID, 3);
      rmSetAreaElevationPersistence(bigIslandID, 0.2);
		rmSetAreaElevationNoiseBias(bigIslandID, 1);
      rmSetAreaWarnFailure(bigIslandID, false);

  float xLoc = 0.0;
  float yLoc = 0.0;
  
		if (IslandLoc == 1){
			rmSetAreaLocation(bigIslandID, 1, 1);
      xLoc = .85;
      yLoc = .85;
      }
		else if (IslandLoc == 2){
			rmSetAreaLocation(bigIslandID, 1, 0);
      xLoc = .85;
      yLoc = .15;
      }
		else if (IslandLoc == 3){
			rmSetAreaLocation(bigIslandID, 0, 0);
      xLoc = .15;
      yLoc = .15;
      }
		else {
			rmSetAreaLocation(bigIslandID, 0, 1);
      xLoc = .15;
      yLoc = .85;
      }

	   rmBuildArea(bigIslandID);

	   //Build Player Islands
		if (cNumberPlayers > 4)
		{

			if (IslandLoc == 1)
				rmSetPlacementSection(0.40, 0.93);
			else if (IslandLoc == 2)
				rmSetPlacementSection(0.57, 0.20);
			else if (IslandLoc == 3)
				rmSetPlacementSection(0.81, 0.43);
			else
				rmSetPlacementSection(0.06, 0.68);
		}
		else
		{
			if (IslandLoc == 1)
				rmSetPlacementSection(0.44, 0.78);
			else if (IslandLoc == 2)
				rmSetPlacementSection(0.63, 0.10);
			else if (IslandLoc == 3)
				rmSetPlacementSection(0.90, 0.33);
			else
				rmSetPlacementSection(0.10, 0.56);
		}


	rmPlacePlayersCircular(0.3, 0.3, rmDegreesToRadians(5.0));
	float isleSize = (0.29 / cNumberTeams);
	rmEchoInfo("Isle size "+isleSize);

   for(i=0; <cNumberTeams)
   {
      // Create the area.
      int teamID=rmCreateArea("team "+i);
      rmSetAreaSize(teamID, isleSize, isleSize);
      rmSetAreaMinBlobs(teamID, 30);
      rmSetAreaMaxBlobs(teamID, 45);
      rmSetAreaMinBlobDistance(teamID, 20.0);
      rmSetAreaMaxBlobDistance(teamID, 40.0);
		rmSetAreaCoherence(teamID, 0.35);
      rmSetAreaBaseHeight(teamID, 2.0);
      rmSetAreaSmoothDistance(teamID, 20);
		rmSetAreaMix(teamID, "caribbean grass");
  //    rmAddAreaToClass(teamID, classPlayer);
      rmAddAreaToClass(teamID, classIsland);
      rmAddAreaToClass(teamID, classTeamIsland);
		rmAddAreaConstraint(teamID, islandConstraint);
  //    rmAddAreaConstraint(teamID, playerConstraint);
//	rmAddAreaConstraint(teamID, playerEdgeConstraint);
		rmSetAreaElevationType(teamID, cElevTurbulence);
      rmSetAreaElevationVariation(teamID, 4.0);
      rmSetAreaElevationMinFrequency(teamID, 0.09);
      rmSetAreaElevationOctaves(teamID, 3);
      rmSetAreaElevationPersistence(teamID, 0.2);
		rmSetAreaElevationNoiseBias(teamID, 1);
        rmSetAreaWarnFailure(teamID, false);
		rmSetAreaLocTeam(teamID, i);
		rmEchoInfo("Team area"+i);
   }

   // Text
	rmSetStatusText("",0.30);


	   rmBuildAllAreas();

		   // Set up player areas.
		for(i=1; <cNumberPlayers)
		{
			// Create the area.
			int id=rmCreateArea("Player"+i, rmAreaID("team "+rmGetPlayerTeam(i)));
			rmEchoInfo("Player "+i+" team "+rmGetPlayerTeam(i));

			// Assign to the player.
			rmSetPlayerArea(i, id);

			// Set the size.
			rmSetAreaSize(id, 1.0, 1.0);
			rmAddAreaToClass(id, classPlayer);

			rmSetAreaMinBlobs(id, 2);
			rmSetAreaMaxBlobs(id, 5);
			rmSetAreaMinBlobDistance(id, 5.0);
			rmSetAreaMaxBlobDistance(id, 10.0);
			rmSetAreaCoherence(id, 0.1);
			rmAddAreaConstraint(id, playerConstraint); 

			// Set the location.
			rmSetAreaLocPlayer(id, i);
			rmSetAreaWarnFailure(id, false);
		}
		rmBuildAllAreas();

	// Text
	rmSetStatusText("",0.40);


   
   // Clear out constraints for good measure.
   rmClearClosestPointConstraints(); 


	int socketID=rmCreateObjectDef("sockets for Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);

	int tradeRoute1ID = rmCreateTradeRoute();

	if (IslandLoc == 1)
	{
		rmAddTradeRouteWaypoint(tradeRoute1ID, 1.0, 0.6);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.75, 0.75, 8, 10);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.6, 1.0, 8, 10);
	}
	else if (IslandLoc == 2)
	{
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0.6, 0.0);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.75, 0.25, 8, 10);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 1.0, 0.4, 8, 10);
	}
	else if (IslandLoc == 3)
	{
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0.4, 0.0);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.25, 0.25, 8, 10);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.0, 0.4, 8, 10);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0.0, 0.6);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.25, 0.75, 8, 10);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.4, 1.0, 8, 10);
	}		

	bool placedTradeRoute1 = rmBuildTradeRoute(tradeRoute1ID, "dirt");
	if(placedTradeRoute1 == false)
		rmEchoError("Failed to place trade route one");

	// add the meeting sockets along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRoute1ID);
	vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.15);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.5);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.80);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);


	// Lonely Caribs
   if (subCiv0 == rmGetCivID("caribs"))
   {  
		int caribsVillageID = -1;
		int caribsVillageType = rmRandInt(1,3);
	  if (cNumberTeams > 2)
		caribsVillageType = rmRandInt(1,5);
      caribsVillageID = rmCreateGrouping("caribs city", "native carib village 0"+caribsVillageType);
      rmSetGroupingMinDistance(caribsVillageID, 0.0);
      rmSetGroupingMaxDistance(caribsVillageID, rmXFractionToMeters(0.3));
		rmAddGroupingConstraint(caribsVillageID, avoidTeamIslands);
		rmAddGroupingConstraint(caribsVillageID, avoidImpassableLand);
		if (IslandLoc == 1)
			rmPlaceGroupingAtLoc(caribsVillageID, 0, 0.8, 0.8);
		else if (IslandLoc == 2)
			rmPlaceGroupingAtLoc(caribsVillageID, 0, 0.7, 0.27);
		else if (IslandLoc == 3)
			rmPlaceGroupingAtLoc(caribsVillageID, 0, 0.27, 0.27);
		else
			rmPlaceGroupingAtLoc(caribsVillageID, 0, 0.27, 0.7);

   }

	// Team Caribs unless FFA

	if (cNumberTeams == 2)
	{
		if (subCiv1 == rmGetCivID("caribs"))
		{  
			int caribs2VillageID = -1;
			int caribs2VillageType = rmRandInt(1,5);
			if (caribsVillageType == 3)
				caribs2VillageType = rmRandInt(1,2);
			caribs2VillageID = rmCreateGrouping("caribs2 city", "native carib village 0"+caribs2VillageType);
			rmAddGroupingConstraint(caribs2VillageID, avoidTC);
			rmAddGroupingConstraint(caribs2VillageID, avoidCW);
			rmAddGroupingConstraint(caribs2VillageID, avoidImpassableLand);
			rmPlaceGroupingInArea(caribs2VillageID, 0, rmAreaID("team 0"));
		}
		
		if (subCiv2 == rmGetCivID("caribs"))
		{  
			int caribs3VillageID = -1;
			int caribs3VillageType = rmRandInt(1,5);
			caribs3VillageID = rmCreateGrouping("caribs3 city", "native carib village 0"+caribs3VillageType);
			rmAddGroupingConstraint(caribs3VillageID, avoidTC);
			rmAddGroupingConstraint(caribs3VillageID, avoidCW);
			rmAddGroupingConstraint(caribs3VillageID, avoidImpassableLand);
			rmPlaceGroupingInArea(caribs3VillageID, 0, rmAreaID("team 1"));
		} 
	}

	// Text
	rmSetStatusText("",0.50);
	
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);

	int TCfloat = -1;
  if (cNumberTeams == 2)
	   TCfloat = 110;
  else 
	   TCfloat = 220;

	int TCID = rmCreateObjectDef("player TC");
	if ( rmGetNomadStart())
		rmAddObjectDefItem(TCID, "coveredWagon", 1, 0);
	else
		rmAddObjectDefItem(TCID, "townCenter", 1, 0);
    
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, TCfloat);
	rmAddObjectDefConstraint(TCID, avoidImpassableLand);
	rmAddObjectDefConstraint(TCID, avoidTC);
	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
	rmAddObjectDefConstraint(TCID, avoidNatives);
	
	int playerSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmSetObjectDefMinDistance(playerSilverID, 10.0);
	rmSetObjectDefMaxDistance(playerSilverID, 30.0);
	rmAddObjectDefConstraint(playerSilverID, avoidAll);
  rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);

	int playerDeerID=rmCreateObjectDef("player deer");
  rmAddObjectDefItem(playerDeerID, "deer", rmRandInt(10,15), 10.0);
  rmSetObjectDefMinDistance(playerDeerID, 15.0);
  rmSetObjectDefMaxDistance(playerDeerID, 30.0);
	rmAddObjectDefConstraint(playerDeerID, avoidAll);
  rmAddObjectDefConstraint(playerDeerID, avoidImpassableLand);
  rmSetObjectDefCreateHerd(playerDeerID, true);

	int colonyShipID = 0;
   
	for(i=1; <cNumberPlayers) {
    rmPlaceObjectDefInArea(TCID, i, rmAreaID("team "+rmGetPlayerTeam(i)), 1);
    vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

    colonyShipID=rmCreateObjectDef("colony ship "+i);
    rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 1.0);
    if ( rmGetNomadStart())
    {
      if(rmGetPlayerCiv(i) == rmGetCivID("Ottomans"))
        rmAddObjectDefItem(colonyShipID, "Galley", 1, 10.0);
      else
        rmAddObjectDefItem(colonyShipID, "caravel", 1, 10.0);
    }
    rmAddClosestPointConstraint(flagEdgeConstraint);
    rmAddClosestPointConstraint(flagVsFlag);
    rmAddClosestPointConstraint(flagLand);
    vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
    
    rmPlaceObjectDefAtLoc(colonyShipID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
    rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
  }
   rmClearClosestPointConstraints();

   // Text
	rmSetStatusText("",0.60);


	// MINES

	int silverID = rmCreateObjectDef("random silver");
	rmAddObjectDefItem(silverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(silverID, 0.0);
	rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(silverID, avoidTC);
	rmAddObjectDefConstraint(silverID, avoidCW);
	rmAddObjectDefConstraint(silverID, avoidAll);
	rmAddObjectDefConstraint(silverID, avoidCoin);
   rmAddObjectDefConstraint(silverID, avoidImpassableLand);
	rmPlaceObjectDefInArea(silverID, true, 2);
	rmPlaceObjectDefInArea(silverID, 0, bigIslandID, cNumberNonGaiaPlayers*rmRandInt(1,1.25));
	for (i=0; <cNumberTeams)
	{
		rmPlaceObjectDefInArea(silverID, 0, rmAreaID("team "+i), cNumberNonGaiaPlayers*0.75);
	}

	// Text
	rmSetStatusText("",0.70);

  // FORESTS
  int forestTreeID = 0;
  int numTries=10*cNumberNonGaiaPlayers;
  int failCount=0;
  for (i=0; <numTries) {   
    int forest=rmCreateArea("forest "+i);
    rmSetAreaWarnFailure(forest, false);
    rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
    rmSetAreaForestType(forest, "caribbean palm forest");
    rmSetAreaForestDensity(forest, 0.6);
    rmSetAreaForestClumpiness(forest, 0.4);
    rmSetAreaForestUnderbrush(forest, 0.0);
    rmSetAreaMinBlobs(forest, 1);
    rmSetAreaMaxBlobs(forest, 5);
    rmSetAreaMinBlobDistance(forest, 16.0);
    rmSetAreaMaxBlobDistance(forest, 40.0);
    rmSetAreaCoherence(forest, 0.4);
    rmSetAreaSmoothDistance(forest, 10);
    rmAddAreaToClass(forest, rmClassID("classForest")); 
    rmAddAreaConstraint(forest, forestConstraint);
    rmAddAreaConstraint(forest, avoidAll);
    rmAddAreaConstraint(forest, avoidTCMedium);
    rmAddAreaConstraint(forest, shortAvoidImpassableLand); 
    rmAddAreaConstraint(forest, avoidTradeRoute); 
    if(rmBuildArea(forest)==false) {
      // Stop trying once we fail 3 times in a row.
      failCount++;
      
      if(failCount==5)
        break;
    }
    
    else
      failCount=0; 
  } 

 // Define and place Nuggets
 
    // Place random flags
    int avoidFlags = rmCreateTypeDistanceConstraint("flags avoid flags", "ControlFlag", 70);
    for ( i =1; <14 ) {
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
    float walk = 0.075;
      
    if(cNumberTeams > 2) {
      walk = 0.15;
    }
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
    
	int nugget1= rmCreateObjectDef("nugget easy"); 
	rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMaxDistance(nugget1, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nugget1, avoidNugget);
  	rmAddObjectDefConstraint(nugget1, avoidTradeRoute);
  	rmAddObjectDefConstraint(nugget1, avoidAll);
	rmAddObjectDefConstraint(nugget1, avoidTCshort);
  	rmAddObjectDefConstraint(nugget1, avoidWater20);
	rmAddObjectDefConstraint(nugget1, playerEdgeConstraint);
	//rmPlaceObjectDefInArea(nugget1, 0, bigIslandID, cNumberNonGaiaPlayers*rmRandInt(1,2));
	for (i=0; <cNumberTeams)
	{
		rmPlaceObjectDefInArea(nugget1, 0, rmAreaID("team "+i), cNumberNonGaiaPlayers*0.5);
	}

	int nugget2= rmCreateObjectDef("nugget hard"); 
	rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget2, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nugget2, avoidNugget);
  	rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
  	rmAddObjectDefConstraint(nugget2, avoidAll);
	rmAddObjectDefConstraint(nugget2, avoidTCshort);
  	rmAddObjectDefConstraint(nugget2, avoidWater20);
	rmAddObjectDefConstraint(nugget2, playerEdgeConstraint);
	rmPlaceObjectDefInArea(nugget2, 0, bigIslandID, cNumberNonGaiaPlayers);

	// Text
	rmSetStatusText("",0.80);

	// DEER	
   int deerID=rmCreateObjectDef("deer herd");
	int bonusChance=rmRandFloat(0, 1);
   if(bonusChance<0.5)   
      rmAddObjectDefItem(deerID, "deer", rmRandInt(4,6), 10.0);
   else
      rmAddObjectDefItem(deerID, "deer", rmRandInt(8,10), 10.0);
   rmSetObjectDefMinDistance(deerID, 0.0);
   rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(deerID, avoidAll);
   rmAddObjectDefConstraint(deerID, avoidImpassableLand);
   rmSetObjectDefCreateHerd(deerID, true);
//	rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);
	rmPlaceObjectDefInArea(deerID, 0, bigIslandID, cNumberNonGaiaPlayers);
	for (i=0; <cNumberTeams)
	{
		rmPlaceObjectDefInArea(deerID, 0, rmAreaID("team "+i), cNumberNonGaiaPlayers*0.5);
	}

	// Text
	rmSetStatusText("",0.90);

   int fishID=rmCreateObjectDef("fish Mahi");
   rmAddObjectDefItem(fishID, "FishMahi", 1, 0.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 11*cNumberNonGaiaPlayers);

   int fish2ID=rmCreateObjectDef("fish Tarpon");
   rmAddObjectDefItem(fish2ID, "FishTarpon", 1, 0.0);
   rmSetObjectDefMinDistance(fish2ID, 0.0);
   rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fish2ID, fishVsFishID);
   rmAddObjectDefConstraint(fish2ID, fishLand);
   rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

   int whaleID=rmCreateObjectDef("whale");
   rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 0.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);

   // RANDOM TREES
   int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, "treeCaribbean", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
   rmAddObjectDefConstraint(randomTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(randomTreeID, avoidAll); 

   rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 15*cNumberNonGaiaPlayers);

	// Text
	rmSetStatusText("",1.0);

  // Water nuggets
  
  int nuggetW= rmCreateObjectDef("nugget water"); 
  rmAddObjectDefItem(nuggetW, "ypNuggetBoat", 1, 0.0);
  rmSetNuggetDifficulty(5, 5);
  rmSetObjectDefMinDistance(nuggetW, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(nuggetW, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nuggetW, avoidLand);
  rmAddObjectDefConstraint(nuggetW, avoidNuggetWater);
  rmPlaceObjectDefAtLoc(nuggetW, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);
    
	// Text
	rmSetStatusText("",0.99);

} 