// GREAT LAKES
// March 2004 - JG
// Main entry point for random map script I MADE A CHANGE
//

// Modified November 16, 2005 ---> KSW
// Iroquois references changed to Huron
// Lakota references changed to Cheyenne

// Nov 06 - YP update

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

	// Choose summer or winter 
	float seasonPicker = rmRandFloat(0,1);//rmRandFloat(0,1); //high # is snow, low is spring

   //Chooses which natives appear on the map
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;
	int subCiv3=-1;
	float nativeChooser = rmRandFloat(0,1);
   if (rmAllocateSubCivs(4) == true)
   {
	   // In winter, it's all-Cree all the time.
		if (seasonPicker >= 0.5)
		{
			subCiv0=rmGetCivID("Cree");
			if (subCiv0 >= 0)
			rmSetSubCiv(0, "Cree", true);

			subCiv1=rmGetCivID("Cree");
			if (subCiv1 >= 0)
			rmSetSubCiv(1, "Cree");

			subCiv2=rmGetCivID("Cree");
			if (subCiv2 >= 0)
			rmSetSubCiv(2, "Cree");

			subCiv3=rmGetCivID("Cree");
			if (subCiv3 >= 0)
			rmSetSubCiv(3, "Cree");

		}
		// Otherwise you get a mix of Huron and Cheyenne
		else
		{
			// Huron or Cheyenne
			if (nativeChooser <= 0.5)
			{
				subCiv0=rmGetCivID("Huron");
				if (subCiv0 >= 0)
				rmSetSubCiv(0, "Huron", true);
			}
			else
			{
				subCiv0=rmGetCivID("Cheyenne");
				rmEchoInfo("subCiv0 is Cheyenne");
				if (subCiv0 >= 0)
					rmSetSubCiv(0, "Cheyenne", true);
			}
					
			subCiv1=rmGetCivID("Huron");
			if (subCiv1 >= 0)
			rmSetSubCiv(1, "Huron");
	
			subCiv2=rmGetCivID("Huron");
			if (subCiv2 >= 0)
			rmSetSubCiv(2, "Huron");
			
			if (nativeChooser <= 0.5)
			{
				subCiv3=rmGetCivID("Huron");
				if (subCiv3 >= 0)
					rmSetSubCiv(3, "Huron");
			}
			else
			{
				subCiv3=rmGetCivID("Cheyenne");
				if (subCiv3 >= 0)
					rmSetSubCiv(3, "Cheyenne");
				rmEchoInfo("subCiv3 is Cheyenne");
			}
		}
 	}

   // Picks the map size
   //int playerTiles=12000;	// old settings
	int playerTiles = 10000;
	if (cNumberNonGaiaPlayers == 2)
		playerTiles = 12000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 9000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 9000;		
 /*  if(cMapSize == 1)
   {
      playerTiles = 16000;			// DAL modified from 18K
      rmEchoInfo("Large map");
   }
 */
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.5, 3.0);  // DAL - original
	
	rmSetMapElevationHeightBlend(1);
	
	// Picks a default water height
	rmSetSeaLevel(6.0);
   
   // LIGHT SET

	if (seasonPicker < 0.5)
		rmSetLightingSet("Great Lakes");
	else
		rmSetLightingSet("Great Lakes Winter");


	// Picks default terrain and water
	if (seasonPicker < 0.5)
	{
		rmSetMapElevationParameters(cElevTurbulence, 0.05, 6, 0.7, 8.0);
		rmSetSeaType("great lakes");
		rmEnableLocalWater(false);
		rmSetBaseTerrainMix("greatlakes_grass");
		rmTerrainInitialize("great_lakes\ground_grass1_gl", 1.0);
		rmSetMapType("greatlakes");
		rmSetMapType("grass");
		rmSetMapType("water");
	}
	else
	{
		rmSetMapElevationParameters(cElevTurbulence, 0.02, 4, 0.7, 8.0);
		rmSetSeaType("great lakes");
		rmEnableLocalWater(false);
		rmSetBaseTerrainMix("greatlakes_snow");
		rmTerrainInitialize("great_lakes\ground_ice1_gl", 1.0);
		rmSetMapType("greatlakes");
		rmSetMapType("snow");
		rmSetMapType("water");
		rmSetGlobalSnow( 1.0 );
	}

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
	rmDefineClass("tradeIslands");
	int classGreatLake=rmDefineClass("great lake");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
	int longPlayerEdgeConstraint=rmCreateBoxConstraint("long avoid edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
	
	int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 20.0);
	int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 30.0);
	int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 60.0);
	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
	


	// Cardinal Directions
	int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
	int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

	// Player constraints
	int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 20.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0);  
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 40.0);  
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players short", classPlayer, 20.0);
	int avoidTradeIslands=rmCreateClassDistanceConstraint("stay away from trade islands", rmClassID("tradeIslands"), 40.0);
	int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);

	// Nature avoidance
	// int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
	
	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 40.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 40.0);
	int shortAvoidCoin=rmCreateTypeDistanceConstraint("short avoid coin", "gold", 10.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);

	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
	int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 10.0);
	int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
	int nearShore=rmCreateTerrainMaxDistanceConstraint("near shore", "water", false, 15.0);

	// Unit avoidance
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 45.0);
	int shortAvoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units short", rmClassID("startingUnit"), 10.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 30.0);
	int avoidSecrets=rmCreateClassDistanceConstraint("stuff avoids secrets", rmClassID("secrets"), 20.0);
	int avoidNuggets=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 60.0);
	int deerConstraint=rmCreateTypeDistanceConstraint("avoid the deer", "deer", 40.0);
	int shortNuggetConstraint=rmCreateTypeDistanceConstraint("avoid nugget objects", "AbstractNugget", 7.0);
	int shortDeerConstraint=rmCreateTypeDistanceConstraint("short avoid the deer", "deer", 20.0);
	int mooseConstraint=rmCreateTypeDistanceConstraint("avoid the moose", "moose", 40.0);
	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 40.0);

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

	// Trade route avoidance.
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("short trade route", 3.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
	int avoidTradeSockets = rmCreateTypeDistanceConstraint("avoid trade sockets", "sockettraderoute", 10.0);
	int farAvoidTradeSockets = rmCreateTypeDistanceConstraint("far avoid trade sockets", "sockettraderoute", 40.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
	int HCspawnLand = rmCreateTerrainDistanceConstraint("HC spawn away from land", "land", true, 12.0);

	// Lake Constraints
	int greatLakesConstraint=rmCreateClassDistanceConstraint("avoid the great lakes", classGreatLake, 5.0);
	int farGreatLakesConstraint=rmCreateClassDistanceConstraint("far avoid the great lakes", classGreatLake, 20.0);


   // -------------Define objects
   // These objects are all defined so they can be placed later


	int bisonID=rmCreateObjectDef("bison herd center");
	rmAddObjectDefItem(bisonID, "bison", rmRandInt(10,12), 6.0);
	rmSetObjectDefCreateHerd(bisonID, true);
	rmSetObjectDefMinDistance(bisonID, 0.0);
	rmSetObjectDefMaxDistance(bisonID, 5.0);
	// rmAddObjectDefConstraint(bisonID, playerConstraint);
	// rmAddObjectDefConstraint(bisonID, bisonEdgeConstraint);
	// rmAddObjectDefConstraint(bisonID, avoidResource);
	// rmAddObjectDefConstraint(bisonID, avoidImpassableLand);
	// rmAddObjectDefConstraint(bisonID, Northward);


	// wood resources
	int randomTreeID=rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "TreeGreatLakes", 1, 0.0);
	rmSetObjectDefMinDistance(randomTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomTreeID, avoidResource);
	rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);

	// -------------Done defining objects
	// Text
	rmSetStatusText("",0.10);

	// ************************ ICE LAKE *******************************

   // Place Ice sheet if Winter.

   if (seasonPicker >= 0.5)
   {
	int IceArea1ID=rmCreateArea("Ice Area 1");
	rmSetAreaSize(IceArea1ID, 0.14, 0.14);
	rmSetAreaLocation(IceArea1ID, 0.45, 0.50);
	//rmSetAreaTerrainType(IceArea1ID, "great_lakes\ground_ice1_gl");
	rmSetAreaMix(IceArea1ID, "great_lakes_ice");
	rmAddAreaToClass(IceArea1ID, classGreatLake);
	rmSetAreaBaseHeight(IceArea1ID, 0.0);
		rmAddAreaInfluencePoint(IceArea1ID, 0.55, 0.5);
		rmSetAreaObeyWorldCircleConstraint(IceArea1ID, false);
	rmSetAreaMinBlobs(IceArea1ID, 2);
	rmSetAreaMaxBlobs(IceArea1ID, 4);
	rmSetAreaMinBlobDistance(IceArea1ID, 5);
	rmSetAreaMaxBlobDistance(IceArea1ID, 8);
	rmSetAreaSmoothDistance(IceArea1ID, 8);
	rmSetAreaCoherence(IceArea1ID, 0.8);
	rmBuildArea(IceArea1ID); 
   }

