// Himalayas - started with a modified version of Rockies.
// Aug 06
// PJJ
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
  string nativeCiv1 = "Udasi";
  string nativeCiv2 = "Bhakti";
 
  string baseMix = "himalayas_a";
  string secondaryMix = "himalayas_b";
  string baseTerrain = "rockies\groundsnow6_roc";
  string cliffType = "himalayas";
  string cliffTerrain = "rockies\groundsnow6_roc";
 
  string denseForest = "Himalayas Forest";
  string sparseForest = "Himalayas Forest";
  string startTreeType = "ypTreeHimalayas";
  
  string mapType1 = "himalayas";
  string mapType2 = "grass";
  
  string tradeRouteType = "water";
  
  string huntable1 = "ypIbex";
  string huntable2 = "ypSerow";
  
  string lightingType = "Himalayas";

   //Chooses which natives appear on the map
  int subCiv0=-1;
  int subCiv1=-1;

  subCiv0=rmGetCivID(nativeCiv1);
  rmEchoInfo("subCiv0 is "+nativeCiv1+ " " +subCiv0);
  if (subCiv0 >= 0)
    rmSetSubCiv(0, nativeCiv1);
    
  subCiv1=rmGetCivID(nativeCiv2);
  rmEchoInfo("subCiv1 is "+nativeCiv2+ " " +subCiv1);
  if (subCiv1 >= 0)
    rmSetSubCiv(1, nativeCiv2);

   // Picks the map size
   int playerTiles=11500;
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   // Picks a default water height
   rmSetSeaLevel(0.0);

   // Picks default terrain and water
  rmSetMapElevationParameters(cElevTurbulence, 0.02, -6, 0.5, 8.0);
  rmSetBaseTerrainMix(baseMix);
  rmTerrainInitialize(baseTerrain, 0);	
  rmSetLightingSet(lightingType);
  rmSetMapType(mapType1);
  rmSetMapType(mapType2);
  rmSetMapType("land");
  rmSetWorldCircleConstraint(true);

  chooseMercs();

  // Define some classes. These are used later for constraints.

  int classPlayer=rmDefineClass("player");
  int classStartingRidge = rmDefineClass("startingRidge");
  rmDefineClass("classForest");
  rmDefineClass("importantItem");
  rmDefineClass("nuggets");

  // -------------Define constraints
  // These are used to have objects and areas avoid each other
   
   // Map edge constraints
  int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
  int ridgeEdgeConstraint=rmCreateBoxConstraint("keep ridges from hitting border", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
  int silverEdgeConstraint=rmCreateBoxConstraint("silver edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
  int forestEdgeConstraint=rmCreatePieConstraint("forest edge of map", 0.5, 0.5, 0, rmGetMapXSize()-5, 0, 0, 0);
  int heavyForestConstraint=rmCreatePieConstraint("Heavy forests concentrated near edge of map", 0.5, 0.5, rmXFractionToMeters(0.25), rmXFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int nativeConstraint=rmCreatePieConstraint("Natives stay close to middle", 0.5, 0.5, 0, rmXFractionToMeters(0.3), rmDegreesToRadians(0), rmDegreesToRadians(360));

  // Player constraints
  int playerConstraint = rmCreateClassDistanceConstraint("player vs. player", classPlayer, 15.0);
  int playerConstraintImportantItem = rmCreateClassDistanceConstraint("vs. player far", classPlayer, 65.0);
  int ridgeAvoidsPlayer=rmCreateClassDistanceConstraint("ridge vs. player", classPlayer, 35.0);

  // Resource avoidance
  int forestConstraint=rmCreateClassDistanceConstraint("forest vs. things", rmClassID("classForest"), 8.0);
  int forestVsForestConstraint=rmCreateClassDistanceConstraint("forest vs. other forests", rmClassID("classForest"), 15.0);
  if ( cNumberNonGaiaPlayers < 3 ) {
    forestVsForestConstraint=rmCreateClassDistanceConstraint("forest vs. other forests smaller", rmClassID("classForest"), 10.0);
  }

  int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 20.0);
  int playerConstraintFar=rmCreateClassDistanceConstraint("resources stay away from players", classPlayer, 25.0);
  int avoidHuntable1=rmCreateTypeDistanceConstraint("huntable1 avoids food", huntable1, 45.0);
  int avoidHuntable2=rmCreateTypeDistanceConstraint("huntable2 avoids food", huntable2, 55.0);
  int avoidCoin=rmCreateTypeDistanceConstraint("stuff avoids coin", "gold", 15.0);
  int avoidCoinShort=rmCreateTypeDistanceConstraint("stuff avoids coin short", "gold", 6.0);
  int coinAvoidCoin= rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 65.0);
  int avoidNuggets=rmCreateTypeDistanceConstraint("stuff avoids nuggets", "abstractNugget", 5.0);
  int avoidNuggetsLong=rmCreateTypeDistanceConstraint("stuff avoids nuggets far", "abstractNugget", 40.0);
    
  // Avoid impassable land
  int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
  int ridgeAvoidImpassableLand=rmCreateTerrainDistanceConstraint("ridges avoid impassable land", "Land", false, 12.0);
  int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);

  // Decoration avoidance
  int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // VP avoidance
  int avoidImportantItem=rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 25.0);
  int avoidImportantItemFar=rmCreateClassDistanceConstraint("important stuff avoids each other far", rmClassID("importantItem"), 65.0);
  int avoidImportantItemForest=rmCreateClassDistanceConstraint("important stuff avoids each forest", rmClassID("importantItem"), 10.0);
  int avoidImportantItemCoin=rmCreateClassDistanceConstraint("Coin avoids important stuff", rmClassID("importantItem"), 5.0);
  int avoidImportantItemRidge=rmCreateClassDistanceConstraint("Ridge avoids important stuff", rmClassID("importantItem"), 15.0);
  int southNativeConstraint=rmCreateBoxConstraint("native south bit of map", 0.35, 0.0, .475, 1.0);
  int northNativeConstraint=rmCreateBoxConstraint("native north bit of map", 0.525, 0.0, .65, 1.0);

  int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
  int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("trade route small", 4.0);
  int avoidSocket=rmCreateTypeDistanceConstraint("socket avoidance", "socketTradeRoute", 8.0);

  int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

  // ridge constraints
  int ridgeAvoidsRidge = rmCreateClassDistanceConstraint("ridges avoid other ridges", classStartingRidge, 25.0);
  int resourceAvoidsRidge = rmCreateClassDistanceConstraint("resources avoid ridges", classStartingRidge, 4.0);
  
  // Text
  rmSetStatusText("",0.10);

  // DEFINE AREAS
  int i = 0;
  
   // Text
  rmSetStatusText("",0.20);

  // Set up player starting locations.

  float teamSide = rmRandFloat(0, 1);

	if (cNumberTeams == 2)	{
    
    if (teamSide > .5) {
      rmSetPlacementTeam(0);
      rmPlacePlayersLine(0.2, 0.25, 0.2, 0.75, 0.0, 0.2);

      rmSetPlacementTeam(1);
      rmPlacePlayersLine(0.8, 0.75, 0.8, 0.25, 0.0, 0.2);
    }
    
    else {
      rmSetPlacementTeam(1);
      rmPlacePlayersLine(0.2, 0.25, 0.2, 0.75, 0.0, 0.2);

      rmSetPlacementTeam(0);
      rmPlacePlayersLine(0.8, 0.75, 0.8, 0.25, 0.0, 0.2);
    }
	}
  
	else	{
	   rmSetTeamSpacingModifier(0.75);
	   rmPlacePlayersCircular(0.4, 0.4, 0);
	}
  
  // Set up valleys for each player.
 
  int id = 0;
  int startingRidge = 0;
  float playerFraction=rmAreaTilesToFraction(100);
  
  for(i=1; < cNumberPlayers){
    // Create the area.
    id=rmCreateArea("Player"+i);

    // Assign to the player.
    rmSetPlayerArea(i, id);

    // Set the size and area parameters.
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classPlayer);
    rmAddAreaConstraint(id, playerConstraint); 
    rmAddAreaConstraint(id, playerEdgeConstraint);
    rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, false);
    rmBuildArea(id);
  }

   // Placement order
   // Trade -> Natives -> Ridges -> Resources -> Nuggets
  
  // TRADE ROUTE PLACEMENT
  int tradeRouteID = rmCreateTradeRoute();

  int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
  rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

  rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
  rmSetObjectDefAllowOverlap(socketID, true);
  rmSetObjectDefMinDistance(socketID, 0.0);
  rmSetObjectDefMaxDistance(socketID, 8.0);
  
  // trade route
  rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.03);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.97);
  
  bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, tradeRouteType);
  if(placedTradeRoute == false)
    rmEchoError("Failed to place trade route"); 
  
  // add the sockets along the trade route.
  vector socketLoc  = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
    
  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  
    
  if (cNumberNonGaiaPlayers > 3) {
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.3);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  

    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);           
  }
  
   // Text
    rmSetStatusText("",0.30);

   // NATIVE AMERICANS

  int lakotaVillageAID = -1;
  int lakotaVillageType = rmRandInt(1,5);
  int lakotaVillageBID = -1;
      
  lakotaVillageAID = rmCreateGrouping("village 1A", "native " +nativeCiv1+ " village himal "+lakotaVillageType);
  rmSetGroupingMinDistance(lakotaVillageAID, 0.0);
  rmSetGroupingMaxDistance(lakotaVillageAID, 25.0);
  rmAddGroupingConstraint(lakotaVillageAID, avoidImpassableLand);
  rmAddGroupingConstraint(lakotaVillageAID, playerConstraintImportantItem);
  rmAddGroupingToClass(lakotaVillageAID, rmClassID("importantItem"));
  rmAddGroupingConstraint(lakotaVillageAID, avoidImportantItemFar);
  rmAddGroupingConstraint(lakotaVillageAID, nativeConstraint);
  rmAddGroupingConstraint(lakotaVillageAID, avoidTradeRoute);
  rmAddGroupingConstraint(lakotaVillageAID, avoidSocket);
  rmAddGroupingConstraint(lakotaVillageAID, southNativeConstraint);
  
  rmPlaceGroupingAtLoc(lakotaVillageAID, 0, 0.35, 0.5);


  // Text
  rmSetStatusText("",0.40);
  
  lakotaVillageType = rmRandInt(1,5);
  lakotaVillageBID = rmCreateGrouping("village 1B", "native " +nativeCiv2+ " village himal "+lakotaVillageType);
  rmSetGroupingMinDistance(lakotaVillageBID, 0.0);
  rmSetGroupingMaxDistance(lakotaVillageBID, 25.0);
  rmAddGroupingConstraint(lakotaVillageBID, avoidImpassableLand);
  rmAddGroupingConstraint(lakotaVillageBID, playerConstraintImportantItem);
  rmAddGroupingToClass(lakotaVillageBID, rmClassID("importantItem"));
  rmAddGroupingConstraint(lakotaVillageBID, avoidImportantItemFar);
  rmAddGroupingConstraint(lakotaVillageBID, nativeConstraint);
  rmAddGroupingConstraint(lakotaVillageBID, avoidTradeRoute);
  rmAddGroupingConstraint(lakotaVillageBID, avoidSocket);
  rmAddGroupingConstraint(lakotaVillageBID, northNativeConstraint);
  rmPlaceGroupingAtLoc(lakotaVillageBID, 0, 0.65, 0.5);

  // Place more native sites if more players
  if(cNumberNonGaiaPlayers > 4) {
    
    lakotaVillageType = rmRandInt(1,5);
    lakotaVillageAID = rmCreateGrouping("village 1E", "native " +nativeCiv1+ " village himal "+lakotaVillageType);
    rmSetGroupingMinDistance(lakotaVillageAID, 0.0);
    rmSetGroupingMaxDistance(lakotaVillageAID, 35.0);
    rmAddGroupingConstraint(lakotaVillageAID, avoidImpassableLand);
    rmAddGroupingConstraint(lakotaVillageAID, playerConstraintImportantItem);
    rmAddGroupingToClass(lakotaVillageAID, rmClassID("importantItem"));
    rmAddGroupingConstraint(lakotaVillageAID, avoidImportantItemFar);
    rmAddGroupingConstraint(lakotaVillageAID, nativeConstraint);
    rmAddGroupingConstraint(lakotaVillageAID, avoidTradeRoute);
    rmAddGroupingConstraint(lakotaVillageAID, avoidSocket);
    rmAddGroupingConstraint(lakotaVillageAID, southNativeConstraint);
    rmPlaceGroupingAtLoc(lakotaVillageAID, 0, 0.4, 0.65);

    lakotaVillageType = rmRandInt(1,5);
    lakotaVillageBID = rmCreateGrouping("village 2F", "native " +nativeCiv2+ " village himal "+lakotaVillageType);
    rmSetGroupingMinDistance(lakotaVillageBID, 0.0);
    rmSetGroupingMaxDistance(lakotaVillageBID, 35.0);
    rmAddGroupingConstraint(lakotaVillageBID, avoidImpassableLand);
    rmAddGroupingConstraint(lakotaVillageBID, playerConstraintImportantItem);
    rmAddGroupingToClass(lakotaVillageBID, rmClassID("importantItem"));
    rmAddGroupingConstraint(lakotaVillageBID, avoidImportantItemFar);
    rmAddGroupingConstraint(lakotaVillageBID, nativeConstraint);
    rmAddGroupingConstraint(lakotaVillageBID, avoidTradeRoute);
    rmAddGroupingConstraint(lakotaVillageBID, avoidSocket);
    rmAddGroupingConstraint(lakotaVillageBID, northNativeConstraint);
    rmPlaceGroupingAtLoc(lakotaVillageBID, 0, 0.6, 0.35);
  
  }
  
  float edgeCliffCoherence = .9;
  float midCliffCoherence = .75; 

  // build ridges with ridge avoidance to start a basic topography   
  
  int randomRidge = 5; 
  float ridgeHeightVariance = 1.5;
  int ridgeAvoid = 3;  
  int numTries = -1;
  int failCount = -1;
  int extraRidges = 4 + cNumberNonGaiaPlayers*2;
  
  for(i=0; < extraRidges) {
    
    if(rmRandInt(1,5) <= randomRidge) {
      startingRidge=rmCreateArea("Ridge 11"+i);
      rmAddAreaConstraint(startingRidge, ridgeAvoidsPlayer); 
      rmAddAreaConstraint(startingRidge, ridgeAvoidsRidge);
      rmAddAreaConstraint(startingRidge, avoidTradeRoute);
      rmAddAreaConstraint(startingRidge, avoidSocket);
      rmAddAreaConstraint(startingRidge, avoidImportantItemRidge);      
                     
      rmSetAreaSize(startingRidge, rmAreaTilesToFraction(125), rmAreaTilesToFraction(150));
      rmSetAreaWarnFailure(startingRidge, false);
      rmSetAreaCoherence(startingRidge, midCliffCoherence);
      rmSetAreaCliffType(startingRidge, cliffType);
      rmSetAreaCliffEdge(startingRidge, 1, 1.0, 1.0, 0.0, 0);
      rmSetAreaCliffHeight(startingRidge, 5, ridgeHeightVariance, 0.3);
      rmSetAreaCliffPainting(startingRidge, true, false, true, 0, true);
      rmAddAreaToClass(startingRidge, classStartingRidge);
      
      if(rmBuildArea(startingRidge)==false){
        failCount++;
        if(failCount==5) // Stop trying once we fail 5 times in a row.
        break;
      }
      else
        failCount=0;
    }
  }
  
  // begin smaller ridges with lower % chance to spawn and possibly no ridge avoidance constraint
  
  randomRidge = 4;
  ridgeAvoid = 5;  
  extraRidges = 5 + cNumberNonGaiaPlayers*2;
  numTries = -1;
  failCount = -1;

  for(i=0; < extraRidges) {
    
    if(rmRandInt(1,5) <= randomRidge) {
      startingRidge=rmCreateArea("Ridge 31"+i);
      rmAddAreaConstraint(startingRidge, ridgeAvoidsPlayer); 
      rmAddAreaConstraint(startingRidge, avoidImportantItemRidge);   
      rmAddAreaConstraint(startingRidge, avoidTradeRoute);
      rmAddAreaConstraint(startingRidge, avoidSocket);
      rmAddAreaConstraint(startingRidge, ridgeAvoidsRidge);
  
      rmSetAreaSize(startingRidge, rmAreaTilesToFraction(50), rmAreaTilesToFraction(75));
      rmSetAreaWarnFailure(startingRidge, false);
      rmSetAreaCoherence(startingRidge, midCliffCoherence);

      rmSetAreaCliffType(startingRidge, cliffType);
      rmSetAreaCliffEdge(startingRidge, 1, 1.0, 1.0, 0.0, 0);
      rmSetAreaCliffHeight(startingRidge, 5, ridgeHeightVariance, 0.3);
      rmSetAreaCliffPainting(startingRidge, true, false, true, 0, true);
      rmAddAreaToClass(startingRidge, classStartingRidge);
      
      if(rmBuildArea(startingRidge)==false){
        failCount++;
        if(failCount==5) // Stop trying once we fail 5 times in a row.
        break;
      }
      else
        failCount=0;
    }
  }
  
  failCount = -1;
  
  //STARTING UNITS
  int startingTCID= rmCreateObjectDef("startingTC");
  if ( rmGetNomadStart())
  {
    rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
  }
  else
  {
    rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
  }
  
  rmSetObjectDefMinDistance(startingTCID, 0.0);
  rmSetObjectDefMaxDistance(startingTCID, 8.0);

  int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
  rmSetObjectDefMinDistance(startingUnits, 4.0);
  rmSetObjectDefMaxDistance(startingUnits, 8.0);
  
  int StartFoodID=rmCreateObjectDef("starting food");
  rmAddObjectDefItem(StartFoodID, huntable1, 10, 10.0);
  rmSetObjectDefMinDistance(StartFoodID, 9.0);
  rmSetObjectDefMaxDistance(StartFoodID, 13.0);
  rmSetObjectDefCreateHerd(StartFoodID, false);
  rmAddObjectDefConstraint(StartFoodID, avoidImpassableLand);

  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 20.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 25.0);
  rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);

  int StartAreaTreeID=rmCreateObjectDef("starting trees");
  rmAddObjectDefItem(StartAreaTreeID, startTreeType, 8, 6.0);
  rmSetObjectDefMinDistance(StartAreaTreeID, 20.0);
  rmSetObjectDefMaxDistance(StartAreaTreeID, 23.0);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidNuggets);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);

  int playerGoldID = rmCreateObjectDef("player silver closer "+i);
  rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
  rmAddObjectDefConstraint(playerGoldID, resourceAvoidsRidge);
  rmSetObjectDefMinDistance(playerGoldID, 15.0);
  rmSetObjectDefMaxDistance(playerGoldID, 18.0);
  
  int playerBerryID=rmCreateObjectDef("player berries");
  rmAddObjectDefItem(playerBerryID, "berryBush", 4, 4.0);
  rmSetObjectDefMinDistance(playerBerryID, 10.0);
  rmSetObjectDefMaxDistance(playerBerryID, 14.0);
  rmAddObjectDefConstraint(playerBerryID, avoidImpassableLand);

  // Text
   rmSetStatusText("",0.60);
   
  for(i=1; <cNumberPlayers) {
    rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    // Everyone gets a starter mines, some sheep, and lumber
    rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    // Placing starting food
    rmPlaceObjectDefAtLoc(StartFoodID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    rmPlaceObjectDefAtLoc(playerBerryID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        
    // Placing starting trees
    rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    // japanese
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    // Place a nugget for the player
    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
  }

  // Text
  rmSetStatusText("",0.70);
  
  // Resources

  // Define and place forests
  int forestTreeID = 0;
  
  numTries = 15 * cNumberNonGaiaPlayers;
  failCount=0;

  for (i=0; <numTries) {   
    int northForest = rmCreateArea("nForest"+i);
    rmSetAreaWarnFailure(northForest, false);
    rmSetAreaSize(northForest, rmAreaTilesToFraction(300), rmAreaTilesToFraction(350));
    rmAddAreaToClass(northForest, rmClassID("classForest"));
    rmSetAreaForestType(northForest, denseForest);
    rmSetAreaForestDensity(northForest, 0.8);
    rmSetAreaForestClumpiness(northForest, 0.6);
    rmSetAreaForestUnderbrush(northForest, 0.0);
    rmSetAreaCoherence(northForest, 0.3);
    rmSetAreaSmoothDistance(northForest, 10);
    rmSetAreaObeyWorldCircleConstraint(northForest, false);
    rmAddAreaConstraint(northForest, avoidImportantItemForest);		
    rmAddAreaConstraint(northForest, playerConstraintForest);	
    rmAddAreaConstraint(northForest, forestVsForestConstraint);			
    rmAddAreaConstraint(northForest, resourceAvoidsRidge);
    rmAddAreaConstraint(northForest, forestEdgeConstraint);
    rmAddAreaConstraint(northForest, avoidTradeRoute);
    rmAddAreaConstraint(northForest, avoidSocket);
    rmAddAreaConstraint(northForest, avoidCoin);
    rmAddAreaConstraint(northForest, heavyForestConstraint);
    
    if(rmBuildArea(northForest) == false) {
      // Stop trying once we fail 4 times in a row.
      failCount++;
      if(failCount==4)
        break;
    }
    
    else
      failCount=0; 
  }

  failCount=0; 
  
  //text
  rmSetStatusText("",0.80);  
  
  for (i=0; <numTries) {   
    int northForest2 = rmCreateArea("nForestb"+i);
    rmSetAreaWarnFailure(northForest2, false);
    rmSetAreaSize(northForest2, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
    rmAddAreaToClass(northForest2, rmClassID("classForest"));
    rmSetAreaForestType(northForest2, sparseForest);
    rmSetAreaForestDensity(northForest2, 0.2);
    rmSetAreaForestClumpiness(northForest2, 0.1);
    rmSetAreaForestUnderbrush(northForest2, 0.0);
    rmSetAreaCoherence(northForest2, 0.3);
    rmSetAreaSmoothDistance(northForest2, 10);
    rmSetAreaObeyWorldCircleConstraint(northForest2, false);
    rmAddAreaConstraint(northForest2, avoidImportantItemForest);		
    rmAddAreaConstraint(northForest2, playerConstraintForest);	
    rmAddAreaConstraint(northForest2, forestVsForestConstraint);			
    rmAddAreaConstraint(northForest2, resourceAvoidsRidge);
    rmAddAreaConstraint(northForest2, forestEdgeConstraint);
    rmAddAreaConstraint(northForest2, avoidTradeRoute);
    rmAddAreaConstraint(northForest2, avoidSocket);
    rmAddAreaConstraint(northForest2, avoidCoin);
    
    if(rmBuildArea(northForest2) == false) {
      // Stop trying once we fail 4 times in a row.
      failCount++;
      if(failCount==4)
        break;
    }
    
    else
      failCount=0; 
  }

  // Denser mines away from the player's starting areas
  int silverID = -1;
  int silverCount = 6;
  
  rmEchoInfo("silver count = "+silverCount);

  silverID = rmCreateObjectDef("silver mines");
  rmAddObjectDefItem(silverID, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(silverID, 0.0);
  rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silverID, coinAvoidCoin);
  rmAddObjectDefConstraint(silverID, avoidTradeRoute);
  rmAddObjectDefConstraint(silverID, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID, playerConstraintFar);
  rmAddObjectDefConstraint(silverID, resourceAvoidsRidge);
  rmAddObjectDefConstraint(silverID, avoidImportantItemCoin);
  rmAddObjectDefConstraint(silverID, silverEdgeConstraint);
  rmPlaceObjectDefPerPlayer(silverID, false, silverCount);
  
  rmSetStatusText("",0.90);

  // huntable 1
  int huntable1ID=rmCreateObjectDef("huntable herd 1");
  rmAddObjectDefItem(huntable1ID, huntable1, rmRandInt(6,7), 10.0);
  rmSetObjectDefMinDistance(huntable1ID, 0.0);
  rmSetObjectDefMaxDistance(huntable1ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(huntable1ID, avoidHuntable1);
  rmAddObjectDefConstraint(huntable1ID, avoidImpassableLand);
  rmAddObjectDefConstraint(huntable1ID, avoidSocket);
  rmAddObjectDefConstraint(huntable1ID, forestConstraint);
  rmAddObjectDefConstraint(huntable1ID, avoidCoin);
  rmAddObjectDefConstraint(huntable1ID, resourceAvoidsRidge);
  rmAddObjectDefConstraint(huntable1ID, playerConstraintFar);
  rmSetObjectDefCreateHerd(huntable1ID, true);
  rmPlaceObjectDefAtLoc(huntable1ID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

  // huntable2
  int huntable2ID=rmCreateObjectDef("huntable2 Herd");
  rmAddObjectDefItem(huntable2ID, huntable2, rmRandInt(8,9), 10.0);
  rmSetObjectDefMinDistance(huntable2ID, 0.0);
  rmSetObjectDefMaxDistance(huntable2ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(huntable2ID, avoidHuntable2);
  rmAddObjectDefConstraint(huntable2ID, avoidHuntable1);
  rmAddObjectDefConstraint(huntable2ID, avoidImpassableLand);
  rmAddObjectDefConstraint(huntable2ID, forestConstraint);
  rmAddObjectDefConstraint(huntable2ID, avoidSocket);
  rmAddObjectDefConstraint(huntable2ID, resourceAvoidsRidge);
  rmAddObjectDefConstraint(huntable2ID, playerConstraintFar);
  rmSetObjectDefCreateHerd(huntable2ID, true);
  rmPlaceObjectDefAtLoc(huntable2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);
      
  // Define and place Nuggets
  int nuggetID= rmCreateObjectDef("nuggets!"); 
  rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
  rmSetObjectDefMinDistance(nuggetID, 0.0);
  rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nuggetID, avoidImportantItemForest);
  rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
  rmAddObjectDefConstraint(nuggetID, avoidSocket);
  rmAddObjectDefConstraint(nuggetID, avoidCoinShort);
  rmAddObjectDefConstraint(nuggetID, avoidNuggetsLong);
  rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
  rmAddObjectDefConstraint(nuggetID, resourceAvoidsRidge);
  rmAddObjectDefConstraint(nuggetID, playerConstraintFar);
  rmAddObjectDefConstraint(nuggetID, forestEdgeConstraint);
  
  rmSetNuggetDifficulty(1, 2);
  rmPlaceObjectDefPerPlayer(nuggetID, false, 4);
  
  int nuggetID2 = rmCreateObjectDef("nuggets! 2"); 
  rmAddObjectDefItem(nuggetID2, "Nugget", 1, 0.0);
  rmSetObjectDefMinDistance(nuggetID2, 0.0);
  rmSetObjectDefMaxDistance(nuggetID2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nuggetID2, avoidImportantItemForest);
  rmAddObjectDefConstraint(nuggetID2, avoidTradeRoute);
  rmAddObjectDefConstraint(nuggetID2, avoidSocket);
  rmAddObjectDefConstraint(nuggetID2, avoidCoinShort);
  rmAddObjectDefConstraint(nuggetID2, avoidNuggetsLong);
  rmAddObjectDefConstraint(nuggetID2, avoidImpassableLand);
  rmAddObjectDefConstraint(nuggetID2, resourceAvoidsRidge);
  rmAddObjectDefConstraint(nuggetID2, playerConstraintImportantItem);
  rmAddObjectDefConstraint(nuggetID2, forestEdgeConstraint);
  
  rmSetNuggetDifficulty(3, 3);
  rmPlaceObjectDefPerPlayer(nuggetID2, false, 2);
  
  rmSetNuggetDifficulty(4, 4);
  rmPlaceObjectDefPerPlayer(nuggetID2, false, 1);
  
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
    
    int randLoc = rmRandInt(1,3);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.075;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, resourceAvoidsRidge);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
  
   // Text
   rmSetStatusText("",1.0);
}