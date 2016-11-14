// Gandalf's Random Land Map - TAD 
// a random map for AOE3: TAD
// by RF_Gandalf

include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";
include "mercenaries.xs";

void main(void)
{  
   // Text
   rmSetStatusText("",0.01);

// Set up for variables
   string baseType = "";
   string pondType = "";
   string cliffType = "";
   string forestType = "";
   string forest2Type = "";
   string riverType = "";
   string treeType = "";
   string deerType = "";
   string deer2Type = "";
   string sheepType = "";
   string centerHerdType = "";
   string fishType = "";
   string native1Name = "";
   string native2Name = "";
   string patchMixType = "";
   string mineType = "";
   string tradeRouteType1 = "";
   string tradeRouteType2 = "";
 
// Pick pattern for trees, terrain, features, etc.
   int patternChance = rmRandInt(29,37); 
   int variantChance = rmRandInt(1,2);
   int lightingChance = rmRandInt(1,2);
   int axisChance = rmRandInt(1,2);
   int playerSide = rmRandInt(1,2);   
   int positionChance = rmRandInt(1,2);   
   int distChance = rmRandInt(1,4);
   int sectionChance = rmRandInt(1,3);
   int ffaChance = rmRandInt(1,4);
   int trPattern = rmRandInt(0,11);
   int socketPattern = rmRandInt(1,2);   
   int nativeSetup = rmRandInt(0,22);
   if (cNumberNonGaiaPlayers > 5)
   {
	if ((nativeSetup == 10) || (nativeSetup == 11))   
	{
	   if (rmRandInt(1,2) == 2)
		nativeSetup = rmRandInt(12,22);
	   else
            nativeSetup = rmRandInt(0,9);
	}
	if ((trPattern == 2) || (trPattern == 3))   
	{
	   if (rmRandInt(1,17) < 8)
		nativeSetup = rmRandInt(16,22);
	   else
            nativeSetup = rmRandInt(0,9);
	}	   
   }
   else
   {
	if ((trPattern == 2) || (trPattern == 3))   
	{
	   if (rmRandInt(1,17) < 8)
		nativeSetup = rmRandInt(16,22);
	   else
            nativeSetup = rmRandInt(0,9);
	}
	if ((trPattern == 8) || (trPattern == 9))   
	{
         nativeSetup = rmRandInt(0,20);
	}
   }
   int nativePattern = -1;
   int nativeChoice = rmRandInt(1,2);
   int nativeNumber = rmRandInt(2,6);
   int endPosition = rmRandInt(1,3);
   int sidePosition = rmRandInt(1,3);
   int sheepChance = rmRandInt(1,2);
   int featureChance = rmRandInt(1,10);
   int cliffChance = rmRandInt(1,10);
   int makeCliffs = -1; 
   int cliffVariety = rmRandInt(0,5);
   int bareCliffs = -1;
   int makeLake = -1;
   int makePonds = -1;
   int makeIce = -1;
   int makeRiver = -1;
   int centerMt = -1;
   int forestMt = -1;
   int makeCentralHighlands = -1;
   int makeCentralCanyon = -1;
   int vultures = -1;
   int eagles = -1;
   int plainsMap = -1;
   int tropicalMap = -1;
   int hillTrees = -1;
   int placeBerries = 1;
   int berryNum = rmRandInt(2,3);
   if (cNumberNonGaiaPlayers > 5)
	berryNum = rmRandInt(4,6);
   else if (cNumberNonGaiaPlayers > 3)
	berryNum = rmRandInt(3,4);
   int reducedForest = -1;
   int mtPattern = rmRandInt(1,4);
   int extendCenter = rmRandInt(0,2);
   int lakePos = rmRandInt(0,3);
   int clearCenter = -1;
   int clearCenterChance = -1;
   int makeCentralForestPatch = -1;
   int forestDist = rmRandInt(12,18);
   if (cNumberNonGaiaPlayers < 5)
	forestDist = rmRandInt(11,16);
   int forSize = rmRandInt(1,3);
   int twoChoice = rmRandInt(1,2);
   int threeChoice = rmRandInt(1,3);
   int fourChoice = rmRandInt(1,4);
   int fiveChoice = rmRandInt(1,5);
   int sixChoice = rmRandInt(1,6);
   int placeGold = rmRandInt(1,5);
   int coverUp = 0;
   int forestCoverUp = 0; 
   int specialPatch = 0;
   int noCliffForest = 0;
   int extraBerries = 0;
   int mineChance = rmRandInt(1,5);
   int mineNumber = rmRandInt(0,8);
   int startingOutpost = rmRandInt(1,8);
   int dualForest = 0;
   int denseForest = 0;
   int forestSize = 0;
   int patchSize = 0;
   int bonusCrates = rmRandInt(1,5);

// Picks the map size
   int playerTiles=14800;  
   if (cNumberNonGaiaPlayers > 7)
	playerTiles = 11500;  
   else if (cNumberNonGaiaPlayers > 5)
	playerTiles = 12500;  
   else if (cNumberNonGaiaPlayers > 3)
	playerTiles = 13000; 
   else if (cNumberNonGaiaPlayers == 3)
	playerTiles = 13500;
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

// Elevation
   int elevationChance = rmRandInt(1,4);
  // rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)

   if (elevationChance == 1)
   {
	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
	rmSetMapElevationHeightBlend(1.0);
   }
   else if (elevationChance == 2)
   {
	rmSetMapElevationParameters(cElevTurbulence, 0.04, 3, 0.5, 6.0);
	rmSetMapElevationHeightBlend(1.0);
   }  
   else if (elevationChance == 3)
   {
	rmSetMapElevationParameters(cElevTurbulence, 0.1, 5, 0.2, 5.0);
	rmSetMapElevationHeightBlend(0.9);
   }
   else if (elevationChance == 4)
   {
	rmSetMapElevationParameters(cElevTurbulence, 0.2, 4, 0.2, 3.0);
	rmSetMapElevationHeightBlend(0.8);
   }

// Pick terrain patterns and features
//   patternChance = 33; // ========================================================================================= 
//   featureChance = 6;
//   trPattern = 1;
//   extendCenter = 0;
//   fourChoice = 1;
//   threeChoice = 2;
//   sixChoice = 1;
//   nativeSetup = 22;
//   lightingChance = 1;
//   extendCenter = 2;
//   variantChance = 1;
//   mineNumber = 0;

   if (patternChance == 1) // NE
   {   
      rmSetSeaType("new england coast");
      rmSetMapType("newEngland");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("Great Lakes");
	else
	   rmSetLightingSet("new england");
      baseType = "newengland_grass";
	forestType = "new england forest";
	riverType = "new england lake";
      cliffType = "New England Inland Grass";
	pondType = "new england lake";
	treeType = "TreeNewEngland";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "turkey";
         centerHerdType = "moose";         
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "moose";
         centerHerdType = "turkey";        
	}
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
      fishType = "FishSalmon";
	mineType = "mine";
      hillTrees = rmRandInt(0,1);
	if (cliffChance > 2)
         makeCliffs = 1;
      if (featureChance == 1)
	   makeLake = 1;
	else if (featureChance == 2)
	   makePonds = 1;	   	
	else if (featureChance < 6)
	{
	   makeCentralHighlands = 1;
	   makeCliffs = 2;
	}
	else if (featureChance < 7)
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	   makePonds = 0;
	}
      else if (featureChance < 8)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      else if (featureChance == 10)
	{
	   makeRiver = 1;
	   makeCliffs = 2;
	   makePonds = 0;
	}
      nativePattern = 40;
   }
   else if (patternChance == 2) // carolina
   {
      rmSetSeaType("atlantic coast");
      rmSetMapType("carolina");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("312b_washington");
	else
	   rmSetLightingSet("carolina");
      baseType = "carolina_grass";
	forestType = "carolina pine forest";
	riverType = "Amazon River";
      cliffType = "Carolina Inland";
	treeType = "TreeCarolinaGrass";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "turkey";
         centerHerdType = "deer";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "deer";
         centerHerdType = "turkey";        
	}   
      if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
      fishType = "FishBass";
	mineType = "mine";
      hillTrees = rmRandInt(0,1);
	extraBerries = 2;
	if (featureChance < 4)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 0;
	}
      else if (featureChance < 6)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      else if (featureChance == 10)
	{
	   makeRiver = 1;
	   cliffChance = 2;
	}
	if (cliffChance > 7)
         makeCliffs = 1;
	if (nativeChoice == 1)
	   nativePattern = 3;
	else
	   nativePattern = 40;
   }
   else if (patternChance == 3) // bayou
   {
      rmSetSeaType("yucatan Coast");
      rmSetMapType("bayou");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("berlin dusk");
	else
         rmSetLightingSet("bayou");
      baseType = "bayou_grass";
	forestType = "bayou swamp forest";
      pondType = "bayou";
	treeType = "TreeBayou";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "turkey";
         centerHerdType = "deer";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "deer";
         centerHerdType = "turkey";        
	}
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
      fishType = "FishBass";
	mineType = "mine";
	eagles = 1;
      makeCliffs = 0;
	if (rmRandInt(1,5) > 1)
         makeLake = 1;
	extraBerries = 2;
	if (threeChoice == 1)
	   nativePattern = 3;
	else if (threeChoice == 2)
	   nativePattern = 21;
	else
	   nativePattern = 42;
   }
   else if (patternChance == 4) // great lakes green
   {
      if (variantChance == 1)
         rmSetSeaType("hudson bay");
      else
	   rmSetSeaType("new england coast");
      rmSetMapType("greatlakes");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("constantinople");
	else
         rmSetLightingSet("Great Lakes");
      baseType = "greatlakes_grass";
	forestType = "great lakes forest";
      cliffType = "New England";
      pondType = "great lakes";
	treeType = "TreeGreatLakes";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "moose";
         centerHerdType = "bison";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "turkey";
         centerHerdType = "moose";        
	}   
      sheepType = "sheep";
      fishType = "FishBass";
	mineType = "mine";
      hillTrees = rmRandInt(0,1);
      extraBerries = 2;
      if (featureChance == 1)
	   makePonds = 1;	
      else if (featureChance < 4)
	   makeLake = 1;
	else if (featureChance < 6)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 0;
      }
	else if (featureChance < 7)
	{
	   makeCentralCanyon = 1;
	   cliffChance = 0;
	}
      else if (featureChance < 9)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
	if (cliffChance >6)
         makeCliffs = 1;

	if (fiveChoice == 1)
	   nativePattern = 4;
	else if (fiveChoice == 2)
	   nativePattern = 5;
	else if (fiveChoice == 3)
	   nativePattern = 40;
	else if (fiveChoice == 4)
	   nativePattern = 22;
	else
	   nativePattern = 40;
   }
   else if (patternChance == 5) // great lakes winter
   {
      rmSetSeaType("great lakes ice");
      rmSetMapType("greatlakes");
      rmSetMapType("snow");
	if (lightingChance == 1)
	   rmSetLightingSet("308b_caribbeanlight");
	else
         rmSetLightingSet("Great Lakes Winter");
      baseType = "greatlakes_snow";
	forestType = "great lakes forest snow";
	riverType = "Yukon River";
      pondType = "great lakes ice";
	treeType = "TreeGreatLakesSnow";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "moose";
         centerHerdType = "elk";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "bison";
         centerHerdType = "moose";       
	}      
      sheepType = "sheep";
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineTin";
	else
	   mineType = "MineCopper";
      placeBerries = 0;
      hillTrees = rmRandInt(0,1);
      if (featureChance < 4)
	   makeLake = 1;
	else if (featureChance < 7)
	   makeIce = 1;
	else if (featureChance < 9)
	   forestMt = 1;
      else if (featureChance == 9)
	   makeRiver = 1;

	if (fiveChoice == 1)
	   nativePattern = 4;
	else if (fiveChoice == 2)
	   nativePattern = 5;
	else if (fiveChoice == 3)
	   nativePattern = 40;
	else if (fiveChoice == 4)
	   nativePattern = 22;
	else
	   nativePattern = 40;
   }
   else if (patternChance == 6) // saguenay
   {
      rmSetSeaType("hudson bay");
      rmSetMapType("saguenay");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("lisbon");
	else
         rmSetLightingSet("saguenay");
      baseType = "saguenay grass";
	forestType = "saguenay forest";
	riverType = "saguenay lake";
      pondType = "saguenay lake";
	treeType = "TreeSaguenay";
      if (variantChance == 1)
	{
         deerType = "caribou";
         deer2Type = "moose";
         centerHerdType = "caribou";
	}
      else 
	{     
         deerType = "caribou";
         deer2Type = "caribou";
         centerHerdType = "moose";       
	}
      sheepType = "sheep";
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineTin";
	else
	   mineType = "MineCopper";
	extraBerries = 1;
	makePonds = rmRandInt(1,3);
      if (featureChance < 5)
	   makeLake = 1;
	else if (featureChance <7)
	   makePonds = 1;
      else if (featureChance == 10)
	{
	   makeRiver = 1;
	   makePonds = 0;
	}	

	if (threeChoice == 1)
	   nativePattern = 5;
	else if (threeChoice == 2)
	   nativePattern = 6;
	else if (threeChoice == 3)
	   nativePattern = 16;
   }
   else if (patternChance == 7) // yukon
   {
      rmSetSeaType("great lakes ice");
      rmSetMapType("yukon");
      rmSetMapType("snow");
	if (lightingChance == 1)
	   rmSetLightingSet("305b");
	else
         rmSetLightingSet("yukon");
      baseType = "yukon snow";
	forestType = "yukon snow forest";
	riverType = "Yukon River";
      cliffType = "rocky mountain2";
	treeType = "TreeYukonSnow";
      if (variantChance == 1)
	{
         deerType = "caribou";
         deer2Type = "muskOx";
         centerHerdType = "bighornsheep";
	}
      else 
	{     
         deerType = "muskOx";
         deer2Type = "caribou";
         centerHerdType = "caribou";       
	}
      sheepChance = 0;
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "minegold";
	else
	   mineType = "MineCopper";
      placeBerries = 0;
      hillTrees = rmRandInt(0,1);
	clearCenterChance = 3;
      if (featureChance < 4)
	{
	   centerMt = 1;
	   cliffVariety = rmRandInt(1,5);
	}
	else if (featureChance < 7)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 2;
	}
	else if (featureChance < 9)
	{
	   makeIce = 1;
	   cliffChance = 0;
	}
      else if (featureChance == 9)
	{
	   makeRiver = 1;
	   clearCenterChance = 0;
	}
	if (cliffChance > 2)
         makeCliffs = 1;

	if (fiveChoice == 1)
	   nativePattern = 5;
	else if (fiveChoice == 2)
	   nativePattern = 6;
	else if (fiveChoice == 3)
	   nativePattern = 8;
	else if (fiveChoice == 4)
	   nativePattern = 27;
	else
	   nativePattern = 28;
   }
   else if (patternChance == 8) // rockies
   {
      rmSetSeaType("great lakes");
      rmSetMapType("rockies");
      rmSetMapType("snow");
	if (lightingChance == 1)
	   rmSetLightingSet("305b");
	else
         rmSetLightingSet("rockies");
      baseType = "rockies_grass";
	forestType = "rockies forest";
      cliffType = "rocky mountain2";
	treeType = "TreeRockies";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "elk";
         centerHerdType = "bighornsheep";
	}
      else 
	{     
         deerType = "elk";
         deer2Type = "elk";
         centerHerdType = "bighornsheep";
	}   
      if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "minegold";
	else
	   mineType = "mine";
	eagles = 1;
      hillTrees = 1;
      reducedForest = 1;
      if (featureChance < 6)
	   centerMt = 1;
	else 
	   makeCentralHighlands = 1;
	nativeChoice = rmRandInt(1,5);
	if (nativeChoice == 1)
	   nativePattern = 23;
	else if (nativeChoice == 2)
	   nativePattern = 29;
	else if (nativeChoice == 3)
	   nativePattern = 19;
	else if (nativeChoice == 4)
	   nativePattern = 8;
	else if (nativeChoice == 5)
	   nativePattern = 28;
   }
   else if (patternChance == 9) // great plains 1
   {
      rmSetSeaType("Yucatan coast");
      rmSetMapType("greatPlains");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("ottoman morning");
	else
         rmSetLightingSet("great plains");       
      baseType = "great plains grass"; 
	forestType = "great plains forest";
	riverType = "Amazon River";
      cliffType = "Great Plains";
      pondType = "great plains pond";
	treeType = "TreeGreatPlains";
      if (variantChance == 1)
	{
         deerType = "bison";
         deer2Type = "pronghorn";
         centerHerdType = "bison";
	}
      else 
	{     
         deerType = "pronghorn";
         deer2Type = "bison";
         centerHerdType = "elk";
	} 
      if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
      fishType = "FishBass";
	mineType = "mine";
      vultures = 1;
      plainsMap = 1;
	extraBerries = 2;
	clearCenterChance = 2;
      if (featureChance == 1)
	   makePonds = 1;
      else if (featureChance < 4)
	   makeLake = 1;
	else if (featureChance < 5)
	{
	   makeCentralCanyon = 1;
	   cliffChance = 0;
	}
	else if (featureChance < 7)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 0;
	}
      else if (featureChance == 10)
	{
	   makeRiver = 1;
	   cliffChance = 0;
	   clearCenterChance = 0;
	}
	if (cliffChance > 7)  
         makeCliffs = 1;
	if (rmRandInt(1,2) == 1) 
	   bareCliffs = 1;
	cliffVariety = rmRandInt(2,7);
	if (cliffVariety == 4)
	   cliffVariety = 6;
	if (cliffVariety == 5)
	   cliffVariety = 7;
	nativeChoice = rmRandInt(1,5);
	if (nativeChoice == 1)
	   nativePattern = 23;
	else if (nativeChoice == 2)
	   nativePattern = 29;
	else if (nativeChoice == 3)
	   nativePattern = 19;
	else if (nativeChoice == 4)
	   nativePattern = 8;
	else if (nativeChoice == 5)
	   nativePattern = 28;
   }
   else if (patternChance == 10) // great plains 2
   {
      rmSetSeaType("new england coast");
      rmSetMapType("greatPlains");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("spc14abuffalo");
	else
         rmSetLightingSet("great plains");
      baseType = "great plains drygrass";
	forestType = "great plains forest";
	riverType = "great plains pond";
      cliffType = "Great Plains";
      pondType = "great plains pond";
	treeType = "TreeGreatPlains";
      if (variantChance == 1)
	{
         deerType = "bison";
         deer2Type = "pronghorn";
         centerHerdType = "bison";
	}
      else 
	{     
         deerType = "pronghorn";
         deer2Type = "bison";
         centerHerdType = "bison";
	}
      sheepType = "cow";
      fishType = "FishBass";
	mineType = "mine";
      vultures = 1;
      plainsMap = 1;
	extraBerries = 2;
	forestCoverUp = 1; 
	clearCenterChance = 1;
      if (featureChance == 1)
	   makePonds = 1;
      else if (featureChance == 2)
	   makeLake = 1;
	else if (featureChance < 5)
	{
	   makeCentralCanyon = 1;
	}
	else if (featureChance < 7)
	{
	   makeCentralHighlands = 1;
	}
      else if (featureChance == 10)
	{
	   makeRiver = 1;
	   cliffChance = 0;
	   clearCenterChance = 0;
	}
	if (cliffChance > 7)  
         makeCliffs = 1;
	if (rmRandInt(0,1) == 1)  
	   bareCliffs = 1;
	cliffVariety = rmRandInt(2,7);
	if (cliffVariety == 4)
	   cliffVariety = 6;
	if (cliffVariety == 5)
	   cliffVariety = 7;
	nativeChoice = rmRandInt(1,5);
	if (nativeChoice == 1)
	   nativePattern = 30;
	else if (nativeChoice == 2)
	   nativePattern = 29;
	else if (nativeChoice == 3)
	   nativePattern = 32;
	else if (nativeChoice == 4)
	   nativePattern = 8;
	else if (nativeChoice == 5)
	   nativePattern = 28;
   }
   else if (patternChance == 11) // texas grass
   {   
      rmSetSeaType("new england coast");
      rmSetMapType("texas");
	rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("pampas");
	else
         rmSetLightingSet("texas");
      baseType = "texas_grass";
	forestType = "texas forest";
	riverType = "Amazon River";
      cliffType = "Texas Grass";
	pondType = "texas pond";
	treeType = "TreeTexas";
      if (variantChance == 1)
	{
         deerType = "bison";
         deer2Type = "deer";
         centerHerdType = "bison";
	}
      else 
	{     
         deerType = "pronghorn";
         deer2Type = "bison";
         centerHerdType = "bison";
	}
      sheepType = "cow";
      fishType = "FishBass";
	mineType = "mine";
      vultures = 1;
	extraBerries = 2;

	if (cliffChance > 3)
         makeCliffs = 1;
	clearCenterChance = 2;
      if (featureChance == 1)
	   makePonds = 1;
      else if (featureChance < 4)
	   makeLake = 1;
	else if (featureChance < 7)
	{
	   makeCentralHighlands = 1;
	   makeCliffs = 2;
	}
	else if (featureChance == 7)
	{
	   makeRiver = 1;
	   makeCliffs = 2;
	   clearCenterChance = 0;
	}

	nativeChoice = rmRandInt(1,6);
	if (nativeChoice == 1)
	   nativePattern = 30;
	else if (nativeChoice == 2)
	   nativePattern = 29;
	else if (nativeChoice == 3)
	   nativePattern = 32;
	else if (nativeChoice == 4)
	   nativePattern = 19;
	else if (nativeChoice == 5)
	   nativePattern = 20;
	else
	   nativePattern = 9;
   }
   else if (patternChance == 12) // texas desert
   {   
      rmSetSeaType("new england coast");
      rmSetMapType("texas");
	rmSetMapType("grass");
	if (featureChance == 7)
	   rmSetLightingSet("seville");
	else
	{
	   if (lightingChance == 1)
	      rmSetLightingSet("seville");
	   else
            rmSetLightingSet("texas");
	}
	if (lightingChance == 1)
	   baseType = "texas_dirt";
	else
         baseType = "texas_grass";
	forestType = "texas forest dirt";
	riverType = "Pampas River";
      cliffType = "Texas";
	pondType = "texas pond";
	treeType = "TreeTexasDirt";
      if (variantChance == 1)
	{
         deerType = "bison";
         deer2Type = "pronghorn";
         centerHerdType = "pronghorn";
	}
      else 
	{     
         deerType = "pronghorn";
         deer2Type = "bison";
         centerHerdType = "bison";
	}
      sheepType = "cow";
      fishType = "FishBass";
	mineType = "mine";
      vultures = 1;
      clearCenterChance = 1;
      makeCliffs = 1;
      if (featureChance < 4)
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	}
	else if (featureChance < 7)
	{
	   makeCentralHighlands = 1;
	   makeCliffs = 2;
	}
	else if (featureChance == 10)
	{
	   makeRiver = 1;
	   makeCliffs = 2;
	   clearCenterChance = 0;
	}

	nativeChoice = rmRandInt(1,6);
	if (nativeChoice == 1)
	   nativePattern = 30;
	else if (nativeChoice == 2)
	   nativePattern = 29;
	else if (nativeChoice == 3)
	   nativePattern = 32;
	else if (nativeChoice == 4)
	   nativePattern = 31;
	else if (nativeChoice == 5)
	   nativePattern = 38;
	else
	   nativePattern = 39;
   }
   else if (patternChance == 13) // sonora
   {   
      rmSetSeaType("Atlantic Coast");
      rmSetMapType("sonora");
	rmSetMapType("grass");
	if (featureChance == 10)
	   rmSetLightingSet("pampas");
	else
	{
   	   if (lightingChance == 1)
            rmSetLightingSet("sonora");
	   else
            rmSetLightingSet("pampas");
	}
      baseType = "sonora_dirt";
	forestType = "sonora forest";
	riverType = "Pampas River";
      cliffType = "Sonora";
      cliffVariety = 8;
	treeType = "TreeSonora";
      if (variantChance == 1)
	{
         deerType = "pronghorn";
         deer2Type = "bison";
         centerHerdType = "bighornsheep";         
	}
      else 
	{     
         deerType = "pronghorn";
         deer2Type = "bighornsheep";
         centerHerdType = "bison";         
	}
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
      fishType = "FishBass";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
      vultures = 1;
      reducedForest = 1;
      if (featureChance < 4)
	{
	   makeCentralCanyon = 1;
	}
	else if (featureChance < 6)
	{
	   makeCentralHighlands = 1;
	}
	else if (featureChance == 10)
	{
	   makeRiver = 1;
	}
      makeCliffs = 1;

	if (fiveChoice == 1)
	   nativePattern = 10;
	else if (fiveChoice == 2)
	   nativePattern = 31;
	else if (fiveChoice == 3)
	   nativePattern = 32;
	else if (fiveChoice == 4)
	   nativePattern = 33;
	else
	   nativePattern = 37;
   }
   else if (patternChance == 14) // yucatan
   {
      rmSetSeaType("yucatan Coast");
      rmSetMapType("yucatan");
      rmSetMapType("tropical");
	if (lightingChance == 1)
	   rmSetLightingSet("311b");
	else
         rmSetLightingSet("yucatan");     
      baseType = "yucatan_grass";
	forestType = "yucatan forest";
	riverType = "Amazon River";
      cliffType = "Amazon";
      pondType = "Amazon River Basin";
	treeType = "TreeYucatan";
      if (variantChance == 1)
      {
         deerType = "tapir";
         deer2Type = "capybara";
         centerHerdType = "turkey";
      }
      else
	{
         deerType = "capybara";
         deer2Type = "turkey";
         centerHerdType = "tapir";
	}
      sheepChance = 0;
      fishType = "FishTarpon";
      mineType = "mine";
      hillTrees = rmRandInt(0,1);
	extraBerries = 1;
      tropicalMap = 1;
      if (featureChance == 1)
	   makePonds = 1;
      else if (featureChance == 2)
	   makeLake = 1;
	else if (featureChance < 5)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 0;
	}
      else if (featureChance < 7)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      else if (featureChance == 7)
	{
	   makeRiver = 1;
	   cliffChance = 2;
	   makePonds = 0;
	}
	if (cliffChance > 7)
         makeCliffs = 1;

	if (fiveChoice == 1)
	   nativePattern = 11;
	else if (fiveChoice == 2)
	   nativePattern = 12;
	else if (fiveChoice == 3)
	   nativePattern = 34;
	else if (fiveChoice == 4)
	   nativePattern = 35;
	else
	   nativePattern = 36;
   }
   else if (patternChance == 15) // caribbean
   {
      rmSetSeaType("caribbean coast");
      rmSetMapType("caribbean");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("301a_malta");
	else
         rmSetLightingSet("caribbean");     
      baseType = "caribbean grass";
	forestType = "caribbean palm forest";
      pondType = "Amazon River Basin";
	treeType = "TreeCaribbean";
      cliffType = "Caribbean";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "deer";
         centerHerdType = "tapir";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "tapir";
         centerHerdType = "deer";
	}
      sheepChance = 0;
      fishType = "FishTarpon";
	if (rmRandInt(1,2) == 1)
	   mineType = "minegold";
	else
	   mineType = "mine";
	extraBerries = 2;
      tropicalMap = 1;
      if (featureChance < 4)
	   makeLake = 1;
	else if (featureChance < 6)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 0;
	}
	if (cliffChance > 7)
         makeCliffs = 1;

	if (fiveChoice == 1)
	   nativePattern = 12;
	else if (fiveChoice == 2)
	   nativePattern = 13;
	else if (fiveChoice == 3)
	   nativePattern = 18;
	else if (fiveChoice == 4)
	   nativePattern = 36;
	else
	   nativePattern = 42;
   }
   else if (patternChance == 16) // amazon
   {
      rmSetSeaType("yucatan coast");
      rmSetMapType("amazonia");
      rmSetMapType("tropical");
	if (lightingChance == 1)
	   rmSetLightingSet("323b_inca");
	else
         rmSetLightingSet("amazon");     
      baseType = "amazon grass";
	forestType = "amazon rain forest";
	riverType = "Amazon River";
      cliffType = "Amazon";
      pondType = "Amazon River Basin";
	treeType = "TreeAmazon";
      if (variantChance == 1)
      {
         deerType = "tapir";
         deer2Type = "tapir";
         centerHerdType = "capybara";
      }
      else
	{
         deerType = "capybara";
         deer2Type = "tapir";
         centerHerdType = "capybara";
	}
      sheepChance = 0;
      fishType = "FishTarpon";
	if (rmRandInt(1,2) == 1)
	   mineType = "minegold";
	else
	   mineType = "mine";
	extraBerries = 1;
      tropicalMap = 1;
      if (featureChance == 1)
	   makeLake = 1;
	else if (featureChance < 4)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 0;
	}
      else if (featureChance < 6)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      else if (featureChance < 10)
	{
	   makeRiver = 1;
	   cliffChance = 0;
	}
	if (cliffChance > 7)
         makeCliffs = 1;

	if (fiveChoice == 1)
	   nativePattern = 13;
	else if (fiveChoice == 2)
	   nativePattern = 14;
	else if (fiveChoice == 3)
	   nativePattern = 15;
	else if (fiveChoice == 4)
	   nativePattern = 18;
	else
	   nativePattern = 26;
   }
   else if (patternChance == 17) // pampas
   {
      rmSetSeaType("Pampas River");
      rmSetMapType("pampas");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("texas");
	else
         rmSetLightingSet("pampas");
	if (cliffVariety < 3)  // not used for cliffs!
	   baseType = "pampas_grass";
	else
         baseType = "pampas_dirt";
	forestType = "pampas forest";
	treeType = "TreePampas";
	riverType = "Pampas River";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "rhea";
         centerHerdType = "rhea";
	}
      else 
	{     
         deerType = "rhea";
         deer2Type = "deer";
         centerHerdType = "rhea";
	}
      sheepType = "llama";
      fishType = "FishBass";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
	clearCenterChance = 2;
      if (featureChance < 6)
	{
	   makeRiver = 1;
	   clearCenterChance = 0;
	}
      vultures = 1;
      eagles = 1;

	if (threeChoice == 1)
	   nativePattern = 14;
	else if (threeChoice == 2)
	   nativePattern = 25;
	else
	   nativePattern = 26;
   }
   else if (patternChance == 18) // patagonia
   {
      rmSetSeaType("hudson bay");
      rmSetMapType("patagonia");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("paris day");
	else
         rmSetLightingSet("patagonia");
	if (twoChoice == 1)
	{
	   baseType = "patagonia_grass";
	   patchMixType = "patagonia_dirt";
	}
	else
	{
         baseType = "patagonia_dirt";
	   patchMixType = "patagonia_grass";
	}
	forestType = "patagonia forest";
      cliffType = "Patagonia";
      pondType = "hudson bay";
	treeType = "TreePatagoniaDirt";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "rhea";
         centerHerdType = "rhea";
	}
      else 
	{     
         deerType = "rhea";
         deer2Type = "deer";
         centerHerdType = "rhea";
	}
      sheepType = "llama";
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
      hillTrees = rmRandInt(0,1);
	extraBerries = 2;
	makeCliffs = 2;
	specialPatch = 1;
      if (featureChance < 3)
	{
 	   makeLake = 1;
	}
	else if (featureChance < 6)
	{
	   makeCentralHighlands = 1;
   	   clearCenterChance = 2;
	}
	else if (featureChance < 8)
	{
	   makeCentralCanyon = 1;
	}

	if (fiveChoice == 1)
	   nativePattern = 14;
	else if (fiveChoice == 2)
	   nativePattern = 15;
	else if (fiveChoice == 3)
	   nativePattern = 24;
	else if (fiveChoice == 4)
	   nativePattern = 25;
	else
	   nativePattern = 26;
   }
   else if (patternChance == 19) // palm desert
   {   
      rmSetMapType("sonora");
	rmSetMapType("grass");
      if (lightingChance == 1)
         rmSetLightingSet("seville");
      else
         rmSetLightingSet("pampas");
	if (twoChoice == 1)
	{
         baseType = "texas_dirt";
         cliffType = "Texas";
	}
	else
	{
         baseType = "sonora_dirt";
         cliffType = "Sonora";
	}
	forestType = "caribbean palm forest";
	riverType = "Pampas River";
	treeType = "TreeCaribbean";
	pondType = "texas pond";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "turkey";
         centerHerdType = "deer";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "deer";
         centerHerdType = "turkey";
	}
      fishType = "FishBass";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
      sheepType = "cow";
      vultures = 1;
	coverUp = 1;
	makePonds = 0;
      clearCenterChance = 1;
      makeCliffs = 2;
	noCliffForest = 1;
      if (featureChance < 4)
	{
	   makeCentralCanyon = 1;
	}
	else if (featureChance < 7)
	{
	   makeCentralHighlands = 1;
	}
	else if (featureChance == 10)
	{
	   makeRiver = 1;
	   clearCenterChance = 0;
	}

	if (fourChoice == 1)
	   nativePattern = 36;
	else if (fourChoice == 2)
	   nativePattern = 34;
	else if (fourChoice == 3)
	   nativePattern = 35;
	else 
	   nativePattern = 33;
   }
   else if (patternChance == 20) // yukon tundra
   {
      rmSetSeaType("hudson bay");
      rmSetMapType("yukon");
      rmSetMapType("snow");
	if (lightingChance == 1)
         rmSetLightingSet("seville morning");
	else
         rmSetLightingSet("yukon");
      baseType = "yukon grass";
	forestType = "yukon forest";
	riverType = "Yukon River";
      cliffType = "rocky mountain2";
	if (rmRandInt(1,2) == 1)
         pondType = "hudson bay";
	else  
         pondType = "great lakes ice";
	treeType = "TreeYukon";
      if (variantChance == 1)
	{
	   if (featureChance > 8)
	   {
		makeRiver = 1; 
            deerType = "muskOx";
            deer2Type = "caribou";
            centerHerdType = "caribou";
	   }
	   else
	   {
	      centerMt = 1;
	      clearCenterChance = 3;
            deerType = "muskOx";
            deer2Type = "caribou";
            centerHerdType = "bighornsheep";
	   }
	}
      else 
	{  
         deerType = "caribou"; 
         deer2Type = "muskOx";
         centerHerdType = "caribou";  
	   clearCenterChance = 3;
         if (featureChance < 4)
		makeIce = 1;
	   else if (featureChance < 8)	
	      makeLake = 1;     
	}
      sheepChance = 0;
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
      placeBerries = 0;
      hillTrees = 0;  

	if (threeChoice == 1)
	   nativePattern = 5;
	else if (threeChoice == 2)
	   nativePattern = 6;
	else if (threeChoice == 3)
	   nativePattern = 16;
   }
   else if (patternChance == 21) // andes
   {
      rmSetSeaType("hudson bay");   
      rmSetMapType("andes");
      rmSetMapType("grass");
	if (lightingChance == 1)
         rmSetLightingSet("greatplainstest");
	else
	   rmSetLightingSet("andes");
	if (twoChoice == 1)
	{
         baseType = "andes_grass_a";
	   patchMixType = "andes_grass_b";
	}
	else
	{
         baseType = "andes_grass_b";
	   patchMixType = "andes_grass_a";
	}
	forestType = "andes forest";
	riverType = "Andes River";
      cliffType = "andes";
	treeType = "TreeAndes";
      pondType = "hudson bay";      
      if (variantChance == 1)
	{
         deerType = "guanaco";
         deer2Type = "guanaco";
         centerHerdType = "rhea";
	}
      else 
	{     
         deerType = "guanaco";
         deer2Type = "guanaco";
         centerHerdType = "guanaco";
	}
      sheepType = "llama";
      fishType = "FishMoonBass";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
      hillTrees = rmRandInt(0,1);
      makeCliffs = 2;
      eagles = 1;
	extraBerries = 2;
      tropicalMap = 1;
	specialPatch = 1;
	if (featureChance < 4)
	{
	   makeCentralHighlands = 1;
	   hillTrees = 0;
	   clearCenterChance = 1;
	}
	else if (featureChance < 5)	
	{
	   makeCentralCanyon = 1;
	   hillTrees = 0;
	}
	else if (featureChance < 7)
	{
	   centerMt = 1;
   	   clearCenterChance = 1;
	}
	else if (featureChance == 10)	
	{
	   makeRiver = 1;
	}

	if (fiveChoice == 1)
	   nativePattern = 14;
	else if (fiveChoice == 2)
	   nativePattern = 24;
	else if (fiveChoice == 3)
	   nativePattern = 25;
	else if (fiveChoice == 4)
	   nativePattern = 26;
	else
	   nativePattern = 18;
   }
   else if (patternChance == 22) // araucania green or central
   {
      rmSetSeaType("Araucania Central Coast");   
      rmSetMapType("araucania");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("Araucania Central");
	else
         rmSetLightingSet("Texas");  
	if (fourChoice == 1)
	{
         baseType = "araucania_grass_a";
	   patchMixType = "araucania_grass_b";
	   makePonds = rmRandInt(1,5);
	}
	else if (fourChoice == 2)
	{
         baseType = "araucania_grass_b";
	   patchMixType = "araucania_grass_a";
	   makePonds = rmRandInt(1,5);
	}
	else if (fourChoice == 3)
	{
         baseType = "araucania_grass_c";
	   patchMixType = "araucania_grass_b";
	   makePonds = rmRandInt(1,5);
	}
	else
	{
         baseType = "araucania_grass_d";
	   patchMixType = "araucania_grass_c";
	}
	forestType = "Araucania Forest";
	riverType = "Andes River";
	cliffType = "Araucania Central";      
	treeType = "TreeAraucania";
      pondType = "great plains pond";
      if (variantChance == 1)
	{
         deerType = "guanaco";
         deer2Type = "deer";
         centerHerdType = "guanaco"; 
	}
      else 
	{     
         deerType = "guanaco";
         deer2Type = "guanaco";
         centerHerdType = "guanaco";
	} 
      sheepType = "llama";
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
      makeCliffs = 2;
	coverUp = 1;   
	specialPatch = 1;
	extraBerries = 1;
	clearCenterChance = 0;
      if (featureChance == 1)
	{
	   if (fourChoice < 4)
	      makeLake = 1;
	}
	else if (featureChance < 4)
	{
	   makeCentralHighlands = 1;
	   makeCliffs = 2;
	   clearCenterChance = 2;
	}
	else if (featureChance < 5)	
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	}
	else if (featureChance < 7)
	{
	   centerMt = 1;
	   makeCliffs = 1;
	}
	else if (featureChance == 10)	
	{
	   makeRiver = 1;
	   makePonds = 0;
	}
	if (fiveChoice == 1)
	   nativePattern = 14;
	else if (fiveChoice == 2)
	   nativePattern = 25;
	else if (fiveChoice == 3)
	   nativePattern = 11;
	else if (fiveChoice == 4)
	   nativePattern = 26;
	else
	   nativePattern = 34;
   }
   else if (patternChance == 23) // araucania north  
   {
      rmSetSeaType("Araucania North Coast");
      rmSetMapType("araucania");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("NthAraucaniaLight");
	else
         rmSetLightingSet("constantinople");  
	if (cliffChance > 3)
         makeCliffs = 1;
	if (sixChoice == 1)
	{
	   baseType = "araucania_north_dirt_a"; 
         patchMixType = "araucania_north_grass_a";
	   makeCliffs = 0;
	}
	else if (sixChoice == 2)
	{
	   baseType = "araucania_north_grass_a";
         patchMixType = "araucania_north_dirt_a"; 
	   makeCliffs = 0;
	}
	else if (sixChoice == 3)
	{
	   baseType = "araucania_north_grass_a";
	   patchMixType = "araucania_north_grass_b"; 
	   makeCliffs = 0;
	}
	else if (sixChoice == 4)
	{
	   baseType = "araucania_north_grass_b";
	   patchMixType = "araucania_north_grass_a"; 
	}
	else if (sixChoice == 5)
	{
	   baseType = "araucania_north_grass_b";
	   patchMixType = "araucania_north_grass_c"; 
	}
	else if (sixChoice == 6)
	{
	   baseType = "araucania_north_grass_c";
	   patchMixType = "araucania_north_grass_a"; 
	}
	forestType =  "North Araucania Forest";
	riverType = "Pampas River";
	cliffType = "Araucania North";
	treeType = "TreeAraucania";
      pondType = "texas pond";   
      if (variantChance == 1)
	{
         deerType = "guanaco";
         deer2Type = "deer";
         centerHerdType = "guanaco"; 
	}
      else 
	{     
         deerType = "guanaco";
         deer2Type = "guanaco";
         centerHerdType = "guanaco";
	} 
      sheepType = "llama";
      fishType = "FishSalmon";
      mineType = "MineCopper";
	coverUp = 1;
	specialPatch = 1;
	extraBerries = 2;
	clearCenterChance = 2;
	hillTrees = 0;
	if (featureChance < 3)
	{
	   makeCentralHighlands = 1;
	   makeCliffs = 2;
	}
	else if (featureChance < 5)	
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	}

	if (fiveChoice == 1)
	   nativePattern = 14;
	else if (fiveChoice == 2)
	   nativePattern = 24;
	else if (fiveChoice == 3)
	   nativePattern = 25;
	else if (fiveChoice == 4)
	   nativePattern = 26;
	else
	   nativePattern = 18;
   }
   else if (patternChance == 24) // araucania south 
   {
      rmSetSeaType("Araucania Southern Coast");  
      rmSetMapType("araucania");
      rmSetMapType("snow");
	if (lightingChance == 2)
	   rmSetLightingSet("SthAraucaniaLight");
	else
	   rmSetLightingSet("303a_boston");  
	if (fourChoice == 1)
	{
   	   baseType = "araucania_snow_a";
         patchMixType = "araucania_snow_b";
	}
	else if (fourChoice == 2)
	{
   	   baseType = "araucania_snow_a";
         patchMixType = "araucania_snow_c";
	}
	else if (fourChoice == 3)
	{
   	   baseType = "araucania_snow_c";
         patchMixType = "araucania_snow_a";
	}
	else if (fourChoice == 4)
	{
   	   baseType = "araucania_snow_b";
         patchMixType = "araucania_snow_a";
	}
	forestType = "Patagonia Snow Forest";
	riverType = "Yukon River";  
      cliffType = "Araucania South";
	treeType = "TreePatagoniaSnow";
	if (twoChoice == 1)
	   pondType = "great lakes ice";  
	else
	   pondType = "Araucania Southern Coast"; 
      if (variantChance == 1)
	{
         deerType = "guanaco";
         deer2Type = "deer";
         centerHerdType = "guanaco"; 
	}
      else 
	{     
         deerType = "guanaco";
         deer2Type = "guanaco";
         centerHerdType = "guanaco";
	} 
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "llama";
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
      placeBerries = 0;
      hillTrees = rmRandInt(0,1);
      makeCliffs = 2;
	noCliffForest = 1;
	if (featureChance < 3)
	   makeLake = 1;
	else if (featureChance == 3)
	{
	   makeCentralHighlands = 1;
	   hillTrees = 0;
	   clearCenterChance = 2;
	}
	else if (featureChance == 4)	
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	   hillTrees = 0;
	}
	else if (featureChance == 5)
	{
	   centerMt = 1;
	   hillTrees = 0;
	}
	else if (featureChance == 6)
	{
	   makeIce = 1;
	   hillTrees = 0;
	   cliffChance = 0;
	}
	else if (featureChance == 7)
	{
	   forestMt = 1;
	   hillTrees = 0;
	}
	else if (featureChance == 10)	
	{
	   makeRiver = 1;
	}
	if (fourChoice == 1)
	   nativePattern = 14;
	else if (fourChoice == 2)
	   nativePattern = 25;
	else if (fourChoice == 3)
	   nativePattern = 26;
	else
	   nativePattern = 11;
   }
   else if (patternChance == 25) // california green
   {
      rmSetSeaType("california coast");   
      rmSetMapType("california");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("california");
	else
         rmSetLightingSet("new england");      
	if (threeChoice == 1)
	{
         baseType = "california_grass";
	   if (twoChoice == 1)
	      patchMixType = "california_grassrocks"; 
	   else
	      patchMixType = "california_snowground5";  
	}
	else if (threeChoice == 2)
	{
         baseType = "california_grassrocks"; 
	   if (twoChoice == 1)
	      patchMixType = "california_grass"; 
	   else
	      patchMixType = "california_snowground5";  
	}
	else if (threeChoice == 3)
	{
         baseType = "california_snowground5";  
	   if (twoChoice == 1)
	      patchMixType = "california_grass"; 
	   else
	      patchMixType = "california_grassrocks"; 
	}
	if (fiveChoice < 3)
	{ 
	   forestType = "california redwood forest";
	   treeType = "TreeRedwood";
	}
	else if (fiveChoice < 5)
	{ 
	   forestType = "California pine forest";
	   treeType = "TreePonderosaPine";
	}
	else
	{
	   forestType = "california madrone forest";
	   treeType = "TreeMadrone";
	}
	riverType = "Andes River";
      cliffType = "California";
      if (variantChance == 1)
	{
         deerType = "elk";
         deer2Type = "deer";
         centerHerdType = "elk";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "deer";
         centerHerdType = "elk";
	} 
      if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "minegold";
	specialPatch = 1;
	if (rmRandInt(1,2) == 1)
	   forestCoverUp = 1; 
      hillTrees = rmRandInt(0,1);
      eagles = 1;
	extraBerries = 2;
	if (featureChance == 1)
	{
	   makeLake = 1;
	   pondType = "california coast";
	}
	else if (featureChance < 4)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 0;
	}
      else if (featureChance < 6)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      else if (featureChance == 9)
	{
	   makePonds = 1;
         pondType = "great plains pond";
	}
      else if (featureChance == 10)
	{
	   makeRiver = 1;
	   cliffChance = 2;
	}
	if (cliffChance > 7)
         makeCliffs = 1;
	if (fourChoice < 3)
	   nativePattern = 27;
	else
	   nativePattern = 28;
   }
   else if (patternChance == 26) // california desert 
   {
      rmSetSeaType("Araucania North Coast");   
      rmSetMapType("california");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("texas");
	else
         rmSetLightingSet("307a_beach");      
      if (variantChance == 1)
	{
         deerType = "pronghorn";
         deer2Type = "pronghorn";
         centerHerdType = "deer";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "deer";
         centerHerdType = "pronghorn";
	}
	forestType = "California Desert Forest";
	treeType = "TreeSonora";
	if (cliffChance > 5)  
         makeCliffs = 1;
	if (threeChoice == 1)
	{ 
	   baseType = "california_desert0";
	   patchMixType = "california_desert";
	}
	else if (threeChoice == 2)
	{ 
	   baseType = "california_desert";
	   patchMixType = "california_desert0";
	}
	else
	{
	   baseType = "california_desert2";
	   patchMixType = "california_desert";
	   forestType = "california madrone forest";
	   treeType = "TreeMadrone";
	   makeCliffs = 0;
         centerHerdType = "elk";
	}
	riverType = "Andes River";
	cliffType = "Sonora";
       if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
      fishType = "FishBass";
      mineType = "mine";
      hillTrees = rmRandInt(0,1);
      vultures = 1;
	coverUp = 1;
	clearCenterChance = 2;
	if (featureChance < 3)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 0;
	}
      else if (featureChance < 5)
	{
	   makeCentralCanyon = 1;
	   cliffChance = 0;
	}
      else if (featureChance == 5)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
	if (fourChoice < 3)
	   nativePattern = 27;
	else
	   nativePattern = 43;
   }
   else if (patternChance == 27) // nwt    
   {
      rmSetSeaType("Northwest Territory Water");   
      rmSetMapType("northwestTerritory");
      rmSetMapType("grass");
	if (lightingChance == 2)
	   rmSetLightingSet("nwterritory");
	else
         rmSetLightingSet("saguenay");
      baseType = "nwt_grass1";
	if (twoChoice == 1)
	{
	   forestType = "NW Territory Birch Forest";
   	   treeType = "TreeGreatLakes";
	}
	else
	{ 
	   forestType = "NW Territory Forest";
	   treeType = "TreeGreatPlains";   
	}
	riverType = "Northwest Territory Water";
	cliffType = "Araucania Central";    
	pondType = "Northwest Territory Water";
      if (variantChance == 1)
	{
         deerType = "elk";
         deer2Type = "deer";
         centerHerdType = "moose"; 
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "moose";
         centerHerdType = "elk";
	} 
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
      makeCliffs = 2;  
      eagles = 1;
	extraBerries = 2;
      fishType = "FishSalmon";
      mineType = "mine";
      hillTrees = rmRandInt(0,1);
	coverUp = 1;
      if (featureChance < 3)
	   makeLake = 1;
	else if (featureChance < 5)
	   makeCentralHighlands = 1;
      else if (featureChance < 7)
	   forestMt = 1;
      else if (featureChance == 9)
         makePonds = 1;
	else if (featureChance == 10)
	{
	   makeRiver = 1;
	   makePonds = 0;
	}
	if (fourChoice == 1)
	   nativePattern = 27;
	else if (fourChoice == 2)
	   nativePattern = 28;
	else if (fourChoice == 3)
	   nativePattern = 7;
	else
	   nativePattern = 6;
   }
   else if (patternChance == 28) // painted desert     
   {   
      rmSetSeaType("hudson bay");
      rmSetMapType("sonora");
	rmSetMapType("desert");
      if (lightingChance == 1)
         rmSetLightingSet("sonora");
      else
         rmSetLightingSet("pampas");
	if (twoChoice == 1)
         baseType = "painteddesert_groundmix_1";
	else
         baseType = "painteddesert_groundmix_2";
	forestType = "painteddesert forest";
	riverType = "Pampas River";
      cliffType = "Painteddesert";
      cliffVariety = 8;
	treeType = "TreePaintedDesert";
	pondType = "texas pond";
      if (variantChance == 1)
	{
         deerType = "pronghorn";
         deer2Type = "bison";
         centerHerdType = "bighornsheep";         
	}
      else 
	{     
         deerType = "pronghorn";
         deer2Type = "bighornsheep";
         centerHerdType = "bison";         
	}
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
      fishType = "FishBass";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "MineCopper";
      vultures = 1;
      reducedForest = 1;
      if (featureChance < 4)
	{
	   makeCentralCanyon = 1;
	}
	else if (featureChance < 7)
	{
	   makeCentralHighlands = 1;
	}
      makeCliffs = 1;
	if (fiveChoice == 1)
	   nativePattern = 30;
	else if (fiveChoice == 2)
	   nativePattern = 31;
	else if (fiveChoice == 3)
	   nativePattern = 32;
	else if (fiveChoice == 4)
	   nativePattern = 33;
	else
	   nativePattern = 37;
   }
   else if (patternChance == 29) // HONSHU  
   {   
      rmSetSeaType("Coastal Japan");
      rmSetMapType("ceylon");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("Honshu");
	else
	   rmSetLightingSet("new england");
      baseType = "coastal_japan_a";
      patchMixType = "coastal_japan_c";
	forestType = "Coastal Japan Forest";
	riverType = "Coastal Japan";
      cliffType = "Coastal Japan";
	pondType = "Coastal Japan";
	treeType = "ypTreeJapaneseMaple";
      if (variantChance == 1)
	{
         deerType = "ypNilgai";
         deer2Type = "ypGiantSalamander";
         centerHerdType = "ypNilgai";         
	}
      else 
	{     
         deerType = "ypNilgai";
         deer2Type = "ypNilgai";
         centerHerdType = "ypGiantSalamander";        
	}
      if (sheepChance == 1)
         sheepType = "ypWaterBuffalo";
      else
         sheepType = "ypGoat";
      fishType = "ypFishCatfish";
	mineType = "mine";
	specialPatch = 1;
	if (featureChance == 1)
	{
	   makeLake = 1;
	}
	else if (featureChance < 4)	
	{
	   makeCentralHighlands = 1;
	   makeCliffs = 2;
	}
      else if (featureChance < 6)
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	   hillTrees = 0;
	}
      else if (featureChance == 6)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      nativePattern = 44;
   }
   else if (patternChance == 30) // DECCAN
   {   
      rmSetSeaType("Coastal Japan");
      rmSetMapType("deccan");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("deccan");
	else
	   rmSetLightingSet("texas");
	if (twoChoice == 1)
	{
         baseType = "deccan_grassy_Dirt_a";
	   patchMixType = "deccan_grass_a";
         cliffType = "Deccan Plateau";
	}
	else
	{
         baseType = "deccan_grass_a";
	   patchMixType = "deccan_grassy_Dirt_a";
         cliffType = "Deccan Plateau River";
	} 
	if (threeChoice == 1)
	{
 	   forestType = "Ashoka Forest";
	   forest2Type = "Deccan Forest";
   	   treeType = "ypTreeAshoka";
	   if (rmRandInt(1,2) == 1)
	      dualForest = 1;
	}
	else if (threeChoice == 2)
	{
 	   forestType = "Eucalyptus Forest";
	   forest2Type = "Deccan Forest";
   	   treeType = "ypTreeEucalyptus";
	   if (rmRandInt(1,2) == 1)
	      dualForest = 1;
	}
	else
	{
	   forestType = "Deccan Forest";
   	   treeType = "ypTreeDeccan";
	}
	riverType = "Deccan Plateau River";
      if (variantChance == 1)
	{
         deerType = "Zebra";
         deer2Type = "ypWildElephant";
         centerHerdType = "Zebra";         
	}
      else 
	{     
         deerType = "Zebra";
         deer2Type = "Zebra";
         centerHerdType = "ypWildElephant";        
	}
      if (sheepChance == 1)
         sheepType = "ypWaterBuffalo";
      else
         sheepType = "ypGoat";
      fishType = "ypFishCatfish";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineCopper";
	else
	   mineType = "mine";
	specialPatch = 1;
	if (featureChance < 4)
	{
	   makeCentralHighlands = 1;
	   makeCliffs = 2;
	}
	else if (featureChance < 5)	
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	   hillTrees = 0;
	}
      else if (featureChance == 5)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      else if (featureChance == 10)
	{
	   makeRiver = 1;
	   cliffChance = 0;
	}
	else
	{
	   if (twoChoice == 2)
	      clearCenter = 1;
	}
	if (cliffChance > 7)
         makeCliffs = 1;

	if (threeChoice == 1)
         nativePattern = 45;
	else if (threeChoice == 2)
         nativePattern = 46;
	else if (threeChoice == 3)
         nativePattern = 47;
   }
   else if (patternChance == 31) // HIMALAYAS
   {   
      rmSetSeaType("Hudson Bay");
      rmSetMapType("himalayas");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("Himalayas");
	else
	   rmSetLightingSet("Yukon");
      baseType = "himalayas_a";
      patchMixType = "himalayas_b";
	forestType = "Himalayas Forest";
	riverType = "Yukon River";
      cliffType = "himalayas";
	treeType = "ypTreeHimalayas";
      if (variantChance == 1)
	{
         deerType = "ypIbex";
         deer2Type = "ypNilgai";
         centerHerdType = "ypIbex";         
	}
      else 
	{     
         deerType = "ypNilgai";
         deer2Type = "ypIbex";
         centerHerdType = "ypNilgai";        
	}
      sheepType = "ypYak";
      fishType = "ypFishCatfish";
	mineType = "mine";
	if (rmRandInt(1,2) == 1)
         placeBerries = 0;
	specialPatch = 1;
      clearCenterChance = 1;
	if (featureChance < 3)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 2;
         clearCenterChance = 1;
	}
	else if (featureChance < 5)	
	{
	   makeCentralCanyon = 1;
	   cliffChance = 0;
	   hillTrees = 0;
         clearCenterChance = 0;
	}
      else if (featureChance == 10)
	{
	   makeRiver = 1;
	   cliffChance = 0;
         clearCenterChance = 0;
	}
	if (cliffChance > 0)
         makeCliffs = 1;
	cliffVariety = 10;
      nativePattern = 49;
   }
   else if (patternChance == 32) // INDOCHINA-BORNEO
   {   
      rmSetSeaType("borneo coast");
      rmSetMapType("borneo");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("borneo");
	else
	   rmSetLightingSet("bayou");
      baseType = "borneo_grass_a";
      patchMixType = "borneo_sand_a";
	if (fourChoice == 1)
	{
	   forestType = "Borneo Palm Forest";
	   forest2Type = "Borneo Canopy Forest";
	   dualForest = 1;
	}
	else if (fourChoice == 2)
	{
	   forestType = "Borneo Palm Forest";
	}
	else if (fourChoice == 3)
	{
	   forestType = "Borneo Canopy Forest";
	}
	else
	   forestType = "Borneo Forest";
	riverType = "Borneo Water";
	pondType = "Borneo Water";
	treeType = "ypTreeBorneo";
      if (variantChance == 1)
	{
         deerType = "ypNilgai";
         deer2Type = "ypNilgai";
         centerHerdType = "ypWildElephant";         
	}
      else 
	{     
         deerType = "ypNilgai";
         deer2Type = "ypWildElephant";
         centerHerdType = "ypNilgai";        
	}
      sheepType = "ypWaterBuffalo";
      fishType = "ypFishCatfish";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineGold";
	else
	   mineType = "mine";
	extraBerries = 1;
	if (rmRandInt(1,2) == 1)
	   specialPatch = 1;
	makePonds = rmRandInt(1,8);
	if (featureChance == 1)
	{
	   makeLake = 1;
	   makePonds = 0;
	}
      else if (featureChance < 4)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      else if (featureChance > 8)
	{
	   makeRiver = 1;
	   cliffChance = 0;
	   makePonds = 0;
	}
      makeCliffs = 0;

      nativePattern = 48;
   }
   else if (patternChance == 33) // MONGOLIA
   {   
      rmSetSeaType("Hudson Bay");
      rmSetMapType("mongolia");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("Mongolia");
	else
	   rmSetLightingSet("Pampas");
	if (twoChoice == 1)
	{
         baseType = "mongolia_grass_b";
         patchMixType = "mongolia_grass_a";
	   forestType = "Mongolian Forest";
	   treeType = "ypTreeMongolianFir";
	}
	else
	{
         baseType = "mongolia_desert";
         patchMixType = "mongolia_grass_b";
	   forestType = "Saxaul Forest";
         treeType = "ypTreeSaxaul";
	}
      if (variantChance == 1)
	{
         deerType = "ypSaiga";
         deer2Type = "Zebra";
         centerHerdType = "ypSaiga";         
	}
      else 
	{     
         deerType = "Zebra";
         deer2Type = "ypSaiga";
         centerHerdType = "Zebra";        
	}
      sheepType = "ypYak";
      fishType = "ypFishCatfish";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineCopper";
	else
	   mineType = "mine";
	specialPatch = 1;
	extraBerries = 2;
      if (twoChoice == 1)
	{
	   if (featureChance > 5)
            clearCenter = 1;
	}
	else
         clearCenterChance = 2;

      makeCliffs = 0;

      nativePattern = 50;
   }
   else if (patternChance == 34) // CEYLON  
   {   
      rmSetSeaType("ceylon coast");
      rmSetMapType("ceylon");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("ceylon");
	else
	   rmSetLightingSet("Great Lakes");
      baseType = "ceylon_grass_a";
      patchMixType = "ceylon_sand_a";
	forestType = "Ceylon Forest";
      cliffType = "ceylon";
	treeType = "ypTreeCeylon";
      if (variantChance == 1)
	{
         deerType = "ypNilgai";
         deer2Type = "ypWildElephant";
         centerHerdType = "ypNilgai";         
	}
      else 
	{     
         deerType = "ypNilgai";
         deer2Type = "ypNilgai";
         centerHerdType = "ypWildElephant";        
	}
      if (sheepChance == 1)
         sheepType = "ypWaterBuffalo";
      else
         sheepType = "ypGoat";
      fishType = "ypFishCarp";
	if (rmRandInt(1,2) == 1)
	   mineType = "minegold";
	else
	   mineType = "mine";
	extraBerries = 1;
	specialPatch = 1;
	if (featureChance < 3)
	{
	   makeCentralHighlands = 1;
	   makeCliffs = 2;
	}
	else if (featureChance < 5)	
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	   hillTrees = 0;
	}
      else if (featureChance == 5)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      nativePattern = 51;
   }
   else if (patternChance == 35) // YELLOW RIVER 
   {   
      rmSetSeaType("ceylon coast");
      rmSetMapType("yellowRiver");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("carolina");
	else
	   rmSetLightingSet("Great Lakes");
      baseType = "yellow_river_a";
      patchMixType = "yellow_river_b";
	dualForest = 1;
	if (twoChoice == 1)
	{
 	  forestType = "Yellow River Forest";
	  forest2Type = "Bamboo Forest";
   	  treeType = "ypTreeBamboo";
	}
	else
	{
 	  forestType = "Yellow River Forest";
	  forest2Type = "Ginkgo Forest";
   	  treeType = "ypTreeGinkgo";
	}
      riverType = "Yellow River";
	pondType = "Yellow River Flooded";
      cliffType = "Yellow River";
      if (variantChance == 1)
	{
         deerType = "ypMuskDeer";
         deer2Type = "ypNilgai";
         centerHerdType = "ypMuskDeer";         
	}
      else 
	{     
         deerType = "ypMuskDeer";
         deer2Type = "ypMuskDeer";
         centerHerdType = "ypNilgai";        
	}
      if (sheepChance == 1)
         sheepType = "ypWaterBuffalo";
      else
         sheepType = "ypGoat";
      fishType = "ypFishCarp";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineCopper";
	else
	   mineType = "mine";
	specialPatch = 1;
	makePonds = rmRandInt(1,8);
	if (featureChance == 1)
	{
	   makeLake = 1;
	   makePonds = 0;
	}
	if (featureChance < 4)
	{
	   makeCentralHighlands = 1;
	   cliffChance = 0;
	}
	else if (featureChance == 4)	
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	   hillTrees = 0;
	   makePonds = 0;
	}
      else if (featureChance == 5)
	{
	   forestMt = 1;
	   cliffChance = 0;
	}
      else if (featureChance > 8)
	{
	   makeRiver = 1;
	   cliffChance = 0;
	   makePonds = 0;
	}
	if (cliffChance > 7)
         makeCliffs = 1;

	if (cliffChance > 5)
         makeCliffs = 1;

      nativePattern = 52;
   }
   else if (patternChance == 36) // SIBERIA  
   {   
      rmSetSeaType("new england coast");
      rmSetMapType("deccan");
	rmSetMapType("grass");
	if (featureChance == 7)
	   rmSetLightingSet("great plains");
	else
	{
	   if (lightingChance == 1)
	      rmSetLightingSet("great plains");
	   else
            rmSetLightingSet("texas");
	}
	if (lightingChance == 1)
	   baseType = "texas_grass";
	else
         baseType = "texas_grass";
	forestType = "texas forest";
	riverType = "Pampas River";
      cliffType = "Texas Grass";
	pondType = "texas pond";
	treeType = "TreeTexasDirt";
      if (variantChance == 1)
	{
         deerType = "Zebra";
         deer2Type = "ypWildElephant";
         centerHerdType = "ypWildElephant";
	}
      else 
	{     
         deerType = "ypWildElephant";
         deer2Type = "Zebra";
         centerHerdType = "Zebra";
	}
      sheepType = "ypWaterBuffalo";
      fishType = "FishBass";
	mineType = "mine";
      vultures = 1;
      clearCenterChance = 1;
      makeCliffs = 1;
      if (featureChance < 4)
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	}
	else if (featureChance < 7)
	{
	   makeCentralHighlands = 1;
	   makeCliffs = 2;
	}
	else if (featureChance == 10)
	{
	   makeRiver = 1;
	   makeCliffs = 2;
	   clearCenterChance = 0;
	}

	nativeChoice = rmRandInt(1,6);
	if (nativeChoice == 1)
	   nativePattern = 30;
	else if (nativeChoice == 2)
	   nativePattern = 29;
	else if (nativeChoice == 3)
	   nativePattern = 32;
	else if (nativeChoice == 4)
	   nativePattern = 31;
	else if (nativeChoice == 5)
	   nativePattern = 38;
	else
	   nativePattern = 39;
   }
   else if (patternChance == 37) // GREEN SIBERIA  
   {
      rmSetSeaType("Northwest Territory Water");   
      rmSetMapType("mongolia");
      rmSetMapType("grass");
	if (lightingChance == 2)
	   rmSetLightingSet("nwterritory");
	else
         rmSetLightingSet("saguenay");
      baseType = "nwt_grass1";
      forestType = "NW Territory Forest";
      treeType = "TreeGreatPlains";   
	riverType = "Northwest Territory Water";
	cliffType = "Araucania Central";    
	pondType = "Northwest Territory Water";
      if (variantChance == 1)
	{
         deerType = "ypMuskDeer";
         deer2Type = "ypSaiga";
         centerHerdType = "ypSaiga";         
	}
      else 
	{     
         deerType = "ypSaiga";
         deer2Type = "ypMuskDeer";
         centerHerdType = "ypSaiga";        
	}
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "ypGoat"; 
      eagles = 1;
      fishType = "FishSalmon";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineTin";
	else
	   mineType = "mine";
      hillTrees = rmRandInt(0,1);
	coverUp = 1;
	makePonds = rmRandInt(1,4);
      if (featureChance < 3)
	   makeLake = 1;
	else if (featureChance < 5)
	   makeCentralHighlands = 1;
      else if (featureChance < 7)
	{
	   makeCentralCanyon = 1;
	   makeCliffs = 2;
	   hillTrees = 0;
	}
	else if (featureChance == 10)
	{
	   makeRiver = 1;
	   makePonds = 0;
	   cliffChance = 0;
	}
	if (cliffChance > 7)
         makeCliffs = 1;
	if (twoChoice == 1)
         nativePattern = 52;
	else 
         nativePattern = 54;
   }

   tradeRouteType1 = "dirt";
   tradeRouteType2 = "dirt";
   if (patternChance > 28)
   {
      tradeRouteType1 = "water";
      tradeRouteType2 = "water";
   }

   if (clearCenterChance == 1)
      clearCenter = rmRandInt(1,2);
   if (clearCenterChance == 2)
      clearCenter = rmRandInt(1,4);
   if (clearCenterChance == 3)
      clearCenter = rmRandInt(1,6);
   if (clearCenter > 1)
	clearCenter = 0;

   rmSetBaseTerrainMix(baseType);
   rmTerrainInitialize("yukon\ground1_yuk", 1);
   rmEnableLocalWater(false);
   rmSetMapType("land");
   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);

