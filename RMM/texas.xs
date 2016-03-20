// TEXAS
// October 2003
// Nov 06 - YP update
// Main entry point for random map script

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   // Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;

	// Which map variation are we dealing with?
	// 1 - Three natives, one in the middle, others between teams
	// 2-3 - Two natives between teams, no lake
	// 4 - Two natives between teams, lake/plateau in the middle.
	// 5-6 - Three natives in the middle, no lake.
	// 7-8 - Two natives in the middle, no lake
	// 9-10 - Two natives in the middle, lake/plateau.
	int whichVariation=-1;
	whichVariation = rmRandInt(1,10);
  
  if(rmGetIsKOTH()) {
    if(whichVariation == 4 || whichVariation > 8)
      whichVariation = rmRandInt(1, 8);
    
    if(whichVariation == 4)
      whichVariation = 1;
  }

  rmEchoInfo("Variation = " + whichVariation);
  
	// Which natives?  1 = Comanche, 2 = Apache
	int whichNatives=-1;
	whichNatives = rmRandInt(1,2);

	// Make sure natives are in the middle in cases where there are lots of players (to avoid placement issues)
	if ( cNumberNonGaiaPlayers > 4 )
	{
    
    if(rmGetIsKOTH())
		  whichVariation = rmRandInt(5,8);
    
    else
		  whichVariation = rmRandInt(5,10);
	}

   if (rmAllocateSubCivs(3) == true)
   {
	   if ( whichNatives == 1 )
	   {
			// All Comanche, all the time
			subCiv0=rmGetCivID("Comanche");
			if (subCiv0 >= 0)
				rmSetSubCiv(0, "Comanche", true);

			subCiv1=rmGetCivID("Comanche");
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "Comanche");

  			subCiv2=rmGetCivID("Comanche");
			if (subCiv2 >= 0)
				rmSetSubCiv(2, "Comanche");
	   }
	   else
	   {
			// All Apache, all the time
			subCiv0=rmGetCivID("Apache");
			if (subCiv0 >= 0)
				rmSetSubCiv(0, "Apache", true);

			subCiv1=rmGetCivID("Apache");
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "Apache");

  			subCiv2=rmGetCivID("Apache");
			if (subCiv2 >= 0)
				rmSetSubCiv(2, "Apache");
	   }
	}

	// Picks the map size
	int playerTiles=10000;
	// if (cNumberNonGaiaPlayers >4)
	//	playerTiles = 9500;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	// rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.5, 3.0);  // DAL - original
	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
	rmSetMapElevationHeightBlend(1);
	
	// Picks a default water height
	rmSetSeaLevel(4.0);
	rmSetLightingSet("Texas");

   // Picks default terrain and water
	rmSetSeaType("Amazon River");
	rmSetBaseTerrainMix("texas_grass");
	rmTerrainInitialize("texas\ground1_tex", 5.0);
	rmSetMapType("texas");
	rmSetMapType("grass");
	rmSetMapType("land");

	// Choose mercs.
	chooseMercs();

	// Corner constraint.
	rmSetWorldCircleConstraint(true);

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
	rmDefineClass("secrets");
	rmDefineClass("nuggets");
	rmDefineClass("center");
	rmDefineClass("classCotton");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
	int bisonEdgeConstraint=rmCreateBoxConstraint("bison edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0);  //DAL - was 24
	// int goldCenterConstraint=rmCreateBoxConstraint("gold keeps away from middle", 0.2, 0.2, 0.8, 0.8, 0.01);
	int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 30.0);
	int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 60.0);

   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 20.0);
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);

	// Nature avoidance
	// int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
	// int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 10.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 10.0);

	// Coin constraint drops on smaller maps.
	int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
	if ( cNumberNonGaiaPlayers < 4 )
	{
		coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin small maps", "gold", 25.0);
	}

	int cottonConstraint=rmCreateClassDistanceConstraint("cotton constraint", rmClassID("classCotton"), 30.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   
   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
   int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 10.0);
   int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 14.0);
	int cliffsAvoidCliffs=rmCreateClassDistanceConstraint("cliffs vs. cliffs", rmClassID("classCliff"), 30.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);
   int avoidStartingUnitsLarge=rmCreateClassDistanceConstraint("objects avoid starting units large", rmClassID("startingUnit"), 50.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 10.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 30.0);
	int avoidSecrets=rmCreateClassDistanceConstraint("stuff avoids secrets", rmClassID("secrets"), 20.0);
	int avoidNugget=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 35.0);
	int avoidCow=rmCreateTypeDistanceConstraint("cow avoids cow", "cow", 50.0);
	int forestsAvoidBison=rmCreateTypeDistanceConstraint("forest avoids bison", "bison", 20.0);

	 int avoidOutpost=rmCreateTypeDistanceConstraint("outposts avoid outposts", "Outpost", 24.0);
  int avoidOutpostAsian=rmCreateTypeDistanceConstraint("avoid Asian outposts", "ypOutpostAsian", 24.0);
	 int avoidOutpostBarracks=rmCreateTypeDistanceConstraint("barracks avoid outposts", "Outpost", 24.0);
	 int avoidBlockhouse=rmCreateTypeDistanceConstraint("blockhouses avoid blockhouses", "Blockhouse", 35.0);
	 int avoidWarHut=rmCreateTypeDistanceConstraint("war huts avoid war huts", "WarHut", 35.0);

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

	// Trade route avoidance.
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int avoidTradeRouteCliff = rmCreateTradeRouteDistanceConstraint("trade route cliff", 10.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// -------------Define objects
	// These objects are all defined so they can be placed later
	// Define the "Fort", bison, and other resource stuff.
	int playerFortID = -1;
	int playerFortIDRussian = -1;
	int playerFortType = 2;
	// playerFortID = rmCreateGrouping("player fort", "texas fort "+playerFortType);
	// playerFortIDRussian = rmCreateGrouping("player fort russian", "texas fort russian");

   int bisonID=rmCreateObjectDef("bison herd center");
   rmAddObjectDefItem(bisonID, "bison", rmRandInt(8,10), 6.0);
   rmSetObjectDefMinDistance(bisonID, 0.0);
   rmSetObjectDefMaxDistance(bisonID, 5.0);

   // wood resources
   int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, "TreeTexasDirt", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomTreeID, avoidResource);
   rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);

   // starting resources
	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeTexasDirt", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 8);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 14);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidNatives);

	int StartPronghornID=rmCreateObjectDef("starting pronghorn");
	rmAddObjectDefItem(StartPronghornID, "pronghorn", 4, 4.0);
	rmSetObjectDefMinDistance(StartPronghornID, 5);
	rmSetObjectDefMaxDistance(StartPronghornID, 12);
	rmAddObjectDefConstraint(StartPronghornID, avoidStartResource);
	rmAddObjectDefConstraint(StartPronghornID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartPronghornID, avoidNatives);
	rmSetObjectDefCreateHerd(StartPronghornID, true);

	// -------------Done defining objects
   // Text
   rmSetStatusText("",0.10);

   // *** Set up player starting locations. Circular around the outside of the map.
   // rmPlacePlayersCircular(0.1, 0.9, rmDegreesToRadians(5.0));
	if ( cNumberTeams == 2 )
	{
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.15, 0.35);
		if (cNumberNonGaiaPlayers >6)
		{
			rmSetPlacementSection(0.13, 0.37);
		}
		rmPlacePlayersCircular(0.35, 0.40, 0.0);

		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.65, 0.85);
		if (cNumberNonGaiaPlayers >6)
		{
			rmSetPlacementSection(0.63, 0.87);
		}
		rmPlacePlayersCircular(0.35, 0.40, 0.0);
	}
	else
	{
  		rmSetPlacementSection(0.0, 0.95);
		rmPlacePlayersCircular(0.40, 0.42, 0.0);
	}

   // Build an invisible "west desert" area.
   int westDesertID = rmCreateArea("west desert");
   rmSetAreaLocation(westDesertID, 0, 1.0); 
   rmSetAreaWarnFailure(westDesertID, false);
   rmSetAreaSize(westDesertID, 0.4, 0.4);
   rmSetAreaCoherence(westDesertID, 0.1);
   //rmAddAreaInfluenceSegment(westDesertID, 0.0, 0.1, 0.75, 0.9);
   rmSetAreaTerrainType(westDesertID, "texas\ground4_tex");
	rmAddAreaTerrainLayer(westDesertID, "texas\ground1_tex", 0, 4);
   rmAddAreaTerrainLayer(westDesertID, "texas\ground2_tex", 4, 10);
   rmAddAreaTerrainLayer(westDesertID, "texas\ground3_tex", 10, 16);
   rmSetAreaObeyWorldCircleConstraint(westDesertID, false);
	rmSetAreaMix(westDesertID, "texas_dirt");
   rmBuildArea(westDesertID);

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
		rmSetAreaTerrainType(id, "texas\ground2");
      rmSetAreaWarnFailure(id, false);
   }

	// Create a center area.
   int centerID=rmCreateArea("center");
   rmSetAreaSize(centerID, 0.05, 0.05);
   rmSetAreaLocation(centerID, 0.5, 0.5);
   rmAddAreaToClass(centerID, rmClassID("center"));

   // Build the areas.
   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.20);

 	// Placement order
	// Trade Route -> Players and player stuff -> Natives -> Secrets -> Cliffs -> Nuggets
	// Place other objects that were defined earlier

	// DAL added - two trade routes placed
	int tradeRouteID = rmCreateTradeRoute();
	// rmAddTradeRouteWaypoint(tradeRouteID, 0.1, 0.9);
	// rmAddTradeRouteWaypoint(tradeRouteID, 0.4, 0.6);
	// rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.4);

	// NOTE: weird conditional stuff in trade route waypoint location is
	// to account for weird edge cases in FFA games where sometimes TCs wouldn't place.
	if ( cNumberTeams == 2 )
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.8, 1.0);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 1.0);
	}
	rmAddTradeRouteWaypoint(tradeRouteID, 0.8, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.35);
	if ( cNumberTeams == 2 )
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.8, 0.0);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.0);
	}
	// rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.8, 1.0, 8, 8);

	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");

	if(placedTradeRoute == false)
		rmEchoError("Failed to place trade route #1");

	// float tradeRouteLoc2 = rmRandFloat(0,1);
	int tradeRouteID2 = rmCreateTradeRoute();
	if ( cNumberTeams == 2 )
	{
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.2, 0.0);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.15, 0.0);
	}
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.35, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.35, 0.65);
	if ( cNumberTeams == 2 )
	{
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.2, 1.0);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.15, 1.0);
	}
	
	bool placedTradeRoute2 = rmBuildTradeRoute(tradeRouteID2, "carolinas\trade_route");
	if(placedTradeRoute2 == false)
		rmEchoError("Failed to place trade route #2");

	// Trade sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 6.0);

   // add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.30);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.60);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID2);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.30);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.60);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // Text
   rmSetStatusText("",0.30);
	
   /*
   // Second set of poles
   poleLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.3);
   rmPlaceObjectDefAtPoint(poleID, 0, poleLoc);

   poleLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.6);
   rmPlaceObjectDefAtPoint(poleID, 0, poleLoc);
   */
	
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 5.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);

	int startingTCID= rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
		// Give it a little wiggle room for maps with greater than four players
		if ( cNumberNonGaiaPlayers > 4 )
		{
			rmSetObjectDefMinDistance(startingTCID, 0.0);
			rmSetObjectDefMaxDistance(startingTCID, 6.0);
		}
	}

	int StartBerryBushID=rmCreateObjectDef("starting berry bush");
	rmAddObjectDefItem(StartBerryBushID, "BerryBush", 2, 4.0);
	rmSetObjectDefMinDistance(StartBerryBushID, 12.0);
	rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
	rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
	
   int playerBisonID=rmCreateObjectDef("player bison herd");
   rmAddObjectDefItem(playerBisonID, "bison", rmRandInt(6,8), 6.0);
   rmSetObjectDefMinDistance(playerBisonID, 40.0);
   rmSetObjectDefMaxDistance(playerBisonID, 45.0);
	rmAddObjectDefConstraint(playerBisonID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerBisonID, avoidImportantItem);
	rmSetObjectDefCreateHerd(playerBisonID, true);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
    rmSetObjectDefMinDistance(playerNuggetID, 30.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteCliff);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	// rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);

	int startingOutpostID=rmCreateObjectDef("Starting Outpost");
   rmAddObjectDefItem(startingOutpostID, "Outpost", 1, 0.0);
   rmSetObjectDefMinDistance(startingOutpostID, 20.0);
   rmSetObjectDefMaxDistance(startingOutpostID, 22.0);
   rmAddObjectDefToClass(startingOutpostID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(startingOutpostID, avoidOutpost);
	rmAddObjectDefConstraint(startingOutpostID, avoidTradeRoute);
	rmAddObjectDefConstraint(startingOutpostID, avoidImportantItem);
   // rmPlaceObjectDefPerPlayer(startingOutpostID, true, 4);

  int startingOutpostAsianID=rmCreateObjectDef("Starting Asian Outpost");
  rmAddObjectDefItem(startingOutpostAsianID, "ypOutpostAsian", 1, 0.0);
  rmSetObjectDefMinDistance(startingOutpostAsianID, 20.0);
  rmSetObjectDefMaxDistance(startingOutpostAsianID, 22.0);
  rmAddObjectDefToClass(startingOutpostAsianID, rmClassID("importantItem"));
  rmAddObjectDefConstraint(startingOutpostAsianID, avoidOutpostAsian);
	rmAddObjectDefConstraint(startingOutpostAsianID, avoidTradeRoute);
	rmAddObjectDefConstraint(startingOutpostAsianID, avoidImportantItem);
  // rmPlaceObjectDefPerPlayer(startingOutpostID, true, 4);

	int startingBarracksID=rmCreateObjectDef("Starting Barracks");
   rmAddObjectDefItem(startingBarracksID, "barracks", 1, 0.0);
   rmSetObjectDefMinDistance(startingBarracksID, 18.0);
   rmSetObjectDefMaxDistance(startingBarracksID, 24.0);
   rmAddObjectDefToClass(startingBarracksID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(startingBarracksID, avoidOutpostBarracks);
	rmAddObjectDefConstraint(startingBarracksID, avoidTradeRoute);
	rmAddObjectDefConstraint(startingBarracksID, avoidImportantItem);
   // rmPlaceObjectDefPerPlayer(startingBarracksID, true, 4);

	int startingBlockhouseID=rmCreateObjectDef("Starting Blockhouse");
   rmAddObjectDefItem(startingBlockhouseID, "Blockhouse", 1, 0.0);
   rmSetObjectDefMinDistance(startingBlockhouseID, 20.0);
   rmSetObjectDefMaxDistance(startingBlockhouseID, 22.0);
   rmAddObjectDefToClass(startingBlockhouseID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(startingBlockhouseID, avoidBlockhouse);
	rmAddObjectDefConstraint(startingBlockhouseID, avoidTradeRoute);
	rmAddObjectDefConstraint(startingBlockhouseID, avoidImportantItem);

	int startingWarHutID=rmCreateObjectDef("Starting War Hut");
   rmAddObjectDefItem(startingWarHutID, "WarHut", 1, 0.0);
   rmSetObjectDefMinDistance(startingWarHutID, 20.0);
   rmSetObjectDefMaxDistance(startingWarHutID, 22.0);
   rmAddObjectDefToClass(startingWarHutID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(startingWarHutID, avoidWarHut);
	rmAddObjectDefConstraint(startingWarHutID, avoidTradeRoute);
	rmAddObjectDefConstraint(startingWarHutID, avoidImportantItem);
  
  int startingBanshoID=rmCreateObjectDef("Starting Bansho");
  rmAddObjectDefItem(startingBanshoID, "ypBarracksJapanese", 1, 0.0);
  rmSetObjectDefMinDistance(startingBanshoID, 20.0);
  rmSetObjectDefMaxDistance(startingBanshoID, 22.0);
  rmAddObjectDefToClass(startingBanshoID, rmClassID("importantItem"));
  rmAddObjectDefConstraint(startingBanshoID, avoidOutpostAsian);
	rmAddObjectDefConstraint(startingBanshoID, avoidTradeRoute);
	rmAddObjectDefConstraint(startingBanshoID, avoidImportantItem);
  
  int startingWarAcademyID=rmCreateObjectDef("Starting War Academy");
  rmAddObjectDefItem(startingWarAcademyID, "ypWarAcademy", 1, 0.0);
  rmSetObjectDefMinDistance(startingWarAcademyID, 20.0);
  rmSetObjectDefMaxDistance(startingWarAcademyID, 22.0);
  rmAddObjectDefToClass(startingWarAcademyID, rmClassID("importantItem"));
  rmAddObjectDefConstraint(startingWarAcademyID, avoidOutpostAsian);
	rmAddObjectDefConstraint(startingWarAcademyID, avoidTradeRoute);
	rmAddObjectDefConstraint(startingWarAcademyID, avoidImportantItem);
  
  int startingStockadeID=rmCreateObjectDef("Starting Stockade");
  rmAddObjectDefItem(startingStockadeID, "ypBarracksIndian", 1, 0.0);
  rmSetObjectDefMinDistance(startingStockadeID, 20.0);
  rmSetObjectDefMaxDistance(startingStockadeID, 22.0);
  rmAddObjectDefToClass(startingStockadeID, rmClassID("importantItem"));
  rmAddObjectDefConstraint(startingStockadeID, avoidOutpostAsian);
	rmAddObjectDefConstraint(startingStockadeID, avoidTradeRoute);
	rmAddObjectDefConstraint(startingStockadeID, avoidImportantItem);

	int playerGoldID=rmCreateObjectDef("player silver ore");
	int silverType = rmRandInt(1,10);
	
	// Player placement
	for(i=1; <cNumberPlayers)
	{
		// DAL - taking out the starting fort for now.
		/*
		if(rmGetPlayerCiv(i) == rmGetCivID("Russians"))
		{
			rmPlaceGroupingAtLoc(playerFortIDRussian, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		}
		else
		{
			rmPlaceGroupingAtLoc(playerFortID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));`
		}
		*/
		
		// Place starting units and a TC!
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Place extra buildings, unless nomad start.
		if ( rmGetNomadStart() == false )
		{
			// Russians place two blockhouses
			if ( rmGetPlayerCiv(i) == rmGetCivID("Russians"))
			{
				rmPlaceObjectDefAtLoc(startingBlockhouseID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingBlockhouseID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			}
      
      // Asians get two outposts and their starter barracks
      else if (rmGetPlayerCiv(i) == rmGetCivID("Chinese")) {
        rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingWarAcademyID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      }
      
      else if (rmGetPlayerCiv(i) == rmGetCivID("Japanese")) {
        rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingBanshoID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      }
      
      else if (rmGetPlayerCiv(i) == rmGetCivID("Indians")) {
        rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingStockadeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      }
      
			// Native civs place two war huts.
			else if ( rmGetPlayerCiv(i) ==  rmGetCivID("XPIroquois") ||
						rmGetPlayerCiv(i) ==  rmGetCivID("XPSioux") ||
						rmGetPlayerCiv(i) ==  rmGetCivID("XPAztec"))
			{
				rmPlaceObjectDefAtLoc(startingWarHutID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingWarHutID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			}
			// Everyone else: two outposts and a barracks.
			else
			{
				rmPlaceObjectDefAtLoc(startingOutpostID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingOutpostID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingBarracksID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			}
		}

		rmPlaceObjectDefAtLoc(StartBerryBushID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Place starting resources - DAL
		rmPlaceObjectDefAtLoc(StartPronghornID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets two ore groupings, one pretty close, the other a little further away.
		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, coinAvoidCoin);
		rmAddObjectDefConstraint(playerGoldID, avoidCliffs);
		rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
		rmSetObjectDefMinDistance(playerGoldID, 25.0);
		rmSetObjectDefMaxDistance(playerGoldID, 30.0);
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver further "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, coinAvoidCoin);
		rmAddObjectDefConstraint(playerGoldID, avoidCliffs);
		rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
		rmSetObjectDefMinDistance(playerGoldID, 40.0);
		rmSetObjectDefMaxDistance(playerGoldID, 50.0);
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets two bison herds..
		rmPlaceObjectDefAtLoc(playerBisonID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerBisonID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Player nuggets.
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		vector closestPoint=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
	}
	// Text
	rmSetStatusText("",0.40);

	// Text
	int numTries = -1;
	int failCount = -1;

	// Central Pond
	int pondClass=rmDefineClass("pond");
   int pondConstraint=rmCreateClassDistanceConstraint("things avoid the pond", rmClassID("pond"), 20.0);
   int smallPondID=rmCreateArea("small pond");
  rmEchoInfo("Variation2 = " + whichVariation);
	if ( whichVariation == 4 || whichVariation > 8 )
	{
		rmSetAreaSize(smallPondID, rmAreaTilesToFraction(600), rmAreaTilesToFraction(700));
		rmSetAreaWaterType(smallPondID, "texas pond");
		rmSetAreaBaseHeight(smallPondID, 4);
		rmSetAreaMinBlobs(smallPondID, 1);
		rmSetAreaMaxBlobs(smallPondID, 4);
		rmSetAreaMinBlobDistance(smallPondID, 5.0);
		rmSetAreaMaxBlobDistance(smallPondID, 30.0);
		rmAddAreaToClass(smallPondID, pondClass);
		rmSetAreaCoherence(smallPondID, 0.5);
		rmSetAreaSmoothDistance(smallPondID, 5);
		rmAddAreaConstraint(smallPondID, playerConstraint);
		rmAddAreaConstraint(smallPondID, avoidTradeRoute);
		rmAddAreaConstraint(smallPondID, avoidImportantItem);
		rmSetAreaWarnFailure(smallPondID, false);
		rmSetAreaLocation(smallPondID, 0.5, 0.5); 
		rmBuildArea(smallPondID);
	}
 
	// Define and place the Native Villages and Secrets of the New World
	// Text
	rmSetStatusText("",0.50);

	float NativeVillageLoc = rmRandFloat(0,1);
	float ComancheVillageLoc = rmRandFloat(0,1);

	// Comanche, Iroquois, Aztec rules (DAL - these are stub for now...)
	if (subCiv0 == rmGetCivID("Comanche"))
	{  
		int comancheVillageID = -1;
		int comancheVillageType = rmRandInt(1,3);
		if ( whichVariation == 1 || whichVariation == 5 || whichVariation == 6 )
		{
			comancheVillageID = rmCreateGrouping("comanche village A", "native comanche village "+comancheVillageType);
			rmSetGroupingMinDistance(comancheVillageID, 0.0);
			rmSetGroupingMaxDistance(comancheVillageID, 0.0);
			rmAddGroupingConstraint(comancheVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(comancheVillageID, avoidTradeRoute);
			rmAddGroupingToClass(comancheVillageID, rmClassID("natives"));
			rmAddGroupingToClass(comancheVillageID, rmClassID("importantItem"));
			rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.5, 0.5);
		}
	}
	else		// Apache
	{
		int apacheVillageID = -1;
		int apacheVillageType = rmRandInt(1,3);
		if ( whichVariation == 1 || whichVariation == 5 || whichVariation == 6 )
		{
			apacheVillageID = rmCreateGrouping("apache village A", "native apache village "+apacheVillageType);
			rmSetGroupingMinDistance(apacheVillageID, 0.0);
			rmSetGroupingMaxDistance(apacheVillageID, 0.0);
			rmAddGroupingConstraint(apacheVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(apacheVillageID, avoidTradeRoute);
			rmAddGroupingToClass(apacheVillageID, rmClassID("natives"));
			rmAddGroupingToClass(apacheVillageID, rmClassID("importantItem"));
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.5, 0.5);
		}
	}

	
	if (subCiv1 == rmGetCivID("Comanche"))
	{
		int comancheVillageBID = -1;
		comancheVillageType = rmRandInt(1,3);
		comancheVillageBID = rmCreateGrouping("comanche village B", "native comanche village "+comancheVillageType);
		rmSetGroupingMinDistance(comancheVillageBID, 0.0);
		rmSetGroupingMaxDistance(comancheVillageBID, 0.1);
		rmAddGroupingConstraint(comancheVillageBID, avoidImpassableLand);
		rmAddGroupingToClass(comancheVillageBID, rmClassID("natives"));
		rmAddGroupingToClass(comancheVillageBID, rmClassID("importantItem"));
		rmAddGroupingConstraint(comancheVillageBID, avoidImportantItem);
		rmAddGroupingConstraint(comancheVillageBID, avoidTradeRoute);

		if ( whichVariation > 4 )
		{
			if (NativeVillageLoc < 0.5)
			{
				rmPlaceGroupingAtLoc(comancheVillageBID, 0, 0.5, 0.25);
			}
			else
			{
				rmPlaceGroupingAtLoc(comancheVillageBID, 0, 0.5, 0.75);
			}
		}
		else
		{
			if (NativeVillageLoc < 0.5)
			{
				rmPlaceGroupingAtLoc(comancheVillageBID, 0, 0.1, 0.5);
			}
			else
			{
				rmPlaceGroupingAtLoc(comancheVillageBID, 0, 0.9, 0.5);
			}
		}
	}
	else	// Apache
	{
		int apacheVillageBID = -1;
		apacheVillageType = rmRandInt(1,3);
		apacheVillageBID = rmCreateGrouping("apache village B", "native apache village "+apacheVillageType);
		rmSetGroupingMinDistance(apacheVillageBID, 0.0);
		rmSetGroupingMaxDistance(apacheVillageBID, 0.1);
		rmAddGroupingConstraint(apacheVillageBID, avoidImpassableLand);
		rmAddGroupingToClass(apacheVillageBID, rmClassID("natives"));
		rmAddGroupingToClass(apacheVillageBID, rmClassID("importantItem"));
		rmAddGroupingConstraint(apacheVillageBID, avoidImportantItem);
		rmAddGroupingConstraint(apacheVillageBID, avoidTradeRoute);

		if ( whichVariation > 4 )
		{
			if (NativeVillageLoc < 0.5)
			{
				rmPlaceGroupingAtLoc(apacheVillageBID, 0, 0.5, 0.25);
			}
			else
			{
				rmPlaceGroupingAtLoc(apacheVillageBID, 0, 0.5, 0.75);
			}
		}
		else
		{
			if (NativeVillageLoc < 0.5)
			{
				rmPlaceGroupingAtLoc(apacheVillageBID, 0, 0.1, 0.5);
			}
			else
			{
				rmPlaceGroupingAtLoc(apacheVillageBID, 0, 0.9, 0.5);
			}
		}
	}

	if (subCiv2 == rmGetCivID("Comanche"))
	{
		int comancheVillageCID = -1;
		comancheVillageType = rmRandInt(1,3);
		comancheVillageCID = rmCreateGrouping("comanche village C", "native comanche village "+comancheVillageType);
		rmSetGroupingMinDistance(comancheVillageCID, 0.0);
		rmSetGroupingMaxDistance(comancheVillageCID, 0.1);
		rmAddGroupingConstraint(comancheVillageCID, avoidImpassableLand);
		rmAddGroupingToClass(comancheVillageCID, rmClassID("natives"));
		rmAddGroupingToClass(comancheVillageCID, rmClassID("importantItem"));
		rmAddGroupingConstraint(comancheVillageCID, avoidImportantItem);
		rmAddGroupingConstraint(comancheVillageCID, avoidTradeRoute);

		if ( whichVariation > 4 )
		{
			if (NativeVillageLoc < 0.5)
			{
				rmPlaceGroupingAtLoc(comancheVillageCID, 0, 0.5, 0.75);
			}
			else
			{
				rmPlaceGroupingAtLoc(comancheVillageCID, 0, 0.5, 0.25);
			}
		}
		else
		{
			if (NativeVillageLoc < 0.5)
			{
				rmPlaceGroupingAtLoc(comancheVillageCID, 0, 0.9, 0.5);
			}
			else
			{
				rmPlaceGroupingAtLoc(comancheVillageCID, 0, 0.1, 0.5);
			}
		}
	}
	else	// Apache
	{
		int apacheVillageCID = -1;
		apacheVillageType = rmRandInt(1,3);
		apacheVillageCID = rmCreateGrouping("apache village C", "native apache village "+apacheVillageType);
		rmSetGroupingMinDistance(apacheVillageCID, 0.0);
		rmSetGroupingMaxDistance(apacheVillageCID, 0.1);
		rmAddGroupingConstraint(apacheVillageCID, avoidImpassableLand);
		rmAddGroupingToClass(apacheVillageCID, rmClassID("natives"));
		rmAddGroupingToClass(apacheVillageCID, rmClassID("importantItem"));
		rmAddGroupingConstraint(apacheVillageCID, avoidImportantItem);
		rmAddGroupingConstraint(apacheVillageCID, avoidTradeRoute);

		if ( whichVariation > 4 )
		{
			if (NativeVillageLoc < 0.5)
			{
				rmPlaceGroupingAtLoc(apacheVillageCID, 0, 0.5, 0.75);
			}
			else
			{
				rmPlaceGroupingAtLoc(apacheVillageCID, 0, 0.5, 0.25);
			}
		}
		else
		{
			if (NativeVillageLoc < 0.5)
			{
				rmPlaceGroupingAtLoc(apacheVillageCID, 0, 0.9, 0.5);
			}
			else
			{
				rmPlaceGroupingAtLoc(apacheVillageCID, 0, 0.1, 0.5);
			}
		}
	}

	// Two extra silver mines in the spots where the natives aren't.
	silverType = rmRandInt(1,10);
	int extraGoldID = rmCreateObjectDef("extra silver "+i);
	rmAddObjectDefItem(extraGoldID, "mine", 1, 0.0);
	rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
	rmAddObjectDefConstraint(extraGoldID, avoidCoin);
	rmAddObjectDefConstraint(extraGoldID, avoidCliffs);
	rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);

	rmSetObjectDefMinDistance(extraGoldID, 0.0);
	rmSetObjectDefMaxDistance(extraGoldID, 10.0);
	
	if ( whichVariation > 4 )
	{
		rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.9, 0.5);
		rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.1, 0.5);
	}
	else
	{
		rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.8);
		rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.2);
	}

	// Define and place cliffs
	numTries=cNumberNonGaiaPlayers*2;
	failCount=0;
	for(i=0; <numTries)
	{
		int cliffEastID=rmCreateArea("cliff east"+i);
	   rmSetAreaSize(cliffEastID, rmAreaTilesToFraction(350), rmAreaTilesToFraction(400));  // DAL - larger cliffs?
		rmSetAreaWarnFailure(cliffEastID, false);
		rmSetAreaCliffType(cliffEastID, "Texas Grass");
		rmAddAreaToClass(cliffEastID, rmClassID("classCliff"));	// Attempt to keep cliffs away from each other.
		rmSetAreaCliffEdge(cliffEastID, 2, 0.4, 0.1, 1.0, 0);
		rmSetAreaCliffPainting(cliffEastID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffEastID, 7, 1.0, 1.0);
		rmSetAreaHeightBlend(cliffEastID, 1);
		rmAddAreaTerrainLayer(cliffEastID, "texas\ground2_tex", 0, 2);

		rmSetAreaObeyWorldCircleConstraint(cliffEastID, false);
		rmAddAreaConstraint(cliffEastID, cliffsAvoidCliffs);				// Avoid cliffs, please!
		rmAddAreaConstraint(cliffEastID, playerConstraint);		// Keep cliffs away from the player.
		rmAddAreaConstraint(cliffEastID, avoidImportantItem);
		rmAddAreaConstraint(cliffEastID, avoidTradeRouteCliff);
		rmAddAreaConstraint(cliffEastID, avoidCoin);
		rmAddAreaConstraint(cliffEastID, avoidNatives);
		rmAddAreaConstraint(cliffEastID, pondConstraint);
		rmAddAreaConstraint(cliffEastID, Eastward);					// Go East, Mr. Cliff.
		rmSetAreaMinBlobs(cliffEastID, 2);
		rmSetAreaMaxBlobs(cliffEastID, 4);
		rmSetAreaMinBlobDistance(cliffEastID, 10.0);
		rmSetAreaMaxBlobDistance(cliffEastID, 20.0);
		rmSetAreaCoherence(cliffEastID, 0.2);
		rmSetAreaSmoothDistance(cliffEastID, 30);						// DAL - used to be 10
		rmSetAreaCoherence(cliffEastID, 0.25);

		if(rmBuildArea(cliffEastID)==false)
		{
			// Stop trying once we fail 3 times in a row
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}

	for(i=0; <numTries)
	{
		int cliffWestID=rmCreateArea("cliff west"+i);
	   rmSetAreaSize(cliffWestID, rmAreaTilesToFraction(350), rmAreaTilesToFraction(400));  // DAL - larger cliffs?
		rmSetAreaWarnFailure(cliffWestID, false);
		rmSetAreaCliffType(cliffWestID, "Texas");
		rmAddAreaToClass(cliffWestID, rmClassID("classCliff"));	// Attempt to keep cliffs away from each other.
		rmSetAreaCliffEdge(cliffWestID, 2, 0.4, 0.1, 1.0, 0);
		rmSetAreaCliffPainting(cliffWestID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffWestID, 7, 1.0, 1.0);
		rmSetAreaHeightBlend(cliffWestID, 1);
		rmAddAreaTerrainLayer(cliffWestID, "texas\ground2_tex", 0, 2);

		rmSetAreaObeyWorldCircleConstraint(cliffWestID, false);
		rmAddAreaConstraint(cliffWestID, cliffsAvoidCliffs);			// Avoid cliffs, please!
		rmAddAreaConstraint(cliffWestID, playerConstraint);	// Keep cliffs away from the player.
		rmAddAreaConstraint(cliffWestID, avoidImportantItem);
		rmAddAreaConstraint(cliffWestID, avoidCoin);
		rmAddAreaConstraint(cliffWestID, avoidNatives);
		rmAddAreaConstraint(cliffWestID, pondConstraint);
		rmAddAreaConstraint(cliffWestID, avoidTradeRouteCliff);
		rmAddAreaConstraint(cliffWestID, Westward);				// Go West, Mr. Cliff.
		rmSetAreaMinBlobs(cliffWestID, 2);
		rmSetAreaMaxBlobs(cliffWestID, 4);
		rmSetAreaMinBlobDistance(cliffWestID, 10.0);
		rmSetAreaMaxBlobDistance(cliffWestID, 20.0);
		rmSetAreaCoherence(cliffWestID, 0.2);
		rmSetAreaSmoothDistance(cliffWestID, 30);	// DAL - used to be 10
		rmSetAreaCoherence(cliffWestID, 0.25);

		if(rmBuildArea(cliffWestID)==false)
		{
			// Stop trying once we fail 3 times in a row
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}

	// Text
	rmSetStatusText("",0.60);

	// Place some extra small-ish Pronghorn herds.  // DAL
   int pronghornHerdID=rmCreateObjectDef("pronghorn herd edge");
   rmAddObjectDefItem(pronghornHerdID, "pronghorn", rmRandInt(2,4), 6.0);
   rmSetObjectDefMinDistance(pronghornHerdID, 0.5);
   rmSetObjectDefMaxDistance(pronghornHerdID, rmXFractionToMeters(0.9));
	rmAddObjectDefConstraint(pronghornHerdID, centerConstraintFar);
	rmAddObjectDefConstraint(pronghornHerdID, longPlayerConstraint);
	rmSetObjectDefCreateHerd(pronghornHerdID, true);
	numTries=cNumberNonGaiaPlayers*2;

	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(pronghornHerdID, 0, 0.5, 0.5);
	}
	
	// Define and place forests - north and south
	int forestTreeID = 0;
	
	numTries=5*cNumberNonGaiaPlayers;  // DAL - 5 here, 5 below
	failCount=0;
	for (i=0; <numTries)
		{   
			int westForest=rmCreateArea("westForest"+i);
			rmSetAreaWarnFailure(westForest, false);
			rmSetAreaSize(westForest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(150));
			rmSetAreaForestType(westForest, "texas forest dirt");
			rmSetAreaForestDensity(westForest, 0.7);
			rmSetAreaForestClumpiness(westForest, 0.4);
			rmSetAreaForestUnderbrush(westForest, 0.0);
			rmSetAreaMinBlobs(westForest, 1);
			rmSetAreaMaxBlobs(westForest, 3);
			rmSetAreaMinBlobDistance(westForest, 5.0);
			rmSetAreaMaxBlobDistance(westForest, 20.0);
			rmSetAreaCoherence(westForest, 0.4);
			rmSetAreaSmoothDistance(westForest, 10);
			rmAddAreaConstraint(westForest, avoidImportantItem);		   // DAL added, to try and make sure natives got on the map w/o override.
			rmAddAreaConstraint(westForest, avoidCoin);
			rmAddAreaConstraint(westForest, playerConstraintForest);		// DAL adeed, to keep forests away from the player.
			rmAddAreaConstraint(westForest, forestConstraint);				// DAL adeed, to keep forests away from each other.
			rmAddAreaConstraint(westForest, Westward);						// DAL adeed, to keep these forests in the west.
			rmAddAreaConstraint(westForest, avoidTradeRoute);
			rmAddAreaConstraint(westForest, avoidCliffs);
			rmAddAreaConstraint(westForest, forestsAvoidBison);
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

	numTries=5*cNumberNonGaiaPlayers;  // DAL - 5 here, 5 above.
	failCount=0;
	for (i=0; <numTries)
		{   
			int eastForest=rmCreateArea("eastForest"+i);
			rmSetAreaWarnFailure(eastForest, false);
			rmSetAreaSize(eastForest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(150));
			rmSetAreaForestType(eastForest, "texas forest");
			rmSetAreaForestDensity(eastForest, 0.7);
			rmSetAreaForestClumpiness(eastForest, 0.4);
			rmSetAreaForestUnderbrush(eastForest, 0.0);
			rmSetAreaMinBlobs(eastForest, 1);
			rmSetAreaMaxBlobs(eastForest, 3);
			rmSetAreaMinBlobDistance(eastForest, 5.0);
			rmSetAreaMaxBlobDistance(eastForest, 20.0);
			rmSetAreaCoherence(eastForest, 0.4);
			rmSetAreaSmoothDistance(eastForest, 10);
			rmAddAreaConstraint(eastForest, avoidImportantItem);			// DAL added, to try and make sure natives got on the map w/o override.
			rmAddAreaConstraint(eastForest, avoidCoin);
			rmAddAreaConstraint(eastForest, playerConstraintForest);		// DAL adeed, to keep forests away from the player.
			rmAddAreaConstraint(eastForest, forestConstraint);				// DAL adeed, to keep forests away from each other.
			rmAddAreaConstraint(eastForest, Eastward);						// DAL adeed, to keep these forests in the east.
			rmAddAreaConstraint(eastForest, avoidTradeRoute);
			rmAddAreaConstraint(eastForest, avoidCliffs);
			rmAddAreaConstraint(eastForest, forestsAvoidBison);
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
	// Text
	rmSetStatusText("",0.70);

	// More coin in the middle
   int middleMineType = -1;
   int middleMineID = -1;
   
   for(i=0; < 2)
   {
	   middleMineType = rmRandInt(1,4);
      middleMineID = rmCreateObjectDef("center middleMine "+i);
	  rmAddObjectDefItem(middleMineID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(middleMineID, 0.0);
      rmSetObjectDefMaxDistance(middleMineID, rmXFractionToMeters(0.10));
		rmAddObjectDefConstraint(middleMineID, coinAvoidCoin);
		rmAddObjectDefConstraint(middleMineID, avoidImportantItem);
      rmAddObjectDefConstraint(middleMineID, avoidImpassableLand);
      rmAddObjectDefConstraint(middleMineID, avoidTradeRoute);
		rmAddObjectDefConstraint(middleMineID, avoidAll);
		rmAddObjectDefConstraint(middleMineID, avoidCliffs);
		rmPlaceObjectDefAtLoc(middleMineID, 0, 0.5, 0.5);
   }

   for(i=0; < 2)
   {
	   middleMineType = rmRandInt(1,4);
	   middleMineID = rmCreateObjectDef("south middleMine "+i);
      rmAddObjectDefItem(middleMineID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(middleMineID, 0.0);
      rmSetObjectDefMaxDistance(middleMineID, rmXFractionToMeters(0.10));
		rmAddObjectDefConstraint(middleMineID, coinAvoidCoin);
		rmAddObjectDefConstraint(middleMineID, avoidImportantItem);
      rmAddObjectDefConstraint(middleMineID, avoidImpassableLand);
      rmAddObjectDefConstraint(middleMineID, avoidTradeRoute);
		rmAddObjectDefConstraint(middleMineID, avoidAll);
		rmAddObjectDefConstraint(middleMineID, avoidCliffs);
		rmPlaceObjectDefAtLoc(middleMineID, 0, 0.5, 0.2);
   }

   for(i=0; < 2)
   {
	   middleMineType = rmRandInt(1,4);
      middleMineID = rmCreateObjectDef("north middleMine "+i);
	  rmAddObjectDefItem(middleMineID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(middleMineID, 0.0);
      rmSetObjectDefMaxDistance(middleMineID, rmXFractionToMeters(0.10));
		rmAddObjectDefConstraint(middleMineID, coinAvoidCoin);
		rmAddObjectDefConstraint(middleMineID, avoidImportantItem);
      rmAddObjectDefConstraint(middleMineID, avoidImpassableLand);
      rmAddObjectDefConstraint(middleMineID, avoidTradeRoute);
		rmAddObjectDefConstraint(middleMineID, avoidAll);
		rmAddObjectDefConstraint(middleMineID, avoidCliffs);
		rmPlaceObjectDefAtLoc(middleMineID, 0, 0.5, 0.8);
   }

	// */
	
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
    
    int randLoc = rmRandInt(1,3);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.05;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("YLOC = "+yLoc);
  }
  
  // Define and place Nuggets
  
	int nuggetID = 0;
	rmSetNuggetDifficulty(1, 3);
	for(i=0; <cNumberNonGaiaPlayers*2)
	{
		nuggetID= rmCreateObjectDef("nugget "+i); 
		rmAddObjectDefItem(nuggetID, "nugget", 1, 0.0);
		// DAL - removing cougars; these are now automagically placed by the nuggets.
		/*
		if(rmRandFloat(0,1) < 0.66)
		{
			rmAddObjectDefItem(nuggetID, "Cougar", 2, 3.0);
		}
		else
		{
			rmAddObjectDefItem(nuggetID, "Cougar", 3, 3.0);
		}
		*/
		rmSetObjectDefMinDistance(nuggetID, 0.0);
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nuggetID, playerConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
		rmAddObjectDefToClass(nuggetID, rmClassID("importantItem"));
		rmAddObjectDefToClass(nuggetID, rmClassID("nuggets"));
		rmAddObjectDefConstraint(nuggetID, avoidResource);
		rmAddObjectDefConstraint(nuggetID, avoidImportantItem);
		rmAddObjectDefConstraint(nuggetID, avoidNugget);
		rmAddObjectDefConstraint(nuggetID, avoidStartingUnitsLarge);
		rmAddObjectDefConstraint(nuggetID, avoidCoin);
		rmAddObjectDefConstraint(nuggetID, pondConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetID, circleConstraint);
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5);
	}

	// Text
	rmSetStatusText("",0.80);

	/*
	rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);
	*/

	// Text
	rmSetStatusText("",0.90);

   int cowID=rmCreateObjectDef("cow");
   rmAddObjectDefItem(cowID, "cow", 2, 4.0);
   rmSetObjectDefMinDistance(cowID, 0.0);
   rmSetObjectDefMaxDistance(cowID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(cowID, avoidCow);
	rmAddObjectDefConstraint(cowID, avoidAll);
	rmAddObjectDefConstraint(cowID, playerConstraint);
	rmAddObjectDefConstraint(cowID, avoidCliffs);
   rmAddObjectDefConstraint(cowID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(cowID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);

	// Big decorative things
	int bigDecorationID=rmCreateObjectDef("Big Texas Things");
	int avoidBigDecoration=rmCreateTypeDistanceConstraint("avoid big decorations", "BigPropTexas", 25.0);
	rmAddObjectDefItem(bigDecorationID, "BigPropTexas", 1, 0.0);
	rmSetObjectDefMinDistance(bigDecorationID, 0.0);
	rmSetObjectDefMaxDistance(bigDecorationID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bigDecorationID, avoidAll);
	rmAddObjectDefConstraint(bigDecorationID, avoidImportantItem);
	rmAddObjectDefConstraint(bigDecorationID, avoidCoin);
	rmAddObjectDefConstraint(bigDecorationID, avoidImpassableLand);
	rmAddObjectDefConstraint(bigDecorationID, avoidBigDecoration);
	rmAddObjectDefConstraint(bigDecorationID, avoidCliffs);
	rmAddObjectDefConstraint(bigDecorationID, longPlayerConstraint);
	rmAddObjectDefConstraint(bigDecorationID, Westward);
	rmPlaceObjectDefAtLoc(bigDecorationID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	// Perching Vultures - add four somewhere.
	int vultureID=rmCreateObjectDef("perching vultures");
	int avoidVultures=rmCreateTypeDistanceConstraint("avoid other vultures", "PropVulturePerching", 30.0);
	rmAddObjectDefItem(vultureID, "PropVulturePerching", 1, 0.0);
	rmSetObjectDefMinDistance(vultureID, 0.0);
	rmSetObjectDefMaxDistance(vultureID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(vultureID, avoidAll);
	rmAddObjectDefConstraint(vultureID, avoidImportantItem);
	rmAddObjectDefConstraint(vultureID, avoidCoin);
	rmAddObjectDefConstraint(vultureID, avoidImpassableLand);
	rmAddObjectDefConstraint(vultureID, avoidTradeRoute);
	rmAddObjectDefConstraint(vultureID, avoidCliffs);
	rmAddObjectDefConstraint(vultureID, avoidBigDecoration);
	rmAddObjectDefConstraint(vultureID, avoidVultures);
	rmAddObjectDefConstraint(vultureID, longPlayerConstraint);
	rmPlaceObjectDefAtLoc(vultureID, 0, 0.5, 0.5, 4);

	// Text
	rmSetStatusText("",1.0);
	}
}  
