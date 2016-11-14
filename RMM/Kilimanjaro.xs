// ESOC TIBET (1v1, TEAM, FFA)
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
	
	// Picks the map size
	int playerTiles=13000; //11000
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles = 12000;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles = 11000;
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(-6.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.04, 2, 0.5, 4.5); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	
	// Picks default terrain and water
	rmSetBaseTerrainMix("himalayas_a"); // 
	rmTerrainInitialize("himalayas\ground_dirt3_himal", -6.0); // 
	rmSetMapType("himalayas"); 
	rmSetMapType("snow");
	rmSetMapType("land");
	rmSetLightingSet("great lakes winter");

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("uger");
	subCiv1 = rmGetCivID("uger");
	rmSetSubCiv(0, "uger");
	rmSetSubCiv(1, "uger");
	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
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
	int classUpperGold = rmDefineClass("UpperGold");
	int classLowerGold = rmDefineClass("LowerGold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.38), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.25), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int staySW = rmCreatePieConstraint("Stay SW", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(260),rmDegreesToRadians(280));
	int stayNE = rmCreatePieConstraint("Stay NE", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(80),rmDegreesToRadians(100));
	int staySouthHalf = rmCreatePieConstraint("Stay south half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(188),rmDegreesToRadians(352));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(368),rmDegreesToRadians(172));
	int plateauTrack = rmCreatePieConstraint("plateau limit constraint", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.36), rmDegreesToRadians(0),rmDegreesToRadians(360));
		
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 30.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 20.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidSerowFar = rmCreateTypeDistanceConstraint("avoid Serow far", "ypSerow", 50.0);
	int avoidSerow = rmCreateTypeDistanceConstraint("avoid Serow", "ypSerow", 30.0);
	int avoidSerowShort = rmCreateTypeDistanceConstraint("avoid Serow short", "ypSerow", 25.0);
	int avoidSerowMin = rmCreateTypeDistanceConstraint("avoid Serow min", "ypSerow", 4.0);
	int avoidIbexFar = rmCreateTypeDistanceConstraint("avoid Ibex far", "ypIbex", 58.0);
	int avoidIbex = rmCreateTypeDistanceConstraint("avoid  Ibex", "ypIbex", 50.0);
	int avoidIbexShort = rmCreateTypeDistanceConstraint("avoid  Ibex short", "ypIbex", 35.0);
	int avoidIbexMin = rmCreateTypeDistanceConstraint("avoid Ibex min", "ypIbex", 4.0);
	int avoidMuskdeerFar = rmCreateTypeDistanceConstraint("avoid muskdeer far", "ypmuskdeer", 70.0);
	int avoidMuskdeer = rmCreateTypeDistanceConstraint("avoid muskdeer ", "ypmuskdeer", 45.0);
	int avoidMuskdeerMin = rmCreateTypeDistanceConstraint("avoid muskdeer min ", "ypmuskdeer", 4.0);
	int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 15.0);
	int avoidGoldTypeMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 25.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 30.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 50.0);
	int avoidLowerGoldMin=rmCreateClassDistanceConstraint("avoid lower gold min ", rmClassID("LowerGold"), 8.0);
	int avoidLowerGoldShort = rmCreateClassDistanceConstraint ("avoid lower gold short", rmClassID("LowerGold"), 15.0);
	int avoidLowerGold = rmCreateClassDistanceConstraint ("avoid lower gold med", rmClassID("LowerGold"), 30.0);
	int avoidLowerGoldFar = rmCreateClassDistanceConstraint ("avoid lower gold far", rmClassID("LowerGold"), 56.0);
	int avoidLowerGoldVeryFar = rmCreateClassDistanceConstraint ("avoid lower gold very far", rmClassID("LowerGold"), 75.0);
	int avoidUpperGoldMin=rmCreateClassDistanceConstraint("avoid upper gold min ", rmClassID("UpperGold"), 8.0);
	int avoidUpperGoldShort = rmCreateClassDistanceConstraint ("avoid upper gold short", rmClassID("UpperGold"), 15.0);
	int avoidUpperGold = rmCreateClassDistanceConstraint ("avoid upper gold med", rmClassID("UpperGold"), 30.0);
	int avoidUpperGoldFar = rmCreateClassDistanceConstraint ("avoid upper gold far", rmClassID("UpperGold"), 58.0);
	int avoidUpperGoldVeryFar = rmCreateClassDistanceConstraint ("avoid upper gold very far", rmClassID("UpperGold"), 65.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 15.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 56.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 50.0);
