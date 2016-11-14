// ESOC INDONESIA (1V1, TEAM, FFA)
// designed by Garja

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";


// Main entry point for random map script
void main(void)
{
		
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01); 
	
	// ************************************** GENERAL FEATURES *****************************************
	
	//Pick spawn variation
	int playerplacement = -1;
	playerplacement = rmRandInt(0,1);
//	playerplacement = 0; // <--- TEST
	if (cNumberNonGaiaPlayers > 2)
		playerplacement = 1;
	
	// Picks the map size
	int playerTiles=24000; //
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles=22000; 
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles=20000; 
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(false);
	
	// Picks a default water height
	rmSetSeaLevel(1.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

//	rmSetMapElevationParameters(cElevTurbulence, 0.05, 2, 0.5, 4.5); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	
	// Picks default terrain and water
	rmSetSeaType("Indonesia Coast");
	rmSetBaseTerrainMix("coastal_japan_b"); // 
	rmTerrainInitialize("water", 0.0); // 
	rmSetMapType("Japan"); 
	rmSetMapType("grass");
	rmSetMapType("water");
	rmSetLightingSet("borneo");

	// Choose Mercs
	chooseMercs();
	  
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	subCiv0 = rmGetCivID("Jesuit");
	subCiv1 = rmGetCivID("Zen");
	rmSetSubCiv(0, "Jesuit");
	rmSetSubCiv(1, "Zen");
	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPond = rmDefineClass("pond");
	int classRocks = rmDefineClass("rocks");
	int classGrass = rmDefineClass("grass");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classIsland=rmDefineClass("island");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.38), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.22), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.16), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int staySouthPart = rmCreatePieConstraint("Stay south part", 0.55, 0.55,rmXFractionToMeters(0.0), rmXFractionToMeters(0.60), rmDegreesToRadians(135),rmDegreesToRadians(315));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
		
	// Resource avoidance
	int avoidForest = rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 24.0); //15.0
	int avoidForestShort = rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 18.0); //15.0
	int avoidForestVeryShort = rmCreateClassDistanceConstraint("avoid forest very short", rmClassID("Forest"), 8.0); //15.0
	int avoidForestMin = rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidBerriesFar = rmCreateTypeDistanceConstraint("avoid Berries far", "berrybush", 50.0);
	int avoidBerries = rmCreateTypeDistanceConstraint("avoid Berries", "berrybush", 40.0);
	int avoidBerriesShort = rmCreateTypeDistanceConstraint("avoid Berries short", "berrybush", 20.0);
	int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid Berries min", "berrybush", 4.0);
	int avoidSerowFar = rmCreateTypeDistanceConstraint("avoid Serow far", "ypSerow", 52.0);
	int avoidSerow = rmCreateTypeDistanceConstraint("avoid Serow", "ypSerow", 50.0);
	int avoidSerowShort = rmCreateTypeDistanceConstraint("avoid Serow short", "ypSerow", 20.0);
	int avoidSerowMin = rmCreateTypeDistanceConstraint("avoid Serow min", "ypSerow", 4.0);
	int avoidEleFar = rmCreateTypeDistanceConstraint("avoid Ele far", "ypIbex", 45.0);
	int avoidEle = rmCreateTypeDistanceConstraint("avoid Ele", "ypIbex", 40.0);
	int avoidEleShort = rmCreateTypeDistanceConstraint("avoid  Ele short", "ypIbex", 25.0);
	int avoidEleMin = rmCreateTypeDistanceConstraint("avoid Ele min", "ypIbex", 5.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 25.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 45.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 52.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 15.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 58.0-1*cNumberNonGaiaPlayers);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 68.0-1*cNumberNonGaiaPlayers);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 66.0);
	int avoidNuggetWater = rmCreateTypeDistanceConstraint("avoid nugget water", "AbstractNugget", 95.0);
	int avoidNuggetWaterShort = rmCreateTypeDistanceConstraint("avoid nugget water short", "AbstractNugget", 15.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("avoid nugget short", "AbstractNugget", 40.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("avoid nugget", "AbstractNugget", 50.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("avoid nugget Far", "AbstractNugget", 50.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 70.0-1*cNumberNonGaiaPlayers);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 46.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 30.0);
//	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 26.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 6.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 10.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 15.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "fish", 50.0);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 30.0);
	int avoidBuffalo=rmCreateTypeDistanceConstraint("avoid buffalo", "ypWaterBuffalo", 50.0);
	int avoidFlag = rmCreateTypeDistanceConstraint("avoid water flag", "HomeCityWaterSpawnFlag", 20.0);
	int avoidFlagShort = rmCreateTypeDistanceConstraint("avoid water flag short", "HomeCityWaterSpawnFlag", 10.0);

	// Avoid impassable land
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 0.5);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 6.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land medium", "Land", false, 12.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 8.0);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 15.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 20.0);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "land", false, 30.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 20.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 5.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 20.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 8.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 12.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int avoidCliffShort = rmCreateClassDistanceConstraint("avoid cliff short", classCliff, 3.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", classCliff, 5.0);
	
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);	
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 3.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
   
	
	// ***********************************************************************************************
	
	// **************************************** PLACE PLAYERS ****************************************
	
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
		
	if (cNumberTeams <= 2) // 1v1 and TEAM
	{
		if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
		{
			float OneVOnePlacement=rmRandFloat(0.0, 0.9);
			
			if (playerplacement == 1)
			{
				if ( OneVOnePlacement < 0.5)
				{
					rmPlacePlayer(1, 0.28, 0.52);
					rmPlacePlayer(2, 0.72, 0.48);
				}
				else
				{
					rmPlacePlayer(2, 0.28, 0.52);
					rmPlacePlayer(1, 0.72, 0.48);
				}
			}
			else
			{
				if ( OneVOnePlacement < 0.5)
				{
					rmPlacePlayer(1, 0.48, 0.72);
					rmPlacePlayer(2, 0.52, 0.28);
				}
				else
				{
					rmPlacePlayer(2, 0.48, 0.72);
					rmPlacePlayer(1, 0.52, 0.28);
				}
			}
		}
		else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
		{
			if (teamZeroCount == 2) // 2v2
			{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.28, 0.64, 0.28, 0.48, 0.00, 0.25);

				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.72, 0.52, 0.72, 0.36, 0.00, 0.25);
			}
			else // 3v3, 4v4
			{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.28, 0.68, 0.28, 0.44, 0.00, 0.25);

				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.72, 0.56, 0.72, 0.32, 0.00, 0.25);
			}
		}
		else // unequal N of players per TEAM
		{
			if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
			{
				if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.28, 0.53, 0.28, 0.55, 0.00, 0.25);
								
					rmSetPlacementTeam(1);
					if (teamOneCount == 2)
						rmPlacePlayersLine(0.72, 0.52, 0.72, 0.36, 0.00, 0.25);
					else
						rmPlacePlayersLine(0.72, 0.56, 0.72, 0.32, 0.00, 0.25);
				} 
				else // 2v1, 3v1, 4v1, etc.
				{
					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.72, 0.45, 0.72, 0.47, 0.00, 0.25);
								
					rmSetPlacementTeam(0);
					if (teamZeroCount == 2)
						rmPlacePlayersLine(0.28, 0.64, 0.28, 0.48, 0.00, 0.25);
					else
						rmPlacePlayersLine(0.28, 0.68, 0.28, 0.44, 0.00, 0.25);
				} 
			}
			else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
			{
				if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.28, 0.64, 0.28, 0.48, 0.00, 0.25);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.72, 0.56, 0.72, 0.32, 0.00, 0.25);
				} 
				else // 3v2, 4v2, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.28, 0.68, 0.28, 0.44, 0.00, 0.25);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.72, 0.52, 0.72, 0.36, 0.00, 0.25);
				} 
			}
			else // 3v4, 4v3, etc.
			{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.28, 0.68, 0.28, 0.44, 0.00, 0.25);

				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.72, 0.56, 0.72, 0.32, 0.00, 0.25);
			} 
		}
	}
	else // FFA
	{	
		rmPlacePlayer(1, 0.28, 0.52);
		rmPlacePlayer(2, 0.72, 0.48);
		rmPlacePlayer(3, 0.52, 0.34);
		rmPlacePlayer(4, 0.48, 0.66);
		rmPlacePlayer(5, 0.70, 0.32);
		rmPlacePlayer(6, 0.30, 0.68);
		rmPlacePlayer(7, 0.87, 0.76);
		rmPlacePlayer(8, 0.13, 0.24);
	}
	
	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.30);
	
	// ******************************************** MAP LAYOUT **************************************************
	
	//Bays
	int bay1ID = rmCreateArea("bay 1");
