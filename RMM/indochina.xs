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
  
  bool weird = false;
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
    
  // FFA and imbalanced teams
  if ( cNumberTeams > 2)
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
	int playerTiles = 15500;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 15000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 14500;		

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
  int playerConstraintNative=rmCreateClassDistanceConstraint("natives stay away from players far", classPlayer, 75.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players medium", classPlayer, 10.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 5.0);

	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 7.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int shortAvoidResource=rmCreateTypeDistanceConstraint("resource avoid resource short", "resource", 5.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);
	   
	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
  int riverGrass = rmCreateTerrainMaxDistanceConstraint("stay near the water", "land", false, 6.0);

  // resource avoidance
	int avoidSilver=rmCreateTypeDistanceConstraint("avoid silver", "mine", 65.0);
  int avoidHuntable1=rmCreateTypeDistanceConstraint("avoid huntable1", huntable1, 60.0);
	int avoidHuntable2=rmCreateTypeDistanceConstraint("avoid huntable2", huntable2, 60.0);
  int avoidNuggetsShort=rmCreateTypeDistanceConstraint("vs nugget short", "AbstractNugget", 10.0);
  int avoidNugget=rmCreateTypeDistanceConstraint("nugget vs. nugget", "AbstractNugget", 40.0);
	int avoidNuggetsFar=rmCreateTypeDistanceConstraint("nugget vs. nugget far", "AbstractNugget", 70.0);
  int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 65.0);
  int avoidHerdable=rmCreateTypeDistanceConstraint("herdables avoid herdables", herdableType, 75.0);
  int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 55.0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Unit avoidance
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 90.0);
	int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other short", rmClassID("importantItem"), 8.0);

	// general avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);
  int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);
  
  // fish & whale constraints
  int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", fish1, 15.0);	
	int fishVsFish2ID=rmCreateTypeDistanceConstraint("fish v fish2", fish2, 15.0); 
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);			
  
  int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", whale1, 45.0);
	int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 20.0);
  int whaleEdgeConstraint=rmCreatePieConstraint("whale edge of map", 0.5, 0.5, 0, rmGetMapXSize()-20, 0, 0, 0);

  // flag constraints
  int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 18.0);
  int nuggetVsFlag = rmCreateTypeDistanceConstraint("nugget v flag", "HomeCityWaterSpawnFlag", 8.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 25.0);
	int flagEdgeConstraint=rmCreatePieConstraint("flag edge of map", 0.5, 0.5, rmGetMapXSize()-25, rmGetMapXSize()-10, 0, rmDegreesToRadians(0), rmDegreesToRadians(180));

