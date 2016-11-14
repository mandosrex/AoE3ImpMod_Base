// Ceylon, PJJ
// Sept 2006
// Main entry point for random map script    

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.10);

  // initialize map type variables 
  string nativeCiv1 = "bhakti";
  string nativeCiv2 = "zen";
  string nativeString1 = "native bhakti village ceylon ";
  string nativeString2 = "native zen temple ceylon 0";
  string baseMix = "ceylon_grass_a";
  string paintMix = "ceylon_sand_a";
  string baseTerrain = "water";
  string seaType = "ceylon coast";
  string startTreeType = "ypTreeCeylon";
  string forestType = "Ceylon Forest";
  string cliffType = "ceylon";
  string mapType1 = "ceylon";
  string mapType2 = "grass";
  string huntable1 = "ypSerow";
  string huntable2 = "ypWildElephant";
  string fish1 = "ypFishMolaMola";
  string fish2 = "ypFishCarp";
  string whale1 = "HumpbackWhale";
  string lightingType = "ceylon";
  
	// Define Natives
	int subCiv0=-1;
	int subCiv1=-1;

  if (rmAllocateSubCivs(2) == true){
		subCiv0=rmGetCivID(nativeCiv1);
		rmEchoInfo("subCiv0 is "+nativeCiv1+" "+subCiv0);
		if (subCiv0 >= 0)
		  rmSetSubCiv(0, nativeCiv1);

		subCiv1=rmGetCivID(nativeCiv2);
		rmEchoInfo("subCiv1 is "+nativeCiv2+" "+subCiv1);
		if (subCiv1 >= 0)
		  rmSetSubCiv(1, nativeCiv2);
	}

	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.20);
	
	// Map variations: 
	
	chooseMercs();
	
	// Set size of map
	int playerTiles=18000;
  if(cNumberNonGaiaPlayers < 5)
    playerTiles = 22000;
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Set up default water type.
	rmSetSeaLevel(1.0);          
	rmSetSeaType(seaType);
	rmSetBaseTerrainMix(baseMix);
	rmSetMapType(mapType1);
	rmSetMapType(mapType2);
	rmSetMapType("water");
	rmSetLightingSet(lightingType);

	// Initialize map.
	rmTerrainInitialize(baseTerrain);

	// Misc variables for use later
	int numTries = -1;

	// Define some classes.
	int classPlayer=rmDefineClass("player");
	int classIsland=rmDefineClass("island");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	int classCanyon=rmDefineClass("canyon");

   // -------------Define constraints----------------------------------------

    // Create an edge of map constraint.
	int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Player area constraint.
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 25.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("long stay away from players", classPlayer, 60.0);
	int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 20.0);
	int avoidTP=rmCreateTypeDistanceConstraint("stay away from Trading Post Sockets", "SocketTradeRoute", 10.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);
  int mesaConstraint = rmCreateBoxConstraint("mesas stay in southern portion of island", .35, .55, .65, .35);
  int northConstraint = rmCreateBoxConstraint("huntable constraint for north side of island", .25, .55, .8, .85);

	// Island Constraints  
	int islandConstraint=rmCreateClassDistanceConstraint("islands avoid each other", classIsland, 15.0);
  int islandEdgeConstraint=rmCreatePieConstraint("island edge of map", 0.5, 0.5, 0, rmGetMapXSize()-5, 0, 0, 0);
  
	// Resource constraints - Fish, whales, forest, mines, nuggets, and sheep
	int avoidFish1=rmCreateTypeDistanceConstraint("fish v fish", fish1, 20.0);	
	int avoidFish2=rmCreateTypeDistanceConstraint("fish v fish2", fish2, 15.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
	int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", whale1, 75.0);	
	int fishVsWhaleID=rmCreateTypeDistanceConstraint("fish v whale", whale1, 8.0);   
	int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 18.0);
	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "mine", 45.0);
  int avoidGold=rmCreateTypeDistanceConstraint("avoid gold", "minegold", 35.0);
	int avoidRandomBerries=rmCreateTypeDistanceConstraint("avoid random berries", "berrybush", 55.0);
	int avoidHuntable1=rmCreateTypeDistanceConstraint("avoid huntable1", huntable1, 30.0);
  int avoidHuntable2=rmCreateTypeDistanceConstraint("avoid huntable2", huntable2, 40.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "abstractNugget", 45.0); 
  int avoidNuggetWater=rmCreateTypeDistanceConstraint("avoid water nuggets", "abstractNugget", 75.0); 
  int avoidNuggetWater2=rmCreateTypeDistanceConstraint("avoid water nuggets2", "ypNuggetBoat", 120.0); 
  int avoidHardNugget=rmCreateTypeDistanceConstraint("hard nuggets avoid other nuggets less", "abstractNugget", 20.0); 

	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 5.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
  int avoidMesa=rmCreateClassDistanceConstraint("avoid random mesas on south central portion of migration island", classCanyon, 10.0);

	// Constraint to avoid water.
	int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 4.0);
	int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 10.0);
	int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 20.0);
	int avoidWater40 = rmCreateTerrainDistanceConstraint("avoid water super long", "Land", false, 40.0);
	
  // things
	int avoidImportantItem = rmCreateClassDistanceConstraint("avoid natives", rmClassID("importantItem"), 7.0);
  int avoidImportantItemNatives = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 70.0);
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);
  
  // flag constraints
  int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 15.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
	int flagEdgeConstraint=rmCreatePieConstraint("flag edge of map", 0.5, 0.5, 0, rmGetMapXSize()-10, 0, 0, 0);

	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.30);

	// Make one big island.  
	int bigIslandID=rmCreateArea("migration island");
	rmSetAreaSize(bigIslandID, 0.18, 0.18);
	rmSetAreaCoherence(bigIslandID, 0.65);
	rmSetAreaBaseHeight(bigIslandID, 2.0);
	rmSetAreaSmoothDistance(bigIslandID, 20);
	rmSetAreaMix(bigIslandID, baseMix);
	rmAddAreaToClass(bigIslandID, classIsland);
	rmAddAreaConstraint(bigIslandID, islandConstraint);
	rmSetAreaObeyWorldCircleConstraint(bigIslandID, false);
	rmSetAreaElevationType(bigIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(bigIslandID, 2.0);
	rmSetAreaElevationMinFrequency(bigIslandID, 0.09);
	rmSetAreaElevationOctaves(bigIslandID, 3);
	rmSetAreaElevationPersistence(bigIslandID, 0.2);
	rmSetAreaElevationNoiseBias(bigIslandID, 1);
  rmSetAreaLocation(bigIslandID, .5, .5);
  rmAddAreaInfluenceSegment(bigIslandID, .4, .5, .5, .7);
  rmAddAreaInfluenceSegment(bigIslandID, .6, .5, .5, .7);
  rmAddAreaInfluenceSegment(bigIslandID, .4, .5, .5, .39);
  rmAddAreaInfluenceSegment(bigIslandID, .6, .5, .5, .39);
  rmAddAreaTerrainLayer(bigIslandID, "Ceylon\ground_sand1_Ceylon", 0, 6);
  rmAddAreaTerrainLayer(bigIslandID, "Ceylon\ground_sand2_Ceylon", 6, 9);
  rmAddAreaTerrainLayer(bigIslandID, "Ceylon\ground_sand3_Ceylon", 9, 12);
  rmAddAreaTerrainLayer(bigIslandID, "Ceylon\ground_grass2_Ceylon", 12, 15);
  
	rmBuildArea(bigIslandID);
	    	
	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.40);
  
  if (cNumberTeams == 2) {
  
    rmSetPlacementTeam(0);
    rmSetPlacementSection(0.57, 0.8);
    if(cNumberNonGaiaPlayers == 2)
      rmSetPlacementSection(.60, .61);
    rmPlacePlayersCircular(.43, .43, 0);

    rmSetPlacementTeam(1);
    rmSetPlacementSection(.2, .43);
    if(cNumberNonGaiaPlayers == 2)
      rmSetPlacementSection(.39, .40);
    rmPlacePlayersCircular(.43, .43, 0);
  }
  
  else
	{
	   rmSetPlacementSection(0.15, 0.85);
	   rmPlacePlayersCircular(0.43, 0.43, 0);
	}

	float playerFraction=rmAreaTilesToFraction(500 + cNumberNonGaiaPlayers*150);
	for(i=1; <cNumberPlayers)
	{
    // Create the Player's area.
    int id=rmCreateArea("Player"+i);
    rmSetPlayerArea(i, id);
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classIsland);
    rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, false);
	  rmSetAreaCoherence(id, 0.5);
    rmSetAreaBaseHeight(id, 2.0);
    rmSetAreaSmoothDistance(id, 20);
    rmSetAreaMix(id, paintMix);
    rmAddAreaToClass(id, classIsland);
    rmAddAreaConstraint(id, islandConstraint);
    rmAddAreaConstraint(id, islandEdgeConstraint);
    rmSetAreaElevationType(id, cElevTurbulence);
    rmSetAreaElevationVariation(id, 4.0);
    rmSetAreaElevationMinFrequency(id, 0.09);
    rmSetAreaElevationOctaves(id, 3);
    rmSetAreaElevationPersistence(id, 0.2);
    rmSetAreaElevationNoiseBias(id, 1);	    	
	}

  // Create the native areas
  int nativeAreaA=rmCreateArea("random native a", bigIslandID);
	rmSetAreaSize(nativeAreaA, 0.02, 0.02);
  rmSetAreaWarnFailure(nativeAreaA, false);
  rmSetAreaCoherence(nativeAreaA, 1.0);
  rmSetAreaLocation(nativeAreaA, .41, .64);
  
  int nativeAreaB=rmCreateArea("random native b", bigIslandID);
	rmSetAreaSize(nativeAreaB, 0.02, 0.02);
  rmSetAreaWarnFailure(nativeAreaB, false);
  rmSetAreaCoherence(nativeAreaB, 1.0);
  rmSetAreaLocation(nativeAreaB, .59, .64);
  
  int nativeArea1=rmCreateArea("random native 1", bigIslandID);
	rmSetAreaSize(nativeArea1, 0.02, 0.02);
  rmSetAreaWarnFailure(nativeArea1, false);
  rmSetAreaCoherence(nativeArea1, 1.0);
  rmSetAreaLocation(nativeArea1, .5, .375);
  
  int nativeArea2=rmCreateArea("random native 2", bigIslandID);
	rmSetAreaSize(nativeArea2, 0.02, 0.02);
  rmSetAreaWarnFailure(nativeArea2, false);
  rmSetAreaCoherence(nativeArea2, 1.0);
  rmSetAreaLocation(nativeArea2, .34, .5);
  
  int nativeArea3=rmCreateArea("random native 3", bigIslandID);
	rmSetAreaSize(nativeArea3, 0.02, 0.02);
  rmSetAreaWarnFailure(nativeArea3, false);
  rmSetAreaCoherence(nativeArea3, 1.0);
  rmSetAreaLocation(nativeArea3, .66, .5);

	// Build the areas. 
	rmBuildAllAreas();
  
  numTries = cNumberNonGaiaPlayers+1;
  int cliffSetup = 0;
  
	for(i=0; <numTries){
		int smallMesaID=rmCreateArea("small mesa 1"+i);
		rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(300), rmAreaTilesToFraction(350));
		rmSetAreaWarnFailure(smallMesaID, false);
		rmSetAreaCliffType(smallMesaID, cliffType);
		rmAddAreaToClass(smallMesaID, classCanyon);
    
    cliffSetup = rmRandInt(1,2);
    if(cliffSetup == 1){
      rmSetAreaCliffEdge(smallMesaID, 2, .4, 0.1, 1.0, 0);
    }
    
    else {
      rmSetAreaCliffEdge(smallMesaID, 3, .25, 0.1, 1.0, 0);
    }
    
		rmSetAreaCliffHeight(smallMesaID, rmRandInt(4,4), 1.0, .5); 
		rmSetAreaCoherence(smallMesaID, 0.75);
    rmAddAreaConstraint(smallMesaID, avoidWater20);
    rmAddAreaConstraint(smallMesaID, avoidMesa);
    rmAddAreaConstraint(smallMesaID, mesaConstraint);
		rmBuildArea(smallMesaID);
	}

   	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.50);
  
	// NATIVES
  
	// Always have 1 & 1 on main island 
		
  int nativeAVillageID = -1;
  int nativeBVillageID = -1;
  int nativeAVillageType = 0;
  int nativeBVillageType = 0;
  
  if (subCiv0 == rmGetCivID(nativeCiv1)) {  
    nativeAVillageType = rmRandInt(1,5);
    nativeAVillageID = rmCreateGrouping("native village 1a", nativeString1+nativeAVillageType);
    rmSetGroupingMinDistance(nativeAVillageID, 0.0);
    rmSetGroupingMaxDistance(nativeAVillageID, 15.0);
    rmAddGroupingConstraint(nativeAVillageID, avoidMesa);
    rmAddGroupingConstraint(nativeAVillageID, avoidWater8);
    rmAddGroupingConstraint(nativeAVillageID, avoidImportantItemNatives);
    rmAddGroupingToClass(nativeAVillageID, rmClassID("importantItem"));
    //~ rmPlaceGroupingAtLoc(nativeAVillageID, 0, 0.39, 0.66);	

    rmPlaceGroupingInArea(nativeAVillageID, 0, nativeAreaA, 1);	
  }	

  if (subCiv1 == rmGetCivID(nativeCiv2)) {  
    nativeBVillageType = rmRandInt(1,5);
    nativeBVillageID = rmCreateGrouping("native village 1b", nativeString2+nativeBVillageType);
    rmSetGroupingMinDistance(nativeBVillageID, 0.0);
    rmSetGroupingMaxDistance(nativeBVillageID, 15.0);
    rmAddGroupingConstraint(nativeBVillageID, avoidWater8);
    rmAddGroupingConstraint(nativeBVillageID, avoidMesa);
    rmAddGroupingConstraint(nativeBVillageID, avoidImportantItemNatives);
    rmAddGroupingToClass(nativeBVillageID, rmClassID("importantItem"));
    //~ rmPlaceGroupingAtLoc(nativeBVillageID, 0, 0.61, 0.66);
    
    rmPlaceGroupingInArea(nativeBVillageID, 0, nativeAreaB, 1);	
    
  } 
  
  string randomNative = "";
  
  int whichNative = rmRandInt(1,2);
  
  if(whichNative == 1)
    randomNative = nativeString1;
  
  else
    randomNative = nativeString2;
  
  // place at least 3 native sites on the island
  int randomNativeType = rmRandInt(1,5);
  int randomNativeID = rmCreateGrouping("random village 1", randomNative+randomNativeType);
  rmSetGroupingMinDistance(randomNativeID, 0.0);
  rmSetGroupingMaxDistance(randomNativeID, 15.0);
  rmAddGroupingConstraint(randomNativeID, avoidMesa);
  rmAddGroupingConstraint(randomNativeID, avoidWater8);
  rmAddGroupingConstraint(randomNativeID, avoidImportantItemNatives);
  rmAddGroupingToClass(randomNativeID, rmClassID("importantItem"));
  
  //~ rmPlaceGroupingAtLoc(randomNativeID, 0, 0.5, 0.8); 
  
  rmPlaceGroupingInArea(randomNativeID, 0, nativeArea1, 1);	
    
  // More players, more natives
  int whichNative2 = rmRandInt(1,2);
  string randomNative2 = "";
  
  if(whichNative2 == 1)
    randomNative2 = nativeString1;
  
  else
    randomNative2 = nativeString2;
  
  if(cNumberNonGaiaPlayers > 5) {
    int randomNativeType2 = rmRandInt(1,5);
    int randomNativeID2 = rmCreateGrouping("random village 2", randomNative2+randomNativeType2);
    rmSetGroupingMinDistance(randomNativeID2, 0.0);
    rmSetGroupingMaxDistance(randomNativeID2, 15.0);
    rmAddGroupingConstraint(randomNativeID2, avoidMesa);
    rmAddGroupingConstraint(randomNativeID2, avoidWater8);
    rmAddGroupingConstraint(randomNativeID2, avoidImportantItemNatives);
    rmAddGroupingToClass(randomNativeID2, rmClassID("importantItem"));
    //~ rmPlaceGroupingInArea(randomNativeID2, 0, bigIslandID, 1);		
    //~ rmPlaceGroupingAtLoc(randomNativeID2, 0, 0.41, 0.33); 
    
    rmPlaceGroupingInArea(randomNativeID2, 0, nativeArea2, 1);	
    
    int randomNativeType3 = rmRandInt(1,5);
    int randomNativeID3 = rmCreateGrouping("random village 3", randomNative2+randomNativeType3);
    rmSetGroupingMinDistance(randomNativeID3, 0.0);
    rmSetGroupingMaxDistance(randomNativeID3, 15.0);
    rmAddGroupingConstraint(randomNativeID3, avoidMesa);
    rmAddGroupingConstraint(randomNativeID3, avoidWater8); 
    rmAddGroupingConstraint(randomNativeID3, avoidImportantItemNatives);
    rmAddGroupingToClass(randomNativeID3, rmClassID("importantItem"));
    //~ rmPlaceGroupingInArea(randomNativeID3, 0, bigIslandID, 1);		
    //~ rmPlaceGroupingAtLoc(randomNativeID3, 0, 0.59, 0.33); 
    
    rmPlaceGroupingInArea(randomNativeID3, 0, nativeArea3, 1);	
  }
  
  int whichNative3 = rmRandInt(1,2);
  string randomNative3 = "";
  
  if(whichNative3 == 1)
    randomNative3 = nativeString1;
  
  else
    randomNative3 = nativeString2;
  
  if(cNumberNonGaiaPlayers > 7) {
    int randomNativeType4 = rmRandInt(1,5);
    int randomNativeID4 = rmCreateGrouping("random village 4", randomNative3+randomNativeType4);
    rmSetGroupingMinDistance(randomNativeID4, 0.0);
    rmSetGroupingMaxDistance(randomNativeID4, 15.0);
    rmAddGroupingConstraint(randomNativeID4, avoidMesa);
    rmAddGroupingConstraint(randomNativeID4, avoidWater8);
    rmAddGroupingConstraint(randomNativeID4, avoidImportantItemNatives);
    rmAddGroupingToClass(randomNativeID4, rmClassID("importantItem"));
    rmPlaceGroupingInArea(randomNativeID4, 0, bigIslandID, 1);	
    //~ rmPlaceGroupingAtLoc(randomNativeID4, 0, 0.3, 0.5); 
    
    int randomNativeType5 = rmRandInt(1,5);
    int randomNativeID5 = rmCreateGrouping("random village 5", randomNative3+randomNativeType5);
    rmSetGroupingMinDistance(randomNativeID5, 0.0);
    rmSetGroupingMaxDistance(randomNativeID5, 15.0);
    rmAddGroupingConstraint(randomNativeID5, avoidMesa);
    rmAddGroupingConstraint(randomNativeID5, avoidWater8);    
    rmAddGroupingConstraint(randomNativeID5, avoidImportantItemNatives);
    rmAddGroupingToClass(randomNativeID5, rmClassID("importantItem"));
    rmPlaceGroupingInArea(randomNativeID5, 0, bigIslandID, 1);	
    //~ rmPlaceGroupingAtLoc(randomNativeID5, 0, 0.7, 0.5); 
  }

	// text
	rmSetStatusText("",0.60);

	//Place player TCs and starting Gold Mines. 

	int TCID = rmCreateObjectDef("player TC");
	if ( rmGetNomadStart())
		rmAddObjectDefItem(TCID, "coveredWagon", 1, 0);
	else
		rmAddObjectDefItem(TCID, "townCenter", 1, 0);

	//Prepare to place TCs
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 3.0);

	//Prepare to place Explorers, Explorer's dog, etc.
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 8.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);

	//Prepare to place player starting Mines 
	int playerGoldID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(playerGoldID, "minegold", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 12.0);
	rmSetObjectDefMaxDistance(playerGoldID, 20.0);
	rmAddObjectDefConstraint(playerGoldID, avoidAll);
  rmAddObjectDefConstraint(playerGoldID, avoidImpassableLand);

	//Prepare to place player starting food
	int playerFoodID=rmCreateObjectDef("player food");
  rmAddObjectDefItem(playerFoodID, huntable1, 8, 4.0);
  rmSetObjectDefMinDistance(playerFoodID, 10);
	rmSetObjectDefMaxDistance(playerFoodID, 15);	
	rmAddObjectDefConstraint(playerFoodID, avoidAll);
  rmAddObjectDefConstraint(playerFoodID, avoidImpassableLand);
  rmSetObjectDefCreateHerd(playerFoodID, false);
  
  //Prepare to place player starting Berries
	int playerBerriesID=rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerBerriesID, "berrybush", 6, 4.0);
  rmSetObjectDefMinDistance(playerBerriesID, 15);
  rmSetObjectDefMaxDistance(playerBerriesID, 20);		
	rmAddObjectDefConstraint(playerBerriesID, avoidAll);
  rmAddObjectDefConstraint(playerBerriesID, avoidImpassableLand);

	//Prepare to place player starting trees
	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 10, 12.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 17.0);
  
  // Starting area nuggets
  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 10.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 15.0);
  rmAddObjectDefConstraint(playerNuggetID, avoidAll);
  rmAddObjectDefConstraint(playerNuggetID, shortAvoidImpassableLand);

	int waterSpawnPointID = 0;

	// --------------- Make load bar move. ----------------------------------------------------------------------------`
	rmSetStatusText("",0.70);
   
	// *********** Place Home City Water Spawn Flag ***************************************************
  
  rmClearClosestPointConstraints();

	for(i=1; <cNumberPlayers) {
    
    // Place TC and starting units
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));				
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));    
		rmPlaceObjectDefAtLoc(playerFoodID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc))); 
    rmPlaceObjectDefAtLoc(playerBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc))); 

		// Place player starting trees
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    // Place starting nugget
    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    
		// Place water spawn points for the players along with a canoe
		waterSpawnPointID=rmCreateObjectDef("colony ship "+i);
		rmAddObjectDefItem(waterSpawnPointID, "HomeCityWaterSpawnFlag", 1, 10.0);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
    rmAddClosestPointConstraint(flagEdgeConstraint);
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(waterSpawnPointID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
     
    int catamaranID=rmCreateObjectDef("Catamaran"+i);
    rmAddObjectDefItem(catamaranID, "ypMarathanCatamaran", 1, 0.0);
    rmPlaceObjectDefAtLoc(catamaranID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
     
		rmClearClosestPointConstraints();
   }
	
   	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.75);

	//rmClearClosestPointConstraints();

	// ***************** SCATTERED RESOURCES **************************************
	// Scattered FORESTS
  int forestTreeID = 0;
  numTries=10*cNumberNonGaiaPlayers;
  int failCount=0;
  for (i=0; <numTries)
  {   
    int forest=rmCreateArea("forest "+i, bigIslandID);
    rmSetAreaWarnFailure(forest, false);
    rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
    rmSetAreaForestType(forest, forestType);
    rmSetAreaForestDensity(forest, 0.6);
    rmSetAreaForestClumpiness(forest, 0.4);
    rmSetAreaForestUnderbrush(forest, 0.0);
    rmSetAreaMinBlobs(forest, 1);
    rmSetAreaMaxBlobs(forest, 5);
    rmSetAreaMinBlobDistance(forest, 16.0);
    rmSetAreaMaxBlobDistance(forest, 40.0);
    rmSetAreaCoherence(forest, 0.4);
    rmSetAreaSmoothDistance(forest, 10);
    rmAddAreaToClass(forest, rmClassID("classForest")); 
    rmAddAreaConstraint(forest, forestConstraint);
    rmAddAreaConstraint(forest, avoidAll);
    rmAddAreaConstraint(forest, avoidImportantItem);
    rmAddAreaConstraint(forest, shortAvoidImpassableLand); 
    rmAddAreaConstraint(forest, avoidTP); 
    
    if(rmBuildArea(forest)==false) {
      // Stop trying once we fail 3 times in a row.
      failCount++;
      if(failCount==5)
        break;
    }
    
    else
      failCount=0; 
   } 
    
    // --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.80);

	// Scattered silver throughout island and gold in south central area
	int goldID = rmCreateObjectDef("random gold");
	rmAddObjectDefItem(goldID, "minegold", 1, 0);
	rmSetObjectDefMinDistance(goldID, 0.0);
	rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(goldID, avoidAll);
  rmAddObjectDefConstraint(goldID, avoidWater8);
	rmAddObjectDefConstraint(goldID, avoidGold);
  rmAddObjectDefConstraint(goldID, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(goldID, mesaConstraint); // keep the gold mines in the same area as the ridges
	rmPlaceObjectDefInArea(goldID, 0, bigIslandID, cNumberNonGaiaPlayers*2);

  int silverID = rmCreateObjectDef("random silver");
	rmAddObjectDefItem(silverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(silverID, 0.0);
	rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(silverID, avoidAll);
  rmAddObjectDefConstraint(silverID, avoidWater8);
	rmAddObjectDefConstraint(silverID, avoidGold);
  rmAddObjectDefConstraint(silverID, avoidCoin);
  rmAddObjectDefConstraint(silverID, avoidTP);
  rmAddObjectDefConstraint(silverID, avoidImportantItem);
  rmAddObjectDefConstraint(silverID, shortAvoidImpassableLand);
	rmPlaceObjectDefInArea(silverID, 0, bigIslandID, cNumberNonGaiaPlayers*3);
   
	// Scattered berries all over island
	int berriesID=rmCreateObjectDef("random berries");
	rmAddObjectDefItem(berriesID, "berrybush", rmRandInt(5,8), 4.0); 
	rmSetObjectDefMinDistance(berriesID, 0.0);
	rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(berriesID, avoidTP);   
	rmAddObjectDefConstraint(berriesID, avoidAll);
  rmAddObjectDefConstraint(berriesID, avoidImportantItem);
	rmAddObjectDefConstraint(berriesID, avoidRandomBerries);
	rmAddObjectDefConstraint(berriesID, shortAvoidImpassableLand);
	rmPlaceObjectDefInArea(berriesID, 0, bigIslandID, cNumberNonGaiaPlayers*4);

	// Huntables scattered on N side of island
	int foodID1=rmCreateObjectDef("random food");
	rmAddObjectDefItem(foodID1, huntable1, rmRandInt(6,7), 5.0);
	rmSetObjectDefMinDistance(foodID1, 0.0);
	rmSetObjectDefMaxDistance(foodID1, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(foodID1, avoidHuntable1);
	rmAddObjectDefConstraint(foodID1, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(foodID1, northConstraint);
  rmAddObjectDefConstraint(foodID1, avoidTP);
  rmAddObjectDefConstraint(foodID1, avoidImportantItem);
	rmPlaceObjectDefInArea(foodID1, 0, bigIslandID, cNumberNonGaiaPlayers*4);  
  
  // Huntables scattered on island
	int foodID2=rmCreateObjectDef("random food two");
	rmAddObjectDefItem(foodID2, huntable2, rmRandInt(2,2), 3.0);
	rmSetObjectDefMinDistance(foodID2, 0.0);
	rmSetObjectDefMaxDistance(foodID2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(foodID2, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(foodID2, avoidTP);
  rmAddObjectDefConstraint(foodID2, avoidImportantItem);
  rmAddObjectDefConstraint(foodID2, avoidHuntable1);
  rmAddObjectDefConstraint(foodID2, avoidHuntable2);
	rmPlaceObjectDefInArea(foodID2, 0, bigIslandID, cNumberNonGaiaPlayers*3);  

	// Define and place Nuggets
    

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.0;
    float walk = 0.075;
    
    if(randLoc == 1 || cNumberTeams > 2)
      yLoc = .5;
    
    else
      yLoc = .75;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
	// Easier nuggets
	int nugget1= rmCreateObjectDef("nugget easy"); 
	rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 3);
	rmSetObjectDefMinDistance(nugget1, 0.0);
	rmSetObjectDefMaxDistance(nugget1, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget1, avoidNugget);
  rmAddObjectDefConstraint(nugget1, avoidImportantItem);
	rmAddObjectDefConstraint(nugget1, avoidTP);
	rmAddObjectDefConstraint(nugget1, avoidAll);
	rmAddObjectDefConstraint(nugget1, avoidWater8);
	rmAddObjectDefConstraint(nugget1, playerEdgeConstraint);
	rmPlaceObjectDefInArea(nugget1, 0, bigIslandID, cNumberNonGaiaPlayers*5);

	// Water nuggets
  int nuggetCount = 4;
  
  int nugget2= rmCreateObjectDef("nugget water" + i); 
  rmAddObjectDefItem(nugget2, "ypNuggetBoat", 1, 0.0);
  rmSetNuggetDifficulty(5, 5);
  rmSetObjectDefMinDistance(nugget2, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget2, avoidLand);
  rmAddObjectDefConstraint(nugget2, avoidNuggetWater);
  rmAddObjectDefConstraint(nugget2, avoidNuggetWater2);
  rmPlaceObjectDefPerPlayer(nugget2, false, nuggetCount);
  
  // really tough nuggets confined to south central cliffy area
  int nugget3= rmCreateObjectDef("nugget hardest"); 
	rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(4, 4);
	rmSetObjectDefMinDistance(nugget3, 0.0);
	rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget3, avoidHardNugget);
  rmAddObjectDefConstraint(nugget3, mesaConstraint);
  rmAddObjectDefConstraint(nugget3, avoidImportantItem);
	rmPlaceObjectDefInArea(nugget3, 0, bigIslandID, cNumberNonGaiaPlayers);

    // --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.90);

	//Place random whales everywhere --------------------------------------------------------
	int whaleID=rmCreateObjectDef("whale");
	rmAddObjectDefItem(whaleID, whale1, 1, 0.0);
	rmSetObjectDefMinDistance(whaleID, 0.2);
	rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.47));
	rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
	rmAddObjectDefConstraint(whaleID, whaleLand);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4); 

	// Place Random Fish everywhere, but restrained to avoid whales ------------------------------------------------------

	int fishID=rmCreateObjectDef("fish 1");
	rmAddObjectDefItem(fishID, fish1, 1, 0.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, avoidFish1);
	rmAddObjectDefConstraint(fishID, fishVsWhaleID);
	rmAddObjectDefConstraint(fishID, fishLand);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 15*cNumberNonGaiaPlayers);

	int fish2ID=rmCreateObjectDef("fish 2");
	rmAddObjectDefItem(fish2ID, fish2, 1, 0.0);
	rmSetObjectDefMinDistance(fish2ID, 0.0);
	rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fish2ID, avoidFish2);
	rmAddObjectDefConstraint(fish2ID, fishVsWhaleID);
	rmAddObjectDefConstraint(fish2ID, fishLand);
	rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 12*cNumberNonGaiaPlayers);

	if (cNumberNonGaiaPlayers <5)		// If less than 5 players, place extra fish.
	{
		rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);	
	}

    // Starter shipment triggers
  for(i = 1; < cNumberPlayers) {
    rmCreateTrigger("XP"+i);
    rmSwitchToTrigger(rmTriggerID("XP"+i));
    rmSetTriggerPriority(3); 
    rmSetTriggerActive(true);
    rmSetTriggerRunImmediately(true);
    rmSetTriggerLoop(false);
      
    rmAddTriggerCondition("Always");
    
    rmAddTriggerEffect("Grant Resources");
    rmSetTriggerEffectParamInt("PlayerID", i, false);
    rmSetTriggerEffectParam("ResName", "XP", false);
    rmSetTriggerEffectParam("Amount", "275", false);
  }

    // --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("",0.99);
}