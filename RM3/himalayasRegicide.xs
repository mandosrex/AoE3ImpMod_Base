// Shangri La
// a random map for AOE3: The Asian Dynasties
// by RF_Gandalf

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{  
   // Text
   rmSetStatusText("",0.01);

// Set up for variables
   string baseType = "";
   string forestType = "";
   string treeType = "";
   string deerType = "";
   string deer2Type = "";
   string deer3Type = "";
   string sheepType = "";
   string centerHerdType = "";
   string native1Name = "";
   string native2Name = "";
   string patchMixType = "";
   string mineType = "";

// Pick pattern for trees, terrain, features, etc.
   int variantChance = rmRandInt(1,2);
   int socketPattern = rmRandInt(2,3);
   if (cNumberNonGaiaPlayers > 4)
	socketPattern = rmRandInt(1,2);
   int nativeSetup = rmRandInt(1,3);	 
   int nativePattern = rmRandInt(1,4);
   int sheepChance = rmRandInt(1,2);
   int cliffVariety = rmRandInt(1,3);
   int hillTrees = -1;
   int forestDist = rmRandInt(12,17);
   int axisChance = rmRandInt(1,2);
   int playerSide = rmRandInt(1,2);
   int twoChoice = rmRandInt(1,2);

// Define the map size
   int playerTiles = 14500;
   if (cNumberNonGaiaPlayers == 8)
	playerTiles = 10000;
   else if (cNumberNonGaiaPlayers == 7)
	playerTiles = 10500;
   else if (cNumberNonGaiaPlayers == 6)
	playerTiles = 11500;
   else if (cNumberNonGaiaPlayers == 5)
	playerTiles = 12500;
   else if (cNumberNonGaiaPlayers == 4)
	playerTiles = 13500;
   else if (cNumberNonGaiaPlayers == 3)
	playerTiles = 14000;

   int size=1.9*sqrt(cNumberNonGaiaPlayers*playerTiles);
   if (cNumberNonGaiaPlayers > 6)
      size=2.15*sqrt(cNumberNonGaiaPlayers*playerTiles);

   float playerFactor=(1.2 + cNumberNonGaiaPlayers*0.085);
   int longSide=playerFactor*size; 
   rmSetMapSize(size,longSide);
   
// Elevation
   rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
   rmSetMapElevationHeightBlend(1.0);
   rmSetSeaLevel(0.0);
	
   // Text
   rmSetStatusText("",0.05);

// Terrain patterns and features 
   rmSetMapType("himalayas");
   rmSetMapType("grass");
   rmSetLightingSet("Himalayas");
   baseType = "himalayas_a";
   forestType = "Himalayas Forest";
   treeType = "ypTreeHimalayas"; 
   if (variantChance == 1)
   {
      deerType = "ypIbex";
      deer2Type = "ypMarcoPoloSheep";
   }
   else if (variantChance == 2)
   {     
      deerType = "ypMarcoPoloSheep";
      deer2Type = "ypIbex";
   }
   variantChance = rmRandInt(1,2);
   if (variantChance == 1)
   {
      centerHerdType = "ypMuskDeer";
      deer3Type = "ypNilgai";
   }
   else
   {
      centerHerdType = "ypNilgai";
      deer3Type = "ypMuskDeer";
   }

   sheepType = "ypYak";

   mineType = "mine";
   hillTrees = rmRandInt(0,1);
   rmSetBaseTerrainMix(baseType);
   rmTerrainInitialize("yukon\ground1_yuk", 0);
   rmEnableLocalWater(false);
   rmSetMapType("land");
   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);
   chooseMercs();

// Native patterns
// EASTERN NATIVE
  if (nativePattern == 1)
  {
      rmSetSubCiv(0, "zen");
      native1Name = "native zen temple YR 0";
  }
  else if (nativePattern == 2)
  {
      rmSetSubCiv(0, "udasi");
      native1Name = "native udasi village himal ";
  }
  else if (nativePattern == 3)
  {
      rmSetSubCiv(0, "bhakti");
      native1Name = "native bhakti village himal ";
  }
  else if (nativePattern == 4)
  {
      rmSetSubCiv(0, "shaolin");
      native1Name = "native shaolin temple mongol 0";
  } 
// WESTERN NATIVE
  nativePattern = rmRandInt(1,5);
  if (nativePattern == 1)
  {
      rmSetSubCiv(1, "shaolin");
      native2Name = "native shaolin temple YR 0";
  }
  else if (nativePattern == 2)
  {
      rmSetSubCiv(1, "bhakti");
      native2Name = "native bhakti village ";
  }
  else if (nativePattern == 3)
  {
      rmSetSubCiv(1, "udasi");
      native2Name = "native udasi village ";
  }
  else if (nativePattern == 4)
  {
      rmSetSubCiv(1, "sufi");
      native2Name = "native sufi mosque deccan ";
  }
  else if (nativePattern == 5)
  {
      rmSetSubCiv(1, "zen");
      native2Name = "native zen temple YR 0";
  }

// Define some classes.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("classCliff");
   rmDefineClass("classMountain");
   rmDefineClass("classBarrierRidge");
   rmDefineClass("classNugget");
   rmDefineClass("socketClass");
   rmDefineClass("classBase");
   rmDefineClass("classClearing"); 
   int classHuntable=rmDefineClass("huntableFood");   
   int classHerdable=rmDefineClass("herdableFood"); 
   int snowPatch=rmDefineClass("snow patch");
   int eastPatch=rmDefineClass("east patch");
   int greenPatch=rmDefineClass("green patch");

   // Text
   rmSetStatusText("",0.10);

