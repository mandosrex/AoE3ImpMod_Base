// BAYOU
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

   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;
   int subCiv4=-1;

   if (rmAllocateSubCivs(5) == true)
   {
		subCiv0=rmGetCivID("Seminoles");
		rmEchoInfo("subCiv0 is Seminole "+subCiv0);
      if (subCiv0 >= 0)
			rmSetSubCiv(0, "Seminoles");
		
		subCiv1=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv1 is Cherokee "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Cherokee");

		subCiv2=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv2 is Cherokee "+subCiv2);
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "Cherokee");

		subCiv3=rmGetCivID("Seminoles");
		rmEchoInfo("subCiv3 is Seminoles "+subCiv3);
		if (subCiv3 >= 0)
			rmSetSubCiv(3, "Seminoles");
		
		if (rmRandFloat(0,1) < 0.5)
		{
			subCiv4=rmGetCivID("Seminoles");
			rmEchoInfo("subCiv4 is Seminoles "+subCiv4);
			if (subCiv4 >= 0)
				rmSetSubCiv(4, "Seminoles");
		}
	}			

   // Picks the map size
   //int playerTiles=14400; // OLD SIZE
   int playerTiles = 11000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 9000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 7000;		
   int size=1.8*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   // Picks a default water height
   rmSetSeaLevel(1.0);
   rmSetLightingSet("Bayou");

   // Picks default terrain and water

//  rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
//	rmSetMapElevationParameters(cElevTurbulence, 0.1, 4, 0.3, 2.0);
	rmSetSeaType("bayou");
	rmEnableLocalWater(false);
	rmSetBaseTerrainMix("bayou_grass");
	rmTerrainInitialize("water");
	rmSetMapType("bayou");
	rmSetMapType("water");
	//	rmSetMapType("grass");
	rmSetWorldCircleConstraint(true);

	// Choose mercs.
	chooseMercs();

	// Define some classes. These are used later for constraints.
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classCliff");
	rmDefineClass("classPatch");
	int classbigContinent=rmDefineClass("big continent");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("startingUnit");
	int classBay=rmDefineClass("bay");

	int classIsland=rmDefineClass("island");
	int classBonusIsland=rmDefineClass("bonus island");
	rmDefineClass("corner");



	// -------------Define constraints
	// These are used to have objects and areas avoid each other

	// Map edge constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
	int islandEdgeConstraint=rmCreateBoxConstraint("islands in center", 0.30, 0.30, 0.70, 0.70, 0.01);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("continent stays away from players", classPlayer, 24.0);
	int avoidTC=rmCreateTypeDistanceConstraint("avoid TC", "towncenter", 30.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));


	// Player constraints
	int islandConstraint=rmCreateClassDistanceConstraint("stay away from islands", classIsland, 10.0);
	int playerConstraint=rmCreateClassDistanceConstraint("bonus Settlement stay away from players", classPlayer, 10);
	int bonusIslandConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classBonusIsland, 30.0);
	int cornerConstraint=rmCreateClassDistanceConstraint("stay away from corner", rmClassID("corner"), 15.0);
	int cornerOverlapConstraint=rmCreateClassDistanceConstraint("don't overlap corner", rmClassID("corner"), 2.0);
	int bayConstraint=rmCreateClassDistanceConstraint("avoid bay", classBay, 6);
	int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
	int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 30.0);
	int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 8.0);

	// Bonus area constraint.
	int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid big island", classbigContinent, 20.0);

	// Resource avoidance
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 50.0);
	int farAvoidCoin=rmCreateTypeDistanceConstraint("silver avoid coin", "gold", 45.0);
	int shortAvoidCoin=rmCreateTypeDistanceConstraint("silver avoid coin short", "gold", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
	int avoidDeer=rmCreateTypeDistanceConstraint("food avoids food", "deer", 50.0);
	int avoidTurkey=rmCreateTypeDistanceConstraint("food avoids turkey", "turkey", 30.0);
	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);

	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

	// VP avoidance
	int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 50.0);
	int shortAvoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other short", rmClassID("importantItem"), 8.0);
  int shorterAvoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other shorter", rmClassID("importantItem"), 4.0);

	// Constraint to avoid water.
	int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 8.0);


	// Text
	rmSetStatusText("",0.10);