// Native patterns
  if (nativePattern == 1)
  {
      rmSetSubCiv(0, "Cherokee");
      native1Name = "native cherokee village ";
      rmSetSubCiv(1, "Iroquois");
      native2Name = "native iroquois village ";
  }
  else if (nativePattern == 2)
  {
      rmSetSubCiv(0, "Comanche");
      native1Name = "native comanche village ";
      rmSetSubCiv(1, "Lakota");
      native2Name = "native lakota village ";
  }
  else if (nativePattern == 3)
  {
      rmSetSubCiv(0, "Cherokee");
      native1Name = "native cherokee village ";
      rmSetSubCiv(1, "Seminoles");
      native2Name = "native seminole village ";
  }
  else if (nativePattern == 4)
  {
      rmSetSubCiv(0, "Cheyenne");
      native1Name = "native cheyenne village ";
      rmSetSubCiv(1, "Huron");
      native2Name = "native huron village ";
  }
  else if (nativePattern == 5)
  {
      rmSetSubCiv(0, "Huron");
      native1Name = "native huron village ";
      rmSetSubCiv(1, "Cree");
      native2Name = "native cree village ";
  }
  else if (nativePattern == 6)
  {
      rmSetSubCiv(0, "Nootka");
      native1Name = "native nootka village ";
      rmSetSubCiv(1, "Cree");
      native2Name = "native cree village ";
  }
  else if (nativePattern == 7)
  {
      rmSetSubCiv(0, "Nootka");
      native1Name = "native nootka village ";
      rmSetSubCiv(1, "Cheyenne");
      native2Name = "native cheyenne village ";
  }
  else if (nativePattern == 8)
  {
      rmSetSubCiv(0, "Cree");
      native1Name = "native cree village ";
      rmSetSubCiv(1, "Cheyenne");
      native2Name = "native cheyenne village ";
  }
  else if (nativePattern == 9)
  {
      rmSetSubCiv(0, "Seminoles");
      native1Name = "native seminole village ";
      rmSetSubCiv(1, "Comanche");
      native2Name = "native comanche village ";
  }
  else if (nativePattern == 10)
  {
      rmSetSubCiv(0, "Zapotec");
      native1Name = "native zapotec village ";
      rmSetSubCiv(1, "Comanche");
      native2Name = "native comanche village ";
  }
  else if (nativePattern == 11)
  {
      rmSetSubCiv(0, "Mapuche");
      native1Name = "native mapuche village ";
      rmSetSubCiv(1, "Maya");
      native2Name = "native maya village ";
  }
  else if (nativePattern == 12)
  {
      rmSetSubCiv(0, "Caribs");
      native1Name = "native carib village ";
      rmSetSubCiv(1, "Maya");
      native2Name = "native maya village ";
  }
  else if (nativePattern == 13)
  {
      rmSetSubCiv(0, "Caribs");
      native1Name = "native carib village ";
      rmSetSubCiv(1, "Tupi");
      native2Name = "native tupi village ";
  }
  else if (nativePattern == 14)
  {
      rmSetSubCiv(0, "Incas");
      native1Name = "native inca village ";
      rmSetSubCiv(1, "Tupi");
      native2Name = "native tupi village ";
  }
  else if (nativePattern == 15)
  {
      rmSetSubCiv(0, "Maya");
      native1Name = "native maya village ";
      rmSetSubCiv(1, "Tupi");
      native2Name = "native tupi village ";
  }
  else if (nativePattern == 16)
  {
      rmSetSubCiv(0, "Nootka");
      native1Name = "native nootka village ";
      rmSetSubCiv(1, "Huron");
      native2Name = "native huron village ";
  }
  else if (nativePattern == 17)
  {
      rmSetSubCiv(0, "Incas");
      native1Name = "native inca village ";
      rmSetSubCiv(1, "Aztecs");
      native2Name = "native aztec village ";
  }
  else if (nativePattern == 18)
  {
      rmSetSubCiv(0, "Incas");
      native1Name = "native inca village ";
      rmSetSubCiv(1, "Caribs");
      native2Name = "native carib village ";
  }
  else if (nativePattern == 19)
  {
      rmSetSubCiv(0, "Cherokee");
      native1Name = "native cherokee village ";
      rmSetSubCiv(1, "Cheyenne");
      native2Name = "native cheyenne village ";
  }
  else if (nativePattern == 20)
  {
      rmSetSubCiv(0, "Cherokee");
      native1Name = "native cherokee village ";
      rmSetSubCiv(1, "Comanche");
      native2Name = "native comanche village ";
  }
  else if (nativePattern == 21)
  {
      rmSetSubCiv(0, "Seminoles");
      native1Name = "native seminole village ";
      rmSetSubCiv(1, "Huron");
      native2Name = "native huron village ";
  }
  else if (nativePattern == 22)
  {
      rmSetSubCiv(0, "Cherokee");
      native1Name = "native cherokee village ";
      rmSetSubCiv(1, "Cree");
      native2Name = "native cree village ";
  }
  else if (nativePattern == 23)
  {
      rmSetSubCiv(0, "Comanche");
      native1Name = "native comanche village ";
      rmSetSubCiv(1, "Cree");
      native2Name = "native cree village ";
  }
  else if (nativePattern == 24)
  {
      rmSetSubCiv(0, "Incas");
      native1Name = "native inca village ";
      rmSetSubCiv(1, "Maya");
      native2Name = "native maya village ";
  }
  else if (nativePattern == 25)
  {
      rmSetSubCiv(0, "Incas");
      native1Name = "native inca village ";
      rmSetSubCiv(1, "Mapuche");
      native2Name = "native mapuche village ";
  }
  else if (nativePattern == 26)
  {
      rmSetSubCiv(0, "Tupi");
      native1Name = "native tupi village ";
      rmSetSubCiv(1, "Mapuche");
      native2Name = "native mapuche village ";
  }
  else if (nativePattern == 27)
  {
      rmSetSubCiv(0, "Klamath");
      native1Name = "native klamath village ";
      rmSetSubCiv(1, "Nootka");
      native2Name = "native nootka village ";
  }
  else if (nativePattern == 28)
  {
      rmSetSubCiv(0, "Klamath");
      native1Name = "native klamath village ";
      rmSetSubCiv(1, "Cheyenne");
      native2Name = "native cheyenne village ";
  }
  else if (nativePattern == 29)
  {
      rmSetSubCiv(0, "Comanche");
      native1Name = "native comanche village ";
      rmSetSubCiv(1, "Cheyenne");
      native2Name = "native cheyenne village ";
  }
  else if (nativePattern == 30)
  {
      rmSetSubCiv(0, "Apache");
      native1Name = "native apache village ";
      rmSetSubCiv(1, "Cheyenne");
      native2Name = "native cheyenne village ";
  }
  else if (nativePattern == 31)
  {
      rmSetSubCiv(0, "Apache");
      native1Name = "native apache village ";
      rmSetSubCiv(1, "Navajo");
      native2Name = "native navajo village ";
  }
  else if (nativePattern == 32)
  {
      rmSetSubCiv(0, "Apache");
      native1Name = "native apache village ";
      rmSetSubCiv(1, "Comanche");
      native2Name = "native comanche village ";
  }
  else if (nativePattern == 33)
  {
      rmSetSubCiv(0, "Apache");
      native1Name = "native apache village ";
      rmSetSubCiv(1, "Zapotec");
      native2Name = "native zapotec village ";
  }
  else if (nativePattern == 34)
  {
      rmSetSubCiv(0, "Incas");
      native1Name = "native inca village ";
      rmSetSubCiv(1, "Zapotec");
      native2Name = "native zapotec village ";
  }
  else if (nativePattern == 35)
  {
      rmSetSubCiv(0, "Maya");
      native1Name = "native maya village ";
      rmSetSubCiv(1, "Zapotec");
      native2Name = "native zapotec village ";
  }
  else if (nativePattern == 36)
  {
      rmSetSubCiv(0, "Caribs");
      native1Name = "native carib village ";
      rmSetSubCiv(1, "Zapotec");
      native2Name = "native zapotec village ";
  }
  else if (nativePattern == 37)
  {
      rmSetSubCiv(0, "Navajo");
      native1Name = "native navajo village ";
      rmSetSubCiv(1, "Zapotec");
      native2Name = "native zapotec village ";
  }
  else if (nativePattern == 38)
  {
      rmSetSubCiv(0, "Navajo");
      native1Name = "native navajo village ";
      rmSetSubCiv(1, "Comanche");
      native2Name = "native comanche village ";
  }
  else if (nativePattern == 39)
  {
      rmSetSubCiv(0, "Navajo");
      native1Name = "native navajo village ";
      rmSetSubCiv(1, "Cheyenne");
      native2Name = "native cheyenne village ";
  }
  else if (nativePattern == 40)
  {
      rmSetSubCiv(0, "Cherokee");
      native1Name = "native cherokee village ";
      rmSetSubCiv(1, "Huron");
      native2Name = "native huron village ";
  }
  else if (nativePattern == 41)
  {
      rmSetSubCiv(0, "Lakota");
      native1Name = "native lakota village ";
      rmSetSubCiv(1, "Huron");
      native2Name = "native huron village ";
  }
  else if (nativePattern == 42)
  {
      rmSetSubCiv(0, "Caribs");
      native1Name = "native carib village ";
      rmSetSubCiv(1, "Seminoles");
      native2Name = "native seminole village ";
  }
  else if (nativePattern == 43)
  {
      rmSetSubCiv(0, "Apache");
      native1Name = "native apache village ";
      rmSetSubCiv(1, "Klamath");
      native2Name = "native klamath village ";
  }
  else if (nativePattern == 44)
  {
      rmSetSubCiv(0, "aztecs");
      native1Name = "native Aztec village ";
      rmSetSubCiv(1, "udasi");
      native2Name = "native udasi village ";
  }
  else if (nativePattern == 45)
  {
      rmSetSubCiv(0, "udasi");
      native1Name = "native udasi village ";
      rmSetSubCiv(1, "bhakti");
      native2Name = "native bhakti village ";
  }
  else if (nativePattern == 46)
  {
      rmSetSubCiv(0, "sufi");
      native1Name = "native sufi mosque deccan ";
      rmSetSubCiv(1, "bhakti");
      native2Name = "native bhakti village ";
  }
  else if (nativePattern == 47)
  {
      rmSetSubCiv(0, "udasi");
      native1Name = "native udasi village ";
      rmSetSubCiv(1, "sufi");
      native2Name = "native sufi mosque deccan ";
  }
  else if (nativePattern == 48)
  {
      rmSetSubCiv(0, "sufi");
      native1Name = "native sufi mosque borneo ";
      rmSetSubCiv(1, "jesuit");
      native2Name = "native jesuit mission borneo 0";
  }
  else if (nativePattern == 49)
  {
      rmSetSubCiv(0, "udasi");
      native1Name = "native udasi village himal ";
      rmSetSubCiv(1, "bhakti");
      native2Name = "native bhakti village himal ";
  }
  else if (nativePattern == 50)
  {
      rmSetSubCiv(0, "sufi");
      native1Name = "native sufi mosque mongol ";
      rmSetSubCiv(1, "bhakti");
      native2Name = "native bhakti village ceylon ";
  }
  else if (nativePattern == 51)
  {
      rmSetSubCiv(0, "aztecs");
      native1Name = "native Aztec village ";
      rmSetSubCiv(1, "bhakti");
      native2Name = "native bhakti village ceylon ";
  }
  else if (nativePattern == 52)
  {
      rmSetSubCiv(0, "sufi");
      native1Name = "native sufi mosque mongol ";
      rmSetSubCiv(1, "aztecs");
      native2Name = "native Aztec village ";
  }
  else if (nativePattern == 53)
  {
      rmSetSubCiv(0, "aztecs");
      native1Name = "native Aztec village ";
      rmSetSubCiv(1, "aztecs");
      native2Name = "native shaolin temple mongol 0";
  }
  else if (nativePattern == 54)
  {
      rmSetSubCiv(0, "aztecs");
      native1Name = "native Aztec village ";
      rmSetSubCiv(1, "jesuit");
      native2Name = "native jesuit mission borneo 0";
  }