// -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int secondEdgeConstraint=rmCreateBoxConstraint("avoid edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
   int wallEdgeConstraint=rmCreateBoxConstraint("walls avoid edge of map", rmXTilesToFraction(5), rmZTilesToFraction(5), 1.0-rmXTilesToFraction(5), 1.0-rmZTilesToFraction(5), 0.01);

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 40.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 25.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 60.0);
   int nativePlayerConstraint=rmCreateClassDistanceConstraint("natives stay away from players", classPlayer, 52.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 85.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 105.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0); 

   // Nature avoidance
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int shortForestConstraint=rmCreateClassDistanceConstraint("patch vs. forest", rmClassID("classForest"), 15.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), forestDist);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 10.0);
   int shortAvoidSilver=rmCreateTypeDistanceConstraint("short gold avoid gold", "Mine", 20.0);
   int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 45.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidSheep=rmCreateClassDistanceConstraint("sheep avoids sheep etc", rmClassID("herdableFood"), 45.0);
   int huntableConstraint=rmCreateClassDistanceConstraint("huntable constraint", rmClassID("huntableFood"), 35.0);
   int longHuntableConstraint=rmCreateClassDistanceConstraint("long huntable constraint", rmClassID("huntableFood"), 55.0);
   int forestsAvoidBison=rmCreateClassDistanceConstraint("forest avoids bison", rmClassID("huntableFood"), 15.0);

   // Avoid impassable land, certain features
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 18.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 8.0);
   int avoidCliffs=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
   int avoidCliff20=rmCreateClassDistanceConstraint("avoid cliffs 20", rmClassID("classCliff"), 20.0);
   int avoidCliff30=rmCreateClassDistanceConstraint("avoid cliffs 30", rmClassID("classCliff"), 30.0);
   int avoidCliffsShort=rmCreateClassDistanceConstraint("stuff vs. cliff short", rmClassID("classCliff"), 7.0);
   int avoidBarrier=rmCreateClassDistanceConstraint("stuff vs. barrier", rmClassID("classBarrierRidge"), 15.0);
   int avoidBarrierShort=rmCreateClassDistanceConstraint("stuff vs. barrier short", rmClassID("classBarrierRidge"), 1.0);
   int avoidBarrierMed=rmCreateClassDistanceConstraint("stuff vs. barrier med", rmClassID("classBarrierRidge"), 8.0);
   int avoidBase=rmCreateClassDistanceConstraint("stuff vs. base", rmClassID("classBase"), 15.0);
   int avoidBaseShort=rmCreateClassDistanceConstraint("stuff vs. base short", rmClassID("classBase"), 1.0);
   int avoidBaseMed=rmCreateClassDistanceConstraint("stuff vs. base med", rmClassID("classBase"), 7.0);
   int avoidBaseLong=rmCreateClassDistanceConstraint("stuff vs. base long", rmClassID("classBase"), 24.0);
   int avoidMts=rmCreateClassDistanceConstraint("stuff vs. mts", rmClassID("classMountain"), 15.0);
   int avoidMtsShort=rmCreateClassDistanceConstraint("stuff vs. mts short", rmClassID("classMountain"), 2.0);
   int avoidClearing=rmCreateClassDistanceConstraint("avoid clearings", rmClassID("classClearing"), 5.0);
   int avoidClearingMt=rmCreateClassDistanceConstraint("mountains avoid clearings", rmClassID("classClearing"), 1.0);
   int avoidSnowPatch=rmCreateClassDistanceConstraint("avoid green", rmClassID("snow patch"), 2.0);    
   int avoidGreen=rmCreateClassDistanceConstraint("avoid green patch", rmClassID("green patch"), 4.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 10.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 4.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 50.0);
   int avoidNativesMed=rmCreateClassDistanceConstraint("stuff avoids natives medium", rmClassID("natives"), 35.0);
   int avoidNativesMed2=rmCreateClassDistanceConstraint("stuff avoids natives medium less", rmClassID("natives"), 30.0);
   int avoidNativesShort=rmCreateClassDistanceConstraint("stuff avoids natives shorter", rmClassID("natives"), 10.0);
   int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget", rmClassID("classNugget"), 42.0);
   int avoidNuggetMed=rmCreateClassDistanceConstraint("nugget vs. nugget med", rmClassID("classNugget"), 50.0);
   int avoidNuggetLong=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 65.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);   
   int avoidKOTH=rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 8.0);


   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidTradeRouteCliff = rmCreateTradeRouteDistanceConstraint("trade route cliff", 10.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 12.0);

   // Cardinal Directions - "quadrants" of the map.
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.48, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(5), rmDegreesToRadians(175));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(185), rmDegreesToRadians(355));
   int Eastmost=rmCreatePieConstraint("farEastMapConstraint", 0.55, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(0), rmDegreesToRadians(180));
   int WestMtTrees=rmCreatePieConstraint("westMtTreeConstraint", 0.45, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(180), rmDegreesToRadians(360));

// ---------------------------------------------------------------------------------------
   // Text
   rmSetStatusText("",0.15);

// Set up player starting locations

   if (cNumberNonGaiaPlayers == 3)
   {
      rmSetPlacementSection(0.11, 0.39);
      rmPlacePlayersCircular(0.355, 0.359, 0.0);
   }
   else if (cNumberNonGaiaPlayers == 5)
   {
      rmSetPlacementSection(0.08, 0.42);
      rmPlacePlayersCircular(0.385, 0.389, 0.0);
   }
   else if (cNumberNonGaiaPlayers == 7)
   {
      rmSetPlacementSection(0.06, 0.44);
      rmPlacePlayersCircular(0.405, 0.408, 0.0);
   }
   else if (cNumberNonGaiaPlayers == 8) 
   {
      rmSetPlacementSection(0.05, 0.45);
      rmPlacePlayersCircular(0.41, 0.412, 0.0);
   }
   else
   {
      if (cNumberTeams > 2)
      {
         if (cNumberNonGaiaPlayers == 4)
         {
            rmSetPlacementSection(0.09, 0.41);
            rmPlacePlayersCircular(0.36, 0.362, 0.0);
         }
         else // if # players = 6
         {
            rmSetPlacementSection(0.07, 0.43);
            rmPlacePlayersCircular(0.39, 0.394, 0.0);
         }
	}
      else // IF #teams = 2, player # = 2,4,6
      {   
         if (playerSide == 1)
   	      rmSetPlacementTeam(0);
	   else
	      rmSetPlacementTeam(1);
	   if (cNumberNonGaiaPlayers == 2)
         {
            rmSetPlacementSection(0.125, 0.2);
            rmPlacePlayersCircular(0.34, 0.342, 0.0);
         }
	   else if (cNumberNonGaiaPlayers == 4)
	   {
            rmSetPlacementSection(0.1, 0.19);
            rmPlacePlayersCircular(0.375, 0.38, 0.0);
	   }
         else if (cNumberNonGaiaPlayers == 6)
	   {
            rmSetPlacementSection(0.065, 0.215);
            rmPlacePlayersCircular(0.399, 0.405, 0.0);
	   }

	   if (playerSide == 1)
	      rmSetPlacementTeam(1);
	   else
	      rmSetPlacementTeam(0);
	   if (cNumberNonGaiaPlayers == 2)
         {
            rmSetPlacementSection(0.37, 0.4);
            rmPlacePlayersCircular(0.34, 0.342, 0.0);
         }
	   else if (cNumberNonGaiaPlayers == 4)
	   {
            rmSetPlacementSection(0.31, 0.4);
            rmPlacePlayersCircular(0.375, 0.38, 0.0);
	   }
         else if (cNumberNonGaiaPlayers == 6)
	   {
            rmSetPlacementSection(0.285, 0.435);
            rmPlacePlayersCircular(0.399, 0.405, 0.0);
         }
      }
   }
	
// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(120);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, longAvoidImpassableLand);
      rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaMix(id, baseType);
      rmSetAreaWarnFailure(id, false);
   }
   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.20);

