	/* Durokan's gold rush - Jan 18 2016 1.1 --Finished and released 2v2*/
	include "mercenaries.xs";
	include "ypAsianInclude.xs";
	include "ypKOTHInclude.xs";
 
	void main(void) {
 
		rmSetStatusText("",0.1);

		float playerTiles=15000;
			if (cNumberNonGaiaPlayers>4)
				playerTiles = 13000;
			if (cNumberNonGaiaPlayers>6)
				playerTiles = 11000;			
		int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
		rmSetMapSize(size, size);
        rmSetMapType("land");
        rmSetMapType("grass");
        rmSetMapType("bayou");
        rmTerrainInitialize("grass");
        rmSetLightingSet("texas");
       
        rmDefineClass("classForest");
 
        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));
        int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
        int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 6.0);
        int AvoidWaterShort2 = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 5.0);
        int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 6);
        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 4.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 5.0);
        int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);
        int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMedium=rmCreateTypeDistanceConstraint("avoid Town Center medium", "townCenter", 18.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);  
        int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
        int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
        int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
	int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
        int classPatch = rmDefineClass("patch");
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
		
		int avoidRush=rmCreateTypeDistanceConstraint("avoid rush by a lot", "AbstractRush", 75.0);
       
        Float spawnSwitch = rmRandFloat(0,1.2);
		
	if (cNumberTeams == 2){
		if (spawnSwitch <=0.6){
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.2, 0.3, 0.2, 0.7, 0, 0);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.8, 0.7, 0.8, 0.3, 0, 0);
		}else if(spawnSwitch <=1.2){
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.2, 0.3, 0.2, 0.7, 0, 0);
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.8, 0.7, 0.8, 0.3, 0, 0);
		}
	}else{
			rmSetPlacementSection(0.16, 0.84);
			rmPlacePlayersCircular(0.38, 0.38, 0.02);
	}

        chooseMercs();
       
		rmSetStatusText("",0.2);

        int continent = rmCreateArea("continent");
        rmSetAreaSize(continent, 1.0, 1.0);
        rmSetAreaLocation(continent, 0.5, 0.0);
        rmSetAreaTerrainType(continent, "andes\ground25_and");
        rmSetAreaBaseHeight(continent, 0.0);
        rmSetAreaCoherence(continent, 1.0);
        rmSetAreaSmoothDistance(continent, 10);
        rmSetAreaHeightBlend(continent, 1);
        //rmSetAreaEdgeFilling(continent, 5);
        rmSetAreaElevationNoiseBias(continent, 0);
        rmSetAreaElevationEdgeFalloffDist(continent, 10);
        rmSetAreaElevationVariation(continent, 3);
        rmSetAreaElevationPersistence(continent, .2);
        rmSetAreaElevationOctaves(continent, 3);
        rmSetAreaElevationMinFrequency(continent, 0.04);
        rmSetAreaElevationType(continent, cElevTurbulence);  
        rmBuildArea(continent);  
	
	
        int island = rmCreateArea("island");
        rmSetAreaSize(island, 0.1, 0.1);
        rmSetAreaLocation(island, 0.505, 0.88);
        rmSetAreaTerrainType(island, "andes\ground25_and");
        rmSetAreaBaseHeight(island, -3.0);
        rmSetAreaCoherence(island, 0.95);
	rmSetAreaElevationEdgeFalloffDist(island, 10);
	rmAddAreaInfluenceSegment(island, 0.48, 0.88, 0.53, 0.88);
        rmBuildArea(island);

       
        int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 0.0);
        rmSetObjectDefMaxDistance(socketID, 6.0);      
       
        int tradeRouteID = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
        rmAddTradeRouteWaypoint(tradeRouteID, 0.49, 0.01); // -1
        rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.4, 0.6, 2, 3); // -2
        rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.4, 0.7, 2, 3); // -2
        rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.2, 0.9, 2, 3); // -5
        rmBuildTradeRoute(tradeRouteID, "dirt");
 
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.20);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
       
        socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
       
        socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
       
//END TR
 
