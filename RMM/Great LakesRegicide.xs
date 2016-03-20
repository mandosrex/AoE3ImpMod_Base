// GREAT LAKES - Regicide
// edited for the AS fan patch by RF_Gandalf

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
   
   seasonPicker = 0.9;  // winter

//Chooses which natives appear on the map
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;
	int subCiv3=-1;
	int nativePicker = rmRandInt(1,2);
	float nativeChooser = rmRandFloat(0,1);
   if (rmAllocateSubCivs(4) == true)
   {
	   // natives vary
		if (nativePicker == 1)
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
	int playerTiles = 10500;  // 4 pl
	if (cNumberNonGaiaPlayers == 2)
		playerTiles = 12600;
	if (cNumberNonGaiaPlayers == 3)
		playerTiles = 11200;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 9800;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 9000;		

	int size=2.5*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.5, 3.0);  // DAL - original
	
	rmSetMapElevationHeightBlend(1);
	
	// Picks a default water height
	rmSetSeaLevel(6.0);
   
// LIGHT SET
	if (rmRandFloat(0.0,1.0) < 0.5)
      	rmSetLightingSet("319a_snow");   
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
	// new direction constraints
	int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(345), rmDegreesToRadians(165));
	int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(165), rmDegreesToRadians(345));

	// Player constraints
	int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 25.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0);  
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 38.0);  
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
	int minePlayerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 63.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players short", classPlayer, 28.0);
	int avoidTradeIslands=rmCreateClassDistanceConstraint("stay away from trade islands", rmClassID("tradeIslands"), 40.0);
	int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 75.0);
	int deerPlayerConstraint=rmCreateClassDistanceConstraint("deer stay away from players", classPlayer, 28.0); 

	// Nature avoidance
	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 40.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 40.0);
	int medAvoidCoin=rmCreateTypeDistanceConstraint("med avoid coin", "Mine", 20.0);
	int shortAvoidCoin=rmCreateTypeDistanceConstraint("short avoid coin", "Mine", 10.0);
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
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 25.0);
	int shortAvoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units short", rmClassID("startingUnit"), 8.0);
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

	// Text
	rmSetStatusText("",0.10);

// ************************ ICE LAKE *******************************

   // Place Ice sheet if Winter.

   if (seasonPicker >= 0.5)
   {
	int IceArea1ID=rmCreateArea("Ice Area 1");
	if (cNumberNonGaiaPlayers < 4)
	   rmSetAreaSize(IceArea1ID, 0.063, 0.063);
	else
	   rmSetAreaSize(IceArea1ID, 0.07, 0.07);
	rmSetAreaLocation(IceArea1ID, 0.5, 0.50);
	//rmSetAreaTerrainType(IceArea1ID, "great_lakes\ground_ice1_gl");
	rmSetAreaMix(IceArea1ID, "great_lakes_ice");
	rmAddAreaToClass(IceArea1ID, classGreatLake);
	rmSetAreaBaseHeight(IceArea1ID, 0.0);
//		rmAddAreaInfluencePoint(IceArea1ID, 0.52, 0.5);
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
	rmAddAreaInfluencePoint(michiganID, 0.52, 0.47);
	}
	else
	{
	rmSetAreaSize(michiganID, 0.03, 0.03);
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

	// Text
   rmSetStatusText("",0.20);
	
	
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
      ypKingsHillLandfill(.5, .5, 0.09, 1.5, "greatlakes_snow", 0);
      ypKingsHillPlacer(.5, .5, 0.0, 0);
    }
    
    else {
      ypKingsHillPlacer(.5, .5, 0.08, 0);
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

// Island objects
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

   // Text
   rmSetStatusText("",0.30);

// **************************** PLACE TRADE ROUTE ***************************

	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 7.0);
	rmAddObjectDefConstraint(socketID, shortAvoidTradeRoute);

	int tradeRouteID = rmCreateTradeRoute();
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.07, 0.55); // -1
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.10, 0.65, 2, 3); // -2
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.18, 0.84, 2, 3); // -2
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.44, 0.94, 2, 3); // -3
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.55, 0.96, 2, 3); // -3
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.68, 0.91, 1, 1); // -4
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.8, 0.8, 1, 1); // -5
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.87, 0.72, 2, 3);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.88, 0.69, 2, 3);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.93, 0.54, 1, 1);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.93, 0.46, 1, 1);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.90, 0.39, 2, 3); // -6
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.83, 0.21, 2, 3); // -7
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.77, 0.19, 2, 3); // -8
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.72, 0.09, 2, 3); // -8
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.57, 0.06, 1, 3); // -9
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.04, 1, 3); // -9
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.4, 0.07, 1, 3); // -9
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.29, 0.14, 2, 3); // -10
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.14, 0.22, 2, 3); // -11
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.10, 0.33, 2, 3); // -11
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.07, 0.55, 2, 3); // -12
	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");

      rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

 	    vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.05);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.172);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.338);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.51);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.672);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.838);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // Text
   rmSetStatusText("",0.40);	