//	rmSetAreaWaterType(bay1ID, "borneo water");
	rmSetAreaSize(bay1ID, 0.03, 0.03);
	if (playerplacement == 1)
		rmSetAreaLocation(bay1ID, 0.52, 0.84);
	else
		rmSetAreaLocation(bay1ID, 0.84, 0.52);
	rmSetAreaCoherence(bay1ID, 0.60);
	rmSetAreaSmoothDistance(bay1ID, 12);
//	rmAddAreaInfluenceSegment(bay1ID, 0.42, 0.58, 0.58, 0.42);
//	rmAddAreaTerrainLayer(bay1ID, "borneo\ground_sand1_borneo", 0, 3);
	rmBuildArea(bay1ID); 
	
	int avoidBay1 = rmCreateAreaDistanceConstraint("avoid bay1", bay1ID, 1.0);
	
	int bay2ID = rmCreateArea("bay 2");
//	rmSetAreaWaterType(bay2ID, "borneo water");
	rmSetAreaSize(bay2ID, 0.03, 0.03);
	if (playerplacement == 1)
		rmSetAreaLocation(bay2ID, 0.52, 0.16);
	else
		rmSetAreaLocation(bay2ID, 0.16, 0.52);
	rmSetAreaCoherence(bay2ID, 0.60);
	rmSetAreaSmoothDistance(bay2ID, 12);
//	rmAddAreaInfluenceSegment(bay2ID, 0.42, 0.58, 0.58, 0.42);
//	rmAddAreaTerrainLayer(bay2ID, "borneo\ground_sand1_borneo", 0, 3);
	rmBuildArea(bay2ID); 
	
	int avoidBay2 = rmCreateAreaDistanceConstraint("avoid bay2", bay2ID, 1.0);
	
	
	//Main island
	int mainislandID = rmCreateArea("main island");
	rmSetAreaSize(mainislandID, 0.25, 0.25);
	rmSetAreaLocation(mainislandID, 0.50, 0.50);
	rmAddAreaInfluenceSegment(mainislandID, 0.42, 0.58, 0.58, 0.42);
	rmSetAreaMix(mainislandID, "coastal_japan_b");
	rmSetAreaTerrainType(mainislandID, "coastal_japan\ground_forest_co_japan"); 
	rmPaintAreaTerrain(mainislandID);
	rmAddAreaTerrainLayer(mainislandID, "coastal_japan\ground_dirt1_co_japan", 0, 2);
	rmAddAreaTerrainLayer(mainislandID, "coastal_japan\ground_dirt3_co_japan", 2, 4);
	rmAddAreaTerrainLayer(mainislandID, "coastal_japan\ground_dirt2_co_japan", 4, 6);
	rmAddAreaTerrainLayer(mainislandID, "coastal_japan\ground_grass3_co_japan", 6, 8);
	rmAddAreaTerrainLayer(mainislandID, "coastal_japan\ground_grass3_co_japan", 8, 10);
	rmAddAreaTerrainLayer(mainislandID, "coastal_japan\ground_grass2_co_japan", 10, 12);
	rmAddAreaTerrainLayer(mainislandID, "coastal_japan\ground_grass1_co_japan", 12, 14);
	rmSetAreaWarnFailure(mainislandID, false);
	rmAddAreaToClass(mainislandID, classIsland);
	rmSetAreaCoherence(mainislandID, 0.60); //.46
	rmSetAreaSmoothDistance(mainislandID, 18);
	rmSetAreaElevationType(mainislandID, cElevTurbulence);
	rmSetAreaElevationVariation(mainislandID, 5.0);
	rmSetAreaBaseHeight(mainislandID, 4.0);
	rmSetAreaElevationMinFrequency(mainislandID, 0.04);
	rmSetAreaElevationOctaves(mainislandID, 3);
	rmSetAreaElevationPersistence(mainislandID, 0.4);      
// 	rmAddConnectionArea(shallowsID, mainislandID);
	rmSetAreaObeyWorldCircleConstraint(mainislandID, false);
	rmAddAreaConstraint(mainislandID, avoidBay1);
	rmAddAreaConstraint(mainislandID, avoidBay2);
	rmBuildArea(mainislandID);
	
	int avoidMainIsland = rmCreateAreaDistanceConstraint("avoid main island", mainislandID, 25.0);
	int stayInMainIsland = rmCreateAreaMaxDistanceConstraint("stay in main island", mainislandID, 0.0);

	
	//Grass patch
	for (i=0; < 26)
	{
		int patchID = rmCreateArea("grass patch"+i);
		rmSetAreaWarnFailure(patchID, false);
//		rmSetAreaObeyWorldCircleConstraint(patchID, false);
		rmSetAreaSize(patchID, rmAreaTilesToFraction(70), rmAreaTilesToFraction(80));
		rmSetAreaTerrainType(patchID, "coastal_japan\ground_forest_co_japan");
		rmAddAreaToClass(patchID, rmClassID("patch"));
		rmSetAreaMinBlobs(patchID, 1);
		rmSetAreaMaxBlobs(patchID, 5);
		rmSetAreaMinBlobDistance(patchID, 13.0);
		rmSetAreaMaxBlobDistance(patchID, 30.0);
		rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidPatch);
