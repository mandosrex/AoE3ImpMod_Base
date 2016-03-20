// Mongolia
// PJJ & JH
include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

  // initialize map type variables
  string nativeCiv1 = "Sufi";
  string nativeCiv2 = "Shaolin";
 
  string baseMix = "mongolia_grass_b";
  string secondaryMix = "mongolia_desert";
  string baseTerrain = "Mongolia\ground_grass1_mongol";
  
  string layerOne = "Mongolia\ground_grass3_mongol";
  string layerTwo = "Mongolia\ground_grass6_mongol";
 
  string steppeForest = "Mongolian Forest";
  string desertForest = "Saxaul Forest";
  string startTreeType = "ypTreeSaxaul";
  
  string mapType1 = "mongolia";
  
  string huntable1 = "ypSaiga";
  string huntable2 = "ypMuskDeer";
  
  string herdable1 = "ypYak";
  string herdable2 = "ypYak";
  
  string lightingType = "Mongolia";
  
   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;

	// Extra native sites in some cases
	int extraPoles=rmRandInt(1,2);
  
  // Determine native site/trade route position
  int nativesOnTop = rmRandInt(1,2);
  nativesOnTop = 2;
  //extraPoles = 2;
  
   if (rmAllocateSubCivs(2) == true)
   {
		  subCiv0=rmGetCivID(nativeCiv1);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, nativeCiv1);

		  subCiv1=rmGetCivID(nativeCiv2);
      if (subCiv1 >= 0)
         rmSetSubCiv(1, nativeCiv2);
   }

   // Picks the map size
	int playerTiles=22000;
  if (cNumberNonGaiaPlayers >4)
		playerTiles = 20500;
  if (cNumberNonGaiaPlayers >6)
      playerTiles = 20000;
   
  if(cNumberTeams > 2)
    playerTiles = playerTiles*1.8;

   rmEchoInfo("Player Tiles ="+playerTiles);
   
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Picks a default water height
	rmSetSeaLevel(1.0);

    // Picks default terrain and water
	rmSetMapElevationParameters(cElevTurbulence, 0.02, 7, 0.5, 8.0);
	rmSetBaseTerrainMix(baseMix);

	rmSetLightingSet(lightingType);
	rmSetMapType(mapType1);
	rmSetMapType("land");
	rmSetWorldCircleConstraint(true);
	rmSetMapType("grass");

	rmTerrainInitialize(baseMix, 0);
	chooseMercs();

	// Define some classes. These are used later for constraints.
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");	
	rmDefineClass("socketClass");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
  int longPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 30.0);
  int mediumPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a bit", classPlayer, 25.0);

   // Resource avoidance  
  int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 15.0);
  int forestConstraintShort=rmCreateClassDistanceConstraint("forest vs. forest short", rmClassID("classForest"), 8.0);
  int forestConstraintLong=rmCreateClassDistanceConstraint("forest vs. forest long", rmClassID("classForest"), 55.0);
  int coinForestConstraint=rmCreateClassDistanceConstraint("coin vs. forest", rmClassID("classForest"), 10.0);
  int avoidHuntable1=rmCreateTypeDistanceConstraint("Huntable1 avoids food", huntable1, 45.0);
  int avoidHuntable2=rmCreateTypeDistanceConstraint("huntable2 avoids food", huntable2, 40.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 25.0);
	int avoidStartingCoin=rmCreateTypeDistanceConstraint("starting coin avoids coin", "gold", 22.0);
  int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 45.0);
  int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
  int avoidHerdable2=rmCreateTypeDistanceConstraint("avoids Herdable2", herdable2, 45.0); 
  int avoidHerdable1=rmCreateTypeDistanceConstraint("avoids Herdable1", herdable1, 45.0); 

	int avoidFastCoin=-1;
	if (cNumberNonGaiaPlayers >6){
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.14));
	}
  
	else if (cNumberNonGaiaPlayers >4)	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.16));
	}
  
	else	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.18));
	}

  int avoidCoinMedium = rmCreateTypeDistanceConstraint("avoid coin medium", "mine", 8.0); 
  int avoidCoinLong = rmCreateTypeDistanceConstraint("avoid coin long", "gold", 75.0); 
  
  // Avoid impassable land
  int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
  int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);

  // Decoration avoidance
  int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

  // VP avoidance
  int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
  int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("trade route small", 4.0);
  int avoidImportantItem=rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 15.0);

	int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 8.0);
	int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);
  int avoidSocketActual = rmCreateTypeDistanceConstraint("avoid sockets", "SocketTradeRoute", 6.0);
	
	// natives avoid natives
	int avoidNatives = rmCreateClassDistanceConstraint("avoid Natives", rmClassID("natives"), 7.0);
	int avoidNativesNuggets = rmCreateClassDistanceConstraint("nuggets avoid Natives", rmClassID("natives"), 12.0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Text
   rmSetStatusText("",0.10);
	
   // TRADE ROUTE PLACEMENT
   int tradeRouteID = rmCreateTradeRoute();

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

  rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
  rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
  rmSetObjectDefMinDistance(socketID, 0.0);
  rmSetObjectDefMaxDistance(socketID, 8.0);

  // Southern trade route
  if (nativesOnTop == 1) {
    rmAddTradeRouteWaypoint(tradeRouteID, 0.01, 0.55);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.075, 0.475);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.35);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.175, 0.275);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.275, 0.175);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.15);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.475, 0.075);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.01);
  }
  
  // northern trade route
  else {
    rmAddTradeRouteWaypoint(tradeRouteID, 0.99, 0.55);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.55);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.825, 0.575);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.575, 0.825);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.95);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.99);
  }
  
  bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "water");
  if(placedTradeRoute == false)
    rmEchoError("Failed to place trade route"); 
  
	// add the sockets along the trade route.
  vector socketLoc  = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
    
  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.1);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.9);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  if (cNumberNonGaiaPlayers > 2 && cNumberNonGaiaPlayers != 6 && cNumberNonGaiaPlayers != 5) {
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  
  } 
  
  else if (cNumberNonGaiaPlayers < 7) {
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.37);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  

    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.63);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);           
  }
  
  if (cNumberNonGaiaPlayers > 6) {
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.3);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  

    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);              
  }

  // DEFINE AREAS
  // Set up player starting locations.

  
  if(cNumberTeams == 2) {
    if(cNumberNonGaiaPlayers == 2){
        rmPlacePlayer(1, .15, .575);
        rmPlacePlayer(2, .575, .15);
    }
    
    else {
      rmSetPlacementTeam(0);    
      rmSetTeamSpacingModifier(.25);
      rmPlacePlayersLine(0.2, 0.8, 0.2, 0.47, 0.0, 0.075);
        
      rmSetPlacementTeam(1);
      rmSetTeamSpacingModifier(.25);
      rmPlacePlayersLine(0.8, 0.2, 0.47, 0.2, 0.0, 0.075);
    }
  }
  
  // FFA
  else { 
    
    rmPlacePlayer(1, .15, .75);
    rmPlacePlayer(2, .75, .15);
    
    if(cNumberNonGaiaPlayers == 3 || cNumberNonGaiaPlayers == 5 || cNumberNonGaiaPlayers == 7) {
      rmPlacePlayer(3, .35, .35);
      
      if(cNumberNonGaiaPlayers == 5) {
        rmPlacePlayer(4, .25, .575);
        rmPlacePlayer(5, .575, .25);
      }
      
      else if (cNumberNonGaiaPlayers == 7){
        rmPlacePlayer(4, .2, .62);
        rmPlacePlayer(5, .25, .485);
        rmPlacePlayer(6, .485, .25);
        rmPlacePlayer(7, .62, .2);
      }

    }
    
    else {
      
      if(cNumberNonGaiaPlayers == 4) {
        rmPlacePlayer(3, .25, .485);
        rmPlacePlayer(4, .485, .25);
      }
      
      else if (cNumberNonGaiaPlayers == 6) {
        rmPlacePlayer(3, .58, .19);
        rmPlacePlayer(4, .19, .58);
        rmPlacePlayer(5, .26, .42);
        rmPlacePlayer(6, .42, .26);
      }
      
      else if(cNumberNonGaiaPlayers == 8){
        rmPlacePlayer(3, .62, .18);
        rmPlacePlayer(4, .18, .62);
        rmPlacePlayer(5, .21, .49);
        rmPlacePlayer(6, .49, .21);
        rmPlacePlayer(7, .26, .36);
        rmPlacePlayer(8, .36, .26);
      }
    }
  }
  
  // Set up player areas.
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
    rmAddAreaConstraint(id, playerEdgeConstraint); 
    rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, false);
   }

	int numTries = -1;
	int failCount = -1;

	// Text
  rmSetStatusText("",0.20);
   
  // North Paint
  int northPaint=rmCreateArea("painting northern steppe");
  rmSetAreaSize(northPaint, 1.0, 1.0);
  rmSetAreaWarnFailure(northPaint, false);
  rmSetAreaMix(northPaint, baseMix);
  rmSetAreaSmoothDistance(northPaint, 5);
	rmSetAreaCoherence(northPaint, 1.0);
	rmSetAreaLocation(northPaint, .5, .5);
	rmSetAreaObeyWorldCircleConstraint(northPaint, false);
	rmBuildArea(northPaint);
   
  // south desert
  int desertID=rmCreateArea("southern desert");
  int avoidDesert = rmCreateAreaDistanceConstraint("avoid southern desert", desertID, 5.0);

  rmSetAreaSize(desertID, 0.375, 0.375);
  rmSetAreaWarnFailure(desertID, false);
  rmSetAreaSmoothDistance(desertID, 10);
  rmSetAreaMix(desertID, secondaryMix);  
  rmAddAreaTerrainLayer(desertID, layerOne, 0, 5);
  rmAddAreaTerrainLayer(desertID, layerTwo, 5, 10);
  rmSetAreaElevationType(desertID, cElevTurbulence);
  rmSetAreaElevationVariation(desertID, 6.0);
  rmSetAreaBaseHeight(desertID, 0);
  rmSetAreaElevationMinFrequency(desertID, 0.05);
  rmSetAreaElevationOctaves(desertID, 3);
  rmSetAreaElevationPersistence(desertID, 0.3);
  rmSetAreaElevationNoiseBias(desertID, 0.5);
  rmSetAreaElevationEdgeFalloffDist(desertID, 20.0);
  rmSetAreaCoherence(desertID, 0.65);
  rmSetAreaLocation(desertID, 0.0, 0.0);
  rmSetAreaEdgeFilling(desertID, 5);

  if (cNumberTeams == 2) {
    rmAddAreaInfluenceSegment(desertID, 0.85, 0, 0.65, 0.25);
    rmAddAreaInfluenceSegment(desertID, 0.25, 0.65, 0, 0.85);
    rmAddAreaInfluenceSegment(desertID, 0.4, 0.2, 0.2, 0.4);
    rmAddAreaInfluenceSegment(desertID, 0.3, 0.2, 0.2, 0.3);
  }
  
  else {
    rmAddAreaInfluenceSegment(desertID, 0.9, 0, 0.15, 0.3);
    rmAddAreaInfluenceSegment(desertID, 0.3, 0.15, 0, 0.9);
  }
  
  rmSetAreaHeightBlend(desertID, 1);
  rmSetAreaObeyWorldCircleConstraint(desertID, false);
  rmBuildArea(desertID);

  // Text
  rmSetStatusText("",0.30);

	// Natives
  
  if (subCiv0 == rmGetCivID(nativeCiv1)) {  
    int comancheVillageAID = -1;
    int comancheVillageType = rmRandInt(1,5);
    comancheVillageAID = rmCreateGrouping("Sufi A", "native sufi mosque mongol "+comancheVillageType);
    rmSetGroupingMinDistance(comancheVillageAID, 0.0);
    rmSetGroupingMaxDistance(comancheVillageAID, 10.0);
    rmAddGroupingConstraint(comancheVillageAID, avoidImpassableLand);
    rmAddGroupingToClass(comancheVillageAID, rmClassID("importantItem"));
    rmAddGroupingToClass(comancheVillageAID, rmClassID("natives"));
    rmAddGroupingConstraint(comancheVillageAID, avoidNatives);
    rmPlaceGroupingAtLoc(comancheVillageAID, 0, 0.4, 0.85); 
	}

  if (subCiv1 == rmGetCivID(nativeCiv2)) {   
    int lakotaVillageAID = -1;
    int lakotaVillageType = rmRandInt(1,5);
    lakotaVillageAID = rmCreateGrouping("shaolin A", "native shaolin temple mongol 0"+lakotaVillageType);
    rmSetGroupingMinDistance(lakotaVillageAID, 0.0);
    rmSetGroupingMaxDistance(lakotaVillageAID, 10.0);
    rmAddGroupingConstraint(lakotaVillageAID, avoidImpassableLand);
    rmAddGroupingToClass(lakotaVillageAID, rmClassID("importantItem"));
    rmAddGroupingToClass(lakotaVillageAID, rmClassID("natives"));
    rmAddGroupingConstraint(lakotaVillageAID, avoidNatives);
    rmPlaceGroupingAtLoc(lakotaVillageAID, 0, 0.85, 0.4);  
	}

  if(subCiv0 == rmGetCivID(nativeCiv1)) {   
    int lakotaVillageID = -1;
    lakotaVillageType = rmRandInt(1,5);
    lakotaVillageID = rmCreateGrouping("sufi b", "native sufi mosque mongol "+lakotaVillageType);
    rmSetGroupingMinDistance(lakotaVillageID, 0.0);
    rmSetGroupingMaxDistance(lakotaVillageID, 10.0);
    rmAddGroupingConstraint(lakotaVillageID, avoidImpassableLand);
    rmAddGroupingToClass(lakotaVillageID, rmClassID("importantItem"));
    rmAddGroupingToClass(lakotaVillageID, rmClassID("natives"));
    rmAddGroupingConstraint(lakotaVillageID, avoidNatives);
    
    if(extraPoles == 1) {
      if(nativesOnTop == 1)
        rmPlaceGroupingAtLoc(lakotaVillageID, 0, 0.7, 0.7);   
      
      else if (cNumberTeams > 2)   {
        
      }
      
      else
        rmPlaceGroupingAtLoc(lakotaVillageID, 0, 0.375, 0.375);   
    }
   }

	if(subCiv1 == rmGetCivID(nativeCiv2)) {   
    int comancheVillageBID = -1;
    comancheVillageType = rmRandInt(1,5);
    comancheVillageBID = rmCreateGrouping("shaolin B", "native shaolin temple mongol 0"+comancheVillageType);
    rmSetGroupingMinDistance(comancheVillageBID, 0.0);
    rmSetGroupingMaxDistance(comancheVillageBID, 10.0);
    rmAddGroupingConstraint(comancheVillageBID, avoidImpassableLand);
    rmAddGroupingToClass(comancheVillageBID, rmClassID("importantItem"));
    rmAddGroupingToClass(comancheVillageBID, rmClassID("natives"));
    rmAddGroupingConstraint(comancheVillageBID, avoidNatives);
   
    if(cNumberNonGaiaPlayers > 3 && extraPoles == 2) {
      if(nativesOnTop == 1)
        rmPlaceGroupingAtLoc(comancheVillageBID, 0, 0.6, 0.9);    
      
      else 
        rmPlaceGroupingAtLoc(comancheVillageBID, 0, 0.4, 0.6);    
    }
  }

	if(subCiv1 == rmGetCivID(nativeCiv2)) {
    int comancheVillageID = -1;
    comancheVillageType = rmRandInt(1,5);
    comancheVillageID = rmCreateGrouping("shaolin c", "native shaolin temple mongol 0"+comancheVillageType);
    rmSetGroupingMinDistance(comancheVillageID, 0.0);
    rmSetGroupingMaxDistance(comancheVillageID, 10.0);
    rmAddGroupingConstraint(comancheVillageID, avoidImpassableLand);
    rmAddGroupingToClass(comancheVillageID, rmClassID("importantItem"));
    rmAddGroupingToClass(comancheVillageID, rmClassID("natives"));
    rmAddGroupingConstraint(comancheVillageID, avoidNatives);

    if(extraPoles == 1) {
      if(nativesOnTop == 1)
        rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.5, 0.5);     
      
      else 
        rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.55, 0.55);    
    }
	}

  if (subCiv1 == rmGetCivID(nativeCiv2)) {   
    int lakotaVillageBID = -1;
    lakotaVillageType = rmRandInt(1,5);
    lakotaVillageBID = rmCreateGrouping("shaolin d", "native shaolin temple mongol 0"+lakotaVillageType);
    rmSetGroupingMinDistance(lakotaVillageBID, 0.0);
    rmSetGroupingMaxDistance(lakotaVillageBID, 10.0);
    rmAddGroupingConstraint(lakotaVillageBID, avoidImpassableLand);
    rmAddGroupingToClass(lakotaVillageBID, rmClassID("importantItem"));
    rmAddGroupingToClass(lakotaVillageBID, rmClassID("natives"));
    rmAddGroupingConstraint(lakotaVillageBID, avoidNatives);
    
    if(cNumberNonGaiaPlayers > 3 && extraPoles == 2){
      if(nativesOnTop == 1)
        rmPlaceGroupingAtLoc(lakotaVillageBID, 0, 0.9, 0.6);    
      
      else 
        rmPlaceGroupingAtLoc(lakotaVillageBID, 0, 0.6, 0.4);  
    }      
  }

  if (subCiv0 == rmGetCivID(nativeCiv1)) {   
    int comancheVillageDID = -1;
    comancheVillageType = rmRandInt(1,5);
    comancheVillageDID = rmCreateGrouping("sufi c", "native sufi mosque mongol "+comancheVillageType);
    rmSetGroupingMinDistance(comancheVillageDID, 0.0);
    rmSetGroupingMaxDistance(comancheVillageDID, 10.0);
    rmAddGroupingConstraint(comancheVillageDID, avoidImpassableLand);
    rmAddGroupingToClass(comancheVillageDID, rmClassID("importantItem"));
    rmAddGroupingToClass(comancheVillageDID, rmClassID("natives"));
    rmAddGroupingConstraint(comancheVillageDID, avoidNatives);
    
    if(extraPoles == 2) {     
        rmPlaceGroupingAtLoc(comancheVillageDID, 0, 0.6, 0.6);    
    }
  }   

  // Starting Units
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 7.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);

	int startingTCID = rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
  
	rmSetObjectDefMinDistance(startingTCID, 0.0);
	rmSetObjectDefMaxDistance(startingTCID, 5.0);
	rmAddObjectDefConstraint(startingTCID, avoidTradeRouteSmall);

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 13, 9.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 18.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 23.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
  rmAddObjectDefConstraint(StartAreaTreeID, playerConstraint);

	int StartHuntable1ID=rmCreateObjectDef("starting Huntable1");
	rmAddObjectDefItem(StartHuntable1ID, huntable1, 5, 4.0);
	rmSetObjectDefMinDistance(StartHuntable1ID, 10.0);
	rmSetObjectDefMaxDistance(StartHuntable1ID, 12.0);
	rmSetObjectDefCreateHerd(StartHuntable1ID, false);
	rmAddObjectDefConstraint(StartHuntable1ID, avoidAll);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 20.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 25.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSmall);
  rmAddObjectDefConstraint(playerNuggetID, playerConstraint);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
  
  int startingLivestockPen=rmCreateObjectDef("Starting Livestock Pen");
  rmAddObjectDefItem(startingLivestockPen, "LivestockPen", 1, 0.0);
  rmSetObjectDefMinDistance(startingLivestockPen, 20.0);
  rmSetObjectDefMaxDistance(startingLivestockPen, 22.0);
  rmAddObjectDefConstraint(startingLivestockPen, avoidTradeRoute);
	rmAddObjectDefConstraint(startingLivestockPen, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingLivestockPen, avoidAll);
  
  int startingFarm=rmCreateObjectDef("Starting Farm");
  rmAddObjectDefItem(startingFarm, "Farm", 1, 0.0);
  rmSetObjectDefMinDistance(startingFarm, 20.0);
  rmSetObjectDefMaxDistance(startingFarm, 22.0);
  rmAddObjectDefConstraint(startingFarm, avoidTradeRoute);
	rmAddObjectDefConstraint(startingFarm, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingFarm, avoidAll);
  
  int startingShrine=rmCreateObjectDef("Starting shrine");
  rmAddObjectDefItem(startingShrine, "ypShrineJapanese", 1, 0.0);
  rmSetObjectDefMinDistance(startingShrine, 20.0);
  rmSetObjectDefMaxDistance(startingShrine, 22.0);
  rmAddObjectDefConstraint(startingShrine, avoidTradeRoute);
	rmAddObjectDefConstraint(startingShrine, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingShrine, avoidAll);
  
  int startingVillage=rmCreateObjectDef("Starting village");
  rmAddObjectDefItem(startingVillage, "ypVillage", 1, 0.0);
  rmSetObjectDefMinDistance(startingVillage, 20.0);
  rmSetObjectDefMaxDistance(startingVillage, 22.0);
  rmAddObjectDefConstraint(startingVillage, avoidTradeRoute);
	rmAddObjectDefConstraint(startingVillage, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingVillage, avoidAll);
  
  int startingField=rmCreateObjectDef("Starting field");
  rmAddObjectDefItem(startingField, "ypSacredField", 1, 0.0);
  rmSetObjectDefMinDistance(startingField, 20.0);
  rmSetObjectDefMaxDistance(startingField, 22.0);
  rmAddObjectDefConstraint(startingField, avoidTradeRoute);
	rmAddObjectDefConstraint(startingField, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingField, avoidAll);
  
  //~ // +1 food crates for Japanese/Indians - Livestock balancing
  //~ int playerCrateID2=rmCreateObjectDef("bonus starting crates 2");
  //~ rmAddObjectDefItem(playerCrateID2, "crateOfFood", 1, 4.0);
  //~ rmSetObjectDefMinDistance(playerCrateID2, 6);
  //~ rmSetObjectDefMaxDistance(playerCrateID2, 10);
	//~ rmAddObjectDefConstraint(playerCrateID2, avoidAll);
  //~ rmAddObjectDefConstraint(playerCrateID2, shortAvoidImpassableLand);
  
  int StartBerriesID=rmCreateObjectDef("starting berries");
	rmAddObjectDefItem(StartBerriesID, "berrybush", 4, 5.0);
	rmSetObjectDefMinDistance(StartBerriesID, 10);
	rmSetObjectDefMaxDistance(StartBerriesID, 20);
	rmAddObjectDefConstraint(StartBerriesID, avoidAll);
	rmAddObjectDefConstraint(StartBerriesID, shortAvoidImpassableLand);

	rmSetStatusText("",0.40);

  // player gold
	int playerGoldID = rmCreateObjectDef("player silver closer");
  rmAddObjectDefItem(playerGoldID, "minegold", 1, 0.0);
  rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
  rmAddObjectDefConstraint(playerGoldID, avoidStartingCoin);
  rmAddObjectDefConstraint(playerGoldID, avoidAll);
  rmSetObjectDefMinDistance(playerGoldID, 20.0);
  rmSetObjectDefMaxDistance(playerGoldID, 23.0);
  
  int playerCrateID=rmCreateObjectDef("bonus starting crates");
  rmAddObjectDefItem(playerCrateID, "crateOfCoin", 1, 0.0);
  rmSetObjectDefMinDistance(playerCrateID, 6);
  rmSetObjectDefMaxDistance(playerCrateID, 10);
	rmAddObjectDefConstraint(playerCrateID, avoidAll);
  rmAddObjectDefConstraint(playerCrateID, shortAvoidImpassableLand);

 	for(i=1; <= cNumberNonGaiaPlayers)	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
    rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		
		// Place resources
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(StartHuntable1ID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(StartHuntable1ID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(StartBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Starter buildings - Japanese, Indians
    if(ypIsAsian(i) && rmGetNomadStart() == false) {
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      //~ rmPlaceObjectDefAtLoc(playerCrateID2, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    }
    
    else if (rmGetPlayerCiv(i) == rmGetCivID("Indians")) {
      //~ rmPlaceObjectDefAtLoc(playerCrateID2, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    }

    // crates!
    if (rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(playerCrateID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // starting scout nugget + nugget
		rmSetNuggetDifficulty(98, 98);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	}

   // Text
   rmSetStatusText("",0.50);
   	
  // Text
  rmSetStatusText("",0.60);
   
  // some medium nuggets in the north
  int nuggetID2= rmCreateObjectDef("north nuggets"); 
	rmAddObjectDefItem(nuggetID2, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID2, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(nuggetID2, rmXFractionToMeters(0.2));
	rmAddObjectDefConstraint(nuggetID2, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(nuggetID2, avoidNugget);
	rmAddObjectDefConstraint(nuggetID2, avoidSocket);
	rmAddObjectDefConstraint(nuggetID2, avoidNativesNuggets);
	rmAddObjectDefConstraint(nuggetID2, circleConstraint);
  rmAddObjectDefConstraint(nuggetID2, avoidAll);
	rmSetNuggetDifficulty(3, 3);
  rmPlaceObjectDefAtLoc(nuggetID2, 0, 0.95, 0.95, cNumberNonGaiaPlayers*2);
   
  // more difficult nuggets that are kept in the desert 
  int nuggetID3= rmCreateObjectDef("dry nuggets"); 
	rmAddObjectDefItem(nuggetID3, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID3, 0.0);
	rmSetObjectDefMaxDistance(nuggetID3, rmXFractionToMeters(0.2));
	rmAddObjectDefConstraint(nuggetID3, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(nuggetID3, avoidNugget);
	rmAddObjectDefConstraint(nuggetID3, longPlayerConstraint);
  rmAddObjectDefConstraint(nuggetID3, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID3, avoidSocket);
	rmAddObjectDefConstraint(nuggetID3, avoidNativesNuggets);
	rmAddObjectDefConstraint(nuggetID3, circleConstraint);
  rmAddObjectDefConstraint(nuggetID3, avoidAll);
	rmSetNuggetDifficulty(3, 4);
  rmPlaceObjectDefAtLoc(nuggetID3, 0, 0.15, 0.15, cNumberNonGaiaPlayers+1);
  
  // Define and place remaining Nuggets
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, longPlayerConstraint);
  rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidSocketMore);
	rmAddObjectDefConstraint(nuggetID, avoidNativesNuggets);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
  rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmSetNuggetDifficulty(1, 2);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);
  
  // team nuggets
  if(cNumberTeams == 2 && cNumberNonGaiaPlayers > 2){
    rmSetNuggetDifficulty(12, 12);
	  rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
  }
   
   // Text
   rmSetStatusText("",0.70); 

	// Place resources
	// silver in the north
  
	int silverID = -1;
	int silverCount = (cNumberNonGaiaPlayers*3);
	rmEchoInfo("silver count = "+silverCount);

  silverID = rmCreateObjectDef("silver");
  rmAddObjectDefItem(silverID, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(silverID, 0.0);
  rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silverID, avoidFastCoin);
  rmAddObjectDefConstraint(silverID, avoidCoin);
  rmAddObjectDefConstraint(silverID, avoidAll);
  rmAddObjectDefConstraint(silverID, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID, avoidNatives);
  rmAddObjectDefConstraint(silverID, longPlayerConstraint);
  rmAddObjectDefConstraint(silverID, avoidNuggetSmall);
  rmAddObjectDefConstraint(silverID, avoidDesert);
  rmPlaceObjectDefPerPlayer(silverID, false, 3);
   
  // gold in the southern desert
  silverCount = cNumberNonGaiaPlayers*2;
  silverID = rmCreateObjectDef("gold "+i);
  rmAddObjectDefItem(silverID, "minegold", 1, 0.0);
  rmAddObjectDefConstraint(silverID, avoidFastCoin);
  rmAddObjectDefConstraint(silverID, avoidCoinLong);
  rmAddObjectDefConstraint(silverID, avoidAll);
  rmAddObjectDefConstraint(silverID, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID, avoidNatives);
  rmAddObjectDefConstraint(silverID, longPlayerConstraint);
  rmAddObjectDefConstraint(silverID, avoidNuggetSmall);
  rmPlaceObjectDefInArea(silverID, 0, desertID, silverCount);

   // Text
   rmSetStatusText("",0.80);   
   
  // Food
  //herdable1
  int herdable1ID=rmCreateObjectDef("herdable1");
  rmAddObjectDefItem(herdable1ID, herdable1, 2, 3.0);
  rmSetObjectDefMinDistance(herdable1ID, 0.0);
  rmSetObjectDefMaxDistance(herdable1ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(herdable1ID, avoidHerdable1);
  rmAddObjectDefConstraint(herdable1ID, avoidAll);
  rmAddObjectDefConstraint(herdable1ID, avoidSocket);
  rmAddObjectDefConstraint(herdable1ID, avoidTradeRoute);
  rmAddObjectDefConstraint(herdable1ID, avoidImpassableLand);
  rmAddObjectDefConstraint(herdable1ID, longPlayerConstraint);
  rmPlaceObjectDefAtLoc(herdable1ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);   
   
  // Herdable2
  int Herdable2ID=rmCreateObjectDef("Herdable2");
  rmAddObjectDefItem(Herdable2ID, herdable2, 2, 3.0);
  rmSetObjectDefMinDistance(Herdable2ID, 0.0);
  rmSetObjectDefMaxDistance(Herdable2ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(Herdable2ID, avoidHerdable1);
  rmAddObjectDefConstraint(Herdable2ID, avoidHerdable2);
  rmAddObjectDefConstraint(Herdable2ID, avoidAll);
  rmAddObjectDefConstraint(Herdable2ID, avoidSocket);
  rmAddObjectDefConstraint(Herdable2ID, avoidTradeRoute);
  rmAddObjectDefConstraint(Herdable2ID, avoidImpassableLand);
  rmAddObjectDefConstraint(Herdable2ID, longPlayerConstraint);
  rmPlaceObjectDefAtLoc(Herdable2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers-1); 
   
	// Huntable1	
  int Huntable1ID=rmCreateObjectDef("Huntable1 herd");
  rmAddObjectDefItem(Huntable1ID, huntable1, rmRandInt(7,11), 12.0);
  rmSetObjectDefMinDistance(Huntable1ID, 0.0);
  rmSetObjectDefMaxDistance(Huntable1ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(Huntable1ID, avoidHuntable1);
	rmAddObjectDefConstraint(Huntable1ID, avoidAll);
  rmAddObjectDefConstraint(Huntable1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Huntable1ID, avoidTradeRoute);
	rmAddObjectDefConstraint(Huntable1ID, avoidSocket);
	rmAddObjectDefConstraint(Huntable1ID, longPlayerConstraint);
	rmAddObjectDefConstraint(Huntable1ID, avoidNuggetSmall);
  rmSetObjectDefCreateHerd(Huntable1ID, true);
  rmAddObjectDefConstraint(Huntable1ID, avoidDesert);
	rmPlaceObjectDefAtLoc(Huntable1ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*1);

	// huntable2	
  int huntable2ID=rmCreateObjectDef("huntable2 herd");
  rmAddObjectDefItem(huntable2ID, huntable2, rmRandInt(4,6), 10.0);
  rmSetObjectDefMinDistance(huntable2ID, 0.0);
  rmSetObjectDefMaxDistance(huntable2ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(huntable2ID, avoidHuntable1);
  rmAddObjectDefConstraint(huntable2ID, avoidHuntable2);
	rmAddObjectDefConstraint(huntable2ID, avoidAll);
  rmAddObjectDefConstraint(huntable2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(huntable2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(huntable2ID, avoidSocket);
	rmAddObjectDefConstraint(huntable2ID, longPlayerConstraint);
	rmAddObjectDefConstraint(huntable2ID, avoidNuggetSmall);
  rmSetObjectDefCreateHerd(huntable2ID, true);
  rmAddObjectDefConstraint(huntable2ID, avoidDesert);
	rmPlaceObjectDefAtLoc(huntable2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);
  
  // huntable3 in the south
  int huntable3ID=rmCreateObjectDef("huntable2 herd 2");
  rmAddObjectDefItem(huntable3ID, huntable2, rmRandInt(5,6), 7.0);
  rmSetObjectDefMinDistance(huntable3ID, 0.0);
  rmSetObjectDefMaxDistance(huntable3ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(huntable3ID, avoidHuntable1);
  rmAddObjectDefConstraint(huntable3ID, avoidHuntable2);
	rmAddObjectDefConstraint(huntable3ID, avoidAll);
  rmAddObjectDefConstraint(huntable3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(huntable3ID, avoidTradeRoute);
	rmAddObjectDefConstraint(huntable3ID, avoidSocket);
	rmAddObjectDefConstraint(huntable3ID, longPlayerConstraint);
	rmAddObjectDefConstraint(huntable3ID, avoidNuggetSmall);
  rmSetObjectDefCreateHerd(huntable3ID, true);
  rmPlaceObjectDefInArea(huntable3ID, 0, desertID, cNumberNonGaiaPlayers*2);

	// Text
   rmSetStatusText("",0.90);

   // Forests
  int count = 0;
  int maxCount = 8 * cNumberNonGaiaPlayers;
  int maxFailCount = 6;
  failCount = 0;
  
  for(i=1; < maxCount) {
	  int treeArea = rmCreateArea("steppe trees sparse"+i);
		rmSetAreaSize(treeArea, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
		rmSetAreaForestType(treeArea, steppeForest);
		rmSetAreaForestDensity(treeArea, 0.4);
		rmSetAreaForestClumpiness(treeArea, 0.1);
		rmAddAreaConstraint(treeArea, avoidImpassableLand);
		rmAddAreaConstraint(treeArea, avoidSocket);
		rmAddAreaConstraint(treeArea, avoidAll);
    rmAddAreaConstraint(treeArea, avoidDesert);
    rmAddAreaConstraint(treeArea, forestConstraint);
    rmAddAreaConstraint(treeArea, avoidNatives);
    rmAddAreaConstraint(treeArea, avoidCoinMedium);
		rmAddAreaConstraint(treeArea, avoidNuggetSmall);
		rmSetAreaWarnFailure(treeArea, false);
		bool ok = rmBuildArea(treeArea);
		if(ok) {
		}
		else {
			failCount++;
			if(failCount > maxFailCount)
			break;
		}
  }

  count = 0;
  failCount = 0;
   
  for(i=1; < maxCount) {
    treeArea = rmCreateArea("steppe trees dense "+i);
    rmSetAreaSize(treeArea, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
    rmSetAreaForestType(treeArea, steppeForest);
    rmSetAreaForestDensity(treeArea, 0.6);
    rmSetAreaForestClumpiness(treeArea, 0.1);
		rmAddAreaConstraint(treeArea, avoidImpassableLand);
		rmAddAreaConstraint(treeArea, avoidSocket);
    rmAddAreaConstraint(treeArea, avoidNatives);
		rmAddAreaConstraint(treeArea, avoidAll);
    rmAddAreaConstraint(treeArea, forestConstraintShort);    
		rmAddAreaConstraint(treeArea, avoidNuggetSmall);
    rmAddAreaConstraint(treeArea, avoidDesert);
    rmAddAreaConstraint(treeArea, avoidCoinMedium);
    rmSetAreaWarnFailure(treeArea, false);
    ok = rmBuildArea(treeArea);
    if(ok) {
    }
    else {
      failCount++;
      if(failCount > maxFailCount)
        break;
    }
  }
  
  count = 0;
  failCount = 0;  
  
  for(i=1; < maxCount) {
    treeArea = rmCreateArea("sparse desert tree"+i, desertID);
    rmSetAreaSize(treeArea, rmAreaTilesToFraction(100), rmAreaTilesToFraction(125));
    rmSetAreaForestType(treeArea, desertForest);
    rmSetAreaForestDensity(treeArea, 0.5);
    rmSetAreaForestClumpiness(treeArea, 0.6);
		rmAddAreaConstraint(treeArea, avoidImpassableLand);
		rmAddAreaConstraint(treeArea, avoidSocket);
    rmAddAreaConstraint(treeArea, avoidNatives);
		rmAddAreaConstraint(treeArea, avoidAll);
    rmAddAreaConstraint(treeArea, forestConstraintLong);    
		rmAddAreaConstraint(treeArea, avoidNuggetSmall);
    rmAddAreaConstraint(treeArea, mediumPlayerConstraint);
    rmAddAreaConstraint(treeArea, avoidCoinMedium);
    rmSetAreaWarnFailure(treeArea, false);
    ok = rmBuildArea(treeArea);
    if(ok) {    }
    
    else {
      failCount++;
      if(failCount > maxFailCount)
        break;
    }
  }
  
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
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float walk = 0.075;
    
    if(randLoc == 1 || cNumberTeams > 2)
      xLoc = .78;
    
    else if(randLoc == 2)
      xLoc = .2;
      
    
    ypKingsHillPlacer(xLoc, xLoc, walk, avoidSocketActual);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+xLoc);
  }

   // Text
   rmSetStatusText("",1.0);
}  
