
// PJJ - modifying script for YPack update

include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
//********************************************************************************//
   rmSetStatusText("",0.01);
//********************************************************************************//

// Map Setup
   // Setting up how big the map is and that it is rectangular
   int playerTiles = 13250;
   int size = 1.4 * sqrt(cNumberNonGaiaPlayers * playerTiles);
   int longSide = 1.7 * size;
   
   rmSetMapSize(size,longSide);
   rmEchoInfo("Map size = "+size+"m x "+longSide+"m");
   rmSetWorldCircleConstraint(false);

   // Setting up variations (used here and in placement)
   // Resources that can vary
   int numberMinePasses = 1;

   int herdSizeHunting = rmRandInt(4,6);
   int herdSizeHerdable = rmRandInt(2,3);
   int numberBerryPatch = rmRandInt(5,7);
   int numberBerryPasses = 1;

   float numberGuanacoPasses = 1.0;
   float numberDeerPasses = 1.0;
   float numberNuggetEasyPasses = 1.0;
   float numberNuggetHardNutsPasses = 0.5;

 
//********************************************************************************//

   // Variation handler - terrain and Natives
   int whichVariation = rmRandInt(1,3);
   int whichNative = -1;

   // Blank strings for names determined in the if statement below
   string coastMixName = "";
   string inlandWestMixName = "";
   string inlandEastMixName = "";
   string andesMixName = "";

   string forestName = "";
   string cliffName = "";
   string nativeName = "";
   string oceanName = "";
   string treeName = "";

   // North Araucania variation stuff
   if(whichVariation == 1)
   {
      rmEchoInfo("Araucania North");
      rmSetMapType("araucania");
      rmSetSeaType("Araucania North Coast");
      rmSetSeaLevel(0);
      rmTerrainInitialize("water");
      rmEnableLocalWater(false);
      rmSetLightingSet("NthAraucaniaLight");

      cliffName = "Araucania North";
      forestName = "North Araucania Forest";
      treeName = "TreeAraucania";

      coastMixName = "araucania_north_dirt_a";
      inlandWestMixName = "araucania_north_grass_a";
      inlandEastMixName = "araucania_north_grass_b";
      andesMixName = "araucania_north_grass_c";
      
      whichNative = rmRandInt(1,2);
      if(whichNative == 1)
      {
         rmSetSubCiv(1, "Incas");
         nativeName = "native Inca village ";
      }
      else
      {
         rmSetSubCiv(1, "Mapuche");
         nativeName = "native Mapuche village ";
      }
      numberMinePasses = 2;
      numberGuanacoPasses = 1.5;
      numberDeerPasses = 1.5;
   }

   // Central Araucania variation stuff
   else if(whichVariation == 2)
   {
      rmEchoInfo("Araucania Central");
      rmSetMapType("araucania");
      rmSetSeaType("Araucania Central Coast");
      rmSetSeaLevel(0);
      rmTerrainInitialize("water");
      rmEnableLocalWater(false);
      rmSetLightingSet("Araucania Central");

      cliffName = "Araucania Central";
      forestName = "Araucania Forest";
      treeName = "TreeAraucania";

      coastMixName = "araucania_dirt_b";
      inlandWestMixName = "araucania_grass_c";
      inlandEastMixName = "araucania_grass_b";
      andesMixName = "araucania_grass_a";

      whichNative = rmRandInt(1,3);
      if(whichNative == 1)
      {
         rmSetSubCiv(1, "Incas");
         nativeName = "native Inca village ";
      }
      else
      {
         rmSetSubCiv(1, "Mapuche");
         nativeName = "native Mapuche village ";
      }

      numberBerryPasses = 2;
      numberBerryPatch = rmRandInt(5,7);
   }

   // South Araucania variation stuff (Nuggets)
   else if(whichVariation == 3)
   {
      rmEchoInfo("Araucania South");
      rmSetMapType("araucania");
      rmSetSeaType("Araucania Southern Coast");
      rmSetSeaLevel(0);
      rmTerrainInitialize("water");
      rmEnableLocalWater(false);
      rmSetLightingSet("SthAraucaniaLight");

      cliffName = "Araucania South";
      forestName = "Patagonia Snow Forest";
      treeName = "TreePatagoniaSnow";

      coastMixName = "araucania_snow_c";
      inlandWestMixName = "araucania_snow_c";
      inlandEastMixName = "araucania_snow_a";
      andesMixName = "araucania_snow_b";

      rmSetSubCiv(1, "Mapuche");
      nativeName = "native Mapuche village ";

      numberNuggetEasyPasses = 1.5;
      numberNuggetHardNutsPasses = 1.0;
   }

//********************************************************************************//

// Defining classes
int classStartingUnits = rmDefineClass("Starting Units");


//********************************************************************************//