// Central barrier range
   // Define base, ridge sizes, clearing size
   int radius = size*0.5;
   int baseRidgeSize = radius*radius*0.235;
   float midRidgeSize = radius*radius*0.135;
   float innerRidgeSize = radius*radius*0.052;
   float midRidgeSize2 = 0;
   float innerRidgeSize2 = 0;
   int clearingSize1 = cNumberNonGaiaPlayers * 25 + 140;
   int clearingSize2 = cNumberNonGaiaPlayers * 30 + 190;
   float greenBaseSize = baseRidgeSize * 2.3;

   // Define locations for passses, ridges
   float yCentral = rmRandFloat(0.4,0.6);
   float nTotalFraction = (1 - yCentral);
   float ySouthPercent = rmRandFloat(0.35,0.65);
   float ySouth = (ySouthPercent*yCentral);
   float yNorth = rmRandFloat(0.7,0.84);
   
   float section1 = ySouth;
   float section2 = (yCentral - ySouth);
   float section3 = (yNorth - yCentral);
   float section4 = (1.0 - yNorth);

   float epicenter1 = ySouth*0.5;
   float epicenter2 = (section2*0.5 + ySouth); 
   float epicenter3 = (section3*0.5 + yCentral);
   float epicenter4 = (section4*0.5 + yNorth);
    
   // snow base for range
   int mountainBaseID = rmCreateArea("mountain base"); 
   rmAddAreaToClass(mountainBaseID, rmClassID("classBase"));
   rmSetAreaLocation(mountainBaseID, 0.45, 0.5); 
   rmAddAreaInfluenceSegment(mountainBaseID, 0.45, 0.0, 0.45, 1.0); 
   rmSetAreaWarnFailure(mountainBaseID, false);
   rmSetAreaSize(mountainBaseID, rmAreaTilesToFraction(baseRidgeSize), rmAreaTilesToFraction(baseRidgeSize));
   rmSetAreaBaseHeight(mountainBaseID, 5.0);
   rmSetAreaElevationType(mountainBaseID, cElevTurbulence);
   rmSetAreaElevationVariation(mountainBaseID, rmRandInt(2,3));
   rmSetAreaHeightBlend(mountainBaseID, 1);
   rmSetAreaCoherence(mountainBaseID, rmRandFloat(0.7,0.8));
   rmSetAreaSmoothDistance(mountainBaseID, rmRandInt(8,12));
   rmSetAreaTerrainType(mountainBaseID, "rockies\groundsnow1_roc");
   rmAddAreaTerrainLayer(mountainBaseID, "rockies\groundsnow8_roc", 0, 3);
   rmAddAreaTerrainLayer(mountainBaseID, "rockies\groundsnow7_roc", 3, 6);
   rmAddAreaTerrainLayer(mountainBaseID, "rockies\groundsnow6_roc", 6, 9);
   rmBuildArea(mountainBaseID);

   // 1st base for east side of range, cover terrain layers
   int eastBaseID = rmCreateArea("east base"); 
   rmAddAreaToClass(eastBaseID, rmClassID("east patch"));
   rmSetAreaWarnFailure(eastBaseID, false);

   rmSetAreaLocation(eastBaseID, 0.59, 0.5); 
   rmAddAreaInfluenceSegment(eastBaseID, 0.59, 0.0, 0.59, 1.0); 
   rmSetAreaSize(eastBaseID, 0.10, 0.10);
   rmSetAreaBaseHeight(eastBaseID, 4);
   rmSetAreaElevationType(eastBaseID, cElevTurbulence);
   rmSetAreaElevationVariation(eastBaseID, 2);
   rmSetAreaHeightBlend(eastBaseID, 1);
   rmSetAreaCoherence(eastBaseID, rmRandFloat(0.5,0.6));
   rmSetAreaSmoothDistance(eastBaseID, rmRandInt(8,12));
   rmSetAreaMix(eastBaseID, "himalayas_b");
   rmBuildArea(eastBaseID);

   // intermediate base for east side of range, cover terrain layers
   int intBaseID = rmCreateArea("intermediate base"); 
   rmAddAreaToClass(intBaseID, rmClassID("east patch"));
   rmSetAreaWarnFailure(intBaseID, false);

   rmSetAreaLocation(intBaseID, 0.55, 0.5); 
   rmAddAreaInfluenceSegment(intBaseID, 0.55, 0.0, 0.55, 1.0); 
   rmSetAreaSize(intBaseID, 0.07, 0.07);
   rmSetAreaBaseHeight(intBaseID, 4.5);
   rmSetAreaElevationType(intBaseID, cElevTurbulence);
   rmSetAreaElevationVariation(intBaseID, 2);
   rmSetAreaHeightBlend(intBaseID, 1);
   rmSetAreaCoherence(intBaseID, rmRandFloat(0.5,0.6));
   rmSetAreaSmoothDistance(intBaseID, rmRandInt(8,12));
   rmSetAreaTerrainType(intBaseID, "himalayas\ground_dirt8_himal");
   rmBuildArea(intBaseID);

   // snow base for east side of range, cover terrain layers
   int snowBase2ID = rmCreateArea("east snow base 2"); 
   rmAddAreaToClass(snowBase2ID, rmClassID("snow patch"));
   rmSetAreaWarnFailure(snowBase2ID, false);
   rmSetAreaLocation(snowBase2ID, 0.525, 0.5); 
   rmAddAreaInfluenceSegment(snowBase2ID, 0.525, 0.0, 0.525, 1.0); 
   rmSetAreaSize(snowBase2ID, 0.085, 0.085);
   rmSetAreaBaseHeight(snowBase2ID, 5.0);
   rmSetAreaElevationType(snowBase2ID, cElevTurbulence);
   rmSetAreaElevationVariation(snowBase2ID, 2);
   rmSetAreaHeightBlend(snowBase2ID, 1);
   rmSetAreaCoherence(snowBase2ID, rmRandFloat(0.6,0.75));
   rmSetAreaSmoothDistance(snowBase2ID, rmRandInt(7,10));
   rmSetAreaMix(snowBase2ID, "rockies_snow");
   rmBuildArea(snowBase2ID);

   int snowBaseID = rmCreateArea("east snow base"); 
   rmAddAreaToClass(snowBaseID, rmClassID("snow patch"));
   rmSetAreaWarnFailure(snowBaseID, false);
   rmSetAreaLocation(snowBaseID, 0.51, 0.5); 
   rmAddAreaInfluenceSegment(snowBaseID, 0.51, 0.0, 0.51, 1.0); 
   rmSetAreaSize(snowBaseID, 0.085, 0.085);
   rmSetAreaBaseHeight(snowBaseID, 5.0);
   rmSetAreaElevationType(snowBaseID, cElevTurbulence);
   rmSetAreaElevationVariation(snowBaseID, 2);
   rmSetAreaHeightBlend(snowBaseID, 1);
   rmSetAreaCoherence(snowBaseID, rmRandFloat(0.8,0.9));
   rmSetAreaSmoothDistance(snowBaseID, rmRandInt(8,12));
   rmSetAreaMix(snowBaseID, "rockies_snow");
   rmBuildArea(snowBaseID);

   // tree area on mt
   int mountainTreeID = rmCreateArea("mountain tree section");
   rmSetAreaSize(mountainTreeID, rmAreaTilesToFraction(midRidgeSize), rmAreaTilesToFraction(midRidgeSize));
   rmAddAreaToClass(mountainTreeID, rmClassID("classBarrierRidge"));
   rmSetAreaLocation(mountainTreeID, 0.45, 0.5);
   rmAddAreaInfluenceSegment(mountainTreeID, 0.45, 0.0, 0.45, 1.05);
   rmSetAreaCoherence(mountainTreeID, 0.8); 
   rmSetAreaBaseHeight(mountainTreeID, 9);
   rmSetAreaElevationType(mountainTreeID, cElevTurbulence);
   rmSetAreaElevationVariation(mountainTreeID, 4.0);
   rmSetAreaHeightBlend(mountainTreeID, 1.3);
   rmSetAreaWarnFailure(mountainTreeID, false);
   rmSetAreaTerrainType(mountainTreeID, "great_lakes\groundforestsnow_gl");
   rmBuildArea(mountainTreeID);

   // Passes
   int forestClearing=rmCreateArea("forest clearing");
   rmSetAreaWarnFailure(forestClearing, false);
   rmSetAreaSize(forestClearing, rmAreaTilesToFraction(clearingSize1), rmAreaTilesToFraction(clearingSize2));
   rmSetAreaLocation(forestClearing, 0.45, yCentral);
   rmAddAreaInfluenceSegment(forestClearing, 0.38, yCentral, 0.52, yCentral);
   rmAddAreaToClass(forestClearing, rmClassID("classClearing"));
   rmSetAreaCoherence(forestClearing, 0.9);
   rmSetAreaTerrainType(forestClearing, "rockies\groundsnow6_roc");
   rmSetAreaBaseHeight(forestClearing, 8);
   rmSetAreaElevationVariation(forestClearing, 2.0);
   rmSetAreaHeightBlend(forestClearing, 2);
   rmBuildArea(forestClearing); 

   int forestClearingS=rmCreateArea("forest clearing south"); 
   rmSetAreaWarnFailure(forestClearingS, false);
   rmSetAreaSize(forestClearingS, rmAreaTilesToFraction(clearingSize1), rmAreaTilesToFraction(clearingSize2));
   rmSetAreaLocation(forestClearingS, 0.45, ySouth);
   rmAddAreaInfluenceSegment(forestClearingS, 0.38, ySouth, 0.52, ySouth);
   rmAddAreaToClass(forestClearingS, rmClassID("classClearing"));
   rmSetAreaCoherence(forestClearingS, 0.9);
   rmSetAreaTerrainType(forestClearingS, "rockies\groundsnow6_roc");
   rmSetAreaBaseHeight(forestClearingS, 8);
   rmSetAreaElevationVariation(forestClearingS, 2.0);
   rmSetAreaHeightBlend(forestClearingS, 2);
   rmBuildArea(forestClearingS); 

   int forestClearingN=rmCreateArea("forest clearing north"); 
   rmSetAreaWarnFailure(forestClearingN, false);
   rmSetAreaSize(forestClearingN, rmAreaTilesToFraction(clearingSize1), rmAreaTilesToFraction(clearingSize2));
   rmSetAreaLocation(forestClearingN, 0.45, yNorth);
   rmAddAreaInfluenceSegment(forestClearingN, 0.38, yNorth, 0.52, yNorth);
   rmAddAreaToClass(forestClearingN, rmClassID("classClearing"));
   rmSetAreaCoherence(forestClearingN, 0.9);
   rmSetAreaTerrainType(forestClearingN, "rockies\groundsnow6_roc");
   rmSetAreaBaseHeight(forestClearingN, 8);
   rmSetAreaElevationVariation(forestClearingN, 2.0);
   rmSetAreaHeightBlend(forestClearingN, 2);
   rmBuildArea(forestClearingN);

   // peaks N mt
   innerRidgeSize2 = innerRidgeSize*section4;
   int mountainNPeaksID = rmCreateArea("mountain N peaks");
   rmSetAreaSize(mountainNPeaksID, rmAreaTilesToFraction(innerRidgeSize2), rmAreaTilesToFraction(innerRidgeSize2));
   rmAddAreaToClass(mountainNPeaksID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainNPeaksID, 0.45, epicenter4);      
   rmAddAreaInfluenceSegment(mountainNPeaksID, 0.45, 1.05, 0.45, yNorth); 
   rmSetAreaCoherence(mountainNPeaksID, 0.8); 
   rmSetAreaSmoothDistance(mountainNPeaksID, 5);
   rmSetAreaBaseHeight(mountainNPeaksID, 17);
   rmSetAreaElevationType(mountainNPeaksID, cElevTurbulence);
   rmSetAreaElevationVariation(mountainNPeaksID, 9.0);
   rmSetAreaHeightBlend(mountainNPeaksID, 1);
   rmAddAreaConstraint(mountainNPeaksID, avoidClearingMt);
   rmSetAreaWarnFailure(mountainNPeaksID, false);
   rmSetAreaTerrainType(mountainNPeaksID, "patagonia\ground_glacier_pat");
   rmBuildArea(mountainNPeaksID);

   // peaks S mt
   innerRidgeSize2 = innerRidgeSize * section1;
   int mountainSPeaksID = rmCreateArea("mountain S peaks");
   rmSetAreaSize(mountainSPeaksID, rmAreaTilesToFraction(innerRidgeSize2), rmAreaTilesToFraction(innerRidgeSize2));
   rmAddAreaToClass(mountainSPeaksID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainSPeaksID, 0.45, epicenter1);
   rmAddAreaInfluenceSegment(mountainSPeaksID, 0.45, 0.0, 0.45, ySouth);
   rmSetAreaCoherence(mountainSPeaksID, 0.8); 
   rmSetAreaSmoothDistance(mountainSPeaksID, 5);
   rmSetAreaBaseHeight(mountainSPeaksID, 17);
   rmSetAreaElevationType(mountainSPeaksID, cElevTurbulence);
   rmSetAreaElevationVariation(mountainSPeaksID, 9.0);
   rmSetAreaHeightBlend(mountainSPeaksID, 1);
   rmAddAreaConstraint(mountainSPeaksID, avoidClearingMt);
   rmSetAreaWarnFailure(mountainSPeaksID, false);
   rmSetAreaTerrainType(mountainSPeaksID, "patagonia\ground_glacier_pat");
   rmBuildArea(mountainSPeaksID);

   // peaks SCent mt
   innerRidgeSize2 = innerRidgeSize * section2;
   int mountainSCPeaksID = rmCreateArea("mountain SC peaks");
   rmSetAreaSize(mountainSCPeaksID, rmAreaTilesToFraction(innerRidgeSize2), rmAreaTilesToFraction(innerRidgeSize2));
   rmAddAreaToClass(mountainSCPeaksID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainSCPeaksID, 0.45, epicenter2);
   rmAddAreaInfluenceSegment(mountainSCPeaksID, 0.45, ySouth, 0.45, yCentral);
   rmSetAreaCoherence(mountainSCPeaksID, 0.8); 
   rmSetAreaSmoothDistance(mountainSCPeaksID, 5);
   rmSetAreaBaseHeight(mountainSCPeaksID, 17);
   rmSetAreaElevationType(mountainSCPeaksID, cElevTurbulence);
   rmSetAreaElevationVariation(mountainSCPeaksID, 9.0);
   rmSetAreaHeightBlend(mountainSCPeaksID, 1);
   rmAddAreaConstraint(mountainSCPeaksID, avoidClearingMt);
   rmSetAreaWarnFailure(mountainSCPeaksID, false);
   rmSetAreaTerrainType(mountainSCPeaksID, "patagonia\ground_glacier_pat");
   rmBuildArea(mountainSCPeaksID);

   // peaks NCent mt
   innerRidgeSize2 = innerRidgeSize * section3;
   int mountainNCPeaksID = rmCreateArea("mountain NC peaks");
   rmSetAreaSize(mountainNCPeaksID, rmAreaTilesToFraction(innerRidgeSize2), rmAreaTilesToFraction(innerRidgeSize2));
   rmAddAreaToClass(mountainNCPeaksID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainNCPeaksID, 0.45, epicenter3);      
   rmAddAreaInfluenceSegment(mountainNCPeaksID, 0.45, yCentral, 0.45, yNorth); 
   rmSetAreaCoherence(mountainNCPeaksID, 0.8); 
   rmSetAreaSmoothDistance(mountainNCPeaksID, 5);
   rmSetAreaBaseHeight(mountainNCPeaksID, 17);
   rmSetAreaElevationType(mountainNCPeaksID, cElevTurbulence);
   rmSetAreaElevationVariation(mountainNCPeaksID, 9.0);
   rmSetAreaHeightBlend(mountainNCPeaksID, 1);
   rmAddAreaConstraint(mountainNCPeaksID, avoidClearingMt);
   rmSetAreaWarnFailure(mountainNCPeaksID, false);
   rmSetAreaTerrainType(mountainNCPeaksID, "patagonia\ground_glacier_pat");
   rmBuildArea(mountainNCPeaksID);

   // end range patches to prevent spaces
   int mountainpatchID = rmCreateArea("mountain patch");
   rmSetAreaSize(mountainpatchID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(120));
   rmAddAreaToClass(mountainpatchID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainpatchID, 0.45, 0.004);
   rmSetAreaCoherence(mountainpatchID, 0.99);
   rmSetAreaTerrainType(mountainpatchID, "patagonia\ground_glacier_pat");
   rmBuildArea(mountainpatchID);
 
   int mountainpatch2ID = rmCreateArea("mountain patch 2");
   rmSetAreaSize(mountainpatch2ID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(120));
   rmAddAreaToClass(mountainpatch2ID, rmClassID("classMountain"));
   rmSetAreaLocation(mountainpatch2ID, 0.45, 0.996);
   rmSetAreaCoherence(mountainpatch2ID, 0.99);
   rmSetAreaTerrainType(mountainpatch2ID, "patagonia\ground_glacier_pat");
   rmBuildArea(mountainpatch2ID); 

   // Text
   rmSetStatusText("",0.25);

