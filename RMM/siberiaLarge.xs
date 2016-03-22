// Silk Road 
// PJJ
// Sept 2006 ~ started with a modified version of pampas

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);
 
  // initialize map type variables 
  string baseMix = "";
  string baseTerrain = "";
 
  string forestType = "";
  string startTreeType = "";
  
  string mapType1 = "";
  string mapType2 = "";
  
  string patchMix = "rockies_snow";
  
  string huntable1 = "";
  string huntable2 = "";
  
  string lightingType = "";
  
  string tradeRouteType = "";
  
  // snow
  baseMix = "rockies_grass_snowb";
  baseTerrain = "yukon\ground8_yuk";
  forestType = "Yukon Snow Forest";
  startTreeType = "TreeYukonSnow";
  mapType1 = "siberia";
  mapType2 = "grass";
  huntable1 = "ypMuskDeer";
  huntable2 = "ypSaiga";   
  lightingType = "great lakes winter";
  tradeRouteType = "water";
	
// Map Basics

  bool weird = false;
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
    
  if (cNumberTeams > 2 || (teamZeroCount - teamOneCount) > 2 || (teamOneCount - teamZeroCount) > 2)
    weird = true;
    
	int playerTiles = 26000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles =25000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 24000;
    
  if (weird == true) 
    playerTiles = playerTiles*1.75;

	rmEchoInfo("Player Tiles = "+playerTiles);

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 10, 0.4, 7.0);
	rmSetMapElevationHeightBlend(1);
	
	rmSetSeaLevel(1.0);
	rmSetLightingSet(lightingType);

	rmSetBaseTerrainMix(baseMix);
	rmTerrainInitialize(baseTerrain, 0.0);
	rmEnableLocalWater(false);
	rmSetMapType(mapType1);
	rmSetMapType(mapType2);
	rmSetMapType("land");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);

	chooseMercs();
	
// Classes
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("classIce");
  rmDefineClass("classIcePatch");
  rmDefineClass("classPatch");

// Constraints
    
	// Map edge constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(12), rmZTilesToFraction(12), 1.0-rmXTilesToFraction(12), 1.0-rmZTilesToFraction(12), 0.01);

	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 25.0);
  int longPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players long", classPlayer, 45.0);
  int playerConstraintNugget = rmCreateClassDistanceConstraint("nuggets stay away from players long", classPlayer, 55.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players medium", classPlayer, 15.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 5.0);

	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int shortAvoidResource=rmCreateTypeDistanceConstraint("resource avoid resource short", "resource", 5.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);
	   
	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
  int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

  // resource avoidance
	int avoidSilver=rmCreateTypeDistanceConstraint("gold avoid gold", "Mine", 60.0);
  int avoidUnderbrush=rmCreateTypeDistanceConstraint("underbrush avoid", "underbrushYukon", 35.0);
	int mediumAvoidSilver=rmCreateTypeDistanceConstraint("medium gold avoid gold", "Mine", 30.0);
	int avoidHuntable1=rmCreateTypeDistanceConstraint("avoid huntable1", huntable1, 60.0);
	int avoidHuntable2=rmCreateTypeDistanceConstraint("avoid huntable2", huntable2, 60.0);
	int avoidNuggets=rmCreateTypeDistanceConstraint("nugget vs. nugget", "AbstractNugget", 20.0);
	int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget vs. nugget far", "AbstractNugget", 60.0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int circleConstraintTwo=rmCreatePieConstraint("circle Constraint 2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Unit avoidance
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), rmXFractionToMeters(0.3));
	int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other short", rmClassID("importantItem"), 7.0);

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);
  int avoidIce = rmCreateClassDistanceConstraint("vs ice", rmClassID("classIce"), 5.0);
  int avoidIcePatch = rmCreateClassDistanceConstraint("vs ice patches", rmClassID("classIcePatch"), 10.0);
  
	// Trade route avoidance.
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid trade route sockets", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketsFar=rmCreateTypeDistanceConstraint("avoid trade route sockets far", "socketTradeRoute", 40.0);
	int avoidMineSockets=rmCreateTypeDistanceConstraint("avoid mine sockets", "mine", 10.0);