/*
//  Create a bay water area -- the mediterranean part.
	int bayID=rmCreateArea("The Gulf of Mexico");
	rmSetAreaSize(bayID, 0.15, 0.15);
	rmSetAreaLocation(bayID, 0.1, 0.05);
	rmSetAreaWaterType(bayID, "new england lake");
	rmSetAreaBaseHeight(bayID, 4.0); // Was 10
	rmSetAreaMinBlobs(bayID, 8);
	rmSetAreaMaxBlobs(bayID, 10);
	rmSetAreaMinBlobDistance(bayID, 10);
	rmSetAreaMaxBlobDistance(bayID, 20);
	rmSetAreaSmoothDistance(bayID, 50);
	rmSetAreaCoherence(bayID, 0.25);
	rmAddAreaToClass(bayID, rmClassID("bay"));
	rmSetAreaObeyWorldCircleConstraint(bayID, false);
	rmBuildArea(bayID);
*/

   /*
   // Create connections
   int shallowsID=rmCreateConnection("shallows");
   rmSetConnectionType(shallowsID, cConnectAreas, false, 1.0);
   rmSetConnectionWidth(shallowsID, 20, 2);
   rmSetConnectionWarnFailure(shallowsID, false);
   rmSetConnectionBaseHeight(shallowsID, 2.0);
   rmSetConnectionHeightBlend(shallowsID, 2.0);
   rmSetConnectionSmoothDistance(shallowsID, 3.0);
   rmAddConnectionTerrainReplacement(shallowsID, "amazon\river1_am", "new_england\ground2_ne");
   rmAddConnectionTerrainReplacement(shallowsID, "amazon\river2_am", "new_england\ground2_ne");
 //  rmAddConnectionTerrainReplacement(shallowsID, "new_england\outerbank_ne", "new_england\ground2_ne");
 //  rmAddConnectionTerrainReplacement(shallowsID, "new_england\outerbank_ne", "new_england\ground2_ne");
 //  rmAddConnectionTerrainReplacement(shallowsID, "new_england\underwater1_ne", "new_england\ground2_ne");
 //  rmAddConnectionTerrainReplacement(shallowsID, "new_england\underwater2_ne", "new_england\ground2_ne");
	rmAddConnectionConstraint(shallowsID, bayConstraint);

*/
   
   for(i=0; <rmRandInt(9,10))
   {
      int bonusIslandID=rmCreateArea("bonus island"+i);
      rmSetAreaSize(bonusIslandID, 0.06, 0.08);
      rmSetAreaMix(bonusIslandID, "bayou_grass");
      rmSetAreaWarnFailure(bonusIslandID, false);
    //  if(rmRandFloat(0.0, 1.0)<0.70)
        rmAddAreaConstraint(bonusIslandID, bonusIslandConstraint);
		rmAddAreaToClass(bonusIslandID, classIsland);
		rmAddAreaToClass(bonusIslandID, classBonusIsland);
		rmAddAreaConstraint(bonusIslandID, bayConstraint);
		rmSetAreaCoherence(bonusIslandID, 0.25);
		rmSetAreaSmoothDistance(bonusIslandID, 12);
		rmSetAreaElevationType(bonusIslandID, cElevTurbulence);
		rmSetAreaElevationVariation(bonusIslandID, 2.0);
		rmSetAreaBaseHeight(bonusIslandID, 4.0);
		rmSetAreaElevationMinFrequency(bonusIslandID, 0.09);
		rmSetAreaElevationOctaves(bonusIslandID, 3);
		rmSetAreaElevationPersistence(bonusIslandID, 0.2);      
	//  rmAddConnectionArea(shallowsID, bonusIslandID);
		rmSetAreaObeyWorldCircleConstraint(bonusIslandID, false);
   }   

   rmBuildAllAreas();

   
  // Text
   rmSetStatusText("",0.20);

   int lakeID=rmCreateArea("Shallows lake");
   rmSetAreaSize(lakeID, 0.1, 0.1);
   rmSetAreaLocation(lakeID, 0.5, 0.5);
   rmSetAreaWaterType(lakeID, "bayou");
   rmSetAreaBaseHeight(lakeID, 4.0); // Was 10
   rmSetAreaMinBlobs(lakeID, 8);
   rmSetAreaMaxBlobs(lakeID, 10);
   rmSetAreaMinBlobDistance(lakeID, 10);
   rmSetAreaMaxBlobDistance(lakeID, 20);
   rmSetAreaSmoothDistance(lakeID, 50);
   rmSetAreaCoherence(lakeID, 0.25);
	rmAddAreaToClass(lakeID, rmClassID("bay"));
   rmSetAreaObeyWorldCircleConstraint(lakeID, false);
   rmBuildArea(lakeID);

    for(i=0; <rmRandInt(6,8))
   {
      int smallIslandID=rmCreateArea("small island"+i);
      rmSetAreaSize(smallIslandID, 0.008, 0.008);
     // rmSetAreaMix(smallIslandID, "carolina_grass");
	  rmSetAreaMix(smallIslandID, "bayou_grass");
      rmSetAreaWarnFailure(smallIslandID, false);
      rmAddAreaToClass(smallIslandID, classIsland);
      //rmAddAreaConstraint(smallIslandID, bayConstraint);
      rmSetAreaCoherence(smallIslandID, 0.25);
      rmSetAreaSmoothDistance(smallIslandID, 12);
	  //rmSetAreaElevationType(smallIslandID, cElevTurbulence);
	  //rmSetAreaElevationVariation(smallIslandID, 2.0);
	  rmSetAreaBaseHeight(smallIslandID, 4.0);
	  //rmSetAreaElevationMinFrequency(smallIslandID, 0.09);
	  //rmSetAreaElevationOctaves(smallIslandID, 3);
	  //rmSetAreaElevationPersistence(smallIslandID, 0.2);      
	  //rmAddAreaConstraint(smallIslandID, islandConstraint);
	  rmAddAreaConstraint(smallIslandID, islandEdgeConstraint);
   }   

   // Build all areas
   rmBuildAllAreas();

  // Text
   rmSetStatusText("",0.40);

	// Add Natives

	float nativeLoc = rmRandFloat(0,1);

	if (subCiv0 == rmGetCivID("Seminoles"))
	{  
		if ( cNumberTeams <= 2 )
		{
		int smallIslandNative1=rmCreateArea("small island native 1");
		rmSetAreaSize(smallIslandNative1, rmAreaTilesToFraction(400), rmAreaTilesToFraction(500));
		rmSetAreaLocation(smallIslandNative1, 0.9, 0.5);
		rmSetAreaMix(smallIslandNative1, "bayou_grass");
		rmSetAreaWarnFailure(smallIslandNative1, false);
		rmAddAreaToClass(smallIslandNative1, classIsland);
		rmSetAreaCoherence(smallIslandNative1, 0.6);
		rmSetAreaSmoothDistance(smallIslandNative1, 12);
		//rmSetAreaElevationType(smallIslandNative1, cElevTurbulence);
		//rmSetAreaElevationVariation(smallIslandNative1, 2.0);
		rmSetAreaBaseHeight(smallIslandNative1, 4.0);
		rmBuildArea(smallIslandNative1);

		int SeminolesVillageID = -1;
		int SeminolesVillageType = rmRandInt(1,5);
		SeminolesVillageID = rmCreateGrouping("Seminole village", "native seminole village "+SeminolesVillageType);
		rmSetGroupingMinDistance(SeminolesVillageID, 0.0);
		rmSetGroupingMaxDistance(SeminolesVillageID, 0.0);
		//rmAddGroupingConstraint(SeminolesVillageID, avoidImpassableLand);
		//rmAddGroupingConstraint(SeminolesVillageID, avoidImportantItem);
		rmAddGroupingToClass(SeminolesVillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(SeminolesVillageID, 0, 0.90, 0.50);
		else
			rmPlaceGroupingAtLoc(SeminolesVillageID, 0, 0.9, 0.5);
		}
	}

	if (subCiv1 == rmGetCivID("Cherokee"))
   {   
	   int smallIslandNative2=rmCreateArea("small island native 2");
		rmSetAreaSize(smallIslandNative2, rmAreaTilesToFraction(400), rmAreaTilesToFraction(500));
		rmSetAreaLocation(smallIslandNative2, 0.6, 0.5);
		rmSetAreaMix(smallIslandNative2, "bayou_grass");
		rmSetAreaWarnFailure(smallIslandNative2, false);
		rmAddAreaToClass(smallIslandNative2, classIsland);
		rmSetAreaCoherence(smallIslandNative2, 0.6);
		rmSetAreaSmoothDistance(smallIslandNative2, 12);
		//rmSetAreaElevationType(smallIslandNative2, cElevTurbulence);
		//rmSetAreaElevationVariation(smallIslandNative2, 2.0);
		rmSetAreaBaseHeight(smallIslandNative2, 4.0);
		rmBuildArea(smallIslandNative2);

		int CherokeeVillageID = -1;
		int CherokeeVillageType = rmRandInt(1,5);
		CherokeeVillageID = rmCreateGrouping("Cherokee village", "native Cherokee village "+CherokeeVillageType);
		rmSetGroupingMinDistance(CherokeeVillageID, 0.0);
		rmSetGroupingMaxDistance(CherokeeVillageID, 0.0);
		//rmAddGroupingConstraint(CherokeeVillageID, avoidImpassableLand);
		//rmAddGroupingConstraint(CherokeeVillageID, avoidImportantItem);
		rmAddGroupingToClass(CherokeeVillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(CherokeeVillageID, 0, 0.6, 0.5);
		else
			rmPlaceGroupingAtLoc(CherokeeVillageID, 0, 0.6, 0.5);
	}

	if (subCiv2 == rmGetCivID("Cherokee"))
   {   
		int smallIslandNative3=rmCreateArea("small island native 3");
		rmSetAreaSize(smallIslandNative3, rmAreaTilesToFraction(400), rmAreaTilesToFraction(500));
		rmSetAreaLocation(smallIslandNative3, 0.4, 0.5);
		rmSetAreaMix(smallIslandNative3, "bayou_grass");
		rmSetAreaWarnFailure(smallIslandNative3, false);
		rmAddAreaToClass(smallIslandNative3, classIsland);
		rmSetAreaCoherence(smallIslandNative3, 0.6);
		rmSetAreaSmoothDistance(smallIslandNative3, 12);
		//rmSetAreaElevationType(smallIslandNative3, cElevTurbulence);
		//rmSetAreaElevationVariation(smallIslandNative3, 2.0);
		rmSetAreaBaseHeight(smallIslandNative3, 4.0);
		rmBuildArea(smallIslandNative3);

		int Cherokee2VillageID = -1;
		int Cherokee2VillageType = rmRandInt(1,5);
		Cherokee2VillageID = rmCreateGrouping("Cherokee2 village", "native cherokee village "+Cherokee2VillageType);
		rmSetGroupingMinDistance(Cherokee2VillageID, 0.0);
		rmSetGroupingMaxDistance(Cherokee2VillageID, 0.0);
		//rmAddGroupingConstraint(Cherokee2VillageID, avoidImpassableLand);
		//rmAddGroupingConstraint(Cherokee2VillageID, avoidImportantItem);
		rmAddGroupingToClass(Cherokee2VillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(Cherokee2VillageID, 0, 0.4, 0.5);
		else
			rmPlaceGroupingAtLoc(Cherokee2VillageID, 0, 0.4, 0.5);
	}
  
	if (subCiv3 == rmGetCivID("Seminoles"))
   {   
	   if ( cNumberTeams <= 2 )
	   {
		int smallIslandNative4=rmCreateArea("small island native 4");
		rmSetAreaSize(smallIslandNative4, rmAreaTilesToFraction(400), rmAreaTilesToFraction(500));
		rmSetAreaLocation(smallIslandNative4, 0.10, 0.5);
		rmSetAreaMix(smallIslandNative4, "bayou_grass");
		rmSetAreaWarnFailure(smallIslandNative4, false);
		rmAddAreaToClass(smallIslandNative4, classIsland);
		rmSetAreaCoherence(smallIslandNative4, 0.6);
		rmSetAreaSmoothDistance(smallIslandNative4, 12);
		//rmSetAreaElevationType(smallIslandNative4, cElevTurbulence);
		//rmSetAreaElevationVariation(smallIslandNative4, 2.0);
		rmSetAreaBaseHeight(smallIslandNative4, 4.0);
		rmBuildArea(smallIslandNative4);

		int Seminoles2VillageID = -1;
		int Seminoles2VillageType = rmRandInt(1,5);
		Seminoles2VillageID = rmCreateGrouping("Seminole2 village", "native seminole village "+Seminoles2VillageType);
		rmSetGroupingMinDistance(Seminoles2VillageID, 0.0);
		rmSetGroupingMaxDistance(Seminoles2VillageID, 0.0);
		//rmAddGroupingConstraint(Seminoles2VillageID, avoidImpassableLand);
		//rmAddGroupingConstraint(Seminoles2VillageID, avoidImportantItem);
		rmAddGroupingToClass(Seminoles2VillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(Seminoles2VillageID, 0, 0.10, 0.5);
		else
			rmPlaceGroupingAtLoc(Seminoles2VillageID, 0, 0.10, 0.50);
	   }
	}
   
  // Text
   rmSetStatusText("",0.50);

/*
	if (subCiv4 == rmGetCivID("Seminoles"))
   {   
      int Seminoles3VillageID = -1;
      int Seminoles3VillageType = rmRandInt(1,10);
      Seminoles3VillageID = rmCreateGrouping("Seminole3 village", "native seminole village "+Seminoles3VillageType);
      rmSetGroupingMinDistance(Seminoles3VillageID, 0.0);
      rmSetGroupingMaxDistance(Seminoles3VillageID, rmXFractionToMeters(0.15));
      rmAddGroupingConstraint(Seminoles3VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(Seminoles3VillageID, avoidImportantItem);
      rmAddGroupingToClass(Seminoles3VillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(Seminoles3VillageID, 0, 0.4, 0.4);
		else
			rmPlaceGroupingAtLoc(Seminoles3VillageID, 0, 0.4, 0.4);
	}
*/

	// Set up player starting locations. These are just used to place Caravels away from each other.

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 2.0);
	rmSetObjectDefMaxDistance(startingUnits, 4.0);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
	rmAddObjectDefToClass(startingUnits, rmClassID("player"));

	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
		{
			rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
		}
		else
		{
            rmAddObjectDefItem(TCID, "townCenter", 1, 0);
		}
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 10.0);
	//rmAddObjectDefConstraint(TCID, avoidTradeRoute);
	rmAddObjectDefToClass(TCID, rmClassID("player"));
	rmAddObjectDefToClass(TCID, rmClassID("startingUnit"));

	int playerSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	//rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmSetObjectDefMinDistance(playerSilverID, 12.0);
	rmSetObjectDefMaxDistance(playerSilverID, 20.0);
	//rmAddObjectDefConstraint(playerSilverID, avoidAll);
	rmAddObjectDefToClass(playerSilverID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerSilverID, avoidStartingUnits);

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeBayou", rmRandInt(5,8), 4.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 8);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 15);
	rmAddObjectDefToClass(StartAreaTreeID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);
	//rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	//rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidSilver);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnits);
	//rmAddObjectDefConstraint(StartAreaTreeID, avoidResource);

	int startBerryID=rmCreateObjectDef("starting Berries");
	rmAddObjectDefItem(startBerryID, "berrybush", 4, 5.0);
	rmSetObjectDefCreateHerd(startBerryID, true);
	rmSetObjectDefMinDistance(startBerryID, 8);
	rmSetObjectDefMaxDistance(startBerryID, 15);
	rmAddObjectDefToClass(startBerryID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startBerryID, avoidImpassableLand);
	//rmAddObjectDefConstraint(startBerryID, avoidTradeRoute);
	rmAddObjectDefConstraint(startBerryID, avoidStartingUnits);
	rmAddObjectDefConstraint(startBerryID, avoidResource);

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	float randomTeamGrouping = rmRandFloat(0.0, 1.0);
	
// FFA and 2 team support
	if ( cNumberTeams <= 2 && teamZeroCount <= 4 && teamOneCount <= 4)
	{

		rmSetPlacementTeam(0);
		if (randomTeamGrouping <= 0.5)
			rmSetPlacementSection(0.4, 0.6);
		else
			rmSetPlacementSection(0.45, 0.55);
		rmSetTeamSpacingModifier(0.5);
		rmPlacePlayersCircular(0.38, 0.38, 0);

		rmSetPlacementTeam(1);
		if (randomTeamGrouping <= 0.5)
			rmSetPlacementSection(0.9, 0.1);
		else
			rmSetPlacementSection(0.95, 0.05);
		rmSetTeamSpacingModifier(0.5);
		rmPlacePlayersCircular(0.38, 0.38, 0);
		
	}
	else if ( cNumberTeams == 2)
	{
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.4, 0.6);
		rmSetTeamSpacingModifier(0.5);
		rmPlacePlayersCircular(0.38, 0.38, 0);

		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.9, 0.1);
		rmSetTeamSpacingModifier(0.5);
		rmPlacePlayersCircular(0.38, 0.38, 0);
	}
	else
	{
		rmSetTeamSpacingModifier(0.7);
		rmPlacePlayersCircular(0.38, 0.40, 0.0);
	}