// More green terrain west of mountains
   int WestGreenBaseID = rmCreateArea("west green base"); 
   rmAddAreaToClass(WestGreenBaseID, rmClassID("green patch"));
   rmSetAreaLocation(WestGreenBaseID, 0.15, 0.5); 
   rmAddAreaInfluenceSegment(WestGreenBaseID, 0.15, 0.0, 0.15, 1.0); 
   rmSetAreaWarnFailure(WestGreenBaseID, false);
   rmSetAreaSize(WestGreenBaseID, 0.325, 0.325);
   rmSetAreaCoherence(WestGreenBaseID, 0.9);
   rmSetAreaSmoothDistance(WestGreenBaseID, rmRandInt(8,12));
   rmAddAreaConstraint(WestGreenBaseID, avoidBaseShort);
   rmSetAreaMix(WestGreenBaseID, "borneo_grass_a");
   rmBuildArea(WestGreenBaseID);

// Trade Routes
   variantChance = rmRandInt(1,2);

   int tradeRouteID4A = rmCreateTradeRoute();
   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.23, 0.95);
   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.26, 0.8);
   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.28, 0.7);
   if (variantChance == 1)
   {
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.24, 0.6);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.28, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.24, 0.4);
   }
   else
   {
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.23, 0.55);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.26, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.23, 0.45);
   }
   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.28, 0.3);
   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.26, 0.22);
   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.23, 0.05);
   rmBuildTradeRoute(tradeRouteID4A, "water");

   // Text
   rmSetStatusText("",0.30);