// ************************** DEFINE OBJECTS ****************************
	
  int deerID=rmCreateObjectDef("huntable1");
	rmAddObjectDefItem(deerID, huntable1, rmRandInt(8,10), 6.0);
	rmSetObjectDefCreateHerd(deerID, true);
	rmSetObjectDefMinDistance(deerID, 0.0);
	rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(deerID, avoidResource);
	rmAddObjectDefConstraint(deerID, playerConstraint);
	rmAddObjectDefConstraint(deerID, avoidImpassableLand);
	rmAddObjectDefConstraint(deerID, avoidHuntable1);
	rmAddObjectDefConstraint(deerID, avoidHuntable2);
  rmAddObjectDefConstraint(deerID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(deerID, avoidTradeRouteSockets);
  
  int tapirID=rmCreateObjectDef("huntable2");
	rmAddObjectDefItem(tapirID, huntable2, rmRandInt(10,12), 6.0);
	rmSetObjectDefCreateHerd(tapirID, true);
	rmSetObjectDefMinDistance(tapirID, 0.0);
	rmSetObjectDefMaxDistance(tapirID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(tapirID, avoidResource);
	rmAddObjectDefConstraint(tapirID, playerConstraint);
	rmAddObjectDefConstraint(tapirID, avoidImpassableLand);
	rmAddObjectDefConstraint(tapirID, avoidHuntable1);
	rmAddObjectDefConstraint(tapirID, avoidHuntable2);
	rmAddObjectDefConstraint(tapirID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(tapirID, avoidTradeRouteSockets);
  
  int StartDeerID=rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(StartDeerID, huntable1, 7, 4.0);
	rmSetObjectDefMinDistance(StartDeerID, 12.0);
	rmSetObjectDefMaxDistance(StartDeerID, 18.0);
	rmSetObjectDefCreateHerd(StartDeerID, false);
	rmAddObjectDefConstraint(StartDeerID, avoidHuntable1);    
	rmAddObjectDefConstraint(StartDeerID, avoidHuntable2);    
   
	// -------------Done defining objects
  // Text
  rmSetStatusText("",0.10);
  
  int IceArea1ID=rmCreateArea("Ice Area 1");
	rmSetAreaSize(IceArea1ID, 0.09, 0.09);
	rmSetAreaLocation(IceArea1ID, 0.0, 0.5);
	//rmSetAreaTerrainType(IceArea1ID, "great_lakes\ground_ice1_gl");
	rmSetAreaMix(IceArea1ID, "great_lakes_ice");
  rmAddAreaToClass(IceArea1ID, rmClassID("classIce"));
	rmSetAreaBaseHeight(IceArea1ID, 0.0);
  rmAddAreaInfluenceSegment(IceArea1ID, 0.0, 0.5, 1.0, 0.5);
  rmAddAreaInfluenceSegment(IceArea1ID, 0.0, 0.45, 1.0, 0.45);
  rmAddAreaInfluenceSegment(IceArea1ID, 0.0, 0.55, 1.0, 0.55);    
  rmSetAreaObeyWorldCircleConstraint(IceArea1ID, false);
	rmSetAreaMinBlobs(IceArea1ID, 4);
	rmSetAreaMaxBlobs(IceArea1ID, 8);
	rmSetAreaMinBlobDistance(IceArea1ID, 5);
	rmSetAreaMaxBlobDistance(IceArea1ID, 8);
	rmSetAreaSmoothDistance(IceArea1ID, 8);
	rmSetAreaCoherence(IceArea1ID, 0.7);
	rmBuildArea(IceArea1ID); 
  
  for(i = 0; < rmRandInt(7, 9)) {
    int IceAreaID=rmCreateArea("Ice Area"+i);
    float iceLoc = rmRandFloat(0.15, 0.85);
    float xVar = rmRandFloat(-0.05, 0.05)*3.5;
    float yVar = rmRandFloat(-0.05, 0.05)*3.5;
    rmSetAreaSize(IceAreaID, rmAreaTilesToFraction(250), rmAreaTilesToFraction(300));
    rmSetAreaLocation(IceAreaID, iceLoc, .5);
    //rmSetAreaTerrainType(IceArea1ID, "great_lakes\ground_ice1_gl");
    rmSetAreaMix(IceAreaID, "great_lakes_ice");
    //~ rmSetAreaMix(IceAreaID, "mongolia_desert");
    rmAddAreaToClass(IceAreaID, rmClassID("classIce"));
    rmAddAreaToClass(IceAreaID, rmClassID("classIcePatch"));
    rmAddAreaInfluenceSegment(IceAreaID, iceLoc, 0.5, iceLoc+xVar, .5+yVar);
    rmSetAreaObeyWorldCircleConstraint(IceAreaID, false);
    rmAddAreaConstraint(IceAreaID, playerConstraint);
    rmAddAreaConstraint(IceAreaID, avoidIcePatch);
    rmAddAreaConstraint(IceAreaID, avoidTradeRouteSockets);
    rmAddAreaConstraint(IceAreaID, shortAvoidImportantItem);
    rmSetAreaMinBlobs(IceAreaID, 3);
    rmSetAreaMaxBlobs(IceAreaID, 5);
	  rmSetAreaMinBlobDistance(IceAreaID, 12);
	  rmSetAreaMaxBlobDistance(IceAreaID, 15);
    rmSetAreaSmoothDistance(IceAreaID, 8);
    rmSetAreaCoherence(IceAreaID, 0.55);
    rmSetAreaWarnFailure(IceAreaID, false);
    rmBuildArea(IceAreaID); 
  }
	
  // TRADE ROUTE PLACEMENT
   int tradeRouteID = rmCreateTradeRoute();

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

  rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
  rmSetObjectDefMinDistance(socketID, 0.0);
  rmSetObjectDefMaxDistance(socketID, 8.0);

  // Southern trade route
  rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 1.0);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 0.0);

  bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "water");
  if(placedTradeRoute == false)
    rmEchoError("Failed to place trade route"); 
  
	// add the sockets along the trade route.
  vector socketLoc  = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
      
  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
  int tpAreaID=rmCreateArea("TP patch");
	rmSetAreaSize(tpAreaID, 0.005, 0.005);
	rmSetAreaLocation(tpAreaID, 0.2, 0.5);
	rmSetAreaMix(tpAreaID, patchMix);
  rmAddAreaToClass(tpAreaID, rmClassID("classIce"));
	rmSetAreaBaseHeight(tpAreaID, 0.0);
	rmSetAreaCoherence(tpAreaID, 0.7);
	rmBuildArea(tpAreaID); 

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  if(cNumberNonGaiaPlayers > 5) {
  
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  
      
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.65);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);        
  }
  
// Players
  
   // Text
   rmSetStatusText("",0.20);
  
   // Players start on either side of the frozen river
  
	float teamStartLoc = rmRandFloat(0.0, 1.0); 

  if (cNumberTeams == 2 ) {
    if (cNumberNonGaiaPlayers == 2) {
      if (teamStartLoc > 0.5) {
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.5, 0.8, 0.51, 0.8, 0, 0);
          
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.5, 0.2, 0.51, 0.2, 0, 0);                
      }
      else {
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.5, 0.8, 0.51, 0.8, 0, 0);  
          
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.5, 0.2, 0.51, 0.2, 0, 0);                  
      }
    } 
    else {
      //Team 0 starts on top
      if (teamStartLoc > 0.5) {
        rmSetPlacementTeam(0);  
        rmPlacePlayersLine(0.35, 0.8, 0.7, 0.8, 0.2, 0.1); 
      
        rmSetPlacementTeam(1); 
        rmPlacePlayersLine(0.35, 0.2, 0.7, 0.2, 0.2, 0.1); 
      }
      
      else {
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.35, 0.8, 0.7, 0.8, 0.2, 0.1); 
          
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.35, 0.2, 0.7, 0.2, 0.2, 0.1);
      }     
    }
  }
  
  	// otherwise FFA
	else	{
    rmPlacePlayer(1, .55, .95);
    rmPlacePlayer(2, .55, .05);
    
    if(cNumberNonGaiaPlayers == 3 || cNumberNonGaiaPlayers == 5 || cNumberNonGaiaPlayers == 7) {
      
      rmPlacePlayer(3, .075, .6);
      
      if(cNumberNonGaiaPlayers == 5) {
        rmPlacePlayer(4, .25, .35);
        rmPlacePlayer(5, .35, .775);
      }
      
      else if (cNumberNonGaiaPlayers == 7){
        rmPlacePlayer(4, .075, .4);
        rmPlacePlayer(5, .35, .775);
        rmPlacePlayer(6, .25, .275);
        rmPlacePlayer(7, .4, .175);
      }
    }
    
    else {
      
      if(cNumberNonGaiaPlayers == 4) {
        rmPlacePlayer(3, .075, .6);
        rmPlacePlayer(4, .075, .4);
      }
      
      else if (cNumberNonGaiaPlayers == 6) {
        rmPlacePlayer(3, .075, .6);
        rmPlacePlayer(4, .075, .4);
        rmPlacePlayer(5, .325, .8);
        rmPlacePlayer(6, .325, .2);
      }
      
      else if(cNumberNonGaiaPlayers == 8){
        rmPlacePlayer(3, .075, .6);
        rmPlacePlayer(4, .075, .4);
        rmPlacePlayer(5, .4, .825);
        rmPlacePlayer(6, .4, .175);
        rmPlacePlayer(7, .25, .725);
        rmPlacePlayer(8, .25, .275);
      }
	  } 
  }
  
  // Set up player areas.
  float playerFraction=rmAreaTilesToFraction(100);
  for(i=1; <cNumberPlayers) {
    int id=rmCreateArea("Player"+i);
    rmSetPlayerArea(i, id);
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classPlayer);
    rmAddAreaConstraint(id, avoidTradeRouteSockets); 
    rmAddAreaConstraint(id, shortAvoidImportantItem); 
    rmAddAreaConstraint(id, playerConstraint); 
    rmAddAreaConstraint(id, playerEdgeConstraint); 
    rmSetAreaCoherence(id, 1.0);
    rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, false);
  }

	// Build the areas.
   rmBuildAllAreas();

  // starting resources
  int TCfloat = -1;
	if (cNumberTeams == 4)
		TCfloat = 5;
	else 
		TCfloat = 8;

  int startingTCID= rmCreateObjectDef("startingTC");
	if (rmGetNomadStart()) {
			rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 1.0);
  }
		
  else {
    rmAddObjectDefItem(startingTCID, "townCenter", 1, 1.0);
  }

  rmSetObjectDefMinDistance(startingTCID, 0);
	rmSetObjectDefMaxDistance(startingTCID, TCfloat);
	rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
  rmAddObjectDefConstraint(startingTCID, avoidIce);
	rmAddObjectDefToClass(startingTCID, rmClassID("player"));

  int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 6, 6.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 16);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 22);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImportantItem);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRouteSockets);

   // Text
   rmSetStatusText("",0.30);

  int startSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(startSilverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(startSilverID, 12.0);
	rmSetObjectDefMaxDistance(startSilverID, 20.0);
	rmAddObjectDefConstraint(startSilverID, avoidAll);
	rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
  rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);

  // Ensure that starting outpost is near the gold
  int startingOutpostAsianID=rmCreateObjectDef("Starting Asian Outpost");
  rmAddObjectDefItem(startingOutpostAsianID, "ypOutpostAsian", 1, 6.0);
  rmAddObjectDefItem(startingOutpostAsianID, "mine", 1, 6.0);
  rmSetObjectDefMinDistance(startingOutpostAsianID, 20.0);
  rmSetObjectDefMaxDistance(startingOutpostAsianID, 25.0);
  rmAddObjectDefToClass(startingOutpostAsianID, rmClassID("importantItem"));
  rmAddObjectDefConstraint(startingOutpostAsianID, avoidAll);
  rmAddObjectDefConstraint(startingOutpostAsianID, avoidIce);
  
  int playerBerryID=rmCreateObjectDef("player berries");
  rmAddObjectDefItem(playerBerryID, "berryBush", 4, 4.0);
  rmSetObjectDefMinDistance(playerBerryID, 10);
  rmSetObjectDefMaxDistance(playerBerryID, 15);
	rmAddObjectDefConstraint(playerBerryID, avoidAll);
  rmAddObjectDefConstraint(playerBerryID, avoidIce);
  
  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 15.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 20.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
  
	// Text
	rmSetStatusText("",0.40);

	for(i=1; < cNumberPlayers) {
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(StartDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(playerBerryID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Place a nugget for the player
    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    if(rmGetNomadStart() == false) {
      
			// Placing outpost/gold
      if (rmGetPlayerCiv(i) == rmGetCivID("Japanese")) {
        rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      }
      
      else {
        rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      }
		}
    
    // nomad silver
    else {
      rmPlaceObjectDefAtLoc(startSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    }
	}

	// Text
	rmSetStatusText("",0.75);

	// Silver
	int silverID = -1;
 	int silverID2 = -1;

  int silverCount = 0;
  silverCount = cNumberNonGaiaPlayers*3;
  
	rmEchoInfo("silver count = "+silverCount);

  silverID2 = rmCreateObjectDef("closer silver mines"+i);
  rmAddObjectDefItem(silverID2, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(silverID2, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(silverID2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silverID2, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID2, avoidSilver);
  rmAddObjectDefConstraint(silverID2, longPlayerConstraint);
  rmAddObjectDefConstraint(silverID2, avoidIce);
  rmAddObjectDefConstraint(silverID2, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(silverID2, avoidTradeRouteSockets);
  rmPlaceObjectDefPerPlayer(silverID2, false, 5);
   
// Forests
	int forestTreeID = 0;
	
	int numTries=10*cNumberNonGaiaPlayers; 
	int failCount=0;
	for (i=0; <numTries)	{   
    int forestID=rmCreateArea("forest"+i);
    rmAddAreaToClass(forestID, rmClassID("classForest"));
    rmSetAreaWarnFailure(forestID, false);
    rmSetAreaSize(forestID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
    rmSetAreaForestType(forestID, forestType);
    rmSetAreaForestDensity(forestID, 0.5);
    rmSetAreaForestClumpiness(forestID, 0.3);
    rmSetAreaForestUnderbrush(forestID, 0.0);
    rmSetAreaMinBlobs(forestID, 1);
    rmSetAreaMaxBlobs(forestID, 2);					
    rmSetAreaMinBlobDistance(forestID, 6.0);
    rmSetAreaMaxBlobDistance(forestID, 10.0);
    rmSetAreaCoherence(forestID, 0.4);
    rmSetAreaSmoothDistance(forestID, 10);
    rmAddAreaConstraint(forestID, mediumPlayerConstraint);  
    rmAddAreaConstraint(forestID, shortAvoidResource);			
    rmAddAreaConstraint(forestID, shortAvoidTradeRoute);
    rmAddAreaConstraint(forestID, avoidTradeRouteSockets);
    rmAddAreaConstraint(forestID, avoidMineSockets);
    rmAddAreaConstraint(forestID, avoidIce);
    rmAddAreaConstraint(forestID, forestConstraint);
    rmAddAreaConstraint(forestID, shortAvoidImportantItem);
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

	
// *********************** OBJECTS PLACED AFTER FORESTS ********************
	// Resources that can be placed after forests
  
  rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
  rmPlaceObjectDefAtLoc(tapirID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

	// Text
	rmSetStatusText("",0.90);
	
	// Nuggets
  
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
  rmSetObjectDefMinDistance(nugget1, 0.0);
  rmSetObjectDefMaxDistance(nugget1, rmXFractionToMeters(0.99));
  rmPlaceObjectDefPerPlayer(nugget1, false, 2);

  int nugget2= rmCreateObjectDef("nugget medium"); 
  rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(2, 2);
  rmSetObjectDefMinDistance(nugget2, 0.0);
  rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget2, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget2, shortAvoidResource);
  rmAddObjectDefConstraint(nugget2, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget2, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget2, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget2, playerConstraint);
  rmAddObjectDefConstraint(nugget2, circleConstraint);
  rmSetObjectDefMinDistance(nugget2, 80.0);
  rmSetObjectDefMaxDistance(nugget2, 120.0);
  rmPlaceObjectDefPerPlayer(nugget2, false, 1);

  int nugget3= rmCreateObjectDef("nugget hard"); 
  rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(3, 3);
  rmSetObjectDefMinDistance(nugget3, 0.0);
  rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget3, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget3, shortAvoidResource);
  rmAddObjectDefConstraint(nugget3, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget3, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget3, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget3, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget3, circleConstraint);
  rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

  int nugget4= rmCreateObjectDef("nugget nuts"); 
  rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(4, 4);
  rmSetObjectDefMinDistance(nugget4, 0.0);
  rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget4, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget4, shortAvoidResource);
  rmAddObjectDefConstraint(nugget4, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget4, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget4, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget4, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget4, circleConstraint);
  rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(2,3));

    // Place random flags
    int avoidFlags = rmCreateTypeDistanceConstraint("flags avoid flags", "ControlFlag", 70);
    for ( i =1; <16 ) {
    int flagID = rmCreateObjectDef("random flag"+i);
    rmAddObjectDefItem(flagID, "ControlFlag", 1, 0.0);
    rmSetObjectDefMinDistance(flagID, 0.0);
    rmSetObjectDefMaxDistance(flagID, rmXFractionToMeters(0.40));
    rmAddObjectDefConstraint(flagID, avoidFlags);
    rmPlaceObjectDefAtLoc(flagID, 0, 0.5, 0.5);
    }

// check for KOTH game mode
  if(rmGetIsKOTH()) {
    int hillLoc = rmRandInt(1,4);
    float xLoc = 0.0;
    float yLoc = 0.0;
    float walk = 0.025;
    
    if(teamZeroCount == 1 && teamOneCount == 1 && cNumberTeams == 2){
      if (hillLoc < 3) {
        xLoc = 0.75;
        yLoc = 0.5;
      }
        
      else {
        yLoc = 0.5;
        xLoc = 0.5;
      }
    }
    
    else if(hillLoc < 3 || cNumberTeams > 2){
      xLoc = 0.6;
      yLoc = 0.5;
    }
    
    else {
      xLoc = 0.4;
      yLoc = 0.5;
    }
    
    ypKingsHillLandfill(xLoc, yLoc, .0065, 1.0, patchMix, 0);
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
  }
    
  // Vary some terrain
  for (i=0; < 15) {
    int patch=rmCreateArea("first patch "+i);
    rmSetAreaWarnFailure(patch, false);
    rmSetAreaSize(patch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
    rmSetAreaMix(patch, patchMix);
    rmAddAreaToClass(patch, rmClassID("classPatch"));
    rmSetAreaMinBlobs(patch, 1);
    rmSetAreaMaxBlobs(patch, 5);
    rmSetAreaMinBlobDistance(patch, 16.0);
    rmSetAreaMaxBlobDistance(patch, 40.0);
    rmSetAreaCoherence(patch, 0.0);
    rmAddAreaConstraint(patch, shortAvoidImpassableLand);
    rmAddAreaConstraint(patch, patchConstraint);
    rmAddAreaConstraint(patch, avoidIce);
    rmBuildArea(patch); 
  }
  
  int underBrushID = rmCreateObjectDef("underbrush");
  rmAddObjectDefItem(underBrushID, "underbrushYukon", 4, 5.0);
  rmSetObjectDefMinDistance(underBrushID, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(underBrushID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(underBrushID, avoidImpassableLand);
  rmAddObjectDefConstraint(underBrushID, avoidUnderbrush);
  rmAddObjectDefConstraint(underBrushID, avoidIce);
  rmAddObjectDefConstraint(underBrushID, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(underBrushID, avoidTradeRouteSockets);
  rmPlaceObjectDefPerPlayer(underBrushID, false, 9);
  
	// Text
	rmSetStatusText("",0.99);
   
}  