//	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 25.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 0.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 0.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 0.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 6.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "fish", 52.0);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 24.0);
	int avoidYak=rmCreateTypeDistanceConstraint("avoid yak", "ypyak", 62.0);
	int avoidColonyShip = rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 30.0);
	int avoidColonyShipShort = rmCreateTypeDistanceConstraint("avoid colony ship short", "HomeCityWaterSpawnFlag", 15.0);

	// Avoid impassable land
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 2.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 5.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land medium", "Land", false, 12.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 8.0);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 15.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 30.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 20.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 5.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 20.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);	
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 7.0);
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
			if ( OneVOnePlacement < 0.5)
			{
				rmPlacePlayer(1, 0.25, 0.50);
				rmPlacePlayer(2, 0.75, 0.50);
			}
			else
			{
				rmPlacePlayer(2, 0.25, 0.50);
				rmPlacePlayer(1, 0.75, 0.50);
			}
			
		}
		else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
		{
			if (teamZeroCount == 2) // 2v2
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.650, 0.850); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.26, 0.26, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.150, 0.350); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.26, 0.26, 0);
			}
			else // 3v3, 4v4 
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.625, 0.875); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.26, 0.26, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.125, 0.375); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.26, 0.26, 0);
			}
		}
		else // unequal N of players per TEAM
		{
			if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
			{
				if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.249, 0.251); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.26, 0.26, 0);

					rmSetPlacementTeam(1);
					if (teamOneCount == 2)
						rmSetPlacementSection(0.650, 0.850); // 
					else
						rmSetPlacementSection(0.625, 0.875); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.26, 0.26, 0);
				} 
				else // 2v1, 3v1, 4v1, etc.
				{
					rmSetPlacementTeam(0);
					if (teamZeroCount == 2)
						rmSetPlacementSection(0.150, 0.350); // 
					else
						rmSetPlacementSection(0.125, 0.375); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.26, 0.26, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.749, 0.751); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.26, 0.26, 0);
				} 
			}
			else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
			{
				if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.650, 0.850); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.26, 0.26, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.125, 0.375); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.26, 0.26, 0);
				} 
				else // 3v2, 4v2, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.625, 0.875); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.26, 0.26, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.150, 0.350); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.26, 0.26, 0);
				} 
			}
			else // 3v4, 4v3, etc.
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.625, 0.875); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.26, 0.26, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.125, 0.375); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.26, 0.26, 0);
			} 
		}
	}
	else // FFA
	{	
		rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.26, 0.26, 0.0);
	}
	
	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.30);
	
		// ****************************************** TRADE ROUTE **********************************************
		
	float TPvariation = -1;
	TPvariation = rmRandFloat(0.1,1.0);
//	TPvariation = 0.3; // <--- TEST
		
	int tradeRouteID = rmCreateTradeRoute();
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);
	rmAddObjectDefConstraint(socketID, avoidImpassableLandShort);

	rmAddTradeRouteWaypoint(tradeRouteID, 0.05, 0.60); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.85); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.95);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.80, 0.82); 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.60);

	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "water");
	if(placedTradeRoute == false)
	rmEchoError("Failed to place trade route");
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);	
	
	
	int tradeRoute2ID = rmCreateTradeRoute();
	int socket2ID=rmCreateObjectDef("sockets to dock Trade Posts 2");
	rmAddObjectDefItem(socket2ID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socket2ID, true);
	rmSetObjectDefMinDistance(socket2ID, 0.0);
	rmSetObjectDefMaxDistance(socket2ID, 8.0);
	rmAddObjectDefConstraint(socket2ID, avoidImpassableLandShort);

	rmAddTradeRouteWaypoint(tradeRoute2ID, 0.95, 0.40); 
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.80, 0.16); 
	rmAddTradeRouteWaypoint(tradeRoute2ID, 0.50, 0.05);
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.20, 0.16); 
	rmAddTradeRouteWaypoint(tradeRoute2ID, 0.05, 0.40);
		
	bool placedTradeRoute2 = rmBuildTradeRoute(tradeRoute2ID, "water");
	if(placedTradeRoute2 == false)
	rmEchoError("Failed to place trade route 2");
	rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);
	vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.15);
	rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
	socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.50);
	rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
	socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.85);
	rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);	

	
	// *************************************************************************************************************
	
	// ******************************************** MAP LAYOUT **************************************************
	
	
	//Plateau 1st level
	int plateauID = rmCreateArea("first level plateau");
    rmSetAreaWarnFailure(plateauID, false);
	rmSetAreaLocation(plateauID, 0.50, 0.50);
	rmSetAreaSize(plateauID, 0.36, 0.36);