// *********************************  SPRING/FROZEN LAKE  *************************************
	int michiganID=rmCreateArea("Lake Michigan 1");
      // 0.37, 0.47
	if (seasonPicker < 0.5)
	{
	rmSetAreaWaterType(michiganID, "great lakes");
	rmSetAreaSize(michiganID, 0.15, 0.15);
		if (cNumberNonGaiaPlayers >= 4)
			rmSetAreaCoherence(michiganID, 0.8);
		else
			rmSetAreaCoherence(michiganID, 0.9);
	rmSetAreaLocation(michiganID, 0.47, 0.52);
	rmAddAreaInfluencePoint(michiganID, 0.55, 0.48);
	}
	else
	{
	rmSetAreaSize(michiganID, 0.025, 0.03);
	rmSetAreaWaterType(michiganID, "great lakes ice");
	rmSetAreaCoherence(michiganID, 0.90);
	rmSetAreaLocation(michiganID, 0.50, 0.50);
	}
	rmAddAreaToClass(michiganID, classGreatLake);
	rmSetAreaBaseHeight(michiganID, 0.0);
	rmSetAreaObeyWorldCircleConstraint(michiganID, false);
	rmSetAreaMinBlobs(michiganID, 2);
	rmSetAreaMaxBlobs(michiganID, 4);
	rmSetAreaMinBlobDistance(michiganID, 5);
	rmSetAreaMaxBlobDistance(michiganID, 8);
	rmSetAreaSmoothDistance(michiganID, 0);
	rmBuildArea(michiganID); 


	
	
// ********************* create LAKE ISLANDS *********************

if (seasonPicker < 0.5)
	{
	int tradeIslandA=rmCreateArea("trade island A");
	rmSetAreaSize(tradeIslandA, rmAreaTilesToFraction(300), rmAreaTilesToFraction(300));
	rmSetAreaLocation(tradeIslandA, 0.5, 0.5);
	rmAddAreaToClass(tradeIslandA, classGreatLake);
	rmAddAreaToClass(tradeIslandA, rmClassID("tradeIslands"));
	rmSetAreaBaseHeight(tradeIslandA, 2.0);
	//if (seasonPicker < 0.5)
		rmSetAreaTerrainType(tradeIslandA, "great_lakes\ground_grass1_gl");
	//else
	//	rmSetAreaTerrainType(tradeIslandA, "great_lakes\ground_snow2_gl");
	rmSetAreaElevationType(tradeIslandA, cElevTurbulence);
	rmSetAreaMinBlobs(tradeIslandA, 3);
	rmSetAreaMaxBlobs(tradeIslandA, 5);
	rmSetAreaMinBlobDistance(tradeIslandA, 4);
	rmSetAreaMaxBlobDistance(tradeIslandA, 7);
	rmSetAreaSmoothDistance(tradeIslandA, 10);
	rmSetAreaCoherence(tradeIslandA, 0.7);
	rmBuildArea(tradeIslandA); 
	}

   //mineType = rmRandInt(1,10);
  
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
    
    if(seasonPicker > 0.5) {
      ypKingsHillLandfill(.5, .5, rmAreaTilesToFraction(625), 1.5, "greatlakes_snow", 0);
      ypKingsHillPlacer(.5, .5, 0.0, 0);
    }
    
    else {
      ypKingsHillPlacer(.5, .5, 0.05, 0);
    }
    
    rmEchoInfo("XLOC = "+.5);
    rmEchoInfo("YLOC = "+.5);
  }
  
  else {
    int islandSilverID = rmCreateObjectDef("island silver");
    rmAddObjectDefItem(islandSilverID, "mine", rmRandInt(1,2), 5.0);
    rmSetObjectDefMinDistance(islandSilverID, 0.0);
    rmSetObjectDefMaxDistance(islandSilverID, 10.0);
    rmAddObjectDefConstraint(islandSilverID, avoidImpassableLand);
    rmPlaceObjectDefAtLoc(islandSilverID, 0, 0.5, 0.5);


    int avoidIslandTrees=rmCreateTypeDistanceConstraint("avoid Island Trees", "TreeGreatLakes", 4.0);
    int avoidIslandSilver=rmCreateTypeDistanceConstraint("avoid Island Silver", "mine", 6.0);

    int islandTreeID = rmCreateObjectDef("island trees");
    if (seasonPicker < 0.5)
      rmAddObjectDefItem(islandTreeID, "TreeGreatLakes", rmRandInt(5,7), 7.0);
    else
      rmAddObjectDefItem(islandTreeID, "TreeGreatLakesSnow", rmRandInt(2,3), 7.0);
    rmAddObjectDefConstraint(islandTreeID, avoidImpassableLand);
    rmAddObjectDefConstraint(islandTreeID, avoidIslandTrees);
    rmAddObjectDefConstraint(islandTreeID, avoidIslandSilver);
    rmSetObjectDefMinDistance(islandTreeID, 0.0);
    rmSetObjectDefMaxDistance(islandTreeID, 20.0);
    rmPlaceObjectDefAtLoc(islandTreeID, 0, 0.5, 0.5, 2);
    
    int islandNuggetID = rmCreateObjectDef("island nuggets");
    rmAddObjectDefItem(islandNuggetID, "nugget", 1, 3.0);
    rmAddObjectDefConstraint(islandNuggetID, avoidImpassableLand);
    rmAddObjectDefConstraint(islandNuggetID, avoidIslandTrees);
    rmAddObjectDefConstraint(islandNuggetID, avoidIslandSilver);
    rmAddObjectDefConstraint(islandNuggetID, shortNuggetConstraint);
    rmAddObjectDefToClass(islandNuggetID, rmClassID("nuggets"));
    rmSetObjectDefMinDistance(islandNuggetID, 0.0);
    rmSetObjectDefMaxDistance(islandNuggetID, 20.0);
    rmPlaceObjectDefAtLoc(islandNuggetID, 0, 0.5, 0.5, 1);
  }

