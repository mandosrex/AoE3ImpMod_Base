// AMAZONIA
// Nov 06 - YP update

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   //only two natives appear on this map!
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;

   if (rmAllocateSubCivs(3) == true)
   {
		subCiv0=rmGetCivID("Tupi");
		rmEchoInfo("subCiv0 is Tupi"+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Tupi");
		subCiv1=rmGetCivID("Zapotec");
		rmEchoInfo("subCiv1 is Zapotec"+subCiv1);
		if (subCiv1 >= 0)
				rmSetSubCiv(1, "Zapotec");
  
		if(rmRandFloat(0,1) < 0.30)
		{
			subCiv2=rmGetCivID("Tupi");
			rmEchoInfo("subCiv2 is Tupi"+subCiv2);
			if (subCiv2 >= 0)
				rmSetSubCiv(2, "Tupi");
		}
		else
		{
			subCiv2=rmGetCivID("Zapotec");
			rmEchoInfo("subCiv2 is Zapotec"+subCiv2);
			if (subCiv2 >= 0)
				rmSetSubCiv(2, "Zapotec");
		}
	}

   // Picks the map size
   // Picks the map size
	int playerTiles = 11000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 10000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 8000;			

   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

	rmSetWindMagnitude(2);

   // Picks a default water height
   rmSetSeaLevel(3.0);

   // Picks default terrain and water
	//	rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
	rmSetMapElevationParameters(cElevTurbulence, 0.04, 4, 0.4, 6.0);
//	rmAddMapTerrainByHeightInfo("amazon\ground2_am", 8.0, 10.0);
//	rmAddMapTerrainByHeightInfo("amazon\ground1_am", 10.0, 16.0);
//   rmSetSeaType("Amazon River");
	rmSetSeaType("Amazon River Basin");
 	rmSetBaseTerrainMix("amazon grass");
	rmSetMapType("amazonia");
	rmSetMapType("tropical");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
   rmSetLightingSet("amazon");

   // Init map.
   rmTerrainInitialize("water");

	chooseMercs();

	// Make it rain
   rmSetGlobalRain( 0.7 );
   
//			rmPaintAreaTerrainByHeight(elevID, "Amazon\ground1_am", 11, 14, 1);
//		rmPaintAreaTerrainByHeight(elevID, "Amazon\ground2_am", 10, 11, 1);
//		rmPaintAreaTerrainByHeight(elevID, "Amazon\ground3_am", 8, 10);

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("classCliff");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   int classIsland=rmDefineClass("island");
   int classTeamIsland=rmDefineClass("teamIsland");


   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
      int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.43), rmDegreesToRadians(0), rmDegreesToRadians(360));

  // int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
//   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 24.0);

   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.55, 0.55, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.45, 0.45, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.45, 0.55, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.55, 0.45, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
   int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 20.0);
   int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 10.0);
   int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 20);
   int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-180, rmGetMapXSize()-40, 0, 0, 0);
   int islandConstraint=rmCreateClassDistanceConstraint("islands avoid each other", classIsland, 55.0);
   int islandConstraintShort=rmCreateClassDistanceConstraint("islands avoid each other short", classIsland, 10.0);
//   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
 
    // Nature avoidance
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 30.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);
    int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
  int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);
   
   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int mediumShortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("mediumshort avoid impassable land", "Land", false, 10.0);
   int mediumAvoidImpassableLand=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 12.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
   // Constraint to avoid water.
   int avoidWater2 = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 2.0);
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
   int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 10.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water large", "Land", false, 20.0);
   int ferryOnShore=rmCreateTerrainMaxDistanceConstraint("ferry v. water", "water", true, 12.0);

   // Unit avoidance
   int avoidImportantItem=rmCreateClassDistanceConstraint("avoid natives, secrets", rmClassID("importantItem"), 30.0);
   int farAvoidImportantItem=rmCreateClassDistanceConstraint("secrets avoid each other by a lot", rmClassID("importantItem"), 50.0);
   int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 25.0);
   int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 40.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int avoidCliff=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);

     // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 15.0);

   // -------------Define objects
   // These objects are all defined so they can be placed later

 	// Place Town Centers
		rmSetTeamSpacingModifier(0.6);

		float teamStartLoc = rmRandFloat(0.0, 1.0);
		if(cNumberTeams > 2)
		{
			rmSetPlacementSection(0.10, 0.90);
			rmSetTeamSpacingModifier(0.75);
			rmPlacePlayersCircular(0.4, 0.4, 0);
		}
		else if (cNumberPlayers > 5)
		//players are placed much more spread on if players > 5
		{
			//team 0 starts on top
			if (teamStartLoc > 0.5)
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.0, 0.30);
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.45, 0.75); 
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
			}
			else
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.45, 0.75);
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.0, 0.30); 
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
			}
		}
		else
		{
			//team 0 starts on top
			if (teamStartLoc > 0.5)
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.10, 0.20);
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.60, 0.70); 
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
			}
			else
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.60, 0.70);
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.10, 0.20); 
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
			}
		}

 
    // wood resources
   int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, "treeamazon", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomTreeID, avoidResource);
   rmAddObjectDefConstraint(randomTreeID, shortAvoidImpassableLand);

	// -------------Done defining objects

  // Text
   rmSetStatusText("",0.10);


   //  Rivers
