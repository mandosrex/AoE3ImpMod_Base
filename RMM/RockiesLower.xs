// ESOC CASCADE RANGE (1v1, TEAM, FFA)
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
	int playerTiles=11500; //12000
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles = 10500;
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
		
	// Picks a default water height
	rmSetSeaLevel(3.5);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 3, 0.4, 4.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks default terrain and water
	rmSetSeaType("great lakes");
	rmSetBaseTerrainMix("great plains grass"); // nwt_grass1
	rmTerrainInitialize("great_plains\ground4_gp", 4.0); // NWterritory\ground_grass2_nwt  NWterritory\ground_grass2_nwt
	rmSetMapType("rockies"); 
	rmSetMapType("snow");
	rmSetMapType("land");
	rmSetLightingSet("rockies"); //
	

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Cheyenne");
	subCiv1 = rmGetCivID("Comanche");
	rmSetSubCiv(0, "Cheyenne");
	rmSetSubCiv(1, "Comanche");

	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("Players");
	int classHill = rmDefineClass("Hills");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPatch4 = rmDefineClass("patch4");
	int classGrass = rmDefineClass("grass");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.42), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.25), rmDegreesToRadians(0),rmDegreesToRadians(360));

	
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 40.0); //
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 32.0); //29.0 
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 24.0); //
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidElkFar = rmCreateTypeDistanceConstraint("avoid elk far", "elk", 60.0);
	int avoidElk = rmCreateTypeDistanceConstraint("avoid elk", "elk", 45.0);
	int avoidElkShort = rmCreateTypeDistanceConstraint("avoid elk short", "elk", 30.0);
	int avoidElkMin = rmCreateTypeDistanceConstraint("avoid elk min", "elk", 5.0);
	int avoidBerriesFar = rmCreateTypeDistanceConstraint("avoid berries far", "berrybush", 56.0);
	int avoidBerries = rmCreateTypeDistanceConstraint("avoid  berries", "berrybush", 40.0);
	int avoidBerriesShort = rmCreateTypeDistanceConstraint("avoid  berries short", "berrybush", 30.0);
	int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min", "berrybush", 10.0);
	int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("coin avoids coin min ", "gold", 10.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 18.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 26.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 50.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 10.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 60.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 72.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 40.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 38.0);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 10.0);
	
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 82.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 70.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 26.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint(" avoid Town Center med", "townCenter", 24.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint(" avoid Town Center short", "townCenter", 20.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint(" avoid Town Center", "townCenter", 40.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 14.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid starting resource", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("avoid starting resource short", rmClassID("startingResource"), 4.0);
	
	

	// Land and terrain constraints
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 10.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 1.0);
	int avoidImpassableLandZero=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 0.2);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 20);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "land", false, 12.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 12.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch 2", rmClassID("patch2"), 12.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("patch avoid patch 3", rmClassID("patch3"), 15.0);
	int avoidPatch4 = rmCreateClassDistanceConstraint("patch avoid patch 4", rmClassID("patch4"), 24.0);
	int avoidStone = rmCreateClassDistanceConstraint("stone avoid stone", rmClassID("stonewater"), 5.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 10.0);
	int avoidCliffMin = rmCreateClassDistanceConstraint("avoid cliff min", rmClassID("Cliffs"), 1.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 4.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 8.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 16.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 10.0);

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);
		
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
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
				rmPlacePlayer(1, 0.50, 0.20);
				rmPlacePlayer(2, 0.50, 0.80);
			}
			else
			{
				rmPlacePlayer(2, 0.50, 0.20);
				rmPlacePlayer(1, 0.50, 0.80);
			}
			
		}
		else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
		{
			if (teamZeroCount == 2) // 2v2
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.960, 0.080); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.34, 0.34, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.460, 0.580); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.34, 0.34, 0);
			}
			else // 3v3, 4v4 
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.930, 0.125); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.34, 0.34, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.430, 0.625); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.34, 0.34, 0);
			}
		}
		else // unequal N of players per TEAM
		{
			if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
			{
				if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.50, 0.82, 0.51, 0.80, 0.00, 0.00);

					rmSetPlacementTeam(1);
					if (teamOneCount == 2)
						rmSetPlacementSection(0.460, 0.580); // 
					else
						rmSetPlacementSection(0.430, 0.625); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);
				} 
				else // 2v1, 3v1, 4v1, etc.
				{
					rmSetPlacementTeam(0);
					if (teamZeroCount == 2)
						rmSetPlacementSection(0.960, 0.080); // 
					else
						rmSetPlacementSection(0.930, 0.125); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.50, 0.18, 0.51, 0.20, 0.00, 0.00);
				} 
			}
			else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
			{
				if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.960, 0.080); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.430, 0.625); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);
				} 
				else // 3v2, 4v2, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.930, 0.125); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.460, 0.580); // 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);
				} 
			}
			else // 3v4, 4v3, etc.
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.930, 0.125); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.34, 0.34, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.430, 0.625); // 
				rmSetTeamSpacingModifier(0.25);
				rmPlacePlayersCircular(0.34, 0.34, 0);
			} 
		}
	}
	else // FFA
	{	
		rmSetPlacementSection(0.380, 0.120);
	//	rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.33, 0.33, 0.0);
	}
		
	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.30);
	
	// ******************************************** MAP LAYOUT AND LANDSCAPE DESIGN **************************************************
	
	int groundID = rmCreateArea("ground");
    rmSetAreaWarnFailure(groundID, false);
	rmSetAreaObeyWorldCircleConstraint(groundID, false);
    rmSetAreaSize(groundID, 1.0, 1.0);
	rmSetAreaTerrainType(groundID, "great_lakes\ground_shoreline3_gl");
//	rmPaintAreaTerrain(groundID);
    rmSetAreaCoherence(groundID, 0.0);
