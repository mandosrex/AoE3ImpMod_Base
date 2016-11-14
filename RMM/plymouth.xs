// PLYMOUTH
// A Random Map for Age of Empires III: The Warchiefs, Live release
// Plymouth introduces pilgrims, scout turkeys, and new Thanksgiving themed treasures and objects.

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
   int subCiv0 = -1;
   int subCiv1 = -1;
   int subCiv2 = -1;
   int subCiv3 = -1;

	int whichVariation = -1;
	whichVariation = rmRandInt(1,4);

   subCiv0 = rmGetCivID("Huron");
   rmEchoInfo("subCiv0 is Huron "+subCiv0);

   subCiv1 = rmGetCivID("Huron");
   rmEchoInfo("subCiv1 is Huron "+subCiv1);

   subCiv2 = rmGetCivID("Huron");
   rmEchoInfo("subCiv0 is Huron "+subCiv0);

   subCiv3 = rmGetCivID("Huron");
   rmEchoInfo("subCiv1 is Huron "+subCiv1);

   rmSetSubCiv(0, "Huron", true);
   rmSetSubCiv(1, "Huron", true);
   rmSetSubCiv(2, "Huron", true);
   rmSetSubCiv(3, "Huron", true);

   // Picks the map size
	int playerTiles = 11500;
   if (cNumberNonGaiaPlayers >4)
		playerTiles = 10500;

   // Picks default terrain and water
   rmSetSeaType("new england coast");
   int size = 2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size = "+size+"m x "+size+"m");
   rmSetMapSize(size, size);

	// Some map turbulence...
	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);  // Like Texas for the moment.
	rmSetMapElevationHeightBlend(0.2);

   // Picks a default water height
   rmSetSeaLevel(4.0);
   rmEnableLocalWater(false);
   rmTerrainInitialize("water");
	rmSetMapType("plymouth");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);
	rmSetLightingSet("yellow_river_dry");
	rmSetMapType("grass");

	// Choose mercs.
	chooseMercs();

   // Define some classes. These are used later for constraints.
   int classPlayer = rmDefineClass("player");
   rmDefineClass("classCliff");
   rmDefineClass("classPatch");
	rmDefineClass("classWall");
   int classbigContinent = rmDefineClass("big continent");
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
   int playerEdgeConstraint = rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
   int longPlayerConstraint = rmCreateClassDistanceConstraint("continent stays away from players", classPlayer, 12.0);

   // Player constraints
   int playerConstraint = rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
   int smallMapPlayerConstraint = rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);

   // Directional constraints
	int Northwestward = rmCreatePieConstraint("northwestMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(270), rmDegreesToRadians(180));  // 225 135, 300, 45
   int Southeastward = rmCreatePieConstraint("southeastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(90), rmDegreesToRadians(270));

   // Bonus area constraint
   int bigContinentConstraint = rmCreateClassDistanceConstraint("avoid bonus island", classbigContinent, 25.0);

   // Resource avoidance
   int forestConstraint = rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 10.0);
   int avoidDeer = rmCreateTypeDistanceConstraint("food avoids food", "deer", 45.0);
	int avoidFastCoin = rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 30.0);
   int avoidCoin = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35);
   int avoidCoinSmall = rmCreateTypeDistanceConstraint("stuff avoids coin a little", "gold", 20);
   int avoidNugget = rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 35.0);
   int avoidPlayerNugget = rmCreateTypeDistanceConstraint("player nugget avoid nugget", "AbstractNugget", 20.0);
   int avoidNuggetSmall = rmCreateTypeDistanceConstraint("nugget avoid nugget small", "AbstractNugget", 10.0);


   // Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int avoidCliffs = rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 10.0);
	int patchConstraint = rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int wallConstraint = rmCreateClassDistanceConstraint("wall vs. wall", rmClassID("classWall"), 40.0);
	int avoidSheep = rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 40.0);

   // Specify true so constraint stays outside of circle (i.e. inside corners)
   int cornerConstraint0 = rmCreateCornerConstraint("in corner 0", 0, true);
   int cornerConstraint1 = rmCreateCornerConstraint("in corner 1", 1, true);
   int cornerConstraint2 = rmCreateCornerConstraint("in corner 2", 2, true);
   int cornerConstraint3 = rmCreateCornerConstraint("in corner 3", 3, true);

   // Unit avoidance
   int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 20.0);
   int avoidStartingUnitsSmall = rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

   // ships vs. ships
   int shipVsShip = rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 5.0);

   // Decoration avoidance
   int avoidAll = rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
   int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 30.0);
	int avoidSocket = rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 12.0);

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

	int circleConstraint = rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 20.0);

   // Text
   rmSetStatusText("",0.10);

	// DEFINE AREAS
   // Set up player starting locations. These are just used to place Caravels away from each other.

   // Text
   rmSetStatusText("",0.20);

	// Build up big continent - called, unoriginally enough, "big continent"
   int bigContinentID = rmCreateArea("big continent");
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
   int smallContinent1ID = rmCreateArea("small continent spur 1");
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
   int smallContinent2ID = rmCreateArea("small continent spur 2");
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

   bool southSide = true;
   float spacing = (0.2 / (cNumberPlayers - 1));

	if (cNumberTeams == 2)
	{
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.2, 0.5, 0.2, 0.8, 0.0, 0.2);

		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.8, 0.5, 0.8, 0.8, 0.0, 0.2);
	}
	else
	{
	   for (i = 0; < (cNumberPlayers - 1))
      {
         rmEchoInfo("i = "+i);
         float iFloat = i;
         if (southSide == true)
         {
            rmSetPlacementTeam(i);
            rmSetPlacementSection((0.075 + ((iFloat) * spacing)), 0.25);
	         rmSetTeamSpacingModifier(0.25);
	         rmPlacePlayersCircular(0.4, 0.4, 0);
         }
         else
         {
            rmSetPlacementTeam(i);
            rmSetPlacementSection((0.75 + ((iFloat) * spacing)), 0.95);
	         rmSetTeamSpacingModifier(0.25);
	         rmPlacePlayersCircular(0.4, 0.4, 0);
         }
         if (southSide == true)
         {
            southSide = false;
         }
         else
         {
            southSide = true;
         }
      }
	}

    // Set up player areas.
   float playerFraction = rmAreaTilesToFraction(100);
   for(i = 1; < cNumberPlayers)
   {
      // Create the area.
      int id = rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();

   // Placement order
   // Islands -> Natives -> Secrets -> Cliffs -> Nuggets
   // Text
   rmSetStatusText("",0.40);

   // Isles of Shoals - these are set in specific locations.
   int bonusIslandID1 = rmCreateArea("isle of shoals 1");
   rmSetAreaSize(bonusIslandID1, rmAreaTilesToFraction(450), rmAreaTilesToFraction(450));
   rmSetAreaTerrainType(bonusIslandID1, "new_england\ground1_ne");
   rmSetAreaMix(bonusIslandID1, "newengland_grass");
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
   rmSetAreaLocation(bonusIslandID1, 0.50, 0.15);
   rmBuildArea(bonusIslandID1);

   // NATIVE AMERICANS
   // Text
   rmSetStatusText("",0.50);
     
   // Huron village A
   int huronVillageAID = -1;
   int huronVillageType = rmRandInt(1,3);
      
   huronVillageAID = rmCreateGrouping("huron village A", "native huron village "+huronVillageType);
   rmSetGroupingMinDistance(huronVillageAID, 0.0);
   rmSetGroupingMaxDistance(huronVillageAID, rmXFractionToMeters(0.05));
   rmAddGroupingConstraint(huronVillageAID, avoidImpassableLand);
   rmAddGroupingToClass(huronVillageAID, rmClassID("importantItem"));
   rmAddGroupingConstraint(huronVillageAID, avoidTradeRoute);
   rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.5, 0.9);
	
   // Huron village B
	int huronVillageBID = -1;
	huronVillageType = rmRandInt(1,3);
	
   huronVillageBID = rmCreateGrouping("huron village B", "native huron village "+huronVillageType);
	rmSetGroupingMinDistance(huronVillageBID, 0.0);
	rmSetGroupingMaxDistance(huronVillageBID, rmXFractionToMeters(0.05));
	rmAddGroupingConstraint(huronVillageBID, avoidImpassableLand);
	rmAddGroupingToClass(huronVillageBID, rmClassID("importantItem"));
	rmAddGroupingConstraint(huronVillageBID, avoidTradeRoute);
	rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.5, 0.75);

   // Huron village C
   int huronVillageCID = -1;
   huronVillageType = rmRandInt(1,3);
      
   huronVillageCID = rmCreateGrouping("huron village C", "native huron village "+huronVillageType);
   rmSetGroupingMinDistance(huronVillageCID, 0.0);
   rmSetGroupingMaxDistance(huronVillageCID, rmXFractionToMeters(0.05));
   rmAddGroupingConstraint(huronVillageCID, avoidImpassableLand);
   rmAddGroupingToClass(huronVillageCID, rmClassID("importantItem"));
   rmAddGroupingConstraint(huronVillageCID, avoidTradeRoute);
   rmPlaceGroupingAtLoc(huronVillageCID, 0, 0.5, 0.6);
	
   // Huron village D
	int huronVillageDID = -1;
	huronVillageType = rmRandInt(1,3);
	
   huronVillageDID = rmCreateGrouping("huron village D", "native huron village "+huronVillageType);
	rmSetGroupingMinDistance(huronVillageDID, 0.0);
	rmSetGroupingMaxDistance(huronVillageDID, rmXFractionToMeters(0.05));
	rmAddGroupingConstraint(huronVillageDID, avoidImpassableLand);
	rmAddGroupingToClass(huronVillageDID, rmClassID("importantItem"));
	rmAddGroupingConstraint(huronVillageDID, avoidTradeRoute);
	rmPlaceGroupingAtLoc(huronVillageDID, 0, 0.5, 0.45);


   // Starting Unit placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 6.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startingUnits, avoidAll);

	int startingTCID =  rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));

	int silverType = -1;
	int playerGoldID = -1;

	int StartAreaTreeID = rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeNewEngland", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 15.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartBerryBushID = rmCreateObjectDef("starting BerryBush");
	rmAddObjectDefItem(StartBerryBushID, "BerryBush", 3, 5.0);
	rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
	rmSetObjectDefMaxDistance(StartBerryBushID, 15.0);
	rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);

	int playerNuggetID = rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(playerNuggetID, 30.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerNuggetID, avoidPlayerNugget);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);

	int waterFlagID = -1;
	
	for(i = 1; <cNumberPlayers)
	{
		rmClearClosestPointConstraints();
		// Place starting units and a TC!
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets one ore grouping close by
		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
		rmSetObjectDefMinDistance(playerGoldID, 15.0);
		rmSetObjectDefMaxDistance(playerGoldID, 20.0);
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

      // Placing starting berries
		rmPlaceObjectDefAtLoc(StartBerryBushID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		// Placing starting trees
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
		waterFlagID = rmCreateObjectDef("HC water flag "+i);
		rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
      vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
		rmClearClosestPointConstraints();

      // Pilgrims
      int pilgrimGroupType = rmRandInt(1,2);
      int pilgrimGroup = 0;
      pilgrimGroup = rmCreateGrouping("Pilgrim Group "+i, "Plymouth_PilgrimGroup "+pilgrimGroupType);
      rmSetGroupingMinDistance(pilgrimGroup, 6.0);
      rmSetGroupingMaxDistance(pilgrimGroup, 8.0);
      rmAddGroupingToClass(pilgrimGroup, rmClassID("startingUnit"));
      rmAddGroupingConstraint(pilgrimGroup, avoidTradeRoute);
      rmAddGroupingConstraint(pilgrimGroup, avoidStartingUnitsSmall);
      rmPlaceGroupingAtLoc(pilgrimGroup, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

	// Text
   rmSetStatusText("",0.60);

	// A few smallish cliffs on the northwest side (inland)
	int numTries = 2 * cNumberNonGaiaPlayers;
	int failCount = 0;
	for(i = 0; <numTries)
	{
		int cliffID = rmCreateArea("cliff "+i);
	   rmSetAreaSize(cliffID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(100));
		rmSetAreaWarnFailure(cliffID, false);
		rmSetAreaCliffType(cliffID, "New England");
      // Attempt to keep cliffs away from each other.
		rmAddAreaToClass(cliffID, rmClassID("classCliff"));
		rmSetAreaCliffEdge(cliffID, 1, 1);
		rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffID, 4, 1.0, 1.0);
		rmSetAreaHeightBlend(cliffID, 1.0);
		rmAddAreaTerrainLayer(cliffID, "new_england\ground4_ne", 0, 2);
      // Avoid other cliffs, please!
		rmAddAreaConstraint(cliffID, avoidCliffs);
      rmAddAreaConstraint(cliffID, avoidCoinSmall);
		rmAddAreaConstraint(cliffID, avoidImportantItem);
      rmAddAreaConstraint(cliffID, avoidStartingUnits);
		rmAddAreaConstraint(cliffID, avoidTradeRoute);
		rmAddAreaConstraint(cliffID, avoidWater20);
      // Cliff are on the northwest side of the map.
		rmAddAreaConstraint(cliffID, Northwestward);
		rmSetAreaSmoothDistance(cliffID, 10);
		rmSetAreaCoherence(cliffID, 0.25);

		if(rmBuildArea(cliffID) == false)
		{
			// Stop trying once we fail 3 times in a row
			failCount++;
			if(failCount == 3)
				break;
		}
		else
			failCount = 0;
	}
  
   // Define and place Nuggets
	int nuggetID =  rmCreateObjectDef("nugget"); 
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
	rmSetNuggetDifficulty(1, 3);
	rmPlaceObjectDefInArea(nuggetID, 0, bigContinentID, cNumberNonGaiaPlayers*5);

	// Trees on bonus island
	int islandNativeID =  rmCreateObjectDef("island natives"); 
	rmAddObjectDefConstraint(islandNativeID, avoidWater4);
	rmAddObjectDefItem(islandNativeID, "TreeNewEngland", 1, 0.0);
	rmPlaceObjectDefInArea(islandNativeID, 0, bonusIslandID1, 7);

	// Placement of pumkin patch on the bonus islands.
   int pumpkinPatchGroupType = rmRandInt(1,6);
	int islandPumpkinPatchID = rmCreateGrouping("Pumpkin patch", "Plymouth_PumpkinPatch "+pumpkinPatchGroupType);
	rmAddGroupingConstraint(islandPumpkinPatchID, avoidWater4);
	rmPlaceGroupingInArea(islandPumpkinPatchID, 0, bonusIslandID1, 1);

   // fish
   int fishVsFishID = rmCreateTypeDistanceConstraint("fish v fish", "fish", 20.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int whaleVsWhaleID = rmCreateTypeDistanceConstraint("whale v whale", "minkeWhale", 25.0);

   int fishID = rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishCod", 2, 5.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.0, cNumberNonGaiaPlayers*5);

	// FAST COIN -- WHALES
	int whaleID = rmCreateObjectDef("whale");
   rmAddObjectDefItem(whaleID, "minkeWhale", 1, 9.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

   // Text
   rmSetStatusText("",0.65); 
 
   // Place resources that we want forests to avoid
	// Fast Coin
	int silverID = -1;
	int silverCount = cNumberNonGaiaPlayers*3;	// 3 per player, plus starting one.
	rmEchoInfo("silver count = "+silverCount);

	for(i = 0; < silverCount)
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
   numTries = 7*cNumberNonGaiaPlayers;
   failCount = 0;

   for (i = 0; <numTries)
   {   
      int forest = rmCreateArea("forest "+i, rmAreaID("big continent"));
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(250));
      rmSetAreaForestType(forest, "Plymouth Forest");
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
      if(rmBuildArea(forest) == false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount == 5)
            break;
      }
      else
         failCount = 0; 
   } 
 
   // Text
   rmSetStatusText("",0.70);

 	// DEER
   int deerID = rmCreateObjectDef("deer herd");
	int bonusChance = rmRandFloat(0, 1);
   
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

	int sheepID = rmCreateObjectDef("sheep");
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

   // Text
   rmSetStatusText("",0.9);
   

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

	// Rock Walls can get placed last.  May not place at all...
	int stoneWallType = -1;
	int stoneWallID = -1;
	int stoneWallCount = cNumberNonGaiaPlayers*2;	
	rmEchoInfo("stoneWall count = "+stoneWallCount);

	for(i = 0; < stoneWallCount)
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