//}

	// **************************** PLACE TRADE ROUTE ***************************


	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 6.0);
	rmAddObjectDefConstraint(socketID, shortAvoidTradeRoute);

	int tradeRouteID = rmCreateTradeRoute();
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.08, 0.55); // -1
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.20, 0.83, 2, 3); // -2
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.45, 0.93, 2, 3); // -3
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.67, 0.89, 2, 3); // -4
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.78, 0.78, 2, 3); // -5
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.84, 0.70, 2, 3);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.86, 0.68, 2, 3);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.88, 0.40, 2, 3); // -6
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.81, 0.23, 2, 3); // -7
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.70, 0.10, 2, 3); // -8
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.50, 0.08, 2, 3); // -9
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.30, 0.15, 2, 3); // -10
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.15, 0.23, 2, 3); // -11
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.08, 0.55, 2, 3); // -12
	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
	if(placedTradeRoute == false)
		rmEchoError("Failed to place trade route #1");

		rmPlaceObjectDefAtLoc(socketID, 0, 0.22, 0.83); // -2
		rmPlaceObjectDefAtLoc(socketID, 0, 0.59, 0.88); // -4
		//rmPlaceObjectDefAtLoc(socketID, 0, 0.92, 0.40); // -6 
		//rmPlaceObjectDefAtLoc(socketID, 0, 0.70, 0.08); // -8
		rmPlaceObjectDefAtLoc(socketID, 0, 0.17, 0.24); // -11
		//rmPlaceObjectDefAtLoc(socketID, 0, 0.45, 0.93); //-3
		rmPlaceObjectDefAtLoc(socketID, 0, 0.86, 0.68); //-5
		//rmPlaceObjectDefAtLoc(socketID, 0, 0.88, 0.70);
		//rmPlaceObjectDefAtLoc(socketID, 0, 0.90, 0.68);
		rmPlaceObjectDefAtLoc(socketID, 0, 0.85, 0.23); //-7
		rmPlaceObjectDefAtLoc(socketID, 0, 0.45, 0.08); //-9
		//rmPlaceObjectDefAtLoc(socketID, 0, 0.30, 0.13); //-10
		//rmPlaceObjectDefAtLoc(socketID, 0, 0.08, 0.55); //-12
		