// Precipitation
   if ((patternChance == 14) || (patternChance == 16)) // yucatan, amazon    
      if (lightingChance == 2)
         rmSetGlobalRain( 0.5 );
   if (patternChance == 7) // yukon
      rmSetGlobalSnow( 1.0 );
   if ((patternChance == 5) || (patternChance == 20) || (patternChance == 24)) // gl winter, yukon tundra, s araucania 
      if (lightingChance == 2)    
         rmSetGlobalSnow( 0.7 );
   if (patternChance == 8) // rockies
      if (lightingChance == 2)
         rmSetGlobalSnow( 0.5 );
   if ((patternChance == 32) || (patternChance == 29)) // himalayas, siberia
      if (rmRandInt(1,2) == 2)
         rmSetGlobalRain( 0.3 );
   if (patternChance == 30) // deccan
      if (twoChoice == 2)
         rmSetGlobalRain( 0.3 ); 

   if (patternChance == 27) // nwt
   {
	// Make it rain
	rmSetGlobalRain( 1.0 );
	rmSetGlobalStormLength(1.0, 0.0);

	// Sets up the rain triggers 
	rmCreateTrigger("ChangeRain1");
	rmSwitchToTrigger(rmTriggerID("ChangeRain1"));
	rmSetTriggerActive(true);
	rmAddTriggerCondition("Timer");
	rmSetTriggerConditionParamInt("Param1", 20);
	rmAddTriggerEffect("Render Rain");
	rmSetTriggerEffectParamFloat("Percent", 0.3);

	rmCreateTrigger("ChangeRain2");
	rmSwitchToTrigger(rmTriggerID("ChangeRain2"));
	rmSetTriggerActive(true);
	rmAddTriggerCondition("Timer");
	rmSetTriggerConditionParamInt("Param1", 40);
	rmAddTriggerEffect("Render Rain");
	rmSetTriggerEffectParamFloat("Percent", 1.0);

	rmCreateTrigger("ChangeRain3");
	rmSwitchToTrigger(rmTriggerID("ChangeRain3"));
	rmSetTriggerActive(true);
	rmAddTriggerCondition("Timer");
	rmSetTriggerConditionParamInt("Param1", 60);
	rmAddTriggerEffect("Render Rain");
	rmSetTriggerEffectParamFloat("Percent", 0.3);

	rmCreateTrigger("ChangeRain4");
	rmSwitchToTrigger(rmTriggerID("ChangeRain4"));
	rmSetTriggerActive(true);
	rmAddTriggerCondition("Timer");
	rmSetTriggerConditionParamInt("Param1", 75);
	rmAddTriggerEffect("Render Rain");
	rmSetTriggerEffectParamFloat("Percent", 0.0);
   }
   
   chooseMercs();

// Define some classes.
   int classPlayer=rmDefineClass("player");
   int lakeClass=rmDefineClass("lake");
   rmDefineClass("classHill");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("classCliff");
   rmDefineClass("center");
   rmDefineClass("classNugget");
   rmDefineClass("socketClass");
   rmDefineClass("classIce");
   rmDefineClass("classClearing"); 
   int classHuntable=rmDefineClass("huntableFood");   
   int classHerdable=rmDefineClass("herdableFood"); 
   int canyon=rmDefineClass("canyon");

   // Text
   rmSetStatusText("",0.10);

// -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int secondEdgeConstraint=rmCreateBoxConstraint("bison edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int circleConstraintMt=rmCreatePieConstraint("circle Constraint for mts", 0.5, 0.5, 0, rmZFractionToMeters(0.2), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Center constraints
   int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 30.0);
   int centerConstraintShort=rmCreateClassDistanceConstraint("stay away from center short", rmClassID("center"), 12.0);
   int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 70.0);
   int centerConstraintForest=rmCreateClassDistanceConstraint("stay away from center forest", rmClassID("center"), rmZFractionToMeters(0.24));
   int centerConstraintForest2=rmCreateClassDistanceConstraint("stay away from center forest 2", rmClassID("center"), rmZFractionToMeters(0.22));
   int centerConstraintForest3=rmCreateClassDistanceConstraint("stay away from center forest 3", rmClassID("center"), rmZFractionToMeters(0.21));
   int centerConstraintForest4=rmCreateClassDistanceConstraint("stay away from center forest 4", rmClassID("center"), rmZFractionToMeters(0.20));

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 40.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 25.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 60.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 85.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 105.0);
   int enormousPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players for asymmetric starts", classPlayer, 130.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0); 

   // Nature avoidance
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int shortForestConstraint=rmCreateClassDistanceConstraint("patch vs. forest", rmClassID("classForest"), 15.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), forestDist);
   int longForestConstraint=rmCreateClassDistanceConstraint("long forest vs. forest", rmClassID("classForest"), 26.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 10.0);
   int shortAvoidSilver=rmCreateTypeDistanceConstraint("short gold avoid gold", "Mine", 20.0);
   int coinAvoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidSheep=rmCreateClassDistanceConstraint("sheep avoids sheep etc", rmClassID("herdableFood"), 45.0);
   int huntableConstraint=rmCreateClassDistanceConstraint("huntable constraint", rmClassID("huntableFood"), 35.0);
   int longHuntableConstraint=rmCreateClassDistanceConstraint("long huntable constraint", rmClassID("huntableFood"), 55.0);
   int forestsAvoidBison=rmCreateClassDistanceConstraint("forest avoids bison", rmClassID("huntableFood"), 15.0);
   int avoidDucks=rmCreateTypeDistanceConstraint("avoids ducks", "DuckFamily", 50.0);

   // Avoid impassable land, certain features
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 18.0);
   int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 15.0);
   int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
   int longHillConstraint=rmCreateClassDistanceConstraint("far from hill", rmClassID("classHill"), 35.0);
   int medHillConstraint=rmCreateClassDistanceConstraint("medium from hill", rmClassID("classHill"), 25.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 8.0);
   int avoidCliffs=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
   int avoidCliffsShort=rmCreateClassDistanceConstraint("stuff vs. cliff short", rmClassID("classCliff"), 7.0);
   int cliffsAvoidCliffs=rmCreateClassDistanceConstraint("cliffs vs. cliffs", rmClassID("classCliff"), 30.0);
   int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water mid-long", "Land", false, 10.0);
   int avoidWater15 = rmCreateTerrainDistanceConstraint("avoid water mid-longer", "Land", false, 15.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water a little more", "Land", false, 20.0);
   int avoidWater30 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 30.0);
   int avoidCanyons=rmCreateClassDistanceConstraint("avoid canyons", rmClassID("canyon"), 35.0);
   int shortAvoidCanyons=rmCreateClassDistanceConstraint("short avoid canyons", rmClassID("canyon"), 15.0);
   int nearShore=rmCreateTerrainMaxDistanceConstraint("tree v. water", "land", true, 14.0);
   int rockVsLand = rmCreateTerrainDistanceConstraint("rock v. land", "land", true, 2.0);
   int avoidLakes=rmCreateClassDistanceConstraint("stuff vs.lakes", rmClassID("lake"), 12.0);
   int avoidLakesFar=rmCreateClassDistanceConstraint("stuff vs.lakes far", rmClassID("lake"), 55.0);
   int avoidIce=rmCreateClassDistanceConstraint("stuff vs.ice", rmClassID("classIce"), 12.0);
   int avoidClearing=rmCreateClassDistanceConstraint("avoid clearings", rmClassID("classClearing"), 11.0);  
  
   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 10.0);
   int avoidStartingUnitsLarge=rmCreateClassDistanceConstraint("objects avoid starting units large", rmClassID("startingUnit"), 50.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 7.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 55.0);
   int avoidNativesMed=rmCreateClassDistanceConstraint("stuff avoids natives medium", rmClassID("natives"), 35.0);
   int avoidNativesShort=rmCreateClassDistanceConstraint("stuff avoids natives shorter", rmClassID("natives"), 15.0);
   int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget", rmClassID("classNugget"), 42.0);
   int avoidNuggetMed=rmCreateClassDistanceConstraint("nugget vs. nugget med", rmClassID("classNugget"), 50.0);
   int avoidNuggetLong=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 65.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 13.0);

// End of constraints -----------------------------------

// Set up of trade routes for special situations
   if (makeRiver == 1)
   {
	if (trPattern == 0)
	   trPattern = 1;
	if (trPattern == 3)
	   trPattern = 2;
	if (trPattern == 6)
	   trPattern = 4;
	if (trPattern == 7)
	   trPattern = 5;
	if (trPattern == 8)
	   trPattern = 9;
	if (trPattern == 10)
	   trPattern = 11;
   }

   if ((makeLake == 1) || (makeIce == 1) || (makeCentralCanyon == 1) || (makeCentralHighlands == 1))      
   {
	if ((trPattern == 6) || (trPattern == 10))   
	{
	   if (rmRandInt(1,10) == 10)
		trPattern = 11;
	   else
	   {
	   if (rmRandInt(1,3) == 1)
	      trPattern = rmRandInt(7,9);
	   else
	      trPattern = rmRandInt(0,5);
	   }
	}
   }

   if ((forestMt == 1) || (centerMt == 1))      
   {
      if (mtPattern == 1)
	{
	   if (rmRandInt(1,10) == 10)
		trPattern = 11;
	   else
	   {
	   if (rmRandInt(1,3) == 1)
	      trPattern = rmRandInt(7,9);
	   else
	      trPattern = rmRandInt(0,5);
	   }
	}
   }

// Set up for native positions based on trade route
   if (trPattern > 7)
	endPosition = rmRandInt(1,2);
   if (trPattern == 2)
	endPosition = rmRandInt(2,3);
   if (trPattern == 3)
	endPosition = rmRandInt(2,3);
   if (trPattern == 0)
   {
	if (rmRandInt(1,2) == 1)
	   endPosition = 3;
	else
	   endPosition = 1;
   }
   if (trPattern == 1)
   {
	if (rmRandInt(1,2) == 1)
	   endPosition = 3;
	else
	   endPosition = 1;
   }

// Set up for player start area distance from center
   if (trPattern < 2)
   {
	if (rmRandInt(1,4) == 1)
         distChance = 4;
	else
         distChance = rmRandInt(1,2);
   }
   if ((trPattern == 8) || (trPattern == 9)) 
	distChance = rmRandInt(2,4);
   if (trPattern == 11)
	distChance = rmRandInt(1,2);