// *********************************** PLACE PLAYERS ************************************
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	int playerSide = rmRandInt(1,2);
	if ( cNumberTeams <= 2 && teamZeroCount <= 4 && teamOneCount <= 4)
	{
         	if (playerSide == 1)
        	   rmSetPlacementTeam(0);
      	else    
        	   rmSetPlacementTeam(1);
		if (cNumberNonGaiaPlayers == 2)
		   rmSetPlacementSection(0.72, 0.9); // 0.5
		else if (cNumberNonGaiaPlayers < 5)
		   rmSetPlacementSection(0.7, 0.9); // 0.5
		else if (cNumberNonGaiaPlayers < 7)
		   rmSetPlacementSection(0.69, 0.91); // 0.5
		else
		   rmSetPlacementSection(0.66, 0.93); // 0.5
		rmSetTeamSpacingModifier(0.25);
		if (cNumberNonGaiaPlayers > 6)
		   rmPlacePlayersCircular(0.31, 0.315, 0);
		else if (cNumberNonGaiaPlayers > 4)
		   rmPlacePlayersCircular(0.30, 0.305, 0);
		else
		   rmPlacePlayersCircular(0.29, 0.294, 0);
			
         	if (playerSide == 1)
        	   rmSetPlacementTeam(1);
      	else    
        	   rmSetPlacementTeam(0);
		if (cNumberNonGaiaPlayers == 2)
		   rmSetPlacementSection(0.22, 0.4); // 0.5
		else if (cNumberNonGaiaPlayers < 5)
		   rmSetPlacementSection(0.2, 0.4); // 0.5
		else if (cNumberNonGaiaPlayers < 7)
		   rmSetPlacementSection(0.19, 0.41); // 0.5
		else
		   rmSetPlacementSection(0.16, 0.43); // 0.5
		rmSetTeamSpacingModifier(0.25);
		if (cNumberNonGaiaPlayers > 6)
		   rmPlacePlayersCircular(0.31, 0.315, 0);
		else if (cNumberNonGaiaPlayers > 4)
		   rmPlacePlayersCircular(0.30, 0.305, 0);
		else
		   rmPlacePlayersCircular(0.29, 0.294, 0);
	}
	else
	{
		rmSetTeamSpacingModifier(0.7);
		if (cNumberNonGaiaPlayers > 6)
		   rmPlacePlayersCircular(0.31, 0.315, 0);
		else if (cNumberNonGaiaPlayers > 3)
		   rmPlacePlayersCircular(0.30, 0.305, 0.0);
		else
		   rmPlacePlayersCircular(0.285, 0.29, 0.0);
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
	rmAddAreaConstraint(id, longAvoidImpassableLand);
	rmSetAreaLocPlayer(id, i);
	rmSetAreaWarnFailure(id, false);
   }

	// Build the areas.
	rmBuildAllAreas();
		
