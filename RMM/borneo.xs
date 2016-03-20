// Borneo
// PJJ
// Dec 2006

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

  int whichVersion = 1;
   
  // initialize map type variables 
  string nativeCiv1 = "Jesuit";
  string nativeCiv2 = "Sufi";
  string baseMix = "borneo_grass_a";
  string paintMix = "borneo_underbrush";
  string baseTerrain = "Deccan\ground_grass4_deccan";
  string seaType = "borneo coast";
  string startTreeType = "ypTreeBorneo";
  string forestType = "Borneo Forest";
  string forestType2 = "Borneo Palm Forest";
  string patchTerrain = "great_plains\ground2_gp";
  string patchType1 = "great_plains\ground8_gp";
  string patchType2 = "great_plains\ground7_gp";
  string mapType1 = "borneo";
  string mapType2 = "grass";
  string herdableType = "ypWaterBuffalo";
  string huntable1 = "ypSerow";
  string huntable2 = "ypWildElephant";
  string fish1 = "ypFishMolaMola";
  string fish2 = "ypFishTuna";
  string whale1 = "HumpbackWhale";
  string lightingType = "Borneo";
  string tradeRouteType = "water";
  
  bool weird = false;
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
    
  // FFA and imbalanced teams
  if ( cNumberTeams > 2 || ((teamZeroCount - teamOneCount) > 2) || ((teamOneCount - teamZeroCount) > 2) )
    weird = true;
  
  rmEchoInfo("weird = "+weird);
  
// Natives
   int subCiv0=-1;
   int subCiv1=-1;

  if (rmAllocateSubCivs(2) == true)
  {
		  // Klamath, Comanche, or Hurons
		  subCiv0=rmGetCivID(nativeCiv1);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, nativeCiv1);

		  // Cherokee, Apache, or Cheyenne
		  subCiv1=rmGetCivID(nativeCiv2);
      if (subCiv1 >= 0)
         rmSetSubCiv(1, nativeCiv2);
  }
	
// Map Basics
	int playerTiles = 22000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 19000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 16000;		

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 10, 0.4, 7.0);
	rmSetMapElevationHeightBlend(1);
	
	rmSetSeaLevel(1.0);
	rmSetLightingSet(lightingType);

	rmSetSeaType(seaType);
	rmSetBaseTerrainMix(baseMix);
	rmTerrainInitialize("water");
	rmSetMapType(mapType1);
	rmSetMapType(mapType2);
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(3.0);

	chooseMercs();
	
// Classes
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");

// Constraints
    
	// Map edge constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(12), rmZTilesToFraction(12), 1.0-rmXTilesToFraction(12), 1.0-rmZTilesToFraction(12), 0.01);

	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 20.0);
  int longPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players long", classPlayer, 35.0);
  int playerConstraintNugget=rmCreateClassDistanceConstraint("stay away from players far", classPlayer, 55.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players medium", classPlayer, 10.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 5.0);

	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 7.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int shortAvoidResource=rmCreateTypeDistanceConstraint("resource avoid resource short", "resource", 5.0);
  int forestAvoidResource=rmCreateTypeDistanceConstraint("forest avoid resource short", "resource", 8.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);
	   
	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);

  // resource avoidance
	int avoidSilver=rmCreateTypeDistanceConstraint("avoid silver", "mine", 75.0);
	int avoidGold=rmCreateTypeDistanceConstraint("avoid gold", "minegold", 50.0);
  int avoidHuntable1=rmCreateTypeDistanceConstraint("avoid huntable1", huntable1, 60.0);
	int avoidHuntable2=rmCreateTypeDistanceConstraint("avoid huntable2", huntable2, 60.0);
  int avoidNuggetsShort=rmCreateTypeDistanceConstraint("vs nugget short", "AbstractNugget", 10.0);
  int avoidNuggets=rmCreateTypeDistanceConstraint("nugget vs. nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget vs. nugget far", "AbstractNugget", 70.0);
  int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
  int avoidHerdable=rmCreateTypeDistanceConstraint("herdables avoid herdables", herdableType, 75.0);
  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 55.0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Unit avoidance
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), rmXFractionToMeters(0.2));
	int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other short", rmClassID("importantItem"), 8.0);

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);

	// Trade route avoidance.
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
	int avoidTradeRouteSocketsShort=rmCreateTypeDistanceConstraint("avoid trade route sockets short", "sockettraderoute", 8.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid trade route sockets", "sockettraderoute", 15.0);
	int avoidTradeRouteSocketsFar=rmCreateTypeDistanceConstraint("avoid trade route sockets far", "sockettraderoute", 40.0);
  //~ int waterySockets = rmCreateTerrainMaxDistanceConstraint("stay near the water", "land", false, 10.0);
  int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);
  
  // fish & whale constraints
  int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", fish1, 15.0);	
	int fishVsFish2ID=rmCreateTypeDistanceConstraint("fish v fish2", fish2, 15.0); 
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);			
  
  int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", whale1, 45.0);
	int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 25.0);
  int whaleEdgeConstraint=rmCreatePieConstraint("whale edge of map", 0.5, 0.5, 0, rmGetMapXSize()-25, 0, 0, 0);

  // flag constraints
  int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 25.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 20.0);
	int flagEdgeConstraint=rmCreatePieConstraint("flag edge of map", 0.5, 0.5, 0, rmGetMapXSize()-25, 0, 0, 0);