//	rmAddAreaConstraint(groundID, avoidImpassableLandZero);	
//	rmAddAreaConstraint(groundID, avoidPlateau1);
//	rmAddAreaConstraint(groundID, avoidPlateau2);
//	rmAddAreaConstraint(groundID, avoidCliff);
    rmBuildArea(groundID); 
	
	
	//Lake1
	int Lake1ID = rmCreateArea("Lake1");
	rmSetAreaSize(Lake1ID, 0.05, 0.055);
	rmSetAreaLocation(Lake1ID, 1.0, 0.7);
	rmAddAreaInfluenceSegment(Lake1ID, 1.0, 0.6, 0.88, 0.55); // 0.62, 0.62
	rmSetAreaWaterType(Lake1ID, "great lakes"); //yukon river
//	rmSetAreaMinBlobs(Lake1ID, 8);
//	rmSetAreaMaxBlobs(Lake1ID, 10);
//	rmSetAreaMinBlobDistance(Lake1ID, 10);
//	rmSetAreaMaxBlobDistance(Lake1ID, 20);
	rmSetAreaSmoothDistance(Lake1ID, 12);
	rmSetAreaCoherence(Lake1ID, 0.6);
	rmSetAreaObeyWorldCircleConstraint(Lake1ID, false);
	if (cNumberTeams <= 2)
		rmBuildArea(Lake1ID);
	
	int stayNearLake1 = rmCreateAreaMaxDistanceConstraint("stay near lake 1", Lake1ID, 14.0);
	
	//Lake2
	int Lake2ID = rmCreateArea("Lake2");
	rmSetAreaSize(Lake2ID, 0.05, 0.055);
	rmSetAreaLocation(Lake2ID, 0.0, 0.3);
	rmAddAreaInfluenceSegment(Lake2ID, 0.0, 0.4, 0.12, 0.45); // 0.62, 0.62
	rmSetAreaWaterType(Lake2ID, "great lakes"); //yukon river
//	rmSetAreaMinBlobs(Lake2ID, 8);
//	rmSetAreaMaxBlobs(Lake2ID, 10);
//	rmSetAreaMinBlobDistance(Lake2ID, 10);
//	rmSetAreaMaxBlobDistance(Lake2ID, 20);
	rmSetAreaSmoothDistance(Lake2ID, 12);
	rmSetAreaCoherence(Lake2ID, 0.6);
	rmSetAreaObeyWorldCircleConstraint(Lake2ID, false);
	if (cNumberTeams <= 2)
		rmBuildArea(Lake2ID);
	
	int stayNearLake2 = rmCreateAreaMaxDistanceConstraint("stay near lake 2", Lake2ID, 14.0);

	//Lake3
	int Lake3ID = rmCreateArea("Lake3");
	rmSetAreaSize(Lake3ID, 0.05, 0.0565);
	rmSetAreaLocation(Lake3ID, 1.0, 0.5);
	rmAddAreaInfluenceSegment(Lake3ID, 1.0, 0.5, 0.80, 0.5); // 0.62, 0.62
	rmSetAreaWaterType(Lake3ID, "great lakes"); //yukon river
//	rmSetAreaMinBlobs(Lake3ID, 8);
//	rmSetAreaMaxBlobs(Lake3ID, 10);
//	rmSetAreaMinBlobDistance(Lake3ID, 10);
//	rmSetAreaMaxBlobDistance(Lake3ID, 20);
	rmSetAreaSmoothDistance(Lake3ID, 12);
	rmSetAreaCoherence(Lake3ID, 0.6);
	rmSetAreaObeyWorldCircleConstraint(Lake3ID, false);
	if (cNumberTeams >= 3)
		rmBuildArea(Lake3ID);
	
	int stayNearLake3 = rmCreateAreaMaxDistanceConstraint("stay near lake 3", Lake3ID, 15.0);
	
	// Plateau template
	int TemplateID = rmCreateArea("plateau template");
	rmSetAreaSize(TemplateID, 0.34, 0.34);
	rmSetAreaWarnFailure(TemplateID, false);
//	rmSetAreaMix(TemplateID, "rockies_snow");
	rmSetAreaCoherence(TemplateID, 0.65);
	rmSetAreaSmoothDistance(TemplateID, 10);
	rmSetAreaLocation(TemplateID, 0.5, 0.5);
	rmBuildArea(TemplateID);
	
	int avoidTemplate = rmCreateAreaDistanceConstraint("avoid template", TemplateID, 3.0);
	
	
	// Snow rim template
	int Template2ID = rmCreateArea("snow rim template");
	rmSetAreaSize(Template2ID, 0.50, 0.50);
	rmSetAreaWarnFailure(Template2ID, false);
//	rmSetAreaMix(Template2ID, "rockies_snow");
	rmSetAreaCoherence(Template2ID, 0.8);
	rmSetAreaSmoothDistance(Template2ID, 6);
	rmSetAreaLocation(Template2ID, 0.5, 0.5);
	rmBuildArea(Template2ID);

	int avoidTemplate2 = rmCreateAreaDistanceConstraint("avoid template2", Template2ID, 1.5);
	

	// Border1 template
	int Template3ID = rmCreateArea("border1 template");
	rmSetAreaSize(Template3ID, 0.63, 0.63);
	rmSetAreaWarnFailure(Template3ID, false);
//	rmSetAreaMix(Template3ID, "rockies_snow");
	rmSetAreaCoherence(Template3ID, 0.8);
	rmSetAreaSmoothDistance(Template3ID, 10);
	rmSetAreaLocation(Template3ID, 0.5, 0.5);
	rmBuildArea(Template3ID);

	int avoidTemplate3 = rmCreateAreaDistanceConstraint("avoid template3", Template3ID, 1.5);
	
	// Border2 template
	int Template4ID = rmCreateArea("border2 template");
	rmSetAreaSize(Template4ID, 0.67, 0.67);
	rmSetAreaWarnFailure(Template4ID, false);