// Start area objects
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
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidStartingUnits);

	int StartAreaTree2ID=rmCreateObjectDef("2nd group starting trees");
	if (seasonPicker < 0.5)
		rmAddObjectDefItem(StartAreaTree2ID, "TreeGreatLakes", 5, 7.0);
	else
		rmAddObjectDefItem(StartAreaTree2ID, "TreeGreatLakesSnow", 5, 7.0);
	rmSetObjectDefMinDistance(StartAreaTree2ID, 19);
	rmSetObjectDefMaxDistance(StartAreaTree2ID, 22);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTree2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidNatives);
	rmAddObjectDefConstraint(StartAreaTree2ID, shortAvoidStartingUnits);

  	int berry = 0;
	int StartElkID=rmCreateObjectDef("starting moose");
	if (seasonPicker < 0.5)
	{
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
	rmSetObjectDefMaxDistance(StartElkID, 20);
	rmAddObjectDefConstraint(StartElkID, avoidStartResource);
	rmAddObjectDefConstraint(StartElkID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartElkID, avoidNatives);
	rmAddObjectDefConstraint(StartElkID, avoidAll);

	int startSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(startSilverID, "mine", 1, 5.0);
	rmAddObjectDefConstraint(startSilverID, avoidTradeRoute);
	rmAddObjectDefConstraint(startSilverID, greatLakesConstraint);
	rmSetObjectDefMinDistance(startSilverID, 10.0);
	rmSetObjectDefMaxDistance(startSilverID, 16.0);
	rmAddObjectDefConstraint(startSilverID, avoidStartResource);
	rmAddObjectDefConstraint(startSilverID, avoidAll);
	rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);

	int startSilver2ID = rmCreateObjectDef("player far silver");
	rmAddObjectDefItem(startSilver2ID, "mine", 1, 5.0);
	rmAddObjectDefConstraint(startSilver2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(startSilver2ID, greatLakesConstraint);
	rmSetObjectDefMinDistance(startSilver2ID, 42.0);
	rmSetObjectDefMaxDistance(startSilver2ID, 48.0);
	rmAddObjectDefConstraint(startSilver2ID, avoidStartResource);
	rmAddObjectDefConstraint(startSilver2ID, avoidAll);
	rmAddObjectDefConstraint(startSilver2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(startSilver2ID, mediumPlayerConstraint);

	int startSilver3ID = rmCreateObjectDef("player farther silver");
	rmAddObjectDefItem(startSilver3ID, "mine", 1, 5.0);
	rmAddObjectDefConstraint(startSilver3ID, avoidTradeRoute);
	rmAddObjectDefConstraint(startSilver3ID, greatLakesConstraint);
	rmSetObjectDefMinDistance(startSilver3ID, 63.0);
	rmSetObjectDefMaxDistance(startSilver3ID, 71.0);
	rmAddObjectDefConstraint(startSilver3ID, avoidAll);
	rmAddObjectDefConstraint(startSilver3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(startSilver3ID, minePlayerConstraint);

      int farDeerID=rmCreateObjectDef("deer herds farther from start");
      rmAddObjectDefItem(farDeerID, "deer", rmRandInt(6,8), 7.0);  
      rmSetObjectDefCreateHerd(farDeerID, true);
      rmSetObjectDefMinDistance(farDeerID, 29);
      rmSetObjectDefMaxDistance(farDeerID, 34);
      rmAddObjectDefToClass(farDeerID, rmClassID("startingUnit"));
      rmAddObjectDefConstraint(farDeerID, shortDeerConstraint);
	rmAddObjectDefConstraint(farDeerID, greatLakesConstraint);
      rmAddObjectDefConstraint(farDeerID, avoidAll);
      rmAddObjectDefConstraint(farDeerID, deerPlayerConstraint);
      rmAddObjectDefConstraint(farDeerID, avoidTradeRoute);

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

  // Regicide objects
  int playerCastle=rmCreateObjectDef("Castle");
  rmAddObjectDefItem(playerCastle, "ypCastleRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerCastle, avoidAll);
  rmAddObjectDefConstraint(playerCastle, avoidImpassableLand);
  rmSetObjectDefMinDistance(playerCastle, 17.0);	
  rmSetObjectDefMaxDistance(playerCastle, 21.0);
  
  int playerWalls = rmCreateGrouping("regicide walls", "regicide_walls");
  rmAddGroupingToClass(playerWalls, rmClassID("importantItem"));
  rmSetGroupingMinDistance(playerWalls, 0.0);
  rmSetGroupingMaxDistance(playerWalls, 4.0);
  rmAddGroupingConstraint(playerWalls, avoidWater4);
  
  int playerDaimyo=rmCreateObjectDef("Daimyo"+i);
  rmAddObjectDefItem(playerDaimyo, "ypDaimyoRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerDaimyo, avoidAll);
  rmSetObjectDefMinDistance(playerDaimyo, 7.0);	
  rmSetObjectDefMaxDistance(playerDaimyo, 10.0);

   for(i=1; <cNumberPlayers)
   {
	rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
	// regicide objects
      rmPlaceObjectDefAtLoc(playerDaimyo, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      rmPlaceGroupingAtLoc(playerWalls, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      rmPlaceObjectDefAtLoc(playerCastle, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

	rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

    	if(ypIsAsian(i) && rmGetNomadStart() == false)
         rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, berry), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(StartElkID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(startSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(startSilver2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(startSilver3ID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(farDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
   }

   // Clear out constraints for good measure.
   //rmClearClosestPointConstraints();

	// Text
	rmSetStatusText("",0.50);

// Define and place the Native Villages
	float NativeVillageLoc = rmRandFloat(0,1);
	float huronVillageLoc = rmRandFloat(0,1);

	if (subCiv0 == rmGetCivID("Cree"))
	{
		int cree1VillageID = -1;
		int cree1VillageType = rmRandInt(1,5);
		cree1VillageID = rmCreateGrouping("cree1 village", "native cree village "+cree1VillageType);
		rmSetGroupingMinDistance(cree1VillageID, 0.0);
		rmSetGroupingMaxDistance(cree1VillageID, 35.0);
		rmAddGroupingConstraint(cree1VillageID, greatLakesConstraint);
		rmAddGroupingConstraint(cree1VillageID, nearShore);
		rmAddGroupingConstraint(cree1VillageID, mediumPlayerConstraint);
		rmAddGroupingConstraint(cree1VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(cree1VillageID, avoidTradeSockets);
		rmAddGroupingConstraint(cree1VillageID, avoidAll);
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
		rmSetGroupingMaxDistance(huron1VillageID, 35.0);
		rmAddGroupingConstraint(huron1VillageID, greatLakesConstraint);
		rmAddGroupingConstraint(huron1VillageID, nearShore);
		rmAddGroupingConstraint(huron1VillageID, mediumPlayerConstraint);
		rmAddGroupingConstraint(huron1VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(huron1VillageID, avoidTradeSockets);
		rmAddGroupingConstraint(huron1VillageID, avoidAll);
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
		rmSetGroupingMaxDistance(cheyenneVillageID, 35.0);
		rmAddGroupingConstraint(cheyenneVillageID, greatLakesConstraint);
		rmAddGroupingConstraint(cheyenneVillageID, nearShore);
		rmAddGroupingConstraint(cheyenneVillageID, mediumPlayerConstraint);
		rmAddGroupingConstraint(cheyenneVillageID, avoidStartingUnits);
		rmAddGroupingConstraint(cheyenneVillageID, avoidTradeRoute);
		rmAddGroupingConstraint(cheyenneVillageID, avoidTradeSockets);
		rmAddGroupingConstraint(cheyenneVillageID, avoidAll);
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
			rmAddGroupingConstraint(huron2VillageID, avoidStartingUnits);
			rmAddGroupingConstraint(huron2VillageID, avoidTradeSockets);
			rmAddGroupingConstraint(huron2VillageID, mediumPlayerConstraint);
			rmAddGroupingConstraint(huron2VillageID, avoidAll);
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
			rmAddGroupingConstraint(cree2VillageID, avoidStartingUnits);
			rmAddGroupingConstraint(cree2VillageID, avoidTradeSockets);
			rmAddGroupingConstraint(cree2VillageID, mediumPlayerConstraint);
			rmAddGroupingConstraint(cree2VillageID, avoidAll);
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
			rmAddGroupingConstraint(huron3VillageID, avoidStartingUnits);
			rmAddGroupingConstraint(huron3VillageID, avoidTradeSockets);
			rmAddGroupingConstraint(huron3VillageID, mediumPlayerConstraint);
			rmAddGroupingConstraint(huron3VillageID, avoidAll);
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
			rmAddGroupingConstraint(cree3VillageID, avoidStartingUnits);
			rmAddGroupingConstraint(cree3VillageID, avoidTradeSockets);
			rmAddGroupingConstraint(cree3VillageID, mediumPlayerConstraint);
			rmAddGroupingConstraint(cree3VillageID, avoidAll);
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
		rmSetGroupingMaxDistance(cree4VillageID, 35.0);
		rmAddGroupingConstraint(cree4VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(cree4VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(cree4VillageID, avoidStartingUnits);
		rmAddGroupingConstraint(cree4VillageID, avoidTradeSockets);
		rmAddGroupingConstraint(cree4VillageID, mediumPlayerConstraint);
		rmAddGroupingConstraint(cree4VillageID, avoidAll);
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
		rmSetGroupingMaxDistance(huron4VillageID, 35.0);
		rmAddGroupingConstraint(huron4VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(huron4VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(huron4VillageID, avoidStartingUnits);
		rmAddGroupingConstraint(huron4VillageID, avoidTradeSockets);
		rmAddGroupingConstraint(huron4VillageID, mediumPlayerConstraint);
		rmAddGroupingConstraint(huron4VillageID, avoidAll);
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
		rmSetGroupingMaxDistance(cheyenne2VillageID, 35.0);
		rmAddGroupingConstraint(cheyenne2VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(cheyenne2VillageID, avoidTradeRoute);
		rmAddGroupingConstraint(cheyenne2VillageID, avoidStartingUnits);
		rmAddGroupingConstraint(cheyenne2VillageID, avoidTradeSockets);
		rmAddGroupingConstraint(cheyenne2VillageID, mediumPlayerConstraint);
		rmAddGroupingConstraint(cheyenne2VillageID, avoidAll);
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
	int silverTries=(1.5*cNumberNonGaiaPlayers);
   
	int silverMineID = rmCreateObjectDef("east silver mines");
	rmAddObjectDefItem(silverMineID, "mine", 1, 5.0);
	rmSetObjectDefMinDistance(silverMineID, 0.0);
	rmSetObjectDefMaxDistance(silverMineID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(silverMineID, avoidImpassableLand);
	rmAddObjectDefConstraint(silverMineID, greatLakesConstraint);
	rmAddObjectDefConstraint(silverMineID, avoidCoin);
	rmAddObjectDefConstraint(silverMineID, farPlayerConstraint);
	rmAddObjectDefConstraint(silverMineID, avoidAll);
	rmAddObjectDefConstraint(silverMineID, Eastward);
	rmAddObjectDefConstraint(silverMineID, avoidTradeRoute);
	rmAddObjectDefConstraint(silverMineID, avoidTradeSockets);
   for(i=0; <silverTries)
   {
		rmPlaceObjectDefAtLoc(silverMineID, 0, 0.75, 0.5);
   }

	int silverMineSID = rmCreateObjectDef("west silver mines");
	rmAddObjectDefItem(silverMineSID, "mine", 1, 5.0);
	rmSetObjectDefMinDistance(silverMineSID, 0.0);
	rmSetObjectDefMaxDistance(silverMineSID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(silverMineSID, avoidImpassableLand);
	rmAddObjectDefConstraint(silverMineSID, greatLakesConstraint);
	rmAddObjectDefConstraint(silverMineSID, avoidCoin);
	rmAddObjectDefConstraint(silverMineSID, farPlayerConstraint);
	rmAddObjectDefConstraint(silverMineSID, avoidAll);
	rmAddObjectDefConstraint(silverMineSID, Westward);
	rmAddObjectDefConstraint(silverMineSID, avoidTradeRoute);
	rmAddObjectDefConstraint(silverMineSID, avoidTradeSockets);
   for(i=0; <silverTries)
   {
		rmPlaceObjectDefAtLoc(silverMineSID, 0, 0.25, 0.5);
   }

   // Text
   rmSetStatusText("",0.60);

// Define and place forests - north and south
	int forestTreeID = 0;
	int numTries = -1;
	int failCount = -1;
	numTries=5*cNumberNonGaiaPlayers;  // now really east
	failCount=0;
	for (i=0; <numTries)
		{   
			int northForest=rmCreateArea("northforest"+i);
			rmSetAreaWarnFailure(northForest, false);
			rmSetAreaSize(northForest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
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
			rmAddAreaConstraint(northForest, avoidAll);
			rmAddAreaConstraint(northForest, avoidTradeSockets);
			rmAddAreaConstraint(northForest, greatLakesConstraint);
			rmAddAreaConstraint(northForest, playerConstraintForest);		// DAL adeed, to keep forests away from the player.
			rmAddAreaConstraint(northForest, forestConstraint);   // DAL adeed, to keep forests away from each other.
			rmAddAreaConstraint(northForest, Eastward);				// DAL adeed, to keep forests in the north.
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

	numTries=5*cNumberNonGaiaPlayers;  // now really west
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
			rmAddAreaConstraint(southForest, avoidAll);
			rmAddAreaConstraint(southForest, avoidTradeSockets);
			rmAddAreaConstraint(southForest, greatLakesConstraint);
			rmAddAreaConstraint(southForest, playerConstraintForest);   // DAL adeed, to keep forests away from the player.
			rmAddAreaConstraint(southForest, forestConstraint);   // DAL adeed, to keep forests away from each other.
			rmAddAreaConstraint(southForest, Westward);				// DAL adeed, to keep forests in the south.
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

	// Text
	rmSetStatusText("",0.70);
   
// Place some extra deer herds.  
	int deerHerdID=rmCreateObjectDef("eastern deer herd");
	rmAddObjectDefItem(deerHerdID, "deer", rmRandInt(7,9), 6.0);
	rmSetObjectDefCreateHerd(deerHerdID, true);
	rmSetObjectDefMinDistance(deerHerdID, 0.0);
	rmSetObjectDefMaxDistance(deerHerdID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(deerHerdID, shortAvoidCoin);
	rmAddObjectDefConstraint(deerHerdID, avoidTradeRoute);
	rmAddObjectDefConstraint(deerHerdID, playerConstraint);
	if (seasonPicker < 0.5)
		rmAddObjectDefConstraint(deerHerdID, greatLakesConstraint);
	rmAddObjectDefConstraint(deerHerdID, avoidAll);
	rmAddObjectDefConstraint(deerHerdID, avoidImpassableLand);
	rmAddObjectDefConstraint(deerHerdID, deerConstraint);
	rmAddObjectDefConstraint(deerHerdID, Eastward);
	numTries=2*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(deerHerdID, 0, 0.75, 0.5);
	}

	int deerHerdID2=rmCreateObjectDef("western deer herd");
	rmAddObjectDefItem(deerHerdID2, "deer", rmRandInt(7,9), 6.0);
	rmSetObjectDefCreateHerd(deerHerdID2, true);
	rmSetObjectDefMinDistance(deerHerdID2, 0.0);
	rmSetObjectDefMaxDistance(deerHerdID2, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(deerHerdID2, shortAvoidCoin);
	rmAddObjectDefConstraint(deerHerdID2, playerConstraint);
	rmAddObjectDefConstraint(deerHerdID2, avoidTradeRoute);
	if (seasonPicker < 0.5)
		rmAddObjectDefConstraint(deerHerdID2, greatLakesConstraint);
	rmAddObjectDefConstraint(deerHerdID2, avoidAll);
	rmAddObjectDefConstraint(deerHerdID2, avoidImpassableLand);
	rmAddObjectDefConstraint(deerHerdID2, deerConstraint);
	rmAddObjectDefConstraint(deerHerdID2, Westward);
	numTries=2*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(deerHerdID2, 0, 0.25, 0.5);
	}

	// Text
	rmSetStatusText("",0.80);	


// Place some extra moose herds.  
	int mooseHerdID=rmCreateObjectDef("eastern moose herd");
	rmAddObjectDefItem(mooseHerdID, "moose", rmRandInt(2,3), 6.0);
	rmSetObjectDefCreateHerd(mooseHerdID, true);
	rmSetObjectDefMinDistance(mooseHerdID, 0.0);
	rmSetObjectDefMaxDistance(mooseHerdID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(mooseHerdID, shortAvoidCoin);
	if (seasonPicker < 0.5)
		rmAddObjectDefConstraint(mooseHerdID, greatLakesConstraint);
	rmAddObjectDefConstraint(mooseHerdID, avoidAll);
	rmAddObjectDefConstraint(mooseHerdID, playerConstraint);
	rmAddObjectDefConstraint(mooseHerdID, avoidTradeRoute);
	rmAddObjectDefConstraint(mooseHerdID, avoidImpassableLand);
	rmAddObjectDefConstraint(mooseHerdID, Eastward);
	rmAddObjectDefConstraint(mooseHerdID, mooseConstraint);
	rmAddObjectDefConstraint(mooseHerdID, shortDeerConstraint);
	numTries=2*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(mooseHerdID, 0, 0.75, 0.5);
	}

	int mooseHerdSID=rmCreateObjectDef("western moose herd");
	rmAddObjectDefItem(mooseHerdSID, "moose", rmRandInt(2,3), 6.0);
	rmSetObjectDefCreateHerd(mooseHerdSID, true);
	rmSetObjectDefMinDistance(mooseHerdSID, 0.0);
	rmSetObjectDefMaxDistance(mooseHerdSID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(mooseHerdSID, shortAvoidCoin);
	if (seasonPicker < 0.5)
		rmAddObjectDefConstraint(mooseHerdSID, greatLakesConstraint);
	rmAddObjectDefConstraint(mooseHerdSID, avoidAll);
	rmAddObjectDefConstraint(mooseHerdSID, playerConstraint);
	rmAddObjectDefConstraint(mooseHerdSID, avoidTradeRoute);
	rmAddObjectDefConstraint(mooseHerdSID, avoidImpassableLand);
	rmAddObjectDefConstraint(mooseHerdSID, Westward);
	rmAddObjectDefConstraint(mooseHerdSID, mooseConstraint);
	rmAddObjectDefConstraint(mooseHerdSID, shortDeerConstraint);
	numTries=2*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(mooseHerdSID, 0, 0.25, 0.5);
	}

	// Text
	rmSetStatusText("",0.90);

// fish
	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
	int fishID=rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "FishSalmon", 3, 4.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishLand);
   	if (seasonPicker < 0.5)
		rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	
	// Text
	rmSetStatusText("",0.95);

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

// Sheep
	int sheepID=rmCreateObjectDef("sheep");
	rmAddObjectDefItem(sheepID, "sheep", 2, 4.0);
	rmSetObjectDefMinDistance(sheepID, 0.0);
	rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(sheepID, avoidSheep);
	rmAddObjectDefConstraint(sheepID, avoidAll);
	rmAddObjectDefConstraint(sheepID, playerConstraint);
	rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);

// Random trees - on hold
	int randomTreeID=rmCreateObjectDef("random tree");
	if (seasonPicker < 0.5)
		rmAddObjectDefItem(randomTreeID, "TreeGreatLakes", 1, 1.0);
	else
		rmAddObjectDefItem(randomTreeID, "TreeGreatLakesSnow", 1, 1.0);
	rmSetObjectDefMinDistance(randomTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, avoidResource);
	rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
//	rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);  

// Regicide Trigger
for(i=1; <= cNumberNonGaiaPlayers)
{   
    // Lose on Daimyo's death
    rmCreateTrigger("DaimyoDeath"+i);
    rmSwitchToTrigger(rmTriggerID("DaimyoDeath"+i));
    rmSetTriggerPriority(4); 
    rmSetTriggerActive(true);
    rmSetTriggerRunImmediately(true);
    rmSetTriggerLoop(false);
    
    rmAddTriggerCondition("Is Dead");
    rmSetTriggerConditionParamInt("SrcObject", rmGetUnitPlacedOfPlayer(playerDaimyo, i), false);
    
    rmAddTriggerEffect("Set Player Defeated");
    rmSetTriggerEffectParamInt("Player", i, false);
    
}

	// Text
	rmSetStatusText("",1.0);
   
	} 
}  
