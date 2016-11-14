// YUKON
// November 2003
// November 06 - YP update

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;

	// Only 2 natives this map
	int whichNative=rmRandInt(1,2);
	if ( whichNative == 1 )
	{
		if (rmAllocateSubCivs(2) == true)
		{
			subCiv0=rmGetCivID("Cree");
			if (subCiv0 >= 0)
				rmSetSubCiv(0, "Cree");

			subCiv1=rmGetCivID("Cree");
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "Cree");
		}
	}
	else
	{
		if (rmAllocateSubCivs(2) == true)
		{
			subCiv0=rmGetCivID("Nootka");
			if (subCiv0 >= 0)
				rmSetSubCiv(0, "Nootka");

			subCiv1=rmGetCivID("Nootka");
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "Nootka");
		}
	}

	// Which map - four possible variations (excluding which end the players start on, which is a separate thing)
	// int whichMap=rmRandInt(1,4);
	int whichMap=2;

   // Picks the map size
	if (cNumberNonGaiaPlayers < 5)
		int playerTiles=10000;
	else
		playerTiles=14000;


	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Picks a default water height
   rmSetSeaLevel(4.5);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Picks default terrain and water
	//	rmAddMapTerrainByHeightInfo("yukon\ground2_yuk", 6.0, 9.0, 1.0);
	//	rmAddMapTerrainByHeightInfo("yukon\ground3_yuk", 9.0, 16.0);
   rmSetSeaType("Yukon River");
	rmSetBaseTerrainMix("yukon snow");
   rmTerrainInitialize("yukon\ground1_yuk", 6);
   rmSetLightingSet("yukon");
	rmSetMapType("yukon");
	rmSetMapType("snow");
	rmSetMapType("land");

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Choose Mercs
	chooseMercs();

	// Make it snow
   rmSetGlobalSnow( 0.7 );

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classHill");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("classMountain");
	rmDefineClass("nuggets");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
	int coinEdgeConstraint=rmCreateBoxConstraint("coin edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.02);
   int shortPlayerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 12.0);

   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

	int NWconstraint = rmCreateBoxConstraint("stay in NW portion", 0, 0.5, 1, 1);
	int SEconstraint = rmCreateBoxConstraint("stay in SE portion", 0, 0, 1, 0.5);
	int NEconstraint = rmCreateBoxConstraint("stay in NE portion", 0.5, 0, 1, 1);
	int SWconstraint = rmCreateBoxConstraint("stay in SW portion", 0, 0.0, 0.5, 1);
	int extremeSEconstraint = rmCreateBoxConstraint("stay deep into SE portion", 0, 0, 1, 0.4);
   
	// Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 20.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
 
   // Nature avoidance
   // int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   // int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int northForestConstraint=rmCreateClassDistanceConstraint("n forest vs. forest", rmClassID("classForest"), 8.0);
   int southForestConstraint=rmCreateClassDistanceConstraint("s forest vs. forest", rmClassID("classForest"), 10.0);
   int avoidMuskOx=rmCreateTypeDistanceConstraint("muskOx avoids muskOx", "MuskOx", 45.0);
   int avoidCaribou=rmCreateTypeDistanceConstraint("caribou avoids caribou", "Caribou", 50.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 20.0);

   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
   
	int coinAvoidsCoin=-1;
	if (cNumberNonGaiaPlayers < 7)
	{
		coinAvoidsCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 50.0);
	}
	else
	{
		coinAvoidsCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 40.0);
	}

   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   
   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
   int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 10.0);
   int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int mountainAvoidMountain=rmCreateClassDistanceConstraint("mountain vs. mountain", rmClassID("classMountain"), 60.0);
	int avoidMountain=rmCreateClassDistanceConstraint("avoid mountain", rmClassID("classMountain"), 10.0);
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water 4", "Land", false, 4.0);
	int avoidWater12 = rmCreateTerrainDistanceConstraint("avoid water 12", "Land", false, 12.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 20.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 60.0);
   int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other by a bit", rmClassID("importantItem"), 10.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 12.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 30.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int avoidTradeRouteNugget = rmCreateTradeRouteDistanceConstraint("trade route nugget", 7.0);
   int avoidTradeRouteForest = rmCreateTradeRouteDistanceConstraint("trade route forest", 10.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 50.0);

   // -------------Define objects
   // These objects are all defined so they can be placed later

   rmSetStatusText("",0.10);

   // *** Set up player starting locations. Circular around the outside of the map.  If WherePlayers == 1, then it's south.
   // int wherePlayers=rmRandInt(1,2);
   int wherePlayers = 1;
   if ( cNumberTeams == 2 && cNumberNonGaiaPlayers < 7 )
	{
		rmSetPlacementSection(0.3, 0.7);
		rmSetTeamSpacingModifier(0.8);
	}
   else if ( cNumberTeams == 2 )
   {
		rmSetPlacementSection(0.28, 0.72);
		rmSetTeamSpacingModifier(0.9);
   }
   else if ( cNumberNonGaiaPlayers < 7 )
   {
		rmSetPlacementSection(0.3, 0.7);
   }
   else
   {
		rmSetPlacementSection(0.22, 0.775);
   }
	rmPlacePlayersCircular(0.42, 0.42, rmDegreesToRadians(5.0));

   // Build a north area
   int northIslandID = rmCreateArea("north island");
   rmSetAreaLocation(northIslandID, 0.5, 0.75); 
   rmSetAreaWarnFailure(northIslandID, false);

	rmSetAreaElevationType(northIslandID, cElevTurbulence);
   rmSetAreaElevationVariation(northIslandID, 5.0);
   rmSetAreaBaseHeight(northIslandID, 5.0);
   rmSetAreaElevationMinFrequency(northIslandID, 0.07);
   rmSetAreaElevationOctaves(northIslandID, 4);
   rmSetAreaElevationPersistence(northIslandID, 0.5);
	rmSetAreaElevationNoiseBias(northIslandID, 1);

	//	rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
	//	rmSetMapElevationParameters(cElevTurbulence, 0.02, 4, 0.5, 8.0);

   rmSetAreaSize(northIslandID, 1.0, 1.0);
   rmSetAreaCoherence(northIslandID, 1.0);
   rmAddAreaConstraint(northIslandID, NWconstraint);
   rmSetAreaObeyWorldCircleConstraint(northIslandID, false);
   rmSetAreaTerrainType(northIslandID, "yukon\ground1_yuk");
	rmSetAreaMix(northIslandID, "yukon snow");
   rmBuildArea(northIslandID);

	//	rmPaintAreaTerrainByHeight(northIslandID, "yukon\ground2_yuk", 6, 10);
	//	rmPaintAreaTerrainByHeight(northIslandID, "yukon\ground3_yuk", 10, 16);

   // Text
   rmSetStatusText("",0.20);

   // Build a south area
   int southIslandID = rmCreateArea("south island");
   rmSetAreaLocation(southIslandID, 0.5, 0); 
   rmSetAreaWarnFailure(southIslandID, false);
	rmSetAreaElevationType(southIslandID, cElevTurbulence);
   rmSetAreaElevationVariation(southIslandID, 5.0);
   rmSetAreaBaseHeight(southIslandID, 5.0);
   rmSetAreaElevationMinFrequency(southIslandID, 0.07);
   rmSetAreaElevationOctaves(southIslandID, 4);
   rmSetAreaElevationPersistence(southIslandID, 0.5);
	rmSetAreaElevationNoiseBias(southIslandID, 1); 
   rmSetAreaSize(southIslandID, 0.15, 0.15);
   rmSetAreaCoherence(southIslandID, 0.1);
   rmAddAreaInfluenceSegment(southIslandID, 0, 0, 1, 0);
   //rmAddAreaConstraint(southIslandID, SEconstraint);
   rmSetAreaTerrainType(southIslandID, "yukon\ground6_yuk");
   rmAddAreaTerrainLayer(southIslandID, "yukon\ground4_yuk", 0, 3);
   rmAddAreaTerrainLayer(southIslandID, "yukon\ground5_yuk", 3, 6);
   rmAddAreaTerrainLayer(southIslandID, "yukon\ground6_yuk", 6, 8);
   rmSetAreaObeyWorldCircleConstraint(southIslandID, false);
	rmSetAreaMix(southIslandID, "yukon grass");
   rmBuildArea(southIslandID);
   //	rmPaintAreaTerrainByHeight(southIslandID, "yukon\ground6_yuk", 9, 16);

   // Text
   rmSetStatusText("",0.30);

	// River - a river 75% of the time - most of the time n/s, once in a while e/w
	int riverID = -1;
	if(whichMap > 1)
	{
		// DAL - always three shallows now
		if(whichMap > 2) // NS river
		{
			if ( cNumberNonGaiaPlayers < 4 )
			{
				riverID = rmRiverCreate(-1, "Yukon River", 8, 8, 6, 8);
			}
			else
			{
				riverID = rmRiverCreate(-1, "Yukon River", 12, 12, 7, 9);
			}
			rmRiverSetConnections(riverID, 0.5, 0, 0.5, 1.0);
			rmRiverSetShallowRadius(riverID, 10);
			rmRiverAddShallow(riverID, rmRandFloat(0.1, 0.2));
			rmRiverAddShallow(riverID, rmRandFloat(0.4, 0.6));
			rmRiverAddShallow(riverID, rmRandFloat(0.8, 0.9));
			rmRiverSetBankNoiseParams(riverID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
			rmRiverBuild(riverID);
		}
		else // EW river
		{
			if ( cNumberNonGaiaPlayers < 4 )
			{
				riverID = rmRiverCreate(-1, "Yukon River", 8, 8, 6, 7);
			}
			else
			{
				riverID = rmRiverCreate(-1, "Yukon River", 12, 12, 7, 9);
			}
			if ( cNumberNonGaiaPlayers < 4 )
			{
				rmRiverSetConnections(riverID, 0, 0.62, 1, 0.62);
			}
			else
			{
				rmRiverSetConnections(riverID, 0, 0.65, 1, 0.65);
			}
			rmRiverSetShallowRadius(riverID, 10);
			// Half the time, a center crossing point
			if(rmRandFloat(0,1) < 0.5)
				rmRiverAddShallow(riverID, rmRandFloat(0.5, 0.5));
			rmRiverAddShallow(riverID, rmRandFloat(0.1, 0.2));
			rmRiverAddShallow(riverID, rmRandFloat(0.8, 0.9));
			rmRiverSetBankNoiseParams(riverID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
			rmRiverBuild(riverID);
		}
	}
	// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, shortPlayerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint);
      rmAddAreaConstraint(id, avoidImpassableLand); 
      rmSetAreaLocPlayer(id, i);
		 rmSetAreaTerrainType(id, "carolina\marshflats");
		// rmSetAreaBaseHeight(id, 8.0);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();
   
	// Text
	rmSetStatusText("",0.40);

	// TRADE ROUTES
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmAddObjectDefConstraint(socketID, avoidImpassableLand);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 12.0);
	
	if(whichMap < 4) // one trade route
	{
		int tradeRouteID = rmCreateTradeRoute();
		
		rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.5);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 1, 0.5, 12, 10);

		bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
		if(placedTradeRoute == false)
			rmEchoError("Failed to place trade route");

		// add the sockets along the trade route.
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.4);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.6);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else // dual trade routes
	{
		int tradeRoute1ID = rmCreateTradeRoute();
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0.3, 0.0);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.3, 1.0, 8, 10);

		bool placedTradeRoute1 = rmBuildTradeRoute(tradeRoute1ID, "dirt");
		if(placedTradeRoute1 == false)
			rmEchoError("Failed to place trade route one");

		// add the meeting sockets along the trade route.
        rmSetObjectDefTradeRouteID(socketID, tradeRoute1ID);
		vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.1);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.9);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	
		int tradeRoute2ID = rmCreateTradeRoute();
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.7, 0.0);
		rmAddRandomTradeRouteWaypoints(tradeRoute2ID, 0.7, 1.0, 8, 10);

		bool placedTradeRoute2 = rmBuildTradeRoute(tradeRoute2ID, "dirt");
		if(placedTradeRoute2 == false)
			rmEchoError("Failed to place trade route 2");

		// add the meeting sockets along the trade route.
      rmSetObjectDefTradeRouteID(socketID, tradeRoute2ID);
		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.1);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);

		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);

		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.9);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);
	}

    //STARTING UNITS and RESOURCES DEFS
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 6.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);

	int startingTCID = rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));

	int playerGoldID=-1;
	int silverType = -1;
	int silverID = -1;

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeYukon", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 15.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartCaribouID=rmCreateObjectDef("starting caribou");
	rmAddObjectDefItem(StartCaribouID, "caribou", 6, 4.0);
	rmSetObjectDefMinDistance(StartCaribouID, 12.0);
	rmSetObjectDefMaxDistance(StartCaribouID, 12.0);
	rmSetObjectDefCreateHerd(StartCaribouID, true);
	rmAddObjectDefConstraint(StartCaribouID, avoidStartingUnitsSmall);

	int StartCaribouID2=rmCreateObjectDef("starting caribou 2");
	rmAddObjectDefItem(StartCaribouID2, "caribou", 4, 4.0);
	rmSetObjectDefMinDistance(StartCaribouID2, 25.0);
	rmSetObjectDefMaxDistance(StartCaribouID2, 30.0);
	rmSetObjectDefCreateHerd(StartCaribouID2, true);
	rmAddObjectDefConstraint(StartCaribouID2, avoidStartingUnitsSmall);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
    rmSetObjectDefMinDistance(playerNuggetID, 32.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 34.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	// rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);

	// Player placement
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
		// vector closestPoint=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
		// rmSetHomeCityGatherPoint(i, closestPoint);

		// Everyone gets one ore grouping.
		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);			
		// rmAddObjectDefToClass(playerGoldID, rmClassID("importantItem"));
		rmSetObjectDefMinDistance(playerGoldID, 16.0);
		rmSetObjectDefMaxDistance(playerGoldID, 19.0);
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(StartCaribouID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartCaribouID2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Nuggets
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

	// Text
	rmSetStatusText("",0.50);

	int creeVillageAID = -1;
	int creeVillageType = rmRandInt(1,5);
	if ( whichNative == 1 )
	{
		creeVillageAID = rmCreateGrouping("Cree village A", "native cree village "+creeVillageType);
	}
	else
	{
		creeVillageAID = rmCreateGrouping("Nootka village A", "native nootka village "+creeVillageType);
	}
	rmSetGroupingMinDistance(creeVillageAID, 0.0);
	rmSetGroupingMaxDistance(creeVillageAID, 8.0);
	// rmSetGroupingMaxDistance(creeVillageAID, rmXFractionToMeters(0.05));
	rmAddGroupingConstraint(creeVillageAID, avoidImpassableLand);
	// rmAddGroupingConstraint(creeVillageAID, playerEdgeConstraint);
	rmAddGroupingToClass(creeVillageAID, rmClassID("natives"));
	rmAddGroupingToClass(creeVillageAID, rmClassID("importantItem"));
	rmAddGroupingConstraint(creeVillageAID, avoidTradeRoute);
	if ( whichMap == 4 )
	{
		rmPlaceGroupingAtLoc(creeVillageAID, 0, 0.9, 0.5);
	}
	else 
	{
		if (wherePlayers == 1 )
		{
			rmPlaceGroupingAtLoc(creeVillageAID, 0, 0.80, 0.80);
		}
		else
		{
			rmPlaceGroupingAtLoc(creeVillageAID, 0, 0.80, 0.20);
		}
	}

	int creeVillageBID = -1;
	creeVillageType = rmRandInt(1,5);
	if ( whichNative == 1 )
	{
		creeVillageBID = rmCreateGrouping("Cree village B", "native cree village "+creeVillageType);
	}
	else
	{
		creeVillageBID = rmCreateGrouping("Nootka village B", "native nootka village "+creeVillageType);
	}
	rmSetGroupingMinDistance(creeVillageBID, 0.0);
	rmSetGroupingMaxDistance(creeVillageBID, 8.0);
	// rmSetGroupingMaxDistance(creeVillageBID, rmXFractionToMeters(0.05));
	rmAddGroupingConstraint(creeVillageBID, avoidImpassableLand);
	// rmAddGroupingConstraint(creeVillageBID, playerEdgeConstraint);
	rmAddGroupingToClass(creeVillageBID, rmClassID("natives"));
	rmAddGroupingToClass(creeVillageBID, rmClassID("importantItem"));
	rmAddGroupingConstraint(creeVillageBID, avoidTradeRoute);
	if ( whichMap == 4 )
	{
		rmPlaceGroupingAtLoc(creeVillageBID, 0, 0.1, 0.5);
	}
	else
	{
		if ( wherePlayers == 1 )
		{
			rmPlaceGroupingAtLoc(creeVillageBID, 0, 0.20, 0.80);
		}
		else
		{
			rmPlaceGroupingAtLoc(creeVillageBID, 0, 0.20, 0.15);
		}
	}	

	// Text
	rmSetStatusText("",0.50);
	int numTries = -1;
	int failCount = -1;

	// Text
	rmSetStatusText("",0.60);
	
	// Taking out Ruins - BH promises replacement with something else.
	/*
   int RuinID=rmCreateObjectDef("Inuksuk");
	rmAddObjectDefItem(RuinID, "Inuksuk", 1);
	rmSetObjectDefMinDistance(RuinID, 0);
	rmSetObjectDefMaxDistance(RuinID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(RuinID, avoidTradeRoute);
	rmAddObjectDefConstraint(RuinID, avoidImportantItem);
   rmAddObjectDefConstraint(RuinID, playerConstraint);
   rmAddObjectDefConstraint(RuinID, avoidImpassableLand);
	rmAddObjectDefToClass(RuinID, rmClassID("classMountain"));
	rmPlaceObjectDefAtLoc(RuinID, 0, 0.5, 0.5, 2);
	*/
  
	// Lots of nuggets in the north - 5 per player.  Crazy!  Go get 'em!
	rmSetNuggetDifficulty(1, 3);
	int nuggetnorthID= rmCreateObjectDef("nugget north"); 
	rmAddObjectDefItem(nuggetnorthID, "nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetnorthID, 0.0);
	rmSetObjectDefMaxDistance(nuggetnorthID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetnorthID, avoidImpassableLand);
	rmAddObjectDefToClass(nuggetnorthID, rmClassID("importantItem"));
	rmAddObjectDefConstraint(nuggetnorthID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nuggetnorthID, NWconstraint);
	rmAddObjectDefConstraint(nuggetnorthID, avoidAll);
	rmAddObjectDefConstraint(nuggetnorthID, avoidTradeRouteNugget);
	rmAddObjectDefConstraint(nuggetnorthID, avoidNugget);
	rmPlaceObjectDefAtLoc(nuggetnorthID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*5);

	// 1 per player in the southeast half - lower difficulty
	rmSetNuggetDifficulty(1, 1);
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
	rmAddObjectDefToClass(nuggetID, rmClassID("importantItem"));
	rmAddObjectDefConstraint(nuggetID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nuggetID, SEconstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteNugget);
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	// And one big nugget somewhere in the northern half.
	rmSetNuggetDifficulty(4, 4);
	int nuggetBigID= rmCreateObjectDef("nugget big"); 
	rmAddObjectDefItem(nuggetBigID, "nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetBigID, 0.0);
	rmSetObjectDefMaxDistance(nuggetBigID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetBigID, avoidImpassableLand);
	rmAddObjectDefToClass(nuggetBigID, rmClassID("importantItem"));
	rmAddObjectDefConstraint(nuggetBigID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nuggetBigID, NWconstraint);
	rmAddObjectDefConstraint(nuggetBigID, avoidAll);
	rmAddObjectDefConstraint(nuggetBigID, avoidTradeRouteNugget);
	rmAddObjectDefConstraint(nuggetBigID, avoidNugget);
	rmAddObjectDefConstraint(nuggetBigID, circleConstraint);
	rmPlaceObjectDefAtLoc(nuggetBigID, 0, 0.5, 0.5, 1);

	// Text
	rmSetStatusText("",0.70);

	// Define and place Forests - north and south
	int forestTreeID = 0;
	// These constraints keep forests from mucking up the transition zone between grass and snow
	// DAL - think these are basically killing placement for most of these things...
	int forestNWconstraint = rmCreateEdgeDistanceConstraint("north forest avoid edge", northIslandID, 10);
	int forestSEconstraint = rmCreateEdgeDistanceConstraint("south forest avoid edge", southIslandID, 10);

	numTries=2*cNumberNonGaiaPlayers;  
	failCount=0;
	for (i=0; <numTries)
		{   
			int forestID=rmCreateArea("forestID"+i);
			rmSetAreaWarnFailure(forestID, false);
			rmSetAreaSize(forestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
			rmSetAreaForestType(forestID, "yukon forest");
			rmSetAreaForestDensity(forestID, 1.0);
			rmSetAreaForestClumpiness(forestID, 0.8);		
			rmSetAreaForestUnderbrush(forestID, 0.0);
			rmSetAreaMinBlobs(forestID, 1);
			rmSetAreaMaxBlobs(forestID, 2);						
			rmSetAreaMinBlobDistance(forestID, 5.0);
			rmSetAreaMaxBlobDistance(forestID, 20.0);
			rmSetAreaCoherence(forestID, 0.4);
			rmSetAreaSmoothDistance(forestID, 10);
			rmAddAreaToClass(forestID, rmClassID("classForest"));
			rmAddAreaConstraint(forestID, southForestConstraint);  
			rmAddAreaConstraint(forestID, avoidTradeRouteForest);
			rmAddAreaConstraint(forestID, extremeSEconstraint);
			rmAddAreaConstraint(forestID, avoidMountain);
			rmAddAreaConstraint(forestID, shortAvoidImportantItem);
			rmAddAreaConstraint(forestID, playerConstraint);
			rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
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

	// Snow forests get placed later, to avoid screws.
	numTries=8*cNumberNonGaiaPlayers;  
	failCount=0;
	for (i=0; <numTries)
		{   
			int snowforestID=rmCreateArea("snowforestID"+i);
			rmSetAreaWarnFailure(snowforestID, false);
			rmSetAreaSize(snowforestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
			rmSetAreaForestType(snowforestID, "yukon snow forest");
			rmSetAreaForestDensity(snowforestID, 1.0);
			rmSetAreaForestClumpiness(snowforestID, 0.8);		
			rmSetAreaForestUnderbrush(snowforestID, 0.0);
			rmSetAreaMinBlobs(snowforestID, 1);
			rmSetAreaMaxBlobs(snowforestID, 2);						
			rmSetAreaMinBlobDistance(snowforestID, 5.0);
			rmSetAreaMaxBlobDistance(snowforestID, 20.0);
			rmSetAreaCoherence(snowforestID, 0.4);
			rmSetAreaSmoothDistance(snowforestID, 10);
			rmAddAreaToClass(snowforestID, rmClassID("classForest"));
			rmAddAreaConstraint(snowforestID, northForestConstraint);
			rmAddAreaConstraint(snowforestID, avoidTradeRouteForest);
			// rmAddAreaConstraint(snowforestID, NWconstraint);
			rmAddAreaConstraint(snowforestID, avoidMountain);
			rmAddAreaConstraint(snowforestID, shortAvoidImportantItem);
			rmAddAreaConstraint(snowforestID, playerConstraint);
			rmAddAreaConstraint(snowforestID, shortAvoidImpassableLand);
			if(rmBuildArea(snowforestID)==false)
			{
				// Stop trying once we fail 5 times in a row.
				failCount++;
				if(failCount==5)
					break;
			}
			else
				failCount=0; 
		} 

	/*
	numTries=4*cNumberNonGaiaPlayers;  
	failCount=0;
	for (i=0; <numTries)
		{   
			forestID=rmCreateArea("forestID"+i);
			rmSetAreaWarnFailure(forestID, false);
			rmSetAreaSize(forestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
			rmSetAreaForestType(forestID, "yukon snow forest");
			rmSetAreaForestDensity(forestID, 1.0);
			rmSetAreaForestClumpiness(forestID, 0.8);		
			rmSetAreaForestUnderbrush(forestID, 0.7);
			rmSetAreaMinBlobs(forestID, 1);
			rmSetAreaMaxBlobs(forestID, 2);						
			rmSetAreaMinBlobDistance(forestID, 5.0);
			rmSetAreaMaxBlobDistance(forestID, 20.0);
			rmSetAreaCoherence(forestID, 0.4);
			rmSetAreaSmoothDistance(forestID, 10);
			rmAddAreaToClass(forestID, rmClassID("classForest"));
			rmAddAreaConstraint(forestID, southForestConstraint);  
			rmAddAreaConstraint(forestID, avoidTradeRouteForest);
			rmAddAreaConstraint(forestID, SEconstraint);
			rmAddAreaConstraint(forestID, avoidMountain);
			rmAddAreaConstraint(forestID, shortAvoidImportantItem);
			rmAddAreaConstraint(forestID, playerConstraint);
			rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
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
		*/

	int silverCount1 = cNumberNonGaiaPlayers;
	int silverCount2 = cNumberNonGaiaPlayers*2;
	rmEchoInfo("silver count 1 = "+silverCount1);
	rmEchoInfo("silver count 2 = "+silverCount2);

	// Two per player in the north - and these are GOLD!
	for(i=0; < silverCount2)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("north silver "+i);
		rmAddObjectDefItem(silverID, "mineGold", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, coinAvoidsCoin);
		rmAddObjectDefConstraint(silverID, coinEdgeConstraint);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRouteForest);
		rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
		rmAddObjectDefConstraint(silverID, playerConstraint);
		rmAddObjectDefConstraint(silverID, avoidWater12);
		rmAddObjectDefConstraint(silverID, Northward);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   }

	/* - DAL: south ore & east ore taken out, since there's starting ore now.
	// One per player in the "south"
	for(i=0; < silverCount1)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateGrouping("south silver "+i, "resource silver ore "+silverType);
		rmSetGroupingMinDistance(silverID, 0.0);
		rmSetGroupingMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(silverID, coinAvoidsCoin);
		rmAddGroupingConstraint(silverID, avoidImpassableLand);
		rmAddGroupingConstraint(silverID, avoidTradeRoute);
		rmAddGroupingConstraint(silverID, shortAvoidImportantItem);
		rmAddGroupingConstraint(silverID, playerConstraint);
		rmAddGroupingConstraint(silverID, Southward);
		rmPlaceGroupingAtLoc(silverID, 0, 0.5, 0.5);
   }
   */

	// One per player in the "east"
	for(i=0; < silverCount1)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("east silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, coinAvoidsCoin);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
		rmAddObjectDefConstraint(silverID, playerConstraint);
		rmAddObjectDefConstraint(silverID, Eastward);
		rmAddObjectDefConstraint(silverID, avoidWater12);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   }

	// One per player in the "west"
	for(i=0; < silverCount1)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("west silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, coinAvoidsCoin);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
		rmAddObjectDefConstraint(silverID, playerConstraint);
		rmAddObjectDefConstraint(silverID, Westward);
		rmAddObjectDefConstraint(silverID, avoidWater12);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   }

	// Text
	rmSetStatusText("",0.80);
  

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.05;
    
    if(randLoc == 1 || cNumberTeams > 2)
      yLoc = .5;
    
    else if(randLoc == 2)
      yLoc = .5;
      
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

	// Resources that can be placed after forests
	int muskOxID=rmCreateObjectDef("muskOx herd");
	rmAddObjectDefItem(muskOxID, "muskOx", rmRandInt(8,10), 8.0);
	rmSetObjectDefMinDistance(muskOxID, 0.0);
	rmSetObjectDefMaxDistance(muskOxID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(muskOxID, avoidMuskOx);
	rmAddObjectDefConstraint(muskOxID, avoidAll);
	rmAddObjectDefConstraint(muskOxID, NWconstraint);
	rmAddObjectDefConstraint(muskOxID, avoidImpassableLand);
	rmAddObjectDefConstraint(muskOxID, avoidMountain);
	rmAddObjectDefConstraint(muskOxID, playerConstraint);
	rmSetObjectDefCreateHerd(muskOxID, true);

	int caribouID=rmCreateObjectDef("caribou herd");
	rmAddObjectDefItem(caribouID, "caribou", rmRandInt(8,12), 8);
	rmSetObjectDefMinDistance(caribouID, 0.0);
	rmSetObjectDefMaxDistance(caribouID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(caribouID, avoidCaribou);
	rmAddObjectDefConstraint(caribouID, avoidAll);
	rmAddObjectDefConstraint(caribouID, SEconstraint);
	rmAddObjectDefConstraint(caribouID, avoidImpassableLand);
	rmAddObjectDefConstraint(caribouID, avoidMountain);
	rmAddObjectDefConstraint(caribouID, playerConstraint);
	rmSetObjectDefCreateHerd(caribouID, true);

	rmPlaceObjectDefAtLoc(muskOxID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(caribouID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	// Text
	rmSetStatusText("",1.0);
	}  
}