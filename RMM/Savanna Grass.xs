/* Durokan's Savanna G- April 17 2016 Version 1.1 */
include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";
 
void main(void) {
 
   // Text
   // Make the loading bar move
   rmSetStatusText("",0.01);

   // Picks the map size
	int playerTiles=11000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 10000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 8500;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);

	rmSetMapType("land");
        rmSetMapType("grass");
        rmSetMapType("mongolia");
        rmTerrainInitialize("texas\ground3_tex");
        rmSetLightingSet("great plains");
       
        rmDefineClass("classForest");
         rmDefineClass("classCliffy");

        int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));
        int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
        int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
        int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
        int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 50.0);
        int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
        int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
        int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 6.0);
        int AvoidWaterShort2 = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 5.0);
        int AvoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 35.0);
        int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 6);
        int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 4.0);
        int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 7.0);
        int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);
        int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
        int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
        int avoidTownCenterMedium=rmCreateTypeDistanceConstraint("avoid Town Center medium", "townCenter", 18.0);
        int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);  
        int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
        int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
        int avoidNatives=rmCreateClassDistanceConstraint("things avoids natives", rmClassID("natives"), 5.0);
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);
       
		int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

		int avoidCliffy=rmCreateClassDistanceConstraint("objects vs. cliffies", rmClassID("classCliffy"), 10.0);

		  // Player placing  
  
 
  	int spawnSwitch = rmRandFloat(0,1.2);

		rmPlacePlayersCircular(0.4, 0.4, 0.02);
		
        chooseMercs();

   // Text
   rmSetStatusText("",0.20);
         
        int continent2 = rmCreateArea("continent");
        rmSetAreaSize(continent2, 1.0, 1.0);
        rmSetAreaLocation(continent2, 0.5, 0.0);
        rmSetAreaTerrainType(continent2, "texas\ground3_tex");
        rmSetAreaBaseHeight(continent2, 0.0);
        rmSetAreaCoherence(continent2, 1.0);
        rmSetAreaSmoothDistance(continent2, 10);
        rmSetAreaHeightBlend(continent2, 1);
        //rmSetAreaEdgeFilling(continent2, 5);
        rmSetAreaElevationNoiseBias(continent2, 0);
        rmSetAreaElevationEdgeFalloffDist(continent2, 10);
        rmSetAreaElevationVariation(continent2, 5);
        rmSetAreaElevationPersistence(continent2, .2);
        rmSetAreaElevationOctaves(continent2, 5);
        rmSetAreaElevationMinFrequency(continent2, 0.04);
        rmSetAreaElevationType(continent2, cElevTurbulence);  
        rmBuildArea(continent2);    
       
	   
	    int lakeID9=rmCreateArea("round lake small");
        rmSetAreaLocation(lakeID9, 0.5, 0.5);
        rmSetAreaSize(lakeID9, .05, .05);
        rmSetAreaWaterType(lakeID9, "texas pond");
        rmSetAreaBaseHeight(lakeID9, 0.0);
        rmSetAreaCoherence(lakeID9, .86);
        rmBuildArea(lakeID9);
       
        int island = rmCreateArea("island");
        rmSetAreaSize(island, 0.003, 0.003);
        rmSetAreaLocation(island, 0.44, 0.56);
        rmSetAreaTerrainType(island, "texas\ground3_tex");
        rmSetAreaBaseHeight(island, -.5);
        rmSetAreaCoherence(island, 0.85);
        rmBuildArea(island);

        int island2 = rmCreateArea("island2");
        rmSetAreaSize(island2, 0.003, 0.003);
        rmSetAreaLocation(island2, 0.56, 0.44);
        rmSetAreaTerrainType(island2, "texas\ground3_tex");
        rmSetAreaBaseHeight(island2, -.5);
        rmSetAreaCoherence(island2, 0.85);
        rmBuildArea(island2);

        int island3 = rmCreateArea("island3");
        rmSetAreaSize(island3, 0.01, 0.01);
        rmSetAreaLocation(island3, 0.5, 0.5);
        rmSetAreaTerrainType(island3, "texas\ground3_tex");
        rmSetAreaBaseHeight(island3, 0.0);
        rmSetAreaCoherence(island3, 0.85);
        rmBuildArea(island3);
		
		for (j=0; < 4) {   
		int cliffies = rmCreateArea("le balanced cliffies"+j);
		rmAddAreaToClass(cliffies, rmClassID("classCliffy")); 
		rmSetAreaSize(cliffies, 0.004, 0.004); 
		rmSetAreaCliffType(cliffies, "texas");
		rmSetAreaCliffEdge(cliffies, 1, 1, 0.0, 0.0, 1); 
		rmSetAreaCliffPainting(cliffies, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffies, 3, 0.1, 0.5);
		rmSetAreaCoherence(cliffies, .88);
		if(j==0){
		rmSetAreaLocation(cliffies, .3, .3);
		}else if(j==1){
		rmSetAreaLocation(cliffies, .7, .7);
		}else if(j==2){
		rmSetAreaLocation(cliffies, .7, .3);
		}else{
		rmSetAreaLocation(cliffies, .3, .7);
		}
  		rmBuildArea(cliffies);	
		}

		for (j=0; < 4) {   
		int satelliteLakes=rmCreateArea("satellite lakes"+j);
        rmSetAreaSize(satelliteLakes, .005, .005);
        rmSetAreaWaterType(satelliteLakes, "texas pond");
        rmSetAreaBaseHeight(satelliteLakes, 0.0);
        rmSetAreaCoherence(satelliteLakes, .86);
		if(j==0){
		rmSetAreaLocation(satelliteLakes, 0.5, 0.25);
		}else if(j==1){
		rmSetAreaLocation(satelliteLakes, 0.5, 0.75);
		}else if(j==2){
		rmSetAreaLocation(satelliteLakes, 0.75, 0.5);
		}else{
		rmSetAreaLocation(satelliteLakes, 0.25, 0.5);
		}
		rmBuildArea(satelliteLakes);
		}
		
				// Build grassy areas everywhere.  Whee!
	int numTries=2*cNumberNonGaiaPlayers;
	for (i=0; <numTries){   
		int grassyArea=rmCreateArea("grassyArea"+i);
		rmSetAreaSize(grassyArea, .2, .2);
		rmSetAreaForestType(grassyArea, "Great Plains grass");
		rmSetAreaForestDensity(grassyArea, .5);
		rmSetAreaForestClumpiness(grassyArea, 0.01);
		rmAddAreaConstraint(grassyArea, avoidNatives);
		rmBuildArea(grassyArea);
	}
		
		int meows = rmCreateObjectDef("meows");
        rmAddObjectDefItem(meows, "UnderbrushTexas", 1, 5.0);
        rmSetObjectDefMinDistance(meows, 0);
        rmSetObjectDefMaxDistance(meows, 0);
		rmAddObjectDefConstraint(meows, avoidCliffy);
		rmSetObjectDefMaxDistance(meows, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(meows, circleConstraint);
		rmAddObjectDefConstraint(meows, avoidTownCenterMedium);
		rmAddObjectDefConstraint(meows, avoidHerd);
		rmPlaceObjectDefAtLoc(meows, 0, 0.5, 0.5, cNumberNonGaiaPlayers*8);


   // Text
   rmSetStatusText("",0.50);

  	//Natives
		
	int subCiv0 = -1;
	subCiv0 = rmGetCivID("Aztecs");
	rmSetSubCiv(0, "Aztecs");
	
	int nativeID0 = -1;
		
	nativeID0 = rmCreateGrouping("Jesuit village", "native Aztec village "+4);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.5, 0.5);


        int playerStart = rmCreateStartingUnitsObjectDef(5.0);
        rmSetObjectDefMinDistance(playerStart, 7.0);
        rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidAll);
       
        int goldID = rmCreateObjectDef("starting gold");
        rmAddObjectDefItem(goldID, "minegold", 1, 8.0);
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
        rmAddObjectDefItem(treeID, "TreeTexasDirt", rmRandInt(6,9), 10.0);
        rmAddObjectDefItem(treeID, "UnderbrushForest", rmRandInt(8,10), 12.0);
        rmSetObjectDefMinDistance(treeID, 12.0);
        rmSetObjectDefMaxDistance(treeID, 18.0);
        rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
        rmAddObjectDefConstraint(treeID, avoidCoin);
 
        int foodID = rmCreateObjectDef("starting hunt");
        rmAddObjectDefItem(foodID, "zebra", 8, 8.0);
        rmSetObjectDefMinDistance(foodID, 10.0);
        rmSetObjectDefMaxDistance(foodID, 10.0);
        rmSetObjectDefCreateHerd(foodID, true);
 
        int foodID2 = rmCreateObjectDef("starting hunt 2");
        rmAddObjectDefItem(foodID2, "zebra", 8, 8.0);
        rmSetObjectDefMinDistance(foodID2, 40.0);
        rmSetObjectDefMaxDistance(foodID2, 40.0);
        rmSetObjectDefCreateHerd(foodID2, true);
               

        for(i=1; < cNumberNonGaiaPlayers + 1) {
    int id=rmCreateArea("Player"+i);
    rmSetPlayerArea(i, id);
    int startID = rmCreateObjectDef("object"+i);
    rmAddObjectDefItem(startID, "TownCenter", 1, 5.0);
    rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(gold2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		int playerMissions = rmCreateObjectDef("missionaries"+i);
        rmAddObjectDefItem(playerMissions, "UnderbrushTexas", 1, 10.0);
        rmSetObjectDefMinDistance(playerMissions, 0);
        rmSetObjectDefMaxDistance(playerMissions, 0);
        rmPlaceObjectDefAtLoc(playerMissions, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), 1);

		
		int teamNumber = rmGetPlayerTeam(i);

  }
  
  	  
   // Text
   rmSetStatusText("",0.70);

	for (j=0; < (6*cNumberNonGaiaPlayers)) {   
		int StartAreaTree2ID=rmCreateObjectDef("starting trees dirt"+j);
		rmAddObjectDefItem(StartAreaTree2ID, "TreeTexasDirt", rmRandInt(8,10), rmRandFloat(8.0,16.0));
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
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidCliffy);	
		rmAddObjectDefConstraint(StartAreaTree2ID, AvoidWaterShort2);	
		rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	}
  
  	int islandminesID = rmCreateObjectDef("island silver");
	rmAddObjectDefItem(islandminesID, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(islandminesID, 0.0);
	rmSetObjectDefMaxDistance(islandminesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(islandminesID, avoidCoinMed);
	//rmAddObjectDefConstraint(islandminesID, avoidNatives);
	rmAddObjectDefConstraint(islandminesID, avoidTownCenterMore);
	rmAddObjectDefConstraint(islandminesID, avoidSocket);
	rmAddObjectDefConstraint(islandminesID, AvoidWaterShort2);
	rmAddObjectDefConstraint(islandminesID, forestConstraintShort);
	rmAddObjectDefConstraint(islandminesID, avoidCliffy);
	rmAddObjectDefConstraint(islandminesID, circleConstraint);
	rmPlaceObjectDefAtLoc(islandminesID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	int elephantswitch = rmRandInt(0,1);
	
		int elephantHunts = rmCreateObjectDef("elephants");
		rmAddObjectDefItem(elephantHunts, "ypWildElephant", 5, 10.0);
		rmSetObjectDefCreateHerd(elephantHunts, true);
		rmSetObjectDefMinDistance(elephantHunts, 0);
		rmSetObjectDefMaxDistance(elephantHunts, rmXFractionToMeters(0.15));
		rmAddObjectDefConstraint(elephantHunts, circleConstraint);	
		rmAddObjectDefConstraint(elephantHunts, avoidHunt);
		rmAddObjectDefConstraint(elephantHunts, waterHunt);
		rmAddObjectDefConstraint(elephantHunts, avoidCliffy);
		if(elephantswitch == 1){
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.6, 0.6, 1);   
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.4, 0.6, 1);   
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.6, 0.4, 1);
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.4, 0.4, 1);
		}else{
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.5, 0.7, 1);   
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.5, 0.3, 1);   
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.6, 0.5, 1);
		rmPlaceObjectDefAtLoc(elephantHunts, 0, 0.4, 0.5, 1);
		}

  	int pronghornHunts = rmCreateObjectDef("pronghornHunts");
	rmAddObjectDefItem(pronghornHunts, "zebra", rmRandInt(7,8), 6.0);
	rmSetObjectDefCreateHerd(pronghornHunts, true);
	rmSetObjectDefMinDistance(pronghornHunts, 0);
	rmSetObjectDefMaxDistance(pronghornHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(pronghornHunts, circleConstraint);
	rmAddObjectDefConstraint(pronghornHunts, avoidTownCenterMedium);
	rmAddObjectDefConstraint(pronghornHunts, avoidHunt);
	rmAddObjectDefConstraint(pronghornHunts, AvoidWaterFar);
	rmAddObjectDefConstraint(pronghornHunts, avoidCliffy);
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

  	int rheaHunts = rmCreateObjectDef("rheas");
	rmAddObjectDefItem(rheaHunts, "rhea", rmRandInt(7,8), 6.0);
	rmSetObjectDefCreateHerd(rheaHunts, true);
	rmSetObjectDefMinDistance(rheaHunts, 0);
	rmSetObjectDefMaxDistance(rheaHunts, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rheaHunts, circleConstraint);
	rmAddObjectDefConstraint(rheaHunts, avoidTownCenterMedium);
	rmAddObjectDefConstraint(rheaHunts, avoidHunt);
	rmAddObjectDefConstraint(rheaHunts, avoidCliffy);
	rmAddObjectDefConstraint(rheaHunts, AvoidWaterFar);
	rmPlaceObjectDefAtLoc(rheaHunts, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
	
	int herdableID=rmCreateObjectDef("beefaloes");
	rmAddObjectDefItem(herdableID, "ypWaterBuffalo", 1, 4.0);
	rmSetObjectDefMinDistance(herdableID, 0.0);
	rmAddObjectDefConstraint(herdableID, avoidCliffy);
	rmSetObjectDefMaxDistance(herdableID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(herdableID, circleConstraint);
	rmAddObjectDefConstraint(herdableID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(herdableID, avoidHerd);
	rmPlaceObjectDefAtLoc(herdableID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);
  
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmAddObjectDefConstraint(nuggetID, avoidCliffy);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, avoidCoin); 
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	//rmAddObjectDefConstraint(nuggetID, avoidNatives); 
	rmAddObjectDefConstraint(nuggetID, avoidWaterShort); 
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidSocket); 
	rmSetNuggetDifficulty(1, 2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);   
  

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.6;
    float yLoc = 0.4;
    float walk = 0.015;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
  
   // Text
   rmSetStatusText("",1.0); 
}
 