// ************************** DEFINE OBJECTS ****************************
	
  int food1ID=rmCreateObjectDef("huntable1");
	rmAddObjectDefItem(food1ID, huntable1, rmRandInt(8,10), 6.0);
	rmSetObjectDefCreateHerd(food1ID, true);
	rmSetObjectDefMinDistance(food1ID, 0.0);
	rmSetObjectDefMaxDistance(food1ID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(food1ID, avoidResource);
	rmAddObjectDefConstraint(food1ID, playerConstraint);
	rmAddObjectDefConstraint(food1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(food1ID, avoidHuntable1);
	rmAddObjectDefConstraint(food1ID, avoidHuntable2);
  rmAddObjectDefConstraint(food1ID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(food1ID, avoidTradeRouteSocketsShort);
  
  int food2ID=rmCreateObjectDef("huntable2");
	rmAddObjectDefItem(food2ID, huntable2, rmRandInt(2,3), 6.0);
	rmSetObjectDefCreateHerd(food2ID, true);
	rmSetObjectDefMinDistance(food2ID, 0.0);
	rmSetObjectDefMaxDistance(food2ID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(food2ID, avoidResource);
	rmAddObjectDefConstraint(food2ID, playerConstraint);
	rmAddObjectDefConstraint(food2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(food2ID, avoidHuntable1);
	rmAddObjectDefConstraint(food2ID, avoidHuntable2);
	rmAddObjectDefConstraint(food2ID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(food2ID, avoidTradeRouteSocketsShort);
  
  int startFoodID=rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(startFoodID, huntable1, 6, 4.0);
	rmSetObjectDefMinDistance(startFoodID, 12.0);
	rmSetObjectDefMaxDistance(startFoodID, 18.0);
	rmSetObjectDefCreateHerd(startFoodID, false);
	rmAddObjectDefConstraint(startFoodID, avoidHuntable1);    
	rmAddObjectDefConstraint(startFoodID, avoidHuntable2);    
  rmAddObjectDefConstraint(startFoodID, avoidTradeRoute);
  
  int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 6, 6.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 16);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 22);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRouteSocketsShort);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);

	int StartBerriesID=rmCreateObjectDef("starting berries");
	rmAddObjectDefItem(StartBerriesID, "berrybush", 4, 5.0);
	rmSetObjectDefMinDistance(StartBerriesID, 10);
	rmSetObjectDefMaxDistance(StartBerriesID, 15);
	rmAddObjectDefConstraint(StartBerriesID, avoidStartResource);
	rmAddObjectDefConstraint(StartBerriesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartBerriesID, shortPlayerConstraint);
  rmAddObjectDefConstraint(StartBerriesID, avoidTradeRoute);

  int startSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(startSilverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(startSilverID, 12.0);
	rmSetObjectDefMaxDistance(startSilverID, 20.0);
	rmAddObjectDefConstraint(startSilverID, avoidAll);
	rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);
  rmAddObjectDefConstraint(startSilverID, avoidTradeRoute);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
  rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);
  rmAddObjectDefConstraint(startingUnits, avoidTradeRoute);
  
  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 15.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 20.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   
	// -------------Done defining objects
  // Text
  rmSetStatusText("",0.10);
  
  // Make the island

	int mainIslandID=rmCreateArea("borneo");

  if(cNumberNonGaiaPlayers > 4)
    	rmSetAreaSize(mainIslandID, 0.375, 0.375);
      
  else
  	rmSetAreaSize(mainIslandID, 0.3, 0.3);
  
	rmSetAreaCoherence(mainIslandID, 0.65);
	rmSetAreaBaseHeight(mainIslandID, 3.0);
  rmSetAreaLocation(mainIslandID, .5, .5);
	rmSetAreaSmoothDistance(mainIslandID, 20);
	rmSetAreaMix(mainIslandID, baseMix);
  rmAddAreaTerrainLayer(mainIslandID, "borneo\ground_sand1_borneo", 0, 6);
  rmAddAreaTerrainLayer(mainIslandID, "borneo\ground_sand2_borneo", 6, 9);
  rmAddAreaTerrainLayer(mainIslandID, "borneo\ground_sand3_borneo", 9, 12);
  rmAddAreaTerrainLayer(mainIslandID, "borneo\ground_grass4_borneo", 12, 15);
	rmSetAreaObeyWorldCircleConstraint(mainIslandID, false);
	rmSetAreaElevationType(mainIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(mainIslandID, 4.0);
	rmSetAreaElevationMinFrequency(mainIslandID, 0.09);
	rmSetAreaElevationOctaves(mainIslandID, 3);
	rmSetAreaElevationPersistence(mainIslandID, 0.2);
	rmSetAreaElevationNoiseBias(mainIslandID, 1);

	rmSetAreaWarnFailure(mainIslandID, false);
	rmBuildArea(mainIslandID);

  // Invisible middle area in the island for resources

	int invisIslandID=rmCreateArea("invisible island");
	rmSetAreaSize(invisIslandID, 0.09, 0.09);
	rmSetAreaCoherence(invisIslandID, 0.8);
  rmSetAreaLocation(invisIslandID, .5, .5);
	rmSetAreaWarnFailure(invisIslandID, false);
	rmBuildArea(invisIslandID);
  
  rmSetOceanReveal(true);

  // Trade routes
  
  if(weird == false) {
    int tradeRouteID = rmCreateTradeRoute();
    
    int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
    rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

    rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
    rmSetObjectDefAllowOverlap(socketID, true);
    rmSetObjectDefMinDistance(socketID, 0.0);
    rmSetObjectDefMaxDistance(socketID, 8.0);

    rmAddTradeRouteWaypoint(tradeRouteID, .30, .675);
    rmAddTradeRouteWaypoint(tradeRouteID, .375, .625);
    rmAddTradeRouteWaypoint(tradeRouteID, .40, .55);
    rmAddTradeRouteWaypoint(tradeRouteID, .45, .5);
    rmAddTradeRouteWaypoint(tradeRouteID, .40, .45);
    rmAddTradeRouteWaypoint(tradeRouteID, .375, .375);
    rmAddTradeRouteWaypoint(tradeRouteID, .30, .325);
    
    bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, tradeRouteType);
    if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 
    
    // add the sockets along the trade route.
    vector socketLoc  = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    
    if(cNumberNonGaiaPlayers > 3) {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  
    }
    
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    
    int tradeRouteID2 = rmCreateTradeRoute();

    int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
    rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);

    rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
    rmSetObjectDefAllowOverlap(socketID2, true);
    rmSetObjectDefMinDistance(socketID2, 0.0);
    rmSetObjectDefMaxDistance(socketID2, 8.0);

    rmAddTradeRouteWaypoint(tradeRouteID2, .7, .675);
    rmAddTradeRouteWaypoint(tradeRouteID2, .625, .625);
    rmAddTradeRouteWaypoint(tradeRouteID2, .60, .55);
    rmAddTradeRouteWaypoint(tradeRouteID2, .55, .5);
    rmAddTradeRouteWaypoint(tradeRouteID2, .60, .45);
    rmAddTradeRouteWaypoint(tradeRouteID2, .625, .375);
    rmAddTradeRouteWaypoint(tradeRouteID2, .7, .325);
    
    bool placedTradeRoute2 = rmBuildTradeRoute(tradeRouteID2, tradeRouteType);
    if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 
    
    // add the sockets along the trade route.
    vector socketLoc2  = rmGetTradeRouteWayPoint(tradeRouteID2, 0.2);
      
    socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.2);
    rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
    
    if(cNumberNonGaiaPlayers > 3) {
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.5);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);  
    }
    
    socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.8);
    rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
  }
  
  // Circular FFA trade route
  else {
    int tradeRouteIDWeird = rmCreateTradeRoute();
    
    int socketIDWeird=rmCreateObjectDef("sockets to dock Trade Posts");
    rmSetObjectDefTradeRouteID(socketIDWeird, tradeRouteIDWeird);

    rmAddObjectDefItem(socketIDWeird, "SocketTradeRoute", 1, 0.0);
    rmSetObjectDefAllowOverlap(socketIDWeird, true);
    rmSetObjectDefMinDistance(socketIDWeird, 0.0);
    rmSetObjectDefMaxDistance(socketIDWeird, 8.0);

    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .35, .5);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .4, .55);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .45, .6);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .5, .65);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .55, .6);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .6, .55);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .65, .5);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .6, .45);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .55, .4);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .5, .35);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .45, .4);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .4, .45);
    rmAddTradeRouteWaypoint(tradeRouteIDWeird, .35, .5);
    
    bool placedTradeRouteWeird = rmBuildTradeRoute(tradeRouteIDWeird, tradeRouteType);
    if(placedTradeRouteWeird == false)
      rmEchoError("Failed to place trade route weird"); 
    
    // add the sockets along the trade route.
    vector socketLocWeird  = rmGetTradeRouteWayPoint(tradeRouteIDWeird, 0.0);
    rmPlaceObjectDefAtPoint(socketIDWeird, 0, socketLocWeird);
      
    socketLocWeird = rmGetTradeRouteWayPoint(tradeRouteIDWeird, 0.25);
    rmPlaceObjectDefAtPoint(socketIDWeird, 0, socketLocWeird);
    
    socketLocWeird = rmGetTradeRouteWayPoint(tradeRouteIDWeird, 0.5);
    rmPlaceObjectDefAtPoint(socketIDWeird, 0, socketLocWeird);  
    
    socketLocWeird = rmGetTradeRouteWayPoint(tradeRouteIDWeird, 0.75);
    rmPlaceObjectDefAtPoint(socketIDWeird, 0, socketLocWeird);
    
    if (cNumberNonGaiaPlayers > 4){
      socketLocWeird = rmGetTradeRouteWayPoint(tradeRouteIDWeird, 0.125);
      rmPlaceObjectDefAtPoint(socketIDWeird, 0, socketLocWeird);
      
      socketLocWeird = rmGetTradeRouteWayPoint(tradeRouteIDWeird, 0.875);
      rmPlaceObjectDefAtPoint(socketIDWeird, 0, socketLocWeird);
    }
    
    if (cNumberNonGaiaPlayers > 6){
    
      socketLocWeird = rmGetTradeRouteWayPoint(tradeRouteIDWeird, 0.375);
      rmPlaceObjectDefAtPoint(socketIDWeird, 0, socketLocWeird);
    
      socketLocWeird = rmGetTradeRouteWayPoint(tradeRouteIDWeird, 0.625);
      rmPlaceObjectDefAtPoint(socketIDWeird, 0, socketLocWeird);
    }
  }
  
  // Text
  rmSetStatusText("",0.15);
  
  // Players
    
  float teamSide = rmRandFloat(0, 1);
  // teamSide = 0;
  
  if (weird == false) {
    
    if(teamSide > .5) {
      if(cNumberNonGaiaPlayers > 7) { 
        rmSetPlacementTeam(0);
        rmSetPlacementSection(.5, .8);
        rmPlacePlayersCircular(.25, .25, 0);
        
        rmSetPlacementTeam(1);
        rmSetPlacementSection(.0, .3);
        rmPlacePlayersCircular(.25, .25, 0);
      }
      
      else if(cNumberNonGaiaPlayers > 5) {
        rmSetPlacementTeam(0);
        rmSetPlacementSection(.6, .9);
        rmPlacePlayersCircular(.25, .25, 0);
        
        rmSetPlacementTeam(1);
        rmSetPlacementSection(.1, .4);
        rmPlacePlayersCircular(.25, .25, 0);
      }
      
      else if(cNumberNonGaiaPlayers > 2) {
        rmSetPlacementTeam(0);
        rmSetPlacementSection(.5, .8);
        rmPlacePlayersCircular(.25, .25, 0);
        
        rmSetPlacementTeam(1);
        rmSetPlacementSection(.0, .3);
        rmPlacePlayersCircular(.25, .25, 0);
        
      }
      
      else {
        rmSetPlacementTeam(0);
        rmSetPlacementSection(.74, .75);
        rmPlacePlayersCircular(.25, .25, 0);
        
        rmSetPlacementTeam(1);
        rmSetPlacementSection(.24, .25);
        rmPlacePlayersCircular(.25, .25, 0);
      }
    }
    
    else {
      if(cNumberNonGaiaPlayers > 7) { 
        rmSetPlacementTeam(1);
        rmSetPlacementSection(.5, .8);
        rmPlacePlayersCircular(.25, .25, 0);
        
        rmSetPlacementTeam(0);
        rmSetPlacementSection(.0, .3);
        rmPlacePlayersCircular(.25, .25, 0);
      }
      
      else if(cNumberNonGaiaPlayers > 5) {
        rmSetPlacementTeam(1);
        rmSetPlacementSection(.6, .9);
        rmPlacePlayersCircular(.25, .25, 0);
        
        rmSetPlacementTeam(0);
        rmSetPlacementSection(.1, .4);
        rmPlacePlayersCircular(.25, .25, 0);
      }
      
      else if(cNumberNonGaiaPlayers > 2) {
        rmSetPlacementTeam(1);
        rmSetPlacementSection(.5, .8);
        rmPlacePlayersCircular(.25, .25, 0);
        
        rmSetPlacementTeam(0);
        rmSetPlacementSection(.0, .3);
        rmPlacePlayersCircular(.25, .25, 0);
        
      }
      
      else {
        rmSetPlacementTeam(1);
        rmSetPlacementSection(.74, .75);
        rmPlacePlayersCircular(.25, .25, 0);
        
        rmSetPlacementTeam(0);
        rmSetPlacementSection(.24, .25);
        rmPlacePlayersCircular(.25, .25, 0);
      }
    }
  }
  
  // ffa
  else {
    rmSetTeamSpacingModifier(0.5);
    rmPlacePlayersCircular(.275, .275, 0.05);
  }
  
  // Set up player areas.
  float playerFraction=rmAreaTilesToFraction(100);
  for(i=1; <cNumberPlayers) {
    int id=rmCreateArea("Player"+i);
    rmSetPlayerArea(i, id);
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classPlayer);
    rmAddAreaConstraint(id, avoidTradeRouteSockets); 
    rmAddAreaConstraint(id, shortAvoidTradeRoute); 
    rmAddAreaConstraint(id, shortAvoidImportantItem); 
    rmAddAreaConstraint(id, playerConstraint); 
    rmAddAreaConstraint(id, playerEdgeConstraint); 
    rmSetAreaCoherence(id, 1.0);
    rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, true);
  }

	// Build the areas.
  rmBuildAllAreas();
    
  // Text
  rmSetStatusText("",0.20);
    
  // Natives
  
  // always one native village of each type
  if (subCiv0 == rmGetCivID(nativeCiv1)) {  
    int nativeVillage1Type = rmRandInt(1,5);
    int nativeVillage1ID = rmCreateGrouping("native village 1", "native sufi mosque borneo "+nativeVillage1Type);
    rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage1ID, 10.0);
    rmAddGroupingToClass(nativeVillage1ID, rmClassID("importantItem"));
    rmAddGroupingConstraint(nativeVillage1ID, avoidImportantItem);
    rmAddGroupingConstraint(nativeVillage1ID, longPlayerConstraint);
    rmAddGroupingConstraint(nativeVillage1ID, avoidTradeRouteSockets);
    rmAddGroupingConstraint(nativeVillage1ID, avoidTradeRouteFar);
    rmAddGroupingConstraint(nativeVillage1ID, avoidImpassableLand);
    rmPlaceGroupingInArea(nativeVillage1ID, 0, invisIslandID, 1);	
  }	

  if (subCiv1 == rmGetCivID(nativeCiv2)) {  
    int nativeVillage2Type = rmRandInt(1,5);
    int nativeVillage2ID = rmCreateGrouping("native village 2", "native jesuit mission borneo 0"+nativeVillage2Type);
    rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage2ID, 10.0);
    rmAddGroupingToClass(nativeVillage2ID, rmClassID("importantItem"));
    rmAddGroupingConstraint(nativeVillage2ID, avoidImportantItem);
    rmAddGroupingConstraint(nativeVillage2ID, longPlayerConstraint);
    rmAddGroupingConstraint(nativeVillage2ID, avoidTradeRouteSockets);
    rmAddGroupingConstraint(nativeVillage2ID, avoidTradeRouteFar);
    rmAddGroupingConstraint(nativeVillage2ID, avoidImpassableLand);
    rmPlaceGroupingInArea(nativeVillage2ID, 0, invisIslandID, 1);	
  }  

  // starting resources

  int startingTCID= rmCreateObjectDef("startingTC");
	if (rmGetNomadStart()) {
			rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
  }
		
  else {
    rmAddObjectDefItem(startingTCID, "townCenter", 1, 0.0);
  }

  rmSetObjectDefMinDistance(startingTCID, 5);
	rmSetObjectDefMaxDistance(startingTCID, 10);
	rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
  rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
	rmAddObjectDefToClass(startingTCID, rmClassID("player"));

   // Text
   rmSetStatusText("",0.35);
  
  rmClearClosestPointConstraints();

	for(i=1; < cNumberPlayers) {
		int placedTC = rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(startSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

    // Food
		rmPlaceObjectDefAtLoc(StartBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(startFoodID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Place a nugget for the player
    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    //Japanese
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Place water spawn points for the players
		int waterSpawnPointID=rmCreateObjectDef("colony ship "+i);
		rmAddObjectDefItem(waterSpawnPointID, "HomeCityWaterSpawnFlag", 1, 10.0);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
    rmAddClosestPointConstraint(flagEdgeConstraint);
		vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(waterSpawnPointID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));

    rmClearClosestPointConstraints();
  }

	// Text
	rmSetStatusText("",0.45);

	// Silver

	int silverID = -1;
 	int silverID2 = -1;

  int silverCount = 0;
  
  silverCount = cNumberNonGaiaPlayers*3;
  
	rmEchoInfo("silver count = "+silverCount);

  // gold mines in the center
  silverID = rmCreateObjectDef("silver mines"+i);
  rmAddObjectDefItem(silverID, "minegold", 1, 0.0);
  rmSetObjectDefMinDistance(silverID, 0.0);
  rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silverID, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID, avoidSilver);
  rmAddObjectDefConstraint(silverID, avoidGold);
  rmAddObjectDefConstraint(silverID, longPlayerConstraint);
  rmAddObjectDefConstraint(silverID, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
  rmAddObjectDefConstraint(silverID, avoidTradeRouteSocketsShort);
  rmPlaceObjectDefInArea(silverID, 0, invisIslandID, silverCount);
   
  // silver mines over the entirety of the island
  silverID2 = rmCreateObjectDef("closer silver mines"+i);
  rmAddObjectDefItem(silverID2, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(silverID2, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(silverID2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silverID2, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID2, avoidSilver);
  rmAddObjectDefConstraint(silverID2, avoidGold);
  rmAddObjectDefConstraint(silverID2, playerConstraint);
  rmAddObjectDefConstraint(silverID2, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(silverID2, shortAvoidImportantItem);
  rmAddObjectDefConstraint(silverID2, avoidTradeRouteSocketsShort);
  rmPlaceObjectDefInArea(silverID2, 0, mainIslandID, silverCount);
   
  // Berries
  int berriesID=rmCreateObjectDef("berries");
	rmAddObjectDefItem(berriesID, "berrybush", 7, 6.0);
	rmSetObjectDefMinDistance(berriesID, 0);
	rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.35));
	rmAddObjectDefConstraint(berriesID, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(berriesID, longPlayerConstraint);
  rmAddObjectDefConstraint(berriesID, avoidTradeRouteSockets);   
  rmAddObjectDefConstraint(berriesID, avoidBerries);
  rmAddObjectDefConstraint(berriesID, shortAvoidImportantItem);
  rmAddObjectDefConstraint(berriesID, avoidResource);
  rmPlaceObjectDefPerPlayer(berriesID, false, 3);
  
// Nuggets first since the forest is going to be really packed in and will make them hard to place

  int nugget4= rmCreateObjectDef("nugget nuts"); 
  rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(4, 4);
  rmSetObjectDefMinDistance(nugget4, 0.0);
  rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.2));
  rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget4, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget4, avoidResource);
  rmAddObjectDefConstraint(nugget4, avoidNuggets);
  rmAddObjectDefConstraint(nugget4, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget4, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget4, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget4, circleConstraint);
  rmPlaceObjectDefInArea(nugget4, 0, invisIslandID, cNumberNonGaiaPlayers);

  int nugget3= rmCreateObjectDef("nugget hard"); 
  rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(3, 3);
  rmSetObjectDefMinDistance(nugget3, 0.0);
  rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.2));
  rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget3, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget3, avoidResource);
  rmAddObjectDefConstraint(nugget3, avoidNuggets);
  rmAddObjectDefConstraint(nugget3, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget3, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget3, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget3, circleConstraint);
  rmPlaceObjectDefInArea(nugget3, 0, invisIslandID, cNumberNonGaiaPlayers+rmRandInt(2,3));

  int nugget2= rmCreateObjectDef("nugget medium"); 
  rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(2, 2);
  rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget2, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget2, avoidResource);
  rmAddObjectDefConstraint(nugget2, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget2, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget2, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget2, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget2, circleConstraint);
  rmSetObjectDefMinDistance(nugget2, rmXFractionToMeters(0.25));
  rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.3));
  rmPlaceObjectDefInArea(nugget2, 0, mainIslandID, cNumberNonGaiaPlayers*2);

  int nugget1= rmCreateObjectDef("nugget easy"); 
  rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(1, 1);
  rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget1, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget1, shortAvoidResource);
  rmAddObjectDefConstraint(nugget1, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget1, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget1, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget1, playerConstraint);
  rmAddObjectDefConstraint(nugget1, circleConstraint);
  rmSetObjectDefMinDistance(nugget1, rmXFractionToMeters(0.3));
  rmSetObjectDefMaxDistance(nugget1, rmXFractionToMeters(0.4));
  rmPlaceObjectDefInArea(nugget1, 0, mainIslandID, cNumberNonGaiaPlayers*3);