// Constraints
   // Trade route
   int avoidTradeRouteClose = rmCreateTradeRouteDistanceConstraint("Avoid trade route close", 6.0);
   int avoidTradeRouteMedium = rmCreateTradeRouteDistanceConstraint("Avoid trade route medium", 10.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("Avoid trade route far", 20.0);
   int avoidTradeSocket = rmCreateTypeDistanceConstraint("Avoid trade socket", "sockettraderoute", 30.0);

   // Home City water flag
   int avoidFlags = rmCreateTypeDistanceConstraint("Flag avoids flags", "HomeCityWaterSpawnFlag", 10.0);
   int avoidEdgeFlag = rmCreatePieConstraint("Flags stay near edge of map", 0.5, 0.5, rmGetMapZSize()-20, rmGetMapXSize()-10, 0, 0, 0);

   // All
   int avoidAllClose = rmCreateTypeDistanceConstraint("Avoid everything a little", "all", 6.0);
   int avoidAllMedium = rmCreateTypeDistanceConstraint("Avoid everything more", "all", 10.0);
   int avoidAllFar = rmCreateTypeDistanceConstraint("Avoid everything a lot", "all", 20.0);
   
   // Impassable land and water
   // Avoid land
   int avoidImpassableLandClose = rmCreateTerrainDistanceConstraint("Avoid impassable land close", "Land", true, 4.0);
   int avoidImpassableLandMedium = rmCreateTerrainDistanceConstraint("Avoid impassable land medium", "Land", true, 10.0);
   int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("Avoid impassable land far", "Land", true, 20.0);
   int avoidImpassableLandSuperFar = rmCreateTerrainDistanceConstraint("Avoid impassable land super far", "Land", true, 40.0);
   // Avoid other
   int avoidImpassableClose = rmCreateTerrainDistanceConstraint("Avoid impassable close", "Land", false, 4.0);
   int avoidImpassableMedium = rmCreateTerrainDistanceConstraint("Avoid impassable medium", "Land", false, 10.0);
   int avoidImpassableFar = rmCreateTerrainDistanceConstraint("Avoid impassable far", "Land", false, 20.0);
   int avoidImpassableSuperFar = rmCreateTerrainDistanceConstraint("Avoid impassable super far", "Land", false, 40.0);

   // Avoid nuggets
   int avoidNugget = rmCreateTypeDistanceConstraint("nugget vs nugget", "abstractnugget", 20.0);
   int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
   int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);
   
   // Avoid starting units
   int avoidStartingUnits = rmCreateClassDistanceConstraint("Avoid starting units", classStartingUnits, 40.0);
  int avoidStartingUnitsShort = rmCreateClassDistanceConstraint("Avoid starting units short", classStartingUnits, 6.0);

   // Box constraints
   int notInTheMountains = rmCreateBoxConstraint("Don't place in the mountains", 0.0, 0.03, 0.93, 0.97, 0);
   int edgeConstraint = rmCreateBoxConstraint("Edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);

   int northTeam = rmCreateBoxConstraint("North Team", 0.0, 0.55, 0.93, 0.97, 0);
   int noMansLand = rmCreateBoxConstraint("No Man's Land", 0.0, 0.35, 0.93, 0.65, 0);
   int southTeam = rmCreateBoxConstraint("South Team", 0.0, 0.03, 0.93, 0.45, 0);

   int northDeer = rmCreateBoxConstraint("North deer box", 0.3, 0.6, 0.55, 0.97, 0);
   int northGuanaco = rmCreateBoxConstraint("North guanaco box", 0.55, 0.6, 0.9, 0.97, 0);

   int southDeer = rmCreateBoxConstraint("South deer box", 0.3, 0.03, 0.55, 0.4, 0);
   int southGuanaco = rmCreateBoxConstraint("South guanaco box", 0.5, 0.03, 0.9, 0.4, 0);

//********************************************************************************//

// Areas
   // Big continent
   int bigContinent = rmCreateArea("Big continent");
   int bigContinentCenter = rmRandInt(1,3);

   if(bigContinentCenter == 1)
   {
      rmAddAreaInfluenceSegment(bigContinent, 0.75, 0.0, 0.75, 1.0);
      rmSetAreaLocation(bigContinent, 0.55, 0.5);
      rmSetAreaSize(bigContinent, 0.75, 0.75);
   }
   else if(bigContinentCenter == 2)
   {
      rmAddAreaInfluenceSegment(bigContinent, 0.75, 0.0, 0.75, 1.0);
      rmSetAreaLocation(bigContinent, 0.75, 0.5);
      rmSetAreaSize(bigContinent, 0.75, 0.75);
   }
   else if(bigContinentCenter == 3)
   {
      rmAddAreaInfluenceSegment(bigContinent, 0.9, 0.0, 0.9, 1.0);
      rmAddAreaInfluenceSegment(bigContinent, 0.65, 0.15, 0.7, 0.15);
      rmAddAreaInfluenceSegment(bigContinent, 0.65, 0.85, 0.7, 0.85);
      rmSetAreaLocation(bigContinent, 0.75, 0.5);
      rmSetAreaSize(bigContinent, 0.725, 0.725);
   }
   rmSetAreaBaseHeight(bigContinent, 1.0);
   rmSetAreaCoherence(bigContinent, 0.90);
   rmSetAreaMix(bigContinent, coastMixName);
   rmSetAreaEdgeFilling(bigContinent, 1.0);
   rmSetAreaSmoothDistance(bigContinent, 10.0);

   rmSetAreaElevationType(bigContinent, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinent, 2.0);
   rmSetAreaElevationMinFrequency(bigContinent, 0.09);
   rmSetAreaElevationOctaves(bigContinent, 1.0);
   rmSetAreaElevationPersistence(bigContinent, 0.2);
   rmSetAreaElevationNoiseBias(bigContinent, 1.0);

   rmSetAreaWarnFailure(bigContinent, false);
   rmBuildArea(bigContinent);

   // Mixes for inland West, inland East and Andes foot areas
   int inlandWestMix = rmCreateArea("Inland West textures");
   rmAddAreaInfluenceSegment(inlandWestMix, 0.55, 0.0, 0.55, 1.0);
   rmSetAreaLocation(inlandWestMix, 0.55, 0.5);
   rmSetAreaSize(inlandWestMix, 0.2, 0.2);
   rmSetAreaCoherence(inlandWestMix, 0.6);
   rmSetAreaMix(inlandWestMix, inlandWestMixName);

   int inlandEastMix = rmCreateArea("Inland East textures");
   rmAddAreaInfluenceSegment(inlandEastMix, 0.7, 0.0, 0.7, 1.0);
   rmSetAreaLocation(inlandEastMix, 0.7, 0.5);
   rmSetAreaSize(inlandEastMix, 0.2, 0.2);
   rmSetAreaCoherence(inlandEastMix, 0.6);
   rmSetAreaMix(inlandEastMix, inlandEastMixName);

   int andesMix = rmCreateArea("Textures at the base of the Andes");
   rmAddAreaInfluenceSegment(andesMix, 0.85, 0.0, 0.85, 1.0);
   rmSetAreaLocation(andesMix, 0.85, 0.5);
   rmSetAreaSize(andesMix, 0.2, 0.2);
   rmSetAreaCoherence(andesMix, 0.6);
   rmSetAreaMix(andesMix, andesMixName);

   // Andes cliffs
   int andesCliffs = rmCreateArea("The Andes Cliffs");
   rmAddAreaInfluenceSegment(andesCliffs, 1.0, 0.0, 1.0, 1.0);
   rmSetAreaLocation(andesCliffs, 0.97, 0.5);
   rmSetAreaSize(andesCliffs, 0.045, 0.045);
   rmSetAreaMix(andesCliffs, andesMixName);

   rmSetAreaCoherence(andesCliffs, 0.75);
   rmSetAreaEdgeFilling(andesCliffs, 1.0);
   rmSetAreaSmoothDistance(andesCliffs, 10.0);
   rmSetAreaHeightBlend(andesCliffs, 6.0);
   // Specific cliff stuff
   rmSetAreaCliffHeight(andesCliffs, 8.0, 2.0, 0.0);
   rmSetAreaCliffType(andesCliffs, cliffName);
   rmSetAreaCliffEdge(andesCliffs, 1.0, 1.0, 0.0, 1.0, 0);
   rmSetAreaCliffPainting(andesCliffs, true, true, true, 1.0, true);

   rmSetAreaWarnFailure(andesCliffs, false);
   rmBuildArea(andesCliffs);

// Placement, defining and placing
   // Define team placement
   int teamZeroCount = rmGetNumberPlayersOnTeam(0);
   int teamOneCount = rmGetNumberPlayersOnTeam(1);
   
   float teamPlacement = rmRandFloat(0, 1);

   if (cNumberTeams > 2) 
   { // Free-for-all
      rmPlacePlayersCircular(0.25, 0.25, 0.9);
   }
   else
   {
      if (teamZeroCount == teamOneCount) // Teams have an even number of players
      {
         if (teamPlacement > 0.50) // Places Team 0 in the south 50% of the time
         {
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.45, 0.15, 0.75, 0.25, 0.0, 0.0);
            
            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.45, 0.80, 0.75, 0.75, 0.0, 0.0);            
         }
         else // Places Team 0 in the north 50% of the time
         {
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.45, 0.80, 0.75, 0.75, 0.0, 0.0);

            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.45, 0.15, 0.75, 0.25, 0.0, 0.0);
         }
      }
      else // Teams have an uneven number of players
      {
         if (teamZeroCount > teamOneCount) 
         { // Team 0 is bigger
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.30, 0.10, 0.80, 0.40, 10.0, 0.25);

            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.30, 0.90, 0.75, 0.75, 10.0, 0.25);
         }
         else // Team 1 is bigger
         {
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.30, 0.90, 0.75, 0.75, 10.0, 0.25);

            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.30, 0.10, 0.80, 0.40, 10.0, 0.25); 
         }
      }
   }
   rmBuildAllAreas();

