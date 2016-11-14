/* Durokan's  Jebel Musa - April 5 2016 Version 1.2*/
	/*=======================Changes from 1.0=======================

	Natives:
	-removed 1 apache camp, there is now only 1 jesuit and 1 apache, both on each side of the anvil

	Resources:
	- added constraints for a single guaranteed mine and level 2 treasure in the corner of the map. assuming the map looks like a "+" shape in brown, it would be on the horizontal "-" corners
	-added constraints and applicable map areas to keep items tagged as "anvil" on the hammer shaped outcrop
		^This includes a set of gold mines, level 2 treasures, and avoidance for level 1,3 treasures and other mines
	-Forests now avoid the TC by more to give the TC more space. They also use different constraints to spawn more evenly. They now avoid the trade route by a long distance instead of avoiding treasures which was sloppy code.
	-starting trees should no longer entangle mines or berries
	-hunts no longer spawn on the low side of cliffs due to their removal
	-The treasures now spawn accordingly: level 3's in the corner area, level 2's on the anvil, and level 1's in the valley.

	Spawn + TC:
	-shifted spawns in 1v1 closer to the x axis by .1 
	-shifted the spawn points for team away from the edges of the plateau by .03 in the z direction.

	Textures/Terrain:	
	-added a texturing function; the map is less monotonous now.
	-changed map textures to texas 4,5 in the dry area, california 8,9 in the wet area. changed the water to texas pond, removed cliffs on water edge
	-map now spawns with grass and a few trees on the water edge due to texas pond
	-cliff texture changed to Texas from Araucania North Coast
	-Changed coherence of the anvil from .85 to .8, giving it a less round shape
	
	Misc:
	-Added the 'Durokan <3's Aiz' function to the top of the anvil. This spawns two neutral alligator buddies which can be duelled for a marginal amount of xp. 
	-Starting hunts are tagged as 'bison' for the express purpose of making sure they spawn correctly and fairly. There are 3 sets per player. They will be reverted to 'ypIbex' before the map is completed
	-map loading bar improved though it does hover around .5 for a long time

	Things to be adressed:
	Resource balance, mines/hunts still spawn unfairly on occasion. I plan on adding 3 zones to accomodate this. They will be Plateau1, Plateau2, and Valley. They will all be initialized differently in each area to balance it better.

	=======================Changes from 1.1=======================
	Natives:

	Resources:
	-made starting hunts avoid water, pushing the hunts for the tc's close to shore back onto the plateau or closer to it
	-mines now spawn along the valley and on cliffs seperately. 
	-There is now a modified hunt spawn for 1v1; it disregards the 3rd starting hunt and places it differently.
	-re-ordered the guaranteed corner resources to now place in order of gold>hunts>nugget instead of hunt>nugget>gold. this reduces/eliminates bugs where the gold won't spawn due to the hitbox of the treasure
	
	Spawn + TC:
	-team tc's z axis increased by .03 to .21 from .18
	
	Textures:	

	Misc:

	Things to be adressed:
	-still alot of open space on the valley region
	
	=======================Changes from 1.2=======================
	-Hunts renamed to ypIbex from bison
	
*/

	include "mercenaries.xs";
	include "ypAsianInclude.xs";
	include "ypKOTHInclude.xs";

	void main(void) { 

		rmSetStatusText("",0.1);

		float playerTiles=13000;
			if (cNumberNonGaiaPlayers>4)
				playerTiles = 11000;
			if (cNumberNonGaiaPlayers>6)
				playerTiles = 9000;			
		int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
		rmSetMapSize(size, size);
		rmSetSeaType("New Zealand Coast");
		rmSetSeaLevel(-7);
		rmSetMapType("land");
		rmSetMapType("grass");
		rmSetMapType("Japan");
		rmTerrainInitialize("water"); 
		rmSetLightingSet("Pampas");
		
		rmDefineClass("classForest");

		int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
		int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
		int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);	
		int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 45.0);
		int avoidHuntBase=rmCreateTypeDistanceConstraint("stuff avoid hunts", "huntable", 4.0);
		int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
		int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
		int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 6.0);
		int avoidWaterLong = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 20.0);
		int AvoidWaterShort2 = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 15.0);
		int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 12);
		int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("objects avoid trade route far", 30);
		int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 4.0);
		int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 5.0);
		int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
		int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
		int avoidTownCenterMedium=rmCreateTypeDistanceConstraint("avoid Town Center medium", "townCenter", 21.0);
		int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);	
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0); 
		int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0); 
		
		int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fishSalmon", 20.0);
		int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
		int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "HumpbackWhale", 50.0);
		int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 15.0);

		int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 8.0);
		int avoidNuggetWater = rmCreateTypeDistanceConstraint("avoid nugget water", "AbstractNugget", 70.0);
		int avoidEdge = rmCreatePieConstraint("Avoid Edge", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

		int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 20.0);
		int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 20);
		int flagEdgeConstraint = rmCreatePieConstraint("flag edge of map", 0.5, 0.5, 0, rmGetMapXSize()-25, 0, 0, 0);
		int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 8.0);
		int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);

		int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.38), rmDegreesToRadians(0),rmDegreesToRadians(360));

		rmDefineClass("classPlateau");
		int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 5.0);
		rmDefineClass("classAnvil");
		int avoidAnvil=rmCreateClassDistanceConstraint("stuff vs. Anvil", rmClassID("classAnvil"), 5.0);
		rmDefineClass("classContinent");
		int avoidContinent=rmCreateClassDistanceConstraint("stuff vs. Continent", rmClassID("classContinent"), 5.0);
		

		float spawnSwitch = rmRandFloat(0,1.2);
	
		if(cNumberNonGaiaPlayers == 2){
			if (spawnSwitch<0.6) {	
			rmPlacePlayer(1, 0.2, 0.25);
			rmPlacePlayer(2, 0.8, 0.25);
			}else{
			rmPlacePlayer(1, 0.8, 0.25);
			rmPlacePlayer(2, 0.2, 0.25);
			}
		}else if (cNumberTeams == 2){
			if (spawnSwitch<0.6) {	
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.2, 0.21, 0.2, 0.47, 0, 0);
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.8, 0.21, 0.8, 0.47, 0, 0);
			}else{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.2, 0.21, 0.2, 0.47, 0, 0);
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.8, 0.21, 0.8, 0.47, 0, 0);
			}

		}else{
			rmSetPlacementSection(0.25, 0.75);
			rmPlacePlayersCircular(0.4, 0.4, 0.02);
		}
		chooseMercs();
		rmSetStatusText("",0.10);

		int continent = rmCreateArea("big huge continent");
		rmAddAreaToClass(continent, rmClassID("classContinent"));
		rmSetAreaSize(continent, 0.64, 0.64);
		rmSetAreaLocation(continent, 0.5, 0.15);
		rmSetAreaTerrainType(continent, "araucania\ground_grass3_ara");
		rmSetAreaBaseHeight(continent, -4.5);
		rmSetAreaCoherence(continent, .8);
		rmAddAreaInfluenceSegment(continent, 0.0, 0.25, 1.0, 0.25); 
		rmSetAreaSmoothDistance(continent, 1);
		rmSetAreaElevationEdgeFalloffDist(continent, 10);
		rmSetAreaElevationVariation(continent, 5);
		rmSetAreaElevationPersistence(continent, 0.5);
		rmSetAreaElevationOctaves(continent, 5);
		rmSetAreaElevationMinFrequency(continent, 0.01);
		rmSetAreaElevationType(continent, cElevTurbulence);   
		rmBuildArea(continent);

		
		int cape = rmCreateArea("cape left");
		rmAddAreaToClass(cape, rmClassID("classAnvil"));
		rmSetAreaSize(cape, 0.015, 0.015);
		rmSetAreaSmoothDistance(cape, 1);
		rmSetAreaLocation(cape, 0.40, 0.8);
		rmSetAreaTerrainType(cape, "araucania\ground_grass3_ara");
		rmSetAreaBaseHeight(cape, -4.5);
		rmSetAreaCoherence(cape, 0.8);
		rmSetAreaElevationEdgeFalloffDist(cape, 10);
		rmSetAreaElevationVariation(cape, 5);
		rmSetAreaElevationPersistence(cape, 0.5);
		rmSetAreaElevationOctaves(cape, 5);
		rmSetAreaElevationMinFrequency(cape, 0.01);
		rmSetAreaElevationType(cape, cElevTurbulence);   
		rmBuildArea(cape); 
		
		int cape2 = rmCreateArea("cape right");
		rmAddAreaToClass(cape2, rmClassID("classAnvil"));
		rmSetAreaSmoothDistance(cape2, 1);
		rmSetAreaSize(cape2, 0.015, 0.015);
		rmSetAreaLocation(cape2, 0.60, 0.8);
		rmSetAreaTerrainType(cape2, "araucania\ground_grass3_ara");
		rmSetAreaBaseHeight(cape2, -4.5);
		rmSetAreaCoherence(cape2, 0.8);
		rmSetAreaElevationEdgeFalloffDist(cape2, 10);
		rmSetAreaElevationVariation(cape2, 5);
		rmSetAreaElevationPersistence(cape2, 0.5);
		rmSetAreaElevationOctaves(cape2, 5);
		rmSetAreaElevationMinFrequency(cape2, 0.01);
		rmSetAreaElevationType(cape2, cElevTurbulence);   
		rmBuildArea(cape2); 
		
		int cape3 = rmCreateArea("cape middle top");
		rmAddAreaToClass(cape3, rmClassID("classAnvil"));
		rmSetAreaSize(cape3, 0.015, 0.015);
		rmSetAreaLocation(cape3, 0.50, 0.8);
		rmSetAreaSmoothDistance(cape3, 1);
		rmSetAreaTerrainType(cape3, "araucania\ground_grass3_ara");
		rmSetAreaBaseHeight(cape3, -4.5);
		rmSetAreaCoherence(cape3, 0.8);
		rmSetAreaElevationEdgeFalloffDist(cape3, 10);
		rmSetAreaElevationVariation(cape3, 5);
		rmSetAreaElevationPersistence(cape3, 0.5);
		rmSetAreaElevationOctaves(cape3, 5);
		rmSetAreaElevationMinFrequency(cape3, 0.01);
		rmSetAreaElevationType(cape3, cElevTurbulence);   
		rmBuildArea(cape3); 
		
		int cape4 = rmCreateArea("cape middle bottom");
		rmAddAreaToClass(cape4, rmClassID("classAnvil"));
		rmSetAreaSize(cape4, 0.015, 0.015);
		rmSetAreaLocation(cape4, 0.5, 0.68);
		rmSetAreaTerrainType(cape4, "araucania\ground_grass3_ara");
		rmSetAreaBaseHeight(cape4, -4.5);
		rmSetAreaCoherence(cape4, 0.9);
		rmSetAreaElevationEdgeFalloffDist(cape4, 10);
		rmSetAreaElevationVariation(cape4, 5);
		rmSetAreaElevationPersistence(cape4, 0.5);
		rmSetAreaElevationOctaves(cape4, 5);
		rmSetAreaElevationMinFrequency(cape4, 0.01);
		rmSetAreaElevationType(cape4, cElevTurbulence);   
		rmBuildArea(cape4); 
		
	int ambiental = rmCreateObjectDef("ambiental");
	rmAddObjectDefItem(ambiental, "UnderbrushForest", 1, 5.0);
	rmSetObjectDefMinDistance(ambiental, 0);
	rmSetObjectDefMaxDistance(ambiental, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(ambiental, avoidTownCenterSmall);
	rmAddObjectDefConstraint(ambiental, avoidWaterShort);
	rmAddObjectDefConstraint(ambiental, avoidTradeRoute);
	rmAddObjectDefConstraint(ambiental, avoidAll);
	rmPlaceObjectDefAtLoc(ambiental, 0, 0.5, 0.5, 90*cNumberNonGaiaPlayers);

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmSetObjectDefMinDistance(socketID, 0.0);
		rmSetObjectDefMaxDistance(socketID, 6.0);
		int tradeRouteID = rmCreateTradeRoute();
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, -0.1);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.75);
		rmBuildTradeRoute(tradeRouteID, "dirt");

		vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.4);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.92);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		rmSetStatusText("",0.20);

		int classPatch = rmDefineClass("patch");
		int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
		int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

		int leftPlateau = rmCreateArea("plateau left");
		rmSetAreaSize(leftPlateau, 0.2, 0.2); 
		rmAddAreaToClass(leftPlateau, rmClassID("classPlateau"));
		rmAddAreaTerrainReplacement(leftPlateau, "araucania\ground_grass3_ara", "araucania\ground_grass1_ara");//great_plains\ground8_gp
		rmSetAreaCliffType(leftPlateau, "Araucania Central");
		rmSetAreaCliffEdge(leftPlateau, 1, 1, 0.0, 0.0, 1); 
		rmSetAreaCliffPainting(leftPlateau, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(leftPlateau, 4, 0.1, 0.5);
		rmSetAreaCoherence(leftPlateau, .95);
		rmSetAreaLocation(leftPlateau, .05, .3);
		rmAddAreaInfluenceSegment(leftPlateau, 0.2, 0.0, 0.2, 0.4);
		rmBuildArea(leftPlateau);	

		int rightPlateau = rmCreateArea("plateau right");
		rmAddAreaToClass(rightPlateau, rmClassID("classPlateau"));
		rmSetAreaSize(rightPlateau, 0.2, 0.2); 
		rmAddAreaTerrainReplacement(rightPlateau, "araucania\ground_grass3_ara", "araucania\ground_grass1_ara");
		rmSetAreaCliffType(rightPlateau, "Araucania Central");
		rmSetAreaCliffEdge(rightPlateau, 1, 1, 0.0, 0.0, 1); 
		rmSetAreaCliffPainting(rightPlateau, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(rightPlateau, 4, 0.1, 0.5);
		rmSetAreaCoherence(rightPlateau, .95);
		rmSetAreaLocation(rightPlateau, .85, .3);
		rmAddAreaInfluenceSegment(rightPlateau, 0.8, .0, 0.8, .4);
		rmBuildArea(rightPlateau);	
		
		int rampNumbers = 8;
				
		for(i=i; < rampNumbers) { 
		int rampLarge = rmCreateArea("top left center basin left ramp"+i);
		rmAddAreaTerrainReplacement(rampLarge, "texas\cliff_top_tex", "amazon\river1_am");
		rmSetAreaSize(rampLarge, 0.0044, 0.0044);
		rmSetAreaBaseHeight(rampLarge, -3.6);
		rmSetAreaSmoothDistance(rampLarge, -8);
		rmSetAreaCoherence(rampLarge, 1);
		if(i == 1){
		rmSetAreaLocation(rampLarge, 0.33, 0.5);
		}else if(i == 2){
		rmSetAreaLocation(rampLarge, 0.67, 0.5);
		}else if(i == 3){
		rmSetAreaLocation(rampLarge, 0.62, 0.12);
		}else if(i == 4){
		rmSetAreaLocation(rampLarge, 0.38, 0.12);
		}else if(i == 5){
		rmSetAreaLocation(rampLarge, 0.62, 0.35);
		}else if(i == 6){
		rmSetAreaLocation(rampLarge, 0.38, 0.35);
		}else if(i == 7){
		rmSetAreaLocation(rampLarge, 0.92, 0.525);
		}else{
		rmSetAreaLocation(rampLarge, 0.08, 0.525);
		}
		rmBuildArea(rampLarge); 
		}
						
		for (i=0; < cNumberNonGaiaPlayers*125){
			int patchID = rmCreateArea("the redder stuff"+i);
			rmSetAreaWarnFailure(patchID, false);
			rmSetAreaSize(patchID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(51));
			rmAddAreaTerrainReplacement(patchID, "araucania\ground_grass3_ara", "araucania\ground_dirt2_ara");
			rmPaintAreaTerrain(patchID);
			rmAddAreaToClass(patchID, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID, 1.0);
			rmAddAreaConstraint(patchID, circleConstraint2);
			rmBuildArea(patchID); 
		}
		
		for (i=0; < cNumberNonGaiaPlayers*125){
			int patchID2 = rmCreateArea("the redder stuff2"+i);
			rmSetAreaWarnFailure(patchID2, false);
			rmSetAreaSize(patchID2, rmAreaTilesToFraction(11), rmAreaTilesToFraction(17));
			rmAddAreaTerrainReplacement(patchID2, "araucania\ground_grass3_ara", "araucania\ground_dirt2_ara");
			rmPaintAreaTerrain(patchID2);
			rmAddAreaToClass(patchID2, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID2, 1.0);
			rmAddAreaConstraint(patchID2, circleConstraint2);
			rmBuildArea(patchID2); 
		}
		rmSetStatusText("",0.30);

		for (i=0; < cNumberNonGaiaPlayers*125){
			int patchID3 = rmCreateArea("the redder stuff3"+i);
			rmSetAreaWarnFailure(patchID3, false);
			rmSetAreaSize(patchID3, rmAreaTilesToFraction(30), rmAreaTilesToFraction(51));
			rmAddAreaTerrainReplacement(patchID3, "araucania\ground_grass1_ara", "araucania\ground_grass2_ara");
			rmPaintAreaTerrain(patchID3);
			rmAddAreaToClass(patchID3, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID3, 1.0);
			rmAddAreaConstraint(patchID3, circleConstraint2);
			rmBuildArea(patchID3); 
		}

		int playerStart = rmCreateStartingUnitsObjectDef(5.0);
		rmSetObjectDefMinDistance(playerStart, 7.0);
		rmSetObjectDefMaxDistance(playerStart, 12.0);
		rmAddObjectDefConstraint(playerStart, avoidAll);
				
				
	//Natives
	int nativeSwitch = rmRandInt(0,1);
	
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Jesuit");
	subCiv1= rmGetCivID("Jesuit");
	rmSetSubCiv(0, "Jesuit");
	rmSetSubCiv(1, "Jesuit");
	
	int nativeID0 = -1;
    int nativeID2 = -1;
				
	nativeID0 = rmCreateGrouping("Apache village", "native jesuit mission borneo 0"+4);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	
	nativeID2 = rmCreateGrouping("Jesuit village ", "native jesuit mission borneo 0"+5);
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));

	if(nativeSwitch == 0){
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.60, 0.8);
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.40, 0.8); 
	}else{
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.8);
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.60, 0.8); 
	}
	rmSetStatusText("",0.40);

		int berryID = rmCreateObjectDef("starting berries"); 
		rmAddObjectDefItem(berryID, "BerryBush", 4, 6.0); 
		rmSetObjectDefMinDistance(berryID, 8.0); 
		rmSetObjectDefMaxDistance(berryID, 12.0); 
		rmAddObjectDefConstraint(berryID, avoidCoin);

		int treeID = rmCreateObjectDef("starting trees"); 
		rmAddObjectDefItem(treeID, "TreeCarolinaGrass", rmRandInt(6,9), 10.0); 
		rmAddObjectDefItem(treeID, "UnderbrushForest", rmRandInt(8,10), 12.0);
		rmSetObjectDefMinDistance(treeID, 20.0); 
		rmSetObjectDefMaxDistance(treeID, 25.0);
		rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
		rmAddObjectDefConstraint(treeID, avoidCoin);
		rmAddObjectDefConstraint(treeID, avoidHunt);

		int foodID = rmCreateObjectDef("starting hunt1"); 
		rmAddObjectDefItem(foodID, "ypIbex", 8, 12.0); 
		rmSetObjectDefMinDistance(foodID, 10.0); 
		rmSetObjectDefMaxDistance(foodID, 10.0); 	
		rmAddObjectDefConstraint(foodID, circleConstraint);
		rmAddObjectDefConstraint(foodID, avoidWaterLong);
		rmSetObjectDefCreateHerd(foodID, true);

		int foodID2 = rmCreateObjectDef("starting hunt2"); 
		rmAddObjectDefItem(foodID2, "ypIbex", 8, 13.0); 
		rmSetObjectDefMinDistance(foodID2, 40.0); 
		rmSetObjectDefMaxDistance(foodID2, 40.0); 
		rmAddObjectDefConstraint(foodID2, circleConstraint);
		rmAddObjectDefConstraint(foodID2, avoidWaterLong);
		rmSetObjectDefCreateHerd(foodID2, true);
		
		rmSetStatusText("",0.50);

		int foodID3 = rmCreateObjectDef("starting hunt3"); 
		rmAddObjectDefItem(foodID3, "ypIbex", 8, 12.0); 
		rmSetObjectDefMinDistance(foodID3, 60.0); 
		rmSetObjectDefMaxDistance(foodID3, 60.0); 		
		rmAddObjectDefConstraint(foodID3, circleConstraint);
		rmAddObjectDefConstraint(foodID3, avoidWaterLong);
		rmSetObjectDefCreateHerd(foodID3, true);

		for(i=1; <cNumberPlayers) { 
		int id=rmCreateArea("Player"+i); 
		rmSetPlayerArea(i, id); 
		int startID = rmCreateObjectDef("object"+i); 
		rmAddObjectDefItem(startID, "TownCenter", 1, 5.0); 
		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i)); 
		rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (cNumberNonGaiaPlayers>2){
		rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}
		rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		int placedTC = rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startID, i));

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

		rmSetStatusText("",0.60);

		int cornerMines = rmCreateObjectDef(" cornerMines");
		rmAddObjectDefItem(cornerMines, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(cornerMines, 0.0);
		rmSetObjectDefMaxDistance(cornerMines, rmXFractionToMeters(0.01));
		rmAddObjectDefConstraint(cornerMines, circleConstraint);
		rmPlaceObjectDefAtLoc(cornerMines, 0, 0.09, 0.605, 1);   
		rmPlaceObjectDefAtLoc(cornerMines, 0, 0.91, 0.605, 1);   

		int cornerHunts = rmCreateObjectDef("guarenteed corner hunts");
		rmAddObjectDefItem(cornerHunts, "ypIbex", rmRandInt(8,8), 10.0);
		rmSetObjectDefCreateHerd(cornerHunts, true);
		rmSetObjectDefMinDistance(cornerHunts, 0);
		rmSetObjectDefMaxDistance(cornerHunts, rmXFractionToMeters(0.01));
		rmAddObjectDefConstraint(cornerHunts, circleConstraint);
		rmPlaceObjectDefAtLoc(cornerHunts, 0, 0.09, 0.605, 1);
		rmPlaceObjectDefAtLoc(cornerHunts, 0, 0.91, 0.605, 1);
		if (cNumberNonGaiaPlayers==2){
		rmPlaceObjectDefAtLoc(cornerHunts, 0, 0.25, 0.4, 1);
		rmPlaceObjectDefAtLoc(cornerHunts, 0, 0.75, 0.4, 1);
		}

		int cornerNugget= rmCreateObjectDef("corner nugs"); 
		rmAddObjectDefItem(cornerNugget, "Nugget", 1, 0.0); 
		rmSetObjectDefMinDistance(cornerNugget, 0.0); 
		rmSetObjectDefMaxDistance(cornerNugget, rmXFractionToMeters(0.01)); 
		rmAddObjectDefConstraint(cornerNugget, circleConstraint);
		rmSetNuggetDifficulty(3, 3); 
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.1, 0.606, 1);   
		rmPlaceObjectDefAtLoc(cornerNugget, 0, 0.9, 0.606, 1);   
		

		int rheaxID = rmCreateObjectDef("ibex hunts");
		rmAddObjectDefItem(rheaxID, "ypIbex", rmRandInt(8,8), 10.0);
		rmSetObjectDefCreateHerd(rheaxID, true);
		rmSetObjectDefMinDistance(rheaxID, 0);
		rmSetObjectDefMaxDistance(rheaxID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(rheaxID, circleConstraint);
		rmAddObjectDefConstraint(rheaxID, avoidTownCenterMedium);
		rmAddObjectDefConstraint(rheaxID, avoidHunt);
		rmAddObjectDefConstraint(rheaxID, AvoidWaterShort2); 
		rmAddObjectDefConstraint(rheaxID, avoidPlateau); 
		rmPlaceObjectDefAtLoc(rheaxID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
			 
		int anvilNuggets = rmCreateObjectDef("nuggets on the anvil"); 
		rmAddObjectDefItem(anvilNuggets, "Nugget", 1, 0.0); 
		rmSetObjectDefMinDistance(anvilNuggets, 0.0); 
		rmSetObjectDefMaxDistance(anvilNuggets, rmXFractionToMeters(0.2)); 
		rmAddObjectDefConstraint(anvilNuggets, avoidNugget); 
		rmAddObjectDefConstraint(anvilNuggets, circleConstraint);
		rmAddObjectDefConstraint(anvilNuggets, avoidCoin); 
		rmAddObjectDefConstraint(anvilNuggets, forestConstraintShort);
		rmAddObjectDefConstraint(anvilNuggets, avoidWaterShort); 
		rmAddObjectDefConstraint(anvilNuggets, avoidTradeRoute);
		rmAddObjectDefConstraint(anvilNuggets, avoidSocket); 
		rmAddObjectDefConstraint(anvilNuggets, avoidPlateau); 
		rmSetNuggetDifficulty(2, 2); 
		rmPlaceObjectDefAtLoc(anvilNuggets, 0, 0.5, 0.8, 2*cNumberNonGaiaPlayers); 
		
		int anvilMines = rmCreateObjectDef("anvilMines gold");
		rmAddObjectDefItem(anvilMines, "mineGold", 1, 1.0);
		rmSetObjectDefMinDistance(anvilMines, 0.0);
		rmSetObjectDefMaxDistance(anvilMines, rmXFractionToMeters(0.09));
		rmAddObjectDefConstraint(anvilMines, avoidCoinMed);
		rmAddObjectDefConstraint(anvilMines, avoidSocket);
		rmAddObjectDefConstraint(anvilMines, AvoidWaterShort2);
		rmAddObjectDefConstraint(anvilMines, forestConstraintShort);
		rmAddObjectDefConstraint(anvilMines, circleConstraint);
		rmPlaceObjectDefAtLoc(anvilMines, 0, 0.5, 0.8, .5*cNumberNonGaiaPlayers);

		rmSetStatusText("",0.70);

	  	int mines = rmCreateObjectDef(" Mines");
		rmAddObjectDefItem(mines, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(mines, 0.0);
		rmSetObjectDefMaxDistance(mines, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(mines, avoidCoinMed);
		rmAddObjectDefConstraint(mines, avoidTownCenterMore);
		rmAddObjectDefConstraint(mines, avoidSocket);
		rmAddObjectDefConstraint(mines, AvoidWaterShort2);
		rmAddObjectDefConstraint(mines, forestConstraintShort);
		rmAddObjectDefConstraint(mines, circleConstraint);
		rmAddObjectDefConstraint(mines, avoidAnvil);
		rmAddObjectDefConstraint(mines, avoidPlateau);
		rmPlaceObjectDefAtLoc(mines, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

		int leftMines = rmCreateObjectDef("leftMines");
		rmAddObjectDefItem(leftMines, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(leftMines, 0.0);
		rmSetObjectDefMaxDistance(leftMines, rmXFractionToMeters(0.35));
		rmAddObjectDefConstraint(leftMines, avoidCoinMed);
		rmAddObjectDefConstraint(leftMines, avoidTownCenterMore);
		rmAddObjectDefConstraint(leftMines, avoidSocket);
		rmAddObjectDefConstraint(leftMines, AvoidWaterShort2);
		rmAddObjectDefConstraint(leftMines, forestConstraintShort);
		rmAddObjectDefConstraint(leftMines, circleConstraint);
		rmAddObjectDefConstraint(leftMines, avoidAnvil);
		rmAddObjectDefConstraint(leftMines, avoidTradeRouteFar);
		rmPlaceObjectDefAtLoc(leftMines, 0, 0.25, 0.45, 1*cNumberNonGaiaPlayers);

		int rightMines = rmCreateObjectDef("rightMines");
		rmAddObjectDefItem(rightMines, "mine", 1, 1.0);
		rmSetObjectDefMinDistance(rightMines, 0.0);
		rmSetObjectDefMaxDistance(rightMines, rmXFractionToMeters(0.35));
		rmAddObjectDefConstraint(rightMines, avoidCoinMed);
		rmAddObjectDefConstraint(rightMines, avoidTownCenterMore);
		rmAddObjectDefConstraint(rightMines, avoidSocket);
		rmAddObjectDefConstraint(rightMines, AvoidWaterShort2);
		rmAddObjectDefConstraint(rightMines, forestConstraintShort);
		rmAddObjectDefConstraint(rightMines, circleConstraint);
		rmAddObjectDefConstraint(rightMines, avoidAnvil);
		rmAddObjectDefConstraint(rightMines, avoidTradeRouteFar);
		rmPlaceObjectDefAtLoc(rightMines, 0, 0.75, 0.45, 1*cNumberNonGaiaPlayers);

		int nuggetID= rmCreateObjectDef("nuggets small"); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
		rmSetObjectDefMinDistance(nuggetID, 0.0); 
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
		rmAddObjectDefConstraint(nuggetID, avoidNugget); 
		rmAddObjectDefConstraint(nuggetID, circleConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
		rmAddObjectDefConstraint(nuggetID, avoidCoin); 
		rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
		rmAddObjectDefConstraint(nuggetID, avoidWaterShort); 
		rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(nuggetID, avoidSocket); 
		rmAddObjectDefConstraint(nuggetID, avoidPlateau); 
		rmAddObjectDefConstraint(nuggetID, avoidAnvil); 
		rmSetNuggetDifficulty(1, 1); 
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 3*(cNumberNonGaiaPlayers + 1));   
		
		int avoidGrass=rmCreateClassDistanceConstraint("tree vs. grasses", rmClassID("patch"), 1.0);
		
			for (j=0; < (8*cNumberNonGaiaPlayers)) {   
			int StartAreaTree2ID=rmCreateObjectDef("plateau trees"+j);
			rmAddObjectDefItem(StartAreaTree2ID, "TreeCarolinaGrass", rmRandInt(13,16), rmRandFloat(15.0,20.0));
			rmAddObjectDefToClass(StartAreaTree2ID, rmClassID("classForest")); 
			rmSetObjectDefMinDistance(StartAreaTree2ID, 0);
			rmSetObjectDefMaxDistance(StartAreaTree2ID, rmXFractionToMeters(0.45));
			rmAddObjectDefConstraint(StartAreaTree2ID, avoidTradeRouteFar);
			rmAddObjectDefConstraint(StartAreaTree2ID, avoidSocketMore);
			rmAddObjectDefConstraint(StartAreaTree2ID, circleConstraint);
			rmAddObjectDefConstraint(StartAreaTree2ID, forestConstraint);
			rmAddObjectDefConstraint(StartAreaTree2ID, avoidCoin);
			rmAddObjectDefConstraint(StartAreaTree2ID, avoidTownCenterMore);	
			rmAddObjectDefConstraint(StartAreaTree2ID, AvoidWaterShort2);	
			rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);
		}
		
		rmSetStatusText("",0.80);

	 // Water nuggets
	int nuggetwcount = 4+1*cNumberNonGaiaPlayers;
	
	for (i=0; < nuggetwcount)
	{
		int nuggetW= rmCreateObjectDef("nugget water"+i); 
		rmAddObjectDefItem(nuggetW, "ypNuggetBoat", 1, 0.0);
		rmSetNuggetDifficulty(5, 5);
		rmSetObjectDefMinDistance(nuggetW, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(nuggetW, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nuggetW, avoidLand);
		rmAddObjectDefConstraint(nuggetW, avoidEdge);
		rmAddObjectDefConstraint(nuggetW, avoidNuggetWater);
		rmPlaceObjectDefAtLoc(nuggetW, 0, 0.50, 0.50);
	}

		int fishID=rmCreateObjectDef("fish Mahi");
		rmAddObjectDefItem(fishID, "FishMahi", 1, 0.0);
		rmSetObjectDefMinDistance(fishID, 0.0);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(fishID, fishVsFishID);
		rmAddObjectDefConstraint(fishID, fishLand);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

		int fish2ID=rmCreateObjectDef("fish Tarpon");
		rmAddObjectDefItem(fish2ID, "FishTarpon", 1, 0.0);
		rmSetObjectDefMinDistance(fish2ID, 0.0);
		rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(fish2ID, fishVsFishID);
		rmAddObjectDefConstraint(fish2ID, fishLand);
		rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
		rmSetStatusText("",0.90);

		int whaleID=rmCreateObjectDef("whale");
		rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 0.0);
		rmSetObjectDefMinDistance(whaleID, 0.0);
		rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
		rmAddObjectDefConstraint(whaleID, whaleLand);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
	  
	  	int mineb=rmAddFairLoc("TownCenter", false, false, 18, 19, 12, 5); 

   if(rmPlaceFairLocs())
   {
   mineb=rmCreateObjectDef("mine behind");
   rmAddObjectDefItem(mineb, "mine", 1, 0.0);
   for(i=1; <cNumberNonGaiaPlayers+1)
      {
   for(j=0; <rmGetNumberFairLocs(i))
         {
   rmPlaceObjectDefAtLoc(mineb, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
         }
      }
   }

	int minef=rmAddFairLoc("TownCenter", true, true, 18, 19, 12, 5);

	if(rmPlaceFairLocs()){
		minef=rmCreateObjectDef("forward mine");
		rmAddObjectDefItem(minef, "mine", 1, 0.0);
			for(i=1; <cNumberNonGaiaPlayers+1){
				for(j=1; <rmGetNumberFairLocs(i)){
					rmPlaceObjectDefAtLoc(minef, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
				}
			}
	}
   
		int Durokan = rmCreateObjectDef("Durokan <3's Aiz");
        rmAddObjectDefItem(Durokan, "Alligator", 2, 6.0);
        rmSetObjectDefMinDistance(Durokan, 0);
        rmSetObjectDefMaxDistance(Durokan, 0);
		rmPlaceObjectDefAtLoc(Durokan, 0, 0.5, 0.89, 1);

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.8;
    float walk = 0.015;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

		rmSetStatusText("", 1.0);

	}


	