//	rmAddAreaInfluenceSegment(plateauID, 0.40, 0.50, 0.60, 0.50);
	rmSetAreaCliffHeight(plateauID, 6, 0.0, 0.6); 
	rmSetAreaCliffEdge(plateauID, 8, 0.10, 0, 1.0, 0); 
	rmSetAreaMix(plateauID, "himalayas_b");	
	rmSetAreaTerrainType(plateauID, "himalayas\ground_dirt2_himal");
	rmSetAreaCliffType(plateauID, "himalayas"); 
//	rmSetAreaCliffPainting(plateauID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCoherence(plateauID, 0.70);
	rmSetAreaSmoothDistance(plateauID, 14);
//	rmAddAreaConstraint(plateauID, plateauTrack);
	rmAddAreaConstraint(plateauID, avoidTradeRouteShort);
	rmAddAreaConstraint(plateauID, avoidTradeRouteSocketShort);
	rmBuildArea(plateauID); 
	
	int avoidPlateau = rmCreateAreaDistanceConstraint("avoid first level plateau ", plateauID, 2);
	int stayInPlateau = rmCreateAreaMaxDistanceConstraint("stay in first level plateau ", plateauID, 0);
	int avoidRamp = rmCreateCliffRampDistanceConstraint("avoid ramp", plateauID, 15.0);
	int avoidRampShort = rmCreateCliffRampDistanceConstraint("avoid ramp short", plateauID, 8.0);
	
	//Hill 2nd level
	int hillID = rmCreateArea("second level hill");
    rmSetAreaWarnFailure(hillID, false);
	rmSetAreaLocation(hillID, 0.5, 0.5);
	rmSetAreaSize(hillID, 0.05, 0.05);
	rmSetAreaCliffHeight(hillID, 4, 0.0, 0.8); 
	rmSetAreaCliffEdge(hillID, 4, 0.20, 0, 1.0, 0); 
//	rmSetAreaMix(hillID, "himalayas_b");
	rmSetAreaTerrainType(hillID, "himalayas\ground_dirt2_himal");
	rmSetAreaCliffType(hillID, "himalayas"); 
//	rmSetAreaCliffPainting(hillID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge	
	rmSetAreaCoherence(hillID, 0.65);
	rmSetAreaSmoothDistance(hillID, 8);
	rmBuildArea(hillID); 
	
	int avoidHill = rmCreateAreaDistanceConstraint("avoid second level plateau ", hillID, 2);
	int stayInHill = rmCreateAreaMaxDistanceConstraint("stay in second level plateau ", hillID, 0);
	
	
		
	// Patches
	for (i=0; < 6+1*cNumberNonGaiaPlayers)
	{
		int patchID = rmCreateArea("patch"+i);
		rmSetAreaWarnFailure(patchID, false);
		rmSetAreaObeyWorldCircleConstraint(patchID, false);
		rmSetAreaSize(patchID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(60));
		rmSetAreaTerrainType(patchID, "himalayas\ground_dirt3_himal");
		rmAddAreaToClass(patchID, rmClassID("patch"));
		rmSetAreaMinBlobs(patchID, 1);
		rmSetAreaMaxBlobs(patchID, 5);
		rmSetAreaMinBlobDistance(patchID, 12.0);
		rmSetAreaMaxBlobDistance(patchID, 30.0);
		rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, avoidImpassableLandMin);
		rmAddAreaConstraint(patchID, stayInHill);
		rmBuildArea(patchID); 
	}
	

	
	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.05, 0.05);
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

	// *********************************************************************************************************
	
	// Text
	rmSetStatusText("",0.40);
	
	
		
	// Text
	rmSetStatusText("",0.45);
	
	// ******************************************** NATIVES *************************************************
	
	
	float Natsvariation = -1;