// Trade sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 7.0);
   variantChance = rmRandInt(1,2);

   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4A);
   if (socketPattern == 1)  // 4 sockets per route
   {
      vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.87);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.66);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.34);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.13);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else if (socketPattern == 2)  // 3 sockets per route
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.87);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.13);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else  // 2 sockets per route
   {
	if (variantChance == 1)
	{
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.23);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.77);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else
	{
         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.68);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

         socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.32);
         rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }

   //Text
   rmSetStatusText("",0.35);

// Starting TCs and units 	
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 5.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);
   rmAddObjectDefConstraint(startingUnits, avoidBase);

   int startingTCID= rmCreateObjectDef("startingTC");
   rmSetObjectDefMaxDistance(startingTCID, 10.0);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
   rmAddObjectDefConstraint(startingTCID, avoidBase);                
   if ( rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }

   // Silver mines - players
   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerGoldID=rmCreateObjectDef("player silver closer");
   rmAddObjectDefItem(playerGoldID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(playerGoldID, avoidAll);
   rmSetObjectDefMinDistance(playerGoldID, 9.0);
   rmSetObjectDefMaxDistance(playerGoldID, 18.0);
//   rmPlaceObjectDefPerPlayer(playerGoldID, false, 1);

   // Regicide objects
   int playerCastle=rmCreateObjectDef("Castle");
   rmAddObjectDefItem(playerCastle, "ypCastleRegicide", 1, 0.0);
   rmAddObjectDefToClass(playerCastle, rmClassID("importantItem"));
   rmAddObjectDefConstraint(playerCastle, avoidAll);
   rmAddObjectDefConstraint(playerCastle, avoidImpassableLand);
   rmSetObjectDefMinDistance(playerCastle, 16.0);	
   rmSetObjectDefMaxDistance(playerCastle, 21.0);
  
   int playerWalls = rmCreateGrouping("regicide walls", "regicide_walls");
   rmAddGroupingConstraint(playerWalls, wallEdgeConstraint);
   rmSetGroupingMinDistance(playerWalls, 0.0);
   rmSetGroupingMaxDistance(playerWalls, 4.0);
 
   int playerDaimyo=rmCreateObjectDef("Daimyo"+i);
   rmAddObjectDefItem(playerDaimyo, "ypDaimyoRegicide", 1, 0.0);
   rmAddObjectDefToClass(playerDaimyo, rmClassID("importantItem"));
   rmAddObjectDefConstraint(playerDaimyo, avoidAll);
   rmAddObjectDefConstraint(playerDaimyo, avoidImportantItemSmall);
   rmSetObjectDefMinDistance(playerDaimyo, 7.0);	
   rmSetObjectDefMaxDistance(playerDaimyo, 10.0);

   for(i=1; <cNumberPlayers)
   {	
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      if(ypIsAsian(i) && rmGetNomadStart() == false)
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(playerDaimyo, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceGroupingAtLoc(playerWalls, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      rmPlaceObjectDefAtLoc(playerGoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc))); 
      rmPlaceObjectDefAtLoc(playerCastle, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc))); 
   }
   
   // Text
   rmSetStatusText("",0.40);

    // Place random flags
    int avoidFlags = rmCreateTypeDistanceConstraint("flags avoid flags", "ControlFlag", 70);
    for ( i =1; <13 ) {
    int flagID = rmCreateObjectDef("random flag"+i);
    rmAddObjectDefItem(flagID, "ControlFlag", 1, 0.0);
    rmSetObjectDefMinDistance(flagID, 0.0);
    rmSetObjectDefMaxDistance(flagID, rmXFractionToMeters(0.40));
    rmAddObjectDefConstraint(flagID, avoidFlags);
    rmPlaceObjectDefAtLoc(flagID, 0, 0.5, 0.5);
    }

// KOTH game mode 
   if(rmGetIsKOTH())
   {
      float xLoc = rmRandFloat(0.08,0.19);
      float yLoc = 0.5;
      float walk = 0.05;
      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
   }

// NATIVE VILLAGES
   // Village A - East of mts
   int villageAID = -1;
   int whichNative = rmRandInt(1,2);
   int villageType = rmRandInt(1,5);

   villageAID = rmCreateGrouping("village A", native1Name+villageType);
   rmAddGroupingToClass(villageAID, rmClassID("natives"));
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, size*0.08);
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRoute);
   if (cNumberNonGaiaPlayers < 4)
   {
      rmAddGroupingConstraint(villageAID, avoidNativesMed2);
      rmAddGroupingConstraint(villageAID, playerConstraint);
   }
   else
   {
      rmAddGroupingConstraint(villageAID, avoidNativesMed);
      rmAddGroupingConstraint(villageAID, longPlayerConstraint);
   }
   rmAddGroupingConstraint(villageAID, playerEdgeConstraint);
   rmAddGroupingConstraint(villageAID, avoidBarrier);

   // Village D - West of mts
   int villageDID = -1;
   villageType = rmRandInt(1,5);

   villageDID = rmCreateGrouping("village D", native2Name+villageType);
   rmAddGroupingToClass(villageDID, rmClassID("natives"));
   rmAddGroupingToClass(villageDID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageDID, 0.0);
   rmSetGroupingMaxDistance(villageDID, size*0.1);
   rmAddGroupingConstraint(villageDID, avoidKOTH);
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRoute);
   rmAddGroupingConstraint(villageDID, avoidNativesMed);
   rmAddGroupingConstraint(villageDID, playerEdgeConstraint);
   rmAddGroupingConstraint(villageDID, avoidBarrier);

   // Text
   rmSetStatusText("",0.45);

// Placement of Natives
   // East
   if (cNumberNonGaiaPlayers == 2)
   {
	if (rmRandInt(1,2) == 1)
        rmPlaceGroupingAtLoc(villageAID, 0, 0.69, 0.5);
	else
        rmPlaceGroupingAtLoc(villageAID, 0, 0.89, 0.5);
   }
   else if (cNumberNonGaiaPlayers > 5)
   {
	if (rmRandInt(1,2) == 1)
	{
         rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.66);
         rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.34);
	}
	else
	{
         rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.69);
         rmPlaceGroupingAtLoc(villageAID, 0, 0.72, 0.5);
         rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.31);
	}
   }
   else	
   {
      rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.645);
      rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.355);
   }
   
   // West
   if (nativeSetup == 1)
   {
      rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.62);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.38);
   }
   else if (nativeSetup == 2)
   {
      rmPlaceGroupingAtLoc(villageDID, 0, 0.2, 0.72);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.2, 0.28);
   }
   else if (nativeSetup == 3)
   {
      rmPlaceGroupingAtLoc(villageDID, 0, 0.23, 0.78);
      rmPlaceGroupingAtLoc(villageDID, 0, 0.23, 0.22);
   }
   if (cNumberNonGaiaPlayers > 4)
	rmPlaceGroupingAtLoc(villageDID, 0, 0.3, 0.5);

   // Text
   rmSetStatusText("",0.50);