//		rmAddAreaConstraint(patchID, stayInMainIsland);
		rmAddAreaConstraint(patchID, avoidImpassableLandMed);
		rmBuildArea(patchID); 
	}

	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.03, 0.03);
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
//	rmSetAreaTerrainType(playerareaID, "new_england\ground2_cliff_ne"); // for testing
	rmSetAreaLocPlayer(playerareaID, i);
	rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
	rmBuildArea(playerareaID);
	rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 3.0);
	rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}
	
	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayInPlayerArea1 = rmConstraintID("stay in player area 1");
	int stayInPlayerArea2 = rmConstraintID("stay in player area 2");
	
	
	
	//Hill A
	for (i=0; < 3)
	{
		int hillAID = rmCreateArea("hill A"+i);
		if (i == 0)
		{
			rmSetAreaSize(hillAID, 0.017, 0.017);
			rmSetAreaCoherence(hillAID, 0.70);
		//	rmSetAreaCliffHeight(hillAID, 2.0, 0.0, 0.8); 
		//	rmSetAreaCliffEdge(hillAID, 1, 0.5, 0.0, 0.0, 1); 
		//	rmSetAreaCliffType(hillAID, "coastal japan"); 
		//	rmSetAreaTerrainType(hillAID, "borneo\ground_grass1_borneo");
		//	rmPaintAreaTerrain(hillAID);
		//	rmSetAreaCliffPainting(hillAID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		//	rmAddAreaConstraint(hillAID, avoidWater);
			int stayInHillA1stlvl = rmCreateAreaMaxDistanceConstraint("stay in hill A first level", hillAID, 0.0);
		}
		else if (i==1)
		{
			rmSetAreaSize(hillAID, 0.011, 0.011);
			rmSetAreaCoherence(hillAID, 0.4);
			rmSetAreaCliffHeight(hillAID, 4.0, 0.0, 0.4); 
			rmSetAreaCliffEdge(hillAID, 1, 0.55, 0.0, 0.0, 1); 
			rmSetAreaCliffType(hillAID, "coastal japan"); 
		//	rmSetAreaTerrainType(hillAID, "borneo\ground_grass1_borneo");	
			rmSetAreaCliffPainting(hillAID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
			int stayInHillA2ndlvl = rmCreateAreaMaxDistanceConstraint("stay in hill A second level", hillAID, 0.0);
			rmAddAreaConstraint(hillAID, avoidImpassableLandShort);
			rmAddAreaConstraint(hillAID, stayInHillA1stlvl);
			
		}
		/*
		else
		{
			rmSetAreaSize(hillAID, 0.014, 0.014);
			rmSetAreaCoherence(hillAID, 0.60);
			rmSetAreaCliffHeight(hillAID, 2.2, 0.0, 0.3); 
			rmSetAreaCliffEdge(hillAID, 1, 0.5, 0.0, 0.0, 1); 
			rmSetAreaCliffType(hillAID, "coastal japan"); 
			rmSetAreaTerrainType(hillAID, "coastal_japan\ground_forest_co_japan");	
	//		rmSetAreaCliffPainting(hillAID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
			rmAddAreaConstraint(hillAID, avoidImpassableLandShort);
			rmAddAreaConstraint(hillAID, stayInHillA2ndlvl);
		
		}
		*/
		rmSetAreaWarnFailure(hillAID, false);
		rmSetAreaObeyWorldCircleConstraint(hillAID, false);	
		rmSetAreaSmoothDistance(hillAID, 9);
		rmAddAreaToClass(hillAID, rmClassID("Cliffs"));
		if (playerplacement == 1)
			rmSetAreaLocation(hillAID, 0.44, 0.62);
		else 
			rmSetAreaLocation(hillAID, 0.36, 0.54);
		if (cNumberTeams <= 2)
			rmBuildArea(hillAID);
		/*
		for (j=0; < 600)
		{
			int RiceAID = rmCreateObjectDef("riceA"+i+j);
			rmAddObjectDefItem(RiceAID, "UnderbrushCoastalJapan", rmRandInt(1,1), 1.0); 
			rmSetObjectDefMinDistance(RiceAID, 0);
			rmSetObjectDefMaxDistance(RiceAID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint(RiceAID, avoidImpassableLandMin);
			rmAddObjectDefConstraint(RiceAID, stayInHillA1stlvl);
			rmPlaceObjectDefAtLoc(RiceAID, 0, 0.50, 0.50);
		}
		*/
		rmCreateAreaDistanceConstraint("avoid hill A "+i, hillAID, 2.0);
		rmCreateAreaMaxDistanceConstraint("stay in hill A "+i, hillAID, 0.0);
		rmCreateAreaMaxDistanceConstraint("stay near hill A "+i, hillAID, 11.0);
	}
	
	int avoidHillA = rmConstraintID("avoid hill A 1");
	int stayInHillA = rmConstraintID("stay in hill A 1");
	int stayNearHillA = rmConstraintID("stay near hill A 1");
	
	
	//Hill B
	for (i=0; < 3)
	{
		int hillBID = rmCreateArea("hill B"+i);
		if (i == 0)
		{
			rmSetAreaSize(hillBID, 0.017, 0.017);
			rmSetAreaCoherence(hillBID, 0.70);
		//	rmSetAreaCliffHeight(hillBID, 2.8, 0.0, 0.8); 
		//	rmSetAreaCliffEdge(hillBID, 1, 1.0, 0.0, 0.0, 1); 
		//	rmSetAreaCliffType(hillBID, "coastal japan"); 
		//	rmSetAreaTerrainType(hillBID, "borneo\ground_grass1_borneo");
		//	rmPaintAreaTerrain(hillBID);	
		//	rmSetAreaCliffPainting(hillBID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		//	rmAddAreaConstraint(hillBID, avoidWater);
			int stayInHillB1stlvl = rmCreateAreaMaxDistanceConstraint("stay in hill B first level", hillBID, 0.0);

		}
		else if(i == 1)
		{
			rmSetAreaSize(hillBID, 0.011, 0.011);
			rmSetAreaCoherence(hillBID, 0.55);
			rmSetAreaCliffHeight(hillBID, 4.0, 0.0, 0.4); 
			rmSetAreaCliffEdge(hillBID, 1, 0.55, 0.0, 0.0, 1); 
			rmSetAreaCliffType(hillBID, "coastal japan"); 
		//	rmSetAreaTerrainType(hillBID, "borneo\ground_grass1_borneo");	
			rmSetAreaCliffPainting(hillBID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
			rmAddAreaConstraint(hillBID, avoidImpassableLandShort);
			int stayInHillB2ndlvl = rmCreateAreaMaxDistanceConstraint("stay in hill B second level", hillBID, 0.0);
			rmAddAreaConstraint(hillBID, stayInHillB1stlvl);
		}
		/*
		else
		{
			rmSetAreaSize(hillBID, 0.018, 0.018);
			rmSetAreaCoherence(hillBID, 0.60);
			rmSetAreaCliffHeight(hillBID, 2.5, 0.0, 0.8); 
			rmSetAreaCliffEdge(hillBID, 1, 1.0, 0.0, 0.0, 1); 
			rmSetAreaCliffType(hillBID, "coastal japan"); 
			rmSetAreaTerrainType(hillBID, "coastal_japan\ground_forest_co_japan");	
			rmSetAreaCliffPainting(hillBID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
			rmAddAreaConstraint(hillBID, avoidImpassableLandShort);
			rmAddAreaConstraint(hillBID, stayInHillB2ndlvl);
		}
		*/
		rmSetAreaWarnFailure(hillBID, false);
		rmSetAreaObeyWorldCircleConstraint(hillBID, false);
		
		rmSetAreaSmoothDistance(hillBID, 9);
		rmAddAreaToClass(hillBID, rmClassID("Cliffs"));
		if (playerplacement == 1)
			rmSetAreaLocation(hillBID, 0.56, 0.38);
		else 
			rmSetAreaLocation(hillBID, 0.64, 0.46);
		if (cNumberTeams <= 2)
			rmBuildArea(hillBID);
		/*
		for (j=0; < 350)
		{
			int RiceBID = rmCreateObjectDef("riceB"+i+j);
			rmAddObjectDefItem(RiceBID, "UnderbrushCoastalJapan", rmRandInt(1,1), 1.0); 
			rmSetObjectDefMinDistance(RiceBID, 0);
			rmSetObjectDefMaxDistance(RiceBID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint(RiceBID, avoidImpassableLandMin);
			rmAddObjectDefConstraint(RiceBID, stayInHillB1stlvl);
			rmPlaceObjectDefAtLoc(RiceBID, 0, 0.50, 0.50);
		}
		*/
		rmCreateAreaDistanceConstraint("avoid hill B "+i, hillBID, 1.0);
		rmCreateAreaMaxDistanceConstraint("stay in hill B "+i, hillBID, 0.0);
		rmCreateAreaMaxDistanceConstraint("stay near hill B "+i, hillBID, 11.0);
	}
	
	int avoidHillB = rmConstraintID("avoid hill B 1");
	int stayInHillB = rmConstraintID("stay in hill B 1");
	int stayNearHillB = rmConstraintID("stay near hill B 1");

	
	//Big islands
	for (i=1; <3)
	{
	int bigislandID = rmCreateArea("big island"+i);
	rmSetAreaSize(bigislandID, 0.05, 0.06);
	if (i == 1)
	{
		if (playerplacement == 1)
			rmSetAreaLocation(bigislandID, rmRandFloat(0.92,0.95), rmRandFloat(0.82,0.85));
		else
			rmSetAreaLocation(bigislandID, rmRandFloat(0.82,0.85), rmRandFloat(0.92,0.95));
	}
	else
	{
		if (playerplacement == 1)
			rmSetAreaLocation(bigislandID,rmRandFloat(0.05,0.08), rmRandFloat(0.15,0.18));
		else
			rmSetAreaLocation(bigislandID,rmRandFloat(0.15,0.18), rmRandFloat(0.05,0.08));
	}
	rmAddAreaInfluenceSegment(bigislandID, 0.42, 0.58, 0.58, 0.42);
	rmSetAreaMix(bigislandID, "coastal_japan_b");
	rmSetAreaTerrainType(bigislandID, "coastal_japan\ground_forest_co_japan"); 
	rmPaintAreaTerrain(bigislandID);
	rmAddAreaTerrainLayer(bigislandID, "coastal_japan\ground_dirt1_co_japan", 0, 2);
	rmAddAreaTerrainLayer(bigislandID, "coastal_japan\ground_dirt3_co_japan", 2, 4);
	rmAddAreaTerrainLayer(bigislandID, "coastal_japan\ground_dirt2_co_japan", 4, 6);
	rmAddAreaTerrainLayer(bigislandID, "coastal_japan\ground_grass3_co_japan", 6, 8);
	rmAddAreaTerrainLayer(bigislandID, "coastal_japan\ground_grass3_co_japan", 8, 10);
	rmAddAreaTerrainLayer(bigislandID, "coastal_japan\ground_grass2_co_japan", 10, 12);
	rmAddAreaTerrainLayer(bigislandID, "coastal_japan\ground_grass1_co_japan", 12, 14);
	rmSetAreaWarnFailure(bigislandID, false);
	rmAddAreaToClass(bigislandID, classIsland);
	rmSetAreaMinBlobs(bigislandID, 2);
	rmSetAreaMaxBlobs(bigislandID, 2);
	rmSetAreaMinBlobDistance(bigislandID, 18.0);
	rmSetAreaMaxBlobDistance(bigislandID, 23.0);
	rmSetAreaCoherence(bigislandID, 0.55); //.46
	rmSetAreaSmoothDistance(bigislandID, 12);
	rmSetAreaElevationType(bigislandID, cElevTurbulence);
	rmSetAreaElevationVariation(bigislandID, 5.0);
	rmSetAreaBaseHeight(bigislandID, 4.0);
	rmSetAreaElevationMinFrequency(bigislandID, 0.04);
	rmSetAreaElevationOctaves(bigislandID, 3);
	rmSetAreaElevationPersistence(bigislandID, 0.4); 
	rmAddAreaConstraint(bigislandID, avoidMainIsland);
	rmBuildArea(bigislandID);
	rmCreateAreaDistanceConstraint("avoid big island "+i, bigislandID, 5.0);
	rmCreateAreaMaxDistanceConstraint("stay in big island "+i, bigislandID, 0.0);
	}
	
	int avoidBigIsland1 = rmConstraintID("avoid big island 1");
	int avoidBigIsland2 = rmConstraintID("avoid big island 2");
	int stayInBigIsland1 = rmConstraintID("stay in big island 1");
	int stayInBigIsland2 = rmConstraintID("stay in big island 2");


	//Small islands
	for (i=1; <3)
	{
	int smallislandID = rmCreateArea("snall island"+i);
	rmSetAreaSize(smallislandID, 0.008, 0.010);
	if (i == 1)
	{
		if (playerplacement == 1)
			rmSetAreaLocation(smallislandID, 0.52, 0.87);
		else
			rmSetAreaLocation(smallislandID, 0.87, 0.52);
	}
	else
	{
		if (playerplacement == 1)
			rmSetAreaLocation(smallislandID, 0.52, 0.13);
		else
			rmSetAreaLocation(smallislandID, 0.13, 0.52);
	}
	rmAddAreaInfluenceSegment(smallislandID, 0.42, 0.58, 0.58, 0.42);
	rmSetAreaMix(smallislandID, "coastal_japan_b");
	rmSetAreaTerrainType(smallislandID, "borneo\ground_forest_borneo"); 
	rmPaintAreaTerrain(smallislandID);
	rmAddAreaTerrainLayer(smallislandID, "coastal_japan\ground_dirt1_co_japan", 0, 2);
	rmAddAreaTerrainLayer(smallislandID, "coastal_japan\ground_dirt3_co_japan", 2, 4);
	rmAddAreaTerrainLayer(smallislandID, "coastal_japan\ground_dirt2_co_japan", 4, 6);
	rmAddAreaTerrainLayer(smallislandID, "coastal_japan\ground_grass3_co_japan", 6, 8);
	rmAddAreaTerrainLayer(smallislandID, "coastal_japan\ground_grass3_co_japan", 8, 10);
	rmAddAreaTerrainLayer(smallislandID, "coastal_japan\ground_grass2_co_japan", 10, 12);
	rmAddAreaTerrainLayer(smallislandID, "coastal_japan\ground_grass1_co_japan", 12, 14);
	rmSetAreaWarnFailure(smallislandID, false);
	rmAddAreaToClass(smallislandID, classIsland);
	rmSetAreaMinBlobs(smallislandID, 2);
	rmSetAreaMaxBlobs(smallislandID, 2);
	rmSetAreaMinBlobDistance(smallislandID, 8.0);
	rmSetAreaMaxBlobDistance(smallislandID, 13.0);
	rmSetAreaCoherence(smallislandID, 0.45); //.46
	rmSetAreaSmoothDistance(smallislandID, 5);
	rmSetAreaElevationType(smallislandID, cElevTurbulence);
	rmSetAreaElevationVariation(smallislandID, 5.0);
	rmSetAreaBaseHeight(smallislandID, 4.0);
	rmSetAreaElevationMinFrequency(smallislandID, 0.04);
	rmSetAreaElevationOctaves(smallislandID, 3);
	rmSetAreaElevationPersistence(smallislandID, 0.4);    
	rmAddAreaConstraint(smallislandID, avoidMainIsland);
	rmBuildArea(smallislandID);
	rmCreateAreaDistanceConstraint("avoid small island "+i, smallislandID, 5.0);
	rmCreateAreaMaxDistanceConstraint("stay in small island "+i, smallislandID, 0.0);
	}
	
	int avoidSmallIsland1 = rmConstraintID("avoid small island 1");
	int avoidSmallIsland2 = rmConstraintID("avoid small island 2");
	int stayInSmallIsland1 = rmConstraintID("stay in small island 1");
	int stayInSmallIsland2 = rmConstraintID("stay in small island 2");
	
	// *********************************************************************************************************
	
	// Text
	rmSetStatusText("",0.40);
	
	// ******************************************** NATIVES *************************************************
	
	int natAreaA = rmCreateArea("nats area A");
	rmSetAreaWarnFailure(natAreaA, false);
	rmSetAreaSize(natAreaA, 0.03, 0.03);
	rmSetAreaCoherence(natAreaA, 0.7);
	rmSetAreaSmoothDistance(natAreaA, 4);
//	rmSetAreaTerrainType(natAreaA, "new_england\ground2_cliff_ne");
	
	int natAreaB = rmCreateArea("nats area B");
	rmSetAreaWarnFailure(natAreaB, false);
	rmSetAreaSize(natAreaB, 0.03, 0.03);
	rmSetAreaCoherence(natAreaB, 0.7);
	rmSetAreaSmoothDistance(natAreaB, 4);
//	rmSetAreaTerrainType(natAreaB, "new_england\ground2_cliff_ne");
	
	
	int nativeID0 = -1;
	int nativeID1 = -1;
	int nativeID2 = -1;
	int nativeID3 = -1;
  
	
		nativeID0 = rmCreateGrouping("Jesuit mission A", "native jesuit mission borneo 0"+4);
		nativeID1 = rmCreateGrouping("Jesuit mission B", "native jesuit mission borneo 0"+3);
	
		nativeID2 = rmCreateGrouping("Sufi mosque A", "native zen temple cj 0"+3);
		nativeID3 = rmCreateGrouping("Sufi mosque B", "native zen temple cj 0"+3);
	
//	rmSetGroupingMinDistance(nativeID0, 0.00);
//	rmSetGroupingMaxDistance(nativeID0, 0.00);
//	rmSetGroupingMinDistance(nativeID1, 0.00);
//	rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));
	if (playerplacement == 1)
	{
		if (cNumberNonGaiaPlayers < 4)
		{
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.34, 0.70);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.66, 0.30);
			rmSetAreaLocation(natAreaA, 0.34, 0.70);
			rmSetAreaLocation(natAreaB, 0.66, 0.30);
		}
		else
		{
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.36, 0.72);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.64, 0.28);
			rmSetAreaLocation(natAreaA, 0.36, 0.72);
			rmSetAreaLocation(natAreaB, 0.64, 0.28);
		}
	}
	else
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.30, 0.66);
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.70, 0.34);
		rmSetAreaLocation(natAreaA, 0.30, 0.66);
		rmSetAreaLocation(natAreaB, 0.70, 0.34);
	}
	
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.62, 0.62);
	rmPlaceGroupingAtLoc(nativeID3, 0, 0.40, 0.40);
	
	rmBuildArea(natAreaA);
	rmBuildArea(natAreaB);
	
	int stayInNatAreaA = rmCreateAreaMaxDistanceConstraint("stay in nat area A", natAreaA, 0.0);
	int stayInNatAreaB = rmCreateAreaMaxDistanceConstraint("stay in nat area B", natAreaB, 0.0);
	int avoidNatAreaA = rmCreateAreaDistanceConstraint("avoid nat area A", natAreaA, 2.0);
	int avoidNatAreaB = rmCreateAreaDistanceConstraint("avoid nat area B", natAreaB, 2.0);
		
	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.50);
	
	// ************************************ PLAYER STARTING RESOURCES ***************************************

	// ******** Define ********

	// Town center & units
	int TCID = rmCreateObjectDef("player TC");
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 8.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
	rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	rmAddObjectDefToClass(TCID, classStartingResource);
	}
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 0.0);
	
	//Extra coin crates
	int playerCrateID = rmCreateObjectDef("extra crates");
	rmAddObjectDefItem(playerCrateID, "crateOfCoin", rmRandInt(1,2), 3.0);
	rmSetObjectDefMinDistance(playerCrateID, 6);
	rmSetObjectDefMaxDistance(playerCrateID, 10);
	
	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "minecopper", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 16);
	rmSetObjectDefMaxDistance(playergoldID, 18);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
