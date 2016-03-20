// NEW ENGLAND
// A Random Map for Age of Empires III: The Third One
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
   int subCiv2=-1;
   int subCiv3=-1;

	// Thingy to randomize location of the four "equal" VP sites.
	int vpLocation=-1;
	// vpLocation = rmRandInt(1,4);
	vpLocation = 1;

	int whichVariation=-1;
	// Used to be 1-4, but taking the mega-cliffs out for now.
	whichVariation = rmRandInt(1,2);

	int whichNative=rmRandInt(1,4);
	if ( whichNative > 1 )
	{
		subCiv0=rmGetCivID("Huron");
		rmEchoInfo("subCiv0 is Huron "+subCiv0);

		subCiv1=rmGetCivID("Huron");
		rmEchoInfo("subCiv1 is Huron "+subCiv1);
	}
	else
	{
		subCiv0=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv0 is Cherokee "+subCiv0);

		subCiv1=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv1 is Cherokee "+subCiv1);
	}

	subCiv2=rmGetCivID("Cree");
	rmEchoInfo("subCiv2 is Cree "+subCiv2);

	rmSetSubCiv(0, "Cherokee", true);
	rmSetSubCiv(1, "Huron", true);
	rmSetSubCiv(2, "Cree", true);

	float handedness = rmRandFloat(0, 1);

   // Picks the map size
	int playerTiles=12500;
   if (cNumberNonGaiaPlayers >4)
		playerTiles = 11500;

   // Picks default terrain and water
   rmSetSeaType("new england coast");
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

	// Some map turbulence...
	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);  // Like Texas for the moment.
	rmSetMapElevationHeightBlend(0.2);

   // Picks a default water height
   rmSetSeaLevel(4.0);
   rmEnableLocalWater(false);
   rmTerrainInitialize("water");
	rmSetMapType("newEngland");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);
	// rmSetLightingSet("new england start");
	rmSetLightingSet("new england");
	rmSetMapType("grass");

	// Sets up the lighting change trigger - happy dawn in New England
	// REMOVED
	/*
	rmCreateTrigger("Day");
   rmSwitchToTrigger(rmTriggerID("Day"));
   rmSetTriggerActive(true);
   rmAddTriggerCondition("Timer");
   rmSetTriggerConditionParamInt("Param1", 2);
   rmAddTriggerEffect("Set Lighting");
   rmSetTriggerEffectParam("SetName", "new england");
   rmSetTriggerEffectParamInt("FadeTime", 120);
   */

	// Choose mercs.
	chooseMercs();

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classCliff");
   rmDefineClass("classPatch");
	rmDefineClass("classWall");
   int classbigContinent=rmDefineClass("big continent");
   rmDefineClass("corner");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("socketClass");
	rmDefineClass("nuggets");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("continent stays away from players", classPlayer, 12.0);

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);

   // Directional constraints
	int Northwestward=rmCreatePieConstraint("northwestMapConstraint", 0.6, 0.6, 0, rmZFractionToMeters(0.9), rmDegreesToRadians(285), rmDegreesToRadians(75));  // 225 135, 300, 45
   int Southeastward=rmCreatePieConstraint("southeastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(90), rmDegreesToRadians(270));

   // Bonus area constraint.
   int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classbigContinent, 25.0);

   // Resource avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 10.0);
   int avoidDeer=rmCreateTypeDistanceConstraint("food avoids food", "deer", 45.0);
	int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 30.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 35.0);
   int avoidPlayerNugget=rmCreateTypeDistanceConstraint("player nugget avoid nugget", "AbstractNugget", 20.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("nugget avoid nugget small", "AbstractNugget", 10.0);
    int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
   int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);

   // Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int wallConstraint=rmCreateClassDistanceConstraint("wall vs. wall", rmClassID("classWall"), 40.0);
	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 40.0);

   // Specify true so constraint stays outside of circle (i.e. inside corners)
   int cornerConstraint0=rmCreateCornerConstraint("in corner 0", 0, true);
   int cornerConstraint1=rmCreateCornerConstraint("in corner 1", 1, true);
   int cornerConstraint2=rmCreateCornerConstraint("in corner 2", 2, true);
   int cornerConstraint3=rmCreateCornerConstraint("in corner 3", 3, true);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 20.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

   // ships vs. ships
   int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 5.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 30.0);
	int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 12.0);

   // Constraint to avoid water.
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
   int avoidWater15 = rmCreateTerrainDistanceConstraint("avoid water 15", "Land", false, 15.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 20.0);
   int avoidWater30 = rmCreateTerrainDistanceConstraint("avoid water mid-long", "Land", false, 30.0);
   int avoidWater40 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 40.0);

   // New extra stuff for water spawn point avoidance.
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 20.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
	int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 20.0);

   // Text
   rmSetStatusText("",0.10);

	// DEFINE AREAS
   // Set up player starting locations. These are just used to place Caravels away from each other.
   /* DAL - old placement.
	rmSetPlacementSection(0.35, 0.65);
   rmSetTeamSpacingModifier(0.50);
   rmPlacePlayersCircular(0.45, 0.45, rmDegreesToRadians(5.0));
	*/

   // Text
   rmSetStatusText("",0.20);

	// Build up big continent - called, unoriginally enough, "big continent"
   int bigContinentID=rmCreateArea("big continent");
   rmSetAreaSize(bigContinentID, 0.52, 0.52);		// 0.65, 0.65
   rmSetAreaWarnFailure(bigContinentID, false);
   rmAddAreaConstraint(bigContinentID, longPlayerConstraint);
   rmAddAreaToClass(bigContinentID, classbigContinent);
   rmSetAreaSmoothDistance(bigContinentID, 25);
	rmSetAreaMix(bigContinentID, "newengland_grass");
   rmSetAreaElevationType(bigContinentID, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinentID, 2.0);
   rmSetAreaBaseHeight(bigContinentID, 6.0);
   rmSetAreaElevationMinFrequency(bigContinentID, 0.09);
   rmSetAreaElevationOctaves(bigContinentID, 3);
   rmSetAreaElevationPersistence(bigContinentID, 0.2);      
	rmSetAreaCoherence(bigContinentID, 0.5);
	rmSetAreaLocation(bigContinentID, 0.5, 0.85);
   rmSetAreaEdgeFilling(bigContinentID, 5);
	rmSetAreaObeyWorldCircleConstraint(bigContinentID, false);
	rmBuildArea(bigContinentID);

	rmSetStatusText("",0.30);

	// Build up small continent spurs called "small continent spur 1 & 2"
   int smallContinent1ID=rmCreateArea("small continent spur 1");
   rmSetAreaSize(smallContinent1ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent1ID, false);
   rmAddAreaConstraint(smallContinent1ID, longPlayerConstraint);
   rmAddAreaToClass(smallContinent1ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent1ID, 25);
	rmSetAreaMix(smallContinent1ID, "newengland_grass");
   rmSetAreaElevationType(smallContinent1ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent1ID, 2.0);
   rmSetAreaBaseHeight(smallContinent1ID, 6.0);
   rmSetAreaElevationMinFrequency(smallContinent1ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent1ID, 3);
   rmSetAreaElevationPersistence(smallContinent1ID, 0.2);      
	rmSetAreaCoherence(smallContinent1ID, 0.5);
	rmSetAreaLocation(smallContinent1ID, 0.8, 0.6);
   rmSetAreaEdgeFilling(smallContinent1ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent1ID, false);
	rmBuildArea(smallContinent1ID);

   rmSetStatusText("",0.35);

	// Build up small continent spurs called "small continent spur 1 & 2"
   int smallContinent2ID=rmCreateArea("small continent spur 2");
   rmSetAreaSize(smallContinent2ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent2ID, false);
   rmAddAreaConstraint(smallContinent2ID, longPlayerConstraint);
   rmAddAreaToClass(smallContinent2ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent2ID, 25);
	rmSetAreaMix(smallContinent2ID, "newengland_grass");
   rmSetAreaElevationType(smallContinent2ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent2ID, 2.0);
   rmSetAreaBaseHeight(smallContinent2ID, 6.0);
   rmSetAreaElevationMinFrequency(smallContinent2ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent2ID, 3);
   rmSetAreaElevationPersistence(smallContinent2ID, 0.2);      
	rmSetAreaCoherence(smallContinent2ID, 0.5);
	rmSetAreaLocation(smallContinent2ID, 0.2, 0.6);
   rmSetAreaEdgeFilling(smallContinent2ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent2ID, false);
	rmBuildArea(smallContinent2ID);

	if ( cNumberTeams == 2 )
	{
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.2, 0.5, 0.2, 0.8, 0.0, 0.2);

		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.8, 0.5, 0.8, 0.8, 0.0, 0.2);
	}
	else
	{
	   rmSetPlacementSection(0.75, 0.25);
	   rmSetTeamSpacingModifier(0.75);
	   rmPlacePlayersCircular(0.4, 0.4, 0);
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
      // rmAddAreaConstraint(id, playerConstraint); 
      // rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();

   // Placement order
   // Trade route -> Lakes -> Natives -> Secrets -> Cliffs -> Nuggets
   // Text
   rmSetStatusText("",0.40);

   // TRADE ROUTES
	int tradeRouteID = rmCreateTradeRoute();

	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);
	if ( cNumberNonGaiaPlayers < 4 )
	{
		rmAddObjectDefConstraint(socketID, avoidWater15);					// To make it avoid the water and the cliffs.
	}

	else 
	{
		rmAddObjectDefConstraint(socketID, avoidWater20);					// To make it avoid the water and the cliffs - by more if larger map
	}

	// Hacky trade route stuff for weird FFA cases, to handle player placement.
	if ( cNumberTeams == 3 || cNumberTeams > 4 )
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.8);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.9);
	}
	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.9);

	if ( cNumberNonGaiaPlayers < 4 )
	{
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.45, 10, 2);
	}
	else
	{
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.4, 10, 4);
	}
   
   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 

	// add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.0);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.3);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 1.0);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	// LAKES
	int lakeClass=rmDefineClass("lake");
	int lakeConstraint=rmCreateClassDistanceConstraint("lake vs. lake", rmClassID("lake"), 20.0);

	// Half the time there are two extra lakes.
	int extraLakes=-1;
	extraLakes = rmRandInt(1,2);

	int smalllakeID=rmCreateArea("small lake 1");
	
	// Place Lakes only in Variations 1 & 2.
	if ( whichVariation < 3 )
	{
		if ( cNumberNonGaiaPlayers < 4 )
			rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
		else
			rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(900), rmAreaTilesToFraction(900));
		rmSetAreaWaterType(smalllakeID, "new england lake");
		rmSetAreaBaseHeight(smalllakeID, 2.0);
		rmSetAreaMinBlobs(smalllakeID, 2);
		rmSetAreaMaxBlobs(smalllakeID, 3);
		rmSetAreaMinBlobDistance(smalllakeID, 8.0);
		rmSetAreaMaxBlobDistance(smalllakeID, 12.0);
		// rmSetAreaSmoothDistance(smalllakeID, 20);
		rmAddAreaToClass(smalllakeID, lakeClass);
		rmAddAreaConstraint(smalllakeID, playerConstraint);
		rmAddAreaConstraint(smalllakeID, avoidTradeRoute);
		rmAddAreaConstraint(smalllakeID, avoidSocket);
		rmSetAreaLocation(smalllakeID, 0.38, 0.65);
		rmAddAreaInfluenceSegment(smalllakeID, 0.4, 0.52, 0.35, 0.68);
		rmSetAreaCoherence(smalllakeID, 0.7);

		rmSetAreaWarnFailure(smalllakeID, false);
		rmBuildArea(smalllakeID);

		int smalllakeID2=rmCreateArea("small lake 2");
		if ( cNumberNonGaiaPlayers < 4 )
			rmSetAreaSize(smalllakeID2, rmAreaTilesToFraction(600), rmAreaTilesToFraction(600));
		else
			rmSetAreaSize(smalllakeID2, rmAreaTilesToFraction(900), rmAreaTilesToFraction(900));

		rmSetAreaWaterType(smalllakeID2, "new england lake");
		rmSetAreaBaseHeight(smalllakeID2, 2.0);
		rmSetAreaMinBlobs(smalllakeID2, 5);
		rmSetAreaMaxBlobs(smalllakeID2, 8);
		rmSetAreaMinBlobDistance(smalllakeID2, 5.0);
		rmSetAreaMaxBlobDistance(smalllakeID2, 10.0);
		// rmSetAreaSmoothDistance(smalllakeID2, 20); 
		rmAddAreaToClass(smalllakeID2, lakeClass);
		rmAddAreaConstraint(smalllakeID2, playerConstraint);
		rmAddAreaConstraint(smalllakeID2, avoidTradeRoute);
		rmAddAreaConstraint(smalllakeID2, avoidSocket);
		rmSetAreaLocation(smalllakeID2, 0.62, 0.65);
		rmAddAreaInfluenceSegment(smalllakeID2, 0.6, 0.52, 0.65, 0.68);
		rmSetAreaCoherence(smalllakeID2, 0.7);

		rmSetAreaWarnFailure(smalllakeID2, false);
		rmBuildArea(smalllakeID2);	

		// Two extra lakes?  Sometimes - only if more than two players.
		if ( extraLakes == 2 && cNumberNonGaiaPlayers > 2 )
		{
			int smallLakeID3=rmCreateArea("small lake 3");
			rmSetAreaSize(smallLakeID3, rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
			rmSetAreaWaterType(smallLakeID3, "new england lake");
			rmSetAreaBaseHeight(smallLakeID3, 2.0);
			rmAddAreaToClass(smallLakeID3, lakeClass);
			rmAddAreaConstraint(smallLakeID3, playerConstraint);
			rmAddAreaConstraint(smallLakeID3, avoidTradeRoute);
			rmSetAreaLocation(smallLakeID3, 0.16, 0.65);
			rmSetAreaCoherence(smallLakeID3, 0.3);
			rmSetAreaWarnFailure(smallLakeID3, false);
			rmBuildArea(smallLakeID3);	

			int smallLakeID4=rmCreateArea("small lake 4");
			rmSetAreaSize(smallLakeID4, rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
			rmSetAreaWaterType(smallLakeID4, "new england lake");
			rmSetAreaBaseHeight(smallLakeID4, 2.0);
			rmAddAreaToClass(smallLakeID4, lakeClass);
			rmAddAreaConstraint(smallLakeID4, playerConstraint);
			rmAddAreaConstraint(smallLakeID4, avoidTradeRoute);
			rmSetAreaLocation(smallLakeID4, 0.84, 0.65);
			rmSetAreaCoherence(smallLakeID4, 0.3);
			rmSetAreaWarnFailure(smallLakeID4, false);
			rmBuildArea(smallLakeID4);	
		}
	}

	// Place two crazy cliffs at the spots the lakes WOULD have been otherwise (i.e., if the lakes aren't there).
	/*
	if ( whichVariation > 2 )
	{
		int bigCliff1ID=rmCreateArea("big cliff 1");
	   rmSetAreaSize(bigCliff1ID, rmAreaTilesToFraction(1200), rmAreaTilesToFraction(1200));
		rmSetAreaWarnFailure(bigCliff1ID, false);
		rmSetAreaCliffType(bigCliff1ID, "New England");
		rmAddAreaToClass(bigCliff1ID, rmClassID("classCliff"));		// Attempt to keep cliffs away from each other.

		rmSetAreaCliffEdge(bigCliff1ID, 1, 0.6, 0.1, 1.0, 0);  // DAL NOTE: Number of edges, second is size of each edge, third is variance
		rmSetAreaCliffPainting(bigCliff1ID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(bigCliff1ID, 6, 1.0, 1.0);
		rmSetAreaHeightBlend(bigCliff1ID, 1.0);
		rmAddAreaTerrainLayer(bigCliff1ID, "new_england\ground4_ne", 0, 2);

		rmAddAreaConstraint(bigCliff1ID, avoidImportantItem);
		rmAddAreaConstraint(bigCliff1ID, avoidTradeRoute);
		rmSetAreaMinBlobs(bigCliff1ID, 3);
		rmSetAreaMaxBlobs(bigCliff1ID, 5);
		rmSetAreaMinBlobDistance(bigCliff1ID, 15.0);
		rmSetAreaMaxBlobDistance(bigCliff1ID, 25.0);
		rmSetAreaSmoothDistance(bigCliff1ID, 15);
		rmSetAreaCoherence(bigCliff1ID, 0.4);
		
		rmSetAreaLocation(bigCliff1ID, 0.40, 0.65);
		rmAddAreaInfluenceSegment(bigCliff1ID, 0.4, 0.52, 0.35, 0.68);
		rmBuildArea(bigCliff1ID);

		int bigCliff2ID=rmCreateArea("big cliff 2");
	   rmSetAreaSize(bigCliff2ID, rmAreaTilesToFraction(1200), rmAreaTilesToFraction(1200));
		rmSetAreaWarnFailure(bigCliff2ID, false);
		rmSetAreaCliffType(bigCliff2ID, "New England");
		rmAddAreaToClass(bigCliff2ID, rmClassID("classCliff"));		// Attempt to keep cliffs away from each other.

		rmSetAreaCliffEdge(bigCliff2ID, 1, 0.6, 0.1, 1.0, 0);
		rmSetAreaCliffPainting(bigCliff2ID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(bigCliff2ID, 6, 1.0, 1.0);
		rmSetAreaHeightBlend(bigCliff2ID, 1.0);
		rmAddAreaTerrainLayer(bigCliff2ID, "new_england\ground4_ne", 0, 2);

		rmAddAreaConstraint(bigCliff2ID, avoidImportantItem);
		rmAddAreaConstraint(bigCliff2ID, avoidTradeRoute);
		rmSetAreaMinBlobs(bigCliff2ID, 3);
		rmSetAreaMaxBlobs(bigCliff2ID, 5);
		rmSetAreaMinBlobDistance(bigCliff2ID, 15.0);
		rmSetAreaMaxBlobDistance(bigCliff2ID, 25.0);
		rmSetAreaSmoothDistance(bigCliff2ID, 15);
		rmSetAreaCoherence(bigCliff2ID, 0.4);

		rmSetAreaLocation(bigCliff2ID, 0.60, 0.65);
		rmAddAreaInfluenceSegment(bigCliff2ID, 0.6, 0.52, 0.65, 0.68);
		rmBuildArea(bigCliff2ID);
	}
	*/

   // Isles of Shoals - these are set in specific locations.
   int bonusIslandID1=rmCreateArea("isle of shoals 1");
   rmSetAreaSize(bonusIslandID1, rmAreaTilesToFraction(450), rmAreaTilesToFraction(450));
   rmSetAreaTerrainType(bonusIslandID1, "new_england\ground1_ne");
   rmSetAreaMix(bonusIslandID1, "newengland_grass");
	// rmSetAreaMix(bonusIslandID1, "newengland_rock");
   rmSetAreaBaseHeight(bonusIslandID1, 6.0);
   rmSetAreaSmoothDistance(bonusIslandID1, 5);
   rmSetAreaWarnFailure(bonusIslandID1, false);
	rmSetAreaMinBlobs(bonusIslandID1, 4);
   rmSetAreaMaxBlobs(bonusIslandID1, 5);
   rmSetAreaMinBlobDistance(bonusIslandID1, 8.0);
	rmSetAreaMaxBlobDistance(bonusIslandID1, 12.0);
   rmSetAreaCoherence(bonusIslandID1, 0.50);
   rmAddAreaConstraint(bonusIslandID1, bigContinentConstraint);
   rmAddAreaConstraint(bonusIslandID1, longPlayerConstraint);

	// this may be the only island!  On a 2 or a 4.
	if ( whichVariation == 1 || whichVariation == 3 )
	{
		rmSetAreaLocation(bonusIslandID1, 0.40, 0.15);
	}
	else
		rmSetAreaLocation(bonusIslandID1, 0.50, 0.15);
   rmBuildArea(bonusIslandID1);

	// Only make the second island half the time.
	if ( whichVariation == 1 || whichVariation == 3 )
	{
		int bonusIslandID2=rmCreateArea("isle of shoals 2");
		rmSetAreaSize(bonusIslandID2, rmAreaTilesToFraction(450), rmAreaTilesToFraction(450));
		rmSetAreaTerrainType(bonusIslandID2, "new_england\ground1_ne");
		rmSetAreaMix(bonusIslandID2, "newengland_grass");
		// rmSetAreaMix(bonusIslandID2, "newengland_rock");
		rmSetAreaBaseHeight(bonusIslandID2, 6.0);
		rmSetAreaSmoothDistance(bonusIslandID2, 5);
		rmSetAreaWarnFailure(bonusIslandID2, false);
		rmSetAreaMinBlobs(bonusIslandID2, 4);
		rmSetAreaMaxBlobs(bonusIslandID2, 5);
		rmSetAreaMinBlobDistance(bonusIslandID2, 8.0);
		rmSetAreaMaxBlobDistance(bonusIslandID2, 12.0);
		rmSetAreaCoherence(bonusIslandID2, 0.50);
		rmAddAreaConstraint(bonusIslandID2, bigContinentConstraint);
		rmAddAreaConstraint(bonusIslandID2, longPlayerConstraint);
		rmSetAreaLocation(bonusIslandID2, 0.60, 0.15);
		rmBuildArea(bonusIslandID2);
	}

   // NATIVE AMERICANS
   // Text
   rmSetStatusText("",0.50);

   float NativeVillageLoc = rmRandFloat(0,1);
     
   // Huron are always on the mainland
   int huronVillageAID = -1;
   int huronVillageType = rmRandInt(1,3);
   if ( whichNative > 1 )
   {
		huronVillageAID = rmCreateGrouping("huron village A", "native huron village "+huronVillageType);
   }
   else
   {
	   	huronVillageAID = rmCreateGrouping("cherokee village A", "native cherokee village "+huronVillageType);
   }
   rmSetGroupingMinDistance(huronVillageAID, 0.0);
   rmSetGroupingMaxDistance(huronVillageAID, rmXFractionToMeters(0.05));
   rmAddGroupingConstraint(huronVillageAID, avoidImpassableLand);
   rmAddGroupingToClass(huronVillageAID, rmClassID("importantItem"));
   rmAddGroupingConstraint(huronVillageAID, avoidTradeRoute);

	if ( vpLocation < 3 )
	{
		rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.35, 0.8); // used to be 0.3 DAL
	}
	else if ( vpLocation == 3 )
	{
		rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.2, 0.6);
	}
	else
	{
		rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.8, 0.6);
	}
	
	int huronVillageBID = -1;
	huronVillageType = rmRandInt(1,3);
	if ( whichNative > 1 )
	{
		huronVillageBID = rmCreateGrouping("huron village B", "native huron village "+huronVillageType);
	}
	else
	{
		huronVillageBID = rmCreateGrouping("cherokee village B", "native cherokee village "+huronVillageType);
	}
	rmSetGroupingMinDistance(huronVillageBID, 0.0);
	rmSetGroupingMaxDistance(huronVillageBID, rmXFractionToMeters(0.05));
	rmAddGroupingConstraint(huronVillageBID, avoidImpassableLand);
	rmAddGroupingToClass(huronVillageBID, rmClassID("importantItem"));
	rmAddGroupingConstraint(huronVillageBID, avoidTradeRoute);
	
	if ( vpLocation == 1 )
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.65, 0.8); // used to be 0.7 DAL
	}
	else if ( vpLocation == 2 )
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.8, 0.6); 
	}
	else if ( vpLocation == 3 )
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.7, 0.8); 
	}
	else
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.2, 0.6);
	}

	// The Cree get placed on one of the islands.  Ahistorical, perhaps, but fun!
	/* DAL - CREE TAKEN OUT
   int creeVillageID = -1;
   int creeVillageType = rmRandInt(1,3);
   creeVillageID = rmCreateGrouping("cree village", "native cree village "+creeVillageType);
   rmSetGroupingMinDistance(creeVillageID, 0.0);
   rmSetGroupingMaxDistance(creeVillageID, rmXFractionToMeters(0.05));
   rmAddGroupingConstraint(creeVillageID, avoidImpassableLand);
   rmAddGroupingToClass(creeVillageID, rmClassID("importantItem"));
	if ( vpLocation < 3 )
	{
		// Only gets placed if island #2 actually exists.
		if ( whichVariation == 1 || whichVariation == 3 )
		{
			rmPlaceGroupingInArea(creeVillageID, 0, bonusIslandID2);
		}
	}
	else
	{
		rmPlaceGroupingInArea(creeVillageID, 0, bonusIslandID1);
	}
	*/

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
	rmAddObjectDefItem(StartAreaTreeID, "TreeNewEngland", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 15.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartBerryBushID=rmCreateObjectDef("starting BerryBush");
	rmAddObjectDefItem(StartBerryBushID, "BerryBush", 3, 5.0);
	rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
	rmSetObjectDefMaxDistance(StartBerryBushID, 15.0);
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

		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets one ore grouping close by.
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
		/*
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		*/
		rmPlaceObjectDefAtLoc(StartBerryBushID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
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
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Water flag
		waterFlagID=rmCreateObjectDef("HC water flag "+i);
		rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
        vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));

		rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
		rmClearClosestPointConstraints();
	}

	// Text
   rmSetStatusText("",0.60);

	// A few smallish cliffs on the northwest side (inland)
	/* DAL Temp - take these suckers out, now that there are some lakes
	int numTries=cNumberNonGaiaPlayers;
	int failCount=0;
	for(i=0; <numTries)
	{
		int cliffID=rmCreateArea("cliff "+i);
	   rmSetAreaSize(cliffID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(100));
		rmSetAreaWarnFailure(cliffID, false);
		rmSetAreaCliffType(cliffID, "New England");
		rmAddAreaToClass(cliffID, rmClassID("classCliff"));	// Attempt to keep cliffs away from each other.

		// rmSetAreaCliffEdge(cliffID, 1, 0.6, 0.1, 1.0, 0);
		rmSetAreaCliffEdge(cliffID, 1, 1);
		rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffID, 4, 1.0, 1.0);
		rmSetAreaHeightBlend(cliffID, 1.0);
		rmAddAreaTerrainLayer(cliffID, "new_england\ground4_ne", 0, 2);

		rmAddAreaConstraint(cliffID, avoidCliffs);				// Avoid other cliffs, please!
		rmAddAreaConstraint(cliffID, avoidImportantItem);
		rmAddAreaConstraint(cliffID, avoidTradeRoute);
		rmAddAreaConstraint(cliffID, avoidWater20);
		rmAddAreaConstraint(cliffID, Northwestward);				// Cliff are on the northwest side of the map.
		rmSetAreaSmoothDistance(cliffID, 10);
		rmSetAreaCoherence(cliffID, 0.25);

		if(rmBuildArea(cliffID)==false)
		{
			// Stop trying once we fail 3 times in a row
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}
	*/

   // Define and place Nuggets
   
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidSocket);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
  	rmAddObjectDefConstraint(nuggetID, avoidWater20);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmSetNuggetDifficulty(2, 3);
	rmPlaceObjectDefInArea(nuggetID, 0, bigContinentID, cNumberNonGaiaPlayers*5);

	// Alternate nugget definition for island nuggets - no constraints (practically)
	/*
	int nuggetID2= rmCreateObjectDef("nugget 2"); 
	rmAddObjectDefItem(nuggetID2, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID2, 0.0);
	rmSetObjectDefMaxDistance(nuggetID2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID2, shortAvoidImpassableLand);

	// Extra nuggets on the non-native island.
	if ( vpLocation < 3 )
	{
		rmPlaceObjectDefInArea(nuggetID2, 0, bonusIslandID1, 4);
	}
	else
	{
		if ( whichVariation == 1 || whichVariation == 3 )
		{
			rmPlaceObjectDefInArea(nuggetID2, 0, bonusIslandID2, 4);
		}
	}
	*/

	// Placement of crates on the bonus islands.
	// DAL - "nuggets" for now instead
	int whichCrate=-1;
	whichCrate = rmRandInt(1,3);

	int islandCrateID= rmCreateObjectDef("island crates"); 
	rmSetNuggetDifficulty(4, 4);
	rmAddObjectDefConstraint(islandCrateID, avoidWater4);
	rmAddObjectDefConstraint(islandCrateID, avoidNuggetSmall);
	if ( whichCrate == 1 )
	{
		rmAddObjectDefItem(islandCrateID, "Nugget", 1, 0.0);
	}
	else if ( whichCrate == 2 )
	{
		rmAddObjectDefItem(islandCrateID, "Nugget", 1, 0.0);
	}
	else
   		rmAddObjectDefItem(islandCrateID, "Nugget", 1, 0.0);
	

	rmPlaceObjectDefInArea(islandCrateID, 0, bonusIslandID1, 1);
	if ( whichVariation == 1 )
	{
		rmPlaceObjectDefInArea(islandCrateID, 0, bonusIslandID2, 1);
	}

	// TEMP: add four natives to the islands
	// DAL - temp trees instead.
	int islandNativeID= rmCreateObjectDef("island natives"); 
	rmAddObjectDefConstraint(islandNativeID, avoidWater4);
	// rmAddObjectDefItem(islandNativeID, "NatTomahawk", 1, 0.0);
	rmAddObjectDefItem(islandNativeID, "TreeNewEngland", 1, 0.0);
	rmPlaceObjectDefInArea(islandNativeID, 0, bonusIslandID1, 7);
	if ( whichVariation == 1 )
	{
		rmPlaceObjectDefInArea(islandNativeID, 0, bonusIslandID2, 7);
	}

   // fish
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 20.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "minkeWhale", 25.0);


   /*
   int playerFishID=rmCreateObjectDef("player fish");
   rmAddObjectDefItem(playerFishID, "FishCod", 1, 10.0);
   rmSetObjectDefMinDistance(playerFishID, 0.0);
   rmSetObjectDefMaxDistance(playerFishID, 20.0);
   rmAddObjectDefConstraint(playerFishID, fishVsFishID);
   rmAddObjectDefConstraint(playerFishID, fishLand);
   */

   // rmPlaceObjectDefPerPlayer(playerFishID, false);

   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishCod", 2, 5.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.0, cNumberNonGaiaPlayers*5);

	// FAST COIN -- WHALES
	int whaleID=rmCreateObjectDef("whale");
   rmAddObjectDefItem(whaleID, "minkeWhale", 1, 9.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);


    //CARAVEL
   /*
   int colonyShipID = 0;
   for(i=1; <cNumberPlayers)
   {
		colonyShipID=rmCreateObjectDef("colony ship "+i);

		rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 5.0);

		rmAddObjectDefConstraint(colonyShipID, shipVsShip);
		rmAddObjectDefConstraint(colonyShipID, fishLand);
		// rmAddObjectDefConstraint(colonyShipID, Southeastward);
		rmSetObjectDefMinDistance(colonyShipID, 0.0);
		rmSetObjectDefMaxDistance(colonyShipID, rmXFractionToMeters(0.3));

		// Ship placement
		if ( rmGetPlayerTeam(i) == 0 )
		{
	   		rmPlaceObjectDefAtLoc(colonyShipID, i, 0.0, 0.0, 1);
		}
		else
		{
			rmPlaceObjectDefAtLoc(colonyShipID, i, 1.0, 0.0, 1);
		}
		// vector colonyShipLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(colonyShipID, i));
		// rmSetHomeCityWaterSpawnPoint(i, colonyShipLocation);
	}
	*/

   // Text
   rmSetStatusText("",0.65); 
 
   // Place resources that we want forests to avoid
	// Fast Coin
	int silverID = -1;
	int silverCount = cNumberNonGaiaPlayers*3;	// 3 per player, plus starting one.
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));

		rmAddObjectDefConstraint(silverID, avoidFastCoin);
		rmAddObjectDefConstraint(silverID, avoidCoin);
		rmAddObjectDefConstraint(silverID, avoidAll);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, avoidSocket);
		rmAddObjectDefConstraint(silverID, avoidStartingUnits);
		// Keep silver away from the water, to avoid the art problem with the "cliffs."
		rmAddObjectDefConstraint(silverID, avoidWater30);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   }

	// FORESTS
   int forestTreeID = 0;
   int numTries=6*cNumberNonGaiaPlayers;
   int failCount=0;

   for (i=0; <numTries)
   {   
      int forest=rmCreateArea("forest "+i, rmAreaID("big continent"));
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(250));
      rmSetAreaForestType(forest, "new england forest");
      rmSetAreaForestDensity(forest, 1.0);
      rmSetAreaForestClumpiness(forest, 0.9);
      rmSetAreaForestUnderbrush(forest, 0.0);
      rmSetAreaCoherence(forest, 0.4);
      rmSetAreaSmoothDistance(forest, 10);
      rmAddAreaToClass(forest, rmClassID("classForest")); 
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidAll);
      rmAddAreaConstraint(forest, avoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
	  rmAddAreaConstraint(forest, avoidStartingUnits);
		rmAddAreaConstraint(forest, avoidSocket);
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
   rmSetStatusText("",0.70);

 	// DEER
   int deerID=rmCreateObjectDef("deer herd");
	int bonusChance=rmRandFloat(0, 1);
   
	if(bonusChance<0.5)
      rmAddObjectDefItem(deerID, "deer", rmRandInt(6,8), 4.0);
   else
      rmAddObjectDefItem(deerID, "deer", rmRandInt(7,9), 6.0);

   rmSetObjectDefMinDistance(deerID, 0.0);
   rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(deerID, avoidDeer);
	rmAddObjectDefConstraint(deerID, avoidAll);
	rmAddObjectDefConstraint(deerID, avoidSocket);
	rmAddObjectDefConstraint(deerID, avoidTradeRoute);
   rmAddObjectDefConstraint(deerID, avoidImpassableLand);
      rmAddObjectDefConstraint(deerID, avoidStartingUnits);
	rmSetObjectDefCreateHerd(deerID, true);
	rmPlaceObjectDefInArea(deerID, 0, bigContinentID, cNumberNonGaiaPlayers*5);

	// Text
   rmSetStatusText("",0.80);

	int sheepID=rmCreateObjectDef("sheep");
	rmAddObjectDefItem(sheepID, "sheep", 2, 4.0);
	rmSetObjectDefMinDistance(sheepID, 0.0);
	rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(sheepID, avoidSheep);
	rmAddObjectDefConstraint(sheepID, avoidAll);
	rmAddObjectDefConstraint(sheepID, avoidSocket);
	rmAddObjectDefConstraint(sheepID, avoidTradeRoute);
	rmAddObjectDefConstraint(sheepID, longPlayerConstraint);
	rmAddObjectDefConstraint(sheepID, avoidCliffs);
	rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);

	// Large decorations - cut for now.
   /*
	int bigDecorationID=rmCreateObjectDef("Big New England Things");
	int avoidBigDecoration=rmCreateTypeDistanceConstraint("avoid big decorations", "BigPropNewEngland", 12.0);
	rmAddObjectDefItem(bigDecorationID, "BigPropNewEngland", 1, 0.0);
	rmSetObjectDefMinDistance(bigDecorationID, 0.0);
	rmSetObjectDefMaxDistance(bigDecorationID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bigDecorationID, avoidAll);
	rmAddObjectDefConstraint(bigDecorationID, avoidImpassableLand);
	rmAddObjectDefConstraint(bigDecorationID, avoidBigDecoration);
	// rmPlaceObjectDefInArea(bigDecorationID, 0, bigContinentID, cNumberNonGaiaPlayers*2);
	// rmPlaceObjectDefInArea(bigDecorationID, 0, bonusIslandID1, 1);
	// rmPlaceObjectDefInArea(bigDecorationID, 0, bonusIslandID2, 1);
	*/

   // Text
   rmSetStatusText("",0.9);
   
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

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.9;
    float walk = 0.075;
    
    if(randLoc == 1 || cNumberTeams > 2)
      yLoc = .3;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

	// Silly Rock Walls can get placed last.  May not place at all...
	int stoneWallType = -1;
	int stoneWallID = -1;
	int stoneWallCount = cNumberNonGaiaPlayers*2;	
	rmEchoInfo("stoneWall count = "+stoneWallCount);

	for(i=0; < stoneWallCount)
	{
		stoneWallType = rmRandInt(1,4);
      stoneWallID = rmCreateGrouping("stone wall "+i, "ne_rockwall "+stoneWallType);
		rmAddGroupingToClass(stoneWallID, rmClassID("classWall"));
      rmSetGroupingMinDistance(stoneWallID, 0.0);
      rmSetGroupingMaxDistance(stoneWallID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(stoneWallID, avoidFastCoin);
		rmAddGroupingConstraint(stoneWallID, avoidImpassableLand);
		rmAddGroupingConstraint(stoneWallID, avoidTradeRoute);
		rmAddGroupingConstraint(stoneWallID, avoidSocket);
		rmAddGroupingConstraint(stoneWallID, wallConstraint);
		rmAddGroupingConstraint(stoneWallID, avoidWater20);
		rmAddGroupingConstraint(stoneWallID, avoidStartingUnits);
		rmPlaceGroupingAtLoc(stoneWallID, 0, 0.5, 0.5);
   }
}