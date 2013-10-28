// ANDES
// Dec 06 - YP update

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
   int subCiv2=-1;
	int subCiv3=-1;


	// All Inca all the time
   if (rmAllocateSubCivs(4) == true)
   {
		subCiv0=rmGetCivID("Incas");
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Incas");

		subCiv1=rmGetCivID("Incas");
      if (subCiv1 >= 0)
         rmSetSubCiv(1, "Incas");

		subCiv2=rmGetCivID("Incas");
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "Incas");

		subCiv3=rmGetCivID("Incas");
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Incas");
	}

	// Which map - four possible variations (excluding which end the players start on, which is a separate thing)

   // Picks the map size
	int playerTiles=10500;
	if (cNumberNonGaiaPlayers<3)
		int size=2.2*sqrt(cNumberNonGaiaPlayers*playerTiles);
	else
		size=2.1*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Picks a default water height
	rmSetSeaLevel(3.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.
	rmSetWindMagnitude(2);

	// Picks default terrain and water
	//	rmAddMapTerrainByHeightInfo("yukon\ground2_yuk", 6.0, 9.0, 1.0);
	//	rmAddMapTerrainByHeightInfo("yukon\ground3_yuk", 9.0, 16.0);
	rmSetBaseTerrainMix("andes_grass_a");
   rmTerrainInitialize("andes\ground10_and", 4);
	rmSetMapType("andes");
	rmSetMapType("grass");
	rmSetMapType("land");
   rmSetLightingSet("sonora");

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Choose Mercs
	chooseMercs();

	// Make it snow
   //rmSetGlobalSnow( 0.7 );

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

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   //int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
	//int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.43), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int coinEdgeConstraint=rmCreateBoxConstraint("coin edge of map", rmXTilesToFraction(7), rmZTilesToFraction(7), 1.0-rmXTilesToFraction(7), 1.0-rmZTilesToFraction(7), 0.01);
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(25), rmZTilesToFraction(25), 1.0-rmXTilesToFraction(25), 1.0-rmZTilesToFraction(25), 0.01);

   // Cardinal Directions
	int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.75, 0.75, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
	int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

	int NWconstraint = rmCreateBoxConstraint("stay in NW portion", 0, 0.5, 1, 1);
	int SEconstraint = rmCreateBoxConstraint("stay in SE portion", 0, 0, 1, 0.5);
	int NEconstraint = rmCreateBoxConstraint("stay in NE portion", 0.65, 0.0, 1, 1);
	int SWconstraint = rmCreateBoxConstraint("stay in SW portion", 0, 0.0, 0.5, 1);
	int extremeNEconstraint = rmCreateBoxConstraint("stay deep into NE portion", 0.6, 0.0, 1.0, 1.0);
   
	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 20.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("stay far away from players", classPlayer, 50.0);
 
   // Nature avoidance
	int southForestConstraint=rmCreateClassDistanceConstraint("forest avoids forest", rmClassID("classForest"), 30.0);
	int avoidLlama=rmCreateTypeDistanceConstraint("llama avoids llama", "Llama", 60.0);
	int avoidDeer=rmCreateTypeDistanceConstraint("deer avoids deer", "Deer", 50.0);
	int avoidGuanaco=rmCreateTypeDistanceConstraint("guanaco avoids guanaco", "Guanaco", 40.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 40.0);
	int avoidCoinFar=rmCreateTypeDistanceConstraint("avoid coin far", "gold", 55.0);
   
   // Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidRiver = rmCreateTerrainDistanceConstraint("avoid river", "Land", false, 5.0);
	int avoidCliff=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
	int avoidCliffFar=rmCreateClassDistanceConstraint("stuff vs. cliff far", rmClassID("classCliff"), 22.0);
	int cliffAvoidCliff=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int mediumShortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("mediumshort avoid impassable land", "Land", false, 8.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int mediumAvoidImpassableLand=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 12.0);

   // Unit avoidance
	
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 20.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 42.0);
	int avoidTownCenterSupaFar=rmCreateTypeDistanceConstraint("avoid Town Center Supa Far", "townCenter", 80.0);
	int avoidHuari=rmCreateTypeDistanceConstraint("avoid Huari", "HuariStrongholdAndes", 80.0);
	int avoidCinematicBlock=rmCreateTypeDistanceConstraint("avoid Block", "CinematicBlock", 5.0);
	int avoidCinematicBlockFar=rmCreateTypeDistanceConstraint("avoid Block Far", "CinematicBlock", 60.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 60.0);
	int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other by a bit", rmClassID("importantItem"), 10.0);
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 10.0);
	int avoidNativesFar=rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 55.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 30.0);
	int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget avoid nugget far", "AbstractNugget", 45.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid Trade Socket", "sockettraderoute", 10);
	int avoidTradeRouteSocketsTC=rmCreateTypeDistanceConstraint("avoid Trade Socket from TC", "sockettraderoute", 60);
	int avoidIncaSocketsTC=rmCreateTypeDistanceConstraint("avoid Inca Socket from TC", "socketinca", 85);
	
   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 8.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidTradeRouteForest = rmCreateTradeRouteDistanceConstraint("trade route forest", 8.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 50.0);
   int avoidTradeRouteTC = rmCreateTradeRouteDistanceConstraint("TC avoid trade route", 20.0);

   // -------------Define objects
   // These objects are all defined so they can be placed later

   rmSetStatusText("",0.10);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	if(cNumberTeams > 2) //ffa
	{
		rmSetPlacementSection(0.52, 0.90);
		rmSetTeamSpacingModifier(0.75);
		rmPlacePlayersCircular(0.40, 0.40, 0);
	}
	else
	{
		// *** Set up player starting locations. Circular around the outside of the map.  
/*
		rmSetPlacementSection(0.52, 0.99);
		rmSetTeamSpacingModifier(.75);
		rmPlacePlayersCircular(0.39, 0.39, 0);
*/	
		// *** Set up player starting locations. On lines on the north and south of the map.  
		if(rmRandFloat(0,1) > 0.50)
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.28, 0.80, 0.65, 0.90, 0.2, 0.1);

			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.30, 0.20, 0.65, 0.10, 0.2, 0.1);
		}
		else
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.28, 0.20, 0.65, 0.10, 0.2, 0.1);

			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.30, 0.80, 0.65, 0.90, 0.2, 0.1);			
		}
	}

   // Build a north area
	int northIslandID = rmCreateArea("north island");
	rmSetAreaLocation(northIslandID, 0.75, 0.50); 
	rmSetAreaWarnFailure(northIslandID, false);
	rmSetAreaSize(northIslandID, 0.5, 0.5);
	rmSetAreaCoherence(northIslandID, 0.5);

	rmSetAreaElevationType(northIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(northIslandID, 3.0);
	rmSetAreaBaseHeight(northIslandID, 4.0);
	rmSetAreaElevationMinFrequency(northIslandID, 0.07);
	rmSetAreaElevationOctaves(northIslandID, 4);
	rmSetAreaElevationPersistence(northIslandID, 0.5);
	rmSetAreaElevationNoiseBias(northIslandID, 1);
   
	rmSetAreaObeyWorldCircleConstraint(northIslandID, false);
	rmSetAreaMix(northIslandID, "andes_grass_b");
	//rmSetAreaMix(northIslandID, "amazon grass");


   // Text
   rmSetStatusText("",0.20);

   // Build a south area
   int southIslandID = rmCreateArea("south island");
   rmSetAreaLocation(southIslandID, 0, 0.5); 
   rmSetAreaWarnFailure(southIslandID, false);
   rmSetAreaSize(southIslandID, 0.5, 0.5);
   rmSetAreaCoherence(southIslandID, 0.5);

	rmSetAreaElevationType(southIslandID, cElevTurbulence);
   rmSetAreaElevationVariation(southIslandID, 5.0);
   rmSetAreaBaseHeight(southIslandID, 3.0);
   rmSetAreaElevationMinFrequency(southIslandID, 0.07);
   rmSetAreaElevationOctaves(southIslandID, 4);
   rmSetAreaElevationPersistence(southIslandID, 0.5);
	rmSetAreaElevationNoiseBias(southIslandID, 1); 
   rmAddAreaTerrainLayer(southIslandID, "andes\ground10_and", 0, 5);
   //rmAddAreaTerrainLayer(southIslandID, "andes\ground07_and", 3, 8);
   //rmAddAreaTerrainLayer(southIslandID, "andes\ground4_and", 6, 8);
   
	rmSetAreaObeyWorldCircleConstraint(southIslandID, false);
	rmSetAreaMix(southIslandID, "andes_grass_a");

   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.30);

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
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint);
      rmSetAreaLocPlayer(id, i);
	  rmSetAreaTerrainType(id, "carolina\marshflats");
	  //rmSetAreaBaseHeight(id, 18.0);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();
   
	// Text
	rmSetStatusText("",0.40);

	// TRADE ROUTES
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 10.0);
	
	int tradeRoute1ID = rmCreateTradeRoute();

	if(rmRandFloat(0,1) > 0.5)
	// Trade Route in a V shape
	{
		
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0, 0.8);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.55, 0.55, 8, 10);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0, 0.2, 4, 6);

		//Place Cinematic block to avoid
		int cinematicBlockID= rmCreateObjectDef("avoid Cinematic Block"); 
		rmAddObjectDefItem(cinematicBlockID, "CinematicBlock", 1, 0.0);
		rmSetObjectDefMinDistance(cinematicBlockID, 0.0);
		rmSetObjectDefMaxDistance(cinematicBlockID, 0.5);
		rmPlaceObjectDefAtLoc(cinematicBlockID, 0, 0.14, 0.52, 1);

	}
	else
	{ 
		//Trade Route down the middle
		// Rivers on both sides 70%
		float RiverType = rmRandFloat(0,1);
		if(RiverType < 0.5)
		{
			//int riverID = rmRiverCreate(-1, "Andes River", 12, 8, 3, 3);
			int riverID = rmRiverCreate(-1, "Andes River", 10, 10, 6, 5);
			rmRiverAddWaypoint(riverID, 0.9, 1.0);
			rmRiverAddWaypoint(riverID, 0.5, 0.65);
			rmRiverAddWaypoint(riverID, 0.0, 0.75);
			rmRiverSetShallowRadius(riverID, 10);
			rmRiverAddShallow(riverID, rmRandFloat(0.45, 0.65));
			rmRiverSetBankNoiseParams(riverID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
			rmRiverBuild(riverID);

			int river2ID = rmRiverCreate(-1, "Andes River", 10, 10, 6, 5);
			rmRiverAddWaypoint(river2ID, 0.9, 0.0);
			rmRiverAddWaypoint(river2ID, 0.5, 0.35);
			rmRiverAddWaypoint(river2ID, 0.0, 0.16);
			rmRiverSetShallowRadius(river2ID, 10);
			rmRiverAddShallow(river2ID, rmRandFloat(0.45, 0.65));
			rmRiverSetBankNoiseParams(river2ID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
			rmRiverBuild(river2ID);
		}
/*		else 
		{
			int river3ID = rmRiverCreate(-1, "Andes River", 10, 10, 6, 5);
			rmRiverAddWaypoint(river3ID, 0.9, 1.0);
			rmRiverAddWaypoint(river3ID, 0.5, 1.0);
			rmRiverAddWaypoint(river3ID, 0.0, 0.84);
			rmRiverSetBankNoiseParams(river3ID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
			rmRiverBuild(river3ID);

			int river4ID = rmRiverCreate(-1, "Andes River", 10, 10, 6, 5);
			rmRiverAddWaypoint(river4ID, 0.9, 0.0);
			rmRiverAddWaypoint(river4ID, 0.5, 0.0);
			rmRiverAddWaypoint(river4ID, 0.0, 0.16);
			rmRiverSetBankNoiseParams(river4ID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
			rmRiverBuild(river4ID);
		}
*/

		rmAddTradeRouteWaypoint(tradeRoute1ID, 0, 0.45);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.45, 0.50, 8, 10);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 1, 0.45, 8, 10);
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

	socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.85);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);


	// Text
	rmSetStatusText("",0.50);

	if (subCiv0 == rmGetCivID("Incas"))
	{  
		int incaVillageAID = -1;
		incaVillageAID = rmCreateGrouping("back inca village", "native inca village "+1);
		rmSetGroupingMinDistance(incaVillageAID, 0.0);
		rmSetGroupingMaxDistance(incaVillageAID, 0.20);
		rmAddGroupingToClass(incaVillageAID, rmClassID("natives"));
		rmAddGroupingToClass(incaVillageAID, rmClassID("importantItem"));
		rmAddGroupingConstraint(incaVillageAID, avoidTradeRoute);
		rmAddGroupingConstraint(incaVillageAID, avoidNatives);
		rmPlaceGroupingAtLoc(incaVillageAID, 0, 0.83, 0.75);
	}

	if (subCiv1 == rmGetCivID("Incas"))
	{  
		int incavillageBID = -1;
		incavillageBID = rmCreateGrouping("left city", "native inca village "+2);
		rmSetGroupingMinDistance(incavillageBID, 0.0);
		rmSetGroupingMaxDistance(incavillageBID, 20.0);
		rmAddGroupingToClass(incavillageBID, rmClassID("natives"));
		rmAddGroupingToClass(incavillageBID, rmClassID("importantItem"));
		rmAddGroupingConstraint(incavillageBID, avoidTradeRoute);
		rmAddGroupingConstraint(incavillageBID, avoidNatives);
		rmPlaceGroupingAtLoc(incavillageBID, 0, 0.73, 0.70);
	}

	if (subCiv2 == rmGetCivID("Incas"))
	{  
		int incavillageCID = -1;
		incavillageCID = rmCreateGrouping("right city", "native inca village "+3);
		rmSetGroupingMinDistance(incavillageCID, 0.0);
		rmSetGroupingMaxDistance(incavillageCID, 20.0);
		rmAddGroupingToClass(incavillageCID, rmClassID("natives"));
		rmAddGroupingToClass(incavillageCID, rmClassID("importantItem"));
		rmAddGroupingConstraint(incavillageCID, avoidTradeRoute);
		rmAddGroupingConstraint(incavillageCID, avoidNatives);
		rmPlaceGroupingAtLoc(incavillageCID, 0, 0.85, 0.25);
	}

	if (subCiv3 == rmGetCivID("Incas"))
	{  
		int incavillageDID = -1;
		incavillageDID = rmCreateGrouping("front city", "native inca village "+4);
		rmSetGroupingMinDistance(incavillageDID, 0.0);
		rmSetGroupingMaxDistance(incavillageDID, 20.0);
		rmAddGroupingToClass(incavillageDID, rmClassID("natives"));
		rmAddGroupingToClass(incavillageDID, rmClassID("importantItem"));
		rmAddGroupingConstraint(incavillageDID, avoidTradeRoute);
		rmAddGroupingConstraint(incavillageDID, avoidNatives);
		rmPlaceGroupingAtLoc(incavillageDID, 0, 0.73, 0.35);
	}


	// Text
	rmSetStatusText("",0.50);
	int failCount = -1;

	int numTries=cNumberNonGaiaPlayers+2;

	// PLAYER STARTING RESOURCES
	rmClearClosestPointConstraints();

	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	}

	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
	int TCfloat = -1;

	if (cNumberTeams == 2)
	{
		rmAddObjectDefConstraint(TCID, avoidTradeRouteTC);
		rmAddObjectDefConstraint(TCID, avoidTradeRouteSocketsTC);
		rmAddObjectDefConstraint(TCID, avoidCinematicBlockFar);

		if (cNumberNonGaiaPlayers<3)
			TCfloat = 55;
		else if (cNumberNonGaiaPlayers<7)
			TCfloat = 65;
		else
			TCfloat = 110;
	}
	else 
	{
		TCfloat = 100;

	}

	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, TCfloat);

	rmAddObjectDefConstraint(TCID, avoidIncaSocketsTC);
	rmAddObjectDefConstraint(TCID, avoidTownCenterFar);
	rmAddObjectDefConstraint(TCID, mediumShortAvoidImpassableLand);

	
	
	int playerSilverID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerSilverID, avoidTownCenter);
	rmSetObjectDefMinDistance(playerSilverID, 15.0);
	rmSetObjectDefMaxDistance(playerSilverID, 20.0);
    rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);

	int playerGuanacoID=rmCreateObjectDef("player guanaco");
    rmAddObjectDefItem(playerGuanacoID, "guanaco", rmRandInt(14,20), 18.0);
    rmSetObjectDefMinDistance(playerGuanacoID, 10);
    rmSetObjectDefMaxDistance(playerGuanacoID, 18);
	rmAddObjectDefConstraint(playerGuanacoID, avoidAll);
    rmAddObjectDefConstraint(playerGuanacoID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerGuanacoID, avoidCliff);
    rmSetObjectDefCreateHerd(playerGuanacoID, true);

	int playerNuggetID= rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
  	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
  	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidCliff);
	rmAddObjectDefConstraint(playerNuggetID, playerEdgeConstraint);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);

	int playerTreeID=rmCreateObjectDef("player trees");
    rmAddObjectDefItem(playerTreeID, "TreeAndes", rmRandInt(5,10), 8.0);
    rmSetObjectDefMinDistance(playerTreeID, 10);
    rmSetObjectDefMaxDistance(playerTreeID, 25);
	rmAddObjectDefConstraint(playerTreeID, avoidAll);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);

	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGuanacoID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		rmClearClosestPointConstraints();
	}

	//Add cliff area
	for(i=0; <numTries)
	{
		int cliffID=rmCreateArea("cliff"+i);
	   rmSetAreaSize(cliffID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(600));
		rmSetAreaWarnFailure(cliffID, false);
		rmSetAreaCliffType(cliffID, "andes");
//		rmSetAreaMix(cliffID, "rockies_grass_snow");
		rmAddAreaToClass(cliffID, rmClassID("classCliff"));
//		rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, true);
		rmSetAreaCliffEdge(cliffID, 1, 1.0, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(cliffID, rmRandInt(4,6), 1.0, 1.0);
		rmAddAreaConstraint(cliffID, cliffAvoidCliff);
		rmSetAreaMinBlobs(cliffID, 3);
		rmSetAreaMaxBlobs(cliffID, 5);
		rmSetAreaMinBlobDistance(cliffID, 3.0);
		rmSetAreaMaxBlobDistance(cliffID, 5.0);
		rmSetAreaCoherence(cliffID, 0.2);
		rmSetAreaSmoothDistance(cliffID, 10);
		rmAddAreaConstraint(cliffID, avoidTownCenterSupaFar);
		rmAddAreaConstraint(cliffID, avoidNatives); 
		rmAddAreaConstraint(cliffID, avoidTradeRouteSockets);
		rmAddAreaConstraint(cliffID, avoidTradeRoute);
		//rmAddAreaConstraint(cliffID, northIslandID);
		rmAddAreaConstraint(cliffID, avoidRiver);
		rmAddAreaConstraint(cliffID, NEconstraint);
		rmSetAreaObeyWorldCircleConstraint(cliffID, false);
		if(rmBuildArea(cliffID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==10)
				break;
		}
		else
			failCount=0;
	}

	// Text
	rmSetStatusText("",0.60);

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

  // KOTH check
  
  if(rmGetIsKOTH())
    rmEchoInfo("KOTH on");

	// Define and place Nuggets

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    int randLoc = rmRandInt(1,2);
    
    if(randLoc == 1 || cNumberTeams > 2)
      ypKingsHillPlacer(0.9, 0.5, 0.1, avoidCliff);
    else 
      ypKingsHillPlacer(0.1, 0.5, 0.05, avoidCliff);
  }

	int nuggeteasyID= rmCreateObjectDef("nugget easy SE"); 
	rmAddObjectDefItem(nuggeteasyID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggeteasyID, 0.0);
	rmSetObjectDefMaxDistance(nuggeteasyID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggeteasyID, avoidNuggetFar);
  	rmAddObjectDefConstraint(nuggeteasyID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggeteasyID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggeteasyID, avoidCliff);
  	rmAddObjectDefConstraint(nuggeteasyID, avoidAll);
  	rmAddObjectDefConstraint(nuggeteasyID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggeteasyID, SEconstraint);
	rmPlaceObjectDefAtLoc(nuggeteasyID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);

	int nuggeteasyNWID= rmCreateObjectDef("nugget easy NW"); 
	rmAddObjectDefItem(nuggeteasyNWID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggeteasyNWID, 0.0);
	rmSetObjectDefMaxDistance(nuggeteasyNWID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidNuggetFar);
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggeteasyNWID, avoidCliff);
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidAll);
  	rmAddObjectDefConstraint(nuggeteasyNWID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggeteasyNWID, NWconstraint);
	rmPlaceObjectDefAtLoc(nuggeteasyNWID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);

	if(rmRandFloat(0,1) < 0.75) //only places medium nuggets 75% of the time
	{
		int nuggetmediumID= rmCreateObjectDef("nugget medium SE"); 
		rmAddObjectDefItem(nuggetmediumID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2, 2);
		rmSetObjectDefMinDistance(nuggetmediumID, 0.0);
		rmSetObjectDefMaxDistance(nuggetmediumID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetmediumID, avoidNuggetFar);
  		rmAddObjectDefConstraint(nuggetmediumID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggetmediumID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetmediumID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetmediumID, avoidAll);
  		rmAddObjectDefConstraint(nuggetmediumID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetmediumID, SEconstraint);
		rmPlaceObjectDefAtLoc(nuggetmediumID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);

		int nuggetmediumNWID= rmCreateObjectDef("nugget medium NW"); 
		rmAddObjectDefItem(nuggetmediumNWID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2, 2);
		rmSetObjectDefMinDistance(nuggetmediumNWID, 0.0);
		rmSetObjectDefMaxDistance(nuggetmediumNWID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidNuggetFar);
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetmediumNWID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidAll);
  		rmAddObjectDefConstraint(nuggetmediumNWID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetmediumNWID, NWconstraint);
		rmPlaceObjectDefAtLoc(nuggetmediumNWID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);
	}

	if(rmRandFloat(0,1) < 0.40) //only places hard nuggets 40% of the time
	{
	int nuggethardID= rmCreateObjectDef("nugget hard SE"); 
	rmAddObjectDefItem(nuggethardID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nuggethardID, 0.0);
	rmSetObjectDefMaxDistance(nuggethardID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggethardID, avoidNuggetFar);
  	rmAddObjectDefConstraint(nuggethardID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggethardID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggethardID, avoidCliff);
  	rmAddObjectDefConstraint(nuggethardID, avoidAll);
	rmAddObjectDefConstraint(nuggethardID, playerEdgeConstraint);
  	rmAddObjectDefConstraint(nuggethardID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggethardID, SEconstraint);
	rmPlaceObjectDefAtLoc(nuggethardID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/4);

	int nuggethardNWID= rmCreateObjectDef("nugget hard NW"); 
	rmAddObjectDefItem(nuggethardNWID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nuggethardNWID, 0.0);
	rmSetObjectDefMaxDistance(nuggethardNWID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggethardNWID, avoidNuggetFar);
  	rmAddObjectDefConstraint(nuggethardNWID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggethardNWID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggethardNWID, avoidCliff);
  	rmAddObjectDefConstraint(nuggethardNWID, avoidAll);
	rmAddObjectDefConstraint(nuggethardNWID, playerEdgeConstraint);
  	rmAddObjectDefConstraint(nuggethardNWID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggethardNWID, NWconstraint);
	rmPlaceObjectDefAtLoc(nuggethardNWID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/4);
	}

	//only try to place these 10% of the time
	   if(rmRandFloat(0,1) < 0.10)
	   {
		int nuggetnutsID= rmCreateObjectDef("nugget nuts SE"); 
		rmAddObjectDefItem(nuggetnutsID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmSetObjectDefMinDistance(nuggetnutsID, 0.0);
		rmSetObjectDefMaxDistance(nuggetnutsID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetnutsID, avoidNuggetFar);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetnutsID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidAll);
		rmAddObjectDefConstraint(nuggetnutsID, playerEdgeConstraint);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetnutsID, SEconstraint);
		rmPlaceObjectDefAtLoc(nuggetnutsID, 0, 0.5, 0.5, 1);

		int nuggetnutsNWID= rmCreateObjectDef("nugget nuts NW"); 
		rmAddObjectDefItem(nuggetnutsNWID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmSetObjectDefMinDistance(nuggetnutsNWID, 0.0);
		rmSetObjectDefMaxDistance(nuggetnutsNWID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidNuggetFar);
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetnutsNWID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidAll);
		rmAddObjectDefConstraint(nuggetnutsNWID, playerEdgeConstraint);
  		rmAddObjectDefConstraint(nuggetnutsNWID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetnutsNWID, NWconstraint);
		rmPlaceObjectDefAtLoc(nuggetnutsNWID, 0, 0.5, 0.5, 1);
	   }

		// Text
	rmSetStatusText("",0.70);

/*
	//Define and place Huari Strongholds
	int strongholdID= rmCreateObjectDef("stronghold"); 
	rmAddObjectDefItem(strongholdID, "HuariStrongholdAndes", 1, 0.0);
	rmSetObjectDefMinDistance(strongholdID, 0.0);
	rmSetObjectDefMaxDistance(strongholdID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(strongholdID, avoidCliff);
	rmAddObjectDefConstraint(strongholdID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(strongholdID, avoidHuari);
	rmAddObjectDefConstraint(strongholdID, avoidAll);
	rmAddObjectDefConstraint(strongholdID, avoidTownCenterSupaFar);
	rmAddObjectDefConstraint(strongholdID, longPlayerConstraint);
	rmPlaceObjectDefAtLoc(strongholdID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*1.5);
*/

/*

	int IncaHouseID= rmCreateObjectDef("random Inca buildings"); 
	rmAddObjectDefItem(IncaHouseID, "NativeHouseInca", 1, 0.0);
	rmSetObjectDefMinDistance(IncaHouseID, 0.0);
	rmSetObjectDefMaxDistance(IncaHouseID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(IncaHouseID, avoidCliff);
	rmAddObjectDefConstraint(IncaHouseID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(IncaHouseID, extremeNEconstraint);
	rmAddObjectDefConstraint(IncaHouseID, avoidAll);
	rmPlaceObjectDefAtLoc(IncaHouseID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);

*/

	// Silver mines

	rmSetStatusText("",0.80);
 
	int silverType = -1;
	int silverCount = (cNumberNonGaiaPlayers*1.25 + rmRandInt(2,3));
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount)
	{
	  int silverID = rmCreateObjectDef("silver "+i);
	  rmAddObjectDefItem(silverID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(silverID, 0.0);
      rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(silverID, avoidCoin);
      rmAddObjectDefConstraint(silverID, avoidAll);
      rmAddObjectDefConstraint(silverID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(silverID, avoidTradeRoute);
	  rmAddObjectDefConstraint(silverID, avoidNatives);
      rmAddObjectDefConstraint(silverID, mediumAvoidImpassableLand);
	  rmAddObjectDefConstraint(silverID, avoidCliff);
	  rmAddObjectDefConstraint(silverID, coinEdgeConstraint);
	  rmAddObjectDefConstraint(silverID, NWconstraint);
	  rmPlaceObjectDefAtLoc(silverID, 0, 0.25, 0.75);
   }


	for(i=0; < silverCount)
	{
	  int silverSouthID = rmCreateObjectDef("silverSouth "+i);
	  rmAddObjectDefItem(silverSouthID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(silverSouthID, 0.0);
      rmSetObjectDefMaxDistance(silverSouthID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(silverSouthID, avoidCoin);
      rmAddObjectDefConstraint(silverSouthID, avoidAll);
      rmAddObjectDefConstraint(silverSouthID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(silverSouthID, avoidTradeRoute);
	  rmAddObjectDefConstraint(silverSouthID, avoidNatives);
      rmAddObjectDefConstraint(silverSouthID, mediumAvoidImpassableLand);
	  rmAddObjectDefConstraint(silverSouthID, avoidCliff);
	  rmAddObjectDefConstraint(silverSouthID, coinEdgeConstraint);
	  rmAddObjectDefConstraint(silverSouthID, SEconstraint);
	  rmPlaceObjectDefAtLoc(silverSouthID, 0, 0.75, 0.25);
   }

	for(i=0; < cNumberNonGaiaPlayers)
	{
	  int silverRandomID = rmCreateObjectDef("silverRandom "+i);
	  rmAddObjectDefItem(silverRandomID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(silverRandomID, 0.0);
      rmSetObjectDefMaxDistance(silverRandomID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(silverRandomID, avoidCoinFar);
      rmAddObjectDefConstraint(silverRandomID, avoidAll);
      rmAddObjectDefConstraint(silverRandomID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(silverRandomID, avoidTradeRoute);
	  rmAddObjectDefConstraint(silverRandomID, avoidNatives);
      rmAddObjectDefConstraint(silverRandomID, mediumAvoidImpassableLand);
	  rmAddObjectDefConstraint(silverRandomID, avoidCliff);
	  rmAddObjectDefConstraint(silverRandomID, coinEdgeConstraint);
	  rmPlaceObjectDefAtLoc(silverRandomID, 0, 0.5, 0.5);
   }




	// Forest areas

	int forestTreeID = 0;

	if (cNumberNonGaiaPlayers < 4)
		numTries=8*cNumberNonGaiaPlayers;
	else
		numTries=4*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
		{   
			int forestID=rmCreateArea("forestID"+i, southIslandID);
			rmSetAreaWarnFailure(forestID, false);
			rmSetAreaSize(forestID, rmAreaTilesToFraction(160), rmAreaTilesToFraction(200));
			rmSetAreaForestType(forestID, "andes forest");
			rmSetAreaForestDensity(forestID, 0.9);
			rmSetAreaForestClumpiness(forestID, 0.7);		
			rmSetAreaForestUnderbrush(forestID, 0.6);
			rmSetAreaMinBlobs(forestID, 1);
			rmSetAreaMaxBlobs(forestID, 4);						
			rmSetAreaMinBlobDistance(forestID, 5.0);
			rmSetAreaMaxBlobDistance(forestID, 20.0);
			rmSetAreaCoherence(forestID, 0.4);
			rmSetAreaSmoothDistance(forestID, 10);
			rmAddAreaToClass(forestID, rmClassID("classForest"));
			//rmAddAreaConstraint(forestID, southForestConstraint);  
			rmAddAreaConstraint(forestID, avoidTradeRouteForest);
			rmAddAreaConstraint(forestID, avoidCinematicBlock);
			rmAddAreaConstraint(forestID, shortAvoidImportantItem);
			rmAddAreaConstraint(forestID, playerConstraint);
			rmAddAreaConstraint(forestID, avoidCliff);
			rmAddAreaConstraint(forestID, avoidAll);
			if(rmBuildArea(forestID)==false)
			{
				// Stop trying once we fail 5 times in a row.
				failCount++;
				if(failCount==10)
					break;
			}
			else
				failCount=0; 
		}

	int forestTreeNorthID = 0;
	numTries=6*cNumberNonGaiaPlayers;  
	failCount=0;
	for (i=0; <numTries)
		{   
			int forestnorthID=rmCreateArea("forestNorthID"+i, northIslandID);
			rmSetAreaWarnFailure(forestnorthID, false);
			rmSetAreaSize(forestnorthID, rmAreaTilesToFraction(160), rmAreaTilesToFraction(200));
			rmSetAreaForestType(forestnorthID, "andes forest");
			rmSetAreaForestDensity(forestnorthID, 0.5);
			rmSetAreaForestClumpiness(forestnorthID, 0.4);		
			rmSetAreaForestUnderbrush(forestnorthID, 0.7);
			rmSetAreaMinBlobs(forestnorthID, 1);
			rmSetAreaMaxBlobs(forestnorthID, 4);						
			rmSetAreaMinBlobDistance(forestnorthID, 5.0);
			rmSetAreaMaxBlobDistance(forestnorthID, 20.0);
			rmSetAreaCoherence(forestnorthID, 0.4);
			rmSetAreaSmoothDistance(forestnorthID, 10);
			rmAddAreaToClass(forestnorthID, rmClassID("classForest"));
			//rmAddAreaConstraint(forestID, southForestConstraint);  
			rmAddAreaConstraint(forestnorthID, avoidTradeRouteForest);
			rmAddAreaConstraint(forestnorthID, avoidCinematicBlock);
			rmAddAreaConstraint(forestnorthID, shortAvoidImportantItem);
			rmAddAreaConstraint(forestnorthID, playerConstraint);
			rmAddAreaConstraint(forestnorthID, avoidCliff);
			rmAddAreaConstraint(forestnorthID, avoidAll);
			if(rmBuildArea(forestnorthID)==false)
			{
				// Stop trying once we fail 5 times in a row.
				failCount++;
				if(failCount==10)
					break;
			}
			else
				failCount=0; 
		}

	// Define and place Puyas
	int puyaCount = (cNumberNonGaiaPlayers*3);
	rmEchoInfo("puya count = "+puyaCount);
	for (i=0; <puyaCount)
		{   
		int puyaTreeID= rmCreateObjectDef("puya tree"+i); 
		rmAddObjectDefItem(puyaTreeID, "treePuya", 1, 0.0);
		rmAddObjectDefConstraint(puyaTreeID, shortAvoidImpassableLand);
  		rmAddObjectDefConstraint(puyaTreeID, avoidNugget);
  		rmAddObjectDefConstraint(puyaTreeID, avoidTradeRoute);
		rmAddObjectDefConstraint(puyaTreeID, avoidTownCenter);
		rmAddObjectDefConstraint(puyaTreeID, avoidCinematicBlock);
  		rmAddObjectDefConstraint(puyaTreeID, avoidAll);
		rmAddObjectDefConstraint(puyaTreeID, avoidCliff);
		rmAddObjectDefConstraint(puyaTreeID, playerEdgeConstraint);
		rmPlaceObjectDefAtLoc(puyaTreeID, 0, 0.5, 0.5);
		}

	// Text
	rmSetStatusText("",0.80);

	// Resources that can be placed after forests


	if(rmRandFloat(0,1) < 0.6) //place llamas 60% of the time
		{
		if (cNumberNonGaiaPlayers<5)
			int llamaCount =2*cNumberNonGaiaPlayers;
		else
			llamaCount =1.75*cNumberNonGaiaPlayers;
		rmEchoInfo("llama count = "+llamaCount);
		for (i=0; <llamaCount)
			{
			int llamaID = rmCreateObjectDef("llama herd "+i);
			rmAddObjectDefItem(llamaID, "llama", rmRandInt(1,2), 10);
			rmSetObjectDefMinDistance(llamaID, 0.0);
			rmSetObjectDefMaxDistance(llamaID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint(llamaID, avoidLlama);
			rmAddObjectDefConstraint(llamaID, avoidAll);
			rmAddObjectDefConstraint(llamaID, avoidTownCenterFar);
			rmAddObjectDefConstraint(llamaID, avoidCinematicBlock);
				//rmAddObjectDefConstraint(llamaID, SEconstraint);
			rmAddObjectDefConstraint(llamaID, avoidCliffFar);
			rmSetObjectDefCreateHerd(llamaID, false);

			rmPlaceObjectDefAtLoc(llamaID, 0, 0.5, 0.5);
			}
		}

	// Text
	rmSetStatusText("",0.90);


	if (cNumberNonGaiaPlayers<5)
		int guanacoCount =4*cNumberNonGaiaPlayers;
	else
		guanacoCount =1.75*cNumberNonGaiaPlayers;

	rmEchoInfo("guanaco count = "+guanacoCount);
	
	for (i=0; <guanacoCount/2)
	{
		int guanacoID = rmCreateObjectDef("guanaco herd " +i);
		rmAddObjectDefItem(guanacoID, "guanaco", rmRandInt(8,10), 13);
		rmSetObjectDefMinDistance(guanacoID, 0.0);
		rmSetObjectDefMaxDistance(guanacoID, rmXFractionToMeters(0.8));
		rmAddObjectDefConstraint(guanacoID, avoidGuanaco);
		rmAddObjectDefConstraint(guanacoID, avoidAll);
		rmAddObjectDefConstraint(guanacoID, avoidNatives);
		rmAddObjectDefConstraint(guanacoID, avoidTradeRouteForest);
		rmAddObjectDefConstraint(guanacoID, avoidCinematicBlock);
		rmAddObjectDefConstraint(guanacoID, avoidCliffFar);
		rmAddObjectDefConstraint(guanacoID, NWconstraint);
		rmSetObjectDefCreateHerd(guanacoID, true);
		rmPlaceObjectDefAtLoc(guanacoID, 0, 0.5, 0.5);
	}

	for (i=0; <guanacoCount/2)
	{
		int guanacoSEID = rmCreateObjectDef("guanaco SE herd " +i);
		rmAddObjectDefItem(guanacoSEID, "guanaco", rmRandInt(8,10), 13);
		rmSetObjectDefMinDistance(guanacoSEID, 0.0);
		rmSetObjectDefMaxDistance(guanacoSEID, rmXFractionToMeters(0.8));
		rmAddObjectDefConstraint(guanacoSEID, avoidGuanaco);
		rmAddObjectDefConstraint(guanacoSEID, avoidAll);
		rmAddObjectDefConstraint(guanacoSEID, avoidNatives);
		rmAddObjectDefConstraint(guanacoSEID, avoidTradeRouteForest);
		rmAddObjectDefConstraint(guanacoSEID, avoidCinematicBlock);
		rmAddObjectDefConstraint(guanacoSEID, avoidCliffFar);
		rmAddObjectDefConstraint(guanacoSEID, SEconstraint);
		rmSetObjectDefCreateHerd(guanacoSEID, true);
		rmPlaceObjectDefAtLoc(guanacoSEID, 0, 0.5, 0.5);
	}


	// Text
	rmSetStatusText("",1.0);

	
	}  
}  