//	Natsvariation = rmRandFloat(0.0,1.0); // > 0.66 x2 udasi, > 0.33 x2 bhakti, else 1 udasi and 1 bhakti
	Natsvariation = 0.2; // <--- TEST
	
	int nativeID0 = -1;
    int nativeID1 = -1;
	
		if (Natsvariation > 0.66)
	{
		nativeID0 = rmCreateGrouping("Udasi village A", "uger"+1);
		nativeID1 = rmCreateGrouping("Udasi village B", "uger"+1);
	}
	else if (Natsvariation > 0.33)
	{
		nativeID0 = rmCreateGrouping("Shaolin temple A", "uger"+1);
		nativeID1 = rmCreateGrouping("Shaolin temple A", "uger"+1);
	}	
	else
	{
		nativeID0 = rmCreateGrouping("Udasi village A", "uger"+1);
		nativeID1 = rmCreateGrouping("Shaolin temple A", "uger"+1);
	}
//	rmSetGroupingMinDistance(nativeID0, 0.00);
//	rmSetGroupingMaxDistance(nativeID0, 0.00);
//	rmSetGroupingMinDistance(nativeID1, 0.00);
//	rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	if (cNumberTeams <= 2)
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.50, 0.73);
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.27);
	}
	else
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.50, 0.70);
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.30);
	}
	
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
	
	// Starting mine
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 12.0);
	rmSetObjectDefMaxDistance(playergoldID, 14.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classUpperGold);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	rmAddObjectDefConstraint(playergoldID, stayCenter);
//	rmAddObjectDefConstraint(playergoldID, avoidEdge);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 52.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 54.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classUpperGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLandMed);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, stayInPlateau);
	rmAddObjectDefConstraint(playergold2ID, avoidHill);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);
		
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "ypTreeHimalayas", rmRandInt(2,2), 3.0);
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 18);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
//	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting herd
	int playeherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playeherdID, "ypIbex", rmRandInt(10,10), 7.0);
	rmSetObjectDefMinDistance(playeherdID, 12.0);
	rmSetObjectDefMaxDistance(playeherdID, 16.0);
	rmSetObjectDefCreateHerd(playeherdID, true);
	rmAddObjectDefToClass(playeherdID, classStartingResource);
	rmAddObjectDefConstraint(playeherdID, avoidTradeRoute);
	rmAddObjectDefConstraint(playeherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playeherdID, avoidNatives);
	rmAddObjectDefConstraint(playeherdID, avoidStartingResources);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "ypIbex", rmRandInt(10,10), 7.0);
    rmSetObjectDefMinDistance(player2ndherdID, 28);
    rmSetObjectDefMaxDistance(player2ndherdID, 30);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResources);
	rmAddObjectDefConstraint(player2ndherdID, avoidSerow); 