//	rmSetAreaMix(Template4ID, "rockies_snow");
	rmSetAreaCoherence(Template4ID, 0.9);
	rmSetAreaSmoothDistance(Template4ID, 12);
	rmSetAreaLocation(Template4ID, 0.5, 0.5);
	rmBuildArea(Template4ID);

	int avoidTemplate4 = rmCreateAreaDistanceConstraint("avoid template4", Template4ID, 1.5);
	
	
	// Plateau
	for(i=1; < 3)
	{
		int plateauID = rmCreateArea("plateau"+i);
		rmSetAreaSize(plateauID, 0.30, 0.30); //0.23, 0.23
		rmSetAreaWarnFailure(plateauID, false);
		rmSetAreaObeyWorldCircleConstraint(plateauID, false);
	//	rmSetAreaCliffType(plateauID, "araucania north coast"); // araucania north coast
	//	rmSetAreaCliffPainting(plateauID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(plateauID, "great_lakes\ground_grass2_gl");
		rmSetAreaBaseHeight(plateauID, 7.0);
		rmSetAreaHeightBlend(plateauID, 2.0);
		rmSetAreaElevationType(plateauID, cElevTurbulence);
		rmSetAreaElevationVariation(plateauID, 7.0);
		rmSetAreaElevationMinFrequency(plateauID, 0.05);
		rmSetAreaElevationOctaves(plateauID, 3);
		rmSetAreaElevationPersistence(plateauID, 0.5);
	//	rmSetAreaBaseHeight(plateauID, 5, 0.0, 0.8); 
	//	rmSetAreaCliffEdge(plateauID, 5, 0.083, 0.0, 0.30, 1); 
		rmSetAreaCoherence(plateauID, 0.8);
		rmSetAreaSmoothDistance(plateauID, 6);
	//	rmAddAreaToClass(plateauID, rmClassID("Cliffs"));
		rmAddAreaConstraint(plateauID, avoidTemplate);	
		rmAddAreaConstraint (plateauID, avoidImpassableLandMin);
		if (i < 2)
			rmSetAreaLocation(plateauID, 0.0, 1.0);
		else	
			rmSetAreaLocation(plateauID, 1.0, 0.0);
		if (cNumberTeams <= 2)
			rmBuildArea(plateauID);
		rmCreateAreaDistanceConstraint("avoid plateau "+i, plateauID, 0.2);
		rmCreateAreaMaxDistanceConstraint("stay in plateau "+i, plateauID, 0.0);
	}
	
	int avoidPlateau1 = rmConstraintID("avoid plateau 1");
	int avoidPlateau2 = rmConstraintID("avoid plateau 2");
	int stayInPlateau1 = rmConstraintID("stay in plateau 1");
	int stayInPlateau2 = rmConstraintID("stay in plateau 2");
		
	
	// Plateau FFA
	int plateau3ID = rmCreateArea("plateau FFA");
	rmSetAreaSize(plateau3ID, 0.60, 0.60); //0.23, 0.23
	rmSetAreaWarnFailure(plateau3ID, false);
	rmSetAreaObeyWorldCircleConstraint(plateau3ID, false);
//	rmSetAreaCliffType(plateau3ID, "araucania north coast"); // araucania north coast
//	rmSetAreaCliffPainting(plateau3ID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaTerrainType(plateau3ID, "great_lakes\ground_grass2_gl");
	rmSetAreaBaseHeight(plateau3ID, 7.0);
	rmSetAreaHeightBlend(plateau3ID, 2.0);
	rmSetAreaElevationType(plateau3ID, cElevTurbulence);
	rmSetAreaElevationVariation(plateau3ID, 7.0);
	rmSetAreaElevationMinFrequency(plateau3ID, 0.05);
	rmSetAreaElevationOctaves(plateau3ID, 3);
	rmSetAreaElevationPersistence(plateau3ID, 0.5);
//	rmSetAreaBaseHeight(plateau3ID, 5, 0.0, 0.8); 
//	rmSetAreaCliffEdge(plateau3ID, 5, 0.083, 0.0, 0.30, 1); 
	rmSetAreaCoherence(plateau3ID, 0.8);
	rmSetAreaSmoothDistance(plateau3ID, 6);
//	rmAddAreaToClass(plateau3ID, rmClassID("Cliffs"));
	rmAddAreaConstraint(plateau3ID, avoidTemplate);	
	rmAddAreaConstraint (plateau3ID, avoidImpassableLandMin);
	rmSetAreaLocation(plateau3ID, 0.0, 0.5);
	if (cNumberTeams >= 3)
		rmBuildArea(plateau3ID);
	
	int avoidPlateau3 = rmCreateAreaDistanceConstraint("avoid plateau 3", plateau3ID, 3.0);
	int stayInPlateau3 = rmCreateAreaMaxDistanceConstraint("stay in plateau 3", plateau3ID, 0.0);

	
	// Snow rim
	for(i=1; < 3)
	{
		int snowrimID = rmCreateArea("snow rim"+i);
		rmSetAreaSize(snowrimID, 0.17, 0.17); //0.08, 0.08
		rmSetAreaWarnFailure(snowrimID, false);
		rmSetAreaObeyWorldCircleConstraint(snowrimID, false);
//		rmSetAreaTerrainType(snowrimID, "araucania\ground_snow3_ara");
		rmSetAreaTerrainType(snowrimID, "great_lakes\ground_snow3_gl");
		rmAddAreaTerrainLayer(snowrimID, "great_lakes\ground_grass3_gl", 0, 2);
		rmSetAreaCoherence(snowrimID, 1.0);
		rmAddAreaConstraint(snowrimID, avoidTemplate);		
		if (i < 2)
			rmSetAreaLocation(snowrimID, 0.0, 1.0);
		else	
			rmSetAreaLocation(snowrimID, 1.0, 0.0);
		rmAddAreaConstraint(snowrimID, avoidTemplate2);
		rmAddAreaConstraint (snowrimID, avoidImpassableLand);
		if (cNumberTeams <= 2)
			rmBuildArea(snowrimID);
		rmCreateAreaDistanceConstraint("avoid snow rim "+i, snowrimID, 3.0);
		rmCreateAreaDistanceConstraint("avoid snow rim far "+i, snowrimID, 15.0);
		rmCreateAreaMaxDistanceConstraint("stay in snow rim "+i, snowrimID, 0.0);
	}
	
	int avoidSnowRim1 = rmConstraintID("avoid snow rim 1");
	int avoidSnowRim2 = rmConstraintID("avoid snow rim 2");
	int avoidSnowRim1Far = rmConstraintID("avoid snow rim far 1");
	int avoidSnowRim2Far = rmConstraintID("avoid snow rim far 2");
	int stayInSnowRim1 = rmConstraintID("stay in snow rim 1");
	int stayInSnowRim2 = rmConstraintID("stay in snow rim 2");
	
	
	// Snow rim FFA
	int snowrim3ID = rmCreateArea("snow rim FFA");
	rmSetAreaSize(snowrim3ID, 0.38, 0.38); //0.08, 0.08
	rmSetAreaWarnFailure(snowrim3ID, false);
	rmSetAreaObeyWorldCircleConstraint(snowrim3ID, false);