// Set up player starting locations
if (cNumberNonGaiaPlayers == 2)
{
   sectionChance = rmRandInt(1,13);
   if (trPattern == 4)
      sectionChance = rmRandInt(1,9);
   if (trPattern == 5) 
      sectionChance = rmRandInt(1,9);
   if (axisChance == 1)
   {
      if (playerSide == 1)
      {
	     rmSetPlacementTeam(0);
      }
      else if (playerSide == 2)
      {
		rmSetPlacementTeam(1);
      }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.24, 0.26);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.29, 0.31);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.19, 0.21);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.14, 0.16);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.34, 0.36);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.34, 0.36);
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.14, 0.16);
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.29, 0.31);
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.19, 0.21);
	    else if (sectionChance == 10)
             rmSetPlacementSection(0.09, 0.11);
	    else if (sectionChance == 11)
             rmSetPlacementSection(0.89, 0.91);
	    else if (sectionChance == 12)
             rmSetPlacementSection(0.09, 0.11);
	    else if (sectionChance == 13)
             rmSetPlacementSection(0.39, 0.41);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.38, 0.40, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.74, 0.76);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.79, 0.81);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.69, 0.71);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.64, 0.66);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.84, 0.86);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.64, 0.66);
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.84, 0.86);
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.69, 0.71);
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.79, 0.81);
	    else if (sectionChance == 10)
             rmSetPlacementSection(0.39, 0.41);
	    else if (sectionChance == 11)
             rmSetPlacementSection(0.59, 0.61);
	    else if (sectionChance == 12)
             rmSetPlacementSection(0.59, 0.61);
	    else if (sectionChance == 13)
             rmSetPlacementSection(0.89, 0.91);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.38, 0.40, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);
   }
   else if (axisChance == 2)
   {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.49, 0.51);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.44, 0.46);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.54, 0.56);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.39, 0.41);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.59, 0.61);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.89, 0.91);
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.09, 0.11);
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.54, 0.56);
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.44, 0.46);
	    else if (sectionChance == 10)
             rmSetPlacementSection(0.14, 0.16);
	    else if (sectionChance == 11)
             rmSetPlacementSection(0.34, 0.36);
	    else if (sectionChance == 12)
             rmSetPlacementSection(0.34, 0.36);
	    else if (sectionChance == 13)
             rmSetPlacementSection(0.64, 0.66);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.38, 0.40, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.99, 0.01);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.94, 0.96);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.04, 0.06);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.89, 0.91);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.09, 0.11);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.59, 0.61);
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.39, 0.41);
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.94, 0.96);
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.04, 0.06);
	    else if (sectionChance == 10)
             rmSetPlacementSection(0.84, 0.86);
	    else if (sectionChance == 11)
             rmSetPlacementSection(0.64, 0.66);
	    else if (sectionChance == 12)
             rmSetPlacementSection(0.84, 0.86);
	    else if (sectionChance == 13)
             rmSetPlacementSection(0.14, 0.16);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.40, 0.41, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.38, 0.40, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);
   }
}   
else 
{ 
   if (cNumberTeams == 2)
   {
      if (cNumberNonGaiaPlayers == 4) // 2 teams, 4 players 
      {
	  sectionChance = rmRandInt(1,6);
        if (axisChance == 1)
        {
          if (playerSide == 1)
          {
	  	rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.21, 0.29);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.19, 0.31);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.18, 0.32);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.17, 0.33);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.16, 0.26);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.24, 0.34);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.41, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.71, 0.79);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.69, 0.81);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.68, 0.82);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.67, 0.83);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.66, 0.76);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.74, 0.84);          

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.41, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);
        }
        else if (axisChance == 2)
        {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.46, 0.54);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.44, 0.56);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.43, 0.57);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.42, 0.58);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.41, 0.51);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.49, 0.59);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.41, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.96, 0.04);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.94, 0.06);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.93, 0.07);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.92, 0.08);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.91, 0.01);
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.99, 0.09);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.41, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);
        } 
      }
      else if (cNumberNonGaiaPlayers <7) // for 2 teams, for 3 or 5-6 players
      {
        if (axisChance == 1)
        {
          if (playerSide == 1)
          {
	  	rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.17, 0.33);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.15, 0.35);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.13, 0.37);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.41, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.67, 0.83);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.65, 0.85);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.63, 0.87);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.41, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);
        }
        else if (axisChance == 2)
        {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.42, 0.58);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.40, 0.60);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.38, 0.62);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.41, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.92, 0.08);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.90, 0.10);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.88, 0.12);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.41, 0.43, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);
        }
      }
      else  // for 2 teams, for over 6 players
      {
        if (axisChance == 1)
        {
          if (playerSide == 1)
          {
	  	rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.15, 0.35);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.13, 0.37);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.11, 0.39);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.43, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.65, 0.85);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.63, 0.87);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.61, 0.89);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.43, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);
        }
        else if (axisChance == 2)
        {
	    if (playerSide == 1)
          {
		rmSetPlacementTeam(0);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(1);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.40, 0.60);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.38, 0.62);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.36, 0.64);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.43, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);

	    if (playerSide == 1)
          {
		rmSetPlacementTeam(1);
	    }
          else if (playerSide == 2)
	    {
		rmSetPlacementTeam(0);
	    }
	    if (sectionChance == 1)
             rmSetPlacementSection(0.90, 0.10);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.88, 0.12);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.86, 0.14);

	    if (distChance == 1)
	       rmPlacePlayersCircular(0.43, 0.45, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);
        }
      }
   }
   else  // for FFA or over 2 teams
   {
      if (cNumberNonGaiaPlayers == 3) 
      {
		if (ffaChance == 1)
		{
   		   rmPlacePlayer(1, 0.31, 0.71);
		   rmPlacePlayer(2, 0.69, 0.71);
		   rmPlacePlayer(3, 0.69, 0.29);
		}
		else if (ffaChance == 2)
		{
   		   rmPlacePlayer(2, 0.31, 0.71);
		   rmPlacePlayer(3, 0.69, 0.71);
		   rmPlacePlayer(1, 0.69, 0.29);
		}		
		else if (ffaChance == 3)
		{
   		   rmPlacePlayer(3, 0.31, 0.71);
		   rmPlacePlayer(1, 0.69, 0.71);
		   rmPlacePlayer(2, 0.69, 0.29);
		}
		else
            { 
	      if (distChance == 1)
	         rmPlacePlayersCircular(0.41, 0.43, 0.0);
	      else if (distChance == 2)
	         rmPlacePlayersCircular(0.39, 0.41, 0.0);
	      else if (distChance == 3)
	         rmPlacePlayersCircular(0.35, 0.37, 0.0);
	      else if (distChance == 4)
	         rmPlacePlayersCircular(0.30, 0.32, 0.0);
            }
      }
      else if (cNumberNonGaiaPlayers == 4) 
      {
		if (ffaChance == 1)
		{
   		   rmPlacePlayer(1, 0.31, 0.71);
		   rmPlacePlayer(2, 0.69, 0.71);
		   rmPlacePlayer(3, 0.69, 0.29);
		   rmPlacePlayer(4, 0.31, 0.29);
		}
		else if (ffaChance == 2)
		{
   		   rmPlacePlayer(2, 0.31, 0.71);
		   rmPlacePlayer(3, 0.69, 0.71);
		   rmPlacePlayer(4, 0.69, 0.29);
		   rmPlacePlayer(1, 0.31, 0.29);
		}		
		else if (ffaChance == 3) 
		{
   		   rmPlacePlayer(3, 0.31, 0.71);
		   rmPlacePlayer(4, 0.69, 0.71);
		   rmPlacePlayer(1, 0.69, 0.29);
		   rmPlacePlayer(2, 0.31, 0.29);
		}
		else
            { 
	      if (distChance == 1)
	         rmPlacePlayersCircular(0.41, 0.43, 0.0);
	      else if (distChance == 2)
	         rmPlacePlayersCircular(0.39, 0.41, 0.0);
	      else if (distChance == 3)
	         rmPlacePlayersCircular(0.35, 0.37, 0.0);
	      else if (distChance == 4)
	         rmPlacePlayersCircular(0.30, 0.32, 0.0);
            }
	}
      else  // over 4 FFA 
      { 
	    if (distChance == 1)
	       rmPlacePlayersCircular(0.42, 0.44, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.39, 0.41, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.35, 0.37, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.30, 0.32, 0.0);
      }
   }
}

   // Text
   rmSetStatusText("",0.20);
	
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
      rmAddAreaConstraint(id, longAvoidImpassableLand);
      rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaMix(id, baseType);
      rmSetAreaWarnFailure(id, false);
   }
   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.30);

// Rivers
   if (makeRiver == 1)  
   {
      int riverWidthChance = rmRandInt(1,3);
      int rivermin = -1;
      int rivermax = -1;
      int riverVar = rmRandInt(12,18);
      int shallowPattern = rmRandInt(1,5);
      if ((trPattern == 2) || (trPattern == 4) || (trPattern == 5)|| (trPattern == 11))  // for less variability in river
      {
         riverWidthChance = rmRandInt(1,2);
	   riverVar = rmRandInt(10,14);
      }
      if (riverWidthChance == 1)
      {
	   rivermin = 7;
	   rivermax = 9;
      }
      else if (riverWidthChance == 2)
      {
         rivermin = 9;
	   rivermax = 11;
      }
      else
      {
         rivermin = 10;
	   rivermax = 12;
      }
	int singleRiver = rmRiverCreate(-1, riverType, 30, riverVar, rivermin, rivermax); 
	if (axisChance == 1)
	   rmRiverSetConnections(singleRiver, 0.5, 0.0, 0.5, 1.0);
	else
	   rmRiverSetConnections(singleRiver, 0.0, 0.5, 1.0, 0.5);
	if (shallowPattern < 3)
	{	
	   rmRiverSetShallowRadius(singleRiver, rmRandInt(9, 12));
	   rmRiverAddShallow(singleRiver, rmRandFloat(0.34, 0.42)); 

	   rmRiverSetShallowRadius(singleRiver, rmRandInt(9, 12));
	   rmRiverAddShallow(singleRiver, rmRandFloat(0.58, 0.66));
	}
	if (shallowPattern < 4)
	{
	   if (shallowPattern >1)
	   {	
	      rmRiverSetShallowRadius(singleRiver, rmRandInt(9, 12));
	      rmRiverAddShallow(singleRiver, rmRandFloat(0.05, 0.2)); 

	      rmRiverSetShallowRadius(singleRiver, rmRandInt(9, 12));
	      rmRiverAddShallow(singleRiver, rmRandFloat(0.8, 0.95));
	   }
	}
	if (shallowPattern > 3)
	{	
	   rmRiverSetShallowRadius(singleRiver, rmRandInt(9, 12));
	   rmRiverAddShallow(singleRiver, rmRandFloat(0.05, 0.2)); 

	   rmRiverSetShallowRadius(singleRiver, rmRandInt(9, 12));
	   rmRiverAddShallow(singleRiver, rmRandFloat(0.8, 0.95));
	}
	if (shallowPattern > 2)
	{
	   if (shallowPattern < 5)
	   {	
	      rmRiverSetShallowRadius(singleRiver, rmRandInt(9, 12));
	      rmRiverAddShallow(singleRiver, 0.5);
	   }
	}
	rmRiverSetBankNoiseParams(singleRiver, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
	rmRiverBuild(singleRiver);
   }

// Trade Routes
if (trPattern == 2) // 2 opposite inner semicircular routes
{
   // first route
   int tradeRouteID = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.59, 0.82);
	else	
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.54, 0.81);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.70);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.66, 0.56);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.54);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.46);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.66, 0.44);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.30);
	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.59, 0.18);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.54, 0.19);
   }
   else 
   {
	if (makeRiver == 1)	
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.18, 0.59);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.19, 0.54);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.28, 0.65);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.66);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.46, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.54, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.62, 0.66);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.65);
	if (makeRiver == 1)	
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.82, 0.59);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.81, 0.54);
   }
   rmBuildTradeRoute(tradeRouteID, tradeRouteType1);

   // second route
   int tradeRouteID2 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	if (makeRiver == 1)	
	   rmAddTradeRouteWaypoint(tradeRouteID2, 0.41, 0.18);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID2, 0.46, 0.19);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.35, 0.30);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.34, 0.44);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.32, 0.46);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.32, 0.54);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.34, 0.56);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.35, 0.70);
	if (makeRiver == 1)	
	   rmAddTradeRouteWaypoint(tradeRouteID2, 0.41, 0.82);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID2, 0.46, 0.81);
   }
   else
   {
	if (makeRiver == 1)	
	   rmAddTradeRouteWaypoint(tradeRouteID2, 0.18, 0.41);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID2, 0.19, 0.46);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.28, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.40, 0.33);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.47, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.53, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.60, 0.33);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.72, 0.35);
	if (makeRiver == 1)	
	   rmAddTradeRouteWaypoint(tradeRouteID2, 0.82, 0.41);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID2, 0.81, 0.46);
   }
   rmBuildTradeRoute(tradeRouteID2, tradeRouteType2);	
}
else if (trPattern == 3)  // one 'circular' inner route
{
   int tradeRouteID3 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.51, 0.8);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.66, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.68, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.66, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.5, 0.2);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.34, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.32, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.34, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.495, 0.8);
   }
   else 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.2, 0.51);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.40, 0.66);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.5, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.60, 0.66);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.8, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.60, 0.34);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.5, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.40, 0.34);
	rmAddTradeRouteWaypoint(tradeRouteID3, 0.2, 0.49);
   }
   rmBuildTradeRoute(tradeRouteID3, tradeRouteType1);
}
else if (trPattern == 4)  // two 'diagonal'
{
   int tradeRouteID4 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.6, 0.62);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 0.45);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.62, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.62, 0.45);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.6, 0.38);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.67, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4, 1.0, 0.67);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.62, 0.6);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.55, 0.67);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.45, 0.67);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.55, 0.62);
	   rmAddTradeRouteWaypoint(tradeRouteID4, 0.45, 0.62);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.38, 0.6);
	rmAddTradeRouteWaypoint(tradeRouteID4, 0.0, 0.67);
   }
   rmBuildTradeRoute(tradeRouteID4, tradeRouteType2);

   int tradeRouteID4A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
     rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.4, 0.62);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.45);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.38, 0.55);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.38, 0.45);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.4, 0.38);
      rmAddTradeRouteWaypoint(tradeRouteID4A, 0.33, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID4A, 1.0, 0.33);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.62, 0.4);
	if(variantChance == 1)
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.55, 0.33);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.45, 0.33);
	}
	else
	{
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.55, 0.38);
	   rmAddTradeRouteWaypoint(tradeRouteID4A, 0.45, 0.38);
	}
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.38, 0.4);
	rmAddTradeRouteWaypoint(tradeRouteID4A, 0.0, 0.33);
   }
   rmBuildTradeRoute(tradeRouteID4A, tradeRouteType1);
}
else if (trPattern == 5)  // two 'parabolas'
{
   int tradeRouteID5 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.68, 0.85);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.6, 0.62);
      if ((makeCentralCanyon == 1) || (makeCentralHighlands == 1) || (makeRiver == 1)) 
    	   rmAddTradeRouteWaypoint(tradeRouteID5, 0.585, 0.5);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID5, 0.54, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.6, 0.38);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.68, 0.15);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.85, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.62, 0.6);
      if ((makeCentralCanyon == 1) || (makeCentralHighlands == 1) || (makeRiver == 1)) 
	   rmAddTradeRouteWaypoint(tradeRouteID5, 0.5, 0.585);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID5, 0.5, 0.54);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.38, 0.6);
	rmAddTradeRouteWaypoint(tradeRouteID5, 0.15, 0.68);
   }
   rmBuildTradeRoute(tradeRouteID5, tradeRouteType1);

   int tradeRouteID5A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.32, 0.85);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.4, 0.62);
      if ((makeCentralCanyon == 1) || (makeCentralHighlands == 1) || (makeRiver == 1))  
         rmAddTradeRouteWaypoint(tradeRouteID5A, 0.415, 0.5);
	else
         rmAddTradeRouteWaypoint(tradeRouteID5A, 0.46, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.4, 0.38);
      rmAddTradeRouteWaypoint(tradeRouteID5A, 0.32, 0.15);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.85, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.62, 0.4);
      if ((makeCentralCanyon == 1) || (makeCentralHighlands == 1) || (makeRiver == 1))  
	   rmAddTradeRouteWaypoint(tradeRouteID5A, 0.5, 0.415);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID5A, 0.5, 0.46);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.38, 0.4);
	rmAddTradeRouteWaypoint(tradeRouteID5A, 0.15, 0.32);
   }
   rmBuildTradeRoute(tradeRouteID5A, tradeRouteType2);
}
else if (trPattern == 6)  // one diagonal
{
   int tradeRouteID6 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 0.0);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.48, 0.2);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.52, 0.35);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.48, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.52, 0.8);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 1.0);
   }
   else
   {
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.0, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.2, 0.48);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.35, 0.52);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.5, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.65, 0.48);
	rmAddTradeRouteWaypoint(tradeRouteID6, 0.8, 0.52);
	rmAddTradeRouteWaypoint(tradeRouteID6, 1.0, 0.5);
   }
   rmBuildTradeRoute(tradeRouteID6, tradeRouteType1);	
}
else if (trPattern == 7) // 2 intersecting 'parabolas'
{
   // first route
   int tradeRouteID7 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.4, 1.0);	
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.58, 0.82);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.66, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.68, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.66, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.58, 0.18);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.4, 0.0);
   }
   else 
   {	
	rmAddTradeRouteWaypoint(tradeRouteID7, 1.0, 0.4);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.82, 0.58);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.60, 0.66);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.5, 0.68);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.40, 0.66);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.18, 0.58);
	rmAddTradeRouteWaypoint(tradeRouteID7, 0.0, 0.4);
   }
   rmBuildTradeRoute(tradeRouteID7, tradeRouteType1);

   // second route
   int tradeRouteID7A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.6, 0.0);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.42, 0.18);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.34, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.32, 0.5);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.34, 0.55);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.42, 0.82);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.6, 1.0);
   }
   else
   {
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.0, 0.6);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.18, 0.42);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.40, 0.34);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.5, 0.32);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.60, 0.34);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 0.82, 0.42);
	rmAddTradeRouteWaypoint(tradeRouteID7A, 1.0, 0.6);
   }
   rmBuildTradeRoute(tradeRouteID7A, tradeRouteType2);	
}
else if (trPattern == 8)  // one 'circular' outside route
{
   int tradeRouteID8 = rmCreateTradeRoute();
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.0, 0.51); 
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.071, 0.6); 
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.105, 0.68); 
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.19, 0.81);  
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.325, 0.90);
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.5, 0.95); 
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.675, 0.90);
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.81, 0.81);  
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.895, 0.7);
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.937, 0.5); 
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.895, 0.3);
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.81, 0.19);   
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.675, 0.10);
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.5, 0.05);  
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.325, 0.10);
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.19, 0.19);  
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.105, 0.32); 
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.07, 0.4); 
   rmAddTradeRouteWaypoint(tradeRouteID8, 0.0, 0.49); 
   rmBuildTradeRoute(tradeRouteID8, tradeRouteType1);
}
else if (trPattern == 9)  // 2 'semi-circular' outside routes
{
   int tradeRouteID9 = rmCreateTradeRoute();
   if (axisChance == 2)
   { 
	if(makeRiver == 1)
         rmAddTradeRouteWaypoint(tradeRouteID9, 0.02, 0.575); 
	else 
         rmAddTradeRouteWaypoint(tradeRouteID9, 0.0, 0.525); 
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.07, 0.58); 
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.105, 0.68); 
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.19, 0.81);  
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.325, 0.90);
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.5, 0.93); 
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.675, 0.90);
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.81, 0.81); 
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.895, 0.7);
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.93, 0.58);
	if(makeRiver == 1)
         rmAddTradeRouteWaypoint(tradeRouteID9, 0.98, 0.575); 
	else 
         rmAddTradeRouteWaypoint(tradeRouteID9, 1.0, 0.525);
   }
   else
   {
	if(makeRiver == 1)
         rmAddTradeRouteWaypoint(tradeRouteID9, 0.575, 0.98); 
	else   
         rmAddTradeRouteWaypoint(tradeRouteID9, 0.525, 1.0); 
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.58, 0.93); 
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.68, 0.88);
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.81, 0.81);  
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.89, 0.695);
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.93, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.89, 0.305);
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.81, 0.19);
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.68, 0.12);
      rmAddTradeRouteWaypoint(tradeRouteID9, 0.58, 0.07);
	if(makeRiver == 1)
         rmAddTradeRouteWaypoint(tradeRouteID9, 0.575, 0.02); 
	else  
         rmAddTradeRouteWaypoint(tradeRouteID9, 0.525, 0.0); 
   }
   rmBuildTradeRoute(tradeRouteID9, tradeRouteType1);

   // second route
   int tradeRouteID9A = rmCreateTradeRoute();
   if (axisChance == 2)
   { 
	if(makeRiver == 1)
         rmAddTradeRouteWaypoint(tradeRouteID9A, 0.98, 0.425); 
	else 
         rmAddTradeRouteWaypoint(tradeRouteID9A, 1.0, 0.475);
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.935, 0.42);  
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.89, 0.31);
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.81, 0.19);   
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.675, 0.10);
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.5, 0.07);  
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.325, 0.10);
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.2, 0.2);  
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.11, 0.31); 
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.065, 0.42);
	if(makeRiver == 1)
         rmAddTradeRouteWaypoint(tradeRouteID9A, 0.02, 0.425); 
	else   
         rmAddTradeRouteWaypoint(tradeRouteID9A, 0.0, 0.475); 
   }
   else
   {
	if(makeRiver == 1)
         rmAddTradeRouteWaypoint(tradeRouteID9A, 0.425, 0.02); 
	else 
         rmAddTradeRouteWaypoint(tradeRouteID9A, 0.475, 0.0);
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.42, 0.065);   
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.31, 0.11);
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.2, 0.2);  
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.10, 0.325);  
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.07, 0.5); 
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.10, 0.675); 
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.19, 0.81);  
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.31, 0.89);
      rmAddTradeRouteWaypoint(tradeRouteID9A, 0.42, 0.935);
	if(makeRiver == 1)
         rmAddTradeRouteWaypoint(tradeRouteID9A, 0.425, 0.98); 
	else  
         rmAddTradeRouteWaypoint(tradeRouteID9A, 0.475, 1.0);  
   }
   rmBuildTradeRoute(tradeRouteID9A, tradeRouteType2);
}
else if (trPattern == 0)  // one 'circular' middle route
{
   int tradeRouteID0 = rmCreateTradeRoute();
   rmAddTradeRouteWaypoint(tradeRouteID0, 0.16, 0.508);
   rmAddTradeRouteWaypoint(tradeRouteID0, 0.24, 0.75);
   rmAddTradeRouteWaypoint(tradeRouteID0, 0.5, 0.84);
   rmAddTradeRouteWaypoint(tradeRouteID0, 0.76, 0.76);
   rmAddTradeRouteWaypoint(tradeRouteID0, 0.84, 0.5);
   rmAddTradeRouteWaypoint(tradeRouteID0, 0.76, 0.26);
   rmAddTradeRouteWaypoint(tradeRouteID0, 0.5, 0.16);
   rmAddTradeRouteWaypoint(tradeRouteID0, 0.24, 0.24);
   rmAddTradeRouteWaypoint(tradeRouteID0, 0.16, 0.492);
   rmBuildTradeRoute(tradeRouteID0, tradeRouteType1);
}
else if (trPattern == 1)  // 2 'semicircular' middle routes
{
   int tradeRouteID1 = rmCreateTradeRoute();
   int tradeRouteID1A = rmCreateTradeRoute();
   if (axisChance == 2)
   {
	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID1, 0.165, 0.59);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID1, 0.165, 0.56);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.25, 0.74);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.5, 0.835);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.75, 0.74);
	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID1, 0.835, 0.59);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID1, 0.835, 0.56);
      rmBuildTradeRoute(tradeRouteID1, tradeRouteType1);	

	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID1A, 0.835, 0.41);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID1A, 0.835, 0.44);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.75, 0.26);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.5, 0.165);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.25, 0.26);
	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID1A, 0.165, 0.41);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID1A, 0.165, 0.44);
      rmBuildTradeRoute(tradeRouteID1A, tradeRouteType2);
   }
   else if (axisChance == 1)
   {
	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID1, 0.59, 0.835);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID1, 0.55, 0.835);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.74, 0.75);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.835, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.74, 0.25);
	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID1, 0.59, 0.165);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID1, 0.55, 0.165);
      rmBuildTradeRoute(tradeRouteID1, tradeRouteType1);	

	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID1A, 0.41, 0.165);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID1A, 0.45, 0.165);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.26, 0.25);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.165, 0.5);
      rmAddTradeRouteWaypoint(tradeRouteID1A, 0.26, 0.75);
	if (makeRiver == 1)
	   rmAddTradeRouteWaypoint(tradeRouteID1A, 0.41, 0.835);
	else
	   rmAddTradeRouteWaypoint(tradeRouteID1A, 0.45, 0.835);
      rmBuildTradeRoute(tradeRouteID1A, tradeRouteType2);
   }
}
else if (trPattern == 10)  // new single with random waypoints
{
   int tradeRouteID10 = rmCreateTradeRoute();
   vector tradeRoutePoint = cOriginVector;
   if (axisChance == 1) 
   {
	tradeRoutePoint = rmFindClosestPoint(0.5, 0.0, 20.0);
	rmAddTradeRouteWaypoint(tradeRouteID10, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));
	rmAddRandomTradeRouteWaypoints(tradeRouteID10, 0.55, 0.4, 4, 6);
	rmAddRandomTradeRouteWaypoints(tradeRouteID10, 0.45, 0.6, 2, 3);
	tradeRoutePoint = rmFindClosestPoint(0.5, 1.0, 20.0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID10, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
   }
   else // axisChance == 2
   {
	tradeRoutePoint = rmFindClosestPoint(0.0, 0.5, 20.0);
	rmAddTradeRouteWaypoint(tradeRouteID10, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));
	rmAddRandomTradeRouteWaypoints(tradeRouteID10, 0.4, 0.45, 4, 6);
	rmAddRandomTradeRouteWaypoints(tradeRouteID10, 0.6, 0.55, 2, 3);
	tradeRoutePoint = rmFindClosestPoint(1.0, 0.5, 20.0);
	rmAddRandomTradeRouteWaypoints(tradeRouteID10, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
   } 
   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID10, tradeRouteType1);
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route");  
}
else if (trPattern == 11)  // two wider spaced 'diagonals'
{
   int tradeRouteID11 = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID11, 0.7, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID11, 0.67, 0.62);
      rmAddTradeRouteWaypoint(tradeRouteID11, 0.7, 0.55);
      rmAddTradeRouteWaypoint(tradeRouteID11, 0.7, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID11, 0.67, 0.38);
	rmAddTradeRouteWaypoint(tradeRouteID11, 0.7, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID11, 1.0, 0.7);
	rmAddTradeRouteWaypoint(tradeRouteID11, 0.62, 0.67);
      rmAddTradeRouteWaypoint(tradeRouteID11, 0.55, 0.7);
      rmAddTradeRouteWaypoint(tradeRouteID11, 0.45, 0.7);
	rmAddTradeRouteWaypoint(tradeRouteID11, 0.38, 0.67);
	rmAddTradeRouteWaypoint(tradeRouteID11, 0.0, 0.7);
   }
   rmBuildTradeRoute(tradeRouteID11, tradeRouteType1);

   int tradeRouteID11A = rmCreateTradeRoute();
   if (axisChance == 1) 
   {
      rmAddTradeRouteWaypoint(tradeRouteID11A, 0.3, 1.0);
	rmAddTradeRouteWaypoint(tradeRouteID11A, 0.33, 0.62);
      rmAddTradeRouteWaypoint(tradeRouteID11A, 0.3, 0.55);
      rmAddTradeRouteWaypoint(tradeRouteID11A, 0.3, 0.45);
	rmAddTradeRouteWaypoint(tradeRouteID11A, 0.33, 0.38);
      rmAddTradeRouteWaypoint(tradeRouteID11A, 0.3, 0.0);
   }
   else if (axisChance == 2) 
   {
	rmAddTradeRouteWaypoint(tradeRouteID11A, 1.0, 0.3);
	rmAddTradeRouteWaypoint(tradeRouteID11A, 0.62, 0.33);
      rmAddTradeRouteWaypoint(tradeRouteID11A, 0.55, 0.3);
      rmAddTradeRouteWaypoint(tradeRouteID11A, 0.45, 0.3);
	rmAddTradeRouteWaypoint(tradeRouteID11A, 0.38, 0.33);
	rmAddTradeRouteWaypoint(tradeRouteID11A, 0.0, 0.3);
   }
   rmBuildTradeRoute(tradeRouteID11A, tradeRouteType1);
}

// Trade sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 7.0);

if (trPattern == 2) // 2 opposite inner semicircular routes
{
   // add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID2);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
}
else if (trPattern == 3) // inner circle
{
   if (socketPattern == 1)
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID3);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.09);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.25);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.41);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.59);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.75);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.91);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else if (socketPattern == 2)
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID3);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.15);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.35);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.65);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID3, 0.85);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if (trPattern == 4) //  2 diagonal
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4);

   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.17);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4, 0.83);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID4A);
   if (socketPattern == 1)
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.83);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID4A, 0.17);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if (trPattern == 5) //  2 parabolas
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID5);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID5A);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5A, 0.83);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID5A, 0.17);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
}
else if (trPattern == 6)   // one diagonal
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID6);
   if (socketPattern == 1)
   {
	if (twoChoice == 1) // 6 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.09);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.25);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.41);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.59);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.75);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.91);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else  // 4 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.36);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.64);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
   else if (socketPattern == 2)
   {
	if (twoChoice == 1) // 5 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.31);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.69);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else // 3 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.2);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID6, 0.8);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
}
else if (trPattern == 7) // 2 intersecting parabolas
{
   // add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID7);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7, 0.21);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7, 0.79);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID7A);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7A, 0.79);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if (socketPattern == 1)
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID7A, 0.21);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
}
else if (trPattern == 8) // outer ring
{ 
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID8);
   if (socketPattern == 1) // 6 or 10 sockets
   {
      if (cNumberNonGaiaPlayers < 6)  // 6 sockets    
      {
 	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.05);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.172);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.338);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.51);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.672);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.838);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
      }
      else // over 5 players, 10 sockets 
      {
	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.05);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.15);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.25);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.35);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.45);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.55);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.65);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.75);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.85);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.95);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
      }	
   }
   else if (socketPattern == 2) // 8 sockets or 12 sockets    
   {
      if (cNumberNonGaiaPlayers < 6)  // 8 sockets 
      { 
	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.063);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.188);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.313);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.438);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.563);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.688);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.813);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.938);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else // over 5 players, 12 sockets
	{
	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.025);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.11);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.191);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.272);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.353);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.434);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.525);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.606);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.687);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.768);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.849);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID8, 0.930);
	    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
      }
   }
}
else if (trPattern == 9) //  2 outer semicircles
{
   if (socketPattern == 1) // 6 sockets
   { 
      if (variantChance == 1)
	{
          rmSetObjectDefTradeRouteID(socketID, tradeRouteID9);
          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.1);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.43);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.76);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

          // change the trade route for the new sockets
          rmSetObjectDefTradeRouteID(socketID, tradeRouteID9A);
          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.1);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.43);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.76);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	 }
	 else
	 {
          rmSetObjectDefTradeRouteID(socketID, tradeRouteID9);
          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.23);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.5);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.77);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

          // change the trade route for the new sockets
          rmSetObjectDefTradeRouteID(socketID, tradeRouteID9A);
          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.23);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.5);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

          socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.77);
          rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	 }
   }
   else if (socketPattern == 2) // 8 sockets
   { 
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID9);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.37);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.62);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9, 0.87);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      // change the trade route for the new sockets
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID9A);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.37);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.62);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID9A, 0.87);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if(trPattern == 0) // middle ring
{
   if (socketPattern == 1) // 6 sockets
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID0);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.01);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.172);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.338);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.51);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.672);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.835);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else if (socketPattern == 2) // 8 sockets
   {
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID0);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.063);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.188);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.313);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.438);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.563);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.688);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.813);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID0, 0.938);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if (trPattern == 1) //  2 middle semicircles
{
   if (socketPattern == 1) // 3 each
   { 
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.1);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.43);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.77);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      // change the trade route for the new sockets
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1A);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.1);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.43);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.77);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   if (socketPattern == 2) // 4 each
   { 
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.07);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.32);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.57);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.82);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      // change the trade route for the new sockets
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID1A);
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.07);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.32);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.57);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1A, 0.82);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}
else if (trPattern == 10)    // one diagonal
{
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID10);
   if (socketPattern == 1)
   {
	if (twoChoice == 1) // 6 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.09);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.25);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.41);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.59);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.75);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.91);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else  // 4 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.36);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.64);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
   else if (socketPattern == 2)
   {
	if (twoChoice == 1) // 5 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.12);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.31);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.69);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.88);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else // 3 TPs
	{
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.16);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID10, 0.84);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
   }
}
else if (trPattern == 11) // 2 new random diagonals
{
   // add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID11);
   if (socketPattern == 1)
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11, 0.21);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11, 0.79);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11, 0.15);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11, 0.35);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11, 0.65);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11, 0.85);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }

   // change the trade route for the new sockets
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID11A);
   if (socketPattern == 1)
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11A, 0.21);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11A, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11A, 0.79);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   else
   { 
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11A, 0.15);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11A, 0.35);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11A, 0.65);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID11A, 0.85);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
}

   //Text
   rmSetStatusText("",0.35);