/*
   // Build the main river which defines the map more-or-less.
	int amazonRiver = rmRiverCreate(-1, "Amazon River", 5, 18, 10, 10);
	if (cNumberNonGaiaPlayers >2)
		amazonRiver = rmRiverCreate(-1, "Amazon River", 6, 30, 14, 17);
	if (cNumberNonGaiaPlayers >4)
		amazonRiver = rmRiverCreate(-1, "Amazon River", 6, 30, 16, 20);
	if (cNumberNonGaiaPlayers >6)
		amazonRiver = rmRiverCreate(-1, "Amazon River", 6, 30, 18, 22);
   rmRiverSetConnections(amazonRiver, 0.0, 1.0, 1.0, 0.0);
   //rmRiverSetShallowRadius(amazonRiver, 10);
   //rmRiverAddShallow(amazonRiver, rmRandFloat(0.2, 0.2));
   //rmRiverAddShallow(amazonRiver, rmRandFloat(0.8, 0.8));
   rmRiverSetBankNoiseParams(amazonRiver, 0.07, 2, 1.5, 20.0, 0.667, 2.0);
   rmRiverBuild(amazonRiver);
   rmRiverReveal(amazonRiver, 2); 

 */


   int northIslandID = rmCreateArea("north island");
   int areaSizerNum = rmRandInt(1,10);
   float areaSizer = 0.33; 
   if (areaSizerNum > 6)
	   areaSizer = 0.38;
   rmEchoInfo("Island size "+areaSizer);
   
   // Make areas for the main islands... kinda hacky I guess, but it works.
   // Build an invisible north island area.
   
   //rmSetAreaLocation(northIslandID, 0.75, 0.75);
   rmSetAreaLocation(northIslandID, 1, 1);
   rmSetAreaMix(northIslandID, "caribbean grass");
   //rmSetAreaSize(northIslandID, 0.5, 0.5);
   rmSetAreaCoherence(northIslandID, 1.0);
   //rmAddAreaConstraint(northIslandID, avoidWater4);
   //rmSetAreaSize(northIslandID, isleSize, isleSize);
	rmSetAreaSize(northIslandID, areaSizer, areaSizer);
      rmSetAreaMinBlobs(northIslandID, 10);
      rmSetAreaMaxBlobs(northIslandID, 15);
      rmSetAreaMinBlobDistance(northIslandID, 8.0);
      rmSetAreaMaxBlobDistance(northIslandID, 10.0);
      rmSetAreaCoherence(northIslandID, 0.60);
      rmSetAreaBaseHeight(northIslandID, 3.0);
      rmSetAreaSmoothDistance(northIslandID, 20);
		rmSetAreaMix(northIslandID, "amazon grass");
      rmAddAreaToClass(northIslandID, classIsland);
      rmAddAreaConstraint(northIslandID, islandConstraint);
      rmSetAreaObeyWorldCircleConstraint(northIslandID, false);
      rmSetAreaElevationType(northIslandID, cElevTurbulence);
      rmSetAreaElevationVariation(northIslandID, 3.0);
      rmSetAreaElevationMinFrequency(northIslandID, 0.09);
      rmSetAreaElevationOctaves(northIslandID, 3);
      rmSetAreaElevationPersistence(northIslandID, 0.2);
		rmSetAreaElevationNoiseBias(northIslandID, 1);
      rmSetAreaWarnFailure(northIslandID, false);
   //rmBuildArea(northIslandID);

   // Build an invisible south island area.
   
  int southIslandID = rmCreateArea("south island");
   //rmSetAreaLocation(southIslandID, 0.25, 0.25);
   rmSetAreaLocation(southIslandID, 0, 0);
   rmSetAreaMix(southIslandID, "caribbean grass");
  // rmSetAreaSize(southIslandID, 0.5, 0.5);
   rmSetAreaCoherence(southIslandID, 1.0);
   //rmAddAreaConstraint(southIslandID, avoidWater4);
   rmSetAreaSize(southIslandID, areaSizer, areaSizer);
      rmSetAreaMinBlobs(southIslandID, 10);
      rmSetAreaMaxBlobs(southIslandID, 15);
      rmSetAreaMinBlobDistance(southIslandID, 8.0);
      rmSetAreaMaxBlobDistance(southIslandID, 10.0);
      rmSetAreaCoherence(southIslandID, 0.60);
      rmSetAreaBaseHeight(southIslandID, 3.0);
      rmSetAreaSmoothDistance(southIslandID, 20);
		rmSetAreaMix(southIslandID, "amazon grass");
      rmAddAreaToClass(southIslandID, classIsland);
      rmAddAreaConstraint(southIslandID, islandConstraint);
      rmSetAreaObeyWorldCircleConstraint(southIslandID, false);
      rmSetAreaElevationType(southIslandID, cElevTurbulence);
      rmSetAreaElevationVariation(southIslandID, 3.0);
      rmSetAreaElevationMinFrequency(southIslandID, 0.09);
      rmSetAreaElevationOctaves(southIslandID, 3);
      rmSetAreaElevationPersistence(southIslandID, 0.2);
		rmSetAreaElevationNoiseBias(southIslandID, 1);
      rmSetAreaWarnFailure(southIslandID, false);
   //rmBuildArea(southIslandID);

   rmBuildAllAreas();

   // add island constraints
   int northIslandConstraint=rmCreateAreaConstraint("north Island", northIslandID);
   int southIslandConstraint=rmCreateAreaConstraint("south Island", southIslandID);