//	rmSetAreaTerrainType(snowrim3ID, "araucania\ground_snow3_ara");
	rmSetAreaTerrainType(snowrim3ID, "great_lakes\ground_snow3_gl");
	rmAddAreaTerrainLayer(snowrim3ID, "great_lakes\ground_grass3_gl", 0, 2);
	rmSetAreaCoherence(snowrim3ID, 1.0);
	rmAddAreaConstraint(snowrim3ID, avoidTemplate);		
	rmSetAreaLocation(snowrim3ID, 0.0, 0.5);
	rmAddAreaConstraint(snowrim3ID, avoidTemplate2);
	rmAddAreaConstraint (snowrim3ID, avoidImpassableLand);
	if (cNumberTeams >= 3)
		rmBuildArea(snowrim3ID);
			
	int avoidSnowRim3 = rmCreateAreaDistanceConstraint("avoid snow rim 3 ", snowrim3ID, 3.0);
	int avoidSnowRim3Far = rmCreateAreaDistanceConstraint("avoid snow rim far 3 ", snowrim3ID, 15.0);
	int stayInSnowRim3 = rmCreateAreaMaxDistanceConstraint("stay in snow rim 3", snowrim3ID, 0.0);

	
	// Rocky border
	for(i=1; < 3)
	{
		int borderID = rmCreateArea("border"+i);
		rmSetAreaSize(borderID, 0.10, 0.10); //0.08, 0.08
		rmSetAreaWarnFailure(borderID, false);
		rmSetAreaObeyWorldCircleConstraint(borderID, false);
		rmSetAreaCliffType(borderID, "araucania south"); //new england snow, rocky mountain edge
	//	rmSetAreaCliffPainting(borderID, false, true, true, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(borderID, "rockies\groundsnow5_roc");
		rmSetAreaCliffHeight(borderID, 7, 0.0, 0.2); 
		rmSetAreaCliffEdge(borderID, 1, 1.0, 0.0, 0.0, 1); 
		rmSetAreaCoherence(borderID, 0.5);
		rmSetAreaSmoothDistance(borderID, 4);
		rmAddAreaToClass(borderID, rmClassID("Cliffs"));
		if (i <2)
			rmSetAreaLocation(borderID, 0.0, 0.7);
		else
			rmSetAreaLocation(borderID, 1.0, 0.3);
		rmAddAreaConstraint(borderID, avoidTemplate3);
		rmAddAreaConstraint (borderID, avoidImpassableLandMin);
		if (cNumberTeams <= 2)
			rmBuildArea(borderID);
	}
	
	int avoidBorder = rmCreateAreaDistanceConstraint("avoid border", borderID, 8.0);

	
	// Rocky border FFA
	int border3ID = rmCreateArea("border FFA");
	rmSetAreaSize(border3ID, 0.23, 0.23); //0.08, 0.08
	rmSetAreaWarnFailure(border3ID, false);
	rmSetAreaObeyWorldCircleConstraint(border3ID, false);
	rmSetAreaCliffType(border3ID, "araucania south"); //new england snow, rocky mountain edge