// Forests
	int forestTreeID = 0;
	
	int numTries=10*cNumberNonGaiaPlayers; 
	int failCount=0;
	for (i=0; <numTries)	{   
    int forestID=rmCreateArea("foresta"+i, invisIslandID);
    rmAddAreaToClass(forestID, rmClassID("classForest"));
    rmSetAreaWarnFailure(forestID, false);
    rmSetAreaSize(forestID, rmAreaTilesToFraction(275), rmAreaTilesToFraction(375));
    rmSetAreaForestType(forestID, forestType);
    rmSetAreaForestDensity(forestID, 0.8);
    rmSetAreaForestClumpiness(forestID, 0.5);
    rmSetAreaForestUnderbrush(forestID, 0.8);
    rmSetAreaMinBlobs(forestID, 1);
    rmSetAreaMaxBlobs(forestID, 2);	
    rmSetAreaMinBlobDistance(forestID, 6.0);
    rmSetAreaMaxBlobDistance(forestID, 10.0);
    rmSetAreaCoherence(forestID, 0.4);
    rmSetAreaSmoothDistance(forestID, 10);
    rmAddAreaConstraint(forestID, mediumPlayerConstraint);  
    rmAddAreaConstraint(forestID, forestAvoidResource);
    rmAddAreaConstraint(forestID, shortAvoidTradeRoute);
    rmAddAreaConstraint(forestID, forestConstraint);
    rmAddAreaConstraint(forestID, avoidTradeRouteSocketsShort);
    rmAddAreaConstraint(forestID, shortAvoidImportantItem);
    rmAddAreaConstraint(forestID, avoidImpassableLand);
    rmAddAreaConstraint(forestID, avoidNuggetsShort);
    
    if(rmBuildArea(forestID)==false)
    {
      // Stop trying once we fail 5 times in a row.  
      failCount++;
      if(failCount==5)
        break;
    }
    else
      failCount=0; 
  } 

  failCount=0; 
  for (i=0; <numTries)	{   
    int forest2ID=rmCreateArea("forestb"+i);
    rmAddAreaToClass(forest2ID, rmClassID("classForest"));
    rmSetAreaWarnFailure(forest2ID, false);
    rmSetAreaSize(forest2ID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
    rmSetAreaForestType(forest2ID, forestType2);
    rmSetAreaForestDensity(forest2ID, 0.4);
    rmSetAreaForestClumpiness(forest2ID, 0.3);
    rmSetAreaForestUnderbrush(forest2ID, 0.0);
    rmSetAreaMinBlobs(forest2ID, 4);
    rmSetAreaMaxBlobs(forest2ID, 7);	
    rmSetAreaMinBlobDistance(forest2ID, 3.0);
    rmSetAreaMaxBlobDistance(forest2ID, 5.0);
    rmSetAreaCoherence(forest2ID, 0.4);
    rmSetAreaSmoothDistance(forest2ID, 10);
    rmAddAreaConstraint(forest2ID, playerConstraint);  
    rmAddAreaConstraint(forest2ID, forestAvoidResource);
    rmAddAreaConstraint(forest2ID, forestConstraint);
    rmAddAreaConstraint(forest2ID, shortAvoidTradeRoute);
    rmAddAreaConstraint(forest2ID, avoidTradeRouteSocketsShort);
    rmAddAreaConstraint(forest2ID, shortAvoidImportantItem);
    rmAddAreaConstraint(forest2ID, avoidImpassableLand);
    rmAddAreaConstraint(forest2ID, avoidNuggetsShort);
    
    if(rmBuildArea(forest2ID)==false)
    {
      // Stop trying once we fail 5 times in a row.  
      failCount++;
      if(failCount==5)
        break;
    }
    else
      failCount=0; 
  } 
  
  failCount=0; 
  
	// Text
	rmSetStatusText("",0.85);
  
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
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.05;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }	

	// Resources that can be placed after forests
  
  rmPlaceObjectDefAtLoc(food1ID, 0, 0.5, 0.5, 2.5*cNumberNonGaiaPlayers);
  rmPlaceObjectDefAtLoc(food2ID, 0, 0.5, 0.5, 3.0*cNumberNonGaiaPlayers);
  
	// Text
	rmSetStatusText("",0.90);
    
  int fishID=rmCreateObjectDef("fish 1");
  rmAddObjectDefItem(fishID, fish1, 1, 0.0);
  rmSetObjectDefMinDistance(fishID, 0.0);
  rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(fishID, fishVsFishID);
  rmAddObjectDefConstraint(fishID, fishLand);
  rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);
    
  int fish2ID=rmCreateObjectDef("fish 2");
  rmAddObjectDefItem(fish2ID, fish2, 1, 0.0);
  rmSetObjectDefMinDistance(fish2ID, 0.0);
  rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(fish2ID, fishVsFish2ID);
  rmAddObjectDefConstraint(fish2ID, fishLand);
  rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);
  
  // extra fish for under 5 players
  if (cNumberNonGaiaPlayers < 5) {
    int fish3ID=rmCreateObjectDef("fish 3");
    rmAddObjectDefItem(fish3ID, fish1, 1, 0.0);
    rmSetObjectDefMinDistance(fish3ID, 0.0);
    rmSetObjectDefMaxDistance(fish3ID, rmXFractionToMeters(0.5));
    rmAddObjectDefConstraint(fish3ID, fishVsFishID);
    rmAddObjectDefConstraint(fish3ID, fishLand);
    rmPlaceObjectDefAtLoc(fish3ID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);
  }  
    
  int whaleID=rmCreateObjectDef("whale");
  rmAddObjectDefItem(whaleID, whale1, 1, 0.0);
  rmSetObjectDefMinDistance(whaleID, 0.0);
  rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);  
  rmAddObjectDefConstraint(whaleID, whaleEdgeConstraint);
  rmAddObjectDefConstraint(whaleID, whaleLand);
  rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
  
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