// Starting TCs and units 		
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 6.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);

   int startingTCID= rmCreateObjectDef("startingTC");
   if ( rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }
   rmSetObjectDefMaxDistance(startingTCID, 18.0);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
   rmAddObjectDefConstraint(startingTCID, longAvoidImpassableLand );

   int playerCrateFID=rmCreateObjectDef("bonus starting food crates");
   rmAddObjectDefItem(playerCrateFID, "crateOfFood", rmRandInt(1,3), 6.0);
   rmSetObjectDefMinDistance(playerCrateFID, 10);
   rmSetObjectDefMaxDistance(playerCrateFID, 12);
   rmAddObjectDefConstraint(playerCrateFID, avoidAll);
   rmAddObjectDefConstraint(playerCrateFID, avoidImpassableLand);

   int playerCrateWID=rmCreateObjectDef("bonus starting wood crates");
   rmAddObjectDefItem(playerCrateWID, "crateOfWood", rmRandInt(1,3), 6.0);
   rmSetObjectDefMinDistance(playerCrateWID, 10);
   rmSetObjectDefMaxDistance(playerCrateWID, 12);
   rmAddObjectDefConstraint(playerCrateWID, avoidAll);
   rmAddObjectDefConstraint(playerCrateWID, avoidImpassableLand);

   int playerCrateCID=rmCreateObjectDef("bonus starting coin crates");
   rmAddObjectDefItem(playerCrateCID, "crateOfCoin", rmRandInt(1,3), 6.0);
   rmSetObjectDefMinDistance(playerCrateCID, 10);
   rmSetObjectDefMaxDistance(playerCrateCID, 12);
   rmAddObjectDefConstraint(playerCrateCID, avoidAll);
   rmAddObjectDefConstraint(playerCrateCID, avoidImpassableLand);

   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerGoldID=rmCreateObjectDef("player silver closer");
   rmAddObjectDefItem(playerGoldID, mineType, 1, 0.0);
   if (startingOutpost == 1) 
      rmAddObjectDefItem(playerGoldID, "ypOutpostAsian", 1, 6.0);
   rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerGoldID, avoidSocket);
   rmAddObjectDefConstraint(playerGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(playerGoldID, circleConstraint);
   rmAddObjectDefConstraint(playerGoldID, avoidAll);
   rmAddObjectDefConstraint(playerGoldID, avoidWater20);
   rmSetObjectDefMinDistance(playerGoldID, 18.0);
   rmSetObjectDefMaxDistance(playerGoldID, 23.0);
            
   for(i=1; <cNumberPlayers)
   {	
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
      if(ypIsAsian(i) && rmGetNomadStart() == false)
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	if (bonusCrates == 1)
      {
	   if (rmRandInt(1,3) > 1)
            rmPlaceObjectDefAtLoc(playerCrateFID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	   if (rmRandInt(1,3) > 1)
            rmPlaceObjectDefAtLoc(playerCrateWID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	   if (rmRandInt(1,3) > 1)
            rmPlaceObjectDefAtLoc(playerCrateCID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	}
      rmPlaceObjectDefAtLoc(playerGoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      if (startingOutpost > 1) 
      {
         if (mineNumber == 0)
            rmPlaceObjectDefAtLoc(playerGoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      }
   }

// Central features & patches, per map or variant
   // Center area
   int centerArea=rmCreateArea("TheCenter");
   rmSetAreaSize(centerArea, 0.1, 0.2);
   rmSetAreaLocation(centerArea, 0.5, 0.5);
   rmAddAreaToClass(centerArea, rmClassID("center")); 

   // Texas desert
   if (patternChance == 12)
   {
      if (lightingChance == 2)
 	{
         int desertID = rmCreateArea("desert");
         rmSetAreaLocation(desertID, 0.5, 0.5); 
         rmSetAreaWarnFailure(desertID, false);
         rmSetAreaSize(desertID, 0.7, 0.95);
         rmSetAreaCoherence(desertID, rmRandFloat(0.2, 0.5));
         rmSetAreaTerrainType(desertID, "texas\ground4_tex");
         rmAddAreaTerrainLayer(desertID, "texas\ground1_tex", 0, 4);
         rmAddAreaTerrainLayer(desertID, "texas\ground2_tex", 4, 8);
         rmAddAreaTerrainLayer(desertID, "texas\ground3_tex", 8, 12);
         rmSetAreaMix(desertID, "texas_dirt");
         rmBuildArea(desertID);
	}
   }

   // Center Highland or Canyon
   int makeCentralCliffArea = -1;
   if (makeCentralHighlands == 1)
	makeCentralCliffArea = 1;
   if (makeCentralCanyon == 1)
 	makeCentralCliffArea = 1;
   if ((patternChance == 8) || (patternChance == 24 && makeCentralHighlands == 1)) 
	extendCenter = 0;
   if (makeCentralCliffArea == 1)
   {
      int edgeChance = rmRandInt(1,4);
	if (extendCenter > 0)
	   edgeChance = rmRandInt(2,4);
      reducedForest = 1;
      int centerHighlandsID=rmCreateArea("center highlands");
      rmSetAreaLocation(centerHighlandsID, 0.5, 0.5);
	if ((trPattern == 2) || (trPattern == 3))
	{
	   if (cNumberNonGaiaPlayers > 3)   
            rmSetAreaSize(centerHighlandsID, 0.028, 0.035);
	   else
            rmSetAreaSize(centerHighlandsID, 0.04, 0.048);
	}
	else
	{
	   if (extendCenter == 0)
	   {
	      if (cNumberNonGaiaPlayers > 3)   
               rmSetAreaSize(centerHighlandsID, 0.035, 0.045);
	      else
               rmSetAreaSize(centerHighlandsID, 0.045, 0.05);
	   }
         else if (extendCenter == 1)
	   {
            rmSetAreaSize(centerHighlandsID, 0.055, 0.075);
	      if (axisChance == 1)
		   rmAddAreaInfluenceSegment(centerHighlandsID, 0.5, 0.27, 0.5, 0.73); 
	      else if (axisChance == 2)
		   rmAddAreaInfluenceSegment(centerHighlandsID, 0.27, 0.5, 0.73, 0.5); 
		endPosition = rmRandInt(2,3);
	   }
	   else if (extendCenter == 2)
	   {
            rmSetAreaSize(centerHighlandsID, 0.065, 0.08);
	      if (axisChance == 1)
		   rmAddAreaInfluenceSegment(centerHighlandsID, 0.5, 0.2, 0.5, 0.8); 
	      else if (axisChance == 2)
		   rmAddAreaInfluenceSegment(centerHighlandsID, 0.2, 0.5, 0.8, 0.5); 
	   }
	}
	if (clearCenter == 1)
	{
	   if (rmRandInt(0,1) == 1)
            rmAddAreaToClass(centerHighlandsID, rmClassID("center"));
	}	
      rmAddAreaToClass(centerHighlandsID, rmClassID("classCliff"));
      if (patternChance == 12)
         rmSetAreaMix(centerHighlandsID, "texas_dirt");
      else if (patternChance == 8)
	   rmSetAreaTerrainType(centerHighlandsID, "rockies\groundsnow1_roc");
	else if (patternChance == 24 && makeCentralHighlands == 1)
	   rmSetAreaTerrainType(centerHighlandsID, "rockies\groundsnow1_roc");
	else 
         rmSetAreaMix(centerHighlandsID, baseType);
      rmSetAreaCliffType(centerHighlandsID, cliffType);
      rmSetAreaCliffPainting(centerHighlandsID, false, true, true, 1.5, true);
	if (edgeChance == 1)
         rmSetAreaCliffEdge(centerHighlandsID, 2, 0.45, 0.1, 0.5, 0);
	else if (edgeChance == 2)
         rmSetAreaCliffEdge(centerHighlandsID, 3, 0.29, 0.1, 0.5, 0);
	else if (edgeChance == 3)
         rmSetAreaCliffEdge(centerHighlandsID, 4, 0.21, 0.1, 0.5, 0);
	else if (edgeChance == 4)
         rmSetAreaCliffEdge(centerHighlandsID, 5, 0.15, 0.08, 0.5, 0);
	if (makeCentralHighlands == 1)
	   rmSetAreaCliffHeight(centerHighlandsID, rmRandInt(6,8), 1.0, 0.5);
	else if (makeCentralCanyon == 1)
	   rmSetAreaCliffHeight(centerHighlandsID, -8, 1.0, 0.5);
      rmSetAreaSmoothDistance(centerHighlandsID, rmRandInt(10,20));
      rmSetAreaCoherence(centerHighlandsID, rmRandFloat(0.4,0.8));
	rmSetAreaHeightBlend(centerHighlandsID, 1.0);
      rmAddAreaConstraint(centerHighlandsID, avoidTradeRoute);
      rmAddAreaConstraint(centerHighlandsID, avoidSocket);
      rmAddAreaConstraint(centerHighlandsID, playerConstraint);
      rmBuildArea(centerHighlandsID);
      makeLake = 0;
   }

   // Center mountains
   int numMt = -1;
   if (mtPattern == 1)
 	numMt = 1;
   else if (mtPattern == 2)
 	numMt = 2;	   
   else
 	numMt = rmRandInt(3,6);
   if (centerMt == 1)
   {
      reducedForest = 1;
	for (i=0; <numMt)   
      { 
         int mtPatchID = rmCreateArea("mt patch"+i); 
         rmAddAreaToClass(mtPatchID, rmClassID("classHill"));
         rmAddAreaToClass(mtPatchID, rmClassID("classPatch"));
	   if (clearCenter == 1)
	   {
	      if (rmRandInt(0,1) == 1)
	         rmAddAreaToClass(mtPatchID, rmClassID("center"));
	   }
 	   if (patternChance == 8) // Rockies
	   {
            rmSetAreaTerrainType(mtPatchID, "rockies\groundsnow1_roc");
            rmAddAreaTerrainLayer(mtPatchID, "rockies\groundsnow8_roc", 0, 3);
            rmAddAreaTerrainLayer(mtPatchID, "rockies\groundsnow7_roc", 3, 5);
            rmAddAreaTerrainLayer(mtPatchID, "rockies\groundsnow6_roc", 5, 7);
	   }
	   if (patternChance == 20)  // Yukon Tundra
	   {
            rmSetAreaTerrainType(mtPatchID, "yukon\ground1_yuk");
            rmAddAreaTerrainLayer(mtPatchID, "yukon\ground5_yuk", 0, 2);
            rmAddAreaTerrainLayer(mtPatchID, "yukon\ground4_yuk", 2, 4);
            rmAddAreaTerrainLayer(mtPatchID, "yukon\ground8_yuk", 4, 6);
	   }
	   if ((patternChance == 18) || (patternChance == 24))   // Patagonia or Araucania South   
	   {
            rmSetAreaTerrainType(mtPatchID, "rockies\groundsnow1_roc");
            if (fourChoice == 3)
		   rmAddAreaTerrainLayer(mtPatchID, "patagonia\ground_snow2_pat", 0, 3);
	   }
 	   if (patternChance == 7) // Yukon
	   {
            rmSetAreaTerrainType(mtPatchID, "rockies\groundsnow1_roc");
	   }
         rmSetAreaWarnFailure(mtPatchID, false);
 	   if (mtPattern == 1)
	   {
            rmSetAreaSize(mtPatchID, 0.035, 0.045);
            rmSetAreaLocation(mtPatchID, 0.5, 0.5);
		if (variantChance == 1)
		{
               rmSetAreaMinBlobs(mtPatchID, 6);
               rmSetAreaMaxBlobs(mtPatchID, 14);
               rmSetAreaMinBlobDistance(mtPatchID, 30.0);
               rmSetAreaMaxBlobDistance(mtPatchID, 45.0);
		}
	   }
 	   else if (mtPattern == 2)
	   {
            rmSetAreaSize(mtPatchID, 0.018, 0.023);
		if (variantChance == 1)
		{
               rmSetAreaMinBlobs(mtPatchID, 6);
               rmSetAreaMaxBlobs(mtPatchID, 12);
               rmSetAreaMinBlobDistance(mtPatchID, 26.0);
               rmSetAreaMaxBlobDistance(mtPatchID, 40.0);
		}
	   }
	   else if (mtPattern == 3)
	   {
            rmSetAreaMinBlobs(mtPatchID, 4);
            rmSetAreaMaxBlobs(mtPatchID, 6);
            rmSetAreaMinBlobDistance(mtPatchID, 15.0);
            rmSetAreaMaxBlobDistance(mtPatchID, 20.0);
            rmSetAreaSize(mtPatchID, rmAreaTilesToFraction(500), rmAreaTilesToFraction(1050));
	   }
	   else if (mtPattern == 4)
	   {
            rmSetAreaMinBlobs(mtPatchID, 1);
            rmSetAreaMaxBlobs(mtPatchID, 3);
            rmSetAreaMinBlobDistance(mtPatchID, 30.0);
            rmSetAreaMaxBlobDistance(mtPatchID, 40.0);
            rmSetAreaSize(mtPatchID, rmAreaTilesToFraction(600), rmAreaTilesToFraction(1100));
	   }
         rmSetAreaElevationType(mtPatchID, cElevTurbulence);
	   rmSetAreaElevationVariation(mtPatchID, rmRandInt(2, 3));
	   rmSetAreaCoherence(mtPatchID, rmRandFloat(0.4, 0.8));
	   rmSetAreaBaseHeight(mtPatchID, rmRandInt(8, 10));
	   rmSetAreaElevationPersistence(mtPatchID, rmRandFloat(0.5, 0.8));
	   if (rmRandInt(1,3) == 3)
            rmSetAreaSmoothDistance(mtPatchID, rmRandInt(8, 20));
         rmAddAreaConstraint(mtPatchID, avoidTradeRoute);
         rmAddAreaConstraint(mtPatchID, avoidSocket);
         rmAddAreaConstraint(mtPatchID, longHillConstraint);
         rmAddAreaConstraint(mtPatchID, circleConstraintMt);
         rmAddAreaConstraint(mtPatchID, farPlayerConstraint);
         rmBuildArea(mtPatchID);
      }
   }
  
   if (forestMt == 1) // green hill forest
   {
      int htBlend = rmRandFloat(1.8,3.0);
      reducedForest = 1;
	for (i=0; <numMt)   
      { 	
         int hillPatchID = rmCreateArea("green hill"+i); 
         rmAddAreaToClass(hillPatchID, rmClassID("classHill"));
         rmAddAreaToClass(hillPatchID, rmClassID("classPatch"));
         rmSetAreaWarnFailure(hillPatchID, false);
         rmSetAreaForestType(hillPatchID, forestType);
         rmSetAreaForestDensity(hillPatchID, rmRandFloat(0.3, 0.5));
         rmSetAreaForestClumpiness(hillPatchID, rmRandFloat(0.5, 0.8));
         rmSetAreaForestUnderbrush(hillPatchID, rmRandFloat(0.0, 0.3));
 	   if (mtPattern == 1)
	   {
            rmSetAreaSize(hillPatchID, 0.035, 0.045);
            rmSetAreaLocation(hillPatchID, 0.5, 0.5);
		if (variantChance == 1)
		{
               rmSetAreaMinBlobs(hillPatchID, 6);
               rmSetAreaMaxBlobs(hillPatchID, 12);
               rmSetAreaMinBlobDistance(hillPatchID, 32.0);
               rmSetAreaMaxBlobDistance(hillPatchID, 45.0);
		}
	   }
 	   else if (mtPattern == 2)
	   {
            rmSetAreaSize(hillPatchID, 0.018, 0.023);
		if (variantChance == 1)
		{
               rmSetAreaMinBlobs(hillPatchID, 6);
               rmSetAreaMaxBlobs(hillPatchID, 14);
               rmSetAreaMinBlobDistance(hillPatchID, 26.0);
               rmSetAreaMaxBlobDistance(hillPatchID, 40.0);
		}
	   }
	   else if (mtPattern == 3)
	   {
            rmSetAreaMinBlobs(hillPatchID, 4);
            rmSetAreaMaxBlobs(hillPatchID, 6);
            rmSetAreaMinBlobDistance(hillPatchID, 15.0);
            rmSetAreaMaxBlobDistance(hillPatchID, 20.0);
            rmSetAreaSize(hillPatchID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(950));
	   }
	   else if (mtPattern == 4)
	   {
            rmSetAreaMinBlobs(hillPatchID, 1);
            rmSetAreaMaxBlobs(hillPatchID, 3);
            rmSetAreaMinBlobDistance(hillPatchID, 30.0);
            rmSetAreaMaxBlobDistance(hillPatchID, 40.0);
            rmSetAreaSize(hillPatchID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(950));
	   }
         rmSetAreaElevationType(hillPatchID, cElevTurbulence);
         rmSetAreaElevationVariation(hillPatchID, rmRandInt(2, 3));
	   rmSetAreaElevationPersistence(hillPatchID, rmRandFloat(0.5, 0.8));
         rmSetAreaCoherence(hillPatchID, rmRandFloat(0.4, 0.8));
         rmSetAreaBaseHeight(hillPatchID, rmRandInt(7, 9));
         rmSetAreaHeightBlend(hillPatchID, htBlend);
	   if (rmRandInt(1,3) == 3)
            rmSetAreaSmoothDistance(hillPatchID, rmRandInt(10, 20));
         rmAddAreaConstraint(hillPatchID, avoidTradeRoute);
         rmAddAreaConstraint(hillPatchID, avoidSocket);
         rmAddAreaConstraint(hillPatchID, longHillConstraint);
         rmAddAreaConstraint(hillPatchID, circleConstraintMt);
         rmAddAreaConstraint(hillPatchID, farPlayerConstraint);
         rmBuildArea(hillPatchID);
	}  
   }

   // Snow patch for Rockies, central highlands
   if (patternChance == 8)  // Rockies
   {
	if (makeCentralCliffArea == 1)
	{
         int snowPatch2ID = rmCreateArea("snow patch 2"); 
         rmAddAreaToClass(snowPatch2ID, rmClassID("classHill"));
         rmAddAreaToClass(snowPatch2ID, rmClassID("classPatch"));
         rmSetAreaLocation(snowPatch2ID, 0.5, 0.5); 
         rmSetAreaWarnFailure(snowPatch2ID, false);
         rmSetAreaSize(snowPatch2ID, 0.048, 0.049);
         rmSetAreaElevationType(snowPatch2ID, cElevTurbulence);
	   rmSetAreaElevationVariation(snowPatch2ID, rmRandInt(2, 3));
	   rmSetAreaCoherence(snowPatch2ID, rmRandFloat(0.4, 0.8));
	   if (rmRandInt(1,3) == 3)
            rmSetAreaSmoothDistance(snowPatch2ID, rmRandInt(8, 20));
         rmSetAreaTerrainType(snowPatch2ID, "rockies\groundsnow1_roc");
         rmAddAreaTerrainLayer(snowPatch2ID, "rockies\groundsnow8_roc", 0, 5);
         rmAddAreaTerrainLayer(snowPatch2ID, "rockies\groundsnow7_roc", 5, 9);
         rmAddAreaTerrainLayer(snowPatch2ID, "rockies\groundsnow6_roc", 9, 13);
         rmAddAreaConstraint(snowPatch2ID, avoidTradeRoute);
         rmAddAreaConstraint(snowPatch2ID, avoidSocket);
         rmBuildArea(snowPatch2ID); 
	}
   }

   // Ice - Great Lakes Winter, Yukon, Yukon Tundra or Araucania South
   if (makeIce == 1)
   {
      nativeNumber = 2;
      int icePatchID = rmCreateArea("ice patch"); 
      rmAddAreaToClass(icePatchID, rmClassID("classIce"));
      rmAddAreaToClass(icePatchID, rmClassID("center"));
	if (variantChance == 2)
	   rmAddAreaToClass(icePatchID, rmClassID("classHill"));
      rmSetAreaLocation(icePatchID, 0.5, 0.5); 
      rmSetAreaWarnFailure(icePatchID, false);
      rmSetAreaSize(icePatchID, 0.035, 0.05);
      rmSetAreaCoherence(icePatchID, rmRandFloat(0.6,0.9));
      rmSetAreaMix(icePatchID, "great_lakes_ice");
      rmSetAreaBaseHeight(icePatchID, 1.0);
      rmSetAreaElevationVariation(icePatchID, 0.0);
      rmAddAreaConstraint(icePatchID, avoidTradeRoute);
      rmAddAreaConstraint(icePatchID, avoidSocket);
      rmAddAreaConstraint(icePatchID, playerConstraint);
      rmBuildArea(icePatchID); 
	int iceHole = rmRandInt(1,2); 
	if (iceHole == 1)
	{
         int waterPatchID = rmCreateArea("water patch", rmAreaID("ice patch")); 
         rmAddAreaToClass(waterPatchID, rmClassID("classPatch"));
         rmSetAreaWarnFailure(waterPatchID, false);
         rmSetAreaSize(waterPatchID, 0.01, 0.025);
         rmSetAreaCoherence(waterPatchID, rmRandFloat(0.2,0.8));
         rmSetAreaWaterType(waterPatchID, "great lakes ice");
         rmSetAreaBaseHeight(waterPatchID, 1.0);
         rmBuildArea(waterPatchID); 
	}
   }

// KOTH game mode - no lake - to avoid need for water warfare ==========================================================
   if(rmGetIsKOTH())
   {
	makeLake = 0;
      int randLoc = rmRandInt(1,2);
      float xLoc = 0.5;
      float yLoc = 0.5;
      float walk = 0.05;
    
      ypKingsHillLandfill(xLoc, yLoc, .0075, 2.0, baseType, 0);
      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
   }

   // Center lake      
   if (makeLake == 1)
   {
	int lakePattern = rmRandInt(1,3);
	if (cNumberNonGaiaPlayers == 2)
	{ 
	   if ((sectionChance == 4) || (sectionChance == 5) || (sectionChance == 11) || (sectionChance == 12) || (sectionChance == 13))	
	      lakePos = 0; 
	}
      nativeNumber = 2;
	int smalllakeID=rmCreateArea("small lake");
      rmSetAreaWaterType(smalllakeID, pondType);
      rmAddAreaToClass(smalllakeID, lakeClass);
      rmSetAreaLocation(smalllakeID, 0.5, 0.5);
      rmSetAreaBaseHeight(smalllakeID, 0);
	if ((trPattern == 2) || (trPattern == 3)) 
	{
	   if (cNumberNonGaiaPlayers > 3)   
            rmSetAreaSize(smalllakeID, 0.028, 0.038);
	   else
            rmSetAreaSize(smalllakeID, 0.04, 0.048);
	}
	else
	{
	   if (extendCenter == 0)
	   {
	      if (cNumberNonGaiaPlayers > 3)   
               rmSetAreaSize(smalllakeID, 0.035, 0.045);
	      else
               rmSetAreaSize(smalllakeID, 0.045, 0.05);
	   }
	   else if (extendCenter == 1)
	   {
	      if (axisChance == 1)
		{
		   if (lakePos < 2)
		   {
			rmSetAreaSize(smalllakeID, 0.035, 0.065);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.5, 0.27, 0.5, 0.73);
		   }
		   else if (lakePos == 2)
		   {
			rmSetAreaSize(smalllakeID, 0.03, 0.06);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.5, 0.42, 0.5, 0.73); 
		   }
		   else if (lakePos == 3)
		   {
			rmSetAreaSize(smalllakeID, 0.03, 0.06);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.5, 0.27, 0.5, 0.58);
		   }
		} 
	      else if (axisChance == 2)
		{
		   if (lakePos < 2)
		   {
			rmSetAreaSize(smalllakeID, 0.035, 0.065);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.27, 0.5, 0.73, 0.5);
		   }
		   else if (lakePos == 2)
		   {
			rmSetAreaSize(smalllakeID, 0.03, 0.06);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.42, 0.5, 0.73, 0.5);
		   }
		   else if (lakePos == 3)
		   {
			rmSetAreaSize(smalllakeID, 0.03, 0.06);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.27, 0.5, 0.58, 0.5);
		   }
		}     
		endPosition = 3;
	   }
	   else if (extendCenter == 2)
	   {
	      if (axisChance == 1)
		{
		   if (lakePos < 2)
		   {
			rmSetAreaSize(smalllakeID, 0.035, 0.07);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.5, 0.2, 0.5, 0.8); 
		   }
		   else if (lakePos == 2)
		   {
			rmSetAreaSize(smalllakeID, 0.035, 0.065);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.5, 0.42, 0.5, 0.8);  
		   }
		   else if (lakePos == 3)
		   {
			rmSetAreaSize(smalllakeID, 0.035, 0.065);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.5, 0.2, 0.5, 0.58); 
		   }
		} 
	      else if (axisChance == 2)
		{
		   if (lakePos < 2)
		   {
			rmSetAreaSize(smalllakeID, 0.035, 0.07);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.2, 0.5, 0.8, 0.5);
		   }
		   else if (lakePos == 2)
		   {
			rmSetAreaSize(smalllakeID, 0.035, 0.065);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.2, 0.5, 0.58, 0.5);
		   }
		   else if (lakePos == 3)
		   {
			rmSetAreaSize(smalllakeID, 0.035, 0.065);
		      rmAddAreaInfluenceSegment(smalllakeID, 0.42, 0.5, 0.8, 0.5);
		   }
		}     
		endPosition = 3;
	   }
	}
	if (lakePattern == 1)
	{
         rmSetAreaMinBlobs(smalllakeID, 1);
         rmSetAreaMaxBlobs(smalllakeID, 3);
         rmSetAreaMinBlobDistance(smalllakeID, 12.0);
         rmSetAreaMaxBlobDistance(smalllakeID, 18.0);
         rmSetAreaCoherence(smalllakeID, rmRandFloat(0.4,0.8));
	}
	else if (lakePattern == 2)
	{
         rmSetAreaMinBlobs(smalllakeID, 3);
         rmSetAreaMaxBlobs(smalllakeID, 8);
         rmSetAreaMinBlobDistance(smalllakeID, 25.0);
         rmSetAreaMaxBlobDistance(smalllakeID, 40.0);
         rmSetAreaCoherence(smalllakeID, rmRandFloat(0.2,0.5));
	}
	else if (lakePattern == 3)
	{
         rmSetAreaMinBlobs(smalllakeID, 6);
         rmSetAreaMaxBlobs(smalllakeID, 12);
         rmSetAreaMinBlobDistance(smalllakeID, 32.0);
         rmSetAreaMaxBlobDistance(smalllakeID, 50.0);
         rmSetAreaCoherence(smalllakeID, rmRandFloat(0.2,0.3));
	}
      rmSetAreaSmoothDistance(smalllakeID, rmRandInt(10,20));
      rmAddAreaConstraint(smalllakeID, farPlayerConstraint);
      rmAddAreaConstraint(smalllakeID, avoidTradeRoute);
      rmAddAreaConstraint(smalllakeID, avoidSocket);
      rmSetAreaWarnFailure(smalllakeID, false);
      rmBuildArea(smalllakeID);
   }
 
   // Text
   rmSetStatusText("",0.40);