// *********************************** PLACE PLAYERS ************************************
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

	if ( cNumberTeams <= 2 && teamZeroCount <= 4 && teamOneCount <= 4)
	{
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.7, 0.9); // 0.5
		rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.30, 0.32, 0);
			
		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.2, 0.4); // 0.5
		rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.30, 0.32, 0);
	}
	else
	{
		rmSetTeamSpacingModifier(0.7);
		rmPlacePlayersCircular(0.32, 0.34, 0.0);
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
      rmAddAreaConstraint(id, playerEdgeConstraint); 
//		rmAddAreaConstraint(id, avoidWater);
		rmAddAreaConstraint(id, longAvoidImpassableLand);
		rmSetAreaLocPlayer(id, i);
		rmSetAreaWarnFailure(id, false);
   }

	// Build the areas.
	rmBuildAllAreas();
		
	int startingTCID= rmCreateObjectDef("startingTC");
	if (rmGetNomadStart())
		{
			rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 5.0);
		}
		else
		{
            rmAddObjectDefItem(startingTCID, "townCenter", 1, 5.0);
		}
	rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
	rmAddObjectDefToClass(startingTCID, rmClassID("player"));

	//rmPlaceObjectDefPerPlayer(startingTCID, true);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 10.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	if (seasonPicker < 0.5)
		rmAddObjectDefItem(StartAreaTreeID, "TreeGreatLakes", 3, 4.0);
	else
		rmAddObjectDefItem(StartAreaTreeID, "TreeGreatLakesSnow", 3, 4.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 12);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 16);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidNatives);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidStartingUnits);


  int berry = 0;
	int StartElkID=rmCreateObjectDef("starting moose");
	if (seasonPicker < 0.5){
		rmAddObjectDefItem(StartElkID, "berrybush", 4, 4.0);
  }
	else
	{
		rmAddObjectDefItem(StartElkID, "moose", 3, 4.0);
    berry = 1;
		rmSetObjectDefCreateHerd(StartElkID, true);
	}
	rmSetObjectDefCreateHerd(StartElkID, true);
	rmSetObjectDefMinDistance(StartElkID, 13);
	rmSetObjectDefMaxDistance(StartElkID, 22);
	rmAddObjectDefConstraint(StartElkID, avoidStartResource);
	rmAddObjectDefConstraint(StartElkID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartElkID, avoidNatives);
	//rmAddObjectDefConstraint(StartElkID, deerAvoidDeer);
	//rmAddObjectDefConstraint(StartElkID, shortPlayerConstraint);

	int startSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(startSilverID, "mine", 1, 5.0);
	rmAddObjectDefConstraint(startSilverID, avoidTradeRoute);
	rmAddObjectDefConstraint(startSilverID, greatLakesConstraint);
	rmSetObjectDefMinDistance(startSilverID, 12.0);
	rmSetObjectDefMaxDistance(startSilverID, 18.0);
	rmAddObjectDefConstraint(startSilverID, avoidStartResource);
	//rmAddObjectDefConstraint(startSilverID, avoidAll);
	rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);

	int waterSpawnFlagID = rmCreateObjectDef("water spawn flag");
	rmAddObjectDefItem(waterSpawnFlagID, "HomeCityWaterSpawnFlag", 1, 0);
	rmSetObjectDefMinDistance(waterSpawnFlagID, rmXFractionToMeters(0.10));
	rmSetObjectDefMaxDistance(waterSpawnFlagID, rmXFractionToMeters(0.19));
	rmAddObjectDefConstraint(waterSpawnFlagID, HCspawnLand);
	
	 
   // Set up for finding closest land points.
	int avoidHCFlags=rmCreateHCGPConstraint("avoid HC flags", 20);
	rmAddClosestPointConstraint(avoidImpassableLand);
	rmAddClosestPointConstraint(avoidTradeIslands);
	rmAddClosestPointConstraint(avoidHCFlags);

	for(i=1; <cNumberPlayers)
	{
	int colonyShipID=rmCreateObjectDef("colony ship "+i);
	if(rmGetPlayerCiv(i) == rmGetCivID("Ottomans"))
    rmAddObjectDefItem(colonyShipID, "Galley", 1, 0.0);
    else
    rmAddObjectDefItem(colonyShipID, "Caravel", 1, 0.0);
	rmSetObjectDefGarrisonStartingUnits(colonyShipID, true);
	rmSetObjectDefMinDistance(colonyShipID, 0.0);
	rmSetObjectDefMaxDistance(colonyShipID, 10.0);
		
						
		// Test of Marcin's Starting Units stuff...
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, berry), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartElkID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startSilverID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (seasonPicker < 0.5)
		{
		rmPlaceObjectDefAtLoc(waterSpawnFlagID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		//vector blockLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(blockID, i));
		//rmSetHomeCityWaterSpawnPoint(i, blockLocation);
		}
		//vector closestPointB=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
		//rmSetHomeCityGatherPoint(i, closestPointB);

	}
   // Clear out constraints for good measure.
   //rmClearClosestPointConstraints();


	
	// Make some terrain patches 
	/*
	for (i=0; < 50)
      {
         int patch=rmCreateArea("first patch "+i);
         rmSetAreaWarnFailure(patch, false);
         rmSetAreaSize(patch, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
		 if (seasonPicker < 0.5)
			rmSetAreaTerrainType(patch, "great_lakes\ground_grass1_gl");
		 else
			rmSetAreaTerrainType(patch, "yukon\ground2_yuk");
         // rmAddAreaTerrainLayer(patch, "saguenay\ground4_sag", 0, 1);
         rmAddAreaToClass(patch, rmClassID("classPatch"));
         rmSetAreaMinBlobs(patch, 1);
         rmSetAreaMaxBlobs(patch, 5);
         rmSetAreaMinBlobDistance(patch, 10.0);
         rmSetAreaMaxBlobDistance(patch, 30.0);
         rmSetAreaCoherence(patch, 0.7);
			rmAddAreaConstraint(patch, shortAvoidImpassableLand);
			//rmAddAreaConstraint(patch, avoidTradeRoute);
         rmBuildArea(patch); 
      }
*/
	// Text
   rmSetStatusText("",0.20);

   // Text
   rmSetStatusText("",0.30);

	// Text
	rmSetStatusText("",0.50);
	int numTries = -1;
	int failCount = -1;

	// Define and place the Native Villages
	
	float NativeVillageLoc = rmRandFloat(0,1);
	float huronVillageLoc = rmRandFloat(0,1);

	// 
	if (subCiv0 == rmGetCivID("Cree"))
	{
		int cree1VillageID = -1;
		int cree1VillageType = rmRandInt(1,5);
		cree1VillageID = rmCreateGrouping("cree1 village", "native cree village "+cree1VillageType);
		rmSetGroupingMinDistance(cree1VillageID, 0.0);
		rmSetGroupingMaxDistance(cree1VillageID, 30.0);
		rmAddGroupingConstraint(cree1VillageID, greatLakesConstraint);
		rmAddGroupingConstraint(cree1VillageID, nearShore);
		rmAddGroupingConstraint(cree1VillageID, mediumPlayerConstraint);
		rmAddGroupingConstraint(cree1VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(cree1VillageID, avoidTradeSockets);
		rmAddGroupingToClass(cree1VillageID, rmClassID("natives"));
		rmAddGroupingToClass(cree1VillageID, rmClassID("importantItem"));

		if ( huronVillageLoc < 0.5 )
		{
			rmPlaceGroupingAtLoc(cree1VillageID, 0, 0.5, 0.25);
		}
		else
		{
			rmPlaceGroupingAtLoc(cree1VillageID, 0, 0.5, 0.25);
		}
	}
	else if (subCiv0 == rmGetCivID("Huron"))
	{  
		int huron1VillageID = -1;
		int huron1VillageType = rmRandInt(1,5);
		huron1VillageID = rmCreateGrouping("huron1 village", "native huron village "+huron1VillageType);
		rmSetGroupingMinDistance(huron1VillageID, 0.0);
		rmSetGroupingMaxDistance(huron1VillageID, 30.0);
		rmAddGroupingConstraint(huron1VillageID, greatLakesConstraint);
		rmAddGroupingConstraint(huron1VillageID, nearShore);
		rmAddGroupingConstraint(huron1VillageID, mediumPlayerConstraint);
		rmAddGroupingConstraint(huron1VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(huron1VillageID, avoidTradeSockets);
		rmAddGroupingToClass(huron1VillageID, rmClassID("natives"));
		rmAddGroupingToClass(huron1VillageID, rmClassID("importantItem"));

		if ( huronVillageLoc < 0.5 )
		{
			rmPlaceGroupingAtLoc(huron1VillageID, 0, 0.5, 0.25);
		}
		else
		{
			rmPlaceGroupingAtLoc(huron1VillageID, 0, 0.5, 0.25);
		}
	}
	else
	{  
		int cheyenneVillageID = -1;
		int cheyenne1VillageType = rmRandInt(1,5);
		cheyenneVillageID = rmCreateGrouping("cheyenne village", "native cheyenne village "+cheyenne1VillageType);
		rmSetGroupingMinDistance(cheyenneVillageID, 0.0);
		rmSetGroupingMaxDistance(cheyenneVillageID, 30.0);
		rmAddGroupingConstraint(cheyenneVillageID, greatLakesConstraint);
		rmAddGroupingConstraint(cheyenneVillageID, nearShore);
		rmAddGroupingConstraint(cheyenneVillageID, shortAvoidStartingUnits);
		rmAddGroupingConstraint(cheyenneVillageID, avoidTradeRoute);
		rmAddGroupingConstraint(cheyenneVillageID, avoidTradeSockets);
		rmAddGroupingToClass(cheyenneVillageID, rmClassID("natives"));
		rmAddGroupingToClass(cheyenneVillageID, rmClassID("importantItem"));

		if ( huronVillageLoc < 0.5 )
		{
			rmPlaceGroupingAtLoc(cheyenneVillageID, 0, 0.5, 0.25);
		}
		else
		{
			rmPlaceGroupingAtLoc(cheyenneVillageID, 0, 0.5, 0.25);
		}
	}

	if ( cNumberNonGaiaPlayers >= 4 )
	{
		if (subCiv1 == rmGetCivID("huron"))
		{
			int huron2VillageID = -1;
			int huron2VillageType = rmRandInt(1,5);
			huron2VillageID = rmCreateGrouping("huron2 village", "native huron village "+huron2VillageType);
			rmSetGroupingMinDistance(huron2VillageID, 0.0);
			rmSetGroupingMaxDistance(huron2VillageID, 40.0);
			rmAddGroupingConstraint(huron2VillageID, avoidImpassableLand);
			rmAddGroupingConstraint(huron2VillageID, avoidTradeRoute);
			rmAddGroupingConstraint(huron2VillageID, shortAvoidStartingUnits);
			rmAddGroupingConstraint(huron2VillageID, avoidTradeSockets);
			rmAddGroupingToClass(huron2VillageID, rmClassID("natives"));
			rmAddGroupingToClass(huron2VillageID, rmClassID("importantItem"));
			rmAddGroupingConstraint(huron2VillageID, avoidImportantItem);
			if (NativeVillageLoc < 0.5)
			{
			rmPlaceGroupingAtLoc(huron2VillageID, 0, 0.05, 0.60);
			}
			else
			{
			rmPlaceGroupingAtLoc(huron2VillageID, 0, 0.05, 0.60);
			}
		}
		else
		{
			int cree2VillageID = -1;
			int cree2VillageType = rmRandInt(1,5);
			cree2VillageID = rmCreateGrouping("cree2 village", "native cree village "+cree2VillageType);
			rmSetGroupingMinDistance(cree2VillageID, 0.0);
			rmSetGroupingMaxDistance(cree2VillageID, 40.0);
			rmAddGroupingConstraint(cree2VillageID, avoidImpassableLand);
			rmAddGroupingConstraint(cree2VillageID, avoidTradeRoute);
			rmAddGroupingConstraint(cree2VillageID, shortAvoidStartingUnits);
			rmAddGroupingConstraint(cree2VillageID, avoidTradeSockets);
			rmAddGroupingToClass(cree2VillageID, rmClassID("natives"));
			rmAddGroupingToClass(cree2VillageID, rmClassID("importantItem"));
			rmAddGroupingConstraint(cree2VillageID, avoidImportantItem);
			if (NativeVillageLoc < 0.5)
			{
			rmPlaceGroupingAtLoc(cree2VillageID, 0, 0.05, 0.60);
			}
			else
			{
			rmPlaceGroupingAtLoc(cree2VillageID, 0, 0.05, 0.60);
			}
		}
		
		if (subCiv2 == rmGetCivID("huron"))
		{
			int huron3VillageID = -1;
			int huron3VillageType = rmRandInt(1,5);
			huron3VillageID = rmCreateGrouping("huron3 village", "native huron village "+huron3VillageType);
			rmSetGroupingMinDistance(huron3VillageID, 0.0);
			rmSetGroupingMaxDistance(huron3VillageID, 40.0);
			rmAddGroupingConstraint(huron3VillageID, avoidImpassableLand);
			rmAddGroupingConstraint(huron3VillageID, avoidTradeRoute);
			rmAddGroupingConstraint(huron3VillageID, shortAvoidStartingUnits);
			rmAddGroupingConstraint(huron3VillageID, avoidTradeSockets);
			rmAddGroupingToClass(huron3VillageID, rmClassID("natives"));
			rmAddGroupingToClass(huron3VillageID, rmClassID("importantItem"));
			rmAddGroupingConstraint(huron3VillageID, avoidImportantItem);
			if (NativeVillageLoc < 0.5)
			{
			rmPlaceGroupingAtLoc(huron3VillageID, 0, 0.99, 0.45);
			}
			else
			{
			rmPlaceGroupingAtLoc(huron3VillageID, 0, 0.99, 0.45);
			}
		}
		else
		{
			int cree3VillageID = -1;
			int cree3VillageType = rmRandInt(1,5);
			cree3VillageID = rmCreateGrouping("cree3 village", "native cree village "+cree3VillageType);
			rmSetGroupingMinDistance(cree3VillageID, 0.0);
			rmSetGroupingMaxDistance(cree3VillageID, 40.0);
			rmAddGroupingConstraint(cree3VillageID, avoidImpassableLand);
			rmAddGroupingConstraint(cree3VillageID, avoidTradeRoute);
			rmAddGroupingConstraint(cree3VillageID, shortAvoidStartingUnits);
			rmAddGroupingConstraint(cree3VillageID, avoidTradeSockets);
			rmAddGroupingToClass(cree3VillageID, rmClassID("natives"));
			rmAddGroupingToClass(cree3VillageID, rmClassID("importantItem"));
			rmAddGroupingConstraint(cree3VillageID, avoidImportantItem);
			if (NativeVillageLoc < 0.5)
			{
			rmPlaceGroupingAtLoc(cree3VillageID, 0, 0.99, 0.45);
			}
			else
			{
			rmPlaceGroupingAtLoc(cree3VillageID, 0, 0.99, 0.45);
			}
		}
	}
	
	if (subCiv3 == rmGetCivID("Cree"))
	{
		int cree4VillageID = -1;
		int cree4VillageType = rmRandInt(1,5);
		cree4VillageID = rmCreateGrouping("cree4 village", "native cree village "+cree4VillageType);
		rmSetGroupingMinDistance(cree4VillageID, 0.0);
		rmSetGroupingMaxDistance(cree4VillageID, 20.0);
		rmAddGroupingConstraint(cree4VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(cree4VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(cree4VillageID, shortAvoidStartingUnits);
		rmAddGroupingConstraint(cree4VillageID, avoidTradeSockets);
		rmAddGroupingToClass(cree4VillageID, rmClassID("natives"));
		rmAddGroupingToClass(cree4VillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(cree4VillageID, avoidImportantItem);
		rmAddGroupingConstraint(cree4VillageID, avoidNatives);

		if (NativeVillageLoc < 0.5)
		{
		  rmPlaceGroupingAtLoc(cree4VillageID, 0, 0.60, 0.77);
		}
		else
		{
		  rmPlaceGroupingAtLoc(cree4VillageID, 0, 0.60, 0.77);
		}
	}
	else if (subCiv3 == rmGetCivID("Huron"))
	{   
		int huron4VillageID = -1;
		int huron4VillageType = rmRandInt(1,5);
		huron4VillageID = rmCreateGrouping("huron4 village", "native huron village "+huron4VillageType);
		rmSetGroupingMinDistance(huron4VillageID, 0.0);
		rmSetGroupingMaxDistance(huron4VillageID, 20.0);
		rmAddGroupingConstraint(huron4VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(huron4VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(huron4VillageID, shortAvoidStartingUnits);
		rmAddGroupingConstraint(huron4VillageID, avoidTradeSockets);
		rmAddGroupingToClass(huron4VillageID, rmClassID("natives"));
		rmAddGroupingToClass(huron4VillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(huron4VillageID, avoidImportantItem);
		rmAddGroupingConstraint(huron4VillageID, avoidNatives);

		if (NativeVillageLoc < 0.5)
		{
		  rmPlaceGroupingAtLoc(huron4VillageID, 0, 0.60, 0.77);
		}
		else
		{
		  rmPlaceGroupingAtLoc(huron4VillageID, 0, 0.60, 0.77);
		}
	}
	else
	{   
		int cheyenne2VillageID = -1;
		int cheyenne2VillageType = rmRandInt(1,5);
		cheyenne2VillageID = rmCreateGrouping("cheyenne2 village", "native cheyenne village "+cheyenne2VillageType);
		rmSetGroupingMinDistance(cheyenne2VillageID, 0.0);
		rmSetGroupingMaxDistance(cheyenne2VillageID, 20.0);
		rmAddGroupingConstraint(cheyenne2VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(cheyenne2VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(cheyenne2VillageID, shortAvoidStartingUnits);
		rmAddGroupingConstraint(cheyenne2VillageID, avoidTradeSockets);
		rmAddGroupingToClass(cheyenne2VillageID, rmClassID("natives"));
		rmAddGroupingToClass(cheyenne2VillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(cheyenne2VillageID, avoidImportantItem);
		rmAddGroupingConstraint(cheyenne2VillageID, avoidNatives);

		if (NativeVillageLoc < 0.5)
		{
		  rmPlaceGroupingAtLoc(cheyenne2VillageID, 0, 0.60, 0.77);
		}
		else
		{
		  rmPlaceGroupingAtLoc(cheyenne2VillageID, 0, 0.60, 0.77);
		}
	}


// Silver mines
   int mineType = -1;
   int mineID = -1;
	int silverTries=5*cNumberNonGaiaPlayers;
   

	int silverMineID = rmCreateObjectDef("silver mines");
	rmAddObjectDefItem(silverMineID, "mine", rmRandInt(1,1), 5.0);
	rmSetObjectDefMinDistance(silverMineID, 0.0);
	rmSetObjectDefMaxDistance(silverMineID, rmXFractionToMeters(0.44));
	rmAddObjectDefConstraint(silverMineID, avoidImpassableLand);
	rmAddObjectDefConstraint(silverMineID, greatLakesConstraint);
	rmAddObjectDefConstraint(silverMineID, avoidCoin);
	rmAddObjectDefConstraint(silverMineID, playerConstraint);
	rmAddObjectDefConstraint(silverMineID, avoidAll);
	rmAddObjectDefConstraint(silverMineID, avoidTradeRoute);
	rmAddObjectDefConstraint(silverMineID, avoidTradeSockets);
   for(i=0; <silverTries)
   {
		//mineType = rmRandInt(1,10);
		rmPlaceObjectDefAtLoc(silverMineID, 0, 0.5, 0.5);

/*
		int silverMineID = rmCreateGrouping("silver mines"+i, "resource silver ore "+mineType);
		rmSetGroupingMinDistance(silverMineID, 0.0);
		rmSetGroupingMaxDistance(silverMineID, rmXFractionToMeters(0.50));
		rmAddGroupingConstraint(silverMineID, avoidCoin);
		
		rmAddGroupingConstraint(silverMineID, avoidImpassableLand);
		rmAddGroupingConstraint(silverMineID, avoidTradeRoute);
		rmAddGroupingConstraint(silverMineID, avoidTradeSockets);
		rmAddGroupingConstraint(silverMineID, greatLakesConstraint);
		rmAddGroupingConstraint(silverMineID, avoidAll);
		rmAddObjectDefConstraint(silverMineID, longPlayerEdgeConstraint);
		//rmAddGroupingConstraint(silverMineID, farGreatLakesConstraint);
		rmPlaceGroupingAtLoc(silverMineID, 0, 0.5, 0.5);
*/
   }



// Define and place forests - north and south
	int forestTreeID = 0;
	
	numTries=5*cNumberNonGaiaPlayers;  // DAL - 4 here, 4 below
	failCount=0;
	for (i=0; <numTries)
		{   
			int northForest=rmCreateArea("northforest"+i);
			rmSetAreaWarnFailure(northForest, false);
			rmSetAreaSize(northForest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(400));
			if (seasonPicker < 0.5)
				rmSetAreaForestType(northForest, "great lakes forest");
			else
				rmSetAreaForestType(northForest, "great lakes forest snow");
			rmSetAreaForestDensity(northForest, 1.0);
			rmAddAreaToClass(northForest, rmClassID("classForest"));
			rmSetAreaForestClumpiness(northForest, 0.0);		//DAL more forest with more clumps
			rmSetAreaForestUnderbrush(northForest, 0.0);
			rmSetAreaBaseHeight(northForest, 2.0);
			rmSetAreaMinBlobs(northForest, 1);
			rmSetAreaMaxBlobs(northForest, 3);					//DAL was 5
			rmSetAreaMinBlobDistance(northForest, 16.0);
			rmSetAreaMaxBlobDistance(northForest, 30.0);
			rmSetAreaCoherence(northForest, 0.4);
			rmSetAreaSmoothDistance(northForest, 1);
			rmAddAreaConstraint(northForest, avoidImportantItem);		   // DAL added, to try and make sure natives got on the map w/o override.
			rmAddAreaConstraint(northForest, avoidTradeRoute);
			rmAddAreaConstraint(northForest, avoidTradeSockets);
			rmAddAreaConstraint(northForest, greatLakesConstraint);
			rmAddAreaConstraint(northForest, playerConstraintForest);		// DAL adeed, to keep forests away from the player.
			rmAddAreaConstraint(northForest, forestConstraint);   // DAL adeed, to keep forests away from each other.
			rmAddAreaConstraint(northForest, Northward);				// DAL adeed, to keep forests in the north.
			if(rmBuildArea(northForest)==false)
			{
				// Stop trying once we fail 5 times in a row.  
				failCount++;
				if(failCount==5)
					break;
			}
			else
				failCount=0; 
		}

	
	numTries=5*cNumberNonGaiaPlayers;  // DAL - 4 here, 4 above.
	failCount=0;
	for (i=0; <numTries)
		{   
			int southForest=rmCreateArea("southforest"+i);
			rmSetAreaWarnFailure(southForest, false);
			rmSetAreaSize(southForest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
			if (seasonPicker < 0.5)
				rmSetAreaForestType(southForest, "great lakes forest");
			else
				rmSetAreaForestType(southForest, "great lakes forest snow");
			rmSetAreaForestDensity(southForest, 1.0);
			rmAddAreaToClass(southForest, rmClassID("classForest"));
			rmSetAreaForestClumpiness(southForest, 0.0);		//DAL more forest with more clumps
			rmSetAreaForestUnderbrush(southForest, 0.0);
			rmSetAreaBaseHeight(southForest, 2.0);
			rmSetAreaMinBlobs(southForest, 1);
			rmSetAreaMaxBlobs(southForest, 3);						//DAL was 5
			rmSetAreaMinBlobDistance(southForest, 16.0);
			rmSetAreaMaxBlobDistance(southForest, 30.0);
			rmSetAreaCoherence(southForest, 0.4);
			rmSetAreaSmoothDistance(southForest, 1);
			rmAddAreaConstraint(southForest, avoidImportantItem); // DAL added, to try and make sure natives got on the map w/o override.
			rmAddAreaConstraint(southForest, avoidTradeRoute);
			rmAddAreaConstraint(southForest, avoidTradeSockets);
			rmAddAreaConstraint(southForest, greatLakesConstraint);
			rmAddAreaConstraint(southForest, playerConstraintForest);   // DAL adeed, to keep forests away from the player.
			rmAddAreaConstraint(southForest, forestConstraint);   // DAL adeed, to keep forests away from each other.
			rmAddAreaConstraint(southForest, Southward);				// DAL adeed, to keep forests in the south.
			if(rmBuildArea(southForest)==false)
			{
				// Stop trying once we fail 5 times in a row.  
				failCount++;
				if(failCount==5)
					break;
			}
			else
				failCount=0; 
		} 



  

   
// Place some extra deer herds.  
	int deerHerdID=rmCreateObjectDef("northern deer herd");
	rmAddObjectDefItem(deerHerdID, "deer", rmRandInt(7,9), 6.0);
	rmSetObjectDefCreateHerd(deerHerdID, true);
	rmSetObjectDefMinDistance(deerHerdID, 0.0);
	rmSetObjectDefMaxDistance(deerHerdID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(deerHerdID, shortAvoidCoin);
	rmAddObjectDefConstraint(deerHerdID, avoidTradeRoute);
	rmAddObjectDefConstraint(deerHerdID, shortPlayerConstraint);
	if (seasonPicker < 0.5)
		rmAddObjectDefConstraint(deerHerdID, greatLakesConstraint);
	rmAddObjectDefConstraint(deerHerdID, avoidAll);
	rmAddObjectDefConstraint(deerHerdID, avoidImpassableLand);
	rmAddObjectDefConstraint(deerHerdID, deerConstraint);
	rmAddObjectDefConstraint(deerHerdID, Northward);
	numTries=3*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(deerHerdID, 0, 0.5, 0.5);
	}
	// Text
	rmSetStatusText("",0.70);

	int deerHerdID2=rmCreateObjectDef("southern deer herd");
	rmAddObjectDefItem(deerHerdID2, "deer", rmRandInt(7,9), 6.0);
	rmSetObjectDefCreateHerd(deerHerdID2, true);
	rmSetObjectDefMinDistance(deerHerdID2, 0.0);
	rmSetObjectDefMaxDistance(deerHerdID2, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(deerHerdID2, shortAvoidCoin);
	rmAddObjectDefConstraint(deerHerdID2, shortPlayerConstraint);
	rmAddObjectDefConstraint(deerHerdID2, avoidTradeRoute);
	if (seasonPicker < 0.5)
		rmAddObjectDefConstraint(deerHerdID2, greatLakesConstraint);
	rmAddObjectDefConstraint(deerHerdID2, avoidAll);
	rmAddObjectDefConstraint(deerHerdID2, avoidImpassableLand);
	rmAddObjectDefConstraint(deerHerdID2, deerConstraint);
	rmAddObjectDefConstraint(deerHerdID2, Southward);
	numTries=3*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(deerHerdID2, 0, 0.5, 0.5);
	}
	// Text
	


// Place some extra deer herds.  
	int mooseHerdID=rmCreateObjectDef("moose herd");
	rmAddObjectDefItem(mooseHerdID, "moose", rmRandInt(2,3), 6.0);
	rmSetObjectDefCreateHerd(mooseHerdID, true);
	rmSetObjectDefMinDistance(mooseHerdID, 0.0);
	rmSetObjectDefMaxDistance(mooseHerdID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(mooseHerdID, shortAvoidCoin);
	if (seasonPicker < 0.5)
		rmAddObjectDefConstraint(mooseHerdID, greatLakesConstraint);
	rmAddObjectDefConstraint(mooseHerdID, avoidAll);
	rmAddObjectDefConstraint(mooseHerdID, shortPlayerConstraint);
	rmAddObjectDefConstraint(mooseHerdID, avoidTradeRoute);
	rmAddObjectDefConstraint(mooseHerdID, avoidImpassableLand);
//	rmAddObjectDefConstraint(mooseHerdID, Northward);
	rmAddObjectDefConstraint(mooseHerdID, mooseConstraint);
	rmAddObjectDefConstraint(mooseHerdID, shortDeerConstraint);
	numTries=3*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(mooseHerdID, 0, 0.5, 0.5);
	}
	// Text
	rmSetStatusText("",0.90);


	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
	

	int fishID=rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "FishSalmon", 3, 4.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishLand);
   	if (seasonPicker < 0.5)
		rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	



	// rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);  //DAL used to be 18.



	// Define and place decorations: rocks and grass and stuff 

	int rockID=rmCreateObjectDef("lone rock");
	int avoidRock=rmCreateTypeDistanceConstraint("avoid rock", "underbrushTexasGrass", 8.0);
	rmAddObjectDefItem(rockID, "underbrushTexasGrass", 1, 0.0);
	rmSetObjectDefMinDistance(rockID, 0.0);
	rmSetObjectDefMaxDistance(rockID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rockID, avoidAll);
	rmAddObjectDefConstraint(rockID, farGreatLakesConstraint);
	rmAddObjectDefConstraint(rockID, avoidImpassableLand);
	rmAddObjectDefConstraint(rockID, avoidRock);
	//rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 15*cNumberNonGaiaPlayers);

	int Grass=rmCreateObjectDef("grass");
	rmAddObjectDefItem(Grass, "underbrushTexasGrass", 1, 0.0);
	rmSetObjectDefMinDistance(Grass, 0.0);
	rmSetObjectDefMaxDistance(Grass, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(Grass, avoidAll);
	rmAddObjectDefConstraint(Grass, farGreatLakesConstraint);
	rmAddObjectDefConstraint(Grass, avoidImpassableLand);
	rmAddObjectDefConstraint(Grass, avoidRock);
	//rmPlaceObjectDefAtLoc(Grass, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);

	int rockAndGrass=rmCreateObjectDef("grass and rock");
	rmAddObjectDefItem(rockAndGrass, "underbrushTexasGrass", 2, 2.0);
	//rmAddObjectDefItem(rockAndGrass, "underbrushRock", 1, 2.0);
	rmSetObjectDefMinDistance(rockAndGrass, 0.0);
	rmSetObjectDefMaxDistance(rockAndGrass, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rockAndGrass, avoidAll);
	rmAddObjectDefConstraint(rockAndGrass, farGreatLakesConstraint);
	rmAddObjectDefConstraint(rockAndGrass, avoidImpassableLand);
	rmAddObjectDefConstraint(rockAndGrass, avoidRock);
	//rmPlaceObjectDefAtLoc(rockAndGrass, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);

	int randomTrees=rmCreateObjectDef("random trees");
	rmAddObjectDefItem(randomTrees, "TreeGreatLakes", rmRandInt(1,3), 4.0);
	rmSetObjectDefMinDistance(randomTrees, 0.0);
	rmSetObjectDefMaxDistance(randomTrees, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomTrees, avoidAll);
	rmAddObjectDefConstraint(randomTrees, farGreatLakesConstraint);
	rmAddObjectDefConstraint(randomTrees, avoidImpassableLand);
	rmAddObjectDefConstraint(randomTrees, avoidRock);
	// rmPlaceObjectDefAtLoc(randomTrees, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers);

	int flowersID=rmCreateObjectDef("flowers");
	//rmAddObjectDefItem(flowersID, "GroundPropsGP", rmRandInt(5,8), 5.0);
	rmAddObjectDefItem(flowersID, "underbrushTexasGrass", rmRandInt(0,2), 4.0);
	rmSetObjectDefMinDistance(flowersID, 0.0);
	rmSetObjectDefMaxDistance(flowersID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(flowersID, avoidAll);
	rmAddObjectDefConstraint(flowersID, farGreatLakesConstraint);
	rmAddObjectDefConstraint(flowersID, avoidImpassableLand);
	rmAddObjectDefConstraint(flowersID, avoidRock);
	//rmPlaceObjectDefAtLoc(flowersID, 0, 0.5, 0.5, 15*cNumberNonGaiaPlayers);

		// Text
	rmSetStatusText("",0.99);


		// Define and place Nuggets
    
		int nugget1= rmCreateObjectDef("nugget easy"); 
		rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(1, 1);
		rmAddObjectDefToClass(nugget1, rmClassID("nuggets"));
		rmAddObjectDefConstraint(nugget1, shortPlayerConstraint);
		rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
		rmAddObjectDefConstraint(nugget1, avoidNuggets);
		rmAddObjectDefConstraint(nugget1, avoidTradeSockets);
		rmAddObjectDefConstraint(nugget1, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget1, avoidAll);
		rmAddObjectDefConstraint(nugget1, greatLakesConstraint);
		rmAddObjectDefConstraint(nugget1, circleConstraint);
		rmSetObjectDefMinDistance(nugget1, 40.0);
		rmSetObjectDefMaxDistance(nugget1, 60.0);
		rmPlaceObjectDefPerPlayer(nugget1, false, 2);

		int nugget2= rmCreateObjectDef("nugget medium"); 
		rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2, 2);
		rmAddObjectDefToClass(nugget2, rmClassID("nuggets"));
		rmSetObjectDefMinDistance(nugget2, 0.0);
		rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nugget2, shortPlayerConstraint);
		rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
		rmAddObjectDefConstraint(nugget2, avoidNuggets);
		rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget2, circleConstraint);
		rmAddObjectDefConstraint(nugget2, avoidAll);
		rmAddObjectDefConstraint(nugget2, greatLakesConstraint);
		//rmAddObjectDefConstraint(nugget2, longPlayerEdgeConstraint);
		rmSetObjectDefMinDistance(nugget2, 80.0);
		rmSetObjectDefMaxDistance(nugget2, 120.0);
		rmPlaceObjectDefPerPlayer(nugget2, false, 1);

		int nugget3= rmCreateObjectDef("nugget hard"); 
		rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(3, 3);
		rmAddObjectDefToClass(nugget3, rmClassID("nuggets"));
		rmSetObjectDefMinDistance(nugget3, 0.15);
		rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(nugget3, shortPlayerConstraint);
		rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
		rmAddObjectDefConstraint(nugget3, avoidNuggets);
		rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget3, circleConstraint);
		rmAddObjectDefConstraint(nugget3, avoidAll);
		rmAddObjectDefConstraint(nugget3, greatLakesConstraint);
		//rmAddObjectDefConstraint(nugget3, longPlayerEdgeConstraint);
		rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

		int nugget4= rmCreateObjectDef("nugget nuts"); 
		rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmAddObjectDefToClass(nugget4, rmClassID("nuggets"));
		rmSetObjectDefMinDistance(nugget4, 0.15);
		rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.4));
		rmAddObjectDefConstraint(nugget4, longPlayerConstraint);
		rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
		rmAddObjectDefConstraint(nugget4, avoidNuggets);
		rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget4, circleConstraint);
		rmAddObjectDefConstraint(nugget4, avoidAll);
		rmAddObjectDefConstraint(nugget4, greatLakesConstraint);
		//rmAddObjectDefConstraint(nugget4, longPlayerEdgeConstraint);
		rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(2,3));





/*
	int nuggetID = 0;
	for(i=0; <cNumberNonGaiaPlayers*3)
	{
		nuggetID= rmCreateObjectDef("nugget "+i); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nuggetID, rmXFractionToMeters(0.15));
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(nuggetID, rmClassID("importantItem"));
		rmAddObjectDefToClass(nuggetID, rmClassID("nuggets"));
		rmAddObjectDefConstraint(nuggetID, shortPlayerConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetID, avoidNuggets);
		rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
		//rmAddObjectDefConstraint(nuggetID, circleConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidAll);
		rmAddObjectDefConstraint(nuggetID, greatLakesConstraint);
		//rmAddObjectDefConstraint(nuggetID, longPlayerEdgeConstraint);
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5);
	}
*/




	int sheepID=rmCreateObjectDef("sheep");
	rmAddObjectDefItem(sheepID, "sheep", 2, 4.0);
	rmSetObjectDefMinDistance(sheepID, 0.0);
	rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(sheepID, avoidSheep);
	rmAddObjectDefConstraint(sheepID, avoidAll);
	rmAddObjectDefConstraint(sheepID, playerConstraint);
//	rmAddObjectDefConstraint(sheepID, avoidCliffs);
	rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);


	// Text
	rmSetStatusText("",1.0);
   
	}  

}  