// more resources
   // start area trees 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, treeType, 2, 2.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 8);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 15);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
   rmPlaceObjectDefPerPlayer(StartAreaTreeID, false, 4);

   // berry bushes
   int berryNum = rmRandInt(2,5);
   int StartBerryBushID=rmCreateObjectDef("starting berry bush");
   rmAddObjectDefItem(StartBerryBushID, "BerryBush", rmRandInt(2,3), 4.0);
   rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
   rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartBerryBushID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(StartBerryBushID, avoidBarrier);
   rmAddObjectDefConstraint(StartBerryBushID, avoidAll);
   rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);

   rmAddObjectDefItem(StartBerryBushID, "BerryBush", 2, 5.0);
   rmAddObjectDefConstraint(StartBerryBushID, Westward);
   rmAddObjectDefConstraint(StartBerryBushID, avoidKOTH);
   rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);
   rmPlaceObjectDefInArea(StartBerryBushID, 0, rmAreaID("west green base"), 3);

   // Text
   rmSetStatusText("",0.55);

   // start area huntable
   int deerNum = rmRandInt(5,6);
   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, deerNum, 5.0);
   rmAddObjectDefToClass(startPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(startPronghornID, 14);
   rmSetObjectDefMaxDistance(startPronghornID, 20);
   rmAddObjectDefConstraint(startPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, true);
   rmPlaceObjectDefPerPlayer(startPronghornID, false, 1);

// Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(playerNuggetID, 35.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 45.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
   rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
   for(i=1; <cNumberPlayers)
   {
 	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

   // Text
   rmSetStatusText("",0.60);

// Random Nuggets
   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget2, 75.0);
   rmSetObjectDefMaxDistance(nugget2, size*0.5);
   rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, avoidSocket);
   rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget2, playerEdgeConstraint);
   rmAddObjectDefConstraint(nugget2, avoidBarrier);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmAddObjectDefConstraint(nugget2, avoidKOTH);
   rmPlaceObjectDefPerPlayer(nugget2, false, 1);

   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget3, 90.0);
   rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, avoidSocket);
   rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget3, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget3, playerEdgeConstraint);
   rmAddObjectDefConstraint(nugget3, avoidBarrier);
   rmAddObjectDefConstraint(nugget3, Westward);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmAddObjectDefConstraint(nugget3, avoidKOTH);
   if (cNumberNonGaiaPlayers < 7) 
      rmPlaceObjectDefInArea(nugget3, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers);
   else
      rmPlaceObjectDefInArea(nugget3, 0, rmAreaID("west green base"), 6);

   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
   rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, avoidSocket);
   rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget4, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget4, playerEdgeConstraint);
   rmAddObjectDefConstraint(nugget4, avoidBarrier);
   rmAddObjectDefConstraint(nugget4, Westward);
   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmAddObjectDefConstraint(nugget4, avoidKOTH);

   if (cNumberNonGaiaPlayers < 6) 
      rmPlaceObjectDefInArea(nugget4, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers);
   else
      rmPlaceObjectDefInArea(nugget4, 0, rmAreaID("west green base"), 5);
   
   rmSetObjectDefMaxDistance(nugget2, size);
   rmAddObjectDefConstraint(nugget2, Westward);
   if (cNumberNonGaiaPlayers < 5) 
      rmPlaceObjectDefInArea(nugget2, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers);
   else
      rmPlaceObjectDefInArea(nugget2, 0, rmAreaID("west green base"), 4);

   // Text
   rmSetStatusText("",0.65);

   // second huntable
   int deer2Num = rmRandInt(4,6);
   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deer2Type, deer2Num, 5.0);
   rmAddObjectDefToClass(farPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farPronghornID, 42.0);
   rmSetObjectDefMaxDistance(farPronghornID, 60.0);
   rmAddObjectDefConstraint(farPronghornID, mediumPlayerConstraint);
   rmAddObjectDefConstraint(farPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farPronghornID, avoidNativesShort);
   rmAddObjectDefConstraint(farPronghornID, huntableConstraint);
   rmAddObjectDefConstraint(farPronghornID, avoidBarrier);
   rmAddObjectDefConstraint(farPronghornID, avoidAll);
   rmAddObjectDefConstraint(farPronghornID, Eastward);
   rmSetObjectDefCreateHerd(farPronghornID, true);
   rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);

   // Text
   rmSetStatusText("",0.70);

// Forests
   int failCount=0;
   int forestChance = -1;
   int numTries=4*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers > 3)
      numTries=4*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 5)
      numTries=3*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 6)
      numTries=2*cNumberNonGaiaPlayers;   
   
   // East forest - Himalayas
   failCount=0;
   for (i=0; <numTries)
   {
      forestChance = rmRandInt(1,4);
      int forest=rmCreateArea("forest east "+i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(140), rmAreaTilesToFraction(200));
      rmSetAreaForestType(forest, forestType);
      rmSetAreaForestDensity(forest, rmRandFloat(0.5,0.8));
      rmSetAreaForestClumpiness(forest, rmRandFloat(0.5,0.6));
      rmSetAreaForestUnderbrush(forest, rmRandFloat(0.0,0.5));
      rmSetAreaCoherence(forest, rmRandFloat(0.4,0.6));
      rmSetAreaSmoothDistance(forest, rmRandInt(10,15));
      if (forestChance == 3)
      {
		rmSetAreaMinBlobs(forest, 1);
		rmSetAreaMaxBlobs(forest, 3);					
		rmSetAreaMinBlobDistance(forest, 10.0);
		rmSetAreaMaxBlobDistance(forest, 18.0);
	}
      if (forestChance == 4)
      {
		rmSetAreaMinBlobs(forest, 3);
		rmSetAreaMaxBlobs(forest, 5);					
		rmSetAreaMinBlobDistance(forest, 14.0);
		rmSetAreaMaxBlobDistance(forest, 24.0);
		rmSetAreaSmoothDistance(forest, 20);
	}
      rmAddAreaToClass(forest, rmClassID("classForest")); 
	rmAddAreaConstraint(forest, playerConstraint);
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidAll); 
      rmAddAreaConstraint(forest, avoidKOTH); 
	rmAddAreaConstraint(forest, avoidCoin);  
	rmAddAreaConstraint(forest, avoidBarrier);
	rmAddAreaConstraint(forest, avoidBase);
      rmAddAreaConstraint(forest, avoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
	rmAddAreaConstraint(forest, avoidStartingUnits);
	rmAddAreaConstraint(forest, avoidSocket);
	rmAddAreaConstraint(forest, Eastmost);
	rmAddAreaConstraint(forest, patchConstraint);
	rmAddAreaConstraint(forest, avoidNativesShort);

      if(rmBuildArea(forest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==5)
            break;
      }
      else
         failCount=0; 
   } 

   // Text
   rmSetStatusText("",0.75);