/*
   // Tributaries
   //northern tributaries
   int tribID1 = -1;
   int tribID2 = -1;
   //southern tributaries
   int tribID3 = -1; 
   int tribID4 = -1; 

   float RiverPlaceN = rmRandFloat(0,1);
   float RiverPlaceS = rmRandFloat(0,1);

*/


   // Text
   rmSetStatusText("",0.20);



	// Player placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 8.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);



   // Text
   rmSetStatusText("",0.30);



   // Placement order
   // Trade route -> River (none on this map) -> Natives -> Secrets -> Cliffs -> Nuggets

   // Text
   rmSetStatusText("",0.40);


	int tradeRouteNum = rmRandInt(1,5);
	if (tradeRouteNum > 3)
		tradeRouteNum = 2; //this makes the dual trade route option come up more often


	// Trade Route on the north side of the river
	int tradeRouteID = rmCreateTradeRoute();
	int tradeRoute2ID = rmCreateTradeRoute();
	int tradeRoute3ID = rmCreateTradeRoute();
	int tradeRoute4ID = rmCreateTradeRoute();

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   // rmAddObjectDefItem(socketID, "socket", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 10.0);
   rmAddObjectDefConstraint(socketID, avoidImpassableLand);
   rmAddObjectDefConstraint(socketID, avoidCliff);
   rmAddObjectDefConstraint(socketID, playerEdgeConstraint);
   

	if (tradeRouteNum == 1)
	{
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

		rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.4);
	   rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.4, 1.0, 8, 10);

		bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
		if(placedTradeRoute == false)
			rmEchoError("Failed to place trade route");	
		
		// add the meeting sockets along the trade route.
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.83);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else if (tradeRouteNum == 2)
	{
		rmAddTradeRouteWaypoint(tradeRoute2ID, 1.0, 0.4);
	   rmAddRandomTradeRouteWaypoints(tradeRoute2ID, 0.4, 1.0, 8, 10);

		bool placedTradeRoute2 = rmBuildTradeRoute(tradeRoute2ID, "dirt");
		if(placedTradeRoute2 == false)
			rmEchoError("Failed to place trade route");
		
      rmSetObjectDefTradeRouteID(socketID, tradeRoute2ID);
		// add the meeting sockets along the trade route.
		vector socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.15);
		rmPlaceObjectDefAtPoint(socketID, 0, socket2Loc);

	   socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socket2Loc);

	   socket2Loc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.83);
		rmPlaceObjectDefAtPoint(socketID, 0, socket2Loc);
	
		// Route 2
		rmAddTradeRouteWaypoint(tradeRoute3ID, 0.6, 0.0);
	   rmAddRandomTradeRouteWaypoints(tradeRoute3ID, 0.0, 0.6, 8, 10);
	
		bool placedTradeRoute3 = rmBuildTradeRoute(tradeRoute3ID, "dirt");
		if(placedTradeRoute3 == false)
			rmEchoError("Failed to place trade route");
		
      rmSetObjectDefTradeRouteID(socketID, tradeRoute3ID);
		// add the meeting sockets along the trade route.
		vector socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.15);
		rmPlaceObjectDefAtPoint(socketID, 0, socket3Loc);

	   socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socket3Loc);

	   socket3Loc = rmGetTradeRouteWayPoint(tradeRoute3ID, 0.83);
		rmPlaceObjectDefAtPoint(socketID, 0, socket3Loc);
	
	}
	else
	{
	
		// South Route 3
		rmAddTradeRouteWaypoint(tradeRoute4ID, 0.6, 0.0);
	   rmAddRandomTradeRouteWaypoints(tradeRoute4ID, 0.0, 0.6, 8, 10);
	
		bool placedTradeRoute4 = rmBuildTradeRoute(tradeRoute4ID, "dirt");
		if(placedTradeRoute4 == false)
			rmEchoError("Failed to place trade route");
		
      rmSetObjectDefTradeRouteID(socketID, tradeRoute4ID);
		// add the meeting sockets along the trade route.
		vector socket4Loc = rmGetTradeRouteWayPoint(tradeRoute4ID, 0.15);
		rmPlaceObjectDefAtPoint(socketID, 0, socket4Loc);

	   socket4Loc = rmGetTradeRouteWayPoint(tradeRoute4ID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socket4Loc);

	   socket4Loc = rmGetTradeRouteWayPoint(tradeRoute4ID, 0.83);
		rmPlaceObjectDefAtPoint(socketID, 0, socket4Loc);
	
	}


   // Text
   rmSetStatusText("",0.50);


	// PLAYER STARTING RESOURCES

   rmClearClosestPointConstraints();
   int TCfloat = -1;
   if (cNumberTeams == 2)
	   TCfloat = 50;
   else 
	   TCfloat = 85;
    

	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
		{
			rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
		}
	else{
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);

		int playerMarketID = rmCreateObjectDef("player market");
		rmAddObjectDefItem(playerMarketID, "market", 1, 0);
		rmAddObjectDefConstraint(playerMarketID, avoidTradeRoute);
		rmSetObjectDefMinDistance(playerMarketID, 10.0);
		rmSetObjectDefMaxDistance(playerMarketID, 18.0);
		rmAddObjectDefConstraint(playerMarketID, playerEdgeConstraint);
		rmAddObjectDefConstraint(playerMarketID, mediumShortAvoidImpassableLand);
    
    int playerAsianMarketID = rmCreateObjectDef("player asian market");
		rmAddObjectDefItem(playerAsianMarketID , "ypTradeMarketAsian", 1, 0);
		rmAddObjectDefConstraint(playerAsianMarketID , avoidTradeRoute);
		rmSetObjectDefMinDistance(playerAsianMarketID , 10.0);
		rmSetObjectDefMaxDistance(playerAsianMarketID , 18.0);
		rmAddObjectDefConstraint(playerAsianMarketID , playerEdgeConstraint);
		rmAddObjectDefConstraint(playerAsianMarketID , mediumShortAvoidImpassableLand);
  }
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, TCfloat);

	rmAddObjectDefConstraint(TCID, avoidTradeRouteFar);
	rmAddObjectDefConstraint(TCID, avoidTownCenter);
	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
	rmAddObjectDefConstraint(TCID, mediumShortAvoidImpassableLand);
	//rmPlaceObjectDefPerPlayer(TCID, true);

	//WATER HC ARRIVAL POINT

   int waterFlagID = 0;
   for(i=1; <cNumberPlayers)
    {
        waterFlagID=rmCreateObjectDef("HC water flag "+i);
        rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
	}  

	int playerSilverID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerSilverID, avoidTownCenter);
	rmSetObjectDefMinDistance(playerSilverID, 10.0);
	rmSetObjectDefMaxDistance(playerSilverID, 25.0);
  rmAddObjectDefConstraint(playerSilverID, mediumAvoidImpassableLand);

	int playerDeerID=rmCreateObjectDef("player turkey");
  rmAddObjectDefItem(playerDeerID, "turkey", rmRandInt(5,8), 10.0);
  rmSetObjectDefMinDistance(playerDeerID, 10);
  rmSetObjectDefMaxDistance(playerDeerID, 16);
	rmAddObjectDefConstraint(playerDeerID, avoidAll);
  rmAddObjectDefConstraint(playerDeerID, avoidImpassableLand);
  rmSetObjectDefCreateHerd(playerDeerID, true);

	int playerTreeID=rmCreateObjectDef("player trees");
  rmAddObjectDefItem(playerTreeID, "TreeAmazon", rmRandInt(7,10), 2.0);
  rmSetObjectDefMinDistance(playerTreeID, 16);
  rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefConstraint(playerTreeID, avoidAll);
  rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);

	for(i=1; <cNumberPlayers) {
    rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

    if (rmGetNomadStart() == false)
    {
      if(ypIsAsian(i)) {
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
        rmPlaceObjectDefAtLoc(playerAsianMarketID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      }
      
      else if(rmGetPlayerCiv(i) ==  rmGetCivID("Chinese") || rmGetPlayerCiv(i) ==  rmGetCivID("Indians")) {
        rmPlaceObjectDefAtLoc(playerAsianMarketID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      }
      
      else 
        rmPlaceObjectDefAtLoc(playerMarketID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    }
    rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

    vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
    rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
	
  }
  
  rmClearClosestPointConstraints();

  // Tupis in the south. Zapotec in the north.
  float NativeVillageLoc = rmRandFloat(0,1);

   if (subCiv0 == rmGetCivID("Tupi"))
   {  
      int tupiVillageID = -1;
      int tupiVillageType = rmRandInt(1,5);
      tupiVillageID = rmCreateGrouping("tupi village", "native tupi village "+tupiVillageType);
      rmSetGroupingMinDistance(tupiVillageID, 0.0);
      rmSetGroupingMaxDistance(tupiVillageID, rmXFractionToMeters(0.50));
      rmAddGroupingConstraint(tupiVillageID, longAvoidImpassableLand);
      rmAddGroupingToClass(tupiVillageID, rmClassID("natives"));
      rmAddGroupingToClass(tupiVillageID, rmClassID("importantItem"));
      rmAddGroupingConstraint(tupiVillageID, avoidImportantItem);
	  rmAddGroupingConstraint(tupiVillageID, avoidTownCenter);
//      rmAddGroupingConstraint(tupiVillageID, avoidTradeRoute);
		if (tradeRouteNum == 1)
		{	rmAddGroupingConstraint(tupiVillageID, southIslandConstraint);
			rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.25, 0.25);
		}
		else if (tradeRouteNum == 2)
		{	rmAddGroupingConstraint(tupiVillageID, southIslandConstraint);
			rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.15, 0.15);
		}
		else if (tradeRouteNum == 3)
		{	rmAddGroupingConstraint(tupiVillageID, northIslandConstraint);
			rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.85, 0.65);
		}
   }

   if (subCiv1 == rmGetCivID("Zapotec"))
   {  
      int zapotecVillageID = -1;
      int zapotecVillageType = rmRandInt(1,5);
      zapotecVillageID = rmCreateGrouping("Zapotec village", "native zapotec village "+zapotecVillageType);
      rmSetGroupingMinDistance(zapotecVillageID, 0.0);
      rmSetGroupingMaxDistance(zapotecVillageID, rmXFractionToMeters(0.50));
      rmAddGroupingConstraint(zapotecVillageID, longAvoidImpassableLand);
      rmAddGroupingToClass(zapotecVillageID, rmClassID("natives"));
      rmAddGroupingToClass(zapotecVillageID, rmClassID("importantItem"));
      rmAddGroupingConstraint(zapotecVillageID, avoidImportantItem);
      rmAddGroupingConstraint(zapotecVillageID, avoidTradeRoute);
	  rmAddGroupingConstraint(zapotecVillageID, avoidTownCenter);
		if (tradeRouteNum == 1)
		{
			rmAddGroupingConstraint(zapotecVillageID, southIslandConstraint);
	      rmPlaceGroupingAtLoc(zapotecVillageID, 0, 0.25, 0.5);
		}
		else if (tradeRouteNum == 2)
		{
			rmAddGroupingConstraint(zapotecVillageID, northIslandConstraint);
	      rmPlaceGroupingAtLoc(zapotecVillageID, 0, 0.85, 0.85);
		}
		else if (tradeRouteNum == 3)
		{	rmAddGroupingConstraint(zapotecVillageID, northIslandConstraint);
			rmPlaceGroupingAtLoc(zapotecVillageID, 0, 0.85, 0.85);
		}
   }

   if (subCiv2 == rmGetCivID("Tupi"))
   {   
      int tupi2VillageID = -1;
      int tupi2VillageType = rmRandInt(1,5);
      tupi2VillageID = rmCreateGrouping("Tupi2 village", "native tupi village "+tupi2VillageType);
      rmSetGroupingMaxDistance(tupi2VillageID, rmXFractionToMeters(0.90));
      rmAddGroupingConstraint(tupi2VillageID, longAvoidImpassableLand);
      //rmAddGroupingToClass(tupi2VillageID, rmClassID("natives"));
      //rmAddGroupingToClass(tupi2VillageID, rmClassID("importantItem"));
      //rmAddGroupingConstraint(tupi2VillageID, avoidImportantItem);
      rmAddGroupingConstraint(tupi2VillageID, avoidTradeRoute);
	  rmAddGroupingConstraint(tupi2VillageID, avoidTownCenter);
	  if (tradeRouteNum == 1)
	  {	  rmAddGroupingConstraint(tupi2VillageID, southIslandConstraint);
		  rmPlaceGroupingAtLoc(tupi2VillageID, 0, 0.75, 0.30);
	  }
	  else if (tradeRouteNum == 3)
	  {	  rmAddGroupingConstraint(tupi2VillageID, northIslandConstraint);
		  rmPlaceGroupingAtLoc(tupi2VillageID, 0, 0.75, 0.75);
	  }
   }

    else if(subCiv2 == rmGetCivID("Zapotec"))
   {   
      int Zapotec2VillageID = -1;
      int Zapotec2VillageType = rmRandInt(1,5);
      Zapotec2VillageID = rmCreateGrouping("Zapotec2 village", "native Zapotec village "+Zapotec2VillageType);
      rmSetGroupingMinDistance(Zapotec2VillageID, 0.0);
      rmSetGroupingMaxDistance(Zapotec2VillageID, 80.0);
      rmAddGroupingConstraint(Zapotec2VillageID, avoidImpassableLand);
      rmAddGroupingToClass(Zapotec2VillageID, rmClassID("natives"));
      rmAddGroupingToClass(Zapotec2VillageID, rmClassID("importantItem"));
      rmAddGroupingConstraint(Zapotec2VillageID, avoidImportantItem);
      //rmAddGroupingConstraint(Zapotec2VillageID, avoidTradeRoute);
	  rmAddGroupingConstraint(Zapotec2VillageID, avoidTownCenter);
		if (tradeRouteNum == 1)
		{	rmAddGroupingConstraint(Zapotec2VillageID, southIslandConstraint);
			rmPlaceGroupingAtLoc(Zapotec2VillageID, 0, 0.75, 0.30);
		}
		else if (tradeRouteNum == 3)
		{	rmAddGroupingConstraint(Zapotec2VillageID, northIslandConstraint);
			rmPlaceGroupingAtLoc(Zapotec2VillageID, 0, 0.85, 0.65);
		}

   }


   // Text
   rmSetStatusText("",0.50);
   int numTries = -1;
   int failCount = -1;

   // Text
   rmSetStatusText("",0.60);


   // Define and place Nuggets on both sides of the river

	   int southNugget1= rmCreateObjectDef("south nugget easy"); 
	   rmAddObjectDefItem(southNugget1, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(1, 1);
	   rmAddObjectDefConstraint(southNugget1, avoidImpassableLand);
  	   rmAddObjectDefConstraint(southNugget1, avoidNugget);
  	   rmAddObjectDefConstraint(southNugget1, avoidTradeRoute);
  	   rmAddObjectDefConstraint(southNugget1, avoidAll);
	   rmAddObjectDefConstraint(southNugget1, avoidWater20);
	   rmAddObjectDefConstraint(southNugget1, southIslandConstraint);
	   rmAddObjectDefConstraint(southNugget1, playerEdgeConstraint);
	   rmPlaceObjectDefPerPlayer(southNugget1, false, 1);

	   int northNugget1= rmCreateObjectDef("north nugget easy"); 
	   rmAddObjectDefItem(northNugget1, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(1, 1);
	   rmAddObjectDefConstraint(northNugget1, avoidImpassableLand);
  	   rmAddObjectDefConstraint(northNugget1, avoidNugget);
  	   rmAddObjectDefConstraint(northNugget1, avoidTradeRoute);
  	   rmAddObjectDefConstraint(northNugget1, avoidAll);
	   rmAddObjectDefConstraint(northNugget1, avoidWater20);
	   rmAddObjectDefConstraint(northNugget1, northIslandConstraint);
	   rmAddObjectDefConstraint(northNugget1, playerEdgeConstraint);
	   rmPlaceObjectDefPerPlayer(northNugget1, false, 1);

	   int southNugget2= rmCreateObjectDef("south nugget medium"); 
	   rmAddObjectDefItem(southNugget2, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(2, 2);
	   rmSetObjectDefMinDistance(southNugget2, 0.0);
	   rmSetObjectDefMaxDistance(southNugget2, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(southNugget2, avoidImpassableLand);
  	   rmAddObjectDefConstraint(southNugget2, avoidNugget);
  	   rmAddObjectDefConstraint(southNugget2, avoidTownCenter);
  	   rmAddObjectDefConstraint(southNugget2, avoidTradeRoute);
  	   rmAddObjectDefConstraint(southNugget2, avoidAll);
  	   rmAddObjectDefConstraint(southNugget2, avoidWater20);
	   rmAddObjectDefConstraint(southNugget2, southIslandConstraint);
	   rmAddObjectDefConstraint(southNugget2, playerEdgeConstraint);
	   rmPlaceObjectDefPerPlayer(southNugget2, false, 1);

	   int northNugget2= rmCreateObjectDef("north nugget medium"); 
	   rmAddObjectDefItem(northNugget2, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(2, 2);
	   rmSetObjectDefMinDistance(northNugget2, 0.0);
	   rmSetObjectDefMaxDistance(northNugget2, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(northNugget2, avoidImpassableLand);
  	   rmAddObjectDefConstraint(northNugget2, avoidNugget);
  	   rmAddObjectDefConstraint(northNugget2, avoidTownCenter);
  	   rmAddObjectDefConstraint(northNugget2, avoidTradeRoute);
  	   rmAddObjectDefConstraint(northNugget2, avoidAll);
  	   rmAddObjectDefConstraint(northNugget2, avoidWater20);
	   rmAddObjectDefConstraint(northNugget2, northIslandConstraint);
	   rmAddObjectDefConstraint(northNugget2, playerEdgeConstraint);
	   rmPlaceObjectDefPerPlayer(northNugget2, false, 1);

	   int southNugget3= rmCreateObjectDef("south nugget hard"); 
	   rmAddObjectDefItem(southNugget3, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(3, 3);
	   rmSetObjectDefMinDistance(southNugget3, 0.0);
	   rmSetObjectDefMaxDistance(southNugget3, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(southNugget3, avoidImpassableLand);
  	   rmAddObjectDefConstraint(southNugget3, avoidNugget);
  	   rmAddObjectDefConstraint(southNugget3, avoidTownCenter);
  	   rmAddObjectDefConstraint(southNugget3, avoidTradeRoute);
  	   rmAddObjectDefConstraint(southNugget3, avoidAll);
  	   rmAddObjectDefConstraint(southNugget3, avoidWater20);
	   rmAddObjectDefConstraint(southNugget3, southIslandConstraint);
	   rmAddObjectDefConstraint(southNugget3, playerEdgeConstraint);
	   //rmPlaceObjectDefPerPlayer(southNugget3, false, 1);
	   rmPlaceObjectDefAtLoc(southNugget3, 0, 0.5, 0.5, 1);

	   int northNugget3= rmCreateObjectDef("north nugget hard"); 
	   rmAddObjectDefItem(northNugget3, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(3, 3);
	   rmSetObjectDefMinDistance(northNugget3, 0.0);
	   rmSetObjectDefMaxDistance(northNugget3, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(northNugget3, avoidImpassableLand);
  	   rmAddObjectDefConstraint(northNugget3, avoidNugget);
  	   rmAddObjectDefConstraint(northNugget3, avoidTownCenter);
  	   rmAddObjectDefConstraint(northNugget3, avoidTradeRoute);
  	   rmAddObjectDefConstraint(northNugget3, avoidAll);
  	   rmAddObjectDefConstraint(northNugget3, avoidWater20);
	   rmAddObjectDefConstraint(northNugget3, northIslandConstraint);
	   rmAddObjectDefConstraint(northNugget3, playerEdgeConstraint);
	   //rmPlaceObjectDefPerPlayer(northNugget3, false, 1);
	   rmPlaceObjectDefAtLoc(northNugget3, 0, 0.5, 0.5, 1);

	   //only try to place these 25% of the time
	   int nuggetNutsNum = rmRandInt(1,4);
	   if (nuggetNutsNum == 1)
	   {
	   int southNugget4= rmCreateObjectDef("south nugget nuts"); 
	   rmAddObjectDefItem(southNugget4, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(4, 4);
	   rmSetObjectDefMinDistance(southNugget4, 0.0);
	   rmSetObjectDefMaxDistance(southNugget4, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(southNugget4, avoidImpassableLand);
  	   rmAddObjectDefConstraint(southNugget4, avoidNugget);
  	   rmAddObjectDefConstraint(southNugget4, avoidTownCenter);
  	   rmAddObjectDefConstraint(southNugget4, avoidTradeRoute);
  	   rmAddObjectDefConstraint(southNugget4, avoidAll);
  	   rmAddObjectDefConstraint(southNugget4, avoidWater20);
	   rmAddObjectDefConstraint(southNugget4, southIslandConstraint);
	   rmAddObjectDefConstraint(southNugget4, playerEdgeConstraint);
	   //rmPlaceObjectDefPerPlayer(southNugget4, false, 1);
	   rmPlaceObjectDefAtLoc(southNugget4, 0, 0.5, 0.5, 1);

	   int northNugget4= rmCreateObjectDef("north nugget nuts"); 
	   rmAddObjectDefItem(northNugget4, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(4, 4);
	   rmSetObjectDefMinDistance(northNugget4, 0.0);
	   rmSetObjectDefMaxDistance(northNugget4, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(northNugget4, avoidImpassableLand);
  	   rmAddObjectDefConstraint(northNugget4, avoidNugget);
  	   rmAddObjectDefConstraint(northNugget4, avoidTownCenter);
  	   rmAddObjectDefConstraint(northNugget4, avoidTradeRoute);
  	   rmAddObjectDefConstraint(northNugget4, avoidAll);
  	   rmAddObjectDefConstraint(northNugget4, avoidWater20);
	   rmAddObjectDefConstraint(northNugget4, northIslandConstraint);
	   rmAddObjectDefConstraint(northNugget4, playerEdgeConstraint);
	   //rmPlaceObjectDefPerPlayer(northNugget4, false, 1);
	   rmPlaceObjectDefAtLoc(northNugget4, 0, 0.5, 0.5, 1);
	   }

   // Text
   rmSetStatusText("",0.70);
 
	int silverType = -1;
	int silverID = -1;
	int silverCount = (cNumberNonGaiaPlayers*2.75);
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount)
	{
	  int southSilverID = rmCreateObjectDef("south silver "+i);
	  rmAddObjectDefItem(southSilverID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(southSilverID, 0.0);
      rmSetObjectDefMaxDistance(southSilverID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(southSilverID, avoidCoin);
      rmAddObjectDefConstraint(southSilverID, avoidAll);
      rmAddObjectDefConstraint(southSilverID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(southSilverID, avoidTradeRoute);
      rmAddObjectDefConstraint(southSilverID, mediumAvoidImpassableLand);
      rmAddObjectDefConstraint(southSilverID, southIslandConstraint);
	  rmPlaceObjectDefAtLoc(southSilverID, 0, 0.5, 0.5);
   }

	for(i=0; < silverCount)
	{
	  silverID = rmCreateObjectDef("north silver "+i);
	  rmAddObjectDefItem(silverID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(silverID, 0.0);
      rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(silverID, avoidCoin);
      rmAddObjectDefConstraint(silverID, avoidAll);
      rmAddObjectDefConstraint(silverID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(silverID, avoidTradeRoute);
      rmAddObjectDefConstraint(silverID, mediumAvoidImpassableLand);
      rmAddObjectDefConstraint(silverID, northIslandConstraint);
	  rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   } 

   // Define and place Forests
   //ABC NEED TO BE SCATTERED BETWEEN THE TWO RIVERBANKS
   int forestTreeID = 0;
   numTries=8*cNumberNonGaiaPlayers;
   failCount=0;
   for (i=0; <numTries)
      {   
         int forest=rmCreateArea("forest"+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
         rmSetAreaForestType(forest, "amazon rain forest");
         rmSetAreaForestDensity(forest, 0.8);
         rmSetAreaForestClumpiness(forest, 0.6);
         rmSetAreaForestUnderbrush(forest, 0.0);
         rmSetAreaMinBlobs(forest, 6);
         rmSetAreaMaxBlobs(forest, 15);
         rmSetAreaMinBlobDistance(forest, 16.0);
         rmSetAreaMaxBlobDistance(forest, 25.0);
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
	      rmAddAreaToClass(forest, rmClassID("classForest"));
         rmAddAreaConstraint(forest, forestConstraint);
         rmAddAreaConstraint(forest, forestObjConstraint);
         rmAddAreaConstraint(forest, shortAvoidImpassableLand); 
         rmAddAreaConstraint(forest, avoidTradeRoute);
		 rmAddAreaConstraint(forest, avoidTownCenter);

         if(rmBuildArea(forest)==false)
         {
            // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==6)
               break;
         }
         else
            failCount=0; 
      } 
 
  // Text
   rmSetStatusText("",0.80);

	// Place other objects that were defined earlier
  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,3);
    float xLoc = 0.0;
    
    if(randLoc == 1)
      xLoc = .25;
    
    else if (randLoc == 2)
      xLoc = .5;
    
    else
      xLoc = .75;
    
    ypKingsHillLandfill(xLoc, (1.0-xLoc), .0075, 4.5, "amazon grass", islandConstraintShort);
    ypKingsHillPlacer(xLoc, (1.0-xLoc), 0.075, avoidWater2);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("YLOC = "+(1.0-xLoc));
  }


 // Resources that can be placed after forests
  
  //Place fish
  int fishID=rmCreateObjectDef("fish");
  rmAddObjectDefItem(fishID, "FishBass", 3, 9.0);
  rmSetObjectDefMinDistance(fishID, 0.0);
  rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(fishID, fishVsFishID);
  rmAddObjectDefConstraint(fishID, fishLand);
  rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 11*cNumberNonGaiaPlayers);

	int tapirCount = rmRandInt(3,6);
	int capyCount = rmRandInt(9,12);

   int tapirNID=rmCreateObjectDef("north tapir crash");
   rmAddObjectDefItem(tapirNID, "tapir", tapirCount, 2.0);
   rmSetObjectDefMinDistance(tapirNID, 0.0);
   rmSetObjectDefMaxDistance(tapirNID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(tapirNID, avoidImpassableLand);
   rmAddObjectDefConstraint(tapirNID, northIslandConstraint);
   rmSetObjectDefCreateHerd(tapirNID, true);
   rmPlaceObjectDefAtLoc(tapirNID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int tapirSID=rmCreateObjectDef("south tapir crash");
   rmAddObjectDefItem(tapirSID, "tapir", tapirCount, 2.0);
   rmSetObjectDefMinDistance(tapirSID, 0.0);
   rmSetObjectDefMaxDistance(tapirSID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(tapirSID, avoidImpassableLand);
   rmAddObjectDefConstraint(tapirSID, southIslandConstraint);
   rmSetObjectDefCreateHerd(tapirSID, true);
   rmPlaceObjectDefAtLoc(tapirSID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	// Text
   rmSetStatusText("",0.90);

	int capybaraNID=rmCreateObjectDef("north capybara crash");
   rmAddObjectDefItem(capybaraNID, "capybara", capyCount, 2.0);
   rmSetObjectDefMinDistance(capybaraNID, 0.0);
   rmSetObjectDefMaxDistance(capybaraNID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(capybaraNID, avoidImpassableLand);
   rmAddObjectDefConstraint(capybaraNID, northIslandConstraint);
   rmSetObjectDefCreateHerd(capybaraNID, true);
   rmPlaceObjectDefAtLoc(capybaraNID, 0, 0.5, 0.5, (1.75*cNumberNonGaiaPlayers));

	int capybaraSID=rmCreateObjectDef("south capybara crash");
   rmAddObjectDefItem(capybaraSID, "capybara", capyCount, 2.0);
   rmSetObjectDefMinDistance(capybaraSID, 0.0);
   rmSetObjectDefMaxDistance(capybaraSID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(capybaraSID, avoidImpassableLand);
   rmAddObjectDefConstraint(capybaraSID, southIslandConstraint);
   rmSetObjectDefCreateHerd(capybaraSID, true);
   rmPlaceObjectDefAtLoc(capybaraSID, 0, 0.5, 0.5, (1.85*cNumberNonGaiaPlayers));

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
