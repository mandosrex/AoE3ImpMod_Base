// PATAGONIA
// May 2004
// Nov 06 - YP update
// Based on the happy Saguenay map to start with.
//
// Main entry point for random map script

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

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

   // Picks the map size
   int playerTiles=12000;
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

	int whichVariation=-1;
	whichVariation = rmRandInt(1,2);

   // Picks a default water height
   rmSetSeaLevel(1.0);

   // Picks default terrain and water
	// rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
	rmSetMapElevationParameters(cElevTurbulence, 0.1, 4, 0.2, 3.0);
	rmSetSeaType("new england coast");
   rmEnableLocalWater(false);
	 rmSetBaseTerrainMix("patagonia_grass");
    rmTerrainInitialize("patagonia\ground_dirt1_pat", 4.0);
	rmSetMapType("patagonia");
	rmSetMapType("water");
	rmSetMapType("grass");
   rmSetLightingSet("patagonia");
	rmSetWorldCircleConstraint(true);

	// Choose mercs.
	chooseMercs();

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classCliff");
   rmDefineClass("classPatch");
   int classbigContinent=rmDefineClass("big continent");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("classWestForest");
   rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("bay");
	rmDefineClass("nuggets");
	rmDefineClass("socketClass");

	int lakeClass=rmDefineClass("lake");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("continent stays away from players", classPlayer, 24.0);

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
   int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 30.0);
   int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);

   // Bonus area constraint.
   int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classbigContinent, 20.0);

   // Resource avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
   int westForestConstraint=rmCreateClassDistanceConstraint("west forest vs. forest", rmClassID("classWestForest"), 35.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 40.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
   int avoidPlayerNugget=rmCreateTypeDistanceConstraint("player nugget avoid nugget", "AbstractNugget", 25.0);
   int avoidBighornSheep=rmCreateTypeDistanceConstraint("bighorn avoids bighorn", "deer", 35.0);
   int avoidMoose=rmCreateTypeDistanceConstraint("moose avoids moose", "Moose", 35.0);
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 15.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "beluga", 18.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 20.0);
	int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 60.0);
	int avoidFastCoinForest=rmCreateTypeDistanceConstraint("forests avoid fast coin", "gold", 10.0);
   int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
   int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

	int avoidLake=rmCreateClassDistanceConstraint("lake vs stuff", lakeClass, 30.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Starting units avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 20.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

   // Trade route avoidance.
   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 5.0);
	int avoidSocketCliff=rmCreateClassDistanceConstraint("cliffs avoid sockets by a lot", rmClassID("socketClass"), 10.0);
	int avoidSocketPlayer=rmCreateClassDistanceConstraint("cliffs avoid sockets by a lot more", rmClassID("socketClass"), 15.0);
   int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 50.0);
   int secretsAvoidSecrets = rmCreateClassDistanceConstraint("secrets avoid secrets", rmClassID("secrets"), 60.0);
   int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 30.0);

   // Constraint to avoid water.
   int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 8.0);

   // Cardinal Directions Constraints (handy!)
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

   // ships vs. ships
   int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 15.0);

    // New extra stuff for water spawn point avoidance.
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 20.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
	int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Text
   rmSetStatusText("",0.10);


	// int avoidBeach = rmCreateAreaDistanceConstraint("stay away from InnerLandID", InnerLandID, 4);

	// Create two Bay Areas.
   int bay1ID=rmCreateArea("Bay 1");
   rmSetAreaSize(bay1ID, 0.05, 0.05);
	rmSetAreaLocation(bay1ID, 1.0, 0.45);
	rmSetAreaWaterType(bay1ID, "hudson bay");
   rmSetAreaBaseHeight(bay1ID, 1.0); // Was 10
   rmSetAreaMinBlobs(bay1ID, 4);
   rmSetAreaMaxBlobs(bay1ID, 6);
   rmSetAreaMinBlobDistance(bay1ID, 5);
   rmSetAreaMaxBlobDistance(bay1ID, 30);
   rmSetAreaSmoothDistance(bay1ID, 50);
   rmSetAreaCoherence(bay1ID, 0.4);
	rmAddAreaToClass(bay1ID, rmClassID("bay"));
   rmSetAreaObeyWorldCircleConstraint(bay1ID, false);
	rmBuildArea(bay1ID);

   int bay2ID=rmCreateArea("Bay 2");
   rmSetAreaSize(bay2ID, 0.05, 0.05);
	rmSetAreaLocation(bay2ID, 0.55, 0.0);
	rmSetAreaWaterType(bay2ID, "hudson bay");
   rmSetAreaBaseHeight(bay2ID, 1.0); // Was 10
   rmSetAreaMinBlobs(bay2ID, 4);
   rmSetAreaMaxBlobs(bay2ID, 6);
   rmSetAreaMinBlobDistance(bay2ID, 5);
   rmSetAreaMaxBlobDistance(bay2ID, 30);
   rmSetAreaSmoothDistance(bay2ID, 50);
   rmSetAreaCoherence(bay2ID, 0.4);
	rmAddAreaToClass(bay2ID, rmClassID("bay"));
   rmSetAreaObeyWorldCircleConstraint(bay2ID, false);
   rmBuildArea(bay2ID);

   int bay3ID=rmCreateArea("Bay 3");
   rmSetAreaSize(bay3ID, 0.14, 0.14);
   rmSetAreaLocation(bay3ID, 1.0, 0.0);
	rmSetAreaWaterType(bay3ID, "hudson bay");
   rmSetAreaBaseHeight(bay3ID, 1.0); // Was 10
   rmSetAreaMinBlobs(bay3ID, 4);
   rmSetAreaMaxBlobs(bay3ID, 6);
   rmSetAreaMinBlobDistance(bay3ID, 5);
   rmSetAreaMaxBlobDistance(bay3ID, 30);
   rmSetAreaSmoothDistance(bay3ID, 50);
   rmSetAreaCoherence(bay3ID, 0.3);
	rmAddAreaToClass(bay3ID, rmClassID("bay"));
   rmSetAreaObeyWorldCircleConstraint(bay3ID, false);
   rmBuildArea(bay3ID);

   // Text
   rmSetStatusText("",0.20);

	/* DAL - the old way.	
   // DEFINE AREAS
   // Set up player starting locations. These are just used to place Caravels away from each other.
	rmSetPlacementSection(0.25, 0.5);
   rmSetTeamSpacingModifier(0.1);
   rmPlacePlayersCircular(0.45, 0.45, rmDegreesToRadians(5.0));

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
      rmSetAreaWarnFailure(id, false);
	   // rmSetAreaTerrainType(id, "carolina\marshflats");
      // rmSetAreaBaseHeight(id, 15.0);  
   }
   */
   // Placement order
   // Trade route -> Player Areas -> Lake -> Cliffs -> Nuggets
	// Two glorious trade routes
   int tradeRouteID = rmCreateTradeRoute();
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts 1");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.1);
   rmSetObjectDefAllowOverlap(socketID, true);

   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmAddObjectDefConstraint(socketID, circleConstraint);

   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 10.0);

   rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.15);						// DAL - 0.5, 1.0; 0.0, 0.5
   rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.05, 0.65, 10, 10);	// 0.15, 0.80

	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "grass");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route");

	// add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.1);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.4);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
   if ( cNumberNonGaiaPlayers < 4 )
   {
	   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
   }
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // Text
   rmSetStatusText("",0.30);

	// DEFINE Player Areas
   // Set up player starting locations. These are just used to place Caravels away from each other.
   /* DAL - old placement.
	rmSetPlacementSection(0.35, 0.65);
   rmSetTeamSpacingModifier(0.50);
   rmPlacePlayersCircular(0.45, 0.45, rmDegreesToRadians(5.0));
	*/

   if ( cNumberTeams == 2 )
   {
	   if ( rmGetNumberPlayersOnTeam(0) < 5 && rmGetNumberPlayersOnTeam(1) < 5)
	   {
			rmSetPlacementTeam(0);
			// rmPlacePlayersLine(0.46, 0.36, 0.3, 0.2, 0.0, 0.1);
			rmPlacePlayersLine(0.3, 0.25, 0.2, 0.55, 0.0, 0.1);

			rmSetPlacementTeam(1);
			// rmPlacePlayersLine(0.64, 0.54, 0.8, 0.7, 0.0, 0.1);
			rmPlacePlayersLine(0.75, 0.7, 0.45, 0.8, 0.0, 0.1);
	   }
	   else
	   {
   			rmSetPlacementTeam(0);
			// rmPlacePlayersLine(0.46, 0.36, 0.3, 0.2, 0.0, 0.1);
			rmPlacePlayersLine(0.3, 0.2, 0.25, 0.6, 0.0, 0.1);		// 0.25

			rmSetPlacementTeam(1);
			// rmPlacePlayersLine(0.64, 0.54, 0.8, 0.7, 0.0, 0.1);
			rmPlacePlayersLine(0.8, 0.7, 0.4, 0.75, 0.0, 0.1);	// 0.75, 0.7
	   }
   }
   else
   {
		// rmPlacePlayersLine(0.3, 0.2, 0.8, 0.7, 0.0, 0.1);
		// rmSetPlayerPlacementArea(0.0, 0.5, 0.7, 0.8);
		rmSetPlacementSection(0.6, 0.15);
		rmPlacePlayersCircular(0.3, 0.3, 0.0);

   }

    // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
	  rmAddAreaConstraint(i, avoidSocketPlayer);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      // rmAddAreaConstraint(id, playerConstraint); 
      // rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();
	
   // Text
   rmSetStatusText("",0.40);

	// Trade route hack.
   //	rmAddTradeRouteWaypoint(tradeRouteID, xFraction, zFraction)
   // rmAddRandomTradeRouteWaypoints(tradeRouteID, endXFraction, endZFraction, count, maxVariation) 
   int tradeRouteID2 = rmCreateTradeRoute();
   socketID=rmCreateObjectDef("sockets to dock Trade Posts 2");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);

   rmAddObjectDefConstraint(socketID, circleConstraint);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));

   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);

   rmAddTradeRouteWaypoint(tradeRouteID2, 0.85, 0.80);							// DAL - 0.9, 1.0; 0.0, 0.1
   rmAddRandomTradeRouteWaypoints(tradeRouteID2, 0.35, 0.95, 10, 10);			// 0.2, 0.85

   placedTradeRoute = rmBuildTradeRoute(tradeRouteID2, "grass");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route");

	// add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID2);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.0);
   if ( cNumberNonGaiaPlayers < 4 )
   {
	   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.05);
   }
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.4);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.8);
   if ( cNumberNonGaiaPlayers < 4 )
   {
	   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.75);
   }
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	// Adding a lake in the middle.
	int lakeID=rmCreateArea("small lake 1");
	int lakeConstraint=rmCreateClassDistanceConstraint("stuff vs. lake", rmClassID("lake"), 15.0);

	// Two variants:
	// 1 - lake moves to the left side, creating safe zones deep inland
	// 2 - lake is central, with ways around on either side
	if ( whichVariation == 1 )
	{
		rmSetAreaLocation(lakeID, 0.2, 0.8);
		rmAddAreaInfluenceSegment(lakeID, 0.0, 1.0, 0.35, 0.65);
		if ( cNumberNonGaiaPlayers < 4 )
		{
			rmSetAreaSize(lakeID, rmAreaTilesToFraction(1750), rmAreaTilesToFraction(1750));
		}
		else
		{
			rmSetAreaSize(lakeID, rmAreaTilesToFraction(3500), rmAreaTilesToFraction(3500));
		}
		rmSetAreaObeyWorldCircleConstraint(lakeID, false);
		rmSetAreaCoherence(lakeID, 0.5);									// higher = rounder
	}
	else
	{
		rmSetAreaLocation(lakeID, 0.4, 0.6);
		rmAddAreaInfluenceSegment(lakeID, 0.4, 0.5, 0.5, 0.6);
		if ( cNumberNonGaiaPlayers < 4 )
		{
			rmSetAreaSize(lakeID, rmAreaTilesToFraction(1200), rmAreaTilesToFraction(1200));
		}
		else
		{
			rmSetAreaSize(lakeID, rmAreaTilesToFraction(1500), rmAreaTilesToFraction(1500));
		}
		rmSetAreaCoherence(lakeID, 0.4);		
	}
	rmSetAreaWaterType(lakeID, "hudson bay");
	rmSetAreaBaseHeight(lakeID, 1.0);
	rmSetAreaMinBlobs(lakeID, 5);
	rmSetAreaMaxBlobs(lakeID, 5);
	rmSetAreaMinBlobDistance(lakeID, 10.0);
	rmSetAreaMaxBlobDistance(lakeID, 20.0);
	rmAddAreaToClass(lakeID, lakeClass);
	rmSetAreaWarnFailure(lakeID, false);
	// Only build if two teams.
	if ( cNumberTeams == 2 )
	{
		rmBuildArea(lakeID);
	}

   // Text
   rmSetStatusText("",0.50);

      // Starting Unit placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startingUnits, avoidAll);

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

	int silverType = -1;
	int playerGoldID = -1;

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreePatagoniaDirt", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 15.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartDeerID=rmCreateObjectDef("starting deer");
	rmAddObjectDefItem(StartDeerID, "deer", 1, 0.0);
	rmSetObjectDefMinDistance(StartDeerID, 10.0);
	rmSetObjectDefMaxDistance(StartDeerID, 15.0);
	rmAddObjectDefConstraint(StartDeerID, avoidStartingUnitsSmall);

	int StartBerryBushID=rmCreateObjectDef("starting berry bush");
	rmAddObjectDefItem(StartBerryBushID, "BerryBush", 2, 4.0);
	rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
	rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
	rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
    rmSetObjectDefMinDistance(playerNuggetID, 30.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerNuggetID, avoidPlayerNugget);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	// rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);

	int waterFlagID=-1;

	for(i=1; <cNumberPlayers)
	{
		rmClearClosestPointConstraints();
		// Place starting units and a TC!
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
    rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets one ore mine close by.
		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
		// rmAddObjectDefToClass(playerGoldID, rmClassID("importantItem"));
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
		rmSetObjectDefMinDistance(playerGoldID, 15.0);
		rmSetObjectDefMaxDistance(playerGoldID, 20.0);
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Berry Bushes
		rmPlaceObjectDefAtLoc(StartBerryBushID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Placing starting Pronghorns...
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Nuggets
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Water flag
		waterFlagID=rmCreateObjectDef("HC water flag "+i);
		rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
		rmAddClosestPointConstraint(Eastward);
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
        vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));

		rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
		rmClearClosestPointConstraints();
	}
   
	int numTries=cNumberNonGaiaPlayers*2;
	// Define and place cliffs
   for(i=0; <numTries)
   {
      int cliffID=rmCreateArea("cliff"+i);
      rmSetAreaSize(cliffID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(700));
      rmSetAreaWarnFailure(cliffID, false);
      rmSetAreaCliffType(cliffID, "Patagonia");
      rmSetAreaCliffEdge(cliffID, 2, 0.3, 0.1, 1.0, 0);
      rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, true);
      rmSetAreaCliffHeight(cliffID, 7, 2.0, 0.5);
      rmSetAreaHeightBlend(cliffID, 1);
      rmSetAreaObeyWorldCircleConstraint(cliffID, false);
      rmAddAreaToClass(cliffID, rmClassID("classCliff")); 
	  rmSetAreaMix(cliffID, "patagonia_dirt");
      rmAddAreaConstraint(cliffID, avoidImportantItem);
      rmAddAreaConstraint(cliffID, avoidImpassableLand);
      rmAddAreaConstraint(cliffID, avoidCliffs);
	  rmAddAreaConstraint(cliffID, playerConstraint);
      rmAddAreaConstraint(cliffID, avoidTradeRoute);
	  rmAddAreaConstraint(cliffID, avoidSocketCliff);
	  rmAddAreaConstraint(cliffID, avoidStartingUnits);
	  rmAddAreaConstraint(cliffID, avoidLake);
	  rmAddAreaConstraint(cliffID, Westward);

      rmSetAreaMinBlobs(cliffID, 2);
      rmSetAreaMaxBlobs(cliffID, 3);
      rmSetAreaMinBlobDistance(cliffID, 5.0);
      rmSetAreaMaxBlobDistance(cliffID, 20.0);
      rmSetAreaSmoothDistance(cliffID, 5);
      rmSetAreaCoherence(cliffID, 0.5);		// higher = tries to make round
      rmBuildArea(cliffID);
   } 

   // Text
   rmSetStatusText("",0.60);

   // Define and place Nuggets
   
   int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
	rmAddObjectDefConstraint(nuggetID, avoidSocket);
	rmAddObjectDefConstraint(nuggetID, avoidWater8);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmSetNuggetDifficulty(1, 3);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*5);
   
   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishSalmon", 3, 6.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);

   // Text
   rmSetStatusText("",0.70);

	// FAST COIN -- WHALES (reasonable in Patagonia, right?)
	int whaleID=rmCreateObjectDef("whale");
   rmAddObjectDefItem(whaleID, "beluga", 1, 9.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);

	// Ore mines, to be avoided by forests, etc.
	int silverID = -1;
	int silverWestID = -1;
	int silverCount = (cNumberNonGaiaPlayers*2);
	rmEchoInfo("silver count = "+silverCount);
	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, avoidFastCoin);
		rmAddObjectDefConstraint(silverID, avoidAll);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, avoidSocket);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   }

	// One extra gold mine per player "out west"
	for(i=0; < (cNumberNonGaiaPlayers))
	{
		silverType = rmRandInt(1,10);
		silverWestID = rmCreateObjectDef("silver west "+i);
		rmAddObjectDefItem(silverWestID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverWestID, 0.0);
		rmSetObjectDefMaxDistance(silverWestID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverWestID, avoidFastCoin);
		rmAddObjectDefConstraint(silverWestID, avoidAll);
		rmAddObjectDefConstraint(silverWestID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverWestID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverWestID, avoidSocket);
		rmAddObjectDefConstraint(silverWestID, Westward);
		rmPlaceObjectDefAtLoc(silverWestID, 0, 0.5, 0.5);
   }

   // Define and place Forests
   int forestTreeID = 0;
   numTries=4*cNumberNonGaiaPlayers;
   int failCount=0;
   for (i=0; <numTries)
      {   
         int forest=rmCreateArea("forest "+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(250));
         rmSetAreaForestType(forest, "patagonia forest");
			// rmSetAreaForestType(forest, "dunes");
         rmSetAreaForestDensity(forest, 1.0);
         rmSetAreaForestClumpiness(forest, 0.2);
         rmSetAreaForestUnderbrush(forest, 0.0);
         /*
			rmSetAreaMinBlobs(forest, 1);
         rmSetAreaMaxBlobs(forest, 4);
         rmSetAreaMinBlobDistance(forest, 4.0);
         rmSetAreaMaxBlobDistance(forest, 12.0);
			*/
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
         rmAddAreaConstraint(forest, forestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
			rmAddAreaConstraint(forest, avoidFastCoinForest);
         // rmAddAreaConstraint(forest, avoidBeach);
         rmAddAreaConstraint(forest, avoidImpassableLand); 
         rmAddAreaConstraint(forest, avoidTradeRoute); 
		  rmAddAreaConstraint(forest, avoidStartingUnits); 
			rmAddAreaConstraint(forest, avoidSocket); 
			rmAddAreaConstraint(forest, Eastward); 
         if(rmBuildArea(forest)==false)
         {
            // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==5)
               break;
         }
         else
            failCount=0; 
      } 

   // Define and place Forests - now a few to the west too
   numTries=cNumberNonGaiaPlayers*2;
   failCount=0;
   for (i=0; <numTries)
      {   
         forest=rmCreateArea("west forest "+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
         rmSetAreaForestType(forest, "patagonia forest");
			// rmSetAreaForestType(forest, "dunes");
         rmSetAreaForestDensity(forest, 1.0);
         rmSetAreaForestClumpiness(forest, 0.2);
         rmSetAreaForestUnderbrush(forest, 0.0);
         /*
			rmSetAreaMinBlobs(forest, 1);
         rmSetAreaMaxBlobs(forest, 4);
         rmSetAreaMinBlobDistance(forest, 4.0);
         rmSetAreaMaxBlobDistance(forest, 12.0);
			*/
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
		 rmAddAreaToClass(forest, rmClassID("classWestForest")); 
         rmAddAreaConstraint(forest, forestConstraint);
		 rmAddAreaConstraint(forest, westForestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
			rmAddAreaConstraint(forest, avoidFastCoinForest);
         // rmAddAreaConstraint(forest, avoidBeach);
         rmAddAreaConstraint(forest, avoidImpassableLand); 
         rmAddAreaConstraint(forest, avoidTradeRoute); 
		  // rmAddAreaConstraint(forest, avoidStartingUnits); 
			rmAddAreaConstraint(forest, avoidSocket); 
			rmAddAreaConstraint(forest, Westward); 
         if(rmBuildArea(forest)==false)
         {
            // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==5)
               break;
         }
         else
            failCount=0; 
      } 


  
	// Text
   rmSetStatusText("",0.80);

   /* DAL - taking out old colony ship stuff.
	int colonyShipID=0;

	// Set up for finding closest land points.
	rmAddClosestPointConstraint(avoidWater8);
	rmAddClosestPointConstraint(playerEdgeConstraint);
	rmAddClosestPointConstraint(flagConstraint);
	rmAddClosestPointConstraint(nearWater10);

	for(i=1; <cNumberPlayers)
	{
		colonyShipID=rmCreateObjectDef("colony ship "+i);
		if(rmGetPlayerCiv(i) == rmGetCivID("Ottomans"))
			rmAddObjectDefItem(colonyShipID, "Galley", 1, 0.0);
		else
			rmAddObjectDefItem(colonyShipID, "Caravel", 1, 0.0);
		rmSetObjectDefGarrisonStartingUnits(colonyShipID, true);
		rmSetObjectDefMinDistance(colonyShipID, 0.0);
		rmSetObjectDefMaxDistance(colonyShipID, 20.0);

		// Place boat.
		int count = rmPlaceObjectDefAtLoc(colonyShipID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if(count<1)
		{
			rmEchoError("Failed to place player "+i);
			continue;
		}

		// Get where it placed.
		vector colonyShipLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(colonyShipID, i));
	    
		// Find closest point.
		vector closestPoint = rmFindClosestPointVector(colonyShipLocation, rmXFractionToMeters(0.25));
		rmEchoInfo("0.25 Fraction to Meters = "+rmXFractionToMeters(0.25));

		// Set HCGP.
		rmSetHomeCityGatherPoint(i, closestPoint);
	}

	// Clear out constraints for good measure.
	rmClearClosestPointConstraints();
   */

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
  
   // Text
   rmSetStatusText("",0.90);

	// HACK replacing bighorn with deer for now.
   int bighornID=rmCreateObjectDef("bighorn sheep herd");
	rmAddObjectDefItem(bighornID, "deer", rmRandInt(5,7), 6.0);
   rmSetObjectDefMinDistance(bighornID, 0.0);
   rmSetObjectDefMaxDistance(bighornID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(bighornID, avoidBighornSheep);
   rmAddObjectDefConstraint(bighornID, avoidMoose);
	rmAddObjectDefConstraint(bighornID, avoidAll);
   rmAddObjectDefConstraint(bighornID, avoidImpassableLand);
	rmAddObjectDefConstraint(bighornID, Westward);
	rmAddObjectDefConstraint(bighornID, avoidStartingUnits);
	rmAddObjectDefConstraint(bighornID, avoidSocket);
	rmAddObjectDefConstraint(bighornID, avoidTradeRoute);
   rmSetObjectDefCreateHerd(bighornID, true);
	rmPlaceObjectDefAtLoc(bighornID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*6);

	int rheaID=rmCreateObjectDef("rhea flock");
   rmAddObjectDefItem(rheaID, "rhea", rmRandInt(8,10), 10.0);
   rmSetObjectDefMinDistance(rheaID, 0.0);
   rmSetObjectDefMaxDistance(rheaID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rheaID, avoidBighornSheep);
	rmAddObjectDefConstraint(rheaID, avoidAll);
   rmAddObjectDefConstraint(rheaID, avoidImpassableLand);
    rmAddObjectDefConstraint(rheaID, avoidStartingUnits);
	rmAddObjectDefConstraint(rheaID, avoidTradeRoute);
	rmAddObjectDefConstraint(rheaID, Eastward);
   rmSetObjectDefCreateHerd(rheaID, true);
	rmPlaceObjectDefAtLoc(rheaID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int sheepID=rmCreateObjectDef("sheep");
	rmAddObjectDefItem(sheepID, "sheep", 2, 4.0);
	rmSetObjectDefMinDistance(sheepID, 0.0);
	rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(sheepID, avoidSheep);
	rmAddObjectDefConstraint(sheepID, avoidAll);
    rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
    rmAddObjectDefConstraint(sheepID, avoidStartingUnits);
	rmAddObjectDefConstraint(sheepID, avoidTradeRoute);
	rmAddObjectDefConstraint(sheepID, Westward);
	rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);


   // wood resources
	/*
   int randomTreeID=rmCreateObjectDef("random tree general");
   rmAddObjectDefItem(randomTreeID, "treeSaguenay", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomTreeID, avoidAll);
   rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
   rmAddObjectDefConstraint(randomTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(randomTreeID, avoidSocket);
   rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);

   // lots of extra trees in the west, since we're placing all the small forests in the east.
   int randomTreeWestID=rmCreateObjectDef("random tree west");
   rmAddObjectDefItem(randomTreeWestID, "treeTexas", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeWestID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeWestID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomTreeWestID, avoidAll);
   rmAddObjectDefConstraint(randomTreeWestID, avoidImpassableLand);
   rmAddObjectDefConstraint(randomTreeWestID, avoidTradeRoute);
	rmAddObjectDefConstraint(randomTreeWestID, Westward);
	rmAddObjectDefConstraint(randomTreeWestID, avoidSocket);
   rmPlaceObjectDefAtLoc(randomTreeWestID, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers);
	*/


	/*
   rmSetMapClusteringPlacementParams(0.8, 0.2, 0.6, cClusterLand);
   rmSetMapClusteringObjectParams(0, 1, 0.1);
   rmPlaceMapClusters("carolinas\grass4", "underbrushRock");
	*/


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