/* ===============================================================
   // Center forest - snow covered
   numTries=3*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 3)
      numTries=2*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers > 6)
      numTries=cNumberNonGaiaPlayers;    
   failCount=0;
   for (i=0; <numTries)
   {
      forestChance = rmRandInt(1,4);
      int CenterForest=rmCreateArea(("forest center "+i), rmAreaID("east snow base"));
      rmSetAreaWarnFailure(CenterForest, false);
      rmSetAreaSize(CenterForest, rmAreaTilesToFraction(140), rmAreaTilesToFraction(200));
      rmSetAreaForestType(CenterForest, "Yukon Snow Forest");
      rmSetAreaForestDensity(CenterForest, rmRandFloat(0.5,0.8));
      rmSetAreaForestClumpiness(CenterForest, rmRandFloat(0.5,0.7));
      rmSetAreaForestUnderbrush(CenterForest, rmRandFloat(0.0,0.5));
      rmSetAreaCoherence(CenterForest, rmRandFloat(0.4,0.7));
      rmSetAreaSmoothDistance(CenterForest, rmRandInt(10,15));
      if (forestChance == 3)
      {
		rmSetAreaMinBlobs(CenterForest, 2);
		rmSetAreaMaxBlobs(CenterForest, 3);					
		rmSetAreaMinBlobDistance(CenterForest, 10.0);
		rmSetAreaMaxBlobDistance(CenterForest, 18.0);
	}
      if (forestChance == 4)
      {
		rmSetAreaMinBlobs(CenterForest, 3);
		rmSetAreaMaxBlobs(CenterForest, 5);					
		rmSetAreaMinBlobDistance(CenterForest, 14.0);
		rmSetAreaMaxBlobDistance(CenterForest, 24.0);
		rmSetAreaSmoothDistance(CenterForest, 20);
	}
      rmAddAreaToClass(CenterForest, rmClassID("classForest")); 
	rmAddAreaConstraint(CenterForest, playerConstraint);
      rmAddAreaConstraint(CenterForest, forestConstraint);
      rmAddAreaConstraint(CenterForest, avoidAll);
      rmAddAreaConstraint(CenterForest, avoidKOTH); 
	rmAddAreaConstraint(CenterForest, avoidCoin);  
	rmAddAreaConstraint(CenterForest, avoidBarrier);
	rmAddAreaConstraint(CenterForest, avoidBaseMed);
      rmAddAreaConstraint(CenterForest, avoidImpassableLand); 
      rmAddAreaConstraint(CenterForest, avoidTradeRoute);
	rmAddAreaConstraint(CenterForest, avoidStartingUnits);
	rmAddAreaConstraint(CenterForest, avoidSocket);
	rmAddAreaConstraint(CenterForest, Eastward);
	rmAddAreaConstraint(CenterForest, patchConstraint);
	rmAddAreaConstraint(CenterForest, avoidNativesShort);

      if(rmBuildArea(CenterForest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==5)
            break;
      }
      else
         failCount=0; 
   }
========================================================================================= */
   numTries=6*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 3)
      numTries=5*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 5)
      numTries=4*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 6)
      numTries=3*cNumberNonGaiaPlayers; 

   // West forest - Shangri La
   failCount=0;
   for (i=0; <numTries)
   {
      forestChance = rmRandInt(1,4);
      int WestForest=rmCreateArea("forest west "+i);
      rmSetAreaWarnFailure(WestForest, false);
      rmSetAreaSize(WestForest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(280));
      rmSetAreaForestType(WestForest, "Borneo Canopy Forest");
      rmSetAreaForestDensity(WestForest, rmRandFloat(0.7,1.0));
      rmSetAreaForestClumpiness(WestForest, rmRandFloat(0.5,0.9));
      rmSetAreaForestUnderbrush(WestForest, rmRandFloat(0.0,0.5));
      rmSetAreaCoherence(WestForest, rmRandFloat(0.4,0.7));
      rmSetAreaSmoothDistance(WestForest, rmRandInt(10,20));
      if (forestChance == 3)
      {
		rmSetAreaMinBlobs(WestForest, 2);
		rmSetAreaMaxBlobs(WestForest, 3);					
		rmSetAreaMinBlobDistance(WestForest, 12.0);
		rmSetAreaMaxBlobDistance(WestForest, 24.0);
	}
      if (forestChance == 4)
      {
		rmSetAreaMinBlobs(WestForest, 3);
		rmSetAreaMaxBlobs(WestForest, 5);					
		rmSetAreaMinBlobDistance(WestForest, 16.0);
		rmSetAreaMaxBlobDistance(WestForest, 28.0);
		rmSetAreaSmoothDistance(WestForest, 20);
	}
      rmAddAreaToClass(WestForest, rmClassID("classForest")); 
      rmAddAreaConstraint(WestForest, forestConstraint);
      rmAddAreaConstraint(WestForest, avoidAll); 
      rmAddAreaConstraint(WestForest, avoidKOTH); 
	rmAddAreaConstraint(WestForest, avoidCoin);  
	rmAddAreaConstraint(WestForest, avoidBarrierMed);
	rmAddAreaConstraint(WestForest, avoidBaseMed);
      rmAddAreaConstraint(WestForest, avoidImpassableLand); 
      rmAddAreaConstraint(WestForest, avoidTradeRoute);
	rmAddAreaConstraint(WestForest, avoidSocket);
	rmAddAreaConstraint(WestForest, Westward);
	rmAddAreaConstraint(WestForest, patchConstraint);
	rmAddAreaConstraint(WestForest, avoidNativesShort);

      if(rmBuildArea(WestForest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==5)
            break;
      }
      else
         failCount=0; 
   }

   // Text
   rmSetStatusText("",0.80);

// Extra gold mines - west of the mountains.
   silverType = rmRandInt(1,10);
   int extraGoldID = rmCreateObjectDef("extra gold "+i);
   rmAddObjectDefItem(extraGoldID, "minegold", 1, 0);
   rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraGoldID, avoidSocket);
   rmAddObjectDefConstraint(extraGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraGoldID, avoidBarrier);
   rmAddObjectDefConstraint(extraGoldID, avoidAll);
   rmAddObjectDefConstraint(extraGoldID, avoidKOTH);
   rmAddObjectDefConstraint(extraGoldID, Westward);
   rmSetObjectDefMinDistance(extraGoldID, 25.0);
   rmSetObjectDefMaxDistance(extraGoldID, 100.0);
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.2, 0.2, 1);
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.3, 0.4, rmRandInt(1,2));
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.2, 0.6, rmRandInt(1,2));
   rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.3, 0.8, 1);
   if (cNumberNonGaiaPlayers > 2)
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.15, 0.5, 1);
   }
   if (cNumberNonGaiaPlayers > 4)
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.4, 0.3, 1);
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.4, 0.7, 1);
   }
   if (cNumberNonGaiaPlayers > 6)
   {
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.4, 0.1, 1);
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.4, 0.9, 1);
   }
   rmPlaceObjectDefInArea(extraGoldID, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers);

   // Text
   rmSetStatusText("",0.85);