// ************************** DEFINE OBJECTS ****************************
	
  int food1ID=rmCreateObjectDef("huntable1");
	rmAddObjectDefItem(food1ID, huntable1, rmRandInt(8,10), 6.0);
	rmSetObjectDefCreateHerd(food1ID, true);
	rmSetObjectDefMinDistance(food1ID, 0.0);
	rmSetObjectDefMaxDistance(food1ID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(food1ID, shortAvoidResource);
	rmAddObjectDefConstraint(food1ID, playerConstraint);
	rmAddObjectDefConstraint(food1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(food1ID, avoidHuntable1);
	rmAddObjectDefConstraint(food1ID, avoidHuntable2);
  rmAddObjectDefConstraint(food1ID, shortAvoidImportantItem);
  
  int food2ID=rmCreateObjectDef("huntable2");
	rmAddObjectDefItem(food2ID, huntable2, rmRandInt(2,3), 6.0);
	rmSetObjectDefCreateHerd(food2ID, true);
	rmSetObjectDefMinDistance(food2ID, 0.0);
	rmSetObjectDefMaxDistance(food2ID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(food2ID, shortAvoidResource);
	rmAddObjectDefConstraint(food2ID, playerConstraint);
	rmAddObjectDefConstraint(food2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(food2ID, avoidHuntable1);
	rmAddObjectDefConstraint(food2ID, avoidHuntable2);
	rmAddObjectDefConstraint(food2ID, shortAvoidImportantItem);
  
  int startFoodID=rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(startFoodID, huntable1, 6, 4.0);
	rmSetObjectDefMinDistance(startFoodID, 12.0);
	rmSetObjectDefMaxDistance(startFoodID, 18.0);
	rmSetObjectDefCreateHerd(startFoodID, false);
	rmAddObjectDefConstraint(startFoodID, avoidHuntable1);    
	rmAddObjectDefConstraint(startFoodID, avoidHuntable2);    
  
  int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 10, 7.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 16);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 20);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);

	int StartBerriesID=rmCreateObjectDef("starting berries");
	rmAddObjectDefItem(StartBerriesID, "berrybush", 4, 5.0);
	rmSetObjectDefMinDistance(StartBerriesID, 10);
	rmSetObjectDefMaxDistance(StartBerriesID, 15);
	rmAddObjectDefConstraint(StartBerriesID, avoidStartResource);
	rmAddObjectDefConstraint(StartBerriesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartBerriesID, shortPlayerConstraint);

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
  
  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 15.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 18.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  
  int playerSaloonID=rmCreateObjectDef("player saloon");
  rmAddObjectDefItem(playerSaloonID, "Saloon", 1, 0.0);
  rmSetObjectDefMinDistance(playerSaloonID, 12.0);
  rmSetObjectDefMaxDistance(playerSaloonID, 16.0);
	rmAddObjectDefConstraint(playerSaloonID, avoidAll);
	rmAddObjectDefConstraint(playerSaloonID, avoidImpassableLand);
  
  int playerFirepitID=rmCreateObjectDef("player firepit");
  rmAddObjectDefItem(playerFirepitID, "Firepit", 1, 0.0);
  rmSetObjectDefMinDistance(playerFirepitID, 12.0);
  rmSetObjectDefMaxDistance(playerFirepitID, 16.0);
	rmAddObjectDefConstraint(playerFirepitID, avoidAll);
	rmAddObjectDefConstraint(playerFirepitID, avoidImpassableLand);
  
  int playerMonID=rmCreateObjectDef("player monastery");
  rmAddObjectDefItem(playerMonID, "ypMonastery", 1, 0.0);
  rmSetObjectDefMinDistance(playerMonID, 12.0);
  rmSetObjectDefMaxDistance(playerMonID, 16.0);
	rmAddObjectDefConstraint(playerMonID, avoidAll);
	rmAddObjectDefConstraint(playerMonID, avoidImpassableLand);
   
	// -------------Done defining objects
  // Text
  rmSetStatusText("",0.10);
  
  // Make the island

	int mainIslandID=rmCreateArea("indochina");

  //~ if(cNumberNonGaiaPlayers > 4)
    	//~ rmSetAreaSize(mainIslandID, 0.6, 0.6);
      
  //~ else
  	rmSetAreaSize(mainIslandID, 0.5, 0.5);
  
	rmSetAreaCoherence(mainIslandID, 0.75);
	rmSetAreaBaseHeight(mainIslandID, 3.0);
  rmSetAreaLocation(mainIslandID, .5, .75);
	rmSetAreaSmoothDistance(mainIslandID, 20);
	rmSetAreaMix(mainIslandID, baseMix);
  rmAddAreaTerrainLayer(mainIslandID, "borneo\ground_sand1_borneo", 0, 4);
  rmAddAreaTerrainLayer(mainIslandID, "borneo\ground_sand2_borneo", 4, 6);
  rmAddAreaTerrainLayer(mainIslandID, "borneo\ground_sand3_borneo", 6, 9);
  rmAddAreaTerrainLayer(mainIslandID, "borneo\ground_grass4_borneo", 9, 12);
	rmSetAreaObeyWorldCircleConstraint(mainIslandID, false);
	rmSetAreaElevationType(mainIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(mainIslandID, 4.0);
	rmSetAreaElevationMinFrequency(mainIslandID, 0.09);
	rmSetAreaElevationOctaves(mainIslandID, 3);
	rmSetAreaElevationPersistence(mainIslandID, 0.2);
	rmSetAreaElevationNoiseBias(mainIslandID, 1);

  // Length of peninsula
  rmAddAreaInfluenceSegment(mainIslandID, 0.5, 1.0, 0.5, 0.3);
  rmAddAreaInfluenceSegment(mainIslandID, 0.4, 1.0, 0.4, 0.3);
  rmAddAreaInfluenceSegment(mainIslandID, 0.3, 1.0, 0.3, 0.35);
  rmAddAreaInfluenceSegment(mainIslandID, 0.6, 1.0, 0.6, 0.3);
  rmAddAreaInfluenceSegment(mainIslandID, 0.7, 1.0, 0.7, 0.35);
  
  // Point of peninsula
  rmAddAreaInfluenceSegment(mainIslandID, 0.0, 0.7, 0.5, 0.35);
  rmAddAreaInfluenceSegment(mainIslandID, 1.0, 0.7, 0.5, 0.35);
  
  // Back of island
  rmAddAreaInfluenceSegment(mainIslandID, 1.0, 0.85, 0.0, 0.85);

	rmSetAreaWarnFailure(mainIslandID, false);
	rmBuildArea(mainIslandID);
  
   // Main river
  int mainRiver = rmRiverCreate(-1, "Borneo Water", 8, 8, 8, 11);

  rmRiverAddWaypoint(mainRiver, 0.5, 1.0);
  rmRiverAddWaypoint(mainRiver, 0.5, .6);
  rmRiverAddWaypoint(mainRiver, 0.5, .2);

  rmRiverSetShallowRadius(mainRiver, 9+cNumberNonGaiaPlayers);
  rmRiverAddShallow(mainRiver, 0.2);
  rmRiverAddShallow(mainRiver, 0.5);
  
  rmRiverBuild(mainRiver);

  // Invisible island for natives
	int westIslandID=rmCreateArea("invisible west island");
	rmSetAreaSize(westIslandID, 0.75, 0.75);
	rmSetAreaCoherence(westIslandID, 1.0);
  rmSetAreaLocation(westIslandID, .3, .7);
  rmAddAreaConstraint(westIslandID, avoidImpassableLand);
	rmSetAreaWarnFailure(westIslandID, false);
	rmBuildArea(westIslandID);
  
  int eastIslandID=rmCreateArea("invisible east island");
	rmSetAreaSize(eastIslandID, 0.75, 0.75);
	rmSetAreaCoherence(eastIslandID, 1.0);
  rmSetAreaLocation(eastIslandID, .7, .7);
  rmAddAreaConstraint(eastIslandID, avoidImpassableLand);
	rmSetAreaWarnFailure(eastIslandID, false);
	rmBuildArea(eastIslandID);
  
  rmSetOceanReveal(true);
  
  // Paint some grass near the river
  //~ int grassPatch=rmCreateArea("grassy area near river");
  //~ rmSetAreaSize(grassPatch, .15, .15);
  //~ rmSetAreaSize(grassPatch, .75, .75);
  //~ rmSetAreaLocation(grassPatch, 0.5, 1.0);
  //~ rmSetAreaWarnFailure(grassPatch, false);
  //~ rmSetAreaSmoothDistance(grassPatch, 10);
  //~ rmSetAreaCoherence(grassPatch, .6);
  //~ rmSetAreaMix(grassPatch, "deccan_grass_b");
  //~ rmAddAreaInfluenceSegment(grassPatch, 0.5, 1.0, 0.5, 0.25);
  //~ rmAddAreaConstraint(grassPatch, riverGrass);
  //~ rmAddAreaConstraint(grassPatch, shortAvoidImpassableLand);
  //~ rmBuildArea(grassPatch);
  
  // Text
  rmSetStatusText("",0.15);
  
  // Players
    
  float teamStartLoc = rmRandFloat(0, 1);
  
  if (weird == false) {
    
    if (cNumberNonGaiaPlayers == 2) {
      if (teamStartLoc > 0.5) {
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.2, 0.65, 0.21, 0.65, 0.1, 0);
          
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.8, 0.65, 0.81, 0.65, 0.1, 0);                
      }
      else {
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.2, 0.65, 0.21, 0.65, 0.1, 0);
          
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.8, 0.65, 0.81, 0.65, 0.1, 0);                   
      }
    } 
    else {
      if (teamStartLoc > 0.5) {
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.2, 0.7, 0.275, 0.45, 0.1, 0);

        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.8, 0.7, 0.725, 0.45, 0.1, 0);  
      }
      else {
        rmSetPlacementTeam(1);
        rmPlacePlayersLine(0.2, 0.7, 0.275, 0.45, 0.1, 0);
          
        rmSetPlacementTeam(0);
        rmPlacePlayersLine(0.8, 0.7, 0.725, 0.45, 0.1, 0);  
      }     
    }
  }
  
  // ffa
  else {
    rmPlacePlayer(1, .2, .8);
    rmPlacePlayer(2, .8, .8);
    float randThreeLoc = rmRandInt(0,1);
    float threeLoc = 0.0;
    
    if(cNumberNonGaiaPlayers == 3 && randThreeLoc == 0)
      threeLoc = 0.2;
    
    if(cNumberNonGaiaPlayers == 3 || cNumberNonGaiaPlayers == 5 || cNumberNonGaiaPlayers == 7) {
      rmPlacePlayer(3, .4+threeLoc, .3);
      
      if(cNumberNonGaiaPlayers == 5) {
        rmPlacePlayer(4, .3, .55);
        rmPlacePlayer(5, .6, .5);
      }
      
      else if (cNumberNonGaiaPlayers == 7){
        rmPlacePlayer(4, .335, .525);
        rmPlacePlayer(5, .66, .4);
        rmPlacePlayer(6, .265, .675);
        rmPlacePlayer(7, .73, .6);
      }
    }
    
    else {
      
      if(cNumberNonGaiaPlayers == 4) {
        rmPlacePlayer(3, .4, .3);
        rmPlacePlayer(4, .6, .3);
      }
      
      else if (cNumberNonGaiaPlayers == 6) {
        rmPlacePlayer(3, .4, .3);
        rmPlacePlayer(4, .6, .3);
        rmPlacePlayer(5, .3, .55);
        rmPlacePlayer(6, .7, .55);
      }
      
      else if(cNumberNonGaiaPlayers == 8){
        rmPlacePlayer(3, .4, .3);
        rmPlacePlayer(4, .6, .3);
        rmPlacePlayer(5, .265, .625);
        rmPlacePlayer(6, .675, .45);
        rmPlacePlayer(7, .33, .45);
        rmPlacePlayer(8, .73, .625);
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
  
  // always at least two native villages of each type
  if (subCiv0 == rmGetCivID(nativeCiv1)) {  
    int nativeVillage1Type = rmRandInt(1,5);
    int nativeVillage1ID = rmCreateGrouping("native village 1", "native sufi mosque borneo "+nativeVillage1Type);
    rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage1ID, 10.0);
    rmAddGroupingToClass(nativeVillage1ID, rmClassID("importantItem"));
    rmAddGroupingConstraint(nativeVillage1ID, avoidImportantItem);
    rmAddGroupingConstraint(nativeVillage1ID, playerConstraintNative);
    rmAddGroupingConstraint(nativeVillage1ID, longAvoidImpassableLand);
    rmPlaceGroupingInArea(nativeVillage1ID, 0, westIslandID, 1);	
  }	

  if (subCiv1 == rmGetCivID(nativeCiv2)) {  
    int nativeVillage2Type = rmRandInt(1,5);
    int nativeVillage2ID = rmCreateGrouping("native village 2", "native jesuit mission borneo 0"+nativeVillage2Type);
    rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage2ID, 10.0);
    rmAddGroupingToClass(nativeVillage2ID, rmClassID("importantItem"));
    rmAddGroupingConstraint(nativeVillage2ID, avoidImportantItem);
    rmAddGroupingConstraint(nativeVillage2ID, playerConstraintNative);
    rmAddGroupingConstraint(nativeVillage2ID, longAvoidImpassableLand);
    rmPlaceGroupingInArea(nativeVillage2ID, 0, eastIslandID, 1);	
  }  

  if (subCiv0 == rmGetCivID(nativeCiv1)) {  
    nativeVillage1Type = rmRandInt(1,5);
    nativeVillage1ID = rmCreateGrouping("native village 1a", "native sufi mosque borneo "+nativeVillage1Type);
    rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage1ID, 10.0);
    rmAddGroupingToClass(nativeVillage1ID, rmClassID("importantItem"));
    rmAddGroupingConstraint(nativeVillage1ID, avoidImportantItem);
    rmAddGroupingConstraint(nativeVillage1ID, playerConstraintNative);
    rmAddGroupingConstraint(nativeVillage1ID, longAvoidImpassableLand);
    rmPlaceGroupingInArea(nativeVillage1ID, 0, eastIslandID, 1);	
  }	

  if (subCiv1 == rmGetCivID(nativeCiv2)) {  
    nativeVillage2Type = rmRandInt(1,5);
    nativeVillage2ID = rmCreateGrouping("native village 2a", "native jesuit mission borneo 0"+nativeVillage2Type);
    rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage2ID, 10.0);
    rmAddGroupingToClass(nativeVillage2ID, rmClassID("importantItem"));
    rmAddGroupingConstraint(nativeVillage2ID, avoidImportantItem);
    rmAddGroupingConstraint(nativeVillage2ID, playerConstraintNative);
    rmAddGroupingConstraint(nativeVillage2ID, longAvoidImpassableLand);
    rmPlaceGroupingInArea(nativeVillage2ID, 0, westIslandID, 1);	
  }  
  
  if(cNumberNonGaiaPlayers > 3) {

    if (subCiv0 == rmGetCivID(nativeCiv1)) {  
      nativeVillage1Type = rmRandInt(1,5);
      nativeVillage1ID = rmCreateGrouping("native village 1b", "native sufi mosque borneo "+nativeVillage1Type);
      rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage1ID, 10.0);
      rmAddGroupingToClass(nativeVillage1ID, rmClassID("importantItem"));
      rmAddGroupingConstraint(nativeVillage1ID, avoidImportantItem);
      rmAddGroupingConstraint(nativeVillage1ID, playerConstraintNative);
      rmAddGroupingConstraint(nativeVillage1ID, longAvoidImpassableLand);
      rmPlaceGroupingInArea(nativeVillage1ID, 0, eastIslandID, 1);	
    }	

    if (subCiv1 == rmGetCivID(nativeCiv2)) {  
      nativeVillage2Type = rmRandInt(1,5);
      nativeVillage2ID = rmCreateGrouping("native village 2b", "native jesuit mission borneo 0"+nativeVillage2Type);
      rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage2ID, 10.0);
      rmAddGroupingToClass(nativeVillage2ID, rmClassID("importantItem"));
      rmAddGroupingConstraint(nativeVillage2ID, avoidImportantItem);
      rmAddGroupingConstraint(nativeVillage2ID, playerConstraintNative);
      rmAddGroupingConstraint(nativeVillage2ID, longAvoidImpassableLand);
      rmPlaceGroupingInArea(nativeVillage2ID, 0, westIslandID, 1);	
    }  
  }
  
  if(cNumberNonGaiaPlayers > 5) {
    if (subCiv0 == rmGetCivID(nativeCiv1)) {  
      nativeVillage1Type = rmRandInt(1,5);
      nativeVillage1ID = rmCreateGrouping("native village 1c", "native sufi mosque borneo "+nativeVillage1Type);
      rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage1ID, 10.0);
      rmAddGroupingToClass(nativeVillage1ID, rmClassID("importantItem"));
      rmAddGroupingConstraint(nativeVillage1ID, avoidImportantItem);
      rmAddGroupingConstraint(nativeVillage1ID, playerConstraintNative);
      rmAddGroupingConstraint(nativeVillage1ID, longAvoidImpassableLand);
      rmPlaceGroupingInArea(nativeVillage1ID, 0, westIslandID, 1);	
    }	

    if (subCiv1 == rmGetCivID(nativeCiv2)) {  
      nativeVillage2Type = rmRandInt(1,5);
      nativeVillage2ID = rmCreateGrouping("native village 2c", "native jesuit mission borneo 0"+nativeVillage2Type);
      rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage2ID, 10.0);
      rmAddGroupingToClass(nativeVillage2ID, rmClassID("importantItem"));
      rmAddGroupingConstraint(nativeVillage2ID, avoidImportantItem);
      rmAddGroupingConstraint(nativeVillage2ID, playerConstraintNative);
      rmAddGroupingConstraint(nativeVillage2ID, longAvoidImpassableLand);
      rmPlaceGroupingInArea(nativeVillage2ID, 0, eastIslandID, 1);	
    }  
  }
    
  if(cNumberNonGaiaPlayers > 7) {
    if (subCiv0 == rmGetCivID(nativeCiv1)) {  
      nativeVillage1Type = rmRandInt(1,5);
      nativeVillage1ID = rmCreateGrouping("native village 1d", "native sufi mosque borneo "+nativeVillage1Type);
      rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage1ID, 10.0);
      rmAddGroupingToClass(nativeVillage1ID, rmClassID("importantItem"));
      rmAddGroupingConstraint(nativeVillage1ID, avoidImportantItem);
      rmAddGroupingConstraint(nativeVillage1ID, playerConstraintNative);
      rmAddGroupingConstraint(nativeVillage1ID, longAvoidImpassableLand);
      rmPlaceGroupingInArea(nativeVillage1ID, 0, eastIslandID, 1);	
    }	

    if (subCiv1 == rmGetCivID(nativeCiv2)) {  
      nativeVillage2Type = rmRandInt(1,5);
      nativeVillage2ID = rmCreateGrouping("native village 2d", "native jesuit mission borneo 0"+nativeVillage2Type);
      rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
      rmSetGroupingMaxDistance(nativeVillage2ID, 10.0);
      rmAddGroupingToClass(nativeVillage2ID, rmClassID("importantItem"));
      rmAddGroupingConstraint(nativeVillage2ID, avoidImportantItem);
      rmAddGroupingConstraint(nativeVillage2ID, playerConstraintNative);
      rmAddGroupingConstraint(nativeVillage2ID, longAvoidImpassableLand);
      rmPlaceGroupingInArea(nativeVillage2ID, 0, westIslandID, 1);	
    }  
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

    if (rmGetNomadStart() == false) {
      
      if (rmGetPlayerCiv(i) == rmGetCivID("Chinese") || rmGetPlayerCiv(i) == rmGetCivID("Japanese") || rmGetPlayerCiv(i) == rmGetCivID("Indians")) {
        rmPlaceObjectDefAtLoc(playerMonID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      }

			else if ( rmGetPlayerCiv(i) ==  rmGetCivID("XPIroquois") ||
						rmGetPlayerCiv(i) ==  rmGetCivID("XPSioux") ||
						rmGetPlayerCiv(i) ==  rmGetCivID("XPAztec"))
			{
				rmPlaceObjectDefAtLoc(playerFirepitID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
			}

			else
			{
				rmPlaceObjectDefAtLoc(playerSaloonID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
			}
		}
    
    //Japanese
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Food
		rmPlaceObjectDefAtLoc(StartBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(startFoodID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Place a nugget for the player
    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Place water spawn points for the players
    
    vector waterPoint = xsVectorSet(0, 0, 0);
    
    if(weird) {
      waterPoint = xsVectorSet(.5, .5, 0);
    }
    
    else if (rmGetPlayerTeam(i) == 0 && teamStartLoc < 0.5) {
      waterPoint = xsVectorSet(0, 0, 1.0);
    }
    
    else if(rmGetPlayerTeam(i) == 1 && teamStartLoc > 0.5) {
      waterPoint = xsVectorSet(0, 0, 1.0);
    }
      
		int waterSpawnPointID=rmCreateObjectDef("colony ship "+i);
		rmAddObjectDefItem(waterSpawnPointID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
    rmAddClosestPointConstraint(flagEdgeConstraint);
		vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(waterSpawnPointID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));

    rmClearClosestPointConstraints();
  }

	// Text
	rmSetStatusText("",0.45);
   
  // Berries
  int berriesID=rmCreateObjectDef("berries");
	rmAddObjectDefItem(berriesID, "berrybush", 7, 6.0);
	rmSetObjectDefMinDistance(berriesID, 0);
	rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.35));
	rmAddObjectDefConstraint(berriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(berriesID, longPlayerConstraint);
  rmAddObjectDefConstraint(berriesID, avoidBerries);
  rmAddObjectDefConstraint(berriesID, shortAvoidImportantItem);
  rmAddObjectDefConstraint(berriesID, shortAvoidResource);
  rmPlaceObjectDefPerPlayer(berriesID, false, 3);
  
  // Forests
	int numTries=10*cNumberNonGaiaPlayers; 
	int failCount=0;
	for (i=0; <numTries)	{   
    int forestID=rmCreateArea("foresta"+i);
    rmAddAreaToClass(forestID, rmClassID("classForest"));
    rmSetAreaWarnFailure(forestID, false);
    rmSetAreaSize(forestID, rmAreaTilesToFraction(175), rmAreaTilesToFraction(250));
    rmSetAreaForestType(forestID, forestType);
    rmSetAreaForestDensity(forestID, 0.6);
    rmSetAreaForestClumpiness(forestID, 0.5);
    rmSetAreaForestUnderbrush(forestID, 0.2);
    rmSetAreaMinBlobs(forestID, 1);
    rmSetAreaMaxBlobs(forestID, 2);	
    rmSetAreaMinBlobDistance(forestID, 6.0);
    rmSetAreaMaxBlobDistance(forestID, 10.0);
    rmSetAreaCoherence(forestID, 0.4);
    rmSetAreaSmoothDistance(forestID, 10);
    rmAddAreaConstraint(forestID, playerConstraint);  
    rmAddAreaConstraint(forestID, shortAvoidResource);
    rmAddAreaConstraint(forestID, forestConstraint);
    rmAddAreaConstraint(forestID, shortAvoidImportantItem);
    rmAddAreaConstraint(forestID, longAvoidImpassableLand);
    
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
    float yLoc = 0.075;
    float walk = 0.025;
    
    ypKingsHillLandfill(xLoc, yLoc, .0075, 2.0, "borneo_sand_a", 0);
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
  
  // Silver

	int silverID = -1;
  int silverCount = 4;
  
	rmEchoInfo("silver count = "+silverCount);
   
  // silver mines over the entirety of the peninsula
  silverID = rmCreateObjectDef("closer silver mines"+i);
  rmAddObjectDefItem(silverID, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(silverID, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(1.0));
  rmAddObjectDefConstraint(silverID, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID, avoidSilver);
  rmAddObjectDefConstraint(silverID, longPlayerConstraint);
  rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
  rmPlaceObjectDefPerPlayer(silverID, false, silverCount);
  
  int nugget4= rmCreateObjectDef("nugget nuts"); 
  rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(4, 4);
  rmSetObjectDefMinDistance(nugget4, 0.0);
  rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.2));
  rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget4, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget4, shortAvoidResource);
  rmAddObjectDefConstraint(nugget4, avoidNuggetsFar);
  rmAddObjectDefConstraint(nugget4, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget4, circleConstraint);
  rmPlaceObjectDefPerPlayer(nugget4, false, 1);

  int nugget3= rmCreateObjectDef("nugget hard"); 
  rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(3, 3);
  rmSetObjectDefMinDistance(nugget3, 0.0);
  rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget3, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget3, shortAvoidResource);
  rmAddObjectDefConstraint(nugget3, avoidNuggetsFar);
  rmAddObjectDefConstraint(nugget3, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget3, circleConstraint);
  rmPlaceObjectDefPerPlayer(nugget3, false, 1);

  int nugget2= rmCreateObjectDef("nugget medium"); 
  rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(2, 2);
  rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget2, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget2, shortAvoidResource);
  rmAddObjectDefConstraint(nugget2, avoidNugget);
  rmAddObjectDefConstraint(nugget2, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget2, circleConstraint);
  rmSetObjectDefMinDistance(nugget2, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
  rmPlaceObjectDefPerPlayer(nugget2, false, 2);

  int nugget1= rmCreateObjectDef("nugget easy"); 
  rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(1, 1);
  rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget1, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget1, shortAvoidResource);
  rmAddObjectDefConstraint(nugget1, avoidNugget);
  rmAddObjectDefConstraint(nugget1, playerConstraint);
  rmAddObjectDefConstraint(nugget1, circleConstraint);
  rmSetObjectDefMinDistance(nugget1, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(nugget1, rmXFractionToMeters(0.5));
  rmPlaceObjectDefPerPlayer(nugget1, false, 3);
	
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
  rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.15, 6*cNumberNonGaiaPlayers);
    
  int fish2ID=rmCreateObjectDef("fish 2");
  rmAddObjectDefItem(fish2ID, fish2, 1, 0.0);
  rmSetObjectDefMinDistance(fish2ID, 0.0);
  rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(fish2ID, fishVsFish2ID);
  rmAddObjectDefConstraint(fish2ID, fishLand);
  rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.15, 6*cNumberNonGaiaPlayers);
  
  // extra fish for under 5 players
  if (cNumberNonGaiaPlayers < 5) {
    int fish3ID=rmCreateObjectDef("fish 3");
    rmAddObjectDefItem(fish3ID, fish1, 1, 0.0);
    rmSetObjectDefMinDistance(fish3ID, 0.0);
    rmSetObjectDefMaxDistance(fish3ID, rmXFractionToMeters(0.5));
    rmAddObjectDefConstraint(fish3ID, fishVsFishID);
    rmAddObjectDefConstraint(fish3ID, fishLand);
    rmPlaceObjectDefAtLoc(fish3ID, 0, 0.5, 0.1, 5*cNumberNonGaiaPlayers);
  }  
    
  int whaleID=rmCreateObjectDef("whale");
  rmAddObjectDefItem(whaleID, whale1, 1, 0.0);
  rmSetObjectDefMinDistance(whaleID, 0.0);
  rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);  
  rmAddObjectDefConstraint(whaleID, whaleEdgeConstraint);
  rmAddObjectDefConstraint(whaleID, whaleLand);
  rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
  
  // Water nuggets
  
  int nuggetW= rmCreateObjectDef("nugget water"); 
  rmAddObjectDefItem(nuggetW, "ypNuggetBoat", 1, 0.0);
  rmSetNuggetDifficulty(5, 5);
  rmSetObjectDefMinDistance(nuggetW, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(nuggetW, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nuggetW, avoidLand);
  rmAddObjectDefConstraint(nuggetW, avoidNuggetWater);
  rmAddObjectDefConstraint(nuggetW, nuggetVsFlag);
  rmPlaceObjectDefAtLoc(nuggetW, 0, 0.5, 0.1, cNumberNonGaiaPlayers*3);
    
	// Text
	rmSetStatusText("",0.99);
   
}  