//	rmAddObjectDefConstraint(playergoldID, avoidEdge);
		
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "ypTreeIndo", rmRandInt(10,10), 7.0);
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
//	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 2, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 12.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// Starting herd
	int playeherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playeherdID, "ypIbex", rmRandInt(2,2), 4.0);
	rmSetObjectDefMinDistance(playeherdID, 14.0);
	rmSetObjectDefMaxDistance(playeherdID, 16.0);
	rmSetObjectDefCreateHerd(playeherdID, true);
	rmAddObjectDefToClass(playeherdID, classStartingResource);
//	rmAddObjectDefConstraint(playeherdID, avoidTradeRoute);
//	rmAddObjectDefConstraint(playeherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playeherdID, avoidNatives);
	rmAddObjectDefConstraint(playeherdID, avoidStartingResources);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "ypserow", rmRandInt(8,8), 6.0);
    rmSetObjectDefMinDistance(player2ndherdID, 34);
    rmSetObjectDefMaxDistance(player2ndherdID, 36);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player2ndherdID, avoidEleShort); 
//	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteShort);
//	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteSocket);
//	rmAddObjectDefConstraint(player2ndherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdge);
	rmAddObjectDefConstraint(player2ndherdID, avoidNativesShort);
	
	//Extra building
	int playerSaloonID=rmCreateObjectDef("player saloon");
	rmAddObjectDefItem(playerSaloonID, "ypTreeIndo", 1, 0.0);
	rmSetObjectDefMinDistance(playerSaloonID, 12.0);
	rmSetObjectDefMaxDistance(playerSaloonID, 16.0);
	rmAddObjectDefConstraint(playerSaloonID, avoidStartingResources);
	rmAddObjectDefConstraint(playerSaloonID, avoidImpassableLand);
  
	int playerFirepitID=rmCreateObjectDef("player firepit");
	rmAddObjectDefItem(playerFirepitID, "ypTreeIndo", 1, 0.0);
	rmSetObjectDefMinDistance(playerFirepitID, 12.0);
	rmSetObjectDefMaxDistance(playerFirepitID, 16.0);
	rmAddObjectDefConstraint(playerFirepitID, avoidStartingResources);
	rmAddObjectDefConstraint(playerFirepitID, avoidImpassableLand);
  
	int playerMonID=rmCreateObjectDef("player monastery");
	rmAddObjectDefItem(playerMonID, "ypTreeIndo", 1, 0.0);
	rmSetObjectDefMinDistance(playerMonID, 12.0);
	rmSetObjectDefMaxDistance(playerMonID, 16.0);
	rmAddObjectDefConstraint(playerMonID, avoidStartingResources);
	rmAddObjectDefConstraint(playerMonID, avoidImpassableLand);
		

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 18.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
//	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget); //Short
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2); // 1,2
	
	//Colony water shipment flag
	int shipmentflagID = rmCreateObjectDef("colony ship");
	 rmAddObjectDefItem(shipmentflagID, "HomeCityWaterSpawnFlag", 1, 1.0);
	rmSetObjectDefMinDistance(shipmentflagID, 0.0);
	rmSetObjectDefMaxDistance(shipmentflagID, rmXFractionToMeters(0.12));
	rmAddObjectDefConstraint(shipmentflagID, avoidFlag);
	rmAddObjectDefConstraint(shipmentflagID, avoidLand);
	rmAddObjectDefConstraint(shipmentflagID, avoidEdgeMore);