// West herds
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, centerHerdType, rmRandInt(7,9), 6.0);
   rmAddObjectDefToClass(centralHerdID, rmClassID("huntableFood"));
   rmSetObjectDefCreateHerd(centralHerdID, true);
   rmSetObjectDefMinDistance(centralHerdID, 0);
   rmSetObjectDefMaxDistance(centralHerdID, 14);
   rmAddObjectDefConstraint(centralHerdID, avoidBarrier);
   rmAddObjectDefConstraint(centralHerdID, Westward);
   // herds by passes
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.36, yCentral, 1);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.36, yNorth, 1);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.36, ySouth, 1);

   int farHuntableID=rmCreateObjectDef("far huntable");
   rmAddObjectDefItem(farHuntableID, deer3Type, rmRandInt(5,9), 6.0);
   rmAddObjectDefToClass(farHuntableID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farHuntableID, 0.3*size);
   rmSetObjectDefMaxDistance(farHuntableID, 0.8*size);
   rmAddObjectDefConstraint(farHuntableID, avoidTradeRoute);
   rmAddObjectDefConstraint(farHuntableID, avoidImportantItem);
   rmAddObjectDefConstraint(farHuntableID, fartherPlayerConstraint);
   rmAddObjectDefConstraint(farHuntableID, longHuntableConstraint);
   rmAddObjectDefConstraint(farHuntableID, avoidAll);
   rmAddObjectDefConstraint(farHuntableID, avoidKOTH);
   rmAddObjectDefConstraint(farHuntableID, avoidBarrier);
   rmAddObjectDefConstraint(farHuntableID, Westward);
   rmSetObjectDefCreateHerd(farHuntableID, true);
   rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);

   // more central herds
   rmSetObjectDefMinDistance(centralHerdID, 20);
   rmSetObjectDefMaxDistance(centralHerdID, 0.25*size);
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, farPlayerConstraint);
   rmAddObjectDefConstraint(centralHerdID, longHuntableConstraint);
   rmAddObjectDefConstraint(centralHerdID, avoidKOTH);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.25, 0.25, cNumberNonGaiaPlayers);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.25, 0.75, cNumberNonGaiaPlayers);

// Sheep etc
   int sheepID=rmCreateObjectDef("herdable animal");
   rmAddObjectDefItem(sheepID, sheepType, 2, 4.0);
   rmAddObjectDefToClass(sheepID, rmClassID("herdableFood"));
   rmSetObjectDefMinDistance(sheepID, 40.0);
   rmSetObjectDefMaxDistance(sheepID, 0.2*longSide);
   rmAddObjectDefConstraint(sheepID, avoidSheep);
   rmAddObjectDefConstraint(sheepID, avoidAll);
   rmAddObjectDefConstraint(sheepID, playerConstraint);
   rmAddObjectDefConstraint(sheepID, avoidBarrier);
   rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
   rmAddObjectDefConstraint(sheepID, Eastward);
   rmPlaceObjectDefPerPlayer(sheepID, false, 2);

   int sheep2ID=rmCreateObjectDef("west herdable animal");
   if (sheepChance == 1)
      rmAddObjectDefItem(sheep2ID, "ypGoat", 2, 4.0);
   else 
      rmAddObjectDefItem(sheep2ID, "ypWaterBuffalo", 2, 4.0);
   rmAddObjectDefToClass(sheep2ID, rmClassID("herdableFood"));
   rmAddObjectDefConstraint(sheep2ID, avoidSheep);
   rmAddObjectDefConstraint(sheep2ID, avoidAll);
   rmAddObjectDefConstraint(sheep2ID, avoidKOTH);
   rmAddObjectDefConstraint(sheep2ID, playerConstraint);
   rmAddObjectDefConstraint(sheep2ID, avoidBarrier);
   rmAddObjectDefConstraint(sheep2ID, avoidImpassableLand);
   rmAddObjectDefConstraint(sheep2ID, Westward);
   rmPlaceObjectDefInArea(sheep2ID, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers*2);
   if (cNumberNonGaiaPlayers < 4)
      rmPlaceObjectDefInArea(sheep2ID, 0, rmAreaID("west green base"), 2);

   // Text
   rmSetStatusText("",0.90);

   // mountain trees
   int ridgeTree=rmCreateObjectDef("ridge trees");
   rmAddObjectDefConstraint(ridgeTree, avoidClearing);
   rmAddObjectDefConstraint(ridgeTree, WestMtTrees);
   int numTrees = size/2.5;
   rmAddObjectDefItem(ridgeTree, "TreeRockiesSnow", 1, 0.0);
   rmPlaceObjectDefInArea(ridgeTree, 0, mountainBaseID, numTrees);
   numTrees = size/3;
   rmPlaceObjectDefInArea(ridgeTree, 0, mountainTreeID, numTrees);

// Random trees
   int StragglerTreeID=rmCreateObjectDef("stragglers in east");
   rmAddObjectDefItem(StragglerTreeID, treeType, 1, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(StragglerTreeID, avoidClearing);
   rmPlaceObjectDefInArea(StragglerTreeID, 0, rmAreaID("intermediate base"), cNumberNonGaiaPlayers*4);

   rmAddObjectDefConstraint(StragglerTreeID, patchConstraint);
   rmAddObjectDefConstraint(StragglerTreeID, avoidBarrier);
   rmAddObjectDefConstraint(StragglerTreeID, avoidBase);
   rmAddObjectDefConstraint(StragglerTreeID, Eastmost);
   rmSetObjectDefMinDistance(StragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, longSide*0.5);
   for(i=0; <cNumberNonGaiaPlayers*6)
      rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.85, 0.5);

   int ECStragglerTreeID=rmCreateObjectDef("stragglers in east center");
   rmAddObjectDefItem(ECStragglerTreeID, "TreeYukonSnow", 1, 0.0);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(ECStragglerTreeID, patchConstraint);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidMtsShort);
   rmAddObjectDefConstraint(ECStragglerTreeID, avoidClearing);
   rmAddObjectDefConstraint(ECStragglerTreeID, Eastward);
   rmSetObjectDefMinDistance(ECStragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(ECStragglerTreeID, longSide*0.5);
   rmPlaceObjectDefInArea(ECStragglerTreeID, 0, rmAreaID("east snow base"), cNumberNonGaiaPlayers*5);
   rmPlaceObjectDefInArea(ECStragglerTreeID, 0, rmAreaID("east snow base 2"), cNumberNonGaiaPlayers*5);

   int WestStragglerTreeID=rmCreateObjectDef("stragglers in west");
   rmAddObjectDefItem(WestStragglerTreeID, "ypTreeBorneoCanopy", 1, 0.0);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidKOTH);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(WestStragglerTreeID, patchConstraint);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidBarrier);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidBaseMed);
   rmAddObjectDefConstraint(WestStragglerTreeID, avoidClearing);
   rmAddObjectDefConstraint(WestStragglerTreeID, Westward);
   rmPlaceObjectDefInArea(WestStragglerTreeID, 0, rmAreaID("west green base"), cNumberNonGaiaPlayers*7);

   // Text
   rmSetStatusText("",0.95);

// Deco
   int avoidEagles=rmCreateTypeDistanceConstraint("avoids Eagles", "EaglesNest", 50.0);
   int randomEagleTreeID=rmCreateObjectDef("random eagle tree");
   rmAddObjectDefItem(randomEagleTreeID, "EaglesNest", 1, 0.0);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidAll);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidKOTH);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidMtsShort);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidClearing);
   rmAddObjectDefConstraint(randomEagleTreeID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(randomEagleTreeID, avoidEagles);
   rmPlaceObjectDefInArea(randomEagleTreeID, 0, rmAreaID("east snow base"), 2);
   rmPlaceObjectDefInArea(randomEagleTreeID, 0, rmAreaID("mountain tree section"), rmRandInt(1,2));

   int avoidProp=rmCreateTypeDistanceConstraint("avoids prop", "PropKingfisher", 70.0);
   int specialPropID=rmCreateObjectDef("kingfisher prop");
   rmAddObjectDefItem(specialPropID, "PropKingfisher", 1, 0.0);
   rmAddObjectDefConstraint(specialPropID, avoidAll);
   rmAddObjectDefConstraint(specialPropID, avoidKOTH);
   rmAddObjectDefConstraint(specialPropID, avoidBaseMed);
   rmAddObjectDefConstraint(specialPropID, avoidProp);
   rmAddObjectDefConstraint(specialPropID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(specialPropID, avoidImportantItem);
   rmPlaceObjectDefInArea(specialPropID, 0, rmAreaID("west green base"), 2);

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

   // Text
   rmSetStatusText("",0.99);
}  

  