// NATIVES
   // Village A 
   int villageAID = -1;
   int whichNative = rmRandInt(1,2);
   int villageType = rmRandInt(1,5);
   if (whichNative == 1)
	   villageAID = rmCreateGrouping("village A", native1Name+villageType);
   else if (whichNative == 2)
	   villageAID = rmCreateGrouping("village A", native2Name+villageType);
   rmAddGroupingToClass(villageAID, rmClassID("natives"));
   rmAddGroupingToClass(villageAID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.12));
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRoute);
   rmAddGroupingConstraint(villageAID, avoidWater15);
   rmAddGroupingConstraint(villageAID, avoidNativesMed);
   rmAddGroupingConstraint(villageAID, playerConstraint);
   rmAddGroupingConstraint(villageAID, avoidIce);

   // Village D - opposite type from A 
   int villageDID = -1;
   villageType = rmRandInt(1,5);
   if (whichNative == 2)
	   villageDID = rmCreateGrouping("village D", native1Name+villageType);
   else if (whichNative == 1)
	   villageDID = rmCreateGrouping("village D", native2Name+villageType);
   rmAddGroupingToClass(villageDID, rmClassID("natives"));
   rmAddGroupingToClass(villageDID, rmClassID("importantItem"));
   rmSetGroupingMinDistance(villageDID, 0.0);
   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.12));
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRoute);
   rmAddGroupingConstraint(villageDID, avoidWater15);
   rmAddGroupingConstraint(villageDID, avoidNativesMed);
   rmAddGroupingConstraint(villageDID, playerConstraint);
   rmAddGroupingConstraint(villageDID, avoidIce);
   if (mtPattern > 2)
      rmAddGroupingConstraint(villageDID, shortHillConstraint);

   // Village B - randomly same or opposite village A
   int villageBID = -1;	
   villageType = rmRandInt(1,5);
   whichNative = rmRandInt(1,2);
   if (whichNative == 1)
	   villageBID = rmCreateGrouping("village B", native1Name+villageType);
   else if (whichNative == 2)
	   villageBID = rmCreateGrouping("village B", native2Name+villageType);
   rmAddGroupingToClass(villageBID, rmClassID("importantItem"));
   rmAddGroupingToClass(villageBID, rmClassID("natives"));
   rmSetGroupingMinDistance(villageBID, 0.0);
   rmSetGroupingMaxDistance(villageBID, rmXFractionToMeters(0.12));
   rmAddGroupingConstraint(villageBID, avoidImpassableLand);
   rmAddGroupingConstraint(villageBID, avoidTradeRoute);
   rmAddGroupingConstraint(villageBID, avoidWater15);
   rmAddGroupingConstraint(villageBID, avoidNatives);
   rmAddGroupingConstraint(villageBID, playerConstraint);

   // Village C // appears in center, variable, randomly same or opposite A and B
   int villageCID = -1;	
   villageType = rmRandInt(1,5);
   whichNative = rmRandInt(1,2);
   if (whichNative == 1)
	   villageCID = rmCreateGrouping("village C", native1Name+villageType);
   else if (whichNative == 2)
	   villageCID = rmCreateGrouping("village C", native2Name+villageType);
   rmAddGroupingToClass(villageCID, rmClassID("importantItem"));
   rmAddGroupingToClass(villageCID, rmClassID("natives"));
   rmSetGroupingMinDistance(villageCID, 0.0);
   rmSetGroupingMaxDistance(villageCID, rmXFractionToMeters(0.09));
   rmAddGroupingConstraint(villageCID, avoidImpassableLand);
   rmAddGroupingConstraint(villageCID, avoidWater15);
   rmAddGroupingConstraint(villageCID, avoidTradeRoute);
   rmAddGroupingConstraint(villageCID, avoidNatives);
   rmAddGroupingConstraint(villageCID, playerConstraint);
   if (mtPattern > 2)
      rmAddGroupingConstraint(villageCID, shortHillConstraint);

   // Placement of Native Americans
   if(makeRiver == 1)
   {
	if (cNumberNonGaiaPlayers > 3)
	{
	   if(rmRandInt(1,4) == 1)
		nativeSetup = 6;
	   else
		nativeSetup = 16;
	   if ((trPattern == 11) || (trPattern == 4) || (trPattern == 5) || (trPattern == 2))   
		nativeSetup = 6;
	}	   
	else
	{
	   if(rmRandInt(1,3) > 1)
		nativeSetup = 16;
	   else
	   {
		if (threeChoice == 1)
		   nativeSetup = 6;
		else if (threeChoice == 2)
		   nativeSetup = 10;
		else
		   nativeSetup = 11;
	   }
	   if ((trPattern == 11) || (trPattern == 4) || (trPattern == 5) || (trPattern == 2))   
	   {
		if (threeChoice == 1)
		   nativeSetup = 6;
		else if (threeChoice == 2)
		   nativeSetup = 10;
		else
		   nativeSetup = 11;
	   }
	}   
   }

   if (makeLake == 1)
   {
	if (extendCenter > 0)
	   nativeSetup = rmRandInt(6,22);
   }

   if ((nativeSetup == 16) || (nativeSetup == 17) || (nativeSetup == 18))        
   {
      if (axisChance == 2)
	{
  	      if (variantChance == 1)
	      {  
               rmPlaceGroupingAtLoc(villageAID, 0, 0.79, 0.36);
               rmPlaceGroupingAtLoc(villageBID, 0, 0.21, 0.36);
               rmPlaceGroupingAtLoc(villageBID, 0, 0.79, 0.64);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.21, 0.64);
		   if (nativeSetup == 17)
		   {	
			rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.4);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.6);
		   }
		   if (nativeSetup == 18)
		   {	
			rmPlaceGroupingAtLoc(villageDID, 0, 0.43, 0.4);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.57, 0.4);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.43, 0.6);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.57, 0.6);
		   }
  	      }
	      else
	      {
               rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.4);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.32, 0.4);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.68, 0.6);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.32, 0.6);
		   if (nativeSetup == 17)
		   {	
			rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.34);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.66);
		   }
		   if (nativeSetup == 18)
		   {	
			rmPlaceGroupingAtLoc(villageDID, 0, 0.43, 0.38);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.57, 0.38);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.43, 0.62);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.57, 0.62);
		   }
	      }
      }
	else if (axisChance == 1)
	{
	      if (variantChance == 1)
	      {  
               rmPlaceGroupingAtLoc(villageAID, 0, 0.41, 0.79);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.41, 0.21);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.59, 0.79);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.59, 0.21);
		   if (nativeSetup == 17)
		   {	
			rmPlaceGroupingAtLoc(villageDID, 0, 0.31, 0.5);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.69, 0.5);
		   }
		   if (nativeSetup == 18)
		   {	
			rmPlaceGroupingAtLoc(villageDID, 0, 0.38, 0.43);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.38, 0.57);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.62, 0.43);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.62, 0.43);
		   }
	      }
	      else
	      {
               rmPlaceGroupingAtLoc(villageAID, 0, 0.4, 0.7);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.4, 0.3);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.6, 0.7);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.6, 0.3);
		   if (nativeSetup == 17)
		   {	
			rmPlaceGroupingAtLoc(villageDID, 0, 0.4, 0.5);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.6, 0.5);
		   }
		   if (nativeSetup == 18)
		   {	
			rmPlaceGroupingAtLoc(villageDID, 0, 0.38, 0.43);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.38, 0.57);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.62, 0.43);
			rmPlaceGroupingAtLoc(villageDID, 0, 0.62, 0.43);
		   }
	      }	   
	}
   }
   else if (nativeSetup == 19)    
   {
      if (axisChance == 2)
	{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.74, 0.28);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.26, 0.28);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.74, 0.72);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.26, 0.72);
		   rmPlaceGroupingAtLoc(villageBID, 0, 0.5, 0.4);
		   rmPlaceGroupingAtLoc(villageBID, 0, 0.5, 0.6);
      }
	else if (axisChance == 1)
	{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.28, 0.74);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.28, 0.26);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.72, 0.74);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.72, 0.26);
		   rmPlaceGroupingAtLoc(villageBID, 0, 0.4, 0.5);
		   rmPlaceGroupingAtLoc(villageBID, 0, 0.6, 0.5);
	}
   } 
   else if (nativeSetup == 20)
   {
      if (axisChance == 2)
	{
  	      if (variantChance == 1)
	      {  
               rmPlaceGroupingAtLoc(villageAID, 0, 0.79, 0.38);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.21, 0.38);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.79, 0.62);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.21, 0.62);
	      }
	      else
	      {
               rmPlaceGroupingAtLoc(villageAID, 0, 0.67, 0.4);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.33, 0.4);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.67, 0.6);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.33, 0.6);
	      }
      }
	else if (axisChance == 1)
	{
	      if (variantChance == 1)
	      {  
               rmPlaceGroupingAtLoc(villageDID, 0, 0.4, 0.79);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.4, 0.21);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.6, 0.79);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.6, 0.21);
	      }
	      else
	      {
               rmPlaceGroupingAtLoc(villageDID, 0, 0.4, 0.7);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.4, 0.3);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.6, 0.7);
		   rmPlaceGroupingAtLoc(villageDID, 0, 0.6, 0.3);
	      }
	}
   } 
   else if (nativeSetup > 20) // 21 AND 22
   {
	if (nativeSetup == 22)
	{
	   if (nativeNumber > 2)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.515, 0.515);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.485, 0.485);
	   }
	   else
	   {
	      if (axisChance == 1)
	      {
               rmPlaceGroupingAtLoc(villageDID, 0, 0.4, 0.51);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.6, 0.49);
            }
   	      else
	      {
               rmPlaceGroupingAtLoc(villageDID, 0, 0.51, 0.6);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.49, 0.4);
	      }
	   }
	}
      if (axisChance == 2)
	{
  	      if (variantChance == 1)
	      {  
               rmPlaceGroupingAtLoc(villageAID, 0, 0.85, 0.135);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.15, 0.135);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.15, 0.865);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.85, 0.865);
	      }
	      else
	      {
               rmPlaceGroupingAtLoc(villageAID, 0, 0.85, 0.135);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.15, 0.135);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.15, 0.865);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.85, 0.865);
	      }
      }
	else if (axisChance == 1)
	{
	      if (variantChance == 1)
	      {  
               rmPlaceGroupingAtLoc(villageDID, 0, 0.135, 0.85);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.135, 0.15);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.865, 0.15);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.865, 0.85);
	      }
	      else
	      {
               rmPlaceGroupingAtLoc(villageAID, 0, 0.135, 0.85);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.135, 0.15);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.865, 0.15);
		   rmPlaceGroupingAtLoc(villageAID, 0, 0.865, 0.85);
	      }
	}
   }
   else if (nativeSetup < 4) 
   {
      if (axisChance == 1)
	{
	   if (endPosition == 1)
            rmPlaceGroupingAtLoc(villageAID, 0, 0.505, 0.73);
	   else if (endPosition == 2)
            rmPlaceGroupingAtLoc(villageAID, 0, 0.495, 0.82);
	   else
            rmPlaceGroupingAtLoc(villageAID, 0, 0.505, 0.91);
	}	 
      else
	{
	   if (endPosition == 1)
            rmPlaceGroupingAtLoc(villageAID, 0, 0.73, 0.505);
	   else if (endPosition == 2)
            rmPlaceGroupingAtLoc(villageAID, 0, 0.82, 0.495);
	   else
            rmPlaceGroupingAtLoc(villageAID, 0, 0.91, 0.505);
	}  
      if (axisChance == 1)
	{
	   if (endPosition == 1)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.495, 0.27);
	   else if (endPosition == 2)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.505, 0.18);
	   else
            rmPlaceGroupingAtLoc(villageBID, 0, 0.495, 0.09);
	}
      else
	{
	   if (endPosition == 1)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.27, 0.495);
	   else if (endPosition == 2)
            rmPlaceGroupingAtLoc(villageBID, 0, 0.18, 0.505);
	   else
            rmPlaceGroupingAtLoc(villageBID, 0, 0.09, 0.495);
	}         
	if (nativeSetup < 2)
	{
         if (nativeNumber > 2)
            rmPlaceGroupingAtLoc(villageCID, 0, 0.5, 0.5);
	}
	else 
	{
	   rmSetGroupingMaxDistance(villageCID, rmXFractionToMeters(0.085));
         if (nativeNumber > 2)
	   {
		if (axisChance == 1)
		{
               rmPlaceGroupingAtLoc(villageCID, 0, 0.485, 0.51);
               rmPlaceGroupingAtLoc(villageCID, 0, 0.515, 0.49);
	      }
		else
		{
               rmPlaceGroupingAtLoc(villageCID, 0, 0.51, 0.515);
               rmPlaceGroupingAtLoc(villageCID, 0, 0.49, 0.485);
	      }
	   }
	}
   }
   else if (nativeSetup > 5)
   {
	if (nativeSetup == 7)
	{
         if (axisChance == 1)
	   {
	      if (endPosition == 1)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.75); 
	      else if (endPosition == 2)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.84); 
	      else
               rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.93); 
	   }
         else
	   {
	      if (endPosition == 1)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.745, 0.495);
	      else if (endPosition == 2)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.84, 0.505);
	      else
              rmPlaceGroupingAtLoc(villageDID, 0, 0.93, 0.495);
	   }
         if (axisChance == 1)
	   {
	      if (endPosition == 1)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.25);
	      else if (endPosition == 2)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.16);
	      else
               rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.07);
	   }            
         else
	   {
	      if (endPosition == 1)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.25, 0.505);
	      else if (endPosition == 2)
               rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.495);
	      else
               rmPlaceGroupingAtLoc(villageDID, 0, 0.07, 0.505);
	   }            
	}
	if (nativeSetup == 8)
	{
	   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.065));
         if (nativeNumber > 2)
	   {
		if (axisChance == 1)
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.485, 0.49);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.515, 0.51);
	      }
		else
		{
               rmPlaceGroupingAtLoc(villageDID, 0, 0.49, 0.515);
               rmPlaceGroupingAtLoc(villageDID, 0, 0.51, 0.485);
	      }
	   }
	}
	if (nativeSetup == 9)
	{
	   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.07));
         if (nativeNumber > 2)
	   {
               rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.5);
	   }
	}
	if (nativeSetup < 12)
	{
         rmSetGroupingMinDistance(villageAID, 65.0);
         rmSetGroupingMaxDistance(villageAID, 85.0);  
	   rmAddGroupingConstraint(villageAID, nuggetPlayerConstraint); 
         rmSetGroupingMinDistance(villageDID, 65.0);
         rmSetGroupingMaxDistance(villageDID, 85.0);
	   rmAddGroupingConstraint(villageDID, nuggetPlayerConstraint); 
         for(i=1; <cNumberPlayers) 
         {       
   	      rmPlaceGroupingAtLoc(villageAID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	      if (nativeSetup == 10)
 	      {     
		   rmPlaceGroupingAtLoc(villageDID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	      }
	      if (nativeSetup == 11)
		   rmPlaceGroupingAtLoc(villageAID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	   }
	}
      if (nativeSetup > 11) // setup 12 to 15
      {
         rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.07));
         rmAddGroupingConstraint(villageAID, nuggetPlayerConstraint);
         if (axisChance == 1)
	   {
		if (distChance < 6)
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.33, 0.4);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.33, 0.6);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.67, 0.4);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.67, 0.6);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.13, 0.31);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.13, 0.69);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.87, 0.31);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.87, 0.69);
		}
	   }
	   else
	   {
		if (distChance < 6)
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.4, 0.33);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.6, 0.33);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.4, 0.67);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.6, 0.67);
		}
		else
		{
               rmPlaceGroupingAtLoc(villageAID, 0, 0.31, 0.13);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.69, 0.13);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.31, 0.87);
               rmPlaceGroupingAtLoc(villageAID, 0, 0.69, 0.87);
		}
	   }
	   if (nativeSetup == 13) 
	   {
	      rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.07));
            if (nativeNumber > 2)
	      {
		   if (rmRandInt(1,2) == 1)
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.5);
		   else
		   {
		      if (axisChance == 1)
		      {
               	   rmPlaceGroupingAtLoc(villageDID, 0, 0.485, 0.49);
               	   rmPlaceGroupingAtLoc(villageDID, 0, 0.515, 0.51);
	      	}
			else
			{
           		   rmPlaceGroupingAtLoc(villageDID, 0, 0.49, 0.515);
           	         rmPlaceGroupingAtLoc(villageDID, 0, 0.51, 0.485);
	      	}
	         }
		}
	   }
	   if (nativeSetup == 14) 
	   {
            if (axisChance == 1)
	      {
	         if (endPosition == 1)
		   {
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.75);
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.25);
		   } 
   	         else if (endPosition == 2)
		   {
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.84);
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.16);
		   } 
	         else
		   {
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.505, 0.07);
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.495, 0.93);
		   } 
	      }
            else
	      {
	         if (endPosition == 1)
		   {
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.745, 0.495);
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.25, 0.505);
		   }
	         else if (endPosition == 2)
		   {
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.84, 0.505);
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.495);
		   }
	         else
		   {
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.93, 0.495);
                  rmPlaceGroupingAtLoc(villageDID, 0, 0.07, 0.505);
		   }
	      }                
	   }
      }
   }
   else if (nativeSetup > 3) // setup 4 and 5
   {
      if (axisChance == 1)
	{
	   if (endPosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.75);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.25);
	   }
	   else if (endPosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.84);
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.16);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.93);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.5, 0.08);
	   }
	}          
      else
	{
	   if (endPosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.745, 0.5);
	      rmPlaceGroupingAtLoc(villageAID, 0, 0.25, 0.5);
	   }
	   else if (endPosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.84, 0.5);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.16, 0.5);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageAID, 0, 0.93, 0.5);
		rmPlaceGroupingAtLoc(villageAID, 0, 0.07, 0.5);
	   }
	}       
	if (nativeSetup == 4)
	{
	   if (axisChance == 1)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.485, 0.51);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.515, 0.49);
         }
   	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.51, 0.515);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.49, 0.485);
	   }
	}
   	rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.085));
      if (axisChance == 1)
	{
         if (sidePosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.74, 0.5);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.24, 0.5);
	   }
	   else if (sidePosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.84, 0.5);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.16, 0.5);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.93, 0.5);
            rmPlaceGroupingAtLoc(villageDID, 0, 0.08, 0.5);
	   }
      }
	else
	{
         if (sidePosition == 1)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.75);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.25);
	   }	   
	   else if (sidePosition == 2)
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.84);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.16);
	   }
	   else
	   {
            rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.93);
		rmPlaceGroupingAtLoc(villageDID, 0, 0.5, 0.08); 
         }
	}  
   }

   // Text
   rmSetStatusText("",0.50);

// Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(playerNuggetID, 34.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 47.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
   rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
   rmAddObjectDefConstraint(playerNuggetID, avoidWater10);
   for(i=1; <cNumberPlayers)
   {
 	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

// Small Ponds for Bayou      
   if (patternChance == 3)
   {
	for (i=0; <cNumberNonGaiaPlayers*3)   
      {
	   int smallPond2ID=rmCreateArea("bigger small pond"+i);
	   rmSetAreaSize(smallPond2ID, rmAreaTilesToFraction(340), rmAreaTilesToFraction(460));
         rmSetAreaWaterType(smallPond2ID, pondType);
         rmSetAreaBaseHeight(smallPond2ID, 0);
         rmSetAreaMinBlobs(smallPond2ID, 5);
         rmSetAreaMaxBlobs(smallPond2ID, 7);
         rmSetAreaMinBlobDistance(smallPond2ID, 24.0);
         rmSetAreaMaxBlobDistance(smallPond2ID, 36.0);
         rmAddAreaToClass(smallPond2ID, lakeClass);
         rmAddAreaConstraint(smallPond2ID, avoidLakes);
         rmAddAreaConstraint(smallPond2ID, playerConstraint);
         rmAddAreaConstraint(smallPond2ID, avoidTradeRoute);
         rmAddAreaConstraint(smallPond2ID, avoidSocket);
         rmAddAreaConstraint(smallPond2ID, avoidAll);
         rmAddAreaConstraint(smallPond2ID, avoidNativesShort);
         rmAddAreaConstraint(smallPond2ID, centerConstraintFar);
         rmSetAreaCoherence(smallPond2ID, 0.1);
         rmSetAreaWarnFailure(smallPond2ID, false);
         rmBuildArea(smallPond2ID);
      }
	for (i=0; <cNumberNonGaiaPlayers*6)   
      {
	   int smallPondID=rmCreateArea("small pond"+i);
	   rmSetAreaSize(smallPondID, rmAreaTilesToFraction(180), rmAreaTilesToFraction(240));
         rmSetAreaWaterType(smallPondID, pondType);
         rmSetAreaBaseHeight(smallPondID, 0);
         rmSetAreaMinBlobs(smallPondID, 2);
         rmSetAreaMaxBlobs(smallPondID, 4);
         rmSetAreaMinBlobDistance(smallPondID, 6.0);
         rmSetAreaMaxBlobDistance(smallPondID, 12.0);
         rmAddAreaToClass(smallPondID, lakeClass);
         rmAddAreaConstraint(smallPondID, avoidLakes);
         rmAddAreaConstraint(smallPondID, playerConstraint);
         rmAddAreaConstraint(smallPondID, avoidTradeRoute);
         rmAddAreaConstraint(smallPondID, avoidSocket);
         rmAddAreaConstraint(smallPondID, avoidAll);
         rmAddAreaConstraint(smallPondID, avoidNativesShort);
         rmAddAreaConstraint(smallPondID, centerConstraintFar);
         rmSetAreaCoherence(smallPondID, rmRandFloat(0.2,0.8));
         rmSetAreaWarnFailure(smallPondID, false);
         rmBuildArea(smallPondID);
      }
   }

// Cliffs
   int cliffHt = -1;
   int failCount=0;
   int numTries=cNumberNonGaiaPlayers*14;
   int anotherChance = -1;
   anotherChance = rmRandInt(0,1);
   if (makeCliffs == 2)
   {
     if (anotherChance == 1)
        makeCliffs = 1;
     else
        makeCliffs = 0;
   } 
   if (makeCentralCliffArea == 1)
   {
	numTries=cNumberNonGaiaPlayers*7;
	if ((patternChance == 9) || (patternChance == 10))
  	   cliffVariety = rmRandInt(3,7);
	else
  	   cliffVariety = rmRandInt(1,3);
   }
   if (makeCliffs == 1)
   { 
	if ((patternChance == 13) || (patternChance == 28))    // for Sonora or Painted Desert only      
	{
	   // bigger mesas
	   for(i=0; <numTries)
	   {
		int cliffHeight=rmRandInt(0,10);
		int mesaID=rmCreateArea("mesa"+i);
		rmSetAreaSize(mesaID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(160)); 
		rmSetAreaWarnFailure(mesaID, false);
		rmSetAreaCliffType(mesaID, cliffType);
		rmAddAreaToClass(mesaID, rmClassID("canyon"));
		rmAddAreaToClass(mesaID, rmClassID("classCliff"));	
		rmSetAreaCliffEdge(mesaID, 1, 1.0, 0.1, 1.0, 0);
		if (cliffHeight <= 7)
		  rmSetAreaCliffHeight(mesaID, rmRandInt(5,9), 1.0, 1.0);
		else
		  rmSetAreaCliffHeight(mesaID, -10, 1.0, 1.0);
		rmAddAreaConstraint(mesaID, avoidCanyons);
		rmSetAreaMinBlobs(mesaID, 3);
		rmSetAreaMaxBlobs(mesaID, 5);
		rmSetAreaMinBlobDistance(mesaID, 3.0);
		rmSetAreaMaxBlobDistance(mesaID, 5.0);
		rmSetAreaCoherence(mesaID, 0.5);
		rmAddAreaConstraint(mesaID, playerConstraint); 
		rmAddAreaConstraint(mesaID, avoidSocket);
		rmAddAreaConstraint(mesaID, avoidNativesShort);
		rmAddAreaConstraint(mesaID, avoidWater20);
		rmAddAreaConstraint(mesaID, avoidTradeRoute);
		rmAddAreaConstraint(mesaID, shortAvoidSilver);
		if(rmBuildArea(mesaID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==2)
				break;
		}
		else
			failCount=0;
	   }
	// smaller mesas
      if (makeCentralCliffArea == 1)
	   numTries=cNumberNonGaiaPlayers*10;
      else
	   numTries=cNumberNonGaiaPlayers*14;
	   for(i=0; <numTries)
	   {
		int smallCliffHeight=rmRandInt(0,10);
		int smallMesaID=rmCreateArea("small mesa"+i);
		rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(4), rmAreaTilesToFraction(8));  
		rmSetAreaWarnFailure(smallMesaID, false);
		rmSetAreaCliffType(smallMesaID, cliffType);
		rmAddAreaToClass(smallMesaID, rmClassID("canyon"));
		rmAddAreaToClass(smallMesaID, rmClassID("classCliff"));	
		rmSetAreaCliffEdge(smallMesaID, 1, 1.0, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(smallMesaID, rmRandInt(5,8), 1.0, 1.0);
		rmAddAreaConstraint(smallMesaID, shortAvoidCanyons);
		rmSetAreaMinBlobs(smallMesaID, 3);
		rmSetAreaMaxBlobs(smallMesaID, 5);
		rmSetAreaMinBlobDistance(smallMesaID, 3.0);
		rmSetAreaMaxBlobDistance(smallMesaID, 5.0);
		rmSetAreaCoherence(smallMesaID, 0.3);
		rmAddAreaConstraint(smallMesaID, mediumPlayerConstraint); 
		rmAddAreaConstraint(smallMesaID, avoidNativesShort); 
		rmAddAreaConstraint(smallMesaID, avoidSocket);
		rmAddAreaConstraint(smallMesaID, avoidWater10);
		rmAddAreaConstraint(smallMesaID, avoidTradeRoute);
		rmAddAreaConstraint(smallMesaID, shortAvoidSilver);
		if(rmBuildArea(smallMesaID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==20)
				break;
		}
		else
			failCount=0;
	   }
	}
	else if (cliffVariety == 0) // larger gorges a little like AOM Anatolia
	{
	   int gorgeHt=rmRandInt(-7,-4);
	   numTries = 2;
	   if (cNumberNonGaiaPlayers > 4)
	      numTries = 3;
	   for(i=0; <numTries)
	   {
	   int gorgeID=rmCreateArea("gorge"+i);
         rmSetAreaWarnFailure(gorgeID, false); 
	   rmSetAreaSize(gorgeID, rmAreaTilesToFraction(1500), rmAreaTilesToFraction(1800));
	   rmSetAreaCliffType(gorgeID, cliffType);
	   rmAddAreaToClass(gorgeID, rmClassID("classCliff"));
	   rmSetAreaMinBlobs(gorgeID, 4);
	   rmSetAreaMaxBlobs(gorgeID, 6);
	   if (rmRandInt(1,3) == 1)
	      rmSetAreaCliffEdge(gorgeID, 6, 0.10, 0.2, 1.0, 0);
	   else
	   {
		if (rmRandInt(1,2) == 1) 
	         rmSetAreaCliffEdge(gorgeID, 5, 0.15, 0.15, 1.0, 0);
		else
	         rmSetAreaCliffEdge(gorgeID, 4, 0.17, 0.15, 1.0, 0);
	   }		
	   rmSetAreaCliffPainting(gorgeID, false, true, true, 1.5);
	   rmSetAreaMinBlobDistance(gorgeID, 20.0);
	   rmSetAreaMaxBlobDistance(gorgeID, 20.0);
	   rmSetAreaCoherence(gorgeID, rmRandFloat(0.0,0.2));
	   rmSetAreaSmoothDistance(gorgeID, rmRandInt(10,20));
	   rmSetAreaCliffHeight(gorgeID, gorgeHt, 1.0, 1.0);
	   rmSetAreaHeightBlend(gorgeID, 2);
	   rmAddAreaConstraint(gorgeID, cliffsAvoidCliffs);
         rmAddAreaConstraint(gorgeID, avoidImportantItem);
	   rmAddAreaConstraint(gorgeID, avoidTradeRoute);
         rmAddAreaConstraint(gorgeID, avoidNatives);
	   rmAddAreaConstraint(gorgeID, avoidWater20);
	   rmAddAreaConstraint(gorgeID, avoidSocket);
	   rmAddAreaConstraint(gorgeID, avoidStartingUnits);
	   rmAddAreaConstraint(gorgeID, fartherPlayerConstraint);
	   rmAddAreaConstraint(gorgeID, secondEdgeConstraint);
	   rmAddAreaConstraint(gorgeID, longHillConstraint);
 	   rmBuildArea(gorgeID);
	   }
      }
      else // all other maps with cliffs
      {
         int numCliffs = rmRandInt(4,5);
	   if (cliffVariety == 2)
		if (makeCentralCliffArea == 1)
		   numCliffs = rmRandInt(3,4);
		else
		   numCliffs = rmRandInt(5,7);
	   else
 		if (makeCentralCliffArea == 1)
		   numCliffs = rmRandInt(3,4);
         for (i=0; <numCliffs)
         {
		cliffHt = rmRandInt(5,7);    
		int bigCliffID=rmCreateArea("big cliff" +i);
		rmSetAreaWarnFailure(bigCliffID, false);
		rmSetAreaCliffType(bigCliffID, cliffType);
		rmAddAreaToClass(bigCliffID, rmClassID("classCliff"));
		rmSetAreaMinBlobs(bigCliffID, 3);
		rmSetAreaMaxBlobs(bigCliffID, 5);
		rmSetAreaMinBlobDistance(bigCliffID, 5.0);
		rmSetAreaMaxBlobDistance(bigCliffID, 20.0);
		if (cliffVariety == 1) // like Patagonia
		{
   	         rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(550), rmAreaTilesToFraction(750));
      	   rmSetAreaCliffEdge(bigCliffID, 2, 0.35, 0.1, 1.0, 0);
		   if (bareCliffs == 1)
			rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
		   else
      	      rmSetAreaCliffPainting(bigCliffID, false, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, 7, 2.0, 0.5);
		   rmSetAreaCoherence(bigCliffID, 0.5);
		   rmSetAreaSmoothDistance(bigCliffID, 5);
		   rmSetAreaHeightBlend(bigCliffID, 1.0);
		}
		else if (cliffVariety == 2) // smaller, kinda like in Sudden Death from AOM
		{
   	         rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(280), rmAreaTilesToFraction(400));
		   rmSetAreaCliffEdge(bigCliffID, 1, 0.6, 0.1, 1.0, 0);
		   if (bareCliffs == 1)
			rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
		   else
      	      rmSetAreaCliffPainting(bigCliffID, false, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, cliffHt, 1.0, 1.0);
		   rmSetAreaCoherence(bigCliffID, rmRandFloat(0.4, 0.9));
		   rmSetAreaSmoothDistance(bigCliffID, 10);
		   rmSetAreaHeightBlend(bigCliffID, 2.0);
		}
		else if (cliffVariety == 6)  // odd long ridges
		{
   	         rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(300), rmAreaTilesToFraction(400));
		   if (rmRandInt(1,2) == 1)
 	            rmSetAreaCliffEdge(bigCliffID, 2, 0.36, 0.1, 1.0, 0);
		   else
 	            rmSetAreaCliffEdge(bigCliffID, 3, 0.26, 0.08, 1.0, 0);
		   rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, cliffHt, 2.0, 1.0);
		   rmSetAreaCoherence(bigCliffID, rmRandFloat(0.3, 0.5));
		   rmSetAreaSmoothDistance(bigCliffID, 5);
		   rmSetAreaHeightBlend(bigCliffID, 1.0);
	  	   rmSetAreaMinBlobs(bigCliffID, 2);
		   rmSetAreaMaxBlobs(bigCliffID, 2);
		   rmSetAreaMinBlobDistance(bigCliffID, 90.0);
		   rmSetAreaMaxBlobDistance(bigCliffID, 110.0);
	         bareCliffs = 1;
		}
		else if (cliffVariety == 7)  // smooth rock domes
		{
   	         rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(400));
		   rmSetAreaCliffEdge(bigCliffID, 1, 0.005, 0.01, 1.0, 0);
		   rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, rmRandInt(7,8), 2.0, 1.0);
		   rmSetAreaCoherence(bigCliffID, rmRandFloat(0.3, 0.5));
		   rmSetAreaSmoothDistance(bigCliffID, 20);
		   rmSetAreaHeightBlend(bigCliffID, 1.0);
	         bareCliffs = 1;
		}
		else  // kinda random, kinda like Texas or NE
		{
   	         rmSetAreaSize(bigCliffID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(700));
		   rmSetAreaCliffEdge(bigCliffID, 1, 0.6, 0.1, 1.0, 0);
		   if (bareCliffs == 1)
			rmSetAreaCliffPainting(bigCliffID, true, true, true, 1.5, true);
		   else
      	      rmSetAreaCliffPainting(bigCliffID, false, true, true, 1.5, true);
		   rmSetAreaCliffHeight(bigCliffID, cliffHt, 2.0, 1.0);
		   rmSetAreaCoherence(bigCliffID, rmRandFloat(0.4, 0.9));
		   rmSetAreaSmoothDistance(bigCliffID, rmRandInt(12,16));
		   rmSetAreaHeightBlend(bigCliffID, 1.0);
		}
		rmAddAreaConstraint(bigCliffID, avoidImportantItem);
		rmAddAreaConstraint(bigCliffID, avoidTradeRoute);
            rmAddAreaConstraint(bigCliffID, avoidNatives);
	      rmAddAreaConstraint(bigCliffID, avoidWater20);
	      rmAddAreaConstraint(bigCliffID, cliffsAvoidCliffs);
	      rmAddAreaConstraint(bigCliffID, avoidSocket);
	      rmAddAreaConstraint(bigCliffID, avoidStartingUnits);
	      rmAddAreaConstraint(bigCliffID, longPlayerConstraint);
	      rmAddAreaConstraint(bigCliffID, longHillConstraint);
		rmBuildArea(bigCliffID);
         }
      }
   }