//  rmSetHomeCityWaterSpawnPoint(i, flagLocation);

	// Catamaran 
	int catamaranID=rmCreateObjectDef("Catamaran");
    rmAddObjectDefItem(catamaranID, "ypMarathanCatamaran", 1, 3.0);
 	
		
	// ******** Place ********
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(shipmentflagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
		vector flagLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(shipmentflagID, i));
		rmPlaceObjectDefAtLoc(catamaranID, i, rmXMetersToFraction(xsVectorGetX(flagLocation)), rmZMetersToFraction(xsVectorGetZ(flagLocation)));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerCrateID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playeherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (rmGetNomadStart() == false) 
		{
			if 	(rmGetPlayerCiv(i) == rmGetCivID("Chinese") || rmGetPlayerCiv(i) == rmGetCivID("Japanese") || rmGetPlayerCiv(i) == rmGetCivID("Indians")) 
			{
				rmPlaceObjectDefAtLoc(playerMonID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			}
			else if (rmGetPlayerCiv(i) ==  rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) ==  rmGetCivID("XPSioux") || rmGetPlayerCiv(i) ==  rmGetCivID("XPAztec"))
			{
				rmPlaceObjectDefAtLoc(playerFirepitID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			}
			else
			{
				rmPlaceObjectDefAtLoc(playerSaloonID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			}
		}
		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		if (nugget0count == 2)
//			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));		
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	}

	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ************************************** COMMON RESOURCES ****************************************
  
   
	// ************* Mines **************
	
	int goldcount = 1+0.5*cNumberNonGaiaPlayers;  
	
	int coppercount = 2+1*cNumberNonGaiaPlayers;
	
	// Gold mines
	for(i=0; < goldcount)
	{
		int commongoldID = rmCreateObjectDef("common gold mines"+i);
		rmAddObjectDefItem(commongoldID, "Minegold", 1, 0.0);
		rmSetObjectDefMinDistance(commongoldID, rmXFractionToMeters(0.04));
		if (cNumberTeams <= 2)
			rmSetObjectDefMaxDistance(commongoldID, rmXFractionToMeters(0.18));
		else
			rmSetObjectDefMaxDistance(commongoldID, rmXFractionToMeters(0.12));
		rmAddObjectDefToClass(commongoldID, classGold);
//		rmAddObjectDefConstraint(commongoldID, avoidTradeRoute);
//		rmAddObjectDefConstraint(commongoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(commongoldID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(commongoldID, avoidNatAreaA);
		rmAddObjectDefConstraint(commongoldID, avoidNatAreaB);
		rmAddObjectDefConstraint(commongoldID, avoidGold);
		rmAddObjectDefConstraint(commongoldID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(commongoldID, avoidEdge);
		rmAddObjectDefConstraint(commongoldID, avoidCliff);
		if (cNumberTeams <= 2)
		{
			if (i < goldcount/2)
				rmAddObjectDefConstraint(commongoldID, stayNearHillA);
			else
				rmAddObjectDefConstraint(commongoldID, stayNearHillB);
		}	
		rmPlaceObjectDefAtLoc(commongoldID, 0, 0.50, 0.50);
	}
	
	
	// Copper mines
	for(i=0; < coppercount)
	{
		int commoncopperID = rmCreateObjectDef("common copper mines"+i);
		rmAddObjectDefItem(commoncopperID, "Minecopper", 1, 0.0);
		rmSetObjectDefMinDistance(commoncopperID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(commoncopperID, rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(commoncopperID, classGold);
//		rmAddObjectDefConstraint(commoncopperID, avoidTradeRoute);
//		rmAddObjectDefConstraint(commoncopperID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(commoncopperID, avoidImpassableLand);
		rmAddObjectDefConstraint(commoncopperID, avoidNatives);
		rmAddObjectDefConstraint(commoncopperID, avoidGoldFar);
		rmAddObjectDefConstraint(commoncopperID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(commoncopperID, avoidEdge);
		rmAddObjectDefConstraint(commoncopperID, avoidCliff);
		if (i < 6)
		{
			rmAddObjectDefConstraint(commoncopperID, avoidSmallIsland1);
			rmAddObjectDefConstraint(commoncopperID, avoidSmallIsland2);
		}
		if (cNumberTeams <= 2)
		{
			if (i == 0)
				rmAddObjectDefConstraint(commoncopperID, stayInBigIsland1);	
			else if (i == 1)
				rmAddObjectDefConstraint(commoncopperID, stayInBigIsland2);
			else if (i == 6)
				rmAddObjectDefConstraint(commoncopperID, stayInSmallIsland1);
			else if (i == 7)
				rmAddObjectDefConstraint(commoncopperID, stayInSmallIsland2);
			else if (i%2 == 1)
				rmAddObjectDefConstraint(commoncopperID, stayInNatAreaA);
			else 
				rmAddObjectDefConstraint(commoncopperID, stayInNatAreaB);
		}	
		else
		{
			if (i == 0)
					rmAddObjectDefConstraint(commoncopperID, stayInBigIsland1);	
			else if (i == 1)
					rmAddObjectDefConstraint(commoncopperID, stayInBigIsland2);			
			else if (i == 6)
					rmAddObjectDefConstraint(commoncopperID, stayInSmallIsland1);
			else if (i == 7)
					rmAddObjectDefConstraint(commoncopperID, stayInSmallIsland2);		
		}
		rmPlaceObjectDefAtLoc(commoncopperID, 0, 0.50, 0.50);
	}
		
	// *********************************
	
	// Text
	rmSetStatusText("",0.70);
	
	// ************ Forest *************

	// Inland forest
	int forestinlandcount = 4+2*cNumberNonGaiaPlayers; //12
	int stayInForestInlandPatch = -1;
	
	for (i=0; < forestinlandcount)
	{
		int forestinlandID = rmCreateArea("forest inland "+i);
		rmSetAreaWarnFailure(forestinlandID, false);
		rmSetAreaSize(forestinlandID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(220)); // 130 150
		rmSetAreaTerrainType(forestinlandID, "coastal_japan\ground_forest_co_japan"); 
		rmSetAreaObeyWorldCircleConstraint(forestinlandID, false);
//		rmSetAreaForestType(forestinlandID, "borneo forest");
//		rmSetAreaForestDensity(forestinlandID, 0.8);
//		rmSetAreaForestClumpiness(forestinlandID, 0.15);
//		rmSetAreaForestUnderbrush(forestinlandID, 0.2);
		rmSetAreaMinBlobs(forestinlandID, 2);
		rmSetAreaMaxBlobs(forestinlandID, 4);
		rmSetAreaMinBlobDistance(forestinlandID, 12.0);
		rmSetAreaMaxBlobDistance(forestinlandID, 30.0);
		rmSetAreaCoherence(forestinlandID, 0.55);
		rmSetAreaSmoothDistance(forestinlandID, 6);
		rmAddAreaToClass(forestinlandID, classForest);
		rmAddAreaConstraint(forestinlandID, avoidForest);
		rmAddAreaConstraint(forestinlandID, avoidGoldMin);
		rmAddAreaConstraint(forestinlandID, avoidEleMin); 
		rmAddAreaConstraint(forestinlandID, avoidSerowMin); 
		rmAddAreaConstraint(forestinlandID, avoidTownCenter); 
		rmAddAreaConstraint(forestinlandID, avoidNativesShort);
//		rmAddAreaConstraint(forestinlandID, avoidTradeRouteShort);
//		rmAddAreaConstraint(forestinlandID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestinlandID, avoidImpassableLandFar);
//		rmAddAreaConstraint(forestinlandID, avoidCliff);
//		rmAddAreaConstraint(forestinlandID, avoidEdge);
		rmAddAreaConstraint(forestinlandID, avoidSmallIsland1);
		rmAddAreaConstraint(forestinlandID, avoidSmallIsland2);
		rmBuildArea(forestinlandID);
		
		stayInForestInlandPatch = rmCreateAreaMaxDistanceConstraint("stay in forest inland patch"+i, forestinlandID, 0.0);
		
		for (j=0; < rmRandInt(18,22))
		{
			int forestinlandtreeID = rmCreateObjectDef("forest inland trees"+i+j);
			rmAddObjectDefItem(forestinlandtreeID, "ypTreeIndo", rmRandInt(1,2), 3.0);
			rmSetObjectDefMinDistance(forestinlandtreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(forestinlandtreeID,  rmXFractionToMeters(0.5));
		//	rmAddObjectDefToClass(forestinlandtreeID, classForest);
		//	rmAddObjectDefConstraint(forestinlandtreeID, avoidForestShort);
//			rmAddObjectDefConstraint(forestinlandtreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(forestinlandtreeID, stayInForestInlandPatch);	
			rmPlaceObjectDefAtLoc(forestinlandtreeID, 0, 0.50, 0.50);
		}
	}
	

	// Central forest
	int forestcentralcount = 2+1*cNumberNonGaiaPlayers; //4
	int stayInForestCentralPatch = -1;
	
	for (i=0; < forestcentralcount)
	{
		int forestcentralID = rmCreateArea("forest central "+i);
		rmSetAreaWarnFailure(forestcentralID, false);
		rmSetAreaSize(forestcentralID, rmAreaTilesToFraction(180), rmAreaTilesToFraction(200)); // 130 150
		rmSetAreaTerrainType(forestcentralID, "coastal_japan\ground_forest_co_japan"); 
		rmSetAreaObeyWorldCircleConstraint(forestcentralID, false);
//		rmSetAreaForestType(forestcentralID, "borneo forest");
//		rmSetAreaForestDensity(forestcentralID, 0.8);
//		rmSetAreaForestClumpiness(forestcentralID, 0.15);
//		rmSetAreaForestUnderbrush(forestcentralID, 0.2);
		rmSetAreaMinBlobs(forestcentralID, 2);
		rmSetAreaMaxBlobs(forestcentralID, 4);
		rmSetAreaMinBlobDistance(forestcentralID, 12.0);
		rmSetAreaMaxBlobDistance(forestcentralID, 30.0);
		rmSetAreaCoherence(forestcentralID, 0.55);
		rmSetAreaSmoothDistance(forestcentralID, 6);
		rmAddAreaToClass(forestcentralID, classForest);
		rmAddAreaConstraint(forestcentralID, avoidForestShort);
		rmAddAreaConstraint(forestcentralID, avoidGoldMin);
		rmAddAreaConstraint(forestcentralID, avoidEleMin); 
		rmAddAreaConstraint(forestcentralID, avoidSerowMin); 
		rmAddAreaConstraint(forestcentralID, avoidTownCenter); 
		rmAddAreaConstraint(forestcentralID, avoidNativesShort);
//		rmAddAreaConstraint(forestcentralID, avoidTradeRouteShort);
//		rmAddAreaConstraint(forestcentralID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestcentralID, avoidImpassableLandShort);
//		rmAddAreaConstraint(forestcentralID, avoidCliff);
		rmAddAreaConstraint(forestcentralID, stayCenter);
		rmAddAreaConstraint(forestcentralID, avoidSmallIsland1);
		rmAddAreaConstraint(forestcentralID, avoidSmallIsland2);
		rmBuildArea(forestcentralID);
		
		stayInForestCentralPatch = rmCreateAreaMaxDistanceConstraint("stay in forest central patch"+i, forestcentralID, 0.0);
		
		for (j=0; < rmRandInt(16,18))
		{
			int forestcentraltreeID = rmCreateObjectDef("forest central trees"+i+j);
			rmAddObjectDefItem(forestcentraltreeID, "ypTreeIndo", rmRandInt(1,2), 3.0);
			rmSetObjectDefMinDistance(forestcentraltreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(forestcentraltreeID,  rmXFractionToMeters(0.5));
		//	rmAddObjectDefToClass(forestcentraltreeID, classForest);
		//	rmAddObjectDefConstraint(forestcentraltreeID, avoidForestShort);
//			rmAddObjectDefConstraint(forestcentraltreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(forestcentraltreeID, stayInForestCentralPatch);	
			rmPlaceObjectDefAtLoc(forestcentraltreeID, 0, 0.50, 0.50);
		}
	}
	
	// Coastal forest
	int forestcoastalcount = 4+2*cNumberNonGaiaPlayers; //12
	int stayInForestCoastalPatch = -1;
	
	for (i=0; < forestcoastalcount)
	{
		int forestcoastalID = rmCreateArea("forest coastal "+i);
		rmSetAreaWarnFailure(forestcoastalID, false);
		rmSetAreaSize(forestcoastalID, rmAreaTilesToFraction(180), rmAreaTilesToFraction(200)); // 130 150
//		rmSetAreaTerrainType(forestcoastalID, "coastal_japan\ground_forest_co_japan"); 
		rmSetAreaObeyWorldCircleConstraint(forestcoastalID, false);
//		rmSetAreaForestType(forestcoastalID, "borneo forest");
//		rmSetAreaForestDensity(forestcoastalID, 0.8);
//		rmSetAreaForestClumpiness(forestcoastalID, 0.15);
//		rmSetAreaForestUnderbrush(forestcoastalID, 0.2);
		rmSetAreaMinBlobs(forestcoastalID, 2);
		rmSetAreaMaxBlobs(forestcoastalID, 4);
		rmSetAreaMinBlobDistance(forestcoastalID, 12.0);
		rmSetAreaMaxBlobDistance(forestcoastalID, 30.0);
		rmSetAreaCoherence(forestcoastalID, 0.55);
		rmSetAreaSmoothDistance(forestcoastalID, 6);
		rmAddAreaToClass(forestcoastalID, classForest);
		rmAddAreaConstraint(forestcoastalID, avoidForestShort);
		rmAddAreaConstraint(forestcoastalID, avoidGoldMin);
		rmAddAreaConstraint(forestcoastalID, avoidEleMin); 
		rmAddAreaConstraint(forestcoastalID, avoidSerowMin); 
		rmAddAreaConstraint(forestcoastalID, avoidTownCenterShort); 
		rmAddAreaConstraint(forestcoastalID, avoidNativesShort);
//		rmAddAreaConstraint(forestcoastalID, avoidTradeRouteShort);
//		rmAddAreaConstraint(forestcoastalID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestcoastalID, avoidImpassableLandShort);
		rmAddAreaConstraint(forestcoastalID, avoidCliff);
//		rmAddAreaConstraint(forestcoastalID, avoidEdge);
		rmAddAreaConstraint(forestcoastalID, avoidCenter);
		rmAddAreaConstraint(forestcoastalID, avoidSmallIsland1);
		rmAddAreaConstraint(forestcoastalID, avoidSmallIsland2);
		rmBuildArea(forestcoastalID);
		
		stayInForestCoastalPatch = rmCreateAreaMaxDistanceConstraint("stay in forest coastal patch"+i, forestcoastalID, 0.0);
		
		for (j=0; < rmRandInt(14,16))
		{
			int forestcoastaltreeID = rmCreateObjectDef("forest coastal trees"+i+j);
			rmAddObjectDefItem(forestcoastaltreeID, "ypTreeIndo", rmRandInt(1,2), 3.0);
			rmSetObjectDefMinDistance(forestcoastaltreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(forestcoastaltreeID,  rmXFractionToMeters(0.5));
		//	rmAddObjectDefToClass(forestcoastaltreeID, classForest);
		//	rmAddObjectDefConstraint(forestcoastaltreeID, avoidForestShort);
//			rmAddObjectDefConstraint(forestcoastaltreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(forestcoastaltreeID, stayInForestCoastalPatch);	
			rmPlaceObjectDefAtLoc(forestcoastaltreeID, 0, 0.50, 0.50);
		}
	}
	
	
	// Random  trees 
	for (i=0; < 8+2*cNumberNonGaiaPlayers)
	{
		int randominlandtreeID = rmCreateObjectDef("random trees inland "+i);
		if (i < 8)
			rmAddObjectDefItem(randominlandtreeID, "ypTreeIndo", rmRandInt(2,3), 5.0);
		else
			rmAddObjectDefItem(randominlandtreeID, "ypTreeIndo", rmRandInt(2,3), 5.0);
		rmSetObjectDefMinDistance(randominlandtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randominlandtreeID,  rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randominlandtreeID, classForest);
		if (i < 8)
		rmAddObjectDefConstraint(randominlandtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randominlandtreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randominlandtreeID, avoidSerowMin); 
		rmAddObjectDefConstraint(randominlandtreeID, avoidEleMin); 
		rmAddObjectDefConstraint(randominlandtreeID, avoidTownCenterShort); 
		rmAddObjectDefConstraint(randominlandtreeID, avoidNativesShort);
//		rmAddObjectDefConstraint(randominlandtreeID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(randominlandtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randominlandtreeID, avoidStartingResources);
		if (i < 8)
			rmAddObjectDefConstraint(randominlandtreeID, avoidImpassableLandFar);
		else
			rmAddObjectDefConstraint(randominlandtreeID, avoidImpassableLandShort);
		if (i < 8)
		{
			rmAddObjectDefConstraint(randominlandtreeID, avoidSmallIsland1);
			rmAddObjectDefConstraint(randominlandtreeID, avoidSmallIsland2);
			rmAddObjectDefConstraint(randominlandtreeID, avoidBigIsland1);
			rmAddObjectDefConstraint(randominlandtreeID, avoidBigIsland2);
		}
		else if (i < 10)
			rmAddObjectDefConstraint(randominlandtreeID, stayInBigIsland1);
		else if (i < 12)
			rmAddObjectDefConstraint(randominlandtreeID, stayInBigIsland2);
		else if (i < 14)
			rmAddObjectDefConstraint(randominlandtreeID, stayInSmallIsland1);
		else
			rmAddObjectDefConstraint(randominlandtreeID, stayInSmallIsland2);
		rmPlaceObjectDefAtLoc(randominlandtreeID, 0, 0.50, 0.50);
	}
	
	// Middle  trees 
	for (i=0; < 2+1*cNumberNonGaiaPlayers)
	{
		int middletreeID = rmCreateObjectDef("middle trees "+i);
		rmAddObjectDefItem(middletreeID, "ypTreeIndo", rmRandInt(5,8), 8.0);
		rmSetObjectDefMinDistance(middletreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(middletreeID,  rmXFractionToMeters(0.05));
		rmAddObjectDefToClass(middletreeID, classForest);
		rmAddObjectDefConstraint(middletreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(middletreeID, avoidForestVeryShort);
		rmAddObjectDefConstraint(middletreeID, avoidGoldMin);
		rmAddObjectDefConstraint(middletreeID, avoidSerowMin); 
		rmAddObjectDefConstraint(middletreeID, avoidEleMin); 
		rmAddObjectDefConstraint(middletreeID, avoidTownCenterShort); 
		rmAddObjectDefConstraint(middletreeID, avoidNativesShort);
	rmPlaceObjectDefAtLoc(middletreeID, 0, 0.50, 0.50);
	}
	
		
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ************ Herds *************
	
	int serowherdcount = 5+2*cNumberNonGaiaPlayers;
		
	//Serow herds
	for (i=0; < serowherdcount)
	{
		int serowherdID = rmCreateObjectDef("serow herd"+i);
		rmAddObjectDefItem(serowherdID, "ypserow", rmRandInt(8,8), 6.0);
		rmSetObjectDefMinDistance(serowherdID, 0.0);
		rmSetObjectDefMaxDistance(serowherdID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(serowherdID, true);
		rmAddObjectDefConstraint(serowherdID, avoidForestMin);
		rmAddObjectDefConstraint(serowherdID, avoidGoldShort);
		rmAddObjectDefConstraint(serowherdID, avoidSerowFar); 
		rmAddObjectDefConstraint(serowherdID, avoidEleFar); 
		rmAddObjectDefConstraint(serowherdID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(serowherdID, avoidNativesShort);
//		rmAddObjectDefConstraint(serowherdID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(serowherdID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(serowherdID, avoidImpassableLandShort);
		if (i > 1)
		{
		rmAddObjectDefConstraint(serowherdID, avoidBigIsland1);
		rmAddObjectDefConstraint(serowherdID, avoidBigIsland2);
		}
		else if (i == 0)
			rmAddObjectDefConstraint(serowherdID, stayInBigIsland1);
		else
			rmAddObjectDefConstraint(serowherdID, stayInBigIsland2);
		rmAddObjectDefConstraint(serowherdID, avoidSmallIsland1);
		rmAddObjectDefConstraint(serowherdID, avoidSmallIsland2);
		rmAddObjectDefConstraint(serowherdID, avoidEdge);
		rmPlaceObjectDefAtLoc(serowherdID, 0, 0.50, 0.50);	
	}

	// ************************************
	
	// ************ Berries *************
	
	int berriescount = 4+2*cNumberNonGaiaPlayers;
		
	//Berries
	for (i=0; < berriescount)
	{
		int berriesID = rmCreateObjectDef("berries"+i);
		rmAddObjectDefItem(berriesID, "berrybush", rmRandInt(3,3), 4.0);
		rmSetObjectDefMinDistance(berriesID, 0.0);
		rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(berriesID, true);
		rmAddObjectDefConstraint(berriesID, avoidForestMin);
		rmAddObjectDefConstraint(berriesID, avoidGoldShort);
		rmAddObjectDefConstraint(berriesID, avoidSerowShort); 
		rmAddObjectDefConstraint(berriesID, avoidEleShort); 
		rmAddObjectDefConstraint(berriesID, avoidBerriesFar); 
		rmAddObjectDefConstraint(berriesID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(berriesID, avoidNativesShort);
//		rmAddObjectDefConstraint(berriesID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(berriesID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(berriesID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(berriesID, avoidBigIsland1);
		rmAddObjectDefConstraint(berriesID, avoidBigIsland2);
		if (i > 1)
		{
			rmAddObjectDefConstraint(berriesID, avoidSmallIsland1);
			rmAddObjectDefConstraint(berriesID, avoidSmallIsland2);
		}
		else if (i == 0)
			rmAddObjectDefConstraint(berriesID, stayInSmallIsland1);
		else
			rmAddObjectDefConstraint(berriesID, stayInSmallIsland2);
		rmAddObjectDefConstraint(berriesID, avoidEdge);
		rmPlaceObjectDefAtLoc(berriesID, 0, 0.50, 0.50);	
	}
	
	// ************************************
	
	// Text
	rmSetStatusText("",0.90);
		
	// ************** Treasures ***************
	
	int treasure1count = 2+1*cNumberNonGaiaPlayers;
	int treasure2count = 3+1*cNumberNonGaiaPlayers;
	int treasure4count = 1+0.34*cNumberNonGaiaPlayers;
	
	//Treasures lvl 2
	for (i=0; < treasure2count)
	{
		int Nugget2ID = rmCreateObjectDef("Nugget lvl 2 "+i);
		rmAddObjectDefItem(Nugget2ID, "Nugget", rmRandInt(1,1), 2.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0.0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(Nugget2ID, true);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidSerowMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidEleMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidBerriesMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(Nugget2ID, avoidNativesShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
//		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge);
		if (i == 0)
			rmAddObjectDefConstraint(Nugget2ID, stayInHillA);
		else if (i == 1)
			rmAddObjectDefConstraint(Nugget2ID, stayInHillB);
		else if (i == 2)
			rmAddObjectDefConstraint(Nugget2ID, stayInBigIsland1);
		else if (i == 3)
			rmAddObjectDefConstraint(Nugget2ID, stayInBigIsland2);
		else
		{
			rmAddObjectDefConstraint(Nugget2ID, avoidBigIsland1);
			rmAddObjectDefConstraint(Nugget2ID, avoidBigIsland2);
			rmAddObjectDefConstraint(Nugget2ID, avoidSmallIsland1);
			rmAddObjectDefConstraint(Nugget2ID, avoidSmallIsland2);
		}
		rmSetNuggetDifficulty(2,2);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);	
	}
	
	//Treasures lvl 4
	for (i=0; < treasure4count)
	{
		int Nugget4ID = rmCreateObjectDef("Nugget lvl 4 "+i);
		rmAddObjectDefItem(Nugget4ID, "Nugget", rmRandInt(1,1), 2.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0.0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(Nugget4ID, true);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidSerowMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidEleMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidBerriesMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(Nugget4ID, avoidNativesShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
//		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget4ID, stayCenter);
		rmAddObjectDefConstraint(Nugget4ID, avoidBigIsland1);
		rmAddObjectDefConstraint(Nugget4ID, avoidBigIsland2);
		rmAddObjectDefConstraint(Nugget4ID, avoidSmallIsland1);
		rmAddObjectDefConstraint(Nugget4ID, avoidSmallIsland2);
		rmSetNuggetDifficulty(4,4);
		if (cNumberNonGaiaPlayers >= 3)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);	
	}
	
	//Treasures lvl 
	for (i=0; < treasure1count)
	{
		int Nugget1ID = rmCreateObjectDef("Nugget lvl 1 "+i);
		rmAddObjectDefItem(Nugget1ID, "Nugget", rmRandInt(1,1), 2.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0.0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(Nugget1ID, true);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidSerowMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidEleMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidBerriesMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(Nugget1ID, avoidNativesShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidNuggetFar);
//		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget1ID, avoidBigIsland1);
		rmAddObjectDefConstraint(Nugget1ID, avoidBigIsland2);
		rmAddObjectDefConstraint(Nugget1ID, avoidSmallIsland1);
		rmAddObjectDefConstraint(Nugget1ID, avoidSmallIsland2);
		rmSetNuggetDifficulty(1,1);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);	
	}
	
	// ****************************************
	
	// *************** Buffalos ***************
	
	//Buffalos 
	
	int buffalocount = 10;
	if (cNumberNonGaiaPlayers >=4)
		buffalocount = 14;
	if (cNumberNonGaiaPlayers >=6)
		buffalocount = 20;
		
	for (i=0; < buffalocount)
	{
		int BuffaloID = rmCreateObjectDef("Buffalo"+i);
		if (i < buffalocount/5)
			rmAddObjectDefItem(BuffaloID, "ypWaterBuffalo", rmRandInt(2,2), 4.0);
		else 
			rmAddObjectDefItem(BuffaloID, "ypWaterBuffalo", rmRandInt(1,1), 2.0);
		rmSetObjectDefMinDistance(BuffaloID, 0.0);
		rmSetObjectDefMaxDistance(BuffaloID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(BuffaloID, true);
		rmAddObjectDefConstraint(BuffaloID, avoidForestMin);
		rmAddObjectDefConstraint(BuffaloID, avoidGoldMin);
		rmAddObjectDefConstraint(BuffaloID, avoidSerowMin);
		rmAddObjectDefConstraint(BuffaloID, avoidBerriesMin);
		rmAddObjectDefConstraint(BuffaloID, avoidEleMin); 
		rmAddObjectDefConstraint(BuffaloID, avoidBerriesMin); 
		rmAddObjectDefConstraint(BuffaloID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(BuffaloID, avoidNativesShort);
		rmAddObjectDefConstraint(BuffaloID, avoidNuggetMin);
		rmAddObjectDefConstraint(BuffaloID, avoidBuffalo);
//		rmAddObjectDefConstraint(BuffaloID, avoidTradeRouteShort);
//		rmAddObjectDefConstraint(BuffaloID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(BuffaloID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(BuffaloID, avoidEdge);
		if (cNumberTeams <= 2)
		{
			if (i < buffalocount/10)
				rmAddObjectDefConstraint(BuffaloID, stayInBigIsland1);
			else if (i < buffalocount/5)
				rmAddObjectDefConstraint(BuffaloID, stayInBigIsland2);
			else
			{
				rmAddObjectDefConstraint(BuffaloID, avoidBigIsland1);
				rmAddObjectDefConstraint(BuffaloID, avoidBigIsland2);
				rmAddObjectDefConstraint(BuffaloID, avoidSmallIsland1);
				rmAddObjectDefConstraint(BuffaloID, avoidSmallIsland2);
			}
		}	
		else
		{
			if (i == 0)
				rmAddObjectDefConstraint(BuffaloID, stayInBigIsland1);
			else if (i == 1)
				rmAddObjectDefConstraint(BuffaloID, stayInBigIsland2);
			else if (i < buffalocount/5)
				rmAddObjectDefConstraint(BuffaloID, stayCenter);
			else
			{
				rmAddObjectDefConstraint(BuffaloID, avoidBigIsland1);
				rmAddObjectDefConstraint(BuffaloID, avoidBigIsland2);
				rmAddObjectDefConstraint(BuffaloID, avoidSmallIsland1);
				rmAddObjectDefConstraint(BuffaloID, avoidSmallIsland2);
			}
		}
		rmPlaceObjectDefAtLoc(BuffaloID, 0, 0.50, 0.50);	
	}

	// ****************************************
	
	// ************ Sea resources *************
	
	 // Water nuggets
	int nuggetwcount = 4+1*cNumberNonGaiaPlayers;
	
	for (i=0; < nuggetwcount)
	{
		int nuggetW= rmCreateObjectDef("nugget water"+i); 
		rmAddObjectDefItem(nuggetW, "ypNuggetBoat", 1, 0.0);
		rmSetNuggetDifficulty(5, 5);
		rmSetObjectDefMinDistance(nuggetW, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(nuggetW, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nuggetW, avoidLand);
		rmAddObjectDefConstraint(nuggetW, avoidEdge);
		rmAddObjectDefConstraint(nuggetW, avoidNuggetWater);
		rmPlaceObjectDefAtLoc(nuggetW, 0, 0.50, 0.50);
	}
	
	//Fish
	int fishcount = 12+4*cNumberNonGaiaPlayers;
	int whalecount = 6+2*cNumberNonGaiaPlayers;
	
	for (i=0; < whalecount)
	{
		int whaleID=rmCreateObjectDef("whale"+i);
		rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 2.0);
		rmSetObjectDefMinDistance(whaleID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(whaleID, avoidWhale);
		rmAddObjectDefConstraint(whaleID, avoidLandFar);
		rmAddObjectDefConstraint(whaleID, avoidFlag);
		rmAddObjectDefConstraint(whaleID, avoidEdge);
		rmAddObjectDefConstraint(whaleID, avoidNuggetWaterShort);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.50, 0.50);
	}
	
	for (i=0; < fishcount)
	{
		int fishID = rmCreateObjectDef("fish"+i);
		rmAddObjectDefItem(fishID, "ypFishMolaMola", rmRandInt(2,2), 10.0);
		rmSetObjectDefMinDistance(fishID, 0.0);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmAddObjectDefConstraint(fishID, avoidLand);
		rmAddObjectDefConstraint(fishID, avoidFlagShort);
		rmAddObjectDefConstraint(fishID, avoidEdge);
		rmAddObjectDefConstraint(fishID, avoidNuggetWaterShort);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.50, 0.50);
	}
	
  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.015;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

	// Text
	rmSetStatusText("",1.00);
	
} //END
	
	