//	rmSetAreaCliffPainting(border3ID, false, true, true, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaTerrainType(border3ID, "rockies\groundsnow5_roc");
	rmSetAreaCliffHeight(border3ID, 7, 0.0, 0.2); 
	rmSetAreaCliffEdge(border3ID, 1, 1.0, 0.0, 0.0, 1); 
	rmSetAreaCoherence(border3ID, 0.5);
	rmSetAreaSmoothDistance(border3ID, 4);
	rmAddAreaToClass(border3ID, rmClassID("Cliffs"));
	rmSetAreaLocation(border3ID, 0.0, 0.5);
	rmAddAreaConstraint(border3ID, avoidTemplate3);
	rmAddAreaConstraint (border3ID, avoidImpassableLandMin);
	if (cNumberTeams >= 3)
		rmBuildArea(border3ID);
		
	int avoidBorder3 = rmCreateAreaDistanceConstraint("avoid border 3", border3ID, 8.0);
	
	
	
	// Patches yellow flowers
	for (i=0; < 12*cNumberNonGaiaPlayers)
    {
        int patch1ID = rmCreateArea("plateau yellow patch"+i);
        rmSetAreaWarnFailure(patch1ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch1ID, false);
        rmSetAreaSize(patch1ID, rmAreaTilesToFraction(80), rmAreaTilesToFraction(120));
		rmSetAreaTerrainType(patch1ID, "great_lakes\ground_grass4_gl");
		rmPaintAreaTerrain(patch1ID);
        rmAddAreaToClass(patch1ID, rmClassID("patch"));
        rmSetAreaMinBlobs(patch1ID, 1);
        rmSetAreaMaxBlobs(patch1ID, 5);
        rmSetAreaMinBlobDistance(patch1ID, 16.0);
        rmSetAreaMaxBlobDistance(patch1ID, 40.0);
        rmSetAreaCoherence(patch1ID, 0.0);
		rmAddAreaConstraint(patch1ID, avoidImpassableLandMin);
		rmAddAreaConstraint(patch1ID, avoidPatch);
		if (cNumberTeams <= 2)
		{
			rmAddAreaConstraint(patch1ID, avoidSnowRim1Far);
			rmAddAreaConstraint(patch1ID, avoidSnowRim2Far);
		}
		else
			rmAddAreaConstraint(patch1ID, avoidSnowRim3Far);
//		rmAddAreaConstraint(patch1ID, avoidBorder);
		rmAddAreaConstraint(patch1ID, avoidCliff);
        rmBuildArea(patch1ID); 
    }
	
	// Patches white flowers
	for (i=0; < 12*cNumberNonGaiaPlayers)
    {
        int patch2ID = rmCreateArea("plateau white patch"+i);
        rmSetAreaWarnFailure(patch2ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch2ID, false);
        rmSetAreaSize(patch2ID, rmAreaTilesToFraction(80), rmAreaTilesToFraction(120));
		rmSetAreaTerrainType(patch2ID, "great_lakes\ground_grass5_gl");
		rmPaintAreaTerrain(patch2ID);
        rmAddAreaToClass(patch2ID, rmClassID("patch2"));
        rmSetAreaMinBlobs(patch2ID, 1);
        rmSetAreaMaxBlobs(patch2ID, 5);
        rmSetAreaMinBlobDistance(patch2ID, 16.0);
        rmSetAreaMaxBlobDistance(patch2ID, 40.0);
        rmSetAreaCoherence(patch2ID, 0.0);
		rmAddAreaConstraint(patch2ID, avoidImpassableLandMin);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
		if (cNumberTeams <= 2)
		{
			rmAddAreaConstraint(patch2ID, avoidSnowRim1Far);
			rmAddAreaConstraint(patch2ID, avoidSnowRim2Far);
		}
		else
			rmAddAreaConstraint(patch2ID, avoidSnowRim3Far);
//		rmAddAreaConstraint(patch2ID, avoidBorder);
		rmAddAreaConstraint(patch2ID, avoidCliff);
        rmBuildArea(patch2ID); 
    }
/*	
	// Patches snow
	for (i=0; < 30)
    {
        int patch3ID = rmCreateArea("snow patch"+i);
        rmSetAreaWarnFailure(patch3ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch3ID, false);
        rmSetAreaSize(patch3ID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(15));
		rmSetAreaTerrainType(patch3ID, "rockies\groundsnow1_roc");
		rmPaintAreaTerrain(patch3ID);
        rmAddAreaToClass(patch3ID, rmClassID("patch2"));
        rmSetAreaMinBlobs(patch3ID, 3);
        rmSetAreaMaxBlobs(patch3ID, 5);
        rmSetAreaMinBlobDistance(patch3ID, 30.0);
        rmSetAreaMaxBlobDistance(patch3ID, 40.0);
        rmSetAreaCoherence(patch3ID, 0.0);
		rmAddAreaConstraint(patch3ID, avoidImpassableLandMin);
		rmAddAreaConstraint(patch3ID, avoidPatch3);
		if (i<15)
			rmAddAreaConstraint(patch3ID, stayInSnowRim1);
		else
			rmAddAreaConstraint(patch3ID, stayInSnowRim2);
//		rmAddAreaConstraint(patch3ID, avoidBorder);
		rmAddAreaConstraint(patch3ID, avoidCliff);
        rmBuildArea(patch3ID); 
    }
*/	
	
	// Players area
	for (i=1; < cNumberPlayers)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.06, 0.06);
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
//	rmSetAreaMix(playerareaID, "rockies_snow");
	rmSetAreaLocPlayer(playerareaID, i);
	rmBuildArea(playerareaID);
	int avoidPlayerArea = rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 2.0);
	int stayInPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}

	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.40);
	
	// ******************************************** NATIVES *************************************************

	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("Nootka village 1", "native cheyenne village "+2); //+5
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
//	rmAddGroupingConstraint(nativeID0, avoidImpassableLand);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID0, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID0, avoidNatives);
	if (cNumberTeams <= 2)
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.72, 0.30);
	else
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.55, 0.38);
	
	nativeID2 = rmCreateGrouping("Klamath village 1", "native comanche village "+1); //+1
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID2, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID2, avoidNatives);
	if (cNumberTeams <= 2)
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.60, 0.50);
	else
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.40, 0.38);
	
	nativeID1 = rmCreateGrouping("Nootka village 2", "native cheyenne village "+1);
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID1, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID1, avoidNatives);
	if (cNumberTeams <= 2)
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.30, 0.70); // 
	else
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.55, 0.62); // 
	
	nativeID3 = rmCreateGrouping("Klamath village 2", "native comanche village "+2);
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
//  rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID3, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID3, avoidNatives);
	if (cNumberTeams <= 2)
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.40, 0.50); // 
	else
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.40, 0.62); //
	
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
	
	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "minetin", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 12.0);
	rmSetObjectDefMaxDistance(playergoldID, 14.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "minetin", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 40.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 42.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold2ID, avoidCliffMed);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidCenter);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 4, 4.0);
	rmSetObjectDefMinDistance(playerberriesID, 12.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreeRockies", rmRandInt(5,5), 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTreeID, avoidPlateau1);
	rmAddObjectDefConstraint(playerTreeID, avoidPlateau2);
			
	// Starting herd
	int playerherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerherdID, "bighornsheep", rmRandInt(10,10), 7.0);
	rmSetObjectDefMinDistance(playerherdID, 19.0);
	rmSetObjectDefMaxDistance(playerherdID, 20.0);
	rmSetObjectDefCreateHerd(playerherdID, true);
	rmAddObjectDefToClass(playerherdID, classStartingResource);
	rmAddObjectDefConstraint(playerherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerherdID, avoidNatives);
	rmAddObjectDefConstraint(playerherdID, avoidStartingResourcesShort);
		
	// 2nd herd
	int playerherd2ID = rmCreateObjectDef("2nd herd");
    rmAddObjectDefItem(playerherd2ID, "bighornsheep", rmRandInt(6,6), 5.0);
    rmSetObjectDefMinDistance(playerherd2ID, 45);
    rmSetObjectDefMaxDistance(playerherd2ID, 46);
	rmAddObjectDefToClass(playerherd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerherd2ID, true);
	rmAddObjectDefConstraint(playerherd2ID, avoidElk); //Short
	rmAddObjectDefConstraint(playerherd2ID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerherd2ID, avoidNatives);
	rmAddObjectDefConstraint(playerherd2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerherd2ID, avoidCliffMed);
	