//********************************************************************************//

   // Trade route
   int tradeRoute = rmCreateTradeRoute();
   int socket = rmCreateObjectDef("Sockets for Trade Route");

   rmSetObjectDefTradeRouteID(socket, tradeRoute);
   rmAddObjectDefItem(socket, "socketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socket, true);
   rmSetObjectDefMinDistance(socket, 0.0);
   rmSetObjectDefMaxDistance(socket, 8.0);
   // Add waypoints for the route - starts in the north and goes south
   rmAddTradeRouteWaypoint(tradeRoute, 0.85, 0.95);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.65, 0.8, 4, 6);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.45, 0.6, 4, 6);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.45, 0.4, 4, 6);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.65, 0.2, 4, 6);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.85, 0.05, 4, 6);

   bool placedTradeRoute = rmBuildTradeRoute(tradeRoute, "dirt");
   if(placedTradeRoute == false)
   rmEchoError("Failed to place trade route"); 

   // Place the sockets along the trade route - uses percentages
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.05);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.3);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.4);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.6);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.7);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.95);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);

//********************************************************************************//

   // Player start
   // Town Center
   int townCenter = rmCreateObjectDef("Player TC");

   if(rmGetNomadStart())
   {
      rmAddObjectDefItem(townCenter, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(townCenter, "TownCenter", 1, 0.0);
   }

   if (cNumberTeams > 2) // Free-for-all
   {
      rmSetObjectDefMinDistance(townCenter, 0.0);
      rmSetObjectDefMaxDistance(townCenter, 120.0);
      rmAddObjectDefToClass(townCenter, classStartingUnits);
      rmAddObjectDefConstraint(townCenter, avoidTradeRouteFar);
      rmAddObjectDefConstraint(townCenter, avoidAllMedium);
      rmAddObjectDefConstraint(townCenter, edgeConstraint);
      rmAddObjectDefConstraint(townCenter, avoidImpassableMedium);
   }
   else
   {
      rmSetObjectDefMinDistance(townCenter, 20.0);
      rmSetObjectDefMaxDistance(townCenter, 50.0);
      rmAddObjectDefToClass(townCenter, classStartingUnits);
      rmAddObjectDefConstraint(townCenter, avoidTradeRouteFar);
      rmAddObjectDefConstraint(townCenter, avoidAllMedium);
      rmAddObjectDefConstraint(townCenter, edgeConstraint);
      rmAddObjectDefConstraint(townCenter, avoidImpassableFar); 
   }

   // Starting resources

   // Starting units, Explorer/Warchief etc.
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 5.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefToClass(startingUnits, classStartingUnits);
   rmAddObjectDefConstraint(startingUnits, avoidAllClose);
   rmAddObjectDefConstraint(startingUnits, edgeConstraint);
   
   //~ // Consulate
  //~ int monasteryID = rmCreateObjectDef("Consulate");
  //~ rmAddObjectDefItem(monasteryID, "ypConsulate", 1, 0);
  //~ rmSetObjectDefMinDistance(monasteryID, 8);
  //~ rmSetObjectDefMaxDistance(monasteryID, 16);
  //~ rmAddObjectDefToClass(monasteryID, classStartingUnits);
  //~ rmAddObjectDefConstraint(monasteryID, avoidAllMedium);
  //~ rmAddObjectDefConstraint(monasteryID, edgeConstraint);
  //~ rmAddObjectDefConstraint(monasteryID, avoidStartingUnitsShort);
  //~ rmAddObjectDefConstraint(monasteryID, avoidImpassableFar);
   
   // Coin
   int startingMine = rmCreateObjectDef("Starting mine");
   rmAddObjectDefItem(startingMine, "MineCopper", 1, 8.0);
   rmSetObjectDefMinDistance(startingMine, 20.0);
   rmSetObjectDefMaxDistance(startingMine, 26.0);
   rmAddObjectDefToClass(startingMine, classStartingUnits);
   rmAddObjectDefConstraint(startingMine, avoidAllMedium);
   rmAddObjectDefConstraint(startingMine, edgeConstraint);
    rmAddObjectDefConstraint(startingMine, avoidStartingUnitsShort);
   rmAddObjectDefConstraint(startingMine, avoidImpassableFar);

   // Food - Guanaco
   int startingHunting = rmCreateObjectDef("Starting hunting close");
   rmAddObjectDefItem(startingHunting, "Guanaco", rmRandInt(2,4), 4.0);
   rmSetObjectDefMinDistance(startingHunting, 14.0);
   rmSetObjectDefMaxDistance(startingHunting, 20.0);
   rmSetObjectDefCreateHerd(startingHunting, true);
   rmAddObjectDefToClass(startingHunting, classStartingUnits);
   rmAddObjectDefConstraint(startingHunting, avoidAllMedium);
   rmAddObjectDefConstraint(startingHunting, edgeConstraint);
   rmAddObjectDefConstraint(startingHunting, avoidStartingUnitsShort);
   rmAddObjectDefConstraint(startingHunting, avoidImpassableFar);

   int startingHunting2 = rmCreateObjectDef("Starting hunting medium");
   rmAddObjectDefItem(startingHunting2, "Guanaco", rmRandInt(4,6), 4.0);
   rmSetObjectDefMinDistance(startingHunting2, 20.0);
   rmSetObjectDefMaxDistance(startingHunting2, 26.0);
   rmSetObjectDefCreateHerd(startingHunting2, true);
   rmAddObjectDefToClass(startingHunting2, classStartingUnits);
   rmAddObjectDefConstraint(startingHunting2, avoidAllMedium);
   rmAddObjectDefConstraint(startingHunting2, edgeConstraint);
   rmAddObjectDefConstraint(startingHunting2, avoidStartingUnitsShort);
   rmAddObjectDefConstraint(startingHunting2, avoidImpassableFar);

   // Wood
   int startingTrees = rmCreateObjectDef("Starting trees");
   rmAddObjectDefItem(startingTrees, treeName, 3, 8.0);
   rmSetObjectDefMinDistance(startingTrees, 14.0);
   rmSetObjectDefMaxDistance(startingTrees, 18.0);
   rmAddObjectDefToClass(startingTrees, classStartingUnits);
   rmAddObjectDefConstraint(startingTrees, avoidAllMedium);
   rmAddObjectDefConstraint(startingTrees, edgeConstraint);
   rmAddObjectDefConstraint(startingTrees, avoidStartingUnitsShort);

   int startingTrees2 = rmCreateObjectDef("More starting trees");
   rmAddObjectDefItem(startingTrees2, treeName, 6, 8.0);
   rmSetObjectDefMinDistance(startingTrees2, 14.0);
   rmSetObjectDefMaxDistance(startingTrees2, 20.0);
   rmAddObjectDefToClass(startingTrees2, classStartingUnits);
   rmAddObjectDefConstraint(startingTrees2, avoidAllMedium);
   rmAddObjectDefConstraint(startingTrees2, edgeConstraint);
   rmAddObjectDefConstraint(startingTrees2, avoidStartingUnitsShort);

   //~ int startingForest = rmCreateArea("Starting forest ", bigContinent);
   //~ rmSetAreaWarnFailure(startingForest, false);
   //~ rmSetAreaSize(startingForest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
   //~ rmSetAreaForestType(startingForest, forestName);
   //~ rmSetAreaForestDensity(startingForest, 0.85);
   //~ rmSetAreaForestClumpiness(startingForest, 0.5);
   //~ rmSetAreaForestUnderbrush(startingForest, 0.25);
   //~ rmSetAreaCoherence(startingForest, 0.8);
   //~ rmSetAreaSmoothDistance(startingForest, 10);
   //~ rmSetAreaMinBlobs(startingForest, 1);
   //~ rmSetAreaMaxBlobs(startingForest, 1);
   //~ rmAddAreaConstraint(startingForest, avoidAllMedium);
   //~ rmAddAreaConstraint(startingForest, edgeConstraint);

   // Groupings moved to the placement loop

   // Nuggets - Easy
   int startingNuggetsEasy = rmCreateObjectDef("Starting nuggets easy");
   rmAddObjectDefItem(startingNuggetsEasy, "Nugget", 1, 0.0);
   rmSetObjectDefMinDistance(startingNuggetsEasy, 20.0);
   rmSetObjectDefMaxDistance(startingNuggetsEasy, 30.0);
   rmAddObjectDefToClass(startingNuggetsEasy, classStartingUnits);
   rmAddObjectDefConstraint(startingNuggetsEasy, avoidImpassableMedium);
   rmAddObjectDefConstraint(startingNuggetsEasy, avoidAllMedium);
   rmAddObjectDefConstraint(startingNuggetsEasy, edgeConstraint);

   // Nuggets - Easy
   int startingNuggetsEasy2 = rmCreateObjectDef("Starting nuggets easy 2");
   rmAddObjectDefItem(startingNuggetsEasy2, "Nugget", 1, 0.0);
   rmSetObjectDefMinDistance(startingNuggetsEasy2, 20.0);
   rmSetObjectDefMaxDistance(startingNuggetsEasy2, 30.0);
   rmAddObjectDefToClass(startingNuggetsEasy2, classStartingUnits);
   rmAddObjectDefConstraint(startingNuggetsEasy2, avoidImpassableMedium);
   rmAddObjectDefConstraint(startingNuggetsEasy2, avoidAllMedium);
   rmAddObjectDefConstraint(startingNuggetsEasy2, edgeConstraint);

   // Nuggets - Moderate
   int startingNuggetsModerate = rmCreateObjectDef("Starting nuggets moderate");
   rmAddObjectDefItem(startingNuggetsModerate, "Nugget", 1, 0.0);
   rmSetObjectDefMinDistance(startingNuggetsModerate, 30.0);
   rmSetObjectDefMaxDistance(startingNuggetsModerate, 40.0);
   rmAddObjectDefToClass(startingNuggetsModerate, classStartingUnits);
   rmAddObjectDefConstraint(startingNuggetsModerate, avoidAllMedium);
   rmAddObjectDefConstraint(startingNuggetsModerate, edgeConstraint);

   // Cool chunk-o-script that finds TCs and places stuff around them - Thanks Evanson!
   rmClearClosestPointConstraints();
   int teamNumber = -1;
   int waterFlag = -1;
   int j = 1;

   for(i = 1; < cNumberPlayers)
   {
      // TC places
      rmPlaceObjectDefAtLoc(townCenter, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(townCenter, i));
      
      vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));

      // Starting units, Explorer/Warchief etc.
      rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

      //~ if(ypIsAsian(i) && rmGetNomadStart() == false) {
        //~ rmPlaceObjectDefAtLoc(monasteryID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      //~ }
      
      // Water flag
      teamNumber = rmGetPlayerTeam(i);

      if (cNumberTeams > 2) 
      { // Free-for-all
         waterFlag = rmCreateObjectDef("HC water flag "+i);
         rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
         rmSetObjectDefMinDistance(waterFlag, 0.0);
         rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
         rmAddObjectDefConstraint(waterFlag, edgeConstraint);
         rmAddObjectDefConstraint(waterFlag, avoidFlags);
         rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
         rmAddObjectDefConstraint(waterFlag, noMansLand);
         rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
      }
      else if (teamZeroCount == teamOneCount)
      {  // Teams have an even number of players
         if ( (teamPlacement > 0.50) && (teamNumber == 0) ) 
         {  // Team 0 is south
            waterFlag = rmCreateObjectDef("HC water flag "+i);
            rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
            rmSetObjectDefMinDistance(waterFlag, 0.0);
            rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
            rmAddObjectDefConstraint(waterFlag, edgeConstraint);
            rmAddObjectDefConstraint(waterFlag, avoidFlags);
            rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
            rmAddObjectDefConstraint(waterFlag, southTeam);
            rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
         }
         else if ( (teamPlacement > 0.50) && (teamNumber == 1) )
         {  
            waterFlag = rmCreateObjectDef("HC water flag "+i);
            rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
            rmSetObjectDefMinDistance(waterFlag, 0.0);
            rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
            rmAddObjectDefConstraint(waterFlag, edgeConstraint);
            rmAddObjectDefConstraint(waterFlag, avoidFlags);
            rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
            rmAddObjectDefConstraint(waterFlag, northTeam);
            rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
         }
         else if ( (teamPlacement < 0.51) && (teamNumber == 0) )
         {  // Team 0 is north
            waterFlag = rmCreateObjectDef("HC water flag "+i);
            rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
            rmSetObjectDefMinDistance(waterFlag, 0.0);
            rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
            rmAddObjectDefConstraint(waterFlag, edgeConstraint);
            rmAddObjectDefConstraint(waterFlag, avoidFlags);
            rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
            rmAddObjectDefConstraint(waterFlag, northTeam);
            rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
         }
         else if ( (teamPlacement < 0.51) && (teamNumber == 1) )
         {  // Team 1 is south
            waterFlag = rmCreateObjectDef("HC water flag "+i);
            rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
            rmSetObjectDefMinDistance(waterFlag, 0.0);
            rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
            rmAddObjectDefConstraint(waterFlag, edgeConstraint);
            rmAddObjectDefConstraint(waterFlag, avoidFlags);
            rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
            rmAddObjectDefConstraint(waterFlag, southTeam);
            rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
         }
      }
      else if ( teamZeroCount != teamOneCount )
      {  // Teams have an uneven number of players
         if ( (teamZeroCount > teamOneCount) && (teamNumber == 0) ) 
         { // Team 0 is bigger, place bigger team flags south
            waterFlag = rmCreateObjectDef("HC water flag "+i);
            rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
            rmSetObjectDefMinDistance(waterFlag, 0.0);
            rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
            rmAddObjectDefConstraint(waterFlag, edgeConstraint);
            rmAddObjectDefConstraint(waterFlag, avoidFlags);
            rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
            rmAddObjectDefConstraint(waterFlag, southTeam);
            rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
         }
         else if ( (teamZeroCount > teamOneCount) && (teamNumber == 1) )
         { // Team 0 is bigger, place smaller team flags north
            waterFlag = rmCreateObjectDef("HC water flag "+i);
            rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
            rmSetObjectDefMinDistance(waterFlag, 0.0);
            rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
            rmAddObjectDefConstraint(waterFlag, edgeConstraint);
            rmAddObjectDefConstraint(waterFlag, avoidFlags);
            rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
            rmAddObjectDefConstraint(waterFlag, northTeam);
            rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
         }
         else if ( (teamOneCount > teamZeroCount) && (teamNumber == 0) )
         { // Team 1 is bigger, place small team flags north
            waterFlag = rmCreateObjectDef("HC water flag "+i);
            rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
            rmSetObjectDefMinDistance(waterFlag, 0.0);
            rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
            rmAddObjectDefConstraint(waterFlag, edgeConstraint);
            rmAddObjectDefConstraint(waterFlag, avoidFlags);
            rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
            rmAddObjectDefConstraint(waterFlag, northTeam);
            rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
         }
         else if ( (teamOneCount > teamZeroCount) && (teamNumber == 1) )
         { // Team 1 is bigger, place smaller team flags south
            waterFlag = rmCreateObjectDef("HC water flag "+i);
            rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
            rmSetObjectDefMinDistance(waterFlag, 0.0);
            rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
            rmAddObjectDefConstraint(waterFlag, edgeConstraint);
            rmAddObjectDefConstraint(waterFlag, avoidFlags);
            rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
            rmAddObjectDefConstraint(waterFlag, southTeam);
            rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
         }
      }
      else 
      { // Fail Case
         waterFlag = rmCreateObjectDef("HC water flag "+i);
         rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
         rmSetObjectDefMinDistance(waterFlag, 0.0);
         rmSetObjectDefMaxDistance(waterFlag, rmZFractionToMeters(0.9));
         rmAddObjectDefConstraint(waterFlag, edgeConstraint);
         rmAddObjectDefConstraint(waterFlag, avoidFlags);
         rmAddObjectDefConstraint(waterFlag, avoidAllMedium);
         rmAddObjectDefConstraint(waterFlag, noMansLand);
         rmPlaceObjectDefAtLoc(waterFlag, i, 0.0, 0.5, 1);
      }

      // Native settlements defined and placed
      int nativeVillageType = rmRandInt(1,5);
      int nativeVillage = 0;
      nativeVillage = rmCreateGrouping("Native village "+i, nativeName+nativeVillageType);
      rmSetGroupingMinDistance(nativeVillage, 40.0);
      rmSetGroupingMaxDistance(nativeVillage, 80.0);
      rmAddGroupingToClass(nativeVillage, classStartingUnits);
      rmAddGroupingConstraint(nativeVillage, avoidAllMedium);
      rmAddGroupingConstraint(nativeVillage, avoidStartingUnits);
      rmAddGroupingConstraint(nativeVillage, edgeConstraint);
      rmPlaceGroupingAtLoc(nativeVillage, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

      // Starting coin
      rmPlaceObjectDefAtLoc(startingMine, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

      // Starting food
      for(j = 0; < numberGuanacoPasses)
      {
         rmPlaceObjectDefAtLoc(startingHunting, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
         rmPlaceObjectDefAtLoc(startingHunting2, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));     
      }

      if(whichVariation == 2)
      {
         // Berry patches
         int berryPatchType = rmRandInt(1,4);
         int berryPatch = 0;
         berryPatch = rmCreateGrouping("Berry patch "+i, "BerryPatch "+berryPatchType);
         rmSetGroupingMinDistance(berryPatch, 10.0);
         rmSetGroupingMaxDistance(berryPatch, 12.0);
         rmAddGroupingToClass(berryPatch, classStartingUnits);
         rmAddGroupingConstraint(berryPatch, avoidAllMedium);
         rmAddGroupingConstraint(berryPatch, edgeConstraint);
         rmPlaceGroupingAtLoc(berryPatch, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
         // Herdable pens
         int herdablePenType = rmRandInt(1,4);
         int herdablePen = 0;
         herdablePen = rmCreateGrouping("Herdable Pen "+i, "Araucania_HerdablePen "+herdablePenType);
         rmSetGroupingMinDistance(herdablePen, 10.0);
         rmSetGroupingMaxDistance(herdablePen, 20.0);
         rmAddGroupingToClass(herdablePen, classStartingUnits);
         rmAddGroupingConstraint(herdablePen, avoidAllMedium);
         rmAddGroupingConstraint(herdablePen, edgeConstraint);
         rmPlaceGroupingAtLoc(herdablePen, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      }

      // Starting trees
      rmPlaceObjectDefAtLoc(startingTrees, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(startingTrees2, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

      // Starting nuggets Easy/Moderate
      for(j = 0; < numberNuggetEasyPasses)
      {
         rmSetNuggetDifficulty(1, 1);
         rmPlaceObjectDefAtLoc(startingNuggetsEasy, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
         rmPlaceObjectDefAtLoc(startingNuggetsEasy2, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
         rmSetNuggetDifficulty(2, 2);
         rmPlaceObjectDefAtLoc(startingNuggetsModerate, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      }
   }

   // Non-Player-Placed resources and map features

   // Mines
   // North mines
   for (i = 0; < numberMinePasses * cNumberNonGaiaPlayers)
   {
      int miningNorth = rmCreateObjectDef("North team mines "+i);
      rmAddObjectDefItem(miningNorth, "MineCopper", 1, 0.0);
      rmSetObjectDefMinDistance(miningNorth, 0.0);
      rmSetObjectDefMaxDistance(miningNorth, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(miningNorth, northTeam);
      rmAddObjectDefConstraint(miningNorth, avoidAllMedium);
      rmAddObjectDefConstraint(miningNorth, edgeConstraint);
      rmAddObjectDefConstraint(miningNorth, avoidImpassableFar);
      rmPlaceObjectDefAtLoc(miningNorth, 0, 0.6, 0.8);
   }

   // No man's land mines
   for (i = 0; < numberMinePasses * cNumberNonGaiaPlayers)
   {
      int miningNoMansLand = rmCreateObjectDef("No man's land mines "+i);
      rmAddObjectDefItem(miningNoMansLand, "MineCopper", 1, 20.0);
      rmSetObjectDefMinDistance(miningNoMansLand, 0.0);
      rmSetObjectDefMaxDistance(miningNoMansLand, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(miningNoMansLand, noMansLand);
      rmAddObjectDefConstraint(miningNoMansLand, avoidAllMedium);
      rmAddObjectDefConstraint(miningNoMansLand, edgeConstraint);
      rmAddObjectDefConstraint(miningNoMansLand, avoidImpassableFar);
      rmPlaceObjectDefAtLoc(miningNoMansLand, 0, 0.6, 0.5);
   }

   // South mines
   for (i = 0; < numberMinePasses * cNumberNonGaiaPlayers)
   {
      int miningSouth = rmCreateObjectDef("South team mines "+i);
      rmAddObjectDefItem(miningSouth, "MineCopper", 1, 0.0);
      rmSetObjectDefMinDistance(miningSouth, 0.0);
      rmSetObjectDefMaxDistance(miningSouth, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(miningSouth, southTeam);
      rmAddObjectDefConstraint(miningSouth, avoidAllMedium);
      rmAddObjectDefConstraint(miningSouth, edgeConstraint);
      rmAddObjectDefConstraint(miningSouth, avoidImpassableFar);
      rmPlaceObjectDefAtLoc(miningSouth, 0, 0.6, 0.2);
   }

   // Forest
   // North forest
   int forestPass = 4 * cNumberNonGaiaPlayers;
   int forestFailCount = 0;
   for (i = 0; < forestPass)
   {
      int forestNorth = rmCreateArea("Forest north "+i, bigContinent);
      rmSetAreaWarnFailure(forestNorth, false);
      rmSetAreaSize(forestNorth, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
      rmSetAreaForestType(forestNorth, forestName);
      rmSetAreaForestDensity(forestNorth, 0.85);
      rmSetAreaForestClumpiness(forestNorth, 0.5);
      rmSetAreaForestUnderbrush(forestNorth, 0.25);
      rmSetAreaCoherence(forestNorth, 0.8);
      rmSetAreaSmoothDistance(forestNorth, 10);
      rmSetAreaMinBlobs(forestNorth, 2);
      rmSetAreaMaxBlobs(forestNorth, 6);
      rmAddAreaConstraint(forestNorth, northTeam);
      rmAddAreaConstraint(forestNorth, avoidTradeSocket);
      rmAddAreaConstraint(forestNorth, avoidAllMedium);
      rmAddAreaConstraint(forestNorth, edgeConstraint);

      if(rmBuildArea(forestNorth) == false)
      {
         // Stop trying once we fail 6 times in a row.
         forestFailCount++;
         if(forestFailCount == 6)
            break;
      }
      else
         forestFailCount = 0; 
   }

   // No man's land forest
   forestPass = 6 * cNumberNonGaiaPlayers;
   forestFailCount = 0;
   for (i = 0; < forestPass)
   {
      int forestNoMansLand = rmCreateArea("Forest no man's land "+i, bigContinent);
      rmSetAreaWarnFailure(forestNoMansLand, false);
      rmSetAreaSize(forestNoMansLand, rmAreaTilesToFraction(50), rmAreaTilesToFraction(50));
      rmSetAreaForestType(forestNoMansLand, forestName);
      rmSetAreaForestDensity(forestNoMansLand, 0.75);
      rmSetAreaForestClumpiness(forestNoMansLand, 0.5);
      rmSetAreaForestUnderbrush(forestNoMansLand, 0.25);
      rmSetAreaCoherence(forestNoMansLand, 0.25);
      rmSetAreaSmoothDistance(forestNoMansLand, 10);
      rmAddAreaConstraint(forestNoMansLand, noMansLand);
      rmAddAreaConstraint(forestNoMansLand, avoidTradeSocket);
      rmAddAreaConstraint(forestNoMansLand, avoidAllMedium);
      rmAddAreaConstraint(forestNoMansLand, edgeConstraint);

      if(rmBuildArea(forestNoMansLand) == false)
      {
         // Stop trying once we fail 6 times in a row.
         forestFailCount++;
         if(forestFailCount == 6)
            break;
      }
      else
         forestFailCount = 0; 
   }

   // South forest
   forestPass = 4 * cNumberNonGaiaPlayers;
   forestFailCount = 0;
   for (i = 0; <forestPass)
   {
      int forestSouth = rmCreateArea("Forest south "+i, bigContinent);
      rmSetAreaWarnFailure(forestSouth, false);
      rmSetAreaSize(forestSouth, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
      rmSetAreaForestType(forestSouth, forestName);
      rmSetAreaForestDensity(forestSouth, 0.85);
      rmSetAreaForestClumpiness(forestSouth, 0.5);
      rmSetAreaForestUnderbrush(forestSouth, 0.25);
      rmSetAreaCoherence(forestSouth, 0.8);
      rmSetAreaSmoothDistance(forestSouth, 10);
      rmSetAreaMinBlobs(forestSouth, 2);
      rmSetAreaMaxBlobs(forestSouth, 6);
      rmAddAreaConstraint(forestSouth, southTeam);
      rmAddAreaConstraint(forestSouth, avoidTradeSocket);
      rmAddAreaConstraint(forestSouth, avoidAllMedium);
      rmAddAreaConstraint(forestSouth, edgeConstraint);

      if(rmBuildArea(forestSouth) == false)
      {
         // Stop trying once we fail 6 times in a row.
         forestFailCount++;
         if(forestFailCount == 6)
            break;
      }
      else
         forestFailCount = 0; 
   }

    // Place random flags
    int avoidFlags2 = rmCreateTypeDistanceConstraint("flags avoid flags 2", "ControlFlag", 70);
    for ( i =1; <13 ) {
    int flagID = rmCreateObjectDef("random flag"+i);
    rmAddObjectDefItem(flagID, "ControlFlag", 1, 0.0);
    rmSetObjectDefMinDistance(flagID, 0.0);
    rmSetObjectDefMaxDistance(flagID, rmXFractionToMeters(0.40));
    rmAddObjectDefConstraint(flagID, avoidFlags2);
    rmPlaceObjectDefAtLoc(flagID, 0, 0.5, 0.5);
    }

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.0;
    float yLoc = 0.5;
    float walk = 0.075;
    
    if(randLoc == 1)
      xLoc = .5;
    
    else
      xLoc = .8;
      
    if(cNumberTeams > 2) {
      yLoc = rmRandFloat(.1, .9);
      walk = 0.25;
    }
    
    ypKingsHillPlacer(xLoc, yLoc, walk, notInTheMountains);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
  
   // Hunting
   // Deer on the north coast
   for (i = 0; < numberDeerPasses * cNumberNonGaiaPlayers)
   {
      int huntingDeerNorth = rmCreateObjectDef("North deer "+i);
      rmAddObjectDefItem(huntingDeerNorth, "Deer", herdSizeHunting, 4.0);
      rmSetObjectDefMinDistance(huntingDeerNorth, 0.0);
      rmSetObjectDefMaxDistance(huntingDeerNorth, rmZFractionToMeters(0.5));
      rmSetObjectDefCreateHerd(huntingDeerNorth, true);
      rmAddObjectDefConstraint(huntingDeerNorth, northDeer);
      rmAddObjectDefConstraint(huntingDeerNorth, avoidAllMedium);
      rmAddObjectDefConstraint(huntingDeerNorth, edgeConstraint);
      rmAddObjectDefConstraint(huntingDeerNorth, avoidImpassableFar);
      rmPlaceObjectDefAtLoc(huntingDeerNorth, 0, 0.3, 0.8);
   }

   // Deer on the south coast
   for (i = 0; < numberDeerPasses * cNumberNonGaiaPlayers)
   {
      int huntingDeerSouth = rmCreateObjectDef("South deer "+i);
      rmAddObjectDefItem(huntingDeerSouth, "Deer", herdSizeHunting, 4.0);
      rmSetObjectDefMinDistance(huntingDeerSouth, 0.0);
      rmSetObjectDefMaxDistance(huntingDeerSouth, rmZFractionToMeters(0.5));
      rmSetObjectDefCreateHerd(huntingDeerSouth, true);
      rmAddObjectDefConstraint(huntingDeerSouth, southDeer);
      rmAddObjectDefConstraint(huntingDeerSouth, avoidAllMedium);
      rmAddObjectDefConstraint(huntingDeerSouth, edgeConstraint);
      rmAddObjectDefConstraint(huntingDeerSouth, avoidImpassableFar);
      rmPlaceObjectDefAtLoc(huntingDeerSouth, 0, 0.3, 0.2);
   }
   
   // Guanaco in the north mountains
   for (i = 0; < numberGuanacoPasses * cNumberNonGaiaPlayers)
   {
      int huntingGuanacoNorth = rmCreateObjectDef("North guanaco "+i);
      rmAddObjectDefItem(huntingGuanacoNorth, "Guanaco", herdSizeHunting, 4.0);
      rmSetObjectDefMinDistance(huntingGuanacoNorth, 0.0);
      rmSetObjectDefMaxDistance(huntingGuanacoNorth, rmZFractionToMeters(0.5));
      rmSetObjectDefCreateHerd(huntingGuanacoNorth, true);
      rmAddObjectDefConstraint(huntingGuanacoNorth, northGuanaco);
      rmAddObjectDefConstraint(huntingGuanacoNorth, avoidAllMedium);
      rmAddObjectDefConstraint(huntingGuanacoNorth, edgeConstraint);
      rmPlaceObjectDefAtLoc(huntingGuanacoNorth, 0, 0.7, 0.8);
   }
   
   // Guanaco in the south mountains
   for (i = 0; < numberGuanacoPasses * cNumberNonGaiaPlayers)
   {
      int huntingGuanacoSouth = rmCreateObjectDef("South guanaco "+i);
      rmAddObjectDefItem(huntingGuanacoSouth, "Guanaco", herdSizeHunting, 4.0);
      rmSetObjectDefMinDistance(huntingGuanacoSouth, 0.0);
      rmSetObjectDefMaxDistance(huntingGuanacoSouth, rmZFractionToMeters(0.5));
      rmSetObjectDefCreateHerd(huntingGuanacoSouth, true);
      rmAddObjectDefConstraint(huntingGuanacoSouth, southGuanaco);
      rmAddObjectDefConstraint(huntingGuanacoSouth, avoidAllMedium);
      rmAddObjectDefConstraint(huntingGuanacoSouth, edgeConstraint);
      rmPlaceObjectDefAtLoc(huntingGuanacoSouth, 0, 0.7, 0.2);
   }

   if(whichVariation == 2)
   {

      // Herdable animals - Llama - No man's land
      for (i = 0; < 2 * cNumberNonGaiaPlayers)
      {
         int noMansLandLlamas = rmCreateObjectDef("No man's land llamas "+i);
         rmAddObjectDefItem(noMansLandLlamas, "Llama", herdSizeHerdable, 4.0);
         rmSetObjectDefMinDistance(noMansLandLlamas, 0.0);
         rmSetObjectDefMaxDistance(noMansLandLlamas, rmZFractionToMeters(0.5));
         rmAddObjectDefConstraint(noMansLandLlamas, noMansLand);
         rmAddObjectDefConstraint(noMansLandLlamas, avoidAllMedium);
         rmAddObjectDefConstraint(noMansLandLlamas, edgeConstraint);
         rmAddObjectDefConstraint(noMansLandLlamas, avoidImpassableFar);
         rmPlaceObjectDefAtLoc(noMansLandLlamas, 0, 0.75, 0.5);
      }
   }
   // Berries - North
   for (i = 0; < cNumberNonGaiaPlayers)
   {
      int berriesNorth = rmCreateObjectDef("North berry patches "+i);
      rmAddObjectDefItem(berriesNorth, "Berrybush", numberBerryPatch, 4.0);
      rmSetObjectDefMinDistance(berriesNorth, 0.0);
      rmSetObjectDefMaxDistance(berriesNorth, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(berriesNorth, northTeam);
      rmAddObjectDefConstraint(berriesNorth, avoidAllMedium);
      rmAddObjectDefConstraint(berriesNorth, edgeConstraint);
      rmAddObjectDefConstraint(berriesNorth, avoidImpassableFar);
      rmPlaceObjectDefAtLoc(berriesNorth, 0, 0.76, 0.8);
   }
   // Berries - No man's land
   for (i = 0; < numberBerryPasses * cNumberNonGaiaPlayers)
   {
      int berriesNoMansLand = rmCreateObjectDef("No man's land berry patches "+i);
      rmAddObjectDefItem(berriesNoMansLand, "Berrybush", numberBerryPatch, 4.0);
      rmSetObjectDefMinDistance(berriesNoMansLand, 0.0);
      rmSetObjectDefMaxDistance(berriesNoMansLand, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(berriesNoMansLand, noMansLand);
      rmAddObjectDefConstraint(berriesNoMansLand, avoidAllMedium);
      rmAddObjectDefConstraint(berriesNoMansLand, edgeConstraint);
      rmAddObjectDefConstraint(berriesNoMansLand, avoidImpassableFar);
      rmPlaceObjectDefAtLoc(berriesNoMansLand, 0, 0.76, 0.5);
   }
   // Berries - South
   for (i = 0; < cNumberNonGaiaPlayers)
   {
      int berriesSouth = rmCreateObjectDef("South berry patches "+i);
      rmAddObjectDefItem(berriesSouth, "Berrybush", numberBerryPatch, 4.0);
      rmSetObjectDefMinDistance(berriesSouth, 0.0);
      rmSetObjectDefMaxDistance(berriesSouth, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(berriesSouth, southTeam);
      rmAddObjectDefConstraint(berriesSouth, avoidAllMedium);
      rmAddObjectDefConstraint(berriesSouth, edgeConstraint);
      rmAddObjectDefConstraint(berriesSouth, avoidImpassableFar);
      rmPlaceObjectDefAtLoc(berriesSouth, 0, 0.24, 0.2);
   }

   // Whales - North
   int northWhales=rmCreateObjectDef(" North whales");
   rmAddObjectDefItem(northWhales, "HumpbackWhale", 1, 0.0);
   rmSetObjectDefMinDistance(northWhales, 0.0);
   rmSetObjectDefMaxDistance(northWhales, rmZFractionToMeters(0.6));
   rmAddObjectDefConstraint(northWhales, northTeam);
   rmAddObjectDefConstraint(northWhales, avoidAllFar);
   rmAddObjectDefConstraint(northWhales, avoidImpassableLandFar);
   rmPlaceObjectDefAtLoc(northWhales, 0, 0.0, 1.0, cNumberNonGaiaPlayers);

   // Whales - South
   int southWhales=rmCreateObjectDef(" South whales");
   rmAddObjectDefItem(southWhales, "HumpbackWhale", 1, 0.0);
   rmSetObjectDefMinDistance(southWhales, 0.0);
   rmSetObjectDefMaxDistance(southWhales, rmZFractionToMeters(0.6));
   rmAddObjectDefConstraint(southWhales, southTeam);
   rmAddObjectDefConstraint(southWhales, avoidAllFar);
   rmAddObjectDefConstraint(southWhales, avoidImpassableLandFar);
   rmPlaceObjectDefAtLoc(southWhales, 0, 0.0, 0.0, cNumberNonGaiaPlayers);

   // Fish - North
   int northFish=rmCreateObjectDef("North fish");
   rmAddObjectDefItem(northFish, "FishSardine", 1, 9.0);
   rmSetObjectDefMinDistance(northFish, 0.0);
   rmSetObjectDefMaxDistance(northFish, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(northFish, northTeam);
   rmAddObjectDefConstraint(northFish, avoidAllFar);
   rmAddObjectDefConstraint(northFish, avoidImpassableLandMedium);
   rmPlaceObjectDefAtLoc(northFish, 0, 0.0, 1.0, 2 * cNumberNonGaiaPlayers);

//********************************************************************************//
   rmSetStatusText("",0.1);
//********************************************************************************//

   // Fish - North2
   int northFish2=rmCreateObjectDef("North fish 2");
   rmAddObjectDefItem(northFish2, "FishSardine", 1, 9.0);
   rmSetObjectDefMinDistance(northFish2, 0.0);
   rmSetObjectDefMaxDistance(northFish2, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(northFish2, northTeam);
   rmAddObjectDefConstraint(northFish2, avoidAllMedium);
   rmAddObjectDefConstraint(northFish2, avoidImpassableLandMedium);
   rmPlaceObjectDefAtLoc(northFish2, 0, 0.0, 1.0, 1 * cNumberNonGaiaPlayers);

//********************************************************************************//
   rmSetStatusText("",0.2);
//********************************************************************************//

   // Fish - South
   int southFish=rmCreateObjectDef("South fish");
   rmAddObjectDefItem(southFish, "FishSardine", 1, 9.0);
   rmSetObjectDefMinDistance(southFish, 0.0);
   rmSetObjectDefMaxDistance(southFish, rmZFractionToMeters(0.5));
   rmAddObjectDefConstraint(southFish, southTeam);
   rmAddObjectDefConstraint(southFish, avoidAllFar);
   rmAddObjectDefConstraint(southFish, avoidImpassableLandMedium);
   rmPlaceObjectDefAtLoc(southFish, 0, 0.0, 0.5, 2 * cNumberNonGaiaPlayers);

//********************************************************************************//
   rmSetStatusText("",0.3);
//********************************************************************************//

   // Fish - South2
   int southFish2=rmCreateObjectDef("South fish 2");
   rmAddObjectDefItem(southFish2, "FishSardine", 1, 9.0);
   rmSetObjectDefMinDistance(southFish2, 0.0);
   rmSetObjectDefMaxDistance(southFish2, rmZFractionToMeters(0.5));
   rmAddObjectDefConstraint(southFish2, southTeam);
   rmAddObjectDefConstraint(southFish2, avoidAllMedium);
   rmAddObjectDefConstraint(southFish2, avoidImpassableLandMedium);
   rmPlaceObjectDefAtLoc(southFish2, 0, 0.0, 0.5, 1 * cNumberNonGaiaPlayers);

//********************************************************************************//
   rmSetStatusText("",0.4);
//********************************************************************************//

//********************************************************************************//
   rmSetStatusText("",0.5);
//********************************************************************************//

   // Nuggets - North - EASY
   for (i = 0; < numberNuggetEasyPasses * cNumberNonGaiaPlayers)
   {
      int northNuggetsEasy = rmCreateObjectDef("North nuggets easy "+i);
      rmAddObjectDefItem(northNuggetsEasy, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(northNuggetsEasy, 0.0);
      rmSetObjectDefMaxDistance(northNuggetsEasy, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(northNuggetsEasy, northTeam);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidAllClose);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidImpassableMedium);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidNugget);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidStartingUnits);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidTradeRouteClose);
      rmSetNuggetDifficulty(1, 1);
      rmPlaceObjectDefAtLoc(northNuggetsEasy, 0, 0.76, 0.8);
   }

//********************************************************************************//
   rmSetStatusText("",0.5);
//********************************************************************************//

   // Nuggets - North - MODERATE
   for (i = 0; < cNumberNonGaiaPlayers)
   {
      int northNuggetsModerate = rmCreateObjectDef("North nuggets moderate "+i);
      rmAddObjectDefItem(northNuggetsModerate, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(northNuggetsModerate, 0.0);
      rmSetObjectDefMaxDistance(northNuggetsModerate, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(northNuggetsModerate, northTeam);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidAllClose);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidNugget);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidImpassableFar);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidStartingUnits);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidTradeRouteClose);
      rmSetNuggetDifficulty(2, 2);
      rmPlaceObjectDefAtLoc(northNuggetsModerate, 0, 0.76, 0.8);
   }

//********************************************************************************//
   rmSetStatusText("",0.6);
//********************************************************************************//

   // Nuggets - North - HARD
   for (i = 0; < numberNuggetHardNutsPasses * cNumberNonGaiaPlayers)
   {
      int northNuggetsHard = rmCreateObjectDef("North nuggets hard "+i);
      rmAddObjectDefItem(northNuggetsHard, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(northNuggetsHard, 0.0);
      rmSetObjectDefMaxDistance(northNuggetsHard, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(northNuggetsHard, northTeam);
      rmAddObjectDefConstraint(northNuggetsHard, avoidAllClose);
      rmAddObjectDefConstraint(northNuggetsHard, avoidImpassableFar);
      rmAddObjectDefConstraint(northNuggetsHard, avoidNugget);
      rmAddObjectDefConstraint(northNuggetsHard, avoidStartingUnits);
      rmAddObjectDefConstraint(northNuggetsHard, avoidTradeRouteClose);
      rmSetNuggetDifficulty(3, 3);
      rmPlaceObjectDefAtLoc(northNuggetsHard, 0, 0.76, 0.8);
   }

//********************************************************************************//
   rmSetStatusText("",0.7);
//********************************************************************************//

   // Nuggets - No man's land - NUTS
   for (i = 0; < numberNuggetHardNutsPasses * cNumberNonGaiaPlayers) 
   {
      int noMansLandNuggetNuts = rmCreateObjectDef("No man's land nuggets nuts "+i);
      rmAddObjectDefItem(noMansLandNuggetNuts, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(noMansLandNuggetNuts, 0.0);
      rmSetObjectDefMaxDistance(noMansLandNuggetNuts, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(noMansLandNuggetNuts, noMansLand);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidAllClose);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidImpassableFar);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidNugget);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidStartingUnits);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidTradeRouteClose);
      rmSetNuggetDifficulty(4, 4);
      rmPlaceObjectDefAtLoc(noMansLandNuggetNuts, 0, 0.76, 0.5);
   }

//********************************************************************************//
   rmSetStatusText("",0.8);
//********************************************************************************//

   // Nuggets - South EASY
   for (i = 0; < numberNuggetEasyPasses * cNumberNonGaiaPlayers)
   {
      int southNuggetsEasy = rmCreateObjectDef("South nuggets easy "+i);
      rmAddObjectDefItem(southNuggetsEasy, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(southNuggetsEasy, 0.0);
      rmSetObjectDefMaxDistance(southNuggetsEasy, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(southNuggetsEasy, southTeam);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidAllClose);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidImpassableMedium);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidNugget);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidStartingUnits);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidTradeRouteClose);
      rmSetNuggetDifficulty(1, 1);
      rmPlaceObjectDefAtLoc(southNuggetsEasy, 0, 0.24, 0.2);
   }

//********************************************************************************//
   rmSetStatusText("",0.9);
//********************************************************************************//

   // Nuggets - South MODERATE
   for (i = 0; < cNumberNonGaiaPlayers)
   {
      int southNuggetsModerate = rmCreateObjectDef("South nuggets moderate "+i);
      rmAddObjectDefItem(southNuggetsModerate, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(southNuggetsModerate, 0.0);
      rmSetObjectDefMaxDistance(southNuggetsModerate, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(southNuggetsModerate, southTeam);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidAllClose);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidImpassableFar);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidNugget);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidStartingUnits);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidTradeRouteClose);
      rmSetNuggetDifficulty(2, 2);
      rmPlaceObjectDefAtLoc(southNuggetsModerate, 0, 0.24, 0.2);
   }

//********************************************************************************//
   rmSetStatusText("",1.0);
//********************************************************************************//

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

   // Nuggets - South HARD
   for (i = 0; < numberNuggetHardNutsPasses * cNumberNonGaiaPlayers)
   {
      int southNuggetsHard = rmCreateObjectDef("South nuggets hard "+i);
      rmAddObjectDefItem(southNuggetsHard, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(southNuggetsHard, 0.0);
      rmSetObjectDefMaxDistance(southNuggetsHard, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(southNuggetsHard, southTeam);
      rmAddObjectDefConstraint(southNuggetsHard, avoidAllClose);
      rmAddObjectDefConstraint(southNuggetsHard, avoidImpassableFar);
      rmAddObjectDefConstraint(southNuggetsHard, avoidNugget);
      rmAddObjectDefConstraint(southNuggetsHard, avoidStartingUnits);
      rmAddObjectDefConstraint(southNuggetsHard, avoidTradeRouteClose);
      rmSetNuggetDifficulty(3, 3);
      rmPlaceObjectDefAtLoc(southNuggetsHard, 0, 0.24, 0.2);
   }
}