// Random ponds
   if (makePonds == 1)
   {
	for (i=0; <cNumberNonGaiaPlayers*2)   
      {
	   int pondID=rmCreateArea("random pond"+i);
	   rmSetAreaSize(pondID, rmAreaTilesToFraction(300), rmAreaTilesToFraction(600));
         rmSetAreaWaterType(pondID, pondType);
         rmSetAreaBaseHeight(pondID, 0);
         rmSetAreaMinBlobs(pondID, 1);
         rmSetAreaMaxBlobs(pondID, 6);
         rmSetAreaMinBlobDistance(pondID, 12.0);
         rmSetAreaMaxBlobDistance(pondID, 35.0);
         rmAddAreaToClass(pondID, lakeClass);
         rmAddAreaConstraint(pondID, avoidLakesFar);
         rmAddAreaConstraint(pondID, longPlayerConstraint);
         rmAddAreaConstraint(pondID, circleConstraint);
         rmAddAreaConstraint(pondID, avoidTradeRoute);
         rmAddAreaConstraint(pondID, avoidSocket);
         rmAddAreaConstraint(pondID, avoidCliffs);
         rmAddAreaConstraint(pondID, avoidAll);
         rmAddAreaConstraint(pondID, avoidNativesShort);
         rmAddAreaConstraint(pondID, medHillConstraint);
         rmSetAreaCoherence(pondID, rmRandFloat(0.1,0.7));
         rmSetAreaWarnFailure(pondID, false);
         rmBuildArea(pondID);
      }
   }

   // Text
   rmSetStatusText("",0.60);

// Random Nuggets
   int nugget2= rmCreateObjectDef("nugget medium"); 
   rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(2, 2);
   rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget2, 60.0);
   rmSetObjectDefMaxDistance(nugget2, 100.0);
   rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget2, circleConstraint);
   rmAddObjectDefConstraint(nugget2, avoidSocket);
   rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget2, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget2, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget2, avoidWater10);
   rmAddObjectDefConstraint(nugget2, avoidAll);
   rmAddObjectDefConstraint(nugget2, avoidIce);
   rmPlaceObjectDefPerPlayer(nugget2, false, 1);

   int nugget3= rmCreateObjectDef("nugget hard"); 
   rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(3, 3);
   rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
   rmSetObjectDefMinDistance(nugget3, 80.0);
   rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget3, circleConstraint);
   rmAddObjectDefConstraint(nugget3, avoidSocket);
   rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget3, longPlayerConstraint);
   rmAddObjectDefConstraint(nugget3, avoidNuggetMed);
   rmAddObjectDefConstraint(nugget3, avoidWater10);
   rmAddObjectDefConstraint(nugget3, avoidAll);
   rmAddObjectDefConstraint(nugget3, avoidIce);
   rmPlaceObjectDefPerPlayer(nugget3, false, 1);

   int nugget4= rmCreateObjectDef("nugget nuts"); 
   rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(4, 4);
   rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
   rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget4, circleConstraint);
   rmAddObjectDefConstraint(nugget4, avoidSocket);
   rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget4, longPlayerConstraint);
   rmAddObjectDefConstraint(nugget4, avoidWater10);
   rmAddObjectDefConstraint(nugget4, avoidAll);
   rmAddObjectDefConstraint(nugget4, avoidIce);

   // Team nuggets - only works on certain Asian map types - and/or more level 4 nuggets    
   if (cNumberTeams == 2 && cNumberNonGaiaPlayers > 3 && rmRandInt(1,3) > 1 && ((patternChance == 29) || (patternChance == 30) || (patternChance == 33) || (patternChance == 35)))  
   {
      rmAddObjectDefConstraint(nugget4, avoidNuggetMed);
      rmSetObjectDefMinDistance(nugget4, 70.0);
      rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.3));
      rmSetNuggetDifficulty(12, 12);
      rmPlaceObjectDefPerPlayer(nugget4, false, 1);

      rmSetNuggetDifficulty(4, 4);
      rmSetObjectDefMinDistance(nugget4, 0.0);
      rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, 1);
      if (cNumberNonGaiaPlayers > 4)
         rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(1,2));
   }
   else  // only regular level 4 nuggets
   {
      rmSetObjectDefMinDistance(nugget4, 85.0);
      rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.4));
      rmAddObjectDefConstraint(nugget4, avoidNuggetLong);
      rmSetNuggetDifficulty(4, 4);
      rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
   }
   // more level 4 nuggets
   rmAddObjectDefConstraint(nugget4, avoidNuggetLong);
   if (rmRandInt(1,4) > 1)
   {
      rmSetObjectDefMinDistance(nugget4, 15.0);
      rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.15));
      rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, 1);
	if (cNumberNonGaiaPlayers > 3 && rmRandInt(1,2) == 1)
         rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, 1);
   }

   // more level 3 nuggets
   rmAddObjectDefConstraint(nugget3, fartherPlayerConstraint);
   rmSetNuggetDifficulty(2, 3);
   rmPlaceObjectDefPerPlayer(nugget3, false, 1);
   if (rmRandInt(1,5) == 1)
      rmPlaceObjectDefPerPlayer(nugget3, false, 1);

   // Text
   rmSetStatusText("",0.65);

// more resources
   // start area trees 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 8);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 12);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
   rmPlaceObjectDefPerPlayer(StartAreaTreeID, false, 3);

   // berry bushes
   int StartBerryBushID=rmCreateObjectDef("starting berry bush");
   rmAddObjectDefItem(StartBerryBushID, "BerryBush", rmRandInt(3,5), 4.0);
   rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
   rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartBerryBushID, avoidAll);
   if (placeBerries == 1)
      rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);
   if (tropicalMap == 1)
      rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);

   rmSetObjectDefMinDistance(StartBerryBushID, 0.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 75.0);
   rmAddObjectDefConstraint(StartBerryBushID, nuggetPlayerConstraint);
   if (extraBerries == 1)
      rmPlaceObjectDefInArea(StartBerryBushID, 0, rmAreaID("TheCenter"), berryNum);
   if (extraBerries == 2)
   {
	if (rmRandInt(1,2) == 1)
         rmPlaceObjectDefInArea(StartBerryBushID, 0, rmAreaID("TheCenter"), 2);
   } 

   // start area huntable
   int deerNum = rmRandInt(5,8);
   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, deerNum, 5.0);
   rmAddObjectDefToClass(startPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(startPronghornID, 16);
   rmSetObjectDefMaxDistance(startPronghornID, 22);
   rmAddObjectDefConstraint(startPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, true);
   rmPlaceObjectDefPerPlayer(startPronghornID, false, 1);

   // second huntable
   int deer2Num = rmRandInt(4, 8);
   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deer2Type, deer2Num, 5.0);
   rmAddObjectDefToClass(farPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farPronghornID, 42.0);
   rmSetObjectDefMaxDistance(farPronghornID, 60.0);
   rmAddObjectDefConstraint(farPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(farPronghornID, mediumPlayerConstraint);
   rmAddObjectDefConstraint(farPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farPronghornID, avoidNativesShort);
   rmAddObjectDefConstraint(farPronghornID, huntableConstraint);
   rmAddObjectDefConstraint(farPronghornID, avoidAll);
   rmAddObjectDefConstraint(farPronghornID, avoidIce);
   rmSetObjectDefCreateHerd(farPronghornID, true);
   if (sheepChance == 0)
      rmPlaceObjectDefPerPlayer(farPronghornID, false, 2);
   else
      rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);

   // possible additional second huntable for low player numbers
   if (rmRandInt(1,3) < 3)
   { 
      if (cNumberNonGaiaPlayers < 4)
      {
         rmAddObjectDefConstraint(farPronghornID, fartherPlayerConstraint);
         rmSetObjectDefMinDistance(farPronghornID, rmXFractionToMeters(0.25));
         rmSetObjectDefMaxDistance(farPronghornID, rmXFractionToMeters(0.35));
         rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);
      }
   }

// Mines - other
   silverType = rmRandInt(1,10);
   int GoldMediumID=rmCreateObjectDef("player silver med");
   rmAddObjectDefItem(GoldMediumID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(GoldMediumID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldMediumID, avoidSocket);
   rmAddObjectDefConstraint(GoldMediumID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldMediumID, shortAvoidCanyons);
   rmAddObjectDefConstraint(GoldMediumID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldMediumID, playerConstraint);
   rmAddObjectDefConstraint(GoldMediumID, circleConstraint);
   rmAddObjectDefConstraint(GoldMediumID, avoidAll);
   rmAddObjectDefConstraint(GoldMediumID, avoidIce);
   rmAddObjectDefConstraint(GoldMediumID, avoidWater10);
   rmSetObjectDefMinDistance(GoldMediumID, 40.0);
   rmSetObjectDefMaxDistance(GoldMediumID, 55.0);
   rmPlaceObjectDefPerPlayer(GoldMediumID, false, 1);

// Extra mines - distant, in the middle and near ends of axis.
   silverType = rmRandInt(1,10);
   int extraGoldID = rmCreateObjectDef("extra silver "+i);
   if (mineChance == 1)
      rmAddObjectDefItem(extraGoldID, "minegold", 1, 0);
   else
      rmAddObjectDefItem(extraGoldID, mineType, 1, 0);
   rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraGoldID, avoidSocket);
   rmAddObjectDefConstraint(extraGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(extraGoldID, shortAvoidCanyons);
   rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraGoldID, avoidWater10);
   rmAddObjectDefConstraint(extraGoldID, avoidAll);
   rmAddObjectDefConstraint(extraGoldID, avoidIce);
   rmSetObjectDefMinDistance(extraGoldID, 0.0);
   if (makeIce == 1)
   {
      rmSetObjectDefMaxDistance(extraGoldID, 100.0);
      rmAddObjectDefConstraint(extraGoldID, centerConstraintFar);
   }
   else if (makeLake == 1)
   {
      rmSetObjectDefMaxDistance(extraGoldID, 100.0);
	rmAddObjectDefConstraint(extraGoldID, centerConstraintFar);
   }
   else
      rmSetObjectDefMaxDistance(extraGoldID, 70.0);
   if (mineNumber == 4)
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, 1);
   else   
      rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, rmRandInt(2,3));

   if ((mineNumber < 4) || (mineNumber > 4))
   { 
      if (cNumberNonGaiaPlayers > 4)
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, 1);
      if (cNumberNonGaiaPlayers > 6)
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.5, 0.5, 1);
   }
   if ((mineNumber < 5) || (mineNumber > 5))
   { 
      if (axisChance == 1)
      {
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.49, 0.78, 1);
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.51, 0.22, 1);
      }
      else
      {
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.78, 0.51, 1);
         rmPlaceObjectDefAtLoc(extraGoldID, 0, 0.22, 0.49, 1);
      }
   }
   silverType = rmRandInt(1,10);
   int GoldFarID=rmCreateObjectDef("player silver far");
   if (mineChance == 2)
      rmAddObjectDefItem(GoldFarID, "minegold", 1, 0);
   else
      rmAddObjectDefItem(GoldFarID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(GoldFarID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldFarID, avoidSocket);
   rmAddObjectDefConstraint(GoldFarID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldFarID, shortAvoidCanyons);
   rmAddObjectDefConstraint(GoldFarID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldFarID, circleConstraint);
   rmAddObjectDefConstraint(GoldFarID, avoidAll);
   rmAddObjectDefConstraint(GoldFarID, farPlayerConstraint);
   rmAddObjectDefConstraint(GoldFarID, avoidWater10);
   rmAddObjectDefConstraint(GoldFarID, avoidIce);
   rmSetObjectDefMinDistance(GoldFarID, 75.0);
   rmSetObjectDefMaxDistance(GoldFarID, 100.0);
   if (mineNumber < 6) 
   { 
      rmPlaceObjectDefPerPlayer(GoldFarID, false, rmRandInt(1,2));
   }

   silverType = rmRandInt(1,10);
   int GoldFartherID=rmCreateObjectDef("player silver farther");
   if (mineChance == 3)
      rmAddObjectDefItem(GoldFartherID, "minegold", 1, 0);
   else
      rmAddObjectDefItem(GoldFartherID, mineType, 1, 0.0);
   rmAddObjectDefConstraint(GoldFartherID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldFartherID, avoidSocket);
   rmAddObjectDefConstraint(GoldFartherID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldFartherID, shortAvoidCanyons);
   rmAddObjectDefConstraint(GoldFartherID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldFartherID, circleConstraint);
   rmAddObjectDefConstraint(GoldFartherID, avoidAll);
   rmAddObjectDefConstraint(GoldFartherID, avoidIce);
   rmAddObjectDefConstraint(GoldFartherID, avoidWater10);
   if (sectionChance > 9)
   {
      rmSetObjectDefMinDistance(GoldFartherID, 120.0);
      rmSetObjectDefMaxDistance(GoldFartherID, 200.0);
      rmAddObjectDefConstraint(GoldFartherID, enormousPlayerConstraint);
   }
   else
   {
      rmSetObjectDefMinDistance(GoldFartherID, 90.0);
      rmSetObjectDefMaxDistance(GoldFartherID, 150.0);
      rmAddObjectDefConstraint(GoldFartherID, fartherPlayerConstraint);
   }
   if (mineNumber < 7) 
   {
      if (cNumberNonGaiaPlayers < 4)
      {
	   rmPlaceObjectDefPerPlayer(GoldFartherID, false, rmRandInt(1,2));
      }
      else if (cNumberNonGaiaPlayers < 6)
      {
         if (makeLake == 1)
	      rmPlaceObjectDefPerPlayer(GoldFartherID, false, 2);
         else
	      rmPlaceObjectDefPerPlayer(GoldFartherID, false, rmRandInt(1,2));
      }
      else
      {
	   rmPlaceObjectDefPerPlayer(GoldFartherID, false, rmRandInt(1,4));
      }
   }
   if (mineNumber == 8)
   {
	if (cNumberNonGaiaPlayers < 4)
         rmPlaceObjectDefAtLoc(GoldFartherID, 0, 0.5, 0.5, 1);
	else if (cNumberNonGaiaPlayers == 4)
         rmPlaceObjectDefAtLoc(GoldFartherID, 0, 0.5, 0.5, 2);
	else
         rmPlaceObjectDefAtLoc(GoldFartherID, 0, 0.5, 0.5, rmRandInt(2,3));
   }

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, treeType, 5, 5.0);
   rmSetObjectDefMinDistance(extraTreesID, 14);
   rmSetObjectDefMaxDistance(extraTreesID, 18);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidNuggetSmall);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidSocket);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player"+i), 1);

   rmSetObjectDefMinDistance(extraTreesID, 19);
   rmSetObjectDefMaxDistance(extraTreesID, 30);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player"+i), 1);

   // Text
   rmSetStatusText("",0.70);

// sheep etc
   if (sheepChance > 0)
   {
      int sheepID=rmCreateObjectDef("herdable animal");
      rmAddObjectDefItem(sheepID, sheepType, 2, 4.0);
      rmAddObjectDefToClass(sheepID, rmClassID("herdableFood"));
      rmSetObjectDefMinDistance(sheepID, 38.0);
      rmSetObjectDefMaxDistance(sheepID, 50.0);
      rmAddObjectDefConstraint(sheepID, avoidSheep);
      rmAddObjectDefConstraint(sheepID, avoidAll);
      rmAddObjectDefConstraint(sheepID, avoidIce);
      rmAddObjectDefConstraint(sheepID, playerConstraint);
      rmAddObjectDefConstraint(sheepID, avoidCliffs);
      rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
	rmPlaceObjectDefPerPlayer(sheepID, false, 1);
      if (sheepChance == 2)
	   rmPlaceObjectDefPerPlayer(sheepID, false, 1);

      rmSetObjectDefMinDistance(sheepID, 47.0);
      rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.3));
	int extraFlocks = rmRandInt(cNumberNonGaiaPlayers,cNumberNonGaiaPlayers*2);
	sheepChance = rmRandInt(1,2);
      if (sheepChance == 1)
         rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
      else 
         rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2); 
      rmAddObjectDefConstraint(sheepID, farPlayerConstraint);
      rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.45));
      rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, extraFlocks); 
   }

// Central herds
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, centerHerdType, rmRandInt(7,9), 6.0);
   rmAddObjectDefToClass(centralHerdID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(centralHerdID, rmXFractionToMeters(0.05));
   rmSetObjectDefMaxDistance(centralHerdID, rmXFractionToMeters(0.12));
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, avoidWater10);
   rmAddObjectDefConstraint(centralHerdID, avoidIce);
   rmAddObjectDefConstraint(centralHerdID, farPlayerConstraint);
   rmAddObjectDefConstraint(centralHerdID, longHuntableConstraint);
   rmSetObjectDefCreateHerd(centralHerdID, true);
   rmPlaceObjectDefAtLoc(centralHerdID, 0, 0.5, 0.5, 2);
   // additional of central herd type
   rmAddObjectDefConstraint(centralHerdID, fartherPlayerConstraint);
   rmSetObjectDefMinDistance(centralHerdID, rmXFractionToMeters(0.3));
   rmSetObjectDefMaxDistance(centralHerdID, rmXFractionToMeters(0.38));
   if (rmRandInt(1,4) > 1)   
      rmPlaceObjectDefPerPlayer(centralHerdID, false, 1);

// far huntable
   int farHuntableID=rmCreateObjectDef("far huntable");
   rmAddObjectDefItem(farHuntableID, deerType, rmRandInt(5,9), 6.0);
   rmAddObjectDefToClass(farHuntableID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farHuntableID, rmXFractionToMeters(0.33));
   rmSetObjectDefMaxDistance(farHuntableID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(farHuntableID, avoidTradeRoute);
   rmAddObjectDefConstraint(farHuntableID, avoidImportantItem);
   rmAddObjectDefConstraint(farHuntableID, avoidWater10);
   rmAddObjectDefConstraint(farHuntableID, fartherPlayerConstraint);
   rmAddObjectDefConstraint(farHuntableID, longHuntableConstraint);
   rmAddObjectDefConstraint(farHuntableID, avoidAll);
   rmAddObjectDefConstraint(farHuntableID, avoidIce);
   rmSetObjectDefCreateHerd(farHuntableID, true);
   rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);
   if (sheepChance == 0)
   {
	if (rmRandInt(1,3) > 1)
         rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);
   }
   else
   {
	if (rmRandInt(1,3) == 1)
         rmPlaceObjectDefPerPlayer(farHuntableID, false, 1);
   }

// Central forests for highlands, canyons
   if (clearCenter < 1)
	makeCentralForestPatch = 1; 
   if (clearCenter == 1)
   {
	if (makeCentralCanyon == 1)
	   makeCentralForestPatch = 1; 
   }
   if (makeCentralCliffArea == 1) // forest for central highlands or canyons
   {
      if (makeCentralForestPatch == 1)
      {  
         numTries=cNumberNonGaiaPlayers;
         for (i=0; <numTries)
         { 
             int forestPatchID = rmCreateArea("forest patch"+i, rmAreaID("center highlands"));
             rmAddAreaToClass(forestPatchID, rmClassID("classForest"));
             rmSetAreaWarnFailure(forestPatchID, false);
             rmSetAreaSize(forestPatchID, rmAreaTilesToFraction(80), rmAreaTilesToFraction(150));
             rmSetAreaCoherence(forestPatchID, 0.6);
        	 if (patternChance == 8)
	          rmSetAreaForestType(forestPatchID, "rockies snow forest");
		 else 
      	    rmSetAreaForestType(forestPatchID, forestType);
             rmSetAreaForestDensity(forestPatchID, 0.6);
             rmSetAreaForestClumpiness(forestPatchID, 0.9);
             rmSetAreaForestUnderbrush(forestPatchID, 0.2);
             rmSetAreaCoherence(forestPatchID, 0.4);
             rmSetAreaSmoothDistance(forestPatchID, 10);
             rmAddAreaConstraint(forestPatchID, avoidAll);
             rmAddAreaConstraint(forestPatchID, avoidTradeRoute);
	       rmAddAreaConstraint(forestPatchID, avoidSocket);
	       rmAddAreaConstraint(forestPatchID, avoidNativesShort);
             rmBuildArea(forestPatchID);

		 if (forestCoverUp == 1)
		 {
      	 int smallForestPatchID = rmCreateArea("small forest patch"+i, rmAreaID("forest patch"+i));   
      	 rmSetAreaWarnFailure(smallForestPatchID, false);
	       rmSetAreaSize(smallForestPatchID, rmAreaTilesToFraction(160), rmAreaTilesToFraction(160));
	       rmSetAreaCoherence(smallForestPatchID, 0.99);
      	 rmSetAreaMix(smallForestPatchID, baseType);
	       rmBuildArea(smallForestPatchID);
		 }
	   }   
      }       
   }
   else if (patternChance == 8) // for 1 central mt on Rockies
   {
	if (numMt == 1)
	{
         numTries=3*cNumberNonGaiaPlayers;
    	   if (cNumberNonGaiaPlayers > 4)
	      numTries=2*cNumberNonGaiaPlayers;
         for (i=0; <numTries)
         { 
            int snowForestPatchID = rmCreateArea("snow forest patch"+i, rmAreaID("mt patch"+0));
            rmAddAreaToClass(snowForestPatchID, rmClassID("classForest"));
            rmSetAreaWarnFailure(snowForestPatchID, false);
            rmSetAreaSize(snowForestPatchID, rmAreaTilesToFraction(170), rmAreaTilesToFraction(220));
            rmSetAreaCoherence(snowForestPatchID, 0.6);
            rmSetAreaForestType(snowForestPatchID, "rockies snow forest");
            rmSetAreaForestDensity(snowForestPatchID, 1.0);
            rmSetAreaForestClumpiness(snowForestPatchID, 0.9);
            rmSetAreaForestUnderbrush(snowForestPatchID, 0.0);
            rmSetAreaCoherence(snowForestPatchID, 0.4);
            rmSetAreaSmoothDistance(snowForestPatchID, 10);
            rmAddAreaConstraint(snowForestPatchID, avoidAll);
            rmAddAreaConstraint(snowForestPatchID, avoidTradeRoute);
            rmAddAreaConstraint(snowForestPatchID, avoidSocket);
            rmAddAreaConstraint(snowForestPatchID, avoidNativesShort);
            rmBuildArea(snowForestPatchID);
         }
	}
   }

   // Text
   rmSetStatusText("",0.75);

   // Clearings
   if (clearCenter < 1)
   {
      for (i=0; <cNumberNonGaiaPlayers)   
      {
	   int forestClearing=rmCreateArea("forest clearing "+i);
	   rmSetAreaWarnFailure(forestClearing, false);
	   rmSetAreaSize(forestClearing, rmAreaTilesToFraction(225), rmAreaTilesToFraction(300));
	   rmSetAreaMix(forestClearing, baseType);
	   rmAddAreaToClass(forestClearing, rmClassID("classClearing"));
	   rmSetAreaMinBlobs(forestClearing, 1);
	   rmSetAreaMaxBlobs(forestClearing, 3);
	   rmSetAreaMinBlobDistance(forestClearing, 6.0);
	   rmSetAreaMaxBlobDistance(forestClearing, 16.0);
	   rmSetAreaCoherence(forestClearing, 0.5);
	   rmSetAreaSmoothDistance(forestClearing, 10);
	   rmAddAreaConstraint(forestClearing, shortAvoidImpassableLand);
	   rmAddAreaConstraint(forestClearing, avoidClearing);
	   rmAddAreaConstraint(forestClearing, farPlayerConstraint);
	   rmAddAreaConstraint(forestClearing, hillConstraint);
	   rmAddAreaConstraint(forestClearing, avoidCliffs);
	   rmBuildArea(forestClearing);
         int clearingTreesID=rmCreateObjectDef("clearing trees "+i);
         rmAddObjectDefItem(clearingTreesID, treeType, rmRandInt(3,5), 9.0);
	   rmPlaceObjectDefInArea(clearingTreesID, 0, rmAreaID("forest clearing "+i), rmRandInt(1,2));
      }
   }

// Main forests
   int forestChance = -1;
   numTries=15*cNumberNonGaiaPlayers;
   if (cNumberNonGaiaPlayers > 3)
      numTries=13*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 5)
      numTries=12*cNumberNonGaiaPlayers;  
   if (cNumberNonGaiaPlayers > 7)
      numTries=11*cNumberNonGaiaPlayers;  
   if (reducedForest == 1)
   {
      numTries=13*cNumberNonGaiaPlayers;
      if (cNumberNonGaiaPlayers > 3)
         numTries=11*cNumberNonGaiaPlayers;  
      if (cNumberNonGaiaPlayers > 5)
         numTries=10*cNumberNonGaiaPlayers;  
      if (cNumberNonGaiaPlayers > 7)
         numTries=9*cNumberNonGaiaPlayers;    
   }

   if (clearCenter == 1)
   {
      numTries=11*cNumberNonGaiaPlayers;
      if (cNumberNonGaiaPlayers > 3)
         numTries=10*cNumberNonGaiaPlayers;  
      if (cNumberNonGaiaPlayers > 5)
         numTries=9*cNumberNonGaiaPlayers;  
      if (cNumberNonGaiaPlayers > 7)
         numTries=8*cNumberNonGaiaPlayers;   
   }

   if ((patternChance == 1) || (patternChance == 2) || (patternChance == 3)|| (patternChance == 4) || (patternChance == 5)|| (patternChance == 8) || (patternChance == 14)|| (patternChance == 16) || (patternChance == 18) || (patternChance == 22) || (patternChance == 24)|| (patternChance == 25) || (patternChance == 27) ||(patternChance == 28) || (patternChance == 29) || (patternChance == 30) || (patternChance == 32)|| (patternChance == 34)|| (patternChance == 35) || (patternChance == 37))
   {
	if (rmRandInt(1,3) == 1)
	   denseForest = 1;
	if (rmRandInt(1,5) < 3)
	{
	   if (rmRandInt(1,3) > 1) 
	      forSize = 4;
	   else
	      forSize = 3;
	}
   }

   failCount=0;
   for (i=0; <numTries)
   {
      if (forSize == 1)
         forestSize = rmRandInt(120, 220);
      if (forSize == 2)
         forestSize = rmRandInt(150, 300);
      if (forSize == 3)
         forestSize = rmRandInt(200, 400);
      if (forSize == 4)
         forestSize = rmRandInt(250, 600);
      patchSize = forestSize + 50;
      forestChance = rmRandInt(1,4);
      int forest=rmCreateArea("forest "+i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(forestSize), rmAreaTilesToFraction(forestSize));
	if (dualForest == 1)
	{
	   if (rmRandInt(1,2) == 1)
		rmSetAreaForestType(forest, forestType);
	   else
		rmSetAreaForestType(forest, forest2Type);
	}
	else
         rmSetAreaForestType(forest, forestType);

      if (denseForest == 1)
	{
         rmSetAreaForestDensity(forest, 0.99);
         rmSetAreaForestClumpiness(forest, 0.99);
	}
	else
	{
         rmSetAreaForestDensity(forest, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forest, rmRandFloat(0.5, 0.9));
	}
      rmSetAreaForestUnderbrush(forest, rmRandFloat(0.0, 0.5));
      rmSetAreaCoherence(forest, rmRandFloat(0.4, 0.7));
      rmSetAreaSmoothDistance(forest, rmRandInt(10,20));
      if (forestChance == 3)
      {
	   rmSetAreaMinBlobs(forest, 1);
	   rmSetAreaMaxBlobs(forest, 3);					
	   rmSetAreaMinBlobDistance(forest, 12.0);
	   rmSetAreaMaxBlobDistance(forest, 24.0);
	}
      if (forestChance == 4)
      {
	   rmSetAreaMinBlobs(forest, 3);
	   rmSetAreaMaxBlobs(forest, 5);					
	   rmSetAreaMinBlobDistance(forest, 16.0);
	   rmSetAreaMaxBlobDistance(forest, 28.0);
	   rmSetAreaSmoothDistance(forest, 20);
	}
      rmAddAreaToClass(forest, rmClassID("classForest")); 
	rmAddAreaConstraint(forest, mediumPlayerConstraint);
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidAll); 
	rmAddAreaConstraint(forest, avoidCoin);  
      rmAddAreaConstraint(forest, avoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
	rmAddAreaConstraint(forest, avoidStartingUnits);
	rmAddAreaConstraint(forest, avoidSocket);
	rmAddAreaConstraint(forest, avoidNativesShort);
      rmAddAreaConstraint(forest, forestsAvoidBison); 
	rmAddAreaConstraint(forest, hillConstraint);
	rmAddAreaConstraint(forest, avoidClearing);
	if ((noCliffForest == 1) || (bareCliffs == 1))
	   rmAddAreaConstraint(forest, avoidCliffs);
      if (clearCenter == 1)
	{
	   if (cNumberNonGaiaPlayers > 3)
	   {
		if (rmRandInt(1,2) == 1) 
	         rmAddAreaConstraint(forest, centerConstraintForest);
		else
		   rmAddAreaConstraint(forest, centerConstraintForest2);
	   }
	   else
	   {
		if (rmRandInt(1,2) == 1) 
	         rmAddAreaConstraint(forest, centerConstraintForest3);
		else
		   rmAddAreaConstraint(forest, centerConstraintForest4);
	   }
	}
      else
	{
	   if (makeCentralCliffArea == 1)
   	      rmAddAreaConstraint(forest, centerConstraintShort);
	}
	if (hillTrees == 1)
	{
	   if (rmRandInt(1,2) == 1)
	   {
            rmSetAreaBaseHeight(forest, rmRandFloat(3.0,5.0));
	      rmSetAreaHeightBlend(forest, rmRandFloat(1.7,3.0));
	   }
	}
      if(rmBuildArea(forest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==5)
            break;
      }
      else
         failCount=0; 
	if (forestCoverUp == 1)
	{
         int coverForestPatchID = rmCreateArea("cover forest patch"+i, rmAreaID("forest "+i));   
         rmSetAreaWarnFailure(coverForestPatchID, false);
         rmSetAreaSize(coverForestPatchID, rmAreaTilesToFraction(patchSize), rmAreaTilesToFraction(patchSize));
         rmSetAreaCoherence(coverForestPatchID, 0.99);
         rmSetAreaMix(coverForestPatchID, baseType);
         if (bareCliffs == 1)
            rmAddAreaConstraint(coverForestPatchID, avoidCliffsShort);
         rmBuildArea(coverForestPatchID);
	}
   } 

   // Text
   rmSetStatusText("",0.80);