/*	// 3nd herd
	int playerherd3ID = rmCreateObjectDef("3nd herd");
    rmAddObjectDefItem(playerherd3ID, "pronghorn", rmRandInt(7,7), 5.0);
    rmSetObjectDefMinDistance(playerherd3ID, 45);
    rmSetObjectDefMaxDistance(playerherd3ID, 48);
	rmAddObjectDefToClass(playerherd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerherd3ID, true);
	rmAddObjectDefConstraint(playerherd3ID, avoidRhea); //Short
	rmAddObjectDefConstraint(playerherd3ID, avoidElk);
	rmAddObjectDefConstraint(playerherd3ID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerherd3ID, avoidNatives);
	rmAddObjectDefConstraint(playerherd3ID, avoidStartingResources);
*/
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 24.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 26.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddAreaConstraint(playerNuggetID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
//	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidCliffMed);
		
	// ******** Place ********
	
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	}

	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ************************************** COMMON RESOURCES ****************************************
  
   
	// ********** Mines ***********
	
		int goldcount = 3*cNumberNonGaiaPlayers;  //

	//Mines
	for(i=0; < goldcount)
	{
		int goldID = rmCreateObjectDef("gold"+i);
		rmAddObjectDefItem(goldID, "Minetin", 1, 0.0);
		rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.10));
		rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(goldID, classGold);
		rmAddObjectDefConstraint(goldID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(goldID, avoidNatives);
		rmAddObjectDefConstraint(goldID, avoidGoldFar);
		rmAddObjectDefConstraint(goldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(goldID, avoidCliffFar);
		rmAddObjectDefConstraint(goldID, avoidEdge);
		rmPlaceObjectDefAtLoc(goldID, 0, 0.50, 0.50);
	}
		
	// ****************************
	
	// Text
	rmSetStatusText("",0.70);
	
	// ********** Forest **********
	
	// Lake forest
	int lakeforestcount = 4;
	int stayInLakeForest = -1;
	
	for (i=0; < lakeforestcount)
	{
		int lakeforestID = rmCreateArea("lake forest"+i);
		rmSetAreaWarnFailure(lakeforestID, false);
		rmSetAreaSize(lakeforestID, rmAreaTilesToFraction(110), rmAreaTilesToFraction(120));
//		rmSetAreaTerrainType(lakeforestID, "pampas\groundforest_pam");
		if (i < 2)
			rmSetAreaTerrainType(lakeforestID, "great_lakes\ground_grass2_gl");
		rmSetAreaObeyWorldCircleConstraint(lakeforestID, false);
		rmSetAreaMinBlobs(lakeforestID, 1);
		rmSetAreaMaxBlobs(lakeforestID, 5);
		rmSetAreaMinBlobDistance(lakeforestID, 16.0);
		rmSetAreaMaxBlobDistance(lakeforestID, 40.0);
		rmSetAreaCoherence(lakeforestID, 0.0);
		rmSetAreaSmoothDistance(lakeforestID, 5);
		rmAddAreaToClass(lakeforestID, classForest);
		rmAddAreaConstraint(lakeforestID, avoidForestShort);
		rmAddAreaConstraint(lakeforestID, avoidGoldTypeMin);
		rmAddAreaConstraint(lakeforestID, avoidNatives);
		rmAddAreaConstraint(lakeforestID, avoidImpassableLandMin);
		rmAddAreaConstraint(lakeforestID, avoidCliffMin);
		if (cNumberTeams <= 2)
		{
			if (i==0 || i==2)
				rmAddAreaConstraint(lakeforestID, stayNearLake1);
			else
				rmAddAreaConstraint(lakeforestID, stayNearLake2);
			if (i == 0)	
				rmAddAreaConstraint(lakeforestID, stayInPlateau1);
			else if (i == 1)
				rmAddAreaConstraint(lakeforestID, stayInPlateau2);
			if ( i >= 2)
			{
				rmAddAreaConstraint(lakeforestID, avoidPlateau1);
				rmAddAreaConstraint(lakeforestID, avoidPlateau2);
			}
		}
		else
		{
			rmAddAreaConstraint(lakeforestID, stayNearLake3);
			if (i <= 2)	
					rmAddAreaConstraint(lakeforestID, stayInPlateau3);
			else 	
				rmAddAreaConstraint(lakeforestID, avoidPlateau3);
		}
	
			
		rmBuildArea(lakeforestID);
		
		stayInLakeForest = rmCreateAreaMaxDistanceConstraint("stay in lake forest"+i, lakeforestID, 0);
		
		for (j=0; < rmRandInt(10,12)) // 20,22
		{
			int lakeforesttreeID = rmCreateObjectDef("lake forest trees"+i+j);
			if (i < 2)
				rmAddObjectDefItem(lakeforesttreeID, "TreeRockiesSnow", rmRandInt(2,3), 3.0);
			else
				rmAddObjectDefItem(lakeforesttreeID, "TreeRockies", rmRandInt(2,3), 3.0);
			rmSetObjectDefMinDistance(lakeforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(lakeforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(lakeforesttreeID, classForest);
		//	rmAddObjectDefConstraint(lakeforesttreeID, avoidForestShort);
			rmAddObjectDefConstraint(lakeforesttreeID, avoidImpassableLandMin);
			rmAddObjectDefConstraint(lakeforesttreeID, stayInLakeForest);	
			rmPlaceObjectDefAtLoc(lakeforesttreeID, 0, 0.50, 0.50);
		}
		
	}
	
	
	// Plateau forest
	int plateauforestcount = 4*cNumberNonGaiaPlayers;
	int stayInPlateauForest = -1;
	
	for (i=0; < plateauforestcount)
	{
		int plateauforestID = rmCreateArea("plateau forest"+i);
		rmSetAreaWarnFailure(plateauforestID, false);
		rmSetAreaSize(plateauforestID, rmAreaTilesToFraction(110), rmAreaTilesToFraction(120));
//		rmSetAreaTerrainType(plateauforestID, "pampas\groundforest_pam");
		rmSetAreaTerrainType(plateauforestID, "great_lakes\ground_grass2_gl");
		rmSetAreaObeyWorldCircleConstraint(plateauforestID, false);
		rmSetAreaMinBlobs(plateauforestID, 1);
		rmSetAreaMaxBlobs(plateauforestID, 5);
		rmSetAreaMinBlobDistance(plateauforestID, 16.0);
		rmSetAreaMaxBlobDistance(plateauforestID, 40.0);
		rmSetAreaCoherence(plateauforestID, 0.0);
		rmSetAreaSmoothDistance(plateauforestID, 5);
		rmAddAreaToClass(plateauforestID, classForest);
		rmAddAreaConstraint(plateauforestID, avoidForest);
		rmAddAreaConstraint(plateauforestID, avoidGoldTypeMin);
		rmAddAreaConstraint(plateauforestID, avoidStartingResources);
		rmAddAreaConstraint(plateauforestID, avoidNatives);
		rmAddAreaConstraint(plateauforestID, avoidImpassableLandMin);
		rmAddAreaConstraint(plateauforestID, avoidCliffMin);
		rmAddAreaConstraint(plateauforestID, avoidTownCenter);
		if (cNumberTeams <= 2)
		{
			if (i < plateauforestcount/2)	
				rmAddAreaConstraint(plateauforestID, stayInPlateau1);
			else 
				rmAddAreaConstraint(plateauforestID, stayInPlateau2);
		}
		else
			rmAddAreaConstraint(plateauforestID, stayInPlateau3);
			
		rmBuildArea(plateauforestID);
		
		stayInPlateauForest = rmCreateAreaMaxDistanceConstraint("stay in plateau forest"+i, plateauforestID, 0);
		
		for (j=0; < rmRandInt(9,10)) // 20,22
		{
			int plateauforesttreeID = rmCreateObjectDef("plateau forest trees"+i+j);
			rmAddObjectDefItem(plateauforesttreeID, "TreeRockiesSnow", rmRandInt(2,3), 3.0);
			rmSetObjectDefMinDistance(plateauforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(plateauforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(plateauforesttreeID, classForest);
		//	rmAddObjectDefConstraint(plateauforesttreeID, avoidForestShort);
			rmAddObjectDefConstraint(plateauforesttreeID, avoidImpassableLandMin);
			rmAddObjectDefConstraint(plateauforesttreeID, stayInPlateauForest);	
			rmPlaceObjectDefAtLoc(plateauforesttreeID, 0, 0.50, 0.50);
		}
		
	}
	
	// Valley forest
	int valleyforestcount = 3*cNumberNonGaiaPlayers;
	int stayInValleyForest = -1;
	
	for (i=0; < valleyforestcount)
	{
		int valleyforestID = rmCreateArea("valley forest"+i);
		rmSetAreaWarnFailure(valleyforestID, false);
		rmSetAreaSize(valleyforestID, rmAreaTilesToFraction(110), rmAreaTilesToFraction(120));
//		rmSetAreaTerrainType(valleyforestID, "pampas\groundforest_pam");
		rmSetAreaObeyWorldCircleConstraint(valleyforestID, false);
		rmSetAreaMinBlobs(valleyforestID, 1);
		rmSetAreaMaxBlobs(valleyforestID, 5);
		rmSetAreaMinBlobDistance(valleyforestID, 16.0);
		rmSetAreaMaxBlobDistance(valleyforestID, 35.0);
		rmSetAreaCoherence(valleyforestID, 0.0);
		rmSetAreaSmoothDistance(valleyforestID, 5);
		rmAddAreaToClass(valleyforestID, classForest);
		rmAddAreaConstraint(valleyforestID, avoidForest);
		rmAddAreaConstraint(valleyforestID, avoidGoldTypeMin);
		rmAddAreaConstraint(valleyforestID, avoidStartingResourcesShort);
		rmAddAreaConstraint(valleyforestID, avoidNativesFar);
		rmAddAreaConstraint(valleyforestID, avoidImpassableLandMin);
		rmAddAreaConstraint(valleyforestID, avoidCliffMin);
		rmAddAreaConstraint(valleyforestID, avoidTownCenter);
		if (cNumberTeams <= 2)
		{
			rmAddAreaConstraint(valleyforestID, avoidPlateau1);
			rmAddAreaConstraint(valleyforestID, avoidPlateau2);
		}
		else
			rmAddAreaConstraint(valleyforestID, avoidPlateau3);
			
		rmBuildArea(valleyforestID);
		
		stayInValleyForest = rmCreateAreaMaxDistanceConstraint("stay in valley forest"+i, valleyforestID, 0);
		
		for (j=0; < rmRandInt(9,10)) // 20,22
		{
			int valleyforesttreeID = rmCreateObjectDef("valley forest trees"+i+j);
			rmAddObjectDefItem(valleyforesttreeID, "TreeRockies", rmRandInt(2,3), 3.0);
			rmSetObjectDefMinDistance(valleyforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(valleyforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(valleyforesttreeID, classForest);
		//	rmAddObjectDefConstraint(valleyforesttreeID, avoidForestShort);
			rmAddObjectDefConstraint(valleyforesttreeID, avoidImpassableLandMin);
			rmAddObjectDefConstraint(valleyforesttreeID, stayInValleyForest);	
			rmPlaceObjectDefAtLoc(valleyforesttreeID, 0, 0.50, 0.50);
		}
		
	}
		
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ************ Herds *************

	//Elk herds
	int herdcount = 3*cNumberNonGaiaPlayers;
	
	for(i=0; < herdcount)
	{
		int elkherdID = rmCreateObjectDef("elk herd"+i);
		rmAddObjectDefItem(elkherdID, "pronghorn", rmRandInt(6,6), 5.0);
		rmSetObjectDefMinDistance(elkherdID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(elkherdID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(elkherdID, true);
		rmAddObjectDefConstraint(elkherdID, avoidImpassableLand);
		rmAddObjectDefConstraint(elkherdID, avoidNatives);
		rmAddObjectDefConstraint(elkherdID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(elkherdID, avoidForestMin);
		rmAddObjectDefConstraint(elkherdID, avoidCliffFar);
		rmAddObjectDefConstraint(elkherdID, avoidTownCenterFar);
		rmAddObjectDefConstraint(elkherdID, avoidElkFar);
		rmAddObjectDefConstraint(elkherdID, avoidEdge);
		rmPlaceObjectDefAtLoc(elkherdID, 0, 0.50, 0.50);
	}

	// ********************************
	
	// ************ Berries *************
	
	//Berries
	int berriescount = 3*cNumberNonGaiaPlayers;
	
	for(i=0; < berriescount)
	{
		int berriesID = rmCreateObjectDef("berries"+i);
		rmAddObjectDefItem(berriesID, "berrybush", rmRandInt(4,4), 5.0);
		rmSetObjectDefMinDistance(berriesID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(berriesID, true);
		rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
		rmAddObjectDefConstraint(berriesID, avoidNatives);
		rmAddObjectDefConstraint(berriesID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(berriesID, avoidForestMin);
		rmAddObjectDefConstraint(berriesID, avoidCliffFar);
		rmAddObjectDefConstraint(berriesID, avoidTownCenterFar);
		rmAddObjectDefConstraint(berriesID, avoidElkShort);
		rmAddObjectDefConstraint(berriesID, avoidBerriesFar);
		rmAddObjectDefConstraint(berriesID, avoidEdge);
		rmPlaceObjectDefAtLoc(berriesID, 0, 0.50, 0.50);
	}

	// ********************************
	
	
	// Random tree clumps
	for (i=0; < 4+cNumberNonGaiaPlayers)
	{
		int randomtreeID = rmCreateObjectDef("random tree"+i);
		rmAddObjectDefItem(randomtreeID, "TreeRockies", rmRandInt(3,5), 4.0);
		rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomtreeID, avoidNatives);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(randomtreeID, avoidElkMin);
		rmAddObjectDefConstraint(randomtreeID, avoidBerriesMin);
		rmAddObjectDefConstraint(randomtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(randomtreeID, avoidStartingResourcesShort);
		if (cNumberTeams <= 2)
		{
			rmAddObjectDefConstraint(randomtreeID, avoidPlateau1);	
			rmAddObjectDefConstraint(randomtreeID, avoidPlateau2);	
		}
		else
			rmAddObjectDefConstraint(randomtreeID, avoidPlateau3);	
		rmAddObjectDefConstraint(randomtreeID, avoidTownCenter);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50);
	}
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.90);

	// ********** Treasures ***********
	
	// Treasures 	
	int NuggetID = rmCreateObjectDef("Nugget"); 
	rmAddObjectDefItem(NuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(NuggetID, 0);
    rmSetObjectDefMaxDistance(NuggetID, rmXFractionToMeters(0.5));
	rmSetNuggetDifficulty(1,3);
	rmAddObjectDefConstraint(NuggetID, avoidNugget);
	rmAddObjectDefConstraint(NuggetID, avoidNatives);
	rmAddObjectDefConstraint(NuggetID, avoidCliffFar);
	rmAddObjectDefConstraint(NuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(NuggetID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(NuggetID, avoidElkMin);
	rmAddObjectDefConstraint(NuggetID, avoidBerriesMin);	
	rmAddObjectDefConstraint(NuggetID, avoidForestMin);	
	rmAddObjectDefConstraint(NuggetID, avoidTownCenterFar);
	rmAddObjectDefConstraint(NuggetID, avoidNatives); 
	rmAddObjectDefConstraint(NuggetID, avoidEdge);
	
	int nuggetcount = 6*cNumberNonGaiaPlayers;
	
	for (i=0; < nuggetcount)
	{
		rmPlaceObjectDefAtLoc(NuggetID, 0, 0.50, 0.50);
	}
		
	// ********************************
	
	//Fish
	int fishID = rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "Fishsalmon", rmRandInt(2,2), 8.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, avoidFish);
	rmAddObjectDefConstraint(fishID, avoidLand);
	rmAddObjectDefConstraint(fishID, avoidEdge);

	
	for (i=0; < 2+cNumberNonGaiaPlayers/2)
	{
		if (cNumberTeams <= 2)
		{
			rmPlaceObjectDefAtLoc(fishID, 0, 1.00, 0.70);
			rmPlaceObjectDefAtLoc(fishID, 0, 0.00, 0.30);
		}
		else
		{
			rmPlaceObjectDefAtLoc(fishID, 0, 1.00, 0.50);
			rmPlaceObjectDefAtLoc(fishID, 0, 1.00, 0.50);
		}
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
	
	