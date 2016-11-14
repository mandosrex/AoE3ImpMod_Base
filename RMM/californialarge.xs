// CALIFORNIA

// JANUARY 2006
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

   if (rmAllocateSubCivs(2) == true)
   {

	  if(rmRandFloat(0,1) < 0.65)

	  {
		  subCiv0=rmGetCivID("Klamath");
      rmEchoInfo("subCiv0 is Klamath "+subCiv0);
	  if (subCiv0 >= 0)
		 rmSetSubCiv(0, "Klamath");
	  }
      else
	  {
		subCiv0=rmGetCivID("Nootka");
      rmEchoInfo("subCiv0 is Nootka "+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Nootka");
	  }
	  
	  if (rmRandFloat(0,1) < 0.65)
	  {
		subCiv1=rmGetCivID("Nootka");
      rmEchoInfo("subCiv1 is Nootka "+subCiv1);
      if (subCiv1 >= 0)
         rmSetSubCiv(1, "Nootka");
      }
	  else
	  {
		  subCiv1=rmGetCivID("Klamath");
      rmEchoInfo("subCiv1 is Klamath "+subCiv1);
	  if (subCiv1 >= 0)
		 rmSetSubCiv(1, "Klamath");
	  }
   }

	// Sets which way the Trade Route goes
	float handedness = rmRandFloat(0.0, 1.0);


	// Picks the map size
	
	if (rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1))
		int playerTiles=21820;
	else
		playerTiles=22320;

	if (cNumberNonGaiaPlayers<3)
		int size=2.3*sqrt(cNumberNonGaiaPlayers*playerTiles);
	else
		size=2.1*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Some map turbulence...
	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);  // Like Texas for the moment.
	rmSetMapElevationHeightBlend(0.2);

	// Picks a default water height
	rmSetSeaLevel(2.0);

	// Picks default terrain and water
	//rmSetSeaType("new england coast");
	rmSetSeaType("california coast");
	rmEnableLocalWater(false);
	rmTerrainInitialize("water");
	rmSetMapType("california");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);
	rmSetMapType("grass");
   rmSetLightingSet("california");
	chooseMercs();

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.9);

	// Define some classes. These are used later for constraints.
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classCliff");
	rmDefineClass("classPatch");
	int classbigContinent=rmDefineClass("big continent");
	rmDefineClass("corner");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("natives");
	rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("flag");
	rmDefineClass("classHillArea");
	int randomClass = rmDefineClass("randomAreaClass");
	// Player placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 8.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
	// Map edge constraintsw
	//int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(28), rmZTilesToFraction(28), 1.0-rmXTilesToFraction(28), 1.0-rmZTilesToFraction(28), 0.01);
	int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.40), rmDegreesToRadians(0), rmDegreesToRadians(360));
	
	int randomAreaConstraint=rmCreateClassDistanceConstraint("continent avoids random areas", randomClass, 20.0);

	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 30.0);
	int playerForestConstraint=rmCreateClassDistanceConstraint("forest vs. player", rmClassID("classForest"), 8.0);
	int Northconstraint = rmCreateBoxConstraint("stay in North portion", 0, 0, 1, 0.5);
	int Southconstraint = rmCreateBoxConstraint("stay in South portion", 0, 0, 0.5, 1);
	int Eastconstraint = rmCreateBoxConstraint("stay in Far East portion", 0, .7, 1, 0);
	int EastForestconstraint = rmCreateBoxConstraint("stay in East portion", 0.4, 0.0, 0.8, 1.0);
	int WestForestconstraint = rmCreateBoxConstraint("stay in Far West portion", 0, 1, 0.60, 0);
	int Centralconstraint = rmCreateBoxConstraint("stay in Central portion", 0.25, 0.25, 0.75, 0.75);
	int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
	int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 20.0);
	int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-180, rmGetMapXSize()-40, 0, 0, 0);
	int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);
	int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 5.0);

	// Bonus area constraint
	int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classbigContinent, 20.0);

	// Resource avoidance
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 10.0);
	int cliffConstraint=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 20.0);
	int avoidCliff=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 10.0);
	int shortAvoidCliff=rmCreateClassDistanceConstraint("short stuff vs. cliff", rmClassID("classCliff"), 8.0);
	int avoidDeer=rmCreateTypeDistanceConstraint("food avoids food", "deer", 50.0);
	int avoidElk=rmCreateTypeDistanceConstraint("elk avoids elk", "elk", 40.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 45.0);
	int avoidCoinFar=rmCreateTypeDistanceConstraint("coin avoids coin Far", "gold", 75.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 28.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidHomeCityWaterSpawnFlag=rmCreateTypeDistanceConstraint("avoid HomeCityWaterSpawnFlag", "HomeCityWaterSpawnFlag", 20.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 8.0);
	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
    int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
	int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "HumpbackWhale", 50.0);
	int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 25.0);
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 55.0);
    int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
   int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);

	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int mediumAvoidImpassableLand=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 15.0);
	int mediumShortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("mediumshort avoid impassable land", "Land", false, 10.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 20.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 10.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.9);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 12.0);
   int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 8.0);
   int nativeAvoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 20.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 30.0);


   // Text
   rmSetStatusText("",0.10);

	// DEFINE AREAS

   // Set up player starting locations. 


	rmSetTeamSpacingModifier(0.4);


	if(cNumberTeams > 2) //ffa
	{
		rmSetPlacementSection(0.05, 0.95);
		rmSetTeamSpacingModifier(0.70);
		rmPlacePlayersCircular(0.4, 0.4, 0);
	}
	else
	{
		float teamStartLoc = rmRandFloat(0.0, 1.0);
		//team 0 starts on top
		if (teamStartLoc > 0.5) 
		{
			rmSetPlacementTeam(0);
			//rmSetPlacementSection(0.40, 0.50);
			rmPlacePlayersLine(0.90, 0.85, 0.50, 0.90, 0.04, 0.02);
			rmSetTeamSpacingModifier(0.20);
			//rmPlacePlayersCircular(0.35, 0.35, rmDegreesToRadians(5.0));
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.60, 0.10, 0.15, 0.20, 0.04, 0.02);
			rmSetTeamSpacingModifier(0.20);
			//rmSetPlacementSection(0.10, 0.20); 
			//rmPlacePlayersCircular(0.35, 0.35, rmDegreesToRadians(5.0));
		}
		else
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.60, 0.10, 0.15, 0.20, 0.04, 0.02);
			rmSetTeamSpacingModifier(0.20);
			//rmSetPlacementSection(0.10, 0.20);
			//rmPlacePlayersCircular(0.35, 0.35, rmDegreesToRadians(5.0));
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.90, 0.85, 0.50, 0.90, 0.04, 0.02);
			rmSetTeamSpacingModifier(0.20);
			//rmSetPlacementSection(0.40, 0.50); 
			//rmPlacePlayersCircular(0.35, 0.35, rmDegreesToRadians(5.0));
		}
	}


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
		rmAddAreaConstraint(id, playerEdgeConstraint); //this is for land only
		rmSetAreaLocPlayer(id, i);
		rmSetAreaTerrainType(id, "california\ground5_cal");
		rmSetAreaWarnFailure(id, false);

	}

	// Build the areas.
	rmBuildAllAreas();
	

   // Text
   rmSetStatusText("",0.20);


	// Build up big continent - called, unoriginally enough, "big continent"
   int bigContinentID=rmCreateArea("big continent");
   rmSetAreaSize(bigContinentID, 0.55, 0.55);		// 0.65, 0.65
   rmSetAreaWarnFailure(bigContinentID, false);
   rmAddAreaToClass(bigContinentID, classbigContinent);
   rmSetAreaSmoothDistance(bigContinentID, 50);
	rmSetAreaMix(bigContinentID, "california_grass");
   rmSetAreaElevationType(bigContinentID, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinentID, 4.0);
   rmSetAreaBaseHeight(bigContinentID, 4.0);
   rmSetAreaElevationMinFrequency(bigContinentID, 0.09);
   rmSetAreaElevationOctaves(bigContinentID, 3);
   rmSetAreaElevationPersistence(bigContinentID, 0.2);      
	rmSetAreaCoherence(bigContinentID, 0.80);
	rmSetAreaLocation(bigContinentID, 0.70, 0.45);
   rmSetAreaEdgeFilling(bigContinentID, 5);
	rmSetAreaObeyWorldCircleConstraint(bigContinentID, false);
	rmBuildArea(bigContinentID);



	rmSetStatusText("",0.30);

		// Build up small continent spurs called "small continent spur 1 & 2"
   int smallContinent1ID=rmCreateArea("small continent spur 1");
   rmSetAreaSize(smallContinent1ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent1ID, false);
   rmAddAreaToClass(smallContinent1ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent1ID, 50);
	rmSetAreaMix(smallContinent1ID, "california_grass");
   rmSetAreaElevationType(smallContinent1ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent1ID, 4.0);
   rmSetAreaBaseHeight(smallContinent1ID, 4.0);
   rmSetAreaElevationMinFrequency(smallContinent1ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent1ID, 3);
   rmSetAreaElevationPersistence(smallContinent1ID, 0.2);      
	rmSetAreaCoherence(smallContinent1ID, 0.80);
	rmSetAreaLocation(smallContinent1ID, 0.64, 0.65);
   rmSetAreaEdgeFilling(smallContinent1ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent1ID, false);
	rmBuildArea(smallContinent1ID);


   rmSetStatusText("",0.35);

	// Build up small continent spurs called "small continent spur 1 & 2"
   int smallContinent2ID=rmCreateArea("small continent spur 2");
   rmSetAreaSize(smallContinent2ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent2ID, false);
   rmAddAreaToClass(smallContinent2ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent2ID, 50);
	rmSetAreaMix(smallContinent2ID, "california_grass");
   rmSetAreaElevationType(smallContinent2ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent2ID, 4.0);
   rmSetAreaBaseHeight(smallContinent2ID, 4.0);
   rmSetAreaElevationMinFrequency(smallContinent2ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent2ID, 3);
   rmSetAreaElevationPersistence(smallContinent2ID, 0.2);      
	rmSetAreaCoherence(smallContinent2ID, 0.80);
	rmSetAreaLocation(smallContinent2ID, 0.45, 0.25);
   rmSetAreaEdgeFilling(smallContinent2ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent2ID, false);
	rmBuildArea(smallContinent2ID);

	// Hilly areas

	int hillEastID=rmCreateArea("East hills");
	int avoidE = rmCreateAreaDistanceConstraint("avoid e", hillEastID, 5.0);
	int EastHillConstraint = rmCreateAreaConstraint("East Hill Constraint", hillEastID);

	rmSetAreaSize(hillEastID, 0.2, 0.2);
	rmSetAreaWarnFailure(hillEastID, false);
	rmSetAreaSmoothDistance(hillEastID, 20);
	rmSetAreaMix(hillEastID, "california_desert0");
	rmAddAreaTerrainLayer(hillEastID, "california\desert6_cal", 0, 4);
	rmAddAreaTerrainLayer(hillEastID, "california\desert5_cal", 4, 8);
	rmAddAreaTerrainLayer(hillEastID, "california\desert4_cal", 8, 12);
	rmSetAreaElevationType(hillEastID, cElevTurbulence);
	rmSetAreaElevationVariation(hillEastID, 4.0);
	rmSetAreaBaseHeight(hillEastID, 4.0);
	rmSetAreaElevationMinFrequency(hillEastID, 0.05);
	rmSetAreaElevationOctaves(hillEastID, 3);
	rmSetAreaElevationPersistence(hillEastID, 0.3);      
	rmSetAreaElevationNoiseBias(hillEastID, 0.5);
	rmSetAreaElevationEdgeFalloffDist(hillEastID, 20.0);
	rmSetAreaCoherence(hillEastID, 0.5);
	rmSetAreaLocation(hillEastID, 0.9, 0.3);
	rmSetAreaEdgeFilling(hillEastID, 5);
	rmAddAreaInfluenceSegment(hillEastID, 0.6, 0.0, 1.2, 1.2);
	rmSetAreaHeightBlend(hillEastID, 1);
	rmSetAreaObeyWorldCircleConstraint(hillEastID, false);
	rmAddAreaToClass(hillEastID, rmClassID("classHillArea"));
	rmBuildArea(hillEastID);

	int hillCentralID=rmCreateArea("central hills");
	int avoidCentral = rmCreateAreaDistanceConstraint("avoid central", hillCentralID, 3.0);
	int CentralHillConstraint = rmCreateAreaConstraint("Central Hill Constraint", hillCentralID);

	rmSetAreaSize(hillCentralID, 0.2, 0.2);
	rmSetAreaWarnFailure(hillCentralID, false);
	rmSetAreaSmoothDistance(hillCentralID, 30);
	rmSetAreaMix(hillCentralID, "california_grassrocks");
	//rmAddAreaTerrainLayer(hillCentralID, "california\desert6_cal", 0, 4);
	//rmAddAreaTerrainLayer(hillCentralID, "california\desert5_cal", 4, 8);
	rmSetAreaElevationType(hillCentralID, cElevTurbulence);
	rmSetAreaElevationVariation(hillCentralID, 2.0);
	rmSetAreaBaseHeight(hillCentralID, 4);
	rmSetAreaElevationMinFrequency(hillCentralID, 0.05);
	rmSetAreaElevationOctaves(hillCentralID, 3);
	rmSetAreaElevationPersistence(hillCentralID, 0.3);      
	rmSetAreaElevationNoiseBias(hillCentralID, 0.5);
	rmSetAreaElevationEdgeFalloffDist(hillCentralID, 0.0);
	rmSetAreaCoherence(hillCentralID, 0.7);
	rmSetAreaLocation(hillCentralID, 0.5, 0.5);
	rmAddAreaInfluenceSegment(hillCentralID, 0.4, 0.0, 0.8, 1);
	rmSetAreaHeightBlend(hillCentralID, 1);
	rmSetAreaObeyWorldCircleConstraint(hillCentralID, false);
	rmAddAreaToClass(hillCentralID, rmClassID("classHillArea"));
	rmBuildArea(hillCentralID);


	// Placement order
   // Trade route -> River (none on this map) -> Natives -> Secrets -> Cliffs -> Nuggets

   // Text
   rmSetStatusText("",0.40);

	// TRADE ROUTES
	int tradeRouteID = rmCreateTradeRoute();

	int socketID=rmCreateObjectDef("sockets for Trade Route");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmAddObjectDefConstraint(socketID, avoidImpassableLand);
	rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 10.0);

	if(handedness < 0.5)
		{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.95);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.78, 0.80, 5, 8);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.78, 0.60, 5, 8);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.42, 0.40, 5, 8);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.44, 0.35, 5, 8);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.05);
		}
	else
		{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.8, 0.95);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.65, 0.75, 5, 8);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.48, 0.58, 5, 8);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.65, 0.45, 5, 8);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.05);
		}

	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
	if(placedTradeRoute == false)
		rmEchoError("Failed to place trade route"); 

    // add the sockets along the trade route.
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.12);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	if(handedness < 0.5)
		{
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
		}
	else
		{
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.45);
		}
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.95);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		// PLAYER STARTING RESOURCES

   rmClearClosestPointConstraints();
   int TCfloat = -1;
   if (cNumberTeams == 2)
		if (cNumberPlayers > 6)
			TCfloat = 120;
		else if (cNumberPlayers == 2)
			TCfloat = 15;
		else
			TCfloat = 75;
   else 
		TCfloat = 120;
    

	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
		{
			rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
		}
		else
		{
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
		}

	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, TCfloat);

	rmAddObjectDefConstraint(TCID, avoidTradeRoute);
	if (rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1))
		rmAddObjectDefConstraint(TCID, avoidTownCenterFar);
	else
		rmAddObjectDefConstraint(TCID, avoidTownCenter);
	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
	rmAddObjectDefConstraint(TCID, longAvoidImpassableLand);

	//WATER HC ARRIVAL POINT

   int waterFlagID = 0;
   for(i=1; <cNumberPlayers)
    {
        waterFlagID=rmCreateObjectDef("HC water flag "+i);
        rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 20.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
	}  

	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "minegold", 1, 0);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidCliff);
	rmSetObjectDefMinDistance(playergoldID, 10.0);
	rmSetObjectDefMaxDistance(playergoldID, 15.0);
    rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);

	float sheepstart = rmRandFloat(0.0, 1.0);
	int playerSheepID = rmCreateObjectDef("player sheep");
	if(sheepstart < 0.5)
		{
		rmAddObjectDefItem(playerSheepID, "sheep", rmRandInt(5,8), 8.0);
		rmSetObjectDefMinDistance(playerSheepID, 10);
		rmSetObjectDefMaxDistance(playerSheepID, 16);
		rmAddObjectDefConstraint(playerSheepID, avoidAll);
		rmAddObjectDefConstraint(playerSheepID, avoidImpassableLand);
		rmAddObjectDefConstraint(playerSheepID, avoidCliff);
		}
	else
		{
		rmAddObjectDefItem(playerSheepID, "sheep", rmRandInt(2,3), 2.0);
		rmSetObjectDefMinDistance(playerSheepID, 10);
		rmSetObjectDefMaxDistance(playerSheepID, 16);
		rmAddObjectDefConstraint(playerSheepID, avoidAll);
		rmAddObjectDefConstraint(playerSheepID, avoidImpassableLand);
		rmAddObjectDefConstraint(playerSheepID, avoidCliff);
		}

	int playerDeerID=rmCreateObjectDef("player deer");
    rmAddObjectDefItem(playerDeerID, "Deer", rmRandInt(6,7), 8.0);
    rmSetObjectDefMinDistance(playerDeerID, 8);
    rmSetObjectDefMaxDistance(playerDeerID, 18);
	rmAddObjectDefConstraint(playerDeerID, avoidAll);
	rmAddObjectDefConstraint(playerDeerID, avoidCliff);
    rmAddObjectDefConstraint(playerDeerID, avoidImpassableLand);
	rmSetObjectDefCreateHerd(playerDeerID, true);

	int playerTreeID=rmCreateObjectDef("player trees");
    rmAddObjectDefItem(playerTreeID, "TreeMadrone", rmRandInt(5,9), 8.0);
    rmSetObjectDefMinDistance(playerTreeID, 18);
    rmSetObjectDefMaxDistance(playerTreeID, 25);
	rmAddObjectDefConstraint(playerTreeID, avoidAll);
	rmAddObjectDefConstraint(playerTreeID, avoidCliff);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);

	int playerNuggetID= rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefConstraint(playerNuggetID, longAvoidImpassableLand);
  	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
  	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
  	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidCliff);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);

	for(i=1; <cNumberPlayers)
   {
	rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

	rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playergoldID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerSheepID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
     
  if(ypIsAsian(i) && rmGetNomadStart() == false)
    rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

	vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
   }
   rmClearClosestPointConstraints();   	

   // NATIVE AMERICANS

   // Text
	rmSetStatusText("",0.50);
   
	float NativeVillageLoc = rmRandFloat(0,1); //
     
	int nootkaVillageID = -1;
	int nootkaVillageType = rmRandInt(1,5);
	int KlamathVillageID = -1;
	int KlamathVillageType = rmRandInt(1,3);
	int Klamath1VillageID = -1;
	int Klamath1VillageType = rmRandInt(1,3);
	int nootka1VillageID = -1;
	int nootka1VillageType = rmRandInt(1,5);

	if(handedness > .5)
	{
		if(subCiv0 == rmGetCivID("Klamath"))
		{   
			KlamathVillageID = rmCreateGrouping("Klamath village", "native Klamath village "+KlamathVillageType);
			rmSetGroupingMinDistance(KlamathVillageID, 0.0);
			rmSetGroupingMaxDistance(KlamathVillageID, rmXFractionToMeters(0.2));
			rmAddGroupingToClass(KlamathVillageID, rmClassID("natives"));
			rmAddGroupingConstraint(KlamathVillageID, longAvoidImpassableLand);
			rmAddGroupingToClass(KlamathVillageID, rmClassID("importantItem"));
			rmAddGroupingConstraint(KlamathVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(KlamathVillageID, avoidNatives);
			rmAddGroupingConstraint(KlamathVillageID, avoidTownCenter);

			//rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.36, 0.43);
			rmPlaceGroupingAtLoc(KlamathVillageID, 0, 0.48, 0.25);
		}

		else if (subCiv0 == rmGetCivID("Nootka"))
		{
			nootkaVillageID = rmCreateGrouping("nootka village", "native nootka village "+nootkaVillageType);
			rmSetGroupingMinDistance(nootkaVillageID, 0.0);
			rmSetGroupingMaxDistance(nootkaVillageID, rmXFractionToMeters(0.2));
			rmAddGroupingToClass(nootkaVillageID, rmClassID("natives"));
			rmAddGroupingConstraint(nootkaVillageID, longAvoidImpassableLand);
			rmAddGroupingToClass(nootkaVillageID, rmClassID("importantItem"));
			rmAddGroupingConstraint(nootkaVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(nootkaVillageID, avoidNatives);
			rmAddGroupingConstraint(nootkaVillageID, avoidTownCenter);
			rmPlaceGroupingAtLoc(nootkaVillageID, 0, 0.36, 0.43);
		}
	}
	else
	{
		if(subCiv0 == rmGetCivID("Klamath"))
		{   
			Klamath1VillageID = rmCreateGrouping("Klamath1 village", "native Klamath village "+Klamath1VillageType);
			rmSetGroupingMinDistance(Klamath1VillageID, 0.0);
			rmSetGroupingMaxDistance(Klamath1VillageID, rmXFractionToMeters(0.2));
			rmAddGroupingToClass(Klamath1VillageID, rmClassID("natives"));
			rmAddGroupingConstraint(Klamath1VillageID, longAvoidImpassableLand);
			rmAddGroupingToClass(Klamath1VillageID, rmClassID("importantItem"));
			rmAddGroupingConstraint(Klamath1VillageID, avoidTradeRoute);
			rmAddGroupingConstraint(Klamath1VillageID, avoidTownCenter);
			rmAddGroupingConstraint(Klamath1VillageID, avoidNatives);
			rmPlaceGroupingAtLoc(Klamath1VillageID, 0, 0.70, 0.15);
		}

		else if (subCiv0 == rmGetCivID("Nootka"))
		{
			nootka1VillageID = rmCreateGrouping("nootka1 village", "native nootka village "+nootka1VillageType);
			rmSetGroupingMinDistance(nootka1VillageID, 0.0);
			rmSetGroupingMaxDistance(nootka1VillageID, rmXFractionToMeters(0.2));
			rmAddGroupingToClass(nootka1VillageID, rmClassID("natives"));
			rmAddGroupingConstraint(nootka1VillageID, longAvoidImpassableLand);
			rmAddGroupingToClass(nootka1VillageID, rmClassID("importantItem"));
			rmAddGroupingConstraint(nootka1VillageID, avoidTradeRoute);
			rmAddGroupingConstraint(nootka1VillageID, avoidTownCenter);
			rmAddGroupingConstraint(nootka1VillageID, avoidNatives);
			rmPlaceGroupingAtLoc(nootka1VillageID, 0, 0.70, 0.15);
		}
	}

	if(subCiv1 == rmGetCivID("Klamath"))
	{
		int Klamath2VillageID = -1;
		int Klamath2VillageType = rmRandInt(4,5);
		Klamath2VillageID = rmCreateGrouping("Klamath2 village", "native Klamath village "+Klamath2VillageType);
		rmSetGroupingMinDistance(Klamath2VillageID, 0.0);
		rmSetGroupingMaxDistance(Klamath2VillageID, rmXFractionToMeters(0.2));
		rmAddGroupingToClass(Klamath2VillageID, rmClassID("natives"));
		rmAddObjectDefConstraint(Klamath2VillageID, longAvoidImpassableLand);
		rmAddGroupingConstraint(Klamath2VillageID, longAvoidImpassableLand);
		rmAddGroupingConstraint(Klamath2VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(Klamath2VillageID, avoidTownCenter);
		rmAddGroupingConstraint(Klamath2VillageID, avoidNatives);
		rmPlaceGroupingAtLoc(Klamath2VillageID, 0, 0.55, 0.80);
	}
	else if (subCiv1 == rmGetCivID("Nootka"))
	{   
		int nootka2VillageID = -1;
		int nootka2VillageType = rmRandInt(1,5);
		nootka2VillageID = rmCreateGrouping("nootka2 village", "native nootka village "+nootka2VillageType);
		rmSetGroupingMinDistance(nootka2VillageID, 0.0);
		rmSetGroupingMaxDistance(nootka2VillageID, rmXFractionToMeters(0.2));
		rmAddGroupingToClass(nootka2VillageID, rmClassID("natives"));
		rmAddGroupingConstraint(nootka2VillageID, avoidImpassableLand);
		rmAddGroupingToClass(nootka2VillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(nootka2VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(nootka2VillageID, avoidTownCenter);
		rmAddGroupingConstraint(nootka2VillageID, avoidNatives);
		rmPlaceGroupingAtLoc(nootka2VillageID, 0, 0.55, 0.80);
	}

  // Define and place Cliffs
   
   int numTries=cNumberNonGaiaPlayers+2;
   
   for(i=0; <numTries)
   {
      int cliffID=rmCreateArea("cliff"+i);
      //rmSetAreaSize(cliffID, rmAreaTilesToFraction(500), rmAreaTilesToFraction(1000));
	  rmSetAreaSize(cliffID, rmAreaTilesToFraction(900), rmAreaTilesToFraction(1800));
      rmSetAreaWarnFailure(cliffID, false);
	  rmSetAreaCliffType(cliffID, "California");
	  rmSetAreaCliffEdge(cliffID, 1, 0.6, 0.8, 1.0, 0);
      //rmSetAreaCliffEdge(cliffID, 1, 0.6, 0.1, 1.0, 0);
	  //rmSetAreaCliffEdge(cliffID, 1, 1);
      rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, true);
      rmSetAreaCliffHeight(cliffID, 5, 2.0, 0.5);
      rmSetAreaHeightBlend(cliffID, 1);
      rmAddAreaToClass(cliffID, rmClassID("classCliff")); 
      rmAddAreaConstraint(cliffID, longAvoidImpassableLand);
      rmAddAreaConstraint(cliffID, cliffConstraint);
	  rmAddAreaConstraint(cliffID, avoidTownCenterFar);
      rmAddAreaConstraint(cliffID, avoidImportantItem);
      rmAddAreaConstraint(cliffID, avoidTradeRoute);
	  rmAddAreaConstraint(cliffID, CentralHillConstraint);
	  rmAddAreaConstraint(cliffID, avoidCoin);
      rmSetAreaMinBlobs(cliffID, 4);
      rmSetAreaMaxBlobs(cliffID, 6);
      rmSetAreaMinBlobDistance(cliffID, 16.0);
      rmSetAreaMaxBlobDistance(cliffID, 30.0);
      rmSetAreaSmoothDistance(cliffID, 10);
      rmSetAreaCoherence(cliffID, 0.75);
      rmBuildArea(cliffID);
   } 

   // Text
	rmSetStatusText("",0.60);

   // Define and place Nuggets
    

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.0;
    float yLoc = 0.5;
    float walk = 0.075;
    
    if(randLoc == 1)
      xLoc = .35;
    
    else
      xLoc = .65;
      
    if(cNumberTeams > 2) {
      xLoc = .35;
      walk = 0.1;
    }
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
   
	int nuggetID= rmCreateObjectDef("nugget easy"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
  	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
  	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int nuggetmediumID= rmCreateObjectDef("nugget medium"); 
	rmAddObjectDefItem(nuggetmediumID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmSetObjectDefMinDistance(nuggetmediumID, 0.0);
	rmSetObjectDefMaxDistance(nuggetmediumID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggetmediumID, avoidNugget);
  	rmAddObjectDefConstraint(nuggetmediumID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggetmediumID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetmediumID, avoidCliff);
  	rmAddObjectDefConstraint(nuggetmediumID, avoidAll);
  	rmAddObjectDefConstraint(nuggetmediumID, longAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(nuggetmediumID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);


	int nuggethardID= rmCreateObjectDef("nugget hard"); 
	rmAddObjectDefItem(nuggethardID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nuggethardID, 0.0);
	rmSetObjectDefMaxDistance(nuggethardID, rmXFractionToMeters(0.5));
  	rmAddObjectDefConstraint(nuggethardID, avoidNugget);
  	rmAddObjectDefConstraint(nuggethardID, avoidTownCenter);
  	rmAddObjectDefConstraint(nuggethardID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggethardID, avoidCliff);
  	rmAddObjectDefConstraint(nuggethardID, avoidAll);
	rmAddObjectDefConstraint(nuggethardID, playerEdgeConstraint);
  	rmAddObjectDefConstraint(nuggethardID, longAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(nuggethardID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	if(rmRandFloat(0,1) < 0.25) //places more hard 25% of the time
	{
		int nuggethard2ID= rmCreateObjectDef("nugget more hard"); 
		rmAddObjectDefItem(nuggethard2ID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(3, 3);
		rmSetObjectDefMinDistance(nuggethard2ID, 0.0);
		rmSetObjectDefMaxDistance(nuggethard2ID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggethard2ID, avoidNugget);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggethard2ID, avoidCliff);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidAll);
		rmAddObjectDefConstraint(nuggethard2ID, playerEdgeConstraint);
  		rmAddObjectDefConstraint(nuggethard2ID, longAvoidImpassableLand);
		rmPlaceObjectDefAtLoc(nuggethard2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);
	}


	//only try to place these 25% of the time
	   if(rmRandFloat(0,1) < 0.25)
	   {
		int nuggetnutsID= rmCreateObjectDef("nugget nuts"); 
		rmAddObjectDefItem(nuggetnutsID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmSetObjectDefMinDistance(nuggetnutsID, 0.0);
		rmSetObjectDefMaxDistance(nuggetnutsID, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(nuggetnutsID, avoidNugget);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidTownCenter);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetnutsID, avoidCliff);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidAll);
		rmAddObjectDefConstraint(nuggetnutsID, playerEdgeConstraint);
  		rmAddObjectDefConstraint(nuggetnutsID, longAvoidImpassableLand);
		rmPlaceObjectDefAtLoc(nuggetnutsID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	   }


	//Place fish
   if(rmRandFloat(0,1) < 0.5)
   {
		int whaleID=rmCreateObjectDef("whale");
		rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 0.0);
		rmSetObjectDefMinDistance(whaleID, 0.0);
		rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
		rmAddObjectDefConstraint(whaleID, whaleLand);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
   }

   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishSalmon", 3, 9.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);
 

   // Place resources that we want forests to avoid

	// Gold mines

 
	int goldType = -1;
	int goldCount = (cNumberNonGaiaPlayers + rmRandInt(1,2));
	rmEchoInfo("gold count = "+goldCount);

	for(i=0; < goldCount)
	{
	  int goldID = rmCreateObjectDef("gold West "+i);
	  rmAddObjectDefItem(goldID, "minegold", 1, 0.0);
      rmSetObjectDefMinDistance(goldID, 0.0);
      rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(goldID, avoidCoin);
      rmAddObjectDefConstraint(goldID, avoidAll);
	  rmAddObjectDefConstraint(goldID, avoidCliff);
      rmAddObjectDefConstraint(goldID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(goldID, avoidTradeRoute);
      rmAddObjectDefConstraint(goldID, mediumAvoidImpassableLand);
	  rmAddObjectDefConstraint(goldID, WestForestconstraint);
	  rmPlaceObjectDefAtLoc(goldID, 0, 0.5, 0.5);
   }

	goldCount = (cNumberNonGaiaPlayers + rmRandInt(1,2));
	rmEchoInfo("gold2 count = "+goldCount);

	for(i=0; < goldCount)
	{
	  int goldEastID = rmCreateObjectDef("gold East "+i);
	  rmAddObjectDefItem(goldEastID, "minegold", 1, 0.0);
      rmSetObjectDefMinDistance(goldEastID, 0.0);
      rmSetObjectDefMaxDistance(goldEastID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(goldEastID, avoidCoin);
      rmAddObjectDefConstraint(goldEastID, avoidAll);
	  rmAddObjectDefConstraint(goldEastID, avoidCliff);
      rmAddObjectDefConstraint(goldEastID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(goldEastID, avoidTradeRoute);
      rmAddObjectDefConstraint(goldEastID, mediumAvoidImpassableLand);
	  rmAddObjectDefConstraint(goldEastID, EastHillConstraint);
	  rmPlaceObjectDefAtLoc(goldEastID, 0, 0.5, 0.5);
	}

	if (cNumberNonGaiaPlayers > 4)
		goldCount = (2);
	else
		goldCount = (cNumberNonGaiaPlayers + 1);
	rmEchoInfo("gold3 count = "+goldCount);

	for(i=0; < goldCount)
	{
	  int goldRandomID = rmCreateObjectDef("gold Random "+i);
	  rmAddObjectDefItem(goldRandomID, "minegold", 1, 0.0);
      rmSetObjectDefMinDistance(goldRandomID, 0.0);
      rmSetObjectDefMaxDistance(goldRandomID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(goldRandomID, avoidCoinFar);
      rmAddObjectDefConstraint(goldRandomID, avoidAll);
	  rmAddObjectDefConstraint(goldRandomID, shortAvoidCliff);
      rmAddObjectDefConstraint(goldRandomID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(goldRandomID, avoidTradeRoute);
      rmAddObjectDefConstraint(goldRandomID, mediumAvoidImpassableLand);
	  rmPlaceObjectDefAtLoc(goldRandomID, 0, 0.5, 0.5); 
   }

   // Text
   rmSetStatusText("",0.70); 

   // FORESTS
   int forestTreeID = 0;
   numTries=2.5*cNumberNonGaiaPlayers;
   int failCount=0;
   for (i=0; <numTries)
      {   
         int forestRedwood=rmCreateArea("forest redwood "+i, rmAreaID("big continent"));
         rmSetAreaWarnFailure(forestRedwood, false);
         rmSetAreaSize(forestRedwood, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
         rmSetAreaForestType(forestRedwood, "california redwood forest");
		 rmSetAreaForestDensity(forestRedwood, 0.45);
         rmSetAreaForestClumpiness(forestRedwood, 0.15);
         rmSetAreaForestUnderbrush(forestRedwood, 0.6);
         rmSetAreaMinBlobs(forestRedwood, 12);
         rmSetAreaMaxBlobs(forestRedwood, 22);
         rmSetAreaMinBlobDistance(forestRedwood, 10.0);
         rmSetAreaMaxBlobDistance(forestRedwood, 20.0);
         rmSetAreaCoherence(forestRedwood, 0.35);
         rmSetAreaSmoothDistance(forestRedwood, 10);
         rmAddAreaToClass(forestRedwood, rmClassID("classForest")); 
         rmAddAreaConstraint(forestRedwood, forestConstraint);
         rmAddAreaConstraint(forestRedwood, avoidAll);
         //rmAddAreaConstraint(forestRedwood, avoidCliff);
         rmAddAreaConstraint(forestRedwood, avoidImpassableLand); 
         rmAddAreaConstraint(forestRedwood, avoidTradeRouteShort);
		 rmAddAreaConstraint(forestRedwood, WestForestconstraint);
		 
         if(rmBuildArea(forestRedwood)==false)
         {
            // Stop trying once we fail 4 times in a row.
            failCount++;
            if(failCount==4)
               break;
         }
         else
            failCount=0; 
      }
	
	forestTreeID = 0;
	numTries=3*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
      {   
         int forest=rmCreateArea("forest pine forest "+i, rmAreaID("big continent"));
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
         rmSetAreaForestType(forest, "California pine forest");
		 rmSetAreaForestDensity(forest, 0.85);
         rmSetAreaForestClumpiness(forest, 0.10);
         rmSetAreaForestUnderbrush(forest, 0.6);
         rmSetAreaMinBlobs(forest, 8);
         rmSetAreaMaxBlobs(forest, 15);
         rmSetAreaMinBlobDistance(forest, 20.0);
         rmSetAreaMaxBlobDistance(forest, 40.0);
         rmSetAreaCoherence(forest, 0.25);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
         rmAddAreaConstraint(forest, forestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
         //rmAddAreaConstraint(forest, avoidCliff);
         rmAddAreaConstraint(forest, avoidImpassableLand); 
         rmAddAreaConstraint(forest, avoidTradeRouteShort);
		 rmAddAreaConstraint(forest, CentralHillConstraint);
		 
         if(rmBuildArea(forest)==false)
         {
            // Stop trying once we fail 5 times in a row.
            failCount++;
            if(failCount==5)
               break;
         }
         else
            failCount=0; 
      } 

	forestTreeID = 0;
	numTries=2*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
      {   
         int forestEast=rmCreateArea("forest desert "+i, rmAreaID("big continent"));
         rmSetAreaWarnFailure(forestEast, false);
         rmSetAreaSize(forestEast, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
         rmSetAreaForestType(forestEast, "California Desert Forest");
		 rmSetAreaForestDensity(forestEast, 0.6);
         rmSetAreaForestClumpiness(forestEast, 0.1);
         rmSetAreaForestUnderbrush(forestEast, 0.6);
         rmSetAreaMinBlobs(forestEast, 10);
         rmSetAreaMaxBlobs(forestEast, 20);
         rmSetAreaMinBlobDistance(forestEast, 16.0);
         rmSetAreaMaxBlobDistance(forestEast, 35.0);
         rmSetAreaCoherence(forestEast, 0.8);
         rmSetAreaSmoothDistance(forestEast, 10);
         rmAddAreaToClass(forestEast, rmClassID("classForest")); 
         rmAddAreaConstraint(forestEast, forestConstraint);
         rmAddAreaConstraint(forestEast, avoidAll);
         rmAddAreaConstraint(forestEast, avoidCliff);
         rmAddAreaConstraint(forestEast, avoidImpassableLand); 
         rmAddAreaConstraint(forestEast, avoidTradeRouteShort);
		 rmAddAreaConstraint(forestEast, EastHillConstraint);
		 
         if(rmBuildArea(forestEast)==false)
         {
            // Stop trying once we fail 6 times in a row.
            failCount++;
            if(failCount==6)
               break;
         }
         else
            failCount=0; 
      } 

    forestTreeID = 0;
	numTries=2*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
      {   
         int forestMadrone=rmCreateArea("forest madrone "+i, rmAreaID("big continent"));
         rmSetAreaWarnFailure(forestMadrone, false);
         rmSetAreaSize(forestMadrone, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
         rmSetAreaForestType(forestMadrone, "california madrone forest");
		 rmSetAreaForestDensity(forestMadrone, 0.65);
         rmSetAreaForestClumpiness(forestMadrone, 0.15);
         rmSetAreaForestUnderbrush(forestMadrone, 0.6);
         rmSetAreaMinBlobs(forestMadrone, 10);
         rmSetAreaMaxBlobs(forestMadrone, 20);
         rmSetAreaMinBlobDistance(forestMadrone, 20.0);
         rmSetAreaMaxBlobDistance(forestMadrone, 30.0);
         rmSetAreaCoherence(forestMadrone, 0.35);
         rmSetAreaSmoothDistance(forestMadrone, 10);
         rmAddAreaToClass(forestMadrone, rmClassID("classForest")); 
         rmAddAreaConstraint(forestMadrone, forestConstraint);
         rmAddAreaConstraint(forestMadrone, avoidAll);
         rmAddAreaConstraint(forestMadrone, avoidCliff);
         rmAddAreaConstraint(forestMadrone, avoidImpassableLand); 
         rmAddAreaConstraint(forestMadrone, avoidTradeRoute);
		 rmAddAreaConstraint(forestMadrone, avoidE);
		 
         if(rmBuildArea(forestMadrone)==false)
         {
            // Stop trying once we fail 4 times in a row.
            failCount++;
            if(failCount==4)
               break;
         }
         else
            failCount=0; 
      }

 
  // Text
   rmSetStatusText("",0.80); 


   // Deer & Elk
	int deerID=rmCreateObjectDef("deer herd");
	rmAddObjectDefItem(deerID, "deer", rmRandInt(6,9), 10.0);
	rmSetObjectDefMinDistance(deerID, 0.0);
	rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(deerID, avoidDeer);
	rmAddObjectDefConstraint(deerID, avoidAll);
	rmAddObjectDefConstraint(deerID, avoidE);
	rmAddObjectDefConstraint(deerID, avoidCentral);
	rmAddObjectDefConstraint(deerID, avoidImpassableLand);
	rmSetObjectDefCreateHerd(deerID, true);

	int elkID=rmCreateObjectDef("elk herd");
	rmAddObjectDefItem(elkID, "elk", rmRandInt(8,9), 13);
	rmSetObjectDefMinDistance(elkID, 0.0);
	rmSetObjectDefMaxDistance(elkID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(elkID, avoidElk);
	rmAddObjectDefConstraint(elkID, avoidDeer);
	rmAddObjectDefConstraint(elkID, avoidAll);
	rmAddObjectDefConstraint(elkID, Eastconstraint);
	rmAddObjectDefConstraint(elkID, avoidImpassableLand);
	rmSetObjectDefCreateHerd(elkID, true);

	if (cNumberNonGaiaPlayers > 6)
	{
		rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 1*cNumberNonGaiaPlayers);
		rmPlaceObjectDefAtLoc(elkID, 0, 0.5, 0.5, 1*cNumberNonGaiaPlayers);
	}
	else
	{
		rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);
		rmPlaceObjectDefAtLoc(elkID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	}



// ************************* PLACE THE SUTTER'S MILL **************************
/*	int abandonedMillID=rmCreateObjectDef("sutters mill");
	rmAddObjectDefItem(abandonedMillID, "SuttersMill", 1, 0.0);
	rmSetObjectDefMinDistance(abandonedMillID, 0.0);
	rmSetObjectDefMaxDistance(abandonedMillID, 10.0);

	if(handedness < 0.5)
	{
		rmPlaceObjectDefAtLoc(abandonedMillID, 0, .75, .75);
	}
	else
	{
		rmPlaceObjectDefAtLoc(abandonedMillID, 0, .6, .2);
	}
*/


  // Text
   rmSetStatusText("",0.90);

   rmSetMapClusteringPlacementParams(0.7, 0.2, 0.9, cClusterLand);
   rmSetMapClusteringObjectParams(0, 2, 0.5);
   //rmPlaceMapClusters("carolinas\grass2", "underbrushShrub");

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