// Random trees
   int StragglerTreeID=rmCreateObjectDef("stragglers");
   rmAddObjectDefItem(StragglerTreeID, treeType, 1, 0.0);
   rmAddObjectDefConstraint(StragglerTreeID, avoidAll);
   rmAddObjectDefConstraint(StragglerTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StragglerTreeID, hillConstraint);
   rmAddObjectDefConstraint(StragglerTreeID, avoidCoin);
   rmAddObjectDefConstraint(StragglerTreeID, patchConstraint);
   rmAddObjectDefConstraint(StragglerTreeID, avoidWater10);
   if ((noCliffForest == 1) || (bareCliffs == 1))
      rmAddObjectDefConstraint(StragglerTreeID, avoidCliffs);
   rmSetObjectDefMinDistance(StragglerTreeID, 10.0);
   rmSetObjectDefMaxDistance(StragglerTreeID, rmXFractionToMeters(0.5));
   for(i=0; <cNumberNonGaiaPlayers*12)
      rmPlaceObjectDefAtLoc(StragglerTreeID, 0, 0.5, 0.5);   

// Fish
   int fishID=rmCreateObjectDef("fish");
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 26.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 7.0);
   rmAddObjectDefItem(fishID, fishType, 1, 0.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   if (cNumberNonGaiaPlayers < 4)
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, rmRandInt(3,5));
   else
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, rmRandInt(4,6));

   // Text
   rmSetStatusText("",0.90);

// Patch to cover forest floor in some patterns
if (coverUp == 1)
{
   int coverPatchID = rmCreateArea("cover patch"+i);
   rmSetAreaLocation(coverPatchID, 0.5, 0.5); 
   rmSetAreaWarnFailure(coverPatchID, false);
   rmSetAreaSize(coverPatchID, 0.99, 0.99);
   rmSetAreaCoherence(coverPatchID, 0.99);
   rmSetAreaMix(coverPatchID, baseType);
   if (bareCliffs == 1)
      rmAddAreaConstraint(coverPatchID, avoidCliffsShort);
   rmBuildArea(coverPatchID);

   int coverPatch2ID = rmCreateArea("cover patch 2"+1);
   rmSetAreaLocation(coverPatch2ID, 0.5, 0.5); 
   rmSetAreaWarnFailure(coverPatch2ID, false);
   rmSetAreaSize(coverPatch2ID, 0.99, 0.99);
   rmSetAreaCoherence(coverPatch2ID, 0.99);
   rmSetAreaMix(coverPatch2ID, baseType);
   if (bareCliffs == 1)
      rmAddAreaConstraint(coverPatch2ID, avoidCliffsShort);
   rmBuildArea(coverPatch2ID);
}

// Deco
   // Patches for Araucania, California, Andes, Patagonia
   if (specialPatch == 1)
   {
      for (i=0; <cNumberNonGaiaPlayers*8)   
      {
	   int colorPatch=rmCreateArea("color patch "+i);
	   rmSetAreaWarnFailure(colorPatch, false);
	   rmSetAreaSize(colorPatch, rmAreaTilesToFraction(250), rmAreaTilesToFraction(400));
         rmSetAreaMix(colorPatch, patchMixType);
	   rmAddAreaToClass(colorPatch, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(colorPatch, 1);
	   rmSetAreaMaxBlobs(colorPatch, 5);
	   rmSetAreaMinBlobDistance(colorPatch, 16.0);
	   rmSetAreaMaxBlobDistance(colorPatch, 36.0);
	   rmSetAreaCoherence(colorPatch, 0.1);
	   rmSetAreaSmoothDistance(colorPatch, 10);
	   rmAddAreaConstraint(colorPatch, shortAvoidImpassableLand);
	   rmAddAreaConstraint(colorPatch, patchConstraint);
	   rmAddAreaConstraint(colorPatch, avoidWater20);
	   rmAddAreaConstraint(colorPatch, shortForestConstraint);
	   rmBuildArea(colorPatch); 
      }

      for (i=0; <cNumberNonGaiaPlayers*12)   
      {
	   int colorPatch2=rmCreateArea("2nd color patch "+i);
	   rmSetAreaWarnFailure(colorPatch2, false);
	   rmSetAreaSize(colorPatch2, rmAreaTilesToFraction(60), rmAreaTilesToFraction(150));
         rmSetAreaMix(colorPatch2, patchMixType);
	   rmAddAreaToClass(colorPatch2, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(colorPatch2, 1);
	   rmSetAreaMaxBlobs(colorPatch2, 3);
	   rmSetAreaMinBlobDistance(colorPatch2, 10.0);
	   rmSetAreaMaxBlobDistance(colorPatch2, 20.0);
	   rmSetAreaCoherence(colorPatch2, 0.1);
	   rmSetAreaSmoothDistance(colorPatch2, 10);
	   rmAddAreaConstraint(colorPatch2, shortAvoidImpassableLand);
	   rmAddAreaConstraint(colorPatch2, patchConstraint);
	   rmAddAreaConstraint(colorPatch2, avoidWater20);
	   rmAddAreaConstraint(colorPatch2, shortForestConstraint);
	   rmBuildArea(colorPatch2); 
      }
   }

   // Text
   rmSetStatusText("",0.95);

   // Dirt patches for Carolina
   if (patternChance == 2 && variantChance == 2)
   {
	   for (i=0; <cNumberNonGaiaPlayers*9)   
         {
		int dirtPatchC=rmCreateArea("carolina dirt patch "+i);
		rmSetAreaWarnFailure(dirtPatchC, false);
		rmSetAreaSize(dirtPatchC, rmAreaTilesToFraction(190), rmAreaTilesToFraction(260));
		rmSetAreaTerrainType(dirtPatchC, "carolina\ground_grass4_car");
		rmAddAreaToClass(dirtPatchC, rmClassID("classPatch"));
		rmSetAreaMinBlobs(dirtPatchC, 3);
		rmSetAreaMaxBlobs(dirtPatchC, 5);
		rmSetAreaMinBlobDistance(dirtPatchC, 16.0);
		rmSetAreaMaxBlobDistance(dirtPatchC, 36.0);
		rmSetAreaCoherence(dirtPatchC, 0.0);
		rmSetAreaSmoothDistance(dirtPatchC, 10);
		rmAddAreaConstraint(dirtPatchC, shortAvoidImpassableLand);
		rmAddAreaConstraint(dirtPatchC, patchConstraint);
	      rmAddAreaConstraint(dirtPatchC, shortForestConstraint);
		rmBuildArea(dirtPatchC); 
	   }
   }

   // Dirt patches for Sonora
   if (patternChance == 13 && twoChoice == 1)
   {
	for (i=0; <cNumberNonGaiaPlayers*6)   
      {
	   int dirtPatch=rmCreateArea("open dirt patch "+i);
         rmSetAreaWarnFailure(dirtPatch, false);
	   rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(150), rmAreaTilesToFraction(230));
	   rmSetAreaTerrainType(dirtPatch, "sonora\ground7_son");
	   rmAddAreaToClass(dirtPatch, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(dirtPatch, 1);
	   rmSetAreaMaxBlobs(dirtPatch, 5);
	   rmSetAreaMinBlobDistance(dirtPatch, 16.0);
	   rmSetAreaMaxBlobDistance(dirtPatch, 40.0);
	   rmSetAreaCoherence(dirtPatch, 0.0);
	   rmSetAreaSmoothDistance(dirtPatch, 10);
	   rmAddAreaConstraint(dirtPatch, shortAvoidImpassableLand);
	   rmAddAreaConstraint(dirtPatch, patchConstraint);
	   rmBuildArea(dirtPatch); 
      }
   }

   // Snow patches for Yukon Tundra
   if (patternChance == 20)
   { 
      for(i=1; <cNumberPlayers*4)
      {
         int patchAID=rmCreateArea("PatchA"+i);
         rmSetAreaSize(patchAID, rmAreaTilesToFraction(185), rmAreaTilesToFraction(250));
         rmAddAreaToClass(patchAID, rmClassID("classPatch"));
         rmSetAreaTerrainType(patchAID, "yukon\ground1_yuk");
         rmAddAreaTerrainLayer(patchAID, "yukon\ground5_yuk", 0, 2);
         rmAddAreaTerrainLayer(patchAID, "yukon\ground4_yuk", 2, 3);
         rmAddAreaTerrainLayer(patchAID, "yukon\ground8_yuk", 3, 4);
         rmSetAreaWarnFailure(patchAID, false);
         rmSetAreaMinBlobs(patchAID, 2);
         rmSetAreaMaxBlobs(patchAID, 3);
         rmSetAreaMinBlobDistance(patchAID, 12.0);
         rmSetAreaMaxBlobDistance(patchAID, 22.0);
         rmSetAreaCoherence(patchAID, 0.3);
         rmAddAreaConstraint(patchAID, playerConstraint);
         rmAddAreaConstraint(patchAID, shortAvoidImpassableLand);
         rmAddAreaConstraint(patchAID, patchConstraint);
         rmSetAreaWarnFailure(patchAID, false);
         rmBuildArea(patchAID);
      }
   }

   // Patches for Great Plains 1
   if (patternChance == 9)
   {
      for (i=0; <cNumberNonGaiaPlayers*13)   
      {
	   int gpPatch2=rmCreateArea("GP patch 2"+i);
	   rmSetAreaWarnFailure(gpPatch2, false);
	   rmSetAreaSize(gpPatch2, rmAreaTilesToFraction(50), rmAreaTilesToFraction(90));
	   if (rmRandInt(1,2) == 1)
	      rmSetAreaTerrainType(gpPatch2, "great_lakes\ground_grass4_gl");
	   else
	      rmSetAreaTerrainType(gpPatch2, "great_lakes\ground_grass5_gl");
	   rmAddAreaToClass(gpPatch2, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatch2, 2);
	   rmSetAreaMaxBlobs(gpPatch2, 4);
	   rmSetAreaMinBlobDistance(gpPatch2, 5.0);
	   rmSetAreaMaxBlobDistance(gpPatch2, 12.0);
	   rmSetAreaCoherence(gpPatch2, 0.3);
	   rmSetAreaSmoothDistance(gpPatch2, 10);
	   rmAddAreaConstraint(gpPatch2, shortAvoidImpassableLand);
	   if (bareCliffs == 1)
	      rmAddAreaConstraint(gpPatch2, avoidCliffsShort);
	   rmAddAreaConstraint(gpPatch2, patchConstraint);
	   rmBuildArea(gpPatch2); 
      }
   
      for (i=0; <cNumberNonGaiaPlayers*9)   
      {
	   int gpPatch0=rmCreateArea("GP patch 0"+i);
	   rmSetAreaWarnFailure(gpPatch0, false);
	   rmSetAreaSize(gpPatch0, rmAreaTilesToFraction(60), rmAreaTilesToFraction(90));
	   if (rmRandInt(1,2) > 1)
	      rmSetAreaTerrainType(gpPatch0, "great_plains\ground6_gp");
	   else
	      rmSetAreaTerrainType(gpPatch0, "great_plains\ground8_gp");
	   rmAddAreaToClass(gpPatch0, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatch0, 2);
	   rmSetAreaMaxBlobs(gpPatch0, 4);
	   rmSetAreaMinBlobDistance(gpPatch0, 5.0);
	   rmSetAreaMaxBlobDistance(gpPatch0, 12.0);
	   rmSetAreaCoherence(gpPatch0, 0.3);
	   rmSetAreaSmoothDistance(gpPatch0, 10);
	   rmAddAreaConstraint(gpPatch0, shortAvoidImpassableLand);
	   if (bareCliffs == 1)
	      rmAddAreaConstraint(gpPatch0, avoidCliffsShort);
	   rmAddAreaConstraint(gpPatch0, forestConstraint);
	   rmAddAreaConstraint(gpPatch0, patchConstraint);
	   rmBuildArea(gpPatch0); 
      }

      for (i=0; <cNumberNonGaiaPlayers*9)   
      {
	   int gpPatch1=rmCreateArea("GP patch 1"+i);
	   rmSetAreaWarnFailure(gpPatch1, false);
	   rmSetAreaSize(gpPatch1, rmAreaTilesToFraction(50), rmAreaTilesToFraction(80));
	   if (rmRandInt(1,2) == 1)
	      rmSetAreaTerrainType(gpPatch1, "great_plains\ground5_gp");
	   else
	      rmSetAreaTerrainType(gpPatch1, "great_plains\ground1_gp");
	   rmAddAreaToClass(gpPatch1, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatch1, 2);
	   rmSetAreaMaxBlobs(gpPatch1, 4);
	   rmSetAreaMinBlobDistance(gpPatch1, 12.0);
	   rmSetAreaMaxBlobDistance(gpPatch1, 18.0);
	   rmSetAreaCoherence(gpPatch1, 0.1);
	   rmSetAreaSmoothDistance(gpPatch1, 10);
	   rmAddAreaConstraint(gpPatch1, shortAvoidImpassableLand);
	   if (bareCliffs == 1)
	      rmAddAreaConstraint(gpPatch1, avoidCliffsShort);
	   rmAddAreaConstraint(gpPatch1, patchConstraint);
	   rmBuildArea(gpPatch1); 
      }

      for (i=0; <cNumberNonGaiaPlayers*12)   
      {
	   int gpPatch3=rmCreateArea("GP patch 3"+i);
	   rmSetAreaWarnFailure(gpPatch3, false);
	   rmSetAreaSize(gpPatch3, rmAreaTilesToFraction(50), rmAreaTilesToFraction(90));
	   if (rmRandInt(1,2) == 1)
	      rmSetAreaTerrainType(gpPatch3, "great_lakes\ground_grass4_gl");
	   else
	      rmSetAreaTerrainType(gpPatch3, "great_lakes\ground_grass5_gl");
	   rmAddAreaToClass(gpPatch3, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatch3, 2);
	   rmSetAreaMaxBlobs(gpPatch3, 4);
	   rmSetAreaMinBlobDistance(gpPatch3, 5.0);
	   rmSetAreaMaxBlobDistance(gpPatch3, 12.0);
	   rmSetAreaCoherence(gpPatch3, 0.3);
	   rmSetAreaSmoothDistance(gpPatch3, 10);
	   rmAddAreaConstraint(gpPatch3, shortAvoidImpassableLand);
	   if (bareCliffs == 1)
	      rmAddAreaConstraint(gpPatch3, avoidCliffsShort);
	   rmBuildArea(gpPatch3); 
      }
   }

   if (patternChance == 10)  // patches for Great Plains 2 - break up the lines!
   {
      for (i=0; <cNumberNonGaiaPlayers*12)   
      {
	   int gpPatchA=rmCreateArea("GP patch A"+i);
	   rmSetAreaWarnFailure(gpPatchA, false);
	   rmSetAreaSize(gpPatchA, rmAreaTilesToFraction(75), rmAreaTilesToFraction(140));
         rmSetAreaTerrainType(gpPatchA, "great_plains\ground2_gp");
	   rmAddAreaToClass(gpPatchA, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatchA, 2);
	   rmSetAreaMaxBlobs(gpPatchA, 4);
	   rmSetAreaMinBlobDistance(gpPatchA, 5.0);
	   rmSetAreaMaxBlobDistance(gpPatchA, 12.0);
	   rmSetAreaCoherence(gpPatchA, 0.3);
	   rmSetAreaSmoothDistance(gpPatchA, 10);
	   rmAddAreaConstraint(gpPatchA, shortAvoidImpassableLand);
	   if (bareCliffs == 1)
	      rmAddAreaConstraint(gpPatchA, avoidCliffsShort);
	   rmAddAreaConstraint(gpPatchA, patchConstraint);
	   rmBuildArea(gpPatchA); 
      }

      for (i=0; <cNumberNonGaiaPlayers*10)   // little green patches
      {
	   int gpPatchC=rmCreateArea("GP patch C"+i);
	   rmSetAreaWarnFailure(gpPatchC, false);
	   rmSetAreaSize(gpPatchC, rmAreaTilesToFraction(15), rmAreaTilesToFraction(45));
         rmSetAreaTerrainType(gpPatchC, "great_plains\ground8_gp");
	   rmAddAreaToClass(gpPatchC, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatchC, 2);
	   rmSetAreaMaxBlobs(gpPatchC, 4);
	   rmSetAreaMinBlobDistance(gpPatchC, 5.0);
	   rmSetAreaMaxBlobDistance(gpPatchC, 10.0);
	   rmSetAreaCoherence(gpPatchC, 0.1);
	   rmSetAreaSmoothDistance(gpPatchC, 10);
	   rmAddAreaConstraint(gpPatchC, shortAvoidImpassableLand);
	   if (bareCliffs == 1)
	      rmAddAreaConstraint(gpPatchC, avoidCliffsShort);
	   rmAddAreaConstraint(gpPatchC, patchConstraint);
	   rmBuildArea(gpPatchC); 
      }

      for (i=0; <cNumberNonGaiaPlayers*9)   
      {
	   int gpPatchD=rmCreateArea("GP patch D"+i);
	   rmSetAreaWarnFailure(gpPatchD, false);
	   rmSetAreaSize(gpPatchD, rmAreaTilesToFraction(50), rmAreaTilesToFraction(70));
         rmSetAreaTerrainType(gpPatchD, "great_plains\ground3_gp");
	   rmAddAreaToClass(gpPatchD, rmClassID("classPatch"));
	   rmSetAreaMinBlobs(gpPatchD, 3);
	   rmSetAreaMaxBlobs(gpPatchD, 5);
	   rmSetAreaMinBlobDistance(gpPatchD, 12.0);
	   rmSetAreaMaxBlobDistance(gpPatchD, 20.0);
	   rmSetAreaCoherence(gpPatchD, 0.1);
	   rmSetAreaSmoothDistance(gpPatchD, 10);
	   rmAddAreaConstraint(gpPatchD, shortAvoidImpassableLand);
	   if (bareCliffs == 1)
	      rmAddAreaConstraint(gpPatchD, avoidCliffsShort);
	   rmAddAreaConstraint(gpPatchD, patchConstraint);
	   rmBuildArea(gpPatchD); 
      }
   }
   
   if (patternChance == 3) // Bayou
   {	
	int treeClumps = rmRandInt(6,9);
	for(i=1; < treeClumps)
	{
	   int randomWaterTreeID=rmCreateObjectDef("random tree in water"+i);	
   	   rmAddObjectDefItem(randomWaterTreeID, "treeBayouMarsh", rmRandInt(3,7), 3.0);
	   rmSetObjectDefMinDistance(randomWaterTreeID, 0.0);
	   rmSetObjectDefMaxDistance(randomWaterTreeID, rmXFractionToMeters(0.1));
	   rmPlaceObjectDefInArea(randomWaterTreeID, 0, smalllakeID, rmRandInt(1,2));
	} 

	int randomTurtlesID=rmCreateObjectDef("random turtles in water");
	rmAddObjectDefItem(randomTurtlesID, "propTurtles", 1, 3.0);
	rmSetObjectDefMinDistance(randomTurtlesID, 0.0);
	rmSetObjectDefMaxDistance(randomTurtlesID, rmXFractionToMeters(0.1));
	rmAddObjectDefConstraint(randomTurtlesID, nearShore);

	int randomWaterRocksID=rmCreateObjectDef("random rocks in water");
	rmAddObjectDefItem(randomWaterRocksID, "underbrushLake", rmRandInt(1,3), 3.0);
	rmSetObjectDefMinDistance(randomWaterRocksID, 0.0);
	rmSetObjectDefMaxDistance(randomWaterRocksID, rmXFractionToMeters(0.1));

	int randomDucksID=rmCreateObjectDef("random ducks in water");
	rmAddObjectDefItem(randomDucksID, "DuckFamily", 1, 0.0);
	rmSetObjectDefMinDistance(randomDucksID, 0.0);
	rmSetObjectDefMaxDistance(randomDucksID, rmXFractionToMeters(0.1));
	rmAddObjectDefConstraint(randomDucksID, avoidDucks);

	rmPlaceObjectDefInArea(randomTurtlesID, 0, smalllakeID, rmRandInt(1,2)); 
	rmPlaceObjectDefInArea(randomWaterRocksID, 0, smalllakeID, rmRandInt(1,2)); 
	rmPlaceObjectDefInArea(randomDucksID, 0, smalllakeID, rmRandInt(1,2)); 
   }

   if (patternChance == 12) // Texas desert
   {
	int bigDecorationID=rmCreateObjectDef("Big Texas Things");
	int avoidBigDecoration=rmCreateTypeDistanceConstraint("avoid big decorations", "BigPropTexas", 45.0);
	rmAddObjectDefItem(bigDecorationID, "BigPropTexas", 1, 0.0);
	rmSetObjectDefMinDistance(bigDecorationID, 0.0);
	rmSetObjectDefMaxDistance(bigDecorationID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bigDecorationID, avoidAll);
	rmAddObjectDefConstraint(bigDecorationID, avoidImportantItem);
	rmAddObjectDefConstraint(bigDecorationID, avoidCoin);
	rmAddObjectDefConstraint(bigDecorationID, avoidImpassableLand);
	rmAddObjectDefConstraint(bigDecorationID, avoidBigDecoration);
	rmAddObjectDefConstraint(bigDecorationID, avoidCliffs);
	rmAddObjectDefConstraint(bigDecorationID, longPlayerConstraint);
	rmPlaceObjectDefAtLoc(bigDecorationID, 0, 0.5, 0.5, rmRandInt(2,4));
   }

   if (plainsMap == 1)
   {
	int areThereBuffalo=rmRandInt(1, 2);
	int howManyBuffalo=rmRandInt(2, 3);
	if ( areThereBuffalo == 1 )
	{
		int bisonCarcass=rmCreateGrouping("Bison Carcass", "gp_carcass_bison");
		rmSetGroupingMinDistance(bisonCarcass, 0.0);
		rmSetGroupingMaxDistance(bisonCarcass, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(bisonCarcass, avoidImpassableLand);
		rmAddGroupingConstraint(bisonCarcass, playerConstraint);
		rmAddGroupingConstraint(bisonCarcass, avoidTradeRoute);
		rmAddGroupingConstraint(bisonCarcass, avoidSocket);
		rmAddGroupingConstraint(bisonCarcass, avoidStartingUnits);
		rmAddGroupingConstraint(bisonCarcass, avoidAll);
		rmAddGroupingConstraint(bisonCarcass, avoidNuggetSmall);
		rmPlaceGroupingAtLoc(bisonCarcass, 0, 0.5, 0.5, howManyBuffalo);
	}

	int grassPatchGroupType=-1;
	int grassPatchGroup=-1;
	for(i=1; <10*cNumberNonGaiaPlayers)
      {
		grassPatchGroupType=rmRandInt(1, 7);
		grassPatchGroup=rmCreateGrouping("Grass Patch Group"+i, "gp_grasspatch0"+grassPatchGroupType);
		rmSetGroupingMinDistance(grassPatchGroup, 0.0);
		rmSetGroupingMaxDistance(grassPatchGroup, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(grassPatchGroup, avoidImpassableLand);
		rmAddGroupingConstraint(grassPatchGroup, playerConstraint);
		rmAddGroupingConstraint(grassPatchGroup, avoidTradeRoute);
		rmAddGroupingConstraint(grassPatchGroup, avoidSocket);
		rmAddGroupingConstraint(grassPatchGroup, avoidNatives);
		rmAddGroupingConstraint(grassPatchGroup, avoidNuggetSmall);
		rmAddGroupingConstraint(grassPatchGroup, circleConstraint);
		rmAddGroupingConstraint(grassPatchGroup, avoidStartingUnits);
		rmAddGroupingConstraint(grassPatchGroup, avoidAll);
		rmAddGroupingConstraint(grassPatchGroup, avoidCliffs);
		rmPlaceGroupingAtLoc(grassPatchGroup, 0, 0.5, 0.5, 1);
	}

	int flowerPatchGroupType=-1;
	int flowerPatchGroup=-1;
	for(i=1; <8*cNumberNonGaiaPlayers)
      {
		flowerPatchGroupType=rmRandInt(1, 8);
		flowerPatchGroup=rmCreateGrouping("Flower Patch Group"+i, "gp_flower0"+flowerPatchGroupType);
		rmSetGroupingMinDistance(flowerPatchGroup, 0.0);
		rmSetGroupingMaxDistance(flowerPatchGroup, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(flowerPatchGroup, avoidImpassableLand);
		rmAddGroupingConstraint(flowerPatchGroup, playerConstraint);
		rmAddGroupingConstraint(flowerPatchGroup, avoidTradeRoute);
		rmAddGroupingConstraint(flowerPatchGroup, avoidSocket);
		rmAddGroupingConstraint(flowerPatchGroup, avoidNatives);
		rmAddGroupingConstraint(flowerPatchGroup, avoidNuggetSmall);
		rmAddGroupingConstraint(flowerPatchGroup, avoidAll);
		rmAddGroupingConstraint(flowerPatchGroup, avoidCliffs);
		rmAddGroupingConstraint(flowerPatchGroup, circleConstraint);
		rmAddGroupingConstraint(flowerPatchGroup, avoidStartingUnits);
		rmPlaceGroupingAtLoc(flowerPatchGroup, 0, 0.5, 0.5, 1);
	}
   }

   if (vultures == 1)
   { 
	int vultureID=rmCreateObjectDef("perching vultures");
	int avoidVultures=rmCreateTypeDistanceConstraint("avoid other vultures", "PropVulturePerching", 30.0);
	rmAddObjectDefItem(vultureID, "PropVulturePerching", 1, 0.0);
	rmSetObjectDefMinDistance(vultureID, 0.0);
	rmSetObjectDefMaxDistance(vultureID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(vultureID, avoidAll);
	rmAddObjectDefConstraint(vultureID, avoidImportantItem);
	rmAddObjectDefConstraint(vultureID, avoidCoin);
	rmAddObjectDefConstraint(vultureID, avoidImpassableLand);
	rmAddObjectDefConstraint(vultureID, avoidTradeRoute);
	rmAddObjectDefConstraint(vultureID, avoidCliffs);
	rmAddObjectDefConstraint(vultureID, avoidVultures);
	rmAddObjectDefConstraint(vultureID, avoidWater20);
	rmAddObjectDefConstraint(vultureID, longPlayerConstraint);
	rmPlaceObjectDefAtLoc(vultureID, 0, 0.5, 0.5, 2);
   }

   if (eagles == 1)
   {
	int avoidEagles=rmCreateTypeDistanceConstraint("avoids Eagles", "EaglesNest", 40.0);
	int randomEagleTreeID=rmCreateObjectDef("random eagle tree");
	rmAddObjectDefItem(randomEagleTreeID, "EaglesNest", 1, 0.0);
	rmSetObjectDefMinDistance(randomEagleTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomEagleTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomEagleTreeID, avoidAll);
	rmAddObjectDefConstraint(randomEagleTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomEagleTreeID, avoidEagles);
	rmPlaceObjectDefAtLoc(randomEagleTreeID, 0, 0.5, 0.5, 2);
   }

   if ((patternChance == 13) || (patternChance == 28))   // for Sonora or Painted Desert     
   {
	int buzzardFlockID=rmCreateObjectDef("buzzards");
	int avoidBuzzards=rmCreateTypeDistanceConstraint("buzzard avoid buzzard", "BuzzardFlock", 70.0);
	rmAddObjectDefItem(buzzardFlockID, "BuzzardFlock", 1, 3.0);
	rmSetObjectDefMinDistance(buzzardFlockID, 0.0);
	rmSetObjectDefMaxDistance(buzzardFlockID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(buzzardFlockID, avoidBuzzards);
	rmAddObjectDefConstraint(buzzardFlockID, avoidSocket);
	rmAddObjectDefConstraint(buzzardFlockID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(buzzardFlockID, playerConstraint);
	rmPlaceObjectDefAtLoc(buzzardFlockID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
   }

   if (patternChance == 36) // GL
   {
	int avoidGrass=rmCreateTypeDistanceConstraint("avoids grass", "TreeGreatPlainsGrass", 30.0);
   	int Grass=rmCreateObjectDef("grass");
	rmAddObjectDefItem(Grass, "TreeGreatPlainsGrass", 1, 0.0);
	rmSetObjectDefMinDistance(Grass, 0.0);
	rmSetObjectDefMaxDistance(Grass, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(Grass, avoidAll);
	rmAddObjectDefConstraint(Grass, avoidImpassableLand);
	rmAddObjectDefConstraint(Grass, playerConstraint);
	rmPlaceObjectDefAtLoc(Grass, 0, 0.5, 0.5, 9*cNumberNonGaiaPlayers);
   }
   
   if (patternChance == 17) // Pampas
   {
      for (i=0; <9*cNumberNonGaiaPlayers)
      {
         int pampasPatch=rmCreateArea("pampas patch "+i);
         rmSetAreaWarnFailure(pampasPatch, false);
         rmAddAreaToClass(pampasPatch, rmClassID("classPatch"));
	   if (cliffVariety < 3) // not used for cliffs!
	   {
		rmSetAreaSize(pampasPatch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
		rmSetAreaTerrainType(pampasPatch, "pampas\ground6_pam");
	   }
	   else
	   {
		rmSetAreaSize(pampasPatch, rmAreaTilesToFraction(300), rmAreaTilesToFraction(400));
		rmSetAreaMix(pampasPatch, "pampas_grass");
	      rmAddAreaConstraint(pampasPatch, shortForestConstraint);
	   }
         rmSetAreaMinBlobs(pampasPatch, 1);
         rmSetAreaMaxBlobs(pampasPatch, 5);
         rmSetAreaMinBlobDistance(pampasPatch, 14.0);
         rmSetAreaMaxBlobDistance(pampasPatch, 38.0);
         rmSetAreaCoherence(pampasPatch, 0.1);
	   rmSetAreaSmoothDistance(pampasPatch, 10);
	   rmAddAreaConstraint(pampasPatch, shortAvoidImpassableLand);
	   rmAddAreaConstraint(pampasPatch, patchConstraint);
         rmBuildArea(pampasPatch); 
      }

	int avoidBrush=rmCreateTypeDistanceConstraint("avoids brush", "UnderbrushPampas", 30.0);
	int decoUnderbrushID=rmCreateObjectDef("underbrush");
	rmAddObjectDefItem(decoUnderbrushID, "UnderbrushPampas", rmRandInt(4,6), 3.0);
	rmSetObjectDefMinDistance(decoUnderbrushID, 20.0);
	rmSetObjectDefMaxDistance(decoUnderbrushID, rmXFractionToMeters(0.5));
      rmAddObjectDefConstraint(decoUnderbrushID, avoidAll);
	rmAddObjectDefConstraint(decoUnderbrushID, avoidImpassableLand);
	rmAddObjectDefConstraint(decoUnderbrushID, playerConstraint);
	rmAddObjectDefConstraint(decoUnderbrushID, avoidBrush);
	rmAddObjectDefConstraint(decoUnderbrushID, avoidTradeRoute);
      rmPlaceObjectDefAtLoc(decoUnderbrushID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);
   }

   // Text
   rmSetStatusText("",0.99);

}  