//	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(player2ndherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdge);
	rmAddObjectDefConstraint(player2ndherdID, avoidNatives);
		
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
		
	// Starting yaks
	int playerYakID = rmCreateObjectDef("starting yaks");
	rmAddObjectDefItem(playerYakID, "ypyak", rmRandInt(1,3), 3.0);
	rmSetObjectDefMinDistance(playerYakID, 12.0);
	rmSetObjectDefMaxDistance(playerYakID, 16.0);
	rmAddObjectDefToClass(playerYakID, classStartingResource);
	rmAddObjectDefConstraint(playerYakID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerYakID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerYakID, avoidNatives);
	rmAddObjectDefConstraint(playerYakID, avoidStartingResources);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget); //Short
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2); // 1,2

	
	
	// ******** Place ********
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playeherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerYakID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(player3rdherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		if (nugget0count == 2)
//			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	}

	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ************************************** COMMON RESOURCES ****************************************
  
   
	// ************* Mines **************
	
	int sidegoldcount = 4+1*cNumberNonGaiaPlayers;  
	int plateaugoldcount = 2+1*cNumberNonGaiaPlayers;   
	
	// Plateau mines
	for(i=0; < plateaugoldcount)
	{
		int plateaugoldID = rmCreateObjectDef("plateau mines"+i);
		rmAddObjectDefItem(plateaugoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(plateaugoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(plateaugoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(plateaugoldID, classUpperGold);
		rmAddObjectDefConstraint(plateaugoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(plateaugoldID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(plateaugoldID, avoidNatives);
		rmAddObjectDefConstraint(plateaugoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(plateaugoldID, avoidGoldTypeFar);
		rmAddObjectDefConstraint(plateaugoldID, avoidUpperGoldVeryFar);
		rmAddObjectDefConstraint(plateaugoldID, avoidTownCenter);
		rmAddObjectDefConstraint(plateaugoldID, avoidEdge);
		rmAddObjectDefConstraint(plateaugoldID, stayInPlateau);
		rmAddObjectDefConstraint(plateaugoldID, avoidHill);
		rmAddObjectDefConstraint(plateaugoldID, avoidRamp);
		rmPlaceObjectDefAtLoc(plateaugoldID, 0, 0.50, 0.50);
	}
	
	
	// ground floor mines
	for(i=0; < sidegoldcount)
	{
		int groundgoldID = rmCreateObjectDef("ground floor mines"+i);
		rmAddObjectDefItem(groundgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(groundgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(groundgoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(groundgoldID, classLowerGold);
		rmAddObjectDefConstraint(groundgoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(groundgoldID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(groundgoldID, avoidNatives);
		rmAddObjectDefConstraint(groundgoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(groundgoldID, avoidLowerGoldVeryFar);
		rmAddObjectDefConstraint(groundgoldID, avoidGoldTypeFar);
		rmAddObjectDefConstraint(groundgoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(groundgoldID, avoidEdge);
		rmAddObjectDefConstraint(groundgoldID, avoidPlateau);
		rmAddObjectDefConstraint(groundgoldID, avoidRamp);
		if (i == 0)
			rmAddObjectDefConstraint(groundgoldID, stayNE);
		else if (i == 1)
			rmAddObjectDefConstraint(groundgoldID, staySW);
		else if (i < 4)
			rmAddObjectDefConstraint(groundgoldID, staySouthHalf);
		else 
			rmAddObjectDefConstraint(groundgoldID, stayNorthHalf);
		rmPlaceObjectDefAtLoc(groundgoldID, 0, 0.50, 0.50);
	}
	
		
	// *********************************
	
	// Text
	rmSetStatusText("",0.70);
	
	// ************ Forest *************
	
	
	// Lowground forest
	int forestlowcount = 14+3*cNumberNonGaiaPlayers;
	int stayInForestLowPatch = -1;
	
	for (i=0; < forestlowcount)
	{
		int forestlowID = rmCreateArea("forest lowground "+i);
		rmSetAreaWarnFailure(forestlowID, false);
		rmSetAreaSize(forestlowID, rmAreaTilesToFraction(130), rmAreaTilesToFraction(150));
//		rmSetAreaTerrainType(forestlowID, "mongolia\ground_grass6_mongol");
		rmSetAreaObeyWorldCircleConstraint(forestlowID, false);
//		rmSetAreaForestDensity(forestlowID, 0.8);
//		rmSetAreaForestClumpiness(forestlowID, 0.15);
//		rmSetAreaForestUnderbrush(forestlowID, 0.2);
		rmSetAreaMinBlobs(forestlowID, 2);
		rmSetAreaMaxBlobs(forestlowID, 4);
		rmSetAreaMinBlobDistance(forestlowID, 14.0);
		rmSetAreaMaxBlobDistance(forestlowID, 30.0);
		rmSetAreaCoherence(forestlowID, 0.65);
		rmSetAreaSmoothDistance(forestlowID, 6);
		rmAddAreaToClass(forestlowID, classForest);
		rmAddAreaConstraint(forestlowID, avoidForest);
		rmAddAreaConstraint(forestlowID, avoidGoldTypeMin);
		rmAddAreaConstraint(forestlowID, avoidIbexMin); 
		rmAddAreaConstraint(forestlowID, avoidTownCenterShort); 
		rmAddAreaConstraint(forestlowID, avoidNativesShort);
		rmAddAreaConstraint(forestlowID, avoidTradeRouteShort);
		rmAddAreaConstraint(forestlowID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestlowID, avoidImpassableLandShort);
		rmAddAreaConstraint(forestlowID, avoidHill);
		rmAddAreaConstraint(forestlowID, avoidRamp);
//		rmAddAreaConstraint(forestlowID, avoidEdge);
		rmBuildArea(forestlowID);
		
		stayInForestLowPatch = rmCreateAreaMaxDistanceConstraint("stay in forest low patch"+i, forestlowID, 0.0);
		
		for (j=0; < rmRandInt(15,16))
		{
			int forestlowtreeID = rmCreateObjectDef("forest lowground trees"+i+j);
			rmAddObjectDefItem(forestlowtreeID, "ypTreeHimalayas", rmRandInt(1,2), 2.0);
			rmSetObjectDefMinDistance(forestlowtreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(forestlowtreeID,  rmXFractionToMeters(0.5));
		//	rmAddObjectDefToClass(forestlowtreeID, classForest);
		//	rmAddObjectDefConstraint(forestlowtreeID, avoidForestShort);
			rmAddObjectDefConstraint(forestlowtreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(forestlowtreeID, stayInForestLowPatch);	
			rmPlaceObjectDefAtLoc(forestlowtreeID, 0, 0.50, 0.50);
		}
	}
	
	// Random trees 
	for (i=0; < 18+3*cNumberNonGaiaPlayers)
	{
		int randomtreeID = rmCreateObjectDef("random trees "+i);
		rmAddObjectDefItem(randomtreeID, "ypTreeHimalayas", rmRandInt(2,4), 5.0);
		rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(randomtreeID, avoidIbexMin); 
		rmAddObjectDefConstraint(randomtreeID, avoidTownCenterShort); 
		rmAddObjectDefConstraint(randomtreeID, avoidNativesShort);
		rmAddObjectDefConstraint(randomtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(randomtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(randomtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(randomtreeID, avoidStartingResources);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50);
	}
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ************ Herds *************
	
	int highgroundherdcount = 1+2*cNumberNonGaiaPlayers;
	int lowgroundherdcount = 3+2*cNumberNonGaiaPlayers;
		
	//Highground herds
	for (i=0; < highgroundherdcount)
	{
		int highgroundherdID = rmCreateObjectDef("highground herd"+i);
		rmAddObjectDefItem(highgroundherdID, "ypIbex", rmRandInt(10,10), 7.0);
		rmSetObjectDefMinDistance(highgroundherdID, 0.0);
		rmSetObjectDefMaxDistance(highgroundherdID, rmXFractionToMeters(0.6));
		rmSetObjectDefCreateHerd(highgroundherdID, true);
		rmAddObjectDefConstraint(highgroundherdID, avoidForestMin);
		rmAddObjectDefConstraint(highgroundherdID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(highgroundherdID, avoidIbexFar);  
		rmAddObjectDefConstraint(highgroundherdID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(highgroundherdID, avoidNatives);
//		rmAddObjectDefConstraint(highgroundherdID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(highgroundherdID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(highgroundherdID, avoidImpassableLand);
		rmAddObjectDefConstraint(highgroundherdID, stayInPlateau);
		rmAddObjectDefConstraint(highgroundherdID, avoidRamp);
		rmAddObjectDefConstraint(highgroundherdID, avoidEdge);
//		if (i < 1)
//			rmAddObjectDefConstraint(highgroundherdID, staySW);
//		else if (i < 2)
//			rmAddObjectDefConstraint(highgroundherdID, stayNE);
		rmPlaceObjectDefAtLoc(highgroundherdID, 0, 0.50, 0.50);	
	}
	
	//Lowground herds
	for (i=0; < lowgroundherdcount)
	{
		int lowgroundherdID = rmCreateObjectDef("lowground herd"+i);
		rmAddObjectDefItem(lowgroundherdID, "ypMuskdeer", rmRandInt(7,7), 7.0);
		rmSetObjectDefMinDistance(lowgroundherdID, 0.0);
		rmSetObjectDefMaxDistance(lowgroundherdID, rmXFractionToMeters(0.6));
		rmSetObjectDefCreateHerd(lowgroundherdID, true);
		rmAddObjectDefConstraint(lowgroundherdID, avoidForestMin);
		rmAddObjectDefConstraint(lowgroundherdID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(lowgroundherdID, avoidMuskdeerFar); 
		rmAddObjectDefConstraint(lowgroundherdID, avoidIbex);
		rmAddObjectDefConstraint(lowgroundherdID, avoidTownCenter); 
		rmAddObjectDefConstraint(lowgroundherdID, avoidNatives);
//		rmAddObjectDefConstraint(lowgroundherdID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(lowgroundherdID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(lowgroundherdID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(lowgroundherdID, avoidPlateau);
		rmAddObjectDefConstraint(lowgroundherdID, avoidEdge);
//		if (i < 2)
//			rmAddObjectDefConstraint(lowgroundherdID, staySW);
//		else if (i < 4)
//			rmAddObjectDefConstraint(lowgroundherdID, stayNE);
		rmPlaceObjectDefAtLoc(lowgroundherdID, 0, 0.50, 0.50);	
	}
	
	
	// ************************************
	
	// Text
	rmSetStatusText("",0.90);
		
	// ************** Treasures ***************
	
	int treasure4count = 0.5*cNumberNonGaiaPlayers;
	int treasure2count = 3+0.5*cNumberNonGaiaPlayers;
	int treasure1count = 4+1*cNumberNonGaiaPlayers;
		
		
	// Treasures lvl4
	for (i=0; < treasure4count)
	{
		int Nugget4ID = rmCreateObjectDef("nugget lvl4 "+i); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(4,4);
		rmAddObjectDefConstraint(Nugget4ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget4ID, avoidIbexMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget4ID, stayInPlateau);
		rmAddObjectDefConstraint(Nugget4ID, avoidHill);
		rmAddObjectDefConstraint(Nugget4ID, avoidRamp);
		if (cNumberNonGaiaPlayers >= 4)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}		
		
		
	// Treasures lvl2
	for (i=0; < treasure2count)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl2 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(2,2);
		rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget2ID, avoidIbexMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, stayInPlateau);
		rmAddObjectDefConstraint(Nugget2ID, avoidHill);
		rmAddObjectDefConstraint(Nugget2ID, avoidRamp);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}	
		
		
	// Treasures lvl1	
	for (i=0; < treasure1count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget lvl1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
		rmSetNuggetDifficulty(1,1);
		rmAddObjectDefConstraint(Nugget1ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget1ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter); 
		rmAddObjectDefConstraint(Nugget1ID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget1ID, avoidPlateau);
//		if (i < 2)
//			rmAddObjectDefConstraint(Nugget2ID, staySouthHalf); 
//		else if (i < 4)
//			rmAddObjectDefConstraint(Nugget2ID, stayNorthHalf); 
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	
	
	// ****************************************
	
	// Text
	rmSetStatusText("",0.95);
	
	// **************** Yaks *****************
	
	int yakcount = 2+3*cNumberNonGaiaPlayers;
	
	for (i=0; < yakcount)
	{
		int yakID=rmCreateObjectDef("yak"+i);
		if (i < yakcount/4)
			rmAddObjectDefItem(yakID, "ypyak", 2, 4.0);
		else
			rmAddObjectDefItem(yakID, "ypyak", 1, 1.0);
		rmSetObjectDefMinDistance(yakID, 0.0);
		rmSetObjectDefMaxDistance(yakID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(yakID, avoidYak);
		rmAddObjectDefConstraint(yakID, avoidNatives);
		rmAddObjectDefConstraint(yakID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(yakID, avoidImpassableLand);
		rmAddObjectDefConstraint(yakID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(yakID, avoidTownCenterFar);
		rmAddObjectDefConstraint(yakID, avoidIbexMin); 
		rmAddObjectDefConstraint(yakID, avoidMuskdeerMin);
		rmAddObjectDefConstraint(yakID, avoidForestMin);
		rmAddObjectDefConstraint(yakID, avoidNuggetShort);
		rmAddObjectDefConstraint(yakID, avoidEdge); 
		rmAddObjectDefConstraint(yakID, avoidRampShort); 
		rmAddObjectDefConstraint(yakID, avoidHill);
		if (i < yakcount/4)
		{
			rmAddObjectDefConstraint(yakID, stayInPlateau);
			if (i%2 == 0)
				rmAddObjectDefConstraint(yakID, stayNorthHalf);
			else
				rmAddObjectDefConstraint(yakID, staySouthHalf);
		}
		else
			rmAddObjectDefConstraint(yakID, avoidPlateau);
		rmPlaceObjectDefAtLoc(yakID, 0, 0.50, 0.50);
	}
	// ****************************************
	
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
	
	