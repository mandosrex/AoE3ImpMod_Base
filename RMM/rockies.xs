// ROCKIES - started with a modified version of Great Plains.
// July 2004
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

   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;

   /*
   int subCiv2=-1;
   int subCiv3=-1;
   int subCiv4=-1;
   int subCiv5=-1;
   */

	int whichNative=rmRandInt(1,2);
	if ( whichNative == 1)
	{
		subCiv0=rmGetCivID("Cheyenne");
		rmEchoInfo("subCiv0 is Cheyenne "+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Cheyenne");

		subCiv1=rmGetCivID("Cheyenne");
		rmEchoInfo("subCiv1 is Cheyenne "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Cheyenne");
	}
	else
	{
		subCiv0=rmGetCivID("Comanche");
		rmEchoInfo("subCiv0 is Comanche "+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Comanche");

		subCiv1=rmGetCivID("Comanche");
		rmEchoInfo("subCiv1 is Comanche "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Comanche");
	}

	// Choose which variation to use.  1=southeast trade route, 2=northwest trade route
	int whichMap=rmRandInt(1,2);
	// int whichMap=2;

	// Are there extra meeting poles?
	int extraPoles=rmRandInt(1,2);

	/*
	if (rmAllocateSubCivs(6) == true)
   {
      subCiv0=rmGetCivID("Cherokee");
      rmEchoInfo("subCiv0 is Cherokee "+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Cherokee");
	
      subCiv1=rmGetCivID("Iroquois");
		rmEchoInfo("subCiv1 is Iroquois "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Iroquois");

		subCiv2=rmGetCivID("Cree");
      rmEchoInfo("subCiv2 is Cree"+subCiv2);
		  if (subCiv2 >= 0)
			 rmSetSubCiv(2, "Cree");
	 
		subCiv3=rmGetCivID("Seminoles");
      rmEchoInfo("subCiv3 is Seminoles"+subCiv3);
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Seminoles");
	  
		subCiv4=rmGetCivID("Comanche");
      rmEchoInfo("subCiv4 is Comanche"+subCiv4);
      if (subCiv4 >= 0)
         rmSetSubCiv(4, "Comanche");
     
		subCiv5=rmGetCivID("Cheyenne");
      rmEchoInfo("subCiv5 is Cheyenne "+subCiv5);
		if (subCiv5 >= 0)
			rmSetSubCiv(5, "Cheyenne");
   }
   */

   // Picks the map size
   int playerTiles=11500;
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   // Picks a default water height
   rmSetSeaLevel(0.0);

   // Picks default terrain and water
	// DAL rmSetAreaMix(westDesertID, "texas_dirt");
	rmSetMapElevationParameters(cElevTurbulence, 0.02, 3, 0.5, 8.0);
	rmSetBaseTerrainMix("rockies_snow");
	rmTerrainInitialize("rockies\groundsnow1_roc", 12);	
	rmSetLightingSet("rockies");
	rmSetMapType("rockies");
	rmSetMapType("land");
	rmSetWorldCircleConstraint(true);
	// rmSetMapType("grass");

	chooseMercs();

    // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("classCotton");
   rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("nuggets");
	rmDefineClass("natives");
	rmDefineClass("classHillArea");
	rmDefineClass("classSmallHillArea");
	rmDefineClass("socketClass");
	rmDefineClass("classCliff");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
	int silverEdgeConstraint=rmCreateBoxConstraint("silver edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
	// int forestEdgeConstraint=rmCreateBoxConstraint("forest edge of map", rmXTilesToFraction(30), rmZTilesToFraction(30), 1.0-rmXTilesToFraction(30), 1.0-rmZTilesToFraction(30), 0.01);
	// int forestEdgeConstraint=rmCreatePieConstraint("forest edge of map", 0.5, 0.5, 0, 50, 0, 360, 0.01);
	int forestEdgeConstraint=rmCreatePieConstraint("forest edge of map", 0.5, 0.5, 0, rmGetMapXSize()-30, 0, 0, 0);
	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);

   // Resource avoidance
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. things", rmClassID("classForest"), 8.0);
    int forestVsForestConstraint=rmCreateClassDistanceConstraint("forest vs. other forests", rmClassID("classForest"), 20.0);
	if ( cNumberNonGaiaPlayers < 3 )
	{
		forestVsForestConstraint=rmCreateClassDistanceConstraint("forest vs. other forests smaller", rmClassID("classForest"), 10.0);
	}
	int cottonConstraint=rmCreateClassDistanceConstraint("cotton vs. cotton", rmClassID("classCotton"), 40.0);
	int otherCottonConstraint=rmCreateClassDistanceConstraint("other things vs. cotton", rmClassID("classCotton"), 5.0);
	int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 15.0);
	int avoidBison=rmCreateTypeDistanceConstraint("bison avoids food", "bison", 70.0);
	int avoidBighorn=rmCreateTypeDistanceConstraint("bighorn avoids food", "bighornsheep", 40.0);
	int avoidPronghorn=rmCreateTypeDistanceConstraint("pronghorn avoids food", "pronghorn", 32.0);
	int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.10));
	int avoidCoin=rmCreateTypeDistanceConstraint("stuff avoids coin", "gold", 15.0);
	int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 60.0);
	int avoidNuggets=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 30.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 15.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 4.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 25.0);
	int avoidImportantItemForest=rmCreateClassDistanceConstraint("important stuff avoids each forest", rmClassID("importantItem"), 10.0);

	int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 8.0);

   // Constraint to avoid water.
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 20.0);
   int avoidWater40 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 40.0);

	// Avoid the hilly areas.
	int avoidHills = rmCreateClassDistanceConstraint("avoid Hills", rmClassID("classHillArea"), 5.0);
	int avoidHillsLarge = rmCreateClassDistanceConstraint("avoid Hills by a lot", rmClassID("classHillArea"), 20.0);
	int avoidSmallHills = rmCreateClassDistanceConstraint("avoid Small Hills", rmClassID("classSmallHillArea"), 20.0);
	int avoidSmallHillsSmall = rmCreateClassDistanceConstraint("avoid Small Hills by a little", rmClassID("classSmallHillArea"), 2.0);

	// Cardinal Directions - "halves" of the map.
	int NWConstraint = rmCreateBoxConstraint("stay in NW portion", 0, 0.5, 1, 1);
	int SEConstraint = rmCreateBoxConstraint("stay in SE portion", 0, 0, 1, 0.5);
	int NEConstraint = rmCreateBoxConstraint("stay in NE portion", 0.5, 0, 1, 1);
	int SWConstraint = rmCreateBoxConstraint("stay in SW portion", 0, 0, 0.5, 1);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Text
   rmSetStatusText("",0.10);

	// DEFINE AREAS
	// DAL TEMP: Big invisible continent, size 0.95, 0.95
   // Build up big continent called "big continent"
   int bigContinentID=rmCreateArea("big continent");
   rmSetAreaSize(bigContinentID, 0.9, 0.9); // 3 35
   rmSetAreaWarnFailure(bigContinentID, false);
   // rmSetAreaSmoothDistance(bigContinentID, 10);
	rmSetAreaMix(bigContinentID, "rockies_snow");
   rmSetAreaCoherence(bigContinentID, 0.9);
   rmSetAreaLocation(bigContinentID, 0.5, 0.5);
	rmSetAreaCliffType(bigContinentID, "rocky mountain edge");
	rmSetAreaCliffEdge(bigContinentID, 1, 1.0, 0.0, 0.0, 0);
	rmSetAreaCliffHeight(bigContinentID, -4, 1.0, 0.3);
	rmSetAreaCliffPainting(bigContinentID, false, false, true);
	rmAddAreaToClass(bigContinentID, rmClassID("classCliff"));
	rmBuildArea(bigContinentID);

   int bigContinent2ID=rmCreateArea("big continent 2");
   rmSetAreaSize(bigContinent2ID, 0.64, 0.64); // 3 35
   rmSetAreaWarnFailure(bigContinent2ID, false);
   // rmSetAreaSmoothDistance(bigContinent2ID, 10);
	rmSetAreaMix(bigContinent2ID, "rockies_snow");
   rmSetAreaCoherence(bigContinent2ID, 0.9);
   rmSetAreaLocation(bigContinent2ID, 0.5, 0.5);
	rmSetAreaCliffType(bigContinent2ID, "rocky mountain edge");
	rmSetAreaCliffEdge(bigContinent2ID, 1, 1.0, 0.0, 0.0, 0);
	rmSetAreaCliffHeight(bigContinent2ID, -8, 1.0, 0.3);
	rmSetAreaCliffPainting(bigContinent2ID, false, false, true);
	rmAddAreaToClass(bigContinent2ID, rmClassID("classCliff"));
	rmBuildArea(bigContinent2ID);

	// DAL - end crazy wacky big continent.
   // Set up player starting locations.
   if ( cNumberTeams > 2 )
   {
		rmSetTeamSpacingModifier(0.75);
		rmSetPlacementSection(0.15, 0.85); // 0.5
		rmPlacePlayersCircular(0.35, 0.35, 0);
   }
   else
   {
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.12, 0.38);
		if ( cNumberNonGaiaPlayers == 2 )
		{
			rmSetPlacementSection(0.20, 0.25);
		}
		rmPlacePlayersCircular(0.35, 0.35, 0);
		
		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.62, 0.88);
		if ( cNumberNonGaiaPlayers == 2 )
		{
			rmSetPlacementSection(0.70, 0.75);
		}
		rmPlacePlayersCircular(0.35, 0.35, 0);
   }
	//	rmPlacePlayersCircular(0.45, 0.45, rmDegreesToRadians(5.0));

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
	  rmAddAreaConstraint(id, avoidTradeRoute); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

	int numTries = -1;
	int failCount = -1;

	// Hill 2 is the central "cliffy" hill.
	int centralValleyID=rmCreateArea("center valley");
	rmSetAreaMix(centralValleyID, "rockies_grass");
	rmSetAreaTerrainType(centralValleyID, "rockies\ground4_roc");
	rmAddAreaTerrainLayer(centralValleyID, "rockies\groundsnow6_roc", 0, 2);
	rmAddAreaTerrainLayer(centralValleyID, "rockies\groundsnow7_roc", 2, 5);
	rmAddAreaTerrainLayer(centralValleyID, "rockies\groundsnow8_roc", 5, 8);
	rmSetAreaSize(centralValleyID, 0.18, 0.18);
	rmSetAreaWarnFailure(centralValleyID, false);
	rmSetAreaSmoothDistance(centralValleyID, 12);
	rmSetAreaCliffType(centralValleyID, "rocky mountain2");
	rmSetAreaCliffEdge(centralValleyID, 1, 1.0, 0.0, 0.0, 0);
	rmSetAreaCliffHeight(centralValleyID, -8, 2.0, 0.3);
	rmSetAreaCoherence(centralValleyID, 0.8);
	rmSetAreaHeightBlend(centralValleyID, 1);
	if ( cNumberTeams == 2 )
	{
		rmAddAreaCliffWaypoint(centralValleyID, 0.5, 0.2);
		rmAddAreaCliffRandomWaypoints(centralValleyID, 0.5, 0.8, 8, 20.0);
	}
	else
	{
		rmAddAreaCliffWaypoint(centralValleyID, 0.5, 0.35);
		rmAddAreaCliffRandomWaypoints(centralValleyID, 0.5, 0.65, 8, 20.0);
	}
	rmSetAreaCliffPainting(centralValleyID, true, false, true);
	rmAddAreaToClass(centralValleyID, rmClassID("classHillArea"));
	rmBuildArea(centralValleyID);

   // Text
   rmSetStatusText("",0.20);

   // Placement order
   // Trade route -> Natives -> Secrets -> Nuggets -> ??
	
   // TRADE ROUTES
   int tradeRouteID = rmCreateTradeRoute();
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts south");
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 12.0);

	rmAddTradeRouteWaypoint(tradeRouteID, 0.8, 0.3);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.2, 0.3, 10, 4);

   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 
  
	// add the sockets along the trade route.
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.0);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 1.0);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   int tradeRoute2ID = rmCreateTradeRoute();
   socketID=rmCreateObjectDef("sockets to dock Trade Posts north");
   rmSetObjectDefTradeRouteID(socketID, tradeRoute2ID);

   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 12.0);

	rmAddTradeRouteWaypoint(tradeRoute2ID, 0.8, 0.7);
	rmAddRandomTradeRouteWaypoints(tradeRoute2ID, 0.2, 0.7, 10, 4);

   placedTradeRoute = rmBuildTradeRoute(tradeRoute2ID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 
  
	// add the sockets along the trade route.
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.0);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 1.0);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);


   // Text
   rmSetStatusText("",0.30);

   // NATIVE AMERICANS
	int cheyenneVillageAID = -1;
	int cheyenneVillageType = rmRandInt(1,5);
	if ( whichNative == 1 )
	{
		cheyenneVillageAID = rmCreateGrouping("cheyenne village A", "native cheyenne village "+cheyenneVillageType);
	}
	else
	{
		cheyenneVillageAID = rmCreateGrouping("comanche village A", "native comanche village "+cheyenneVillageType);
	}
	rmSetGroupingMinDistance(cheyenneVillageAID, 0.0);
	rmSetGroupingMaxDistance(cheyenneVillageAID, 0.0);
	rmAddGroupingConstraint(cheyenneVillageAID, avoidImpassableLand);
	rmAddGroupingToClass(cheyenneVillageAID, rmClassID("importantItem"));
	rmAddGroupingConstraint(cheyenneVillageAID, avoidTradeRoute);
	rmPlaceGroupingAtLoc(cheyenneVillageAID, 0, 0.2, 0.5);

	// Text
   rmSetStatusText("",0.40);

	int cheyenneVillageBID = -1;
	cheyenneVillageType = rmRandInt(1,5);
	if ( whichNative == 1 )
	{
		cheyenneVillageBID = rmCreateGrouping("cheyenne village B", "native cheyenne village "+cheyenneVillageType);
	}
	else
	{
		cheyenneVillageBID = rmCreateGrouping("comanche village B", "native comanche village "+cheyenneVillageType);
	}
	rmSetGroupingMinDistance(cheyenneVillageBID, 0.0);
	rmSetGroupingMaxDistance(cheyenneVillageBID, 0.0);
	rmAddGroupingConstraint(cheyenneVillageBID, avoidImpassableLand);
	rmAddGroupingToClass(cheyenneVillageBID, rmClassID("importantItem"));
	rmAddGroupingConstraint(cheyenneVillageBID, avoidTradeRoute);
	rmPlaceGroupingAtLoc(cheyenneVillageBID, 0, 0.8, 0.5);

	// Text
   rmSetStatusText("",0.60);

    //STARTING UNITS
   	int startingTCID= rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
	rmSetObjectDefMinDistance(startingTCID, 0.0);
	rmSetObjectDefMaxDistance(startingTCID, 16.0);

   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 8.0);
	rmAddObjectDefConstraint(startingUnits, avoidStartingUnitsSmall);
	
	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeRockiesSnow", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 12.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 20.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartBighornID=rmCreateObjectDef("starting bighorn");
	rmAddObjectDefItem(StartBighornID, "bighornsheep", 5, 4.0);
	rmSetObjectDefMinDistance(StartBighornID, 9.0);
	rmSetObjectDefMaxDistance(StartBighornID, 13.0);
	rmSetObjectDefCreateHerd(StartBighornID, true);
	rmAddObjectDefConstraint(StartBighornID, avoidStartingUnitsSmall);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
	rmAddObjectDefToClass(playerNuggetID, rmClassID("startingUnit"));
    rmSetObjectDefMinDistance(playerNuggetID, 30.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggets);
	rmAddObjectDefConstraint(playerNuggetID, forestEdgeConstraint);	// Pushing the nuggets away from the cliffs at the edge.
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);

	int playerGoldID=rmCreateObjectDef("player silver ore");
	int silverType = rmRandInt(1,10);

 	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
		// vector closestPoint=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
		// rmSetHomeCityGatherPoint(i, closestPoint);

    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
		// Everyone gets two ore groupings, one pretty close, the other a little further away.
		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
		// rmAddGroupingToClass(playerGoldID, rmClassID("importantItem"));
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
		rmSetObjectDefMinDistance(playerGoldID, 15.0);
		rmSetObjectDefMaxDistance(playerGoldID, 20.0);
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Placing starting Pronghorns...
		rmPlaceObjectDefAtLoc(StartBighornID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		// rmPlaceObjectDefAtLoc(StartBighornID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		// rmPlaceObjectDefAtLoc(StartBighornID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		// rmPlaceObjectDefAtLoc(StartBighornID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Nuggets
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

	// Text

	// Place resources - silver mines in the east
	silverType = rmRandInt(1,10);
	int silverID = -1;
	int silver2ID = -1;
	int silver3ID = -1;
	int silverCount = cNumberNonGaiaPlayers;

	rmEchoInfo("silver count = "+silverCount);
	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));

		rmAddObjectDefConstraint(silverID, playerConstraint);
		rmAddObjectDefConstraint(silverID, coinAvoidCoin);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, avoidSocket);
		rmAddObjectDefConstraint(silverID, avoidHillsLarge);
		rmAddObjectDefConstraint(silverID, SWConstraint);
		rmAddObjectDefConstraint(silverID, silverEdgeConstraint);
		rmAddObjectDefConstraint(silverID, avoidStartingUnits);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
	}

	// Silver in the west
	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
		silver2ID = rmCreateObjectDef("silver north "+i);
		rmAddObjectDefItem(silver2ID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silver2ID, 0.0);
		rmSetObjectDefMaxDistance(silver2ID, rmXFractionToMeters(0.5));

		rmAddObjectDefConstraint(silver2ID, playerConstraint);
		rmAddObjectDefConstraint(silver2ID, coinAvoidCoin);
		rmAddObjectDefConstraint(silver2ID, avoidImpassableLand);
		rmAddObjectDefConstraint(silver2ID, avoidTradeRoute);
		rmAddObjectDefConstraint(silver2ID, avoidSocket);
		rmAddObjectDefConstraint(silver2ID, avoidHillsLarge);
		rmAddObjectDefConstraint(silver2ID, NEConstraint);
		rmAddObjectDefConstraint(silver2ID, silverEdgeConstraint);
		rmAddObjectDefConstraint(silver2ID, avoidStartingUnits);
		rmPlaceObjectDefAtLoc(silver2ID, 0, 0.5, 0.5);
	}

	// Text
   rmSetStatusText("",0.70); 

	// Then a few more in the middle, clustered and away from the edges
	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
		silver3ID = rmCreateObjectDef("silver south "+i);
		rmAddObjectDefItem(silver3ID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silver3ID, 0.0);
		rmSetObjectDefMaxDistance(silver3ID, rmXFractionToMeters(0.5));

		rmAddObjectDefConstraint(silver3ID, coinAvoidCoin);
		rmAddObjectDefConstraint(silver3ID, avoidImpassableLand);
		rmAddObjectDefConstraint(silver3ID, avoidTradeRoute);
		rmAddObjectDefConstraint(silver3ID, avoidSocket);
		rmAddObjectDefConstraint(silver3ID, silverEdgeConstraint);
		rmPlaceObjectDefInArea(silver3ID, 0, centralValleyID);
	}
   // Text
   rmSetStatusText("",0.80);

	// Define and place forests - west and east
	int forestTreeID = 0;
	
	numTries=2*cNumberNonGaiaPlayers;  // DAL - 3 here, 3 below
	failCount=0;
	for (i=0; <numTries)
	{   
		int westForest=rmCreateArea("westForest"+i);
		rmSetAreaWarnFailure(westForest, false);
		rmAddAreaToClass(westForest, rmClassID("classForest"));
		rmSetAreaSize(westForest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
		rmSetAreaForestType(westForest, "rockies snow forest");
		rmSetAreaForestDensity(westForest, 0.9);
		rmSetAreaForestClumpiness(westForest, 0.3);					//DAL more forest with more clumps
		rmSetAreaForestUnderbrush(westForest, 0.0);
		rmSetAreaCoherence(westForest, 0.3);
		rmSetAreaSmoothDistance(westForest, 10);
		rmSetAreaObeyWorldCircleConstraint(westForest, false);
		rmAddAreaConstraint(westForest, avoidImportantItemForest);		// DAL added, to try and make sure natives got on the map w/o override.
		rmAddAreaConstraint(westForest, playerConstraintForest);	// DAL adeed, to keep forests away from the player.
		rmAddAreaConstraint(westForest, forestVsForestConstraint);			// DAL adeed, to keep forests away from each other.
		rmAddAreaConstraint(westForest, SWConstraint);				// DAL adeed, to keep these forests in the west.
		rmAddAreaConstraint(westForest, avoidTradeRoute);
		rmAddAreaConstraint(westForest, avoidHills);
		rmAddAreaConstraint(westForest, avoidSocket);
		rmAddAreaConstraint(westForest, avoidCoin);
		rmAddAreaConstraint(westForest, forestEdgeConstraint);
		rmAddAreaConstraint(westForest, avoidStartingUnits);
		if(rmBuildArea(westForest)==false)
		{
			// Stop trying once we fail 5 times in a row.
			failCount++;
			if(failCount==5)
				break;
		}
		else
			failCount=0; 
	}

	numTries=2*cNumberNonGaiaPlayers;  // DAL - 3 here, 3 above
	failCount=0;
	for (i=0; <numTries)
	{   
		int eastForest=rmCreateArea("eastForest"+i);
		rmSetAreaWarnFailure(eastForest, false);
		rmAddAreaToClass(eastForest, rmClassID("classForest"));
		rmSetAreaSize(eastForest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
		rmSetAreaForestType(eastForest, "rockies snow forest");
		rmSetAreaForestDensity(eastForest, 0.9);
		rmSetAreaForestClumpiness(eastForest, 0.3);						//DAL more forest with more clumps
		rmSetAreaForestUnderbrush(eastForest, 0.0);
		rmSetAreaCoherence(eastForest, 0.3);
		rmSetAreaSmoothDistance(eastForest, 10);
		rmSetAreaObeyWorldCircleConstraint(eastForest, false);
		rmAddAreaConstraint(eastForest, avoidImportantItemForest);	// DAL added, to try and make sure natives got on the map w/o override.
		rmAddAreaConstraint(eastForest, playerConstraintForest);		// DAL adeed, to keep forests away from the player.
		rmAddAreaConstraint(eastForest, forestVsForestConstraint);				// DAL adeed, to keep forests away from each other.
		rmAddAreaConstraint(eastForest, NEConstraint);	// DAL adeed, to keep these forests in the east.
		rmAddAreaConstraint(eastForest, avoidTradeRoute);
		rmAddAreaConstraint(eastForest, avoidHills);
		rmAddAreaConstraint(eastForest, avoidSocket);
		rmAddAreaConstraint(eastForest, avoidCoin);
		rmAddAreaConstraint(eastForest, forestEdgeConstraint);
		rmAddAreaConstraint(eastForest, avoidStartingUnits);
		if(rmBuildArea(eastForest)==false)
		{
			// Stop trying once we fail 5 times in a row.
			failCount++;
			if(failCount==5)
				break;
		}
		else
			failCount=0;
	} 

	numTries=cNumberNonGaiaPlayers;															// DAL - 1 more forests/player in the middle.
	failCount=0;
	for (i=0; <numTries)
	{   
		int centerForest=rmCreateArea("centerForest"+i, centralValleyID);
		rmSetAreaWarnFailure(centerForest, false);
		rmAddAreaToClass(centerForest, rmClassID("classForest"));
		rmSetAreaSize(centerForest, rmAreaTilesToFraction(500), rmAreaTilesToFraction(600));
		rmSetAreaForestType(centerForest, "rockies forest");
		rmSetAreaForestDensity(centerForest, 0.9);
		rmSetAreaForestClumpiness(centerForest, 0.7);										// DAL more forest with more clumps
		rmSetAreaForestUnderbrush(centerForest, 0.0);
		rmSetAreaCoherence(centerForest, 0.7);												// DAL forests in the valley are more coherent
		rmSetAreaSmoothDistance(centerForest, 10);
		rmSetAreaObeyWorldCircleConstraint(centerForest, false);
		rmAddAreaConstraint(centerForest, forestVsForestConstraint);						// DAL adeed, to keep forests away from each other.
		rmAddAreaConstraint(centerForest, avoidSocket);
		rmAddAreaConstraint(centerForest, avoidTradeRoute);
		rmAddAreaConstraint(centerForest, avoidCoin);
		if(rmBuildArea(centerForest)==false)
		{
			// Stop trying once we fail 5 times in a row.
			failCount++;
			if(failCount==5)
				break;
		}
		else
			failCount=0;
	} 

	rmSetStatusText("",0.90);

	// bighorn - two groups (one on each side per player)
	int bighorn1ID=rmCreateObjectDef("bighorn herd 1");
	rmAddObjectDefItem(bighorn1ID, "BighornSheep", rmRandInt(6,8), 10.0);
	rmSetObjectDefMinDistance(bighorn1ID, 0.0);
	rmSetObjectDefMaxDistance(bighorn1ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bighorn1ID, avoidBighorn);
	rmAddObjectDefConstraint(bighorn1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(bighorn1ID, avoidTradeRoute);
	rmAddObjectDefConstraint(bighorn1ID, avoidSocket);
	rmAddObjectDefConstraint(bighorn1ID, forestConstraint);
	rmAddObjectDefConstraint(bighorn1ID, SWConstraint);
	rmAddObjectDefConstraint(bighorn1ID, avoidHills);
	rmAddObjectDefConstraint(bighorn1ID, avoidCoin);
	rmAddObjectDefConstraint(bighorn1ID, avoidStartingUnits);
	rmSetObjectDefCreateHerd(bighorn1ID, true);
	rmPlaceObjectDefAtLoc(bighorn1ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int bighorn2ID=rmCreateObjectDef("bighorn herd 2");
	rmAddObjectDefItem(bighorn2ID, "BighornSheep", rmRandInt(6,8), 10.0);
	rmSetObjectDefMinDistance(bighorn2ID, 0.0);
	rmSetObjectDefMaxDistance(bighorn2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bighorn2ID, avoidBighorn);
	rmAddObjectDefConstraint(bighorn2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(bighorn2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(bighorn2ID, avoidSocket);
	rmAddObjectDefConstraint(bighorn2ID, forestConstraint);
	rmAddObjectDefConstraint(bighorn2ID, NEConstraint);
	rmAddObjectDefConstraint(bighorn2ID, avoidHills);
	rmAddObjectDefConstraint(bighorn2ID, avoidCoin);
	rmAddObjectDefConstraint(bighorn2ID, avoidStartingUnits);
	rmSetObjectDefCreateHerd(bighorn2ID, true);
	rmPlaceObjectDefAtLoc(bighorn2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	// pronghorn sheep down in the (center) valley
	int pronghornID=rmCreateObjectDef("pronghorn Herd");
	rmAddObjectDefItem(pronghornID, "pronghorn", rmRandInt(8,10), 10.0);
	rmSetObjectDefMinDistance(pronghornID, 0.0);
	rmSetObjectDefMaxDistance(pronghornID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(pronghornID, avoidPronghorn);
	rmAddObjectDefConstraint(pronghornID, avoidImpassableLand);
	rmAddObjectDefConstraint(pronghornID, avoidTradeRoute);
	rmAddObjectDefConstraint(pronghornID, forestConstraint);
	rmAddObjectDefConstraint(pronghornID, avoidSocket);
	rmAddObjectDefConstraint(pronghornID, avoidSmallHillsSmall);
	rmSetObjectDefCreateHerd(pronghornID, true);
	rmPlaceObjectDefInArea(pronghornID, 0, centralValleyID, cNumberNonGaiaPlayers*3);
		
	// Define and place Nuggets - mostly in the middle section.
  
	int nuggetID = 0;

	// Nuggets in the center.
	for(i=0; <cNumberNonGaiaPlayers*4)
	{
		rmSetNuggetDifficulty(1, 3);
		nuggetID= rmCreateObjectDef("nugget center "+i); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nuggetID, 0.0);
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
		rmAddObjectDefToClass(nuggetID, rmClassID("nuggets"));
		rmAddObjectDefConstraint(nuggetID, avoidImportantItem);
		rmAddObjectDefConstraint(nuggetID, avoidNuggets);
		rmAddObjectDefConstraint(nuggetID, avoidCoin);
		rmAddObjectDefConstraint(nuggetID, otherCottonConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetID, avoidSmallHillsSmall);
		rmAddObjectDefConstraint(nuggetID, forestEdgeConstraint);
		rmAddObjectDefConstraint(nuggetID, circleConstraint);
		rmPlaceObjectDefInArea(nuggetID, 0, centralValleyID, 1);
	}
  
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
    float walk = 0.075;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

	/*
	// Nuggets - one per player in each of the non-hill sections.
	// DAL - these taken out, now only player nuggets + ones in center
	for(i=0; <cNumberNonGaiaPlayers*2)
	{
		nuggetID= rmCreateObjectDef("nugget southwest "+i); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nuggetID, 0.0);
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
		rmAddObjectDefToClass(nuggetID, rmClassID("nuggets"));
		rmAddObjectDefConstraint(nuggetID, avoidImportantItem);
		rmAddObjectDefConstraint(nuggetID, avoidNuggets);
		rmAddObjectDefConstraint(nuggetID, avoidCoin);
		rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetID, avoidHills);
		rmAddObjectDefConstraint(nuggetID, SWConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 1);

	}
	for(i=0; <cNumberNonGaiaPlayers*2)
	{
		nuggetID= rmCreateObjectDef("nugget northeast "+i); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nuggetID, 0.0);
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
		rmAddObjectDefToClass(nuggetID, rmClassID("nuggets"));
		rmAddObjectDefConstraint(nuggetID, avoidImportantItem);
		rmAddObjectDefConstraint(nuggetID, avoidNuggets);
		rmAddObjectDefConstraint(nuggetID, avoidCoin);
		rmAddObjectDefConstraint(nuggetID, avoidHills);
		rmAddObjectDefConstraint(nuggetID, NEConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 1);
	}
	*/

   // Text
   rmSetStatusText("",1.0);
}