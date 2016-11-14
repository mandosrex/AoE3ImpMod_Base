// RM script of Sahara
// For K&B mod
// By AOE_Fan
// TAD-compatible version!

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // Make the loading bar move
   rmSetStatusText("",0.01);


   // Chooses the 3 natives - Sudanese or Berbers randomly

   int nativeInt1 = rmRandInt(1,2);
   int nativeInt2 = rmRandInt(1,2);
   int nativeInt3 = rmRandInt(1,2);

   // Native 1
   if (nativeInt1 == 1)
      rmSetSubCiv(0, "Aztecs");
   else
      rmSetSubCiv(0, "Aztecs");

   // Native 2
   if (nativeInt2 == 1) 
      rmSetSubCiv(1, "Sufi");
   else
      rmSetSubCiv(1, "Sufi");

   // Native 3
   if (nativeInt3 == 1) 
      rmSetSubCiv(2, "Aztecs");
   else
      rmSetSubCiv(2, "Aztecs");


   // Picks the map size
   int playerTiles = 12000;
   if (cNumberNonGaiaPlayers > 4)
      playerTiles = 11000;
   if (cNumberNonGaiaPlayers > 6)
      playerTiles = 9000;


   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);


   // Chooses if 3rd native starts from north or south
   int native3Place = rmRandInt(1,2);


   // Set map the map smoothness
   rmSetMapElevationHeightBlend(1);


   // Chooses the side where teams start in team games
   int teamSide = rmRandInt(1,4);


   // Picks a default water height
   rmSetSeaLevel(0.0);


   // Pick lighting
   rmSetLightingSet("3x01a_newengland");


   // Picks default terrain and map type
   rmSetMapElevationParameters(cElevTurbulence, 0.08, 4, 0.5, 12.0);
   rmTerrainInitialize("borneo\shoreline1_borneo", 1.0);
   rmSetMapType("mongolia");
   rmSetMapType("grass");
   rmSetMapType("land");


   chooseMercs();


   // Corner constraint
   rmSetWorldCircleConstraint(true);

   // Define classes, these are used for constraints
   int classPlayer=rmDefineClass("player");
   int classAnimals=rmDefineClass("animals");
   int classMines=rmDefineClass("mines");
   int classRocks=rmDefineClass("rocks");
   int classForest=rmDefineClass("forest");
   rmDefineClass("startingUnit");
   rmDefineClass("nuggets");
   rmDefineClass("natives");
   rmDefineClass("classPatch");


   // Define constraints - used for things to avoid certain things
   
   // Map edge and centre constraints
   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // 1/4 slice of map constraints
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(20), rmDegreesToRadians(40));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(80), rmDegreesToRadians(150));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(200), rmDegreesToRadians(220));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(260), rmDegreesToRadians(330));

   // All player things avoidance
   int veryLongPlayerConstraint=rmCreateClassDistanceConstraint("nuggets stay away from players very long", classPlayer, 70.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("nuggets stay away from players long", classPlayer, 55.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 35.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("nuggets stay away from players medium", classPlayer, 40.0);
   int shortPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players short", classPlayer, 20.0);
   int shortestPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players shortest", classPlayer, 18.0);
   int shortAvoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units short", rmClassID("startingUnit"), 12.0);
   int shortyPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players shortest", classPlayer, 16.0);

   // Resource avoidance
   int avoidMines=rmCreateClassDistanceConstraint("avoid mines", classMines, 65.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);
   int animalConstraint=rmCreateClassDistanceConstraint("avoid all animals", classAnimals, 40.0);
   int shortAnimalConstraint=rmCreateClassDistanceConstraint("short avoid all animals", classAnimals, 5.0);
   int avoidRocks=rmCreateClassDistanceConstraint("rocks avoid rocks", classRocks, 100.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);

   // Nugget avoidance
   int avoidNuggets=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 60.0);

   // Native avoidance
   int avoidNatives=rmCreateClassDistanceConstraint("things avoids natives", rmClassID("natives"), 10.0);
   int nativesAvoidNatives=rmCreateClassDistanceConstraint("natives avoids natives", rmClassID("natives"), 100.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int avoidPatch=rmCreateClassDistanceConstraint("patches avoid patches", rmClassID("classPatch"), 2.0);


   // Text
   rmSetStatusText("",0.10);


   // Place players - in team and FFA games

   // Player placement if FFA (Free For All) - place players in circle
   if(cNumberTeams > 2)
   {
      rmSetTeamSpacingModifier(0.7);
      rmPlacePlayersCircular(0.36, 0.36, 0.0);
   }

   // Player placement if teams - place teams in circle to apart from each other
   if(cNumberTeams == 2)
   {
      rmSetPlacementTeam(0);
      if (teamSide == 1)
            rmSetPlacementSection(0.00, 0.25);
      else if (teamSide == 2)
            rmSetPlacementSection(0.25, 0.50);
      else if (teamSide == 3)
            rmSetPlacementSection(0.50, 0.75);
      else if (teamSide == 4)
            rmSetPlacementSection(0.75, 1.00);
      rmSetTeamSpacingModifier(0.25);
      rmPlacePlayersCircular(0.36, 0.36, 0.0);

      rmSetPlacementTeam(1);
      if (teamSide == 1)
            rmSetPlacementSection(0.50, 0.75);
      else if (teamSide == 2)
            rmSetPlacementSection(0.75, 1.00);
      else if (teamSide == 3)
            rmSetPlacementSection(0.00, 0.25);
      else if (teamSide == 4)
            rmSetPlacementSection(0.25, 0.50);
      rmSetTeamSpacingModifier(0.25);
      rmPlacePlayersCircular(0.36, 0.36, 0.0);
   }


   // Text
   rmSetStatusText("",0.20);


   // Define and place players' area, green terrain

   float playerFraction=rmAreaTilesToFraction(1100);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaTerrainType(id, "borneo\ground_grass5_borneo");
      rmAddAreaTerrainLayer(id, "borneo\ground_sand3_borneo", 8, 12);
      rmAddAreaTerrainLayer(id, "borneo\ground_sand2_borneo", 6, 8);
      rmAddAreaTerrainLayer(id, "borneo\ground_sand1_borneo", 0, 6);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmSetAreaBaseHeight(id, 1);
      rmSetAreaCoherence(id, 1.0);
      rmAddAreaConstraint(id, playerConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }


   // Build the areas.
   rmBuildAllAreas();


   // Text
   rmSetStatusText("",0.30);


   // Define and place players' oasis

   for(i=1; <cNumberPlayers) 
   {
      int oasisPlayerID=rmCreateArea("Player"+i+"oasis player", rmAreaID("Player"+i));
      rmSetAreaSize(oasisPlayerID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
      rmSetAreaWaterType(oasisPlayerID, "texas pond");
      rmSetAreaBaseHeight(oasisPlayerID, 1);
      rmSetAreaHeightBlend(oasisPlayerID, 3.0);
      rmSetAreaMinBlobs(oasisPlayerID, 1);
      rmSetAreaMaxBlobs(oasisPlayerID, 2);
      rmSetAreaMinBlobDistance(oasisPlayerID, 10);
      rmSetAreaMaxBlobDistance(oasisPlayerID, 14);
      rmAddAreaConstraint(oasisPlayerID, avoidAll);
      rmSetAreaCoherence(oasisPlayerID, 0.8);
      rmBuildArea(oasisPlayerID);
   }


   // Define and place "things" to players' oasis

   for(i=1; <cNumberPlayers) 
   {
      // Define and place trees to players' oasis
      int oasisTreesPlayerID=rmCreateObjectDef("oasis trees player"+i);
      rmAddObjectDefItem(oasisTreesPlayerID, "TreeCaribbean", 4, 6.0);
      rmSetObjectDefMinDistance(oasisTreesPlayerID, 0);
      rmSetObjectDefMaxDistance(oasisTreesPlayerID, 6);
      rmAddObjectDefConstraint(oasisTreesPlayerID, avoidAll);
      int numTries=30*cNumberNonGaiaPlayers;
      for (j=0; <numTries) 
            rmPlaceObjectDefInArea(oasisTreesPlayerID, 0, rmAreaID("Player"+i+"oasis player"));

      // Define and place addax to players' oasis
      int addaxHerdPlayerID=rmCreateObjectDef("addax herd player"+i);
      rmAddObjectDefItem(addaxHerdPlayerID, "rhea", 1, 5.0);
      rmSetObjectDefMinDistance(addaxHerdPlayerID, 2);
      rmSetObjectDefMaxDistance(addaxHerdPlayerID, 6);
      rmAddObjectDefToClass(addaxHerdPlayerID, classAnimals);
      rmAddObjectDefConstraint(addaxHerdPlayerID, shortAnimalConstraint);
      numTries=6;
      for (j=0; <numTries)
            rmPlaceObjectDefInArea(addaxHerdPlayerID, 0, rmAreaID("Player"+i+"oasis player"));
   }


   // Text
   rmSetStatusText("",0.40);


   // Define starting objects and resources

   int startingTCID=rmCreateObjectDef("startingTC");
   if (rmGetNomadStart())
      rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 5.0);
   else
      rmAddObjectDefItem(startingTCID, "townCenter", 1, 5.0);
   rmSetObjectDefMinDistance(startingTCID, 1.0);
   rmSetObjectDefMaxDistance(startingTCID, 14.0);
   rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefToClass(startingTCID, classPlayer);

   int startingUnits=rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 6.0);
   rmSetObjectDefMaxDistance(startingUnits, 16.0);
   rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
   rmAddObjectDefConstraint(startingUnits, avoidAll);

   int startBerryID=rmCreateObjectDef("starting berries");
   rmAddObjectDefItem(startBerryID, "Berrybush", 3, 5.0);
   rmSetObjectDefMinDistance(startBerryID, 13);
   rmSetObjectDefMaxDistance(startBerryID, 16);
   rmAddObjectDefConstraint(startBerryID, avoidStartResource);
   rmAddObjectDefConstraint(startBerryID, avoidImpassableLand);
   rmAddObjectDefConstraint(startBerryID, shortAvoidStartingUnits);
   rmAddObjectDefConstraint(startBerryID, avoidAll);

   int startCopperID=rmCreateObjectDef("player copper");
   rmAddObjectDefItem(startCopperID, "MineCopper", 1, 5.0);
   rmSetObjectDefMinDistance(startCopperID, 14);
   rmSetObjectDefMaxDistance(startCopperID, 30);
   rmAddObjectDefConstraint(startCopperID, avoidStartResource);
   rmAddObjectDefConstraint(startCopperID, avoidImpassableLand);
   rmAddObjectDefConstraint(startCopperID, shortAvoidStartingUnits);
   rmAddObjectDefConstraint(startCopperID, avoidAll);

   // Place starting objects

   for(i=1; <cNumberPlayers)
   {					
      // Place starting objects and resources
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	  if(ypIsAsian(i) && rmGetNomadStart() == false)
         rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }


   // Text
   rmSetStatusText("",0.50);


   // Place starting resources, so they avoid oasis

   for(i=1; <cNumberPlayers)
   {					
      rmPlaceObjectDefAtLoc(startCopperID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startBerryID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }


   // Text
   rmSetStatusText("",0.60);

   
   // Define and place larger oasis and its "things" to middle

   // Define and place green terrain
   int oasisTerrainMiddleID=rmCreateArea("oasis terrain middle");
   rmSetAreaSize(oasisTerrainMiddleID, 0.11, 0.11);
   rmSetAreaBaseHeight(oasisTerrainMiddleID, 1.0);
   rmSetAreaLocation(oasisTerrainMiddleID, 0.5, 0.5);
   rmSetAreaHeightBlend(oasisTerrainMiddleID, 3.0);
   rmSetAreaTerrainType(oasisTerrainMiddleID, "borneo\ground_grass5_borneo");
   rmAddAreaTerrainLayer(oasisTerrainMiddleID, "borneo\ground_sand3_borneo", 4, 6);
   rmAddAreaTerrainLayer(oasisTerrainMiddleID, "borneo\ground_sand2_borneo", 2, 4);
   rmAddAreaTerrainLayer(oasisTerrainMiddleID, "borneo\ground_sand1_borneo", 0, 2);
   rmSetAreaCoherence(oasisTerrainMiddleID, 0.9);
   rmBuildArea(oasisTerrainMiddleID);

   // Define and place the middle oasis itself
   int oasisMiddleID=rmCreateArea("oasis middle");
   rmSetAreaSize(oasisMiddleID, 0.05, 0.05);
   rmSetAreaWaterType(oasisMiddleID, "texas pond");
   rmSetAreaBaseHeight(oasisMiddleID, 1.0);
   rmSetAreaLocation(oasisMiddleID, 0.5, 0.5);
   rmSetAreaHeightBlend(oasisMiddleID, 3.0);
   rmSetAreaCoherence(oasisMiddleID, 0.8);
   rmAddAreaConstraint(oasisMiddleID, avoidAll);
   rmBuildArea(oasisMiddleID);

   // Define and place trees to middle oasis 
   int oasisTreesMiddleID=rmCreateObjectDef("oasis trees middle");
   rmAddObjectDefItem(oasisTreesMiddleID, "TreeCaribbean", 4, 8.0);
   rmSetObjectDefMinDistance(oasisTreesMiddleID, 1);
   rmSetObjectDefMaxDistance(oasisTreesMiddleID, 10);
   rmAddObjectDefConstraint(oasisTreesMiddleID, avoidAll);
   numTries=200;
   for (i=0; <numTries)
      rmPlaceObjectDefInArea(oasisTreesMiddleID, 0, rmAreaID("oasis middle"));

   // Define and place ostrich to middle oasis
   int ostrichHerdID=rmCreateObjectDef("ostrich herd");
   if (i < 8)
      rmAddObjectDefItem(ostrichHerdID, "ypWildElephant", rmRandInt(4,5), 5.0);
   else
      rmAddObjectDefItem(ostrichHerdID, "Zebra", rmRandInt(4,5), 5.0);
   rmSetObjectDefCreateHerd(ostrichHerdID, true);
   rmSetObjectDefMinDistance(ostrichHerdID, rmXFractionToMeters(0.04));
   rmSetObjectDefMaxDistance(ostrichHerdID, rmXFractionToMeters(0.17));
   rmAddObjectDefToClass(ostrichHerdID, classAnimals);
   rmAddObjectDefConstraint(ostrichHerdID, avoidAll);
   rmAddObjectDefConstraint(ostrichHerdID, animalConstraint);
   numTries=2*cNumberNonGaiaPlayers;
   for (i=0; <numTries)
      rmPlaceObjectDefAtLoc(ostrichHerdID, 0, 0.5, 0.5);

	int fishID=rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "FishSalmon", 1, 1);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishLand);
   	numTries=20;
   	for (i=0; <numTries)
      	rmPlaceObjectDefInArea(fishID, 0, rmAreaID("oasis middle"));

   // Text
   rmSetStatusText("",0.70);


   for (i=0; < 100)   
   {
      int grassPatch=rmCreateArea("grass patch "+i);
      rmSetAreaSize(grassPatch, rmAreaTilesToFraction(20), rmAreaTilesToFraction(40));
      rmSetAreaTerrainType(grassPatch, "borneo\ground_sand1_borneo");
      rmAddAreaToClass(grassPatch, rmClassID("classPatch"));
      rmSetAreaMinBlobs(grassPatch, 1);
      rmSetAreaMaxBlobs(grassPatch, 5);
      rmSetAreaMinBlobDistance(grassPatch, 10.0);
      rmSetAreaMaxBlobDistance(grassPatch, 40.0);
      rmSetAreaCoherence(grassPatch, 0.0);
      rmSetAreaSmoothDistance(grassPatch, 10);
      rmAddAreaConstraint(grassPatch, avoidImpassableLand);
      rmAddAreaConstraint(grassPatch, avoidPatch);
      rmAddAreaConstraint(grassPatch, shortestPlayerConstraint);
      rmBuildArea(grassPatch); 
   }


   // Place the 3 natives, Sudanese or Berbers

   // Native 1
   int nativeVillageID = -1;
   int nativeVillageType = rmRandInt(1,5);
   if (nativeInt1 == 1)
      nativeVillageID = rmCreateGrouping("Aztec village"+i, "native Aztec village "+nativeVillageType);
   else
      nativeVillageID = rmCreateGrouping("Aztec village"+i, "native Aztec village "+nativeVillageType);
   rmSetGroupingMinDistance(nativeVillageID, rmXFractionToMeters(0.15));
   rmSetGroupingMaxDistance(nativeVillageID, rmXFractionToMeters(0.22));
   rmAddGroupingConstraint(nativeVillageID, playerConstraint);
   if(cNumberTeams > 2)
      rmAddGroupingConstraint(nativeVillageID, nativesAvoidNatives);
   if(cNumberTeams == 2)
      rmAddGroupingConstraint(nativeVillageID, Eastward);
   rmAddGroupingToClass(nativeVillageID, rmClassID("natives"));
   rmPlaceGroupingAtLoc(nativeVillageID, 0, 0.5, 0.5);

   // Native 2
   int nativeVillage2ID = -1;
   int nativeVillage2Type = rmRandInt(1,5);
   if (nativeInt2 == 1)
      nativeVillage2ID = rmCreateGrouping("Sufi A", "native sufi mosque mongol "+nativeVillage2Type);
   else
      nativeVillage2ID = rmCreateGrouping("Sufi A", "native sufi mosque mongol "+nativeVillage2Type);
   rmSetGroupingMinDistance(nativeVillage2ID, rmXFractionToMeters(0.15));
   rmSetGroupingMaxDistance(nativeVillage2ID, rmXFractionToMeters(0.22));
   rmAddGroupingConstraint(nativeVillage2ID, playerConstraint);
   if(cNumberTeams > 2)
      rmAddGroupingConstraint(nativeVillage2ID, nativesAvoidNatives);
   if(cNumberTeams == 2)
      rmAddGroupingConstraint(nativeVillage2ID, Westward);
   rmAddGroupingToClass(nativeVillage2ID, rmClassID("natives"));
   rmPlaceGroupingAtLoc(nativeVillage2ID, 0, 0.5, 0.5);

   // Native 3
   int nativeVillage3ID = -1;
   int nativeVillage3Type = rmRandInt(1,5);
   if (nativeInt3 == 1)
      nativeVillage3ID = rmCreateGrouping("Aztec village"+i, "native Aztec village "+nativeVillage3Type);
   else
      nativeVillage3ID = rmCreateGrouping("Aztec village"+i, "native Aztec village "+nativeVillage3Type);
   rmSetGroupingMinDistance(nativeVillage3ID, rmXFractionToMeters(0.15));
   rmSetGroupingMaxDistance(nativeVillage3ID, rmXFractionToMeters(0.22));
   rmAddGroupingConstraint(nativeVillage3ID, playerConstraint);
   if(cNumberTeams > 2)
      rmAddGroupingConstraint(nativeVillage3ID, nativesAvoidNatives);
   if(cNumberTeams == 2 && native3Place == 1)
      rmAddGroupingConstraint(nativeVillage3ID, Northward);
   else if(cNumberTeams == 2 && native3Place == 2)
      rmAddGroupingConstraint(nativeVillage3ID, Southward);
   rmAddGroupingToClass(nativeVillage3ID, rmClassID("natives"));
   rmPlaceGroupingAtLoc(nativeVillage3ID, 0, 0.5, 0.5);


   // Text
   rmSetStatusText("",0.80);


   // Define and place mines - gold and copper

   // Gold mines

   int goldCount = 3*cNumberNonGaiaPlayers;

   for(i=0; < goldCount)
   {
      int goldID=rmCreateObjectDef("gold mine"+i);
      rmAddObjectDefItem(goldID, "minegold", 1, 0.0);
      rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.10));
      rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.47));
      rmAddObjectDefToClass(goldID, classMines);
      rmAddObjectDefConstraint(goldID, playerConstraint);
      rmAddObjectDefConstraint(goldID, avoidMines);
      rmAddObjectDefConstraint(goldID, avoidNatives);
      rmPlaceObjectDefAtLoc(goldID, 0, 0.5, 0.5);
   }

   // Copper mines

   int copperCount = 1*cNumberNonGaiaPlayers;

   for(i=0; < copperCount)
   {
      int copperID=rmCreateObjectDef("copper mine"+i);
      rmAddObjectDefItem(copperID, "MineCopper", 1, 0.0);
      rmSetObjectDefMinDistance(copperID, rmXFractionToMeters(0.10));
      rmSetObjectDefMaxDistance(copperID, rmXFractionToMeters(0.47));
      rmAddObjectDefToClass(copperID, classMines);
      rmAddObjectDefConstraint(copperID, playerConstraint);
      rmAddObjectDefConstraint(copperID, avoidMines);
      rmAddObjectDefConstraint(copperID, avoidNatives);
      rmPlaceObjectDefAtLoc(copperID, 0, 0.5, 0.5);
   }


   // Text
   rmSetStatusText("",0.90);


   // Define and place treasures

   // Easy treasures
   int nugget1=rmCreateObjectDef("nugget easy"); 
   rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(1, 1);
   rmAddObjectDefToClass(nugget1, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget1, 20.0);
   rmSetObjectDefMaxDistance(nugget1, 30.0);
   rmAddObjectDefConstraint(nugget1, shortPlayerConstraint);
   rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget1, avoidNuggets);
   rmAddObjectDefConstraint(nugget1, avoidNatives);
   rmPlaceObjectDefPerPlayer(nugget1, false, 1);

   // Medium treasures
   int nugget2=rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget2, 0.0);
   rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.47));
   rmAddObjectDefConstraint(nugget2, mediumPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidNuggets);
   rmAddObjectDefConstraint(nugget2, avoidNatives);
   rmPlaceObjectDefAtLoc(nugget2, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

   // Hard treasures
   int nugget3=rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget3, 0.0);
   rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.47));
   rmAddObjectDefConstraint(nugget3, longPlayerConstraint);
   rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidNuggets);
   rmAddObjectDefConstraint(nugget3, avoidNatives);
   rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

   // Very hard treasures
   int nugget4=rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(nugget4, 0.0);
   rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.47));
   rmAddObjectDefConstraint(nugget4, veryLongPlayerConstraint);
   rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidNuggets);
   rmAddObjectDefConstraint(nugget4, avoidNatives);
   if (cNumberNonGaiaPlayers <= 4)
      rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, 2);
   else if (cNumberNonGaiaPlayers >= 5)
      rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, 3);
   else if (cNumberNonGaiaPlayers >= 7)
      rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, 4);

	// Random trees 
	for (i=0; < 20*cNumberNonGaiaPlayers)
	{
		int randomtreeID = rmCreateObjectDef("random trees "+i);
		rmAddObjectDefItem(randomtreeID, "TreeSonora", 1, 1);
		rmSetObjectDefMinDistance(randomtreeID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidAll);
		rmAddObjectDefConstraint(randomtreeID, avoidImpassableLand);
		rmAddObjectDefConstraint(randomtreeID, shortAvoidStartingUnits);
		rmAddObjectDefConstraint(randomtreeID, avoidNatives);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.5, 0.5);
	}

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.4;
    float yLoc = 0.4;
    float walk = 0.03;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

   // Text
   rmSetStatusText("",1.0);
}  