/*
if ( cNumberTeams == 2 )
	{
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.60, 0.10, 0.65, 0.1, 0, 0.002);
	
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.50, 0.9, 0.55, 0.9, 0, 0.002);
	}
	else
	{
  		rmSetPlacementSection(0.0, 0.95);
		rmPlacePlayersCircular(0.35, 0.40, 0.0);
	}
*/
   // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(800);
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
//      rmAddAreaConstraint(id, playerConstraint); 
//      rmAddAreaConstraint(id, playerEdgeConstraint); 
		rmSetAreaLocPlayer(id, i);
		rmSetAreaBaseHeight(id, 4);
		rmSetAreaCoherence(id, 0.8);
		//rmSetAreaTerrainType(id, "andes\ground2_and");
		rmSetAreaMix(id, "bayou_grass");
		rmSetAreaWarnFailure(id, false);
   }
	// Build the areas.
   rmBuildAllAreas(); 
   
   
  // Text
   rmSetStatusText("",0.60);

   for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerSilverID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startBerryID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		//vector closestPoint=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
		//rmSetHomeCityGatherPoint(i, closestPoint);
	}

   // Text
   rmSetStatusText("",0.70);

// *********************************** TREASURES *******************************
    
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
    float xLoc = 0.0;
    
    if(randLoc == 1)
      xLoc = .6;
    
    else
      xLoc = .4;
    
    ypKingsHillPlacer(xLoc, .5, 0.1, longPlayerConstraint);
    rmEchoInfo("XLOC = "+xLoc);
  }
    
		int nugget1= rmCreateObjectDef("nugget easy"); 
		rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(1, 1);
		//rmAddObjectDefToClass(nugget1, rmClassID("classNugget"));
		rmAddObjectDefConstraint(nugget1, longPlayerConstraint);
		rmAddObjectDefConstraint(nugget1, shortAvoidImportantItem);
		rmAddObjectDefConstraint(nugget1, avoidNugget);
		rmAddObjectDefConstraint(nugget1, circleConstraint);
		rmAddObjectDefConstraint(nugget1, avoidAll);
		rmSetObjectDefMinDistance(nugget1, 40.0);
		rmSetObjectDefMaxDistance(nugget1, 60.0);
		rmPlaceObjectDefPerPlayer(nugget1, false, 2);

		int nugget2= rmCreateObjectDef("nugget medium"); 
		rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2, 2);
		//rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
		rmSetObjectDefMinDistance(nugget2, 0.0);
		rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nugget2, longPlayerConstraint);
		rmAddObjectDefConstraint(nugget2, shortAvoidImportantItem);
		rmAddObjectDefConstraint(nugget2, avoidNugget);
		rmAddObjectDefConstraint(nugget2, circleConstraint);
		rmAddObjectDefConstraint(nugget2, avoidAll);
		rmSetObjectDefMinDistance(nugget2, 80.0);
		rmSetObjectDefMaxDistance(nugget2, 120.0);
		rmPlaceObjectDefPerPlayer(nugget2, false, 1);

		int nugget3= rmCreateObjectDef("nugget hard"); 
		rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(3, 3);
		//rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
		rmSetObjectDefMinDistance(nugget3, 0.0);
		rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nugget3, longPlayerConstraint);
		rmAddObjectDefConstraint(nugget3, shortAvoidImportantItem);
		rmAddObjectDefConstraint(nugget3, avoidNugget);
		rmAddObjectDefConstraint(nugget3, circleConstraint);
		rmAddObjectDefConstraint(nugget3, avoidAll);
		rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

		int nugget4= rmCreateObjectDef("nugget nuts"); 
		rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		//rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
		rmSetObjectDefMinDistance(nugget4, 0.0);
		rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.4));
		rmAddObjectDefConstraint(nugget4, longPlayerConstraint);
		rmAddObjectDefConstraint(nugget4, shortAvoidImportantItem);
		rmAddObjectDefConstraint(nugget4, avoidNugget);
		rmAddObjectDefConstraint(nugget4, circleConstraint);
		rmAddObjectDefConstraint(nugget4, avoidAll);
		rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(2,3));




/*
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	//rmAddObjectDefConstraint(nuggetID, islandEdgeConstraint);
	rmAddObjectDefConstraint(nuggetID, longPlayerConstraint);
	rmAddObjectDefConstraint(nuggetID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*rmRandInt(3,4));
*/





	int silverType = rmRandInt(1,10);
	int silverID = -1;
	int silver2ID = -1;
	int silverCount = (cNumberNonGaiaPlayers*5);
	int bonusSilverCount = (cNumberNonGaiaPlayers);	
	rmEchoInfo("silver count = "+silverCount);
	rmEchoInfo("bonus silver count = "+bonusSilverCount);

	for(i=0; < silverCount)
	{

	silverID = rmCreateObjectDef("silver"+i);
	rmAddObjectDefItem(silverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(silverID, 0.0);
	rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(silverID, farAvoidCoin);
	rmAddObjectDefConstraint(silverID, avoidAll);
	//rmAddObjectDefToClass(silverID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(silverID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(silverID, avoidStartingUnits);
	rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
	rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
	
   }

	for(i=0; < bonusSilverCount)
	{
		silver2ID = rmCreateObjectDef("silver2_"+i);
	rmAddObjectDefItem(silver2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(silver2ID, 0.0);
	rmSetObjectDefMaxDistance(silver2ID, rmXFractionToMeters(0.30));
	rmAddObjectDefConstraint(silver2ID, farAvoidCoin);
	rmAddObjectDefConstraint(silver2ID, avoidAll);
	//rmAddObjectDefToClass(silver2ID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(silver2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(silver2ID, avoidStartingUnits);
	rmAddObjectDefConstraint(silver2ID, shortAvoidImportantItem);
	rmPlaceObjectDefAtLoc(silver2ID, 0, 0.5, 0.5);
   }
// Text
   rmSetStatusText("",0.80);


	int deerID=rmCreateObjectDef("deer herd");
	rmAddObjectDefItem(deerID, "deer", rmRandInt(8,10), 10.0);
	rmSetObjectDefMinDistance(deerID, 0.0);
	rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(deerID, avoidDeer);
	rmAddObjectDefConstraint(deerID, avoidAll);
	rmAddObjectDefConstraint(deerID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(deerID, avoidTC);
	rmSetObjectDefCreateHerd(deerID, true);
	rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);

	int turkeyID=rmCreateObjectDef("turkey flock");
	rmAddObjectDefItem(turkeyID, "turkey", rmRandInt(10,14), 10.0);
	rmSetObjectDefMinDistance(turkeyID, 0.0);
	rmSetObjectDefMaxDistance(turkeyID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(turkeyID, avoidDeer);
	rmAddObjectDefConstraint(turkeyID, avoidTurkey);
	rmAddObjectDefConstraint(turkeyID, avoidAll);
	rmAddObjectDefConstraint(turkeyID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(turkeyID, avoidTC);
	rmSetObjectDefCreateHerd(turkeyID, true);
	rmPlaceObjectDefAtLoc(turkeyID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);

   // Define and place Forests
   int forestTreeID = 0;
   int numTries=5*cNumberNonGaiaPlayers;
   int failCount=0;
   for (i=0; <numTries)
      {   
         int forest=rmCreateArea("forest "+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(400));
         rmSetAreaForestType(forest, "bayou swamp forest");
         rmSetAreaForestDensity(forest, 0.8);
         rmSetAreaForestClumpiness(forest, 0.0);
         rmSetAreaForestUnderbrush(forest, 0.0);
         rmSetAreaMinBlobs(forest, 1);
         rmSetAreaMaxBlobs(forest, 4);
         rmSetAreaMinBlobDistance(forest, 16.0);
         rmSetAreaMaxBlobDistance(forest, 20.0);
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
         rmAddAreaConstraint(forest, forestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
         rmAddAreaConstraint(forest, shortAvoidImpassableLand); 
		 rmAddAreaConstraint(forest, avoidTC); 
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
	rmSetStatusText("",0.90);

    // Embellishments
	int avoidEagles=rmCreateTypeDistanceConstraint("avoids Eagles", "EaglesNest", 40.0);

	int randomEagleTreeID=rmCreateObjectDef("random eagle tree");
	rmAddObjectDefItem(randomEagleTreeID, "EaglesNest", 1, 0.0);
	rmSetObjectDefMinDistance(randomEagleTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomEagleTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomEagleTreeID, avoidAll);
	rmAddObjectDefConstraint(randomEagleTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomEagleTreeID, avoidEagles);
	rmPlaceObjectDefAtLoc(randomEagleTreeID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	int treeVsLand = rmCreateTerrainDistanceConstraint("tree v. land", "land", true, 2.0);
	int nearShore=rmCreateTerrainMaxDistanceConstraint("tree v. water", "land", true, 14.0);

	int randomWaterTreeID=rmCreateObjectDef("random tree in water");
	rmAddObjectDefItem(randomWaterTreeID, "treeBayouMarsh", 3, 0.0);
	rmSetObjectDefMinDistance(randomWaterTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomWaterTreeID, rmXFractionToMeters(0.5));
	//rmAddObjectDefConstraint(randomWaterTreeID, nearShore);
	rmAddObjectDefConstraint(randomWaterTreeID, treeVsLand);

	int randomTurtlesID=rmCreateObjectDef("random turtles in water");
	rmAddObjectDefItem(randomTurtlesID, "propTurtles", 1, 3.0);
	rmSetObjectDefMinDistance(randomTurtlesID, 0.0);
	rmSetObjectDefMaxDistance(randomTurtlesID, rmXFractionToMeters(0.5));
	//rmAddObjectDefConstraint(randomTurtlesID, nearShore);
	rmAddObjectDefConstraint(randomTurtlesID, treeVsLand);

	int randomWaterRocksID=rmCreateObjectDef("random rocks in water");
	rmAddObjectDefItem(randomWaterRocksID, "underbrushLake", rmRandInt(3,6), 3.0);
	rmSetObjectDefMinDistance(randomWaterRocksID, 0.0);
	rmSetObjectDefMaxDistance(randomWaterRocksID, rmXFractionToMeters(0.5));
	//rmAddObjectDefConstraint(randomWaterRocksID, nearShore);
	rmAddObjectDefConstraint(randomWaterRocksID, treeVsLand);

	int avoidGeese=rmCreateTypeDistanceConstraint("avoids geese", "PropSwan", 80.0);
	int avoidDucks=rmCreateTypeDistanceConstraint("avoids ducks", "DuckFamily", 50.0);

	int randomGeeseID=rmCreateObjectDef("random Geese in water");
	rmAddObjectDefItem(randomGeeseID, "PropSwan", 1, 0.0);
	rmSetObjectDefMinDistance(randomGeeseID, 0.0);
	rmSetObjectDefMaxDistance(randomGeeseID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomGeeseID, avoidGeese);
	rmAddObjectDefConstraint(randomGeeseID, treeVsLand);

	int randomDucksID=rmCreateObjectDef("random ducks in water");
	rmAddObjectDefItem(randomDucksID, "DuckFamily", 1, 0.0);
	rmSetObjectDefMinDistance(randomDucksID, 0.0);
	rmSetObjectDefMaxDistance(randomDucksID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomDucksID, avoidGeese);
	rmAddObjectDefConstraint(randomDucksID, avoidDucks);
	rmAddObjectDefConstraint(randomDucksID, treeVsLand);

	int fishID=rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "FishSalmon", 3, 9.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishLand);
	//rmPlaceObjectDefInArea(fishID, 0, bayID, 3*cNumberNonGaiaPlayers);

	rmPlaceObjectDefAtLoc(randomWaterTreeID, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(randomTurtlesID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(randomWaterRocksID, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(randomGeeseID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(randomDucksID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
/*
	for (i=0; <20)
      {
		int dirtPatch=rmCreateArea("open dirt patch "+i);
		rmSetAreaWarnFailure(dirtPatch, false);
		rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
		//rmSetAreaMix(dirtPatch, "pampas_grass");
		rmSetAreaTerrainType(dirtPatch, "bayou\groundforest_bay");
		// rmAddAreaTerrainLayer(dirtPatch, "great_plains\ground2_gp", 0, 1);
		rmAddAreaToClass(dirtPatch, rmClassID("classPatch"));
		//rmSetAreaBaseHeight(dirtPatch, 4.0);
		rmSetAreaMinBlobs(dirtPatch, 1);
		rmSetAreaMaxBlobs(dirtPatch, 5);
		rmSetAreaMinBlobDistance(dirtPatch, 16.0);
		rmSetAreaMaxBlobDistance(dirtPatch, 40.0);
		rmSetAreaCoherence(dirtPatch, 0.2);
		rmSetAreaSmoothDistance(dirtPatch, 10);
		rmAddAreaConstraint(dirtPatch, shortAvoidImpassableLand);
		rmAddAreaConstraint(dirtPatch, patchConstraint);
		rmBuildArea(dirtPatch); 
      }
*/

	rmEchoInfo("RANDOM TEAM GROUPING = "+randomTeamGrouping);

// Text
   rmSetStatusText("",0.99);
}