//TR 2
 
		rmSetStatusText("",0.3);

        int socket2ID=rmCreateObjectDef("sockets to dock Trade Posts 2");
        rmAddObjectDefItem(socket2ID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socket2ID, true);
        rmSetObjectDefMinDistance(socket2ID, 0.0);
        rmSetObjectDefMaxDistance(socket2ID, 6.0);    
 
        int tradeRoute2ID = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);
       
        rmAddTradeRouteWaypoint(tradeRoute2ID, 0.52, 0.01); // -1
        rmAddRandomTradeRouteWaypoints(tradeRoute2ID, 0.6, 0.6, 2, 3); // -2
        rmAddRandomTradeRouteWaypoints(tradeRoute2ID, 0.6, 0.7, 2, 3); // -2
        rmAddRandomTradeRouteWaypoints(tradeRoute2ID, 0.8, 0.9, 2, 3); // -5
 
        rmBuildTradeRoute(tradeRoute2ID, "dirt");
 
        vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.20);
        rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
       
        socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.50);
        rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
       
        socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.85);
        rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);
          
       
// END TR 2
 
		rmSetStatusText("",0.4);

         int topgold = rmCreateObjectDef("goldrush");
        rmAddObjectDefItem(topgold, "minegold", 1, 1.0);
        rmSetObjectDefMinDistance(topgold, 0.0);
        rmSetObjectDefMaxDistance(topgold, rmXFractionToMeters(0.1));
        rmAddObjectDefConstraint(topgold, avoidCoin);
        //rmAddObjectDefConstraint(topgold, avoidNatives);
        rmAddObjectDefConstraint(topgold, avoidTownCenterMore);
        rmAddObjectDefConstraint(topgold, avoidSocket);
        rmAddObjectDefConstraint(topgold, AvoidWaterShort2);
        rmAddObjectDefConstraint(topgold, forestConstraintShort);
        rmAddObjectDefConstraint(topgold, circleConstraint);
		rmAddObjectDefConstraint(topgold, avoidRush);
        rmPlaceObjectDefAtLoc(topgold, 0, 0.505, 0.88, 12);

        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidAll);
       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "MineCopper", 1, 8.0);
        rmSetObjectDefMinDistance(goldID, 15.0);
        rmSetObjectDefMaxDistance(goldID, 15.0);
       
        int gold2ID = rmCreateObjectDef("starting gold 2");
        rmAddObjectDefItem(gold2ID, "mine", 1, 16.0);
        rmSetObjectDefMinDistance(gold2ID, 15.0);
        rmSetObjectDefMaxDistance(gold2ID, 15.0);
        rmAddObjectDefConstraint(gold2ID, avoidCoin);
 
        int berryID = rmCreateObjectDef("starting berries");
        rmAddObjectDefItem(berryID, "BerryBush", 2, 6.0);
        rmSetObjectDefMinDistance(berryID, 8.0);
        rmSetObjectDefMaxDistance(berryID, 12.0);
        rmAddObjectDefConstraint(berryID, avoidCoin);
 
        int treeID = rmCreateObjectDef("starting trees");
        rmAddObjectDefItem(treeID, "TreeSonora", rmRandInt(6,9), 10.0);
        rmAddObjectDefItem(treeID, "UnderbrushTexas", rmRandInt(8,10), 12.0);
        rmSetObjectDefMinDistance(treeID, 12.0);
        rmSetObjectDefMaxDistance(treeID, 18.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "Capybara", 5, 8.0);
        rmSetObjectDefMinDistance(foodID, 10.0);
        rmSetObjectDefMaxDistance(foodID, 10.0);
        rmSetObjectDefCreateHerd(foodID, true);
 
		rmSetStatusText("",0.5);

        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "Capybara", 5, 8.0);
        rmSetObjectDefMinDistance(foodID2, 40.0);
        rmSetObjectDefMaxDistance(foodID2, 40.0);
        rmSetObjectDefCreateHerd(foodID2, true);
               
		int foodID3 = rmCreateObjectDef("starting hunt 3");
        rmAddObjectDefItem(foodID3, "Capybara", 5, 8.0);
        rmSetObjectDefMinDistance(foodID3, 70.0);
        rmSetObjectDefMaxDistance(foodID3, 70.0);
        rmSetObjectDefCreateHerd(foodID3, true);
	 
    
// regicide objects
  int playerCastle = rmCreateObjectDef("Castle");
  rmAddObjectDefItem(playerCastle, "ypCastleRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerCastle, avoidAll);
  rmAddObjectDefConstraint(playerCastle, avoidImpassableLand);
  rmSetObjectDefMinDistance(playerCastle, 17.0);	
  rmSetObjectDefMaxDistance(playerCastle, 22.0);

  int playerWalls = rmCreateGrouping("regicide walls", "regicide_walls");
  rmAddGroupingToClass(playerWalls, rmClassID("importantItem"));
  rmSetGroupingMinDistance(playerWalls, 0.0);
  rmSetGroupingMaxDistance(playerWalls, 2.0);

  int playerDaimyo = rmCreateObjectDef("Daimyo");
  rmAddObjectDefItem(playerDaimyo, "ypDaimyoRegicide", 1, 0.0);
  rmAddObjectDefConstraint(playerDaimyo, avoidAll);
  rmSetObjectDefMinDistance(playerDaimyo, 7.0);
  rmSetObjectDefMaxDistance(playerDaimyo, 10.0);

        for(i=1; <cNumberPlayers) {
    int id=rmCreateArea("Player"+i);
    rmSetPlayerArea(i, id);
    int startID = rmCreateObjectDef("object"+i);
    rmAddObjectDefItem(startID, "TownCenter", 1, 5.0);
    rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startID, i));
      rmPlaceGroupingAtLoc(playerWalls, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      rmPlaceObjectDefAtLoc(playerCastle, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      rmPlaceObjectDefAtLoc(playerDaimyo, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(gold2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
  }
 
        for (j=0; < (4*4)) {  
                int StartAreaTree2ID=rmCreateObjectDef("starting trees dirt"+j);
                rmAddObjectDefItem(StartAreaTree2ID, "TreeSonora", rmRandInt(8,10), rmRandFloat(8.0,16.0));
                rmAddObjectDefToClass(StartAreaTree2ID, rmClassID("classForest"));
                rmSetObjectDefMinDistance(StartAreaTree2ID, 0);
                rmSetObjectDefMaxDistance(StartAreaTree2ID, rmXFractionToMeters(0.45));
                rmAddObjectDefConstraint(StartAreaTree2ID, avoidTradeRoute);
                rmAddObjectDefConstraint(StartAreaTree2ID, avoidSocket);
                //rmAddObjectDefConstraint(StartAreaTree2ID, avoidNatives);
                rmAddObjectDefConstraint(StartAreaTree2ID, circleConstraint);
                rmAddObjectDefConstraint(StartAreaTree2ID, forestConstraint);
                //rmAddObjectDefConstraint(StartAreaTree2ID, avoidCoin);
                rmAddObjectDefConstraint(StartAreaTree2ID, avoidTownCenter);  
                rmAddObjectDefConstraint(StartAreaTree2ID, AvoidWaterShort2);  
				rmAddObjectDefConstraint(StartAreaTree2ID, avoidRush);
                rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, 0.5, 0.5, 5*4);
        }

		for (i=0; < cNumberNonGaiaPlayers*55){
			int patchID = rmCreateArea("the redder stuff"+i);
			rmSetAreaWarnFailure(patchID, false);
			rmSetAreaSize(patchID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(51));
			rmAddAreaTerrainReplacement(patchID, "andes\ground25_and", "andes\ground22_and");
			rmPaintAreaTerrain(patchID);
			rmAddAreaToClass(patchID, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID, 1.0);
			rmAddAreaConstraint(patchID, circleConstraint2);
			rmBuildArea(patchID); 
		}

		rmSetStatusText("",0.6);

        int leftmines = rmCreateObjectDef("left gold mines");
        rmAddObjectDefItem(leftmines, "MineCopper", 1, 1.0);
        rmSetObjectDefMinDistance(leftmines, 0.0);
        rmSetObjectDefMaxDistance(leftmines, rmXFractionToMeters(0.25));
        rmAddObjectDefConstraint(leftmines, avoidCoinMed);
        rmAddObjectDefConstraint(leftmines, avoidTownCenterMore);
        rmAddObjectDefConstraint(leftmines, avoidSocket);
        rmAddObjectDefConstraint(leftmines, AvoidWaterShort2);
        rmAddObjectDefConstraint(leftmines, forestConstraintShort);
        rmAddObjectDefConstraint(leftmines, circleConstraint);
		rmAddObjectDefConstraint(leftmines, avoidRush);
        rmPlaceObjectDefAtLoc(leftmines, 0, 0.25, 0.35, 6);
		
        int rightmines = rmCreateObjectDef("right gold mines");
        rmAddObjectDefItem(rightmines, "MineCopper", 1, 1.0);
        rmSetObjectDefMinDistance(rightmines, 0.0);
        rmSetObjectDefMaxDistance(rightmines, rmXFractionToMeters(0.25));
        rmAddObjectDefConstraint(rightmines, avoidCoinMed);
        rmAddObjectDefConstraint(rightmines, avoidTownCenterMore);
        rmAddObjectDefConstraint(rightmines, avoidSocket);
        rmAddObjectDefConstraint(rightmines, AvoidWaterShort2);
        rmAddObjectDefConstraint(rightmines, forestConstraintShort);
        rmAddObjectDefConstraint(rightmines, circleConstraint);
		rmAddObjectDefConstraint(rightmines, avoidRush);
        rmPlaceObjectDefAtLoc(rightmines, 0, 0.75, 0.35, 6);
		
	
	int ambiental = rmCreateObjectDef("ambiental");
	rmAddObjectDefItem(ambiental, "UnderbrushAus", 1, 5.0);
	rmSetObjectDefMinDistance(ambiental, 0);
	rmSetObjectDefMaxDistance(ambiental, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(ambiental, avoidTownCenterSmall);
	rmAddObjectDefConstraint(ambiental, avoidNuggetSmall);
	rmAddObjectDefConstraint(ambiental, avoidSocketMore);
	rmAddObjectDefConstraint(ambiental, avoidCoin);
	rmAddObjectDefConstraint(ambiental, avoidAll);
	rmPlaceObjectDefAtLoc(ambiental, 0, 0.5, 0.5, 80*cNumberNonGaiaPlayers);	
    

        int rheaxID = rmCreateObjectDef("caribou hunts");
        rmAddObjectDefItem(rheaxID, "rhea", rmRandInt(7,7), 10.0);
        rmSetObjectDefCreateHerd(rheaxID, true);
        rmSetObjectDefMinDistance(rheaxID, 0);
        rmSetObjectDefMaxDistance(rheaxID, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(rheaxID, circleConstraint);
        rmAddObjectDefConstraint(rheaxID, avoidTownCenterMedium);
        rmAddObjectDefConstraint(rheaxID, avoidHunt);
		rmAddObjectDefConstraint(rheaxID, avoidRush);
        rmPlaceObjectDefAtLoc(rheaxID, 0, 0.5, 0.5, 20);

		rmSetStatusText("",0.7);

        /*
        int herdableID=rmCreateObjectDef("cow");
        rmAddObjectDefItem(herdableID, "cow", 1, 4.0);
        rmSetObjectDefMinDistance(herdableID, 0.0);
        rmSetObjectDefMaxDistance(herdableID, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(rheaxID, circleConstraint);
        rmAddObjectDefConstraint(rheaxID, avoidTownCenterMedium);
        rmAddObjectDefConstraint(rheaxID, avoidHunt);
        rmPlaceObjectDefAtLoc(herdableID, 0, 0.5, 0.5, 12);
  */

        int leftnuggeteasy= rmCreateObjectDef("leftnuggeteasy");
        rmAddObjectDefItem(leftnuggeteasy, "Nugget", 1, 0.0);
        rmSetObjectDefMinDistance(leftnuggeteasy, 0.0);
        rmSetObjectDefMaxDistance(leftnuggeteasy, rmXFractionToMeters(0.25));
        rmAddObjectDefConstraint(leftnuggeteasy, avoidNugget);
        rmAddObjectDefConstraint(leftnuggeteasy, circleConstraint);
        rmAddObjectDefConstraint(leftnuggeteasy, avoidTownCenter);
        rmAddObjectDefConstraint(leftnuggeteasy, avoidCoin);
        rmAddObjectDefConstraint(leftnuggeteasy, forestConstraintShort);
        //rmAddObjectDefConstraint(leftnuggeteasy, avoidNatives);
        rmAddObjectDefConstraint(leftnuggeteasy, avoidWaterShort);
        rmAddObjectDefConstraint(leftnuggeteasy, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(leftnuggeteasy, avoidSocket);
		rmAddObjectDefConstraint(leftnuggeteasy, avoidRush);
        rmSetNuggetDifficulty(1, 1);
        rmPlaceObjectDefAtLoc(leftnuggeteasy, 0, 0.25, 0.35, 3);  
		
        int leftnuggetmed= rmCreateObjectDef("leftnuggetmed");
        rmAddObjectDefItem(leftnuggetmed, "Nugget", 1, 0.0);
        rmSetObjectDefMinDistance(leftnuggetmed, 0.0);
        rmSetObjectDefMaxDistance(leftnuggetmed, rmXFractionToMeters(0.25));
        rmAddObjectDefConstraint(leftnuggetmed, avoidNugget);
        rmAddObjectDefConstraint(leftnuggetmed, circleConstraint);
        rmAddObjectDefConstraint(leftnuggetmed, avoidTownCenter);
        rmAddObjectDefConstraint(leftnuggetmed, avoidCoin);
        rmAddObjectDefConstraint(leftnuggetmed, forestConstraintShort);
        //rmAddObjectDefConstraint(leftnuggetmed, avoidNatives);
        rmAddObjectDefConstraint(leftnuggetmed, avoidWaterShort);
        rmAddObjectDefConstraint(leftnuggetmed, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(leftnuggetmed, avoidSocket);
		rmAddObjectDefConstraint(leftnuggetmed, avoidRush);
        rmSetNuggetDifficulty(2, 2);
        rmPlaceObjectDefAtLoc(leftnuggetmed, 0, 0.25, 0.35, 4);  		
		
		rmSetStatusText("",0.8);

        int rightnuggeteasy= rmCreateObjectDef("rightnuggeteasy");
        rmAddObjectDefItem(rightnuggeteasy, "Nugget", 1, 0.0);
        rmSetObjectDefMinDistance(rightnuggeteasy, 0.0);
        rmSetObjectDefMaxDistance(rightnuggeteasy, rmXFractionToMeters(0.25));
        rmAddObjectDefConstraint(rightnuggeteasy, avoidNugget);
        rmAddObjectDefConstraint(rightnuggeteasy, circleConstraint);
        rmAddObjectDefConstraint(rightnuggeteasy, avoidTownCenter);
        rmAddObjectDefConstraint(rightnuggeteasy, avoidCoin);
        rmAddObjectDefConstraint(rightnuggeteasy, forestConstraintShort);
        //rmAddObjectDefConstraint(rightnuggeteasy, avoidNatives);
        rmAddObjectDefConstraint(rightnuggeteasy, avoidWaterShort);
        rmAddObjectDefConstraint(rightnuggeteasy, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(rightnuggeteasy, avoidSocket);
		rmAddObjectDefConstraint(rightnuggeteasy, avoidRush);
        rmSetNuggetDifficulty(1, 1);
        rmPlaceObjectDefAtLoc(rightnuggeteasy, 0, 0.75, 0.35, 3);  		
  

        int rightnuggetmed= rmCreateObjectDef("rightnuggetmed");
        rmAddObjectDefItem(rightnuggetmed, "Nugget", 1, 0.0);
        rmSetObjectDefMinDistance(rightnuggetmed, 0.0);
        rmSetObjectDefMaxDistance(rightnuggetmed, rmXFractionToMeters(0.25));
        rmAddObjectDefConstraint(rightnuggetmed, avoidNugget);
        rmAddObjectDefConstraint(rightnuggetmed, circleConstraint);
        rmAddObjectDefConstraint(rightnuggetmed, avoidTownCenter);
        rmAddObjectDefConstraint(rightnuggetmed, avoidCoin);
        rmAddObjectDefConstraint(rightnuggetmed, forestConstraintShort);
        //rmAddObjectDefConstraint(rightnuggetmed, avoidNatives);
        rmAddObjectDefConstraint(rightnuggetmed, avoidWaterShort);
        rmAddObjectDefConstraint(rightnuggetmed, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(rightnuggetmed, avoidSocket);
		rmAddObjectDefConstraint(rightnuggetmed, avoidRush);
        rmSetNuggetDifficulty(2, 2);
        rmPlaceObjectDefAtLoc(rightnuggetmed, 0, 0.75, 0.35, 4); 
		
		rmSetStatusText("",0.9);

        int nuggethard= rmCreateObjectDef("nuggethard");
        rmAddObjectDefItem(nuggethard, "Nugget", 1, 0.0);
        rmSetObjectDefMinDistance(nuggethard, 0.0);
        rmSetObjectDefMaxDistance(nuggethard, rmXFractionToMeters(0.25));
        rmAddObjectDefConstraint(nuggethard, avoidNugget);
        rmAddObjectDefConstraint(nuggethard, circleConstraint);
        rmAddObjectDefConstraint(nuggethard, avoidTownCenter);
        rmAddObjectDefConstraint(nuggethard, avoidCoin);
        rmAddObjectDefConstraint(nuggethard, forestConstraintShort);
        //rmAddObjectDefConstraint(nuggethard, avoidNatives);
        rmAddObjectDefConstraint(nuggethard, avoidWaterShort);
        rmAddObjectDefConstraint(nuggethard, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(nuggethard, avoidSocket);
		rmAddObjectDefConstraint(nuggethard, avoidRush);
        rmSetNuggetDifficulty(4, 4);
        rmPlaceObjectDefAtLoc(nuggethard, 0, 0.505, 0.88, 4);  

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

		rmSetStatusText("",1.0);
				
}