// Gandalf's Isles TAD
// by RF_Gandalf
// A Random map script for AOE3: The Asian Dynasties

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
   string sheepType = "";
   string centerHerdType = "";
   string fishType = "";
   string fish2Type = "";
   string whaleType = "";
   string native1Name = "";
   string native2Name = "";
   string mineType = "";
   string propType = "";
   string brushType = "";
   string tradeRouteType = "";

// Pick pattern for trees, terrain, features, etc.
   int patternChance = rmRandInt(30,38);   
   if ((patternChance == 5) || (patternChance == 7) || (patternChance == 14) || (patternChance == 16) || (patternChance == 19) || (patternChance == 20) || (patternChance == 25))     // reset frequency for some patterns - less snow and american jungle
   {
      if (rmRandInt(1,2) == 2)
	   patternChance = rmRandInt(1,38);
   }
   int variantChance = rmRandInt(1,2);
   int lightingChance = rmRandInt(1,2);
   int axisChance = rmRandInt(1,2);
   int playerSide = rmRandInt(1,2);   
   int positionChance = rmRandInt(1,2);   
   int distChance = rmRandInt(1,7);
   int sectionChance = rmRandInt(0,12);
   int directionChance = rmRandInt(1,2);
   int nativePattern = -1;
   int sheepChance = rmRandInt(1,2);
   int tropical = 0;
   int arctic = 0;
   int placeBerries = 1;
   int noHeight = 0;
   int nativeChoice = rmRandInt(1,2);
   int baseHeight = rmRandInt(1,2);
   int twoChoice = rmRandInt(1,2);
   int threeChoice = rmRandInt(1,3);
   int fourChoice = rmRandInt(1,4);
   int fiveChoice = rmRandInt(1,5);
   int sixChoice = rmRandInt(1,6);
   int extraNativeIs = 0;
   int forestCoverUp = 0;
   int lowForest = 0;
   int cacheChance = rmRandInt(1,2);
   int cacheType = 0;
   int llamaCache = 0;
   int berryCache = 0;
   int campfireCache = 0;
   int centeredBigIsland = 0;
   int eBigIs = 0;
   int wBigIs = 0;
   int nBigIs = 0;
   int sBigIs = 0;
   int eEdgeIs = 0;
   int wEdgeIs = 0;
   int nEdgeIs = 0;
   int sEdgeIs = 0;
   int vultures = 0;
   int eagles = 0;
   int eaglerock = 0;
   int kingfishers = 0;
   int underbrush = 0;
   int texasProp = 0;
   int waterNuggets = 0;
   mineType = "mine";

// Text
   rmSetStatusText("",0.05);

// Picks the map size
   int playerTiles=47500;  
   if (cNumberNonGaiaPlayers == 8)
	playerTiles = 35000;
   else if (cNumberNonGaiaPlayers == 7)
	playerTiles = 37000;  
   else if (cNumberNonGaiaPlayers == 6)
	playerTiles = 39000;
   else if (cNumberNonGaiaPlayers == 5)
	playerTiles = 41000;  
   else if (cNumberNonGaiaPlayers == 4)
	playerTiles = 42500;
   else if (cNumberNonGaiaPlayers == 3)
	playerTiles = 44500; 

   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles/0.8);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);
   rmSetSeaLevel(0.0);

// Select terrain pattern details

   if (patternChance == 1) // NE
   { 
      rmSetSeaType("new england coast");
      rmSetMapType("newEngland");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("constantinople");
	else
	   rmSetLightingSet("new england");
      baseType = "newengland_grass";
	forestType = "new england forest";
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
         centerHerdType = "deer";        
	}
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
      fishType = "FishCod"; 
      fish2Type = "FishSalmon";
      whaleType = "minkeWhale";
	if (rmRandInt(1,2) == 1)  
	   mineType = "MineTin";
	cacheType = 1;
	if (rmRandInt(1,3) == 3)
	   berryCache = 1;
      nativePattern = 40;
	eagles = 1;
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
      fishType = "FishSardine";
      fish2Type = "FishCod";
      whaleType = "humpbackWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineTin";
	cacheType = 1;
	if (rmRandInt(1,3) == 3)
	   berryCache = 1;
	noHeight = 1;
	if (nativeChoice == 1)
	   nativePattern = 3;
	else
	   nativePattern = 40;
	eagles = 1;
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
      fishType = "FishSardine";
      fish2Type = "FishCod";
      whaleType = "humpbackWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineTin";
	cacheType = 3;
	if (rmRandInt(1,3) == 3)
	   berryCache = 1;
	if (nativeChoice == 1)
	   nativePattern = 3;
	else
	   nativePattern = 21;
	eagles = 1;
	underbrush = 1;
      brushType = "UnderbrushCarolinasMarsh";
   }
   else if (patternChance == 4) // great lakes green
   {
      if (variantChance == 1)
         rmSetSeaType("great lakes");
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
	treeType = "TreeGreatLakes";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "bison";
         centerHerdType = "moose";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "turkey";
         centerHerdType = "moose";        
	}   
      if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
      fishType = "FishSardine";
      fish2Type = "FishCod";
      whaleType = "minkeWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineTin";
	cacheType = 1;
	if (rmRandInt(1,3) == 3)
	   berryCache = 1;
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
	eagles = 1;
   }
   else if (patternChance == 5) // great lakes winter
   {
      rmSetSeaType("great lakes");
      rmSetMapType("greatlakes");
      rmSetMapType("snow");
	if (lightingChance == 1)
	   rmSetLightingSet("308b_caribbeanlight");
	else
         rmSetLightingSet("Great Lakes Winter");
      baseType = "greatlakes_snow";
	forestType = "great lakes forest snow";
	treeType = "TreeGreatLakesSnow";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "moose";
         centerHerdType = "elk";
	}
      else 
	{     
         deerType = "bison";
         deer2Type = "deer";
         centerHerdType = "moose";       
	}      
      if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
      fishType = "FishSalmon";
      fish2Type = "FishCod";
      whaleType = "minkeWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineTin";
	cacheType = 1;
      placeBerries = 0;
	noHeight = 1;
	if (fiveChoice == 1)
	   nativePattern = 4;
	else if (fiveChoice == 2)
	   nativePattern = 5;
	else if (fiveChoice == 3)
	   nativePattern = 40;
	else if (fiveChoice == 4)
	   nativePattern = 22;
	else
	   nativePattern = 5;
	eagles = 1;
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
      fish2Type = "FishCod";
      whaleType = "beluga";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineTin";
	else
	   mineType = "MineCopper";
	cacheType = 1;
	if (threeChoice == 1)
	   nativePattern = 5;
	else if (threeChoice == 2)
	   nativePattern = 6;
	else if (threeChoice == 3)
	   nativePattern = 16;
	eagles = 1;
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
	treeType = "TreeYukonSnow";
      if (variantChance == 1)
	{
         deerType = "caribou";
         deer2Type = "muskOx";
         centerHerdType = "muskOx";
	}
      else 
	{     
         deerType = "muskOx";
         deer2Type = "caribou";
         centerHerdType = "caribou";       
	}
      sheepChance = 0;
      fishType = "FishSalmon";
      fish2Type = "FishCod";
      whaleType = "beluga";
	if (rmRandInt(1,2) == 1)
	   mineType = "minegold";
	cacheType = 1;
      placeBerries = 0;
	arctic = 1;
	noHeight = 1;
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
	eagles = 1;
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
	treeType = "TreeRockies";
      if (variantChance == 1)
	{
         deerType = "deer";
         deer2Type = "elk";
         centerHerdType = "deer";
	}
      else 
	{     
         deerType = "elk";
         deer2Type = "bighornsheep";
         centerHerdType = "deer";
	}   
      if (sheepChance == 1)
         sheepType = "cow";
      else
         sheepType = "sheep";
      fishType = "FishSalmon";
      fish2Type = "FishCod";
      whaleType = "humpbackWhale";
	cacheType = 2;
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
	eagles = 1;
	underbrush = 1;
      brushType = "UnderbrushRockies";
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
	treeType = "TreeGreatPlains";
      if (variantChance == 1)
	{
         deerType = "bison";
         deer2Type = "pronghorn";
         centerHerdType = "deer";
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
      fishType = "FishSardine";
      fish2Type = "FishCod";
      whaleType = "minkeWhale";
	cacheType = 2;
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
	vultures = 1;
	underbrush = 1;
      brushType = "underbrushGreatPlains"; 
   }
   else if (patternChance == 10) // great plains 2
   {
      rmSetSeaType("Yucatan coast");
      rmSetMapType("greatPlains");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("spc14abuffalo");
	else
         rmSetLightingSet("great plains");
      baseType = "great plains drygrass";
	forestType = "great plains forest";
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
         centerHerdType = "deer";
	}
      sheepType = "cow";
      fishType = "FishSardine";
      fish2Type = "FishCod";
      whaleType = "humpbackWhale";
	cacheType = 2;
	forestCoverUp = 1;
	lowForest = rmRandInt(0,1);
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
	if (rmRandInt(1,2) == 1)
	   texasProp = 1;
	else
	   eaglerock = 1;
	underbrush = 1;
      brushType = "underbrushGreatPlains"; 
   }
   else if (patternChance == 11) // texas grass
   {  
      rmSetSeaType("Atlantic Coast");
      rmSetMapType("texas");
	rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("pampas");
	else
         rmSetLightingSet("texas");
      baseType = "texas_grass";
	forestType = "texas forest";
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
         centerHerdType = "deer";
	}
      sheepType = "cow";
      fishType = "FishSardine";
      fish2Type = "FishCod";
      whaleType = "humpbackWhale";
	cacheType = 2;
	noHeight = 1;
	lowForest = rmRandInt(0,1);
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
	if (rmRandInt(1,2) == 1)
	   texasProp = 1;
	else
	   vultures = 1;	
	underbrush = 1;
      brushType = "underbrushTexasGrass"; 
   }
   else if (patternChance == 12) // texas desert
   { 
      rmSetSeaType("Atlantic Coast");
      rmSetMapType("texas");
	rmSetMapType("grass");
      if (lightingChance == 1)
         rmSetLightingSet("seville");
      else
         rmSetLightingSet("texas");
      baseType = "texas_dirt";
	forestType = "texas forest dirt";
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
      fishType = "FishSardine";
      fish2Type = "FishCod";
      whaleType = "humpbackWhale";
	cacheType = 2;
	noHeight = 1;
	lowForest = rmRandInt(0,1);
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
	if (rmRandInt(1,2) == 1)
	   texasProp = 1;
	else
	   eaglerock = 1;
	underbrush = 1;
	brushType = "UnderbrushDesert";
   }
   else if (patternChance == 13) // sonora
   {  
      rmSetSeaType("caribbean coast");
      rmSetMapType("sonora");
	rmSetMapType("grass");
   	if (lightingChance == 1)
         rmSetLightingSet("sonora");
	else
         rmSetLightingSet("pampas");
      baseType = "sonora_dirt";
	forestType = "sonora forest";
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
      fishType = "FishSardine";
      fish2Type = "FishMahi";
      whaleType = "humpbackWhale";
	if (rmRandInt(1,2) == 1)
	   cacheType = 2;
	else
   	   cacheType = 3;
	noHeight = 1;
	lowForest = 1;
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
	eaglerock = 1;
	underbrush = 1;
	brushType = "UnderbrushDesert";
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
	treeType = "TreeYucatan";
      if (variantChance == 1)
      {
         deerType = "tapir";
         deer2Type = "turkey";
         centerHerdType = "capybara";
      }
      else
	{
         deerType = "capybara";
         deer2Type = "turkey";
         centerHerdType = "tapir";
	}
      sheepChance = 0;
      tropical = 1;
      fishType = "FishTarpon";
      fish2Type = "FishMahi";
      whaleType = "humpbackWhale";
	cacheType = 5;
	if (rmRandInt(1,3) < 3)
	   berryCache = 1;
	nativeChoice = rmRandInt(1,3);
	if (nativeChoice == 1)
	   nativePattern = 12;
	else if (nativeChoice == 2)
	   nativePattern = 35;
	else if (nativeChoice == 3)
	   nativePattern = 36;
	kingfishers = 1;
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
	treeType = "TreeCaribbean";
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
      tropical = 1;
      fishType = "FishTarpon";
      fish2Type = "FishMahi";
      whaleType = "humpbackWhale";
	cacheType = 3;
	noHeight = 1;
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
	kingfishers = 1;
   }
   else if (patternChance == 16) // amazon
   {
      rmSetSeaType("yucatan coast");
      rmSetMapType("amazonia");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("323b_inca");
	else
         rmSetLightingSet("amazon");
      baseType = "amazon grass";
	forestType = "amazon rain forest";
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
      tropical = 1;
      fishType = "FishMahi";
      fish2Type = "FishTarpon";
      whaleType = "humpbackWhale";
	cacheType = 3;
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
	kingfishers = 1;
   }
   else if (patternChance == 17) // pampas
   {
      rmSetSeaType("caribbean coast");
      rmSetMapType("pampas");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("texas");
	else
         rmSetLightingSet("pampas");
      baseType = "pampas_grass";
	forestType = "pampas forest";
	treeType = "TreePampas";
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
      fishType = "FishMahi";
      fish2Type = "FishTarpon";
      whaleType = "humpbackWhale";
	cacheType = 3;
	lowForest = rmRandInt(0,1);
	noHeight = 1;
	if (rmRandInt(1,3) < 3)
	   llamaCache = 1;
	if (threeChoice == 1)
	   nativePattern = 14;
	else if (threeChoice == 2)
	   nativePattern = 25;
	else
	   nativePattern = 26;
	vultures = 1;
	underbrush = 1;
      brushType = "UnderbrushPampas";
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
      baseType = "patagonia_grass";
	forestType = "patagonia forest";
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
      fish2Type = "FishSardine";
      whaleType = "minkeWhale";
	cacheType = 1;

	if (rmRandInt(1,3) < 3)
	   llamaCache = 1;
	if (rmRandInt(1,3) < 3)
	   berryCache = 1;
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
	eagles = 1;
   }
   else if (patternChance == 19) // nwt
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
      if (variantChance == 1)
	{
         deerType = "elk";
         deer2Type = "moose";
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
      fish2Type = "FishSalmon";
      fishType = "FishCod";
      whaleType = "humpbackWhale";
	cacheType = 1;
	if (rmRandInt(1,3) == 3)
	   berryCache = 1;
	if (fourChoice == 1)
	   nativePattern = 27;
	else if (fourChoice == 2)
	   nativePattern = 28;
	else if (fourChoice == 3)
	   nativePattern = 7;
	else
	   nativePattern = 6;
	kingfishers = 1;
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
	treeType = "TreeYukon";
      if (variantChance == 1)
	{
         deerType = "muskOx";
         deer2Type = "caribou";
         centerHerdType = "caribou";
	}
      else 
	{  
         deerType = "caribou"; 
         deer2Type = "caribou";
         centerHerdType = "muskOx";
	}
      sheepChance = 0;
      fishType = "FishSalmon";
      fish2Type = "FishCod";
      whaleType = "minkeWhale";
	cacheType = 1;
	arctic = 1;
      placeBerries = 0;
	if (threeChoice == 1)
	   nativePattern = 5;
	else if (threeChoice == 2)
	   nativePattern = 6;
	else if (threeChoice == 3)
	   nativePattern = 16;
	eagles = 1;
   }
   else if (patternChance == 21) // painted desert
   {   
      rmSetSeaType("Atlantic Coast");
      rmSetMapType("sonora");
	rmSetMapType("grass");
      if (lightingChance == 1)
         rmSetLightingSet("seville");
      else
         rmSetLightingSet("pampas");
	if (twoChoice == 1)
         baseType = "painteddesert_groundmix_2";
	else
         baseType = "painteddesert_groundmix_1";
	forestType = "painteddesert forest";
	treeType = "TreePaintedDesert";
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
      fishType = "FishSardine";
      fish2Type = "FishMahi";
      whaleType = "humpbackWhale";
	mineType = "MineCopper";
	cacheType = 3;
	lowForest = rmRandInt(0,1);
	noHeight = 1;
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
	eaglerock = 1;
   }
   else if (patternChance == 22) // andes
   {
      rmSetSeaType("california coast");
      rmSetMapType("andes");
      rmSetMapType("grass");
	if (lightingChance == 1)
         rmSetLightingSet("greatplainstest");
	else
	   rmSetLightingSet("andes");
      baseType = "andes_grass_a";
	forestType = "andes forest";
	treeType = "TreeAndes";
      if (variantChance == 1)
	{
         deerType = "guanaco";
         deer2Type = "guanaco";
         centerHerdType = "rhea";
	}
      else 
	{     
         deerType = "guanaco";
         deer2Type = "rhea";
         centerHerdType = "guanaco";
	}
      sheepType = "llama";
      fishType = "FishSardine";
      fish2Type = "FishCod";
      whaleType = "humpbackWhale";
	cacheType = 5;
	if (rmRandInt(1,3) < 3)
	   llamaCache = 1;
	if (rmRandInt(1,3) < 3)
	   berryCache = 1;
      tropical = 1;
	if (fiveChoice == 1)
	   nativePattern = 14;
	else if (fiveChoice == 2)
	   nativePattern = 24;
	else if (fiveChoice == 3)
	   nativePattern = 25;
	else if (fiveChoice == 4)
	   nativePattern = 26;
	else
	   nativePattern = 34;
	vultures = 1;
   }
   else if (patternChance == 23) // central araucania
   {
      rmSetSeaType("Araucania Central Coast");
      rmSetMapType("araucania");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("Araucania Central");
	else
         rmSetLightingSet("new england");
	if (twoChoice == 1)
	{ 
         baseType = "araucania_grass_b";
	   forestCoverUp = 1;
	}
	else
         baseType = "araucania_grass_d";	
	forestType = "Araucania Forest";
	treeType = "TreeAraucania";
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
      fishType = "FishCod";
      fish2Type = "FishSalmon";
      whaleType = "humpbackWhale";
	mineType = "MineCopper";
	cacheType = 5;
	if (rmRandInt(1,3) < 3) 
	   llamaCache = 1;
	if (rmRandInt(1,3) < 3) 
	   berryCache = 1;
      tropical = 1;
	if (fiveChoice == 1)
	   nativePattern = 14;
	else if (fiveChoice == 2)
	   nativePattern = 25;
	else if (fiveChoice == 3)
	   nativePattern = 25;
	else if (fiveChoice == 4)
	   nativePattern = 18;
	else
	   nativePattern = 11;
	kingfishers = 1;
   }
   else if (patternChance == 24) // north araucania
   {
      rmSetSeaType("Araucania North Coast");
      rmSetMapType("araucania");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("NthAraucaniaLight");
	else
         rmSetLightingSet("constantinople");  
      baseType = "araucania_north_grass_b";  
	forestType =  "North Araucania Forest";
	treeType = "TreeAraucania";
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
      fishType = "FishCod";
      fish2Type = "FishSardine";
      whaleType = "humpbackWhale";
	mineType = "MineCopper";
	lowForest = rmRandInt(0,1);
	if (rmRandInt(1,2) == 1)
	   cacheType = 5;
	else
	   cacheType = 4;
	if (rmRandInt(1,4) < 4)
	   llamaCache = 1;
	if (fiveChoice == 1)
	   nativePattern = 14;
	else if (fiveChoice == 2)
	   nativePattern = 24;
	else if (fiveChoice == 3)
	   nativePattern = 25;
	else if (fiveChoice == 4)
	   nativePattern = 26;
	else
	   nativePattern = 34;
	vultures = 1;
   }
   else if (patternChance == 25) // south araucania
   {
      rmSetSeaType("Araucania Southern Coast");
      rmSetMapType("araucania");
      rmSetMapType("grass");
	if (lightingChance == 2)
	   rmSetLightingSet("SthAraucaniaLight");
	else
	   rmSetLightingSet("303a_boston");     
      baseType = "araucania_snow_c";
	forestType = "Patagonia Snow Forest";
	treeType = "TreePatagoniaSnow";
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
         centerHerdType = "deer";
	} 
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "llama";
      fish2Type = "FishCod";
      fishType = "FishSalmon";
      whaleType = "humpbackWhale";
	mineType = "MineCopper";
	if (rmRandInt(1,2) == 1)
	   cacheType = 5;
	else
	   cacheType = 4;
	if (rmRandInt(1,3) < 3)
	   llamaCache = 1;
      placeBerries = 0;
	if (fourChoice == 1)
	   nativePattern = 14;
	else if (fourChoice == 2)
	   nativePattern = 25;
	else if (fourChoice == 3)
	   nativePattern = 26;
	else
	   nativePattern = 11;
	eagles = 1;
   }
   else if (patternChance == 26) // california green
   {
      rmSetSeaType("california coast");   
      rmSetMapType("california");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("california");
	else
         rmSetLightingSet("new england");  
      baseType = "california_grass";
	if (fourChoice < 3)
	{ 
	   forestType = "california redwood forest";
	   treeType = "TreeRedwood";
	}
	else 
	{ 
	   forestType = "California pine forest";
	   treeType = "TreePonderosaPine";
	}
      if (variantChance == 1)
	{
         deerType = "elk";
         deer2Type = "deer";
         centerHerdType = "elk";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "elk";
         centerHerdType = "elk";
	} 
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
      fish2Type = "FishCod";
      fishType = "FishSalmon";
      whaleType = "humpbackWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "minegold";
	cacheType = 4;
	if (twoChoice == 1)
	   nativePattern = 27;
	else
	   nativePattern = 28;
	eagles = 1;
   }
   else if (patternChance == 27) // california desert
   {
      rmSetSeaType("california coast");   
      rmSetMapType("california");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("california");
	else
         rmSetLightingSet("new england");  
      baseType = "california_desert2";
	if (fourChoice < 3)
	{ 
	   forestType = "California Desert Forest";
	   treeType = "TreeSonora";
	}
	else 
	{ 
	   forestType = "california madrone forest";
	   treeType = "TreeMadrone";
	}
      if (variantChance == 1)
	{
         deerType = "elk";
         deer2Type = "pronghorn";
         centerHerdType = "elk";
	}
      else 
	{     
         deerType = "deer";
         deer2Type = "elk";
         centerHerdType = "deer";
	} 
      if (sheepChance == 1)
         sheepType = "sheep";
      else
         sheepType = "cow";
      fish2Type = "FishMahi";
      fishType = "FishSardine";
      whaleType = "humpbackWhale";
	lowForest = rmRandInt(0,1);
	if (rmRandInt(1,2) == 1)
	   mineType = "mine";
	else
	   mineType = "minegold";
	cacheType = 4;
	if (twoChoice == 1)
	   nativePattern = 27;
	else
	   nativePattern = 43;
	vultures = 1;
	underbrush = 1;
	brushType = "UnderbrushDesert";
   }
   else if (patternChance == 28) // palm desert
   {   
      rmSetSeaType("Atlantic Coast");
      rmSetMapType("sonora");
	rmSetMapType("grass");
      if (lightingChance == 1)
         rmSetLightingSet("seville");
      else
         rmSetLightingSet("pampas");
	if (twoChoice == 1)
	{
         baseType = "texas_dirt";
	}
	else
	{
         baseType = "sonora_dirt";
	}
	forestType = "caribbean palm forest";
	treeType = "TreeCaribbean";
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
      fishType = "FishSardine";
      fish2Type = "FishMahi";
      whaleType = "minkeWhale";
      sheepType = "cow";
	cacheType = 5;
	noHeight = 1;
	forestCoverUp = 1;
	lowForest = rmRandInt(0,1);
	if (fourChoice == 1)
	   nativePattern = 33;
	else if (fourChoice == 2)
	   nativePattern = 35;
	else if (fourChoice == 3)
	   nativePattern = 35;
	else 
	   nativePattern = 36;
	vultures = 1;
	underbrush = 1;
	brushType = "UnderbrushPampas";
   }
   else if (patternChance == 29) // atacama
   {
      rmSetSeaType("Araucania North Coast");
      rmSetMapType("araucania");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("NthAraucaniaLight");
	else
         rmSetLightingSet("constantinople");
      baseType = "araucania_north_grass_a";
	forestType = "sonora forest";
	treeType = "TreeSonora";
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
      fishType = "FishMahi";
      fish2Type = "FishSardine";
      whaleType = "humpbackWhale";
	mineType = "MineCopper";
	if (rmRandInt(1,2) == 1)
	   cacheType = 5;
	else
	   cacheType = 4;
      placeBerries = 0;
	forestCoverUp = 1;
	lowForest = 1;
	if (rmRandInt(1,4) < 4)
	   llamaCache = 1;
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
	vultures = 1;
	underbrush = 1;
	brushType = "UnderbrushPampas"; 
   }
   else if (patternChance == 30) // Honshu
   {
      rmSetSeaType("Coastal Japan");
      rmSetMapType("Japan");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("Honshu");
	else
	   rmSetLightingSet("new england");
      baseType = "coastal_japan_a";
	forestType = "Coastal Japan Forest";
	treeType = "ypTreeJapaneseMaple";
      if (variantChance == 1)
	{
         deerType = "ypSerow";
         deer2Type = "ypGiantSalamander";
         centerHerdType = "ypSerow";         
	}
      else 
	{     
         deerType = "ypSerow";
         deer2Type = "ypSerow";
         centerHerdType = "ypGiantSalamander";        
	}
      if (sheepChance == 1)
         sheepType = "ypWaterBuffalo";
      else
         sheepType = "ypGoat";
      fishType = "ypFishTuna";
      fish2Type = "ypSquid";
      whaleType = "minkeWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineTin";
	cacheType = 7;  
	if (rmRandInt(1,3) == 3)
	   berryCache = 1;
      nativePattern = 44;
	kingfishers = 1;
      waterNuggets = 1;
   }
   else if (patternChance == 31) // Deccan
   {
      rmSetSeaType("great lakes");
      rmSetMapType("deccan");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("deccan");
	else
	   rmSetLightingSet("texas");
	if (twoChoice == 1)
	{
         baseType = "deccan_grassy_Dirt_a";
	}
	else
	{
         baseType = "deccan_grass_a";
	} 
	if (threeChoice == 1)
	{
 	   forestType = "Ashoka Forest";
   	   treeType = "ypTreeAshoka";
	}
	else if (threeChoice == 2)
	{
 	   forestType = "Eucalyptus Forest";
   	   treeType = "ypTreeEucalyptus";
	}
	else
	{
	   forestType = "Deccan Forest";
   	   treeType = "ypTreeDeccan";
	}
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
      fishType = "ypFishMolaMola";
      fish2Type = "FishMahi";
      whaleType = "humpbackWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "mineTin";
	else
	   mineType = "minegold";
	cacheType = 6; 
	if (rmRandInt(1,3) == 3)
	   berryCache = 1;
	threeChoice = rmRandInt(1,3);
	if (threeChoice == 1)
         nativePattern = 45;
	else if (threeChoice == 2)
         nativePattern = 46;
	else if (threeChoice == 3)
         nativePattern = 47;
      tropical = 1;
	kingfishers = 1;
   }
   else if (patternChance == 32) // Himalayas
   {
      rmSetSeaType("Hudson Bay");
      rmSetMapType("himalayas");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("Himalayas");
	else
	   rmSetLightingSet("Yukon");
      baseType = "himalayas_a";
	forestType = "Himalayas Forest";
	treeType = "ypTreeHimalayas";
      if (variantChance == 1)
	{
         deerType = "ypIbex";
         deer2Type = "ypMarcoPoloSheep";
         centerHerdType = "ypIbex";         
	}
      else 
	{     
         deerType = "ypMarcoPoloSheep";
         deer2Type = "ypIbex";
         centerHerdType = "ypSerow";        
	}
      sheepType = "ypYak";
      fishType = "ypFishTuna";
      fish2Type = "FishCod";
      whaleType = "minkeWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "MineCopper";
	lowForest = rmRandInt(0,1);
	cacheType = 6;  
      nativePattern = 49;
	eagles = 1;
   }
   else if (patternChance == 33) // Indochina-Borneo
   {
      rmSetSeaType("borneo coast");
      rmSetMapType("borneo");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("borneo");
	else
	   rmSetLightingSet("bayou");
      baseType = "borneo_grass_a";
	if (threeChoice == 1)
	{
	   forestType = "Borneo Palm Forest";
	}
	else if (threeChoice == 2)
	{
	   forestType = "Borneo Canopy Forest";
	}
	else
	{
	   forestType = "Borneo Forest";
	}
	treeType = "ypTreeBorneo";
      if (variantChance == 1)
	{
         deerType = "ypSerow";
         deer2Type = "ypSerow";
         centerHerdType = "ypWildElephant";         
	}
      else 
	{     
         deerType = "ypSerow";
         deer2Type = "ypWildElephant";
         centerHerdType = "ypSerow";        
	}
      sheepType = "ypWaterBuffalo";
      fishType = "ypFishMolaMola";
      fish2Type = "FishMahi";
      whaleType = "humpbackWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "mineTin";
	else
	   mineType = "mineCopper";
	cacheType = 6;  
      nativePattern = 48;
      tropical = 1;
	kingfishers = 1;
	noHeight = 1;
      waterNuggets = 1;
   }
   else if (patternChance == 34) // Mongolia
   {
      rmSetSeaType("great lakes");
      rmSetMapType("mongolia");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("Mongolia");
	else
	   rmSetLightingSet("Pampas");
	if (twoChoice == 1)
	{
         baseType = "mongolia_grass_b";
	   forestType = "Mongolian Forest";
	   treeType = "ypTreeMongolianFir";
	}
	else
	{
         baseType = "mongolia_desert";
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
      fishType = "ypFishTuna";
      fish2Type = "FishSalmon";
      whaleType = "minkeWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "mineTin";
	lowForest = rmRandInt(0,1);
	cacheType = 7;  
      nativePattern = 50;
	eagles = 1;
   }
   else if (patternChance == 35) // Ceylon
   {
      rmSetSeaType("ceylon coast");
      rmSetMapType("ceylon");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("ceylon");
	else
	   rmSetLightingSet("Great Lakes");
      baseType = "ceylon_grass_a";
	forestType = "Ceylon Forest";
	treeType = "ypTreeCeylon";
      if (variantChance == 1)
	{
         deerType = "ypSerow";
         deer2Type = "ypWildElephant";
         centerHerdType = "ypSerow";         
	}
      else 
	{     
         deerType = "ypSerow";
         deer2Type = "ypSerow";
         centerHerdType = "ypWildElephant";        
	}
      if (sheepChance == 1)
         sheepType = "ypWaterBuffalo";
      else
         sheepType = "ypGoat";
      fishType = "ypFishMolaMola";
      fish2Type = "FishMahi";
      whaleType = "humpbackWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "mineTin";
	else
	   mineType = "minegold";
	cacheType = 6;  
	if (rmRandInt(1,3) == 3)
	   berryCache = 1;
      nativePattern = 51;
      tropical = 1;
	kingfishers = 1;
	noHeight = 1;
      waterNuggets = 1;
   }
   else if (patternChance == 36) // Yellow River
   {
      rmSetSeaType("Great Lakes");
      rmSetMapType("yellowRiver");
      rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("carolina");
	else
	   rmSetLightingSet("Great Lakes");
      baseType = "yellow_river_a";
	if (twoChoice == 1)
	{
 	  forestType = "Yellow River Forest";
   	  treeType = "ypTreeBamboo";
	}
	else
	{
	  forestType = "Ginkgo Forest";
   	  treeType = "ypTreeGinkgo";
	}
      if (variantChance == 1)
	{
         deerType = "ypSerow";
         deer2Type = "ypMuskDeer";
         centerHerdType = "ypMuskDeer";         
	}
      else 
	{     
         deerType = "ypMuskDeer";
         deer2Type = "ypSerow";
         centerHerdType = "ypSerow";        
	}
      if (sheepChance == 1)
         sheepType = "ypWaterBuffalo";
      else
         sheepType = "ypGoat";
      fishType = "ypFishTuna";
      fish2Type = "ypSquid";
      whaleType = "humpbackWhale";
	if (rmRandInt(1,2) == 1)
	   mineType = "mineTin";
	else
	   mineType = "mineCopper";
	cacheType = 7;  
	if (rmRandInt(1,3) == 3)
	   berryCache = 1;
      nativePattern = 52;
	if (rmRandInt(1,3) == 1)
	   tropical = 1;
	kingfishers = 1;
   }
   else if (patternChance == 37) // Siberia
   {  
      rmSetSeaType("Atlantic Coast");
      rmSetMapType("ceylon");
	rmSetMapType("grass");
	if (lightingChance == 1)
	   rmSetLightingSet("great plains");
	else
         rmSetLightingSet("texas");
      baseType = "texas_grass";
	forestType = "texas forest";
	treeType = "TreeTexas";
      if (variantChance == 1)
	{
         deerType = "Zebra";
         deer2Type = "ypWildElephant";
         centerHerdType = "Zebra";
	}
      else 
	{     
         deerType = "ypWildElephant";
         deer2Type = "Zebra";
         centerHerdType = "ypWildElephant";
	}
      sheepType = "ypWaterBuffalo";
      fishType = "FishSardine";
      fish2Type = "FishCod";
      whaleType = "humpbackWhale";
	cacheType = 2;
	noHeight = 1;
	lowForest = rmRandInt(0,1);
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
	if (rmRandInt(1,2) == 1)
	   texasProp = 1;
	else
	   vultures = 1;	
	underbrush = 1;
      brushType = "underbrushTexasGrass"; 
   }
   else if (patternChance == 38) // Green Siberia
   {
      rmSetSeaType("Northwest Territory Water");   
      rmSetMapType("mongolia");
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
      sheepType = "ypYak";
      fish2Type = "FishSalmon";
      fishType = "FishCod";
      whaleType = "minkeWhale";
	cacheType = 7;  
	if (twoChoice == 1)
         nativePattern = 52;
	else 
         nativePattern = 54;
      eagles = 1;
   }

   tradeRouteType = "dirt";
   if (patternChance > 29)
      tradeRouteType = "water";
   
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
   if ((patternChance == 5) || (patternChance == 20) || (patternChance == 25)) // gl winter, yukon tundra, s araucania 
      if (lightingChance == 2)    
         rmSetGlobalSnow( 0.7 );
   if (patternChance == 8) // rockies
      if (lightingChance == 2)
         rmSetGlobalSnow( 0.5 );

   if ((patternChance == 33) || (patternChance == 38)) // himalayas, siberia
      if (rmRandInt(1,2) == 2)
         rmSetGlobalRain( 0.3 );
   if (patternChance == 31) // deccan
      if (rmRandInt(1,2) == 2)
         rmSetGlobalRain( 0.3 ); 

   if (patternChance == 19) // nwt
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

   rmTerrainInitialize("water");
   rmSetMapType("water");
   rmSetWorldCircleConstraint(true);
   rmSetWindMagnitude(2.0);

   chooseMercs();

// Define some classes.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
   rmDefineClass("nuggets");
   rmDefineClass("center");
   rmDefineClass("socketClass");
   rmDefineClass("classFish");
   int classHuntable=rmDefineClass("huntableFood");   
   int classHerdable=rmDefineClass("herdableFood"); 
   int classMines=rmDefineClass("all mines"); 
   int classCenterIsland=rmDefineClass("center island");
   int classBonusIsland=rmDefineClass("bonus island");
   int classSettlementIsland=rmDefineClass("settlement island");
   int classNativeIsland=rmDefineClass("native island");
   int classGoldIsland=rmDefineClass("gold island");
   int islandsX=rmDefineClass("islandsX");
   int islandsY=rmDefineClass("islandsY");
   int islandsZ=rmDefineClass("islandsZ");

// Text
   rmSetStatusText("",0.10);

// -------------Define constraints
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
   int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 30.0);
   int centerConstraintShort=rmCreateClassDistanceConstraint("stay away from center short", rmClassID("center"), 12.0);
   int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 70.0);
   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int circleEdgeConstraint=rmCreatePieConstraint("circle edge Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.46), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int centralExtraLandConstraint=rmCreatePieConstraint("circle Constraint for extra land", 0.5, 0.5, 0, rmZFractionToMeters(0.17), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int centralExtraLandConstraint2=rmCreatePieConstraint("2nd circle Constraint for extra land", 0.5, 0.5, 0, rmZFractionToMeters(0.12), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // Player constraints
   int playerConstraintShort=rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 15.0);
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
   int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 25.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 60.0);
   int farPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players more", classPlayer, 85.0);
   int fartherPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players the most", classPlayer, 105.0);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 75.0);

   float constraintChance = rmRandFloat(0, 1);
   int constraintNum = 0;
   if(constraintChance < 0.25)
      constraintNum = 28;
   else if(constraintChance < 0.5)
      constraintNum = 30;
   else if(constraintChance < 0.75)
      constraintNum = 32;
   else 
      constraintNum = 34;
   int secondPlayerConstraint=rmCreateClassDistanceConstraint("also stay away from players", classPlayer, constraintNum); 

   // Nature avoidance
   int forestConstraint2=rmCreateClassDistanceConstraint("forest v forest2", rmClassID("classForest"), 10.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
   int avoidCoin=rmCreateClassDistanceConstraint("avoid coin", rmClassID("all mines"), 10.0);
   int coinAvoidCoin=rmCreateClassDistanceConstraint("coin avoids coin", rmClassID("all mines"), 35.0);
   int longAvoidCoin=rmCreateClassDistanceConstraint("long avoid coin", rmClassID("all mines"), 90.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidSheep=rmCreateClassDistanceConstraint("sheep avoids sheep etc", rmClassID("herdableFood"), 45.0);
   int huntableConstraint=rmCreateClassDistanceConstraint("huntable constraint", rmClassID("huntableFood"), 35.0);

   // Avoid impassable land, certain features
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 18.0);
   int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water mid-long", "Land", false, 10.0);
   int avoidWater15 = rmCreateTerrainDistanceConstraint("avoid water mid-longer", "Land", false, 15.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water a little more", "Land", false, 20.0);
   int rockVsLand = rmCreateTerrainDistanceConstraint("rock v. land", "land", true, 2.0);
   int nearWater = rmCreateTerrainMaxDistanceConstraint("stay near Water", "Water", true, 5.0);
   int avoidLand10 = rmCreateTerrainDistanceConstraint("avoid land by 10", "land", true, 10.0);
   int nearShore=rmCreateTerrainMaxDistanceConstraint("stay near shore", "land", true, 5.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 10.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("things avoid each other", rmClassID("importantItem"), 10.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 7.0);
   int avoidImportantItemMed=rmCreateClassDistanceConstraint("things avoid each other med", rmClassID("importantItem"), 35.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 60.0);
   int avoidNativesLong=rmCreateClassDistanceConstraint("stuff avoids natives longer", rmClassID("natives"), 90.0);
   int avoidNativesShort=rmCreateClassDistanceConstraint("stuff avoids natives shorter", rmClassID("natives"), 15.0);
   int avoidNugget=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 40.0);
   int avoidNuggetSmall=rmCreateClassDistanceConstraint("avoid nuggets by a little", rmClassID("nuggets"), 10.0);
   int avoidNuggetLong=rmCreateClassDistanceConstraint("avoids nuggets long", rmClassID("nuggets"), 70.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int avoidKOTH=rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 8.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 10.0);

   // New extra stuff for water spawn point avoidance.
   int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 5.0);
   int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 40);
   int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-30, rmGetMapXSize()-5, 0, 0, 0);

   // Center constraint
   int avoidCenter=rmCreateClassDistanceConstraint("avoid the center", rmClassID("center"), 30.0);
 
   // Island constraints
   float constraintChance2 = rmRandFloat(0, 1);
   int constraintNum2 = 0;
   if(constraintChance2 < 0.33)
      constraintNum2 = 26;
   else if(constraintChance2 < 0.66)
      constraintNum2 = 29;
   else 
      constraintNum2 = 32;
   float constraintChance3 = rmRandFloat(0, 1);
   int constraintNum3 = 0;
   if(constraintChance3 < 0.33)
      constraintNum3 = 27;
   else if(constraintChance3 < 0.66)
      constraintNum3 = 30;
   else
      constraintNum3 = 32;

   int settlementIslandConstraint=rmCreateClassDistanceConstraint("avoid settlement islands", classSettlementIsland, constraintNum3); 
   int centerIslandConstraint=rmCreateClassDistanceConstraint("avoid center island", classCenterIsland, constraintNum2);
   int nativeIslandConstraint=rmCreateClassDistanceConstraint("avoid native island", classNativeIsland, constraintNum3);
   int nativeIslandConstraintLarge=rmCreateClassDistanceConstraint("avoid native island large", classNativeIsland, rmXFractionToMeters(0.28));
   int islandsXvsY=rmCreateClassDistanceConstraint("island X avoids Y", islandsY, rmRandInt(27,32));
   int islandsYvsX=rmCreateClassDistanceConstraint("island Y avoids X", islandsX, rmRandInt(27,32));
   int islandsXYvsZ=rmCreateClassDistanceConstraint("islands Y and X avoid Z", islandsZ, rmRandInt(27,32));
   int islandsZvsX=rmCreateClassDistanceConstraint("island Z avoids X", islandsX, rmRandInt(27,32));
   int islandsZvsY=rmCreateClassDistanceConstraint("island Z avoids Y", islandsY, rmRandInt(27,32));

   // Cardinal Directions - "quadrants" of the map.
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.75, 0, rmZFractionToMeters(0.22), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.25, 0, rmZFractionToMeters(0.22), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.75, 0.5, 0, rmZFractionToMeters(0.22), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.25, 0.5, 0, rmZFractionToMeters(0.22), rmDegreesToRadians(0), rmDegreesToRadians(360));

// ---------------------------------------------------------------------------------------End constraints

// Text
   rmSetStatusText("",0.15);

// NATIVES - defined
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
   rmSetGroupingMinDistance(villageAID, 34.0);
   rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.06));
   rmAddGroupingConstraint(villageAID, avoidImpassableLand);
   rmAddGroupingConstraint(villageAID, avoidTradeRoute);
   rmAddGroupingConstraint(villageAID, avoidSocket);
   rmAddGroupingConstraint(villageAID, avoidWater15);
   rmAddGroupingConstraint(villageAID, avoidNatives);
   rmAddGroupingConstraint(villageAID, avoidKOTH);

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
   rmSetGroupingMaxDistance(villageDID, rmXFractionToMeters(0.05));
   rmAddGroupingConstraint(villageDID, avoidImpassableLand);
   rmAddGroupingConstraint(villageDID, avoidTradeRoute);
   rmAddGroupingConstraint(villageDID, avoidSocket);
   rmAddGroupingConstraint(villageDID, avoidWater15);
   rmAddGroupingConstraint(villageDID, avoidNativesLong);
   rmAddGroupingConstraint(villageDID, playerConstraint);
   rmAddGroupingConstraint(villageDID, avoidKOTH);

// Center area
   int centerArea=rmCreateArea("TheCenter");
   rmSetAreaSize(centerArea, 0.1, 0.1);
   rmSetAreaLocation(centerArea, 0.5, 0.5);
   rmAddAreaToClass(centerArea, rmClassID("center")); 

// --------------------------------------------------------------------------------Done special definitions 

// Text
   rmSetStatusText("",0.20);

// Set up player starting locations
int fiveChance = rmRandInt(1,5);
int fourChance = rmRandInt(1,4);
int threeChance = rmRandInt(1,3);
int twoChance = rmRandInt(1,2);

if (sectionChance == 0)
{
      directionChance = 0;
      if (distChance == 1)
         rmPlacePlayersCircular(0.31, 0.32, 0.0);
      else if (distChance == 2)
         rmPlacePlayersCircular(0.32, 0.33, 0.0);
      else if (distChance == 3)
         rmPlacePlayersCircular(0.33, 0.34, 0.0);
	else if (distChance == 4)
	   rmPlacePlayersCircular(0.34, 0.35, 0.0);
      else if (distChance == 5)
	   rmPlacePlayersCircular(0.35, 0.36, 0.0);
	else if (distChance == 6)
	   rmPlacePlayersCircular(0.36, 0.37, 0.0);
	else if (distChance == 7)
	   rmPlacePlayersCircular(0.37, 0.38, 0.0);
}
else
{
   if (cNumberNonGaiaPlayers == 2)
   {   
	 sectionChance = rmRandInt(1,21);  
	 distChance = rmRandInt(1,4);
	 if (sectionChance == 1) // opposite, across axis 1
	 {
	    axisChance = 2;
          rmSetPlacementSection(0.0, 0.5);
	    if (fiveChance == 1)
		 eBigIs = 1;
	    else if (fiveChance == 2)
	 	 wBigIs = 1;
	    else if (fiveChance == 3)
	 	 eEdgeIs = 1;
	    else if (fiveChance == 4)
	 	 wEdgeIs = 1;
	    else if (fiveChance == 5)
	    {
		 if (rmRandInt(1,3) == 1)
		    directionChance = 0;
		 else
	       { 
		    if (rmRandInt(1,2) == 1)
		       directionChance = 1;
		    else
                   directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 2) // opposite, across axis 2
	 {
	    axisChance = 1;
          rmSetPlacementSection(0.25, 0.75);
	    if (fiveChance == 1)
		 nBigIs = 1;
	    else if (fiveChance == 2)
	 	 sBigIs = 1;
	    else if (fiveChance == 3)
	 	 nEdgeIs = 1;
	    else if (fiveChance == 4)
	 	 sEdgeIs = 1;
	    else if (fiveChance == 5)
	    {
		 if (rmRandInt(1,3) == 1)
		    directionChance = 0;
		 else
	       { 
		    if (rmRandInt(1,2) == 1)
		       directionChance = 1;
		    else
                   directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance < 5) // 3,4 East side of map
	 {
	    if (sectionChance == 3)
             rmSetPlacementSection(0.1, 0.4);
	    if (sectionChance == 4)
             rmSetPlacementSection(0.15, 0.35);
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 1;
		    else
                   directionChance = 0;
		 }
	    }
	 }
	 else if (sectionChance < 7) // 5,6 W side of map
	 {
	    if (sectionChance == 5)
             rmSetPlacementSection(0.6, 0.9);
	    if (sectionChance == 6)
             rmSetPlacementSection(0.65, 0.85);
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 2;
		    else
                   directionChance = 0;
		 }
	    }
	 }
	 else if (sectionChance < 9) // 7,8 S side of map
	 {
	    if (sectionChance == 7)
             rmSetPlacementSection(0.35, 0.65);
	    if (sectionChance == 8)
             rmSetPlacementSection(0.4, 0.6);
	    if (threeChance == 1)
		 nBigIs = 1;
	    else if (threeChance == 2)
	 	 nEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 2;
		    else
                   directionChance = 0;
		 }
	    }
	 }
	 else if (sectionChance < 11) // 9,10 N side of map
	 {
	    if (sectionChance == 9)
             rmSetPlacementSection(0.85, 0.15);
	    if (sectionChance == 10)
             rmSetPlacementSection(0.9, 0.1);
	    if (threeChance == 1)
		 sBigIs = 1;
	    else if (threeChance == 2)
	 	 sEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 1;
		    else
                   directionChance = 0;
		 }
	    }
	 }
	 else if (sectionChance == 11) // next 4 same side, 0.4 of map
	 {
          rmSetPlacementSection(0.05, 0.45); // E
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 2;
		    directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 12)
	 {
          rmSetPlacementSection(0.55, 0.95); // W
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 2;
  	          directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 13)
	 {
          rmSetPlacementSection(0.3, 0.7); // S
	    if (threeChance == 1)
		 nBigIs = 1;
	    else if (threeChance == 2)
	 	 nEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 1;
		    directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 14)
	 {
          rmSetPlacementSection(0.8, 0.2); // N
	    if (threeChance == 1)
		 sBigIs = 1;
	    else if (threeChance == 2)
	 	 sEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 1;
		    directionChance = 1;
		 }
          }
	 }
	 else if (sectionChance == 15) // opposite, not on axis
	 {
             rmSetPlacementSection(0.1, 0.6);
		 if (rmRandInt(1,4) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
		    {
		       if (rmRandInt(1,2) == 1)
		          directionChance = 1;
		       else
                      directionChance = 2;
		    }
		 }
	 }
	 else if (sectionChance == 16) // opposite, not on axis
	 {
             rmSetPlacementSection(0.4, 0.9);
		 if (rmRandInt(1,4) == 1)
		 {
		    directionChance = 0;
		    axisChance = 1;
		 }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
		    {
		       if (rmRandInt(1,2) == 1)
		          directionChance = 1;
		       else
                      directionChance = 2;
		    }
		 }
	 }
	 else if (sectionChance == 17) // opposite, not on axis
	 {
             rmSetPlacementSection(0.15, 0.65);
		 if (rmRandInt(1,4) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
		    {
		       if (rmRandInt(1,2) == 1)
		          directionChance = 1;
		       else
                      directionChance = 2;
		    }
		 }
	 }
	 else if (sectionChance == 18) // opposite, not on axis
	 {
             rmSetPlacementSection(0.35, 0.85);
		 if (rmRandInt(1,4) == 1)
		 {
		    directionChance = 0;
		    axisChance = 2;
		 }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
		    {
		       if (rmRandInt(1,2) == 1)
		          directionChance = 1;
		       else
                      directionChance = 2;
		    }
		 }
	 }
	 else if (sectionChance == 19) // asymmetric
	 {
          rmSetPlacementSection(0.2, 0.4);
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {
  	       directionChance = 1;
		 axisChance = 2;
	    }
	 }
	 else if (sectionChance == 20) // asymmetric
	 {
          rmSetPlacementSection(0.6, 0.8);
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {
  	       directionChance = 2;
		 axisChance = 2;
	    }
	 }
	 else if (sectionChance == 21) // asymmetric
	 {
             rmSetPlacementSection(0.0, 0.7);
		 axisChance = 2;
		 if (rmRandInt(1,2) == 1)
		 {
		    directionChance = 0;
		 }
		 else
		 {
		    directionChance = 1;
		 }
	 }
	    if (distChance == 1)
	       rmPlacePlayersCircular(0.31, 0.32, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.33, 0.34, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
   }
   else if (cNumberNonGaiaPlayers == 3)
   {
	 sectionChance = rmRandInt(1,15);
	 distChance = rmRandInt(1,6);
	 if (sectionChance == 1) // east - next 4 0.5 circ
	 {
          rmSetPlacementSection(0.0, 0.5);
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 2) // south 
	 {
          rmSetPlacementSection(0.25, 0.75);
	    if (threeChance == 1)
		 nBigIs = 1;
	    else if (threeChance == 2)
	 	 nEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 3) // west
	 {
          rmSetPlacementSection(0.5, 0.0);
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 4) // north
	 {
          rmSetPlacementSection(0.75, 0.25);
	    if (threeChance == 1)
		 sBigIs = 1;
	    else if (threeChance == 2)
	 	 sEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 5) // east - next 4 0.6 circ 
	 {
          rmSetPlacementSection(0.95, 0.55);
	    if (threeChance == 1)
		 wBigIs = 1;
	    else if (threeChance == 2)
	 	 wEdgeIs = 1;
	    else if (threeChance == 3)
	    {		
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 6) // south 
	 {
          rmSetPlacementSection(0.15, 0.85);
	    if (threeChance == 1)
		 nBigIs = 1;
	    else if (threeChance == 2)
	 	 nEdgeIs = 1;
	    else if (threeChance == 3)
	    {	
             if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 7) // west
	 {
          rmSetPlacementSection(0.4, 0.1);
	    if (threeChance == 1)
		 eBigIs = 1;
	    else if (threeChance == 2)
	 	 eEdgeIs = 1;
	    else if (threeChance == 3)
	    {	
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 8) // north
	 {
          rmSetPlacementSection(0.65, 0.35);
	    if (threeChance == 1)
		 sBigIs = 1;
	    else if (threeChance == 2)
	 	 sEdgeIs = 1;
	    else if (threeChance == 3)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 9) // east - next 4 0.6 circ, not on axis
	 {
          rmSetPlacementSection(0.00, 0.60);
	    if (twoChance == 1)
		 wBigIs = 1;
	    else if (twoChance == 2)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else if (sectionChance == 10) // south 
	 {
          rmSetPlacementSection(0.25, 0.85);
	    if (twoChance == 1)
		 nBigIs = 1;
	    else if (twoChance == 2)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 11) // west
	 {
          rmSetPlacementSection(0.50, 0.10);
	    if (twoChance == 1)
		 eBigIs = 1;
	    else if (twoChance == 2)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 2;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 2;
		 }
	    }
	 }
	 else if (sectionChance == 12) // north
	 {
          rmSetPlacementSection(0.75, 0.35);
	    if (twoChance == 1)
		 sBigIs = 1;
	    else if (twoChance == 2)
	    {
		 if (rmRandInt(1,3) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
             }
		 else
		 {
		    axisChance = 1;
		    if (rmRandInt(1,2) == 1)
		       directionChance = 0;
		    else
  	             directionChance = 1;
		 }
	    }
	 }
	 else   // chance 13, 14, 15 whole circular
	 {
	    directionChance = 0;	
	 }
	    if (distChance == 1)
	       rmPlacePlayersCircular(0.31, 0.32, 0.0);
	    else if (distChance == 2)
	       rmPlacePlayersCircular(0.32, 0.33, 0.0);
	    else if (distChance == 3)
	       rmPlacePlayersCircular(0.33, 0.34, 0.0);
	    else if (distChance == 4)
	       rmPlacePlayersCircular(0.34, 0.35, 0.0);
	    else if (distChance == 5)
	       rmPlacePlayersCircular(0.35, 0.36, 0.0);
	    else if (distChance == 6)
	       rmPlacePlayersCircular(0.36, 0.37, 0.0);
   }    
   else 
   {
      if (cNumberTeams == 2)
      {
        if (cNumberNonGaiaPlayers == 4) // 2 teams, 4 players   
        {
	    distChance = rmRandInt(1,6);
 	    directionChance = 0;

          if (axisChance == 1)
          {
	      if (sectionChance == 9)
	      {
		    sBigIs = 1;
	      }
	      if (sectionChance == 10)
	      {
		    sEdgeIs = 1;
	      }
	      if (sectionChance == 11)
	      {
		    nBigIs = 1;
	      }
	      if (sectionChance == 12)
	      {
		    nEdgeIs = 1;
	      }

           if (playerSide == 1)
	  	  rmSetPlacementTeam(0);
           else if (playerSide == 2)
	        rmSetPlacementTeam(1);

	     if (sectionChance == 1)
             rmSetPlacementSection(0.17, 0.33);
	     else if (sectionChance == 2)
             rmSetPlacementSection(0.15, 0.35);
	     else if (sectionChance == 3)
             rmSetPlacementSection(0.13, 0.37);
	     else if (sectionChance == 4)
             rmSetPlacementSection(0.11, 0.39);
	     else if (sectionChance == 5)
             rmSetPlacementSection(0.1, 0.34); // toward CC
	     else if (sectionChance == 6)
             rmSetPlacementSection(0.09, 0.31); // toward CC
	     else if (sectionChance == 7)
             rmSetPlacementSection(0.16, 0.4); // toward C
	     else if (sectionChance == 8)
             rmSetPlacementSection(0.19, 0.41); // toward C
	     else if (sectionChance == 9)
             rmSetPlacementSection(0.12, 0.32); // toward N
	     else if (sectionChance == 10)
		 rmSetPlacementSection(0.10, 0.28); // toward N
	     else if (sectionChance == 11)
		 rmSetPlacementSection(0.18, 0.38); // toward S
	     else if (sectionChance == 12)
             rmSetPlacementSection(0.22, 0.40); // toward S

 	     if (distChance == 1)
      	 rmPlacePlayersCircular(0.32, 0.33, 0.0);
  	     else if (distChance == 2)
  	       rmPlacePlayersCircular(0.31, 0.32, 0.0);
 	     else if (distChance == 3)
              rmPlacePlayersCircular(0.30, 0.31, 0.0);
	     else if (distChance == 4)
	        rmPlacePlayersCircular(0.36, 0.37, 0.0);
           else if (distChance == 5)
              rmPlacePlayersCircular(0.33, 0.34, 0.0);
	     else if (distChance == 6)
	        rmPlacePlayersCircular(0.34, 0.35, 0.0);

	     if (playerSide == 1) 
		  rmSetPlacementTeam(1);
  	     else if (playerSide == 2)
	        rmSetPlacementTeam(0);
	     
	     if (sectionChance == 1)
             rmSetPlacementSection(0.67, 0.83);
	     else if (sectionChance == 2)
             rmSetPlacementSection(0.65, 0.85);
	     else if (sectionChance == 3)
             rmSetPlacementSection(0.63, 0.87);
	     else if (sectionChance == 4)
             rmSetPlacementSection(0.61, 0.89);
	     else if (sectionChance == 5)
             rmSetPlacementSection(0.60, 0.84); // cc
	     else if (sectionChance == 6)
             rmSetPlacementSection(0.59, 0.81); // cc
	     else if (sectionChance == 7)
             rmSetPlacementSection(0.66, 0.90); // c
	     else if (sectionChance == 8)
             rmSetPlacementSection(0.69, 0.91); // c
	     else if (sectionChance == 9)
             rmSetPlacementSection(0.68, 0.88); // n
	     else if (sectionChance == 10)
             rmSetPlacementSection(0.72, 0.90); // n
	     else if (sectionChance == 11)
             rmSetPlacementSection(0.62, 0.82); // s
	     else if (sectionChance == 12)
             rmSetPlacementSection(0.60, 0.78); // s

 	     if (distChance == 1)
      	 rmPlacePlayersCircular(0.32, 0.33, 0.0);
  	     else if (distChance == 2)
  	       rmPlacePlayersCircular(0.31, 0.32, 0.0);
 	     else if (distChance == 3)
              rmPlacePlayersCircular(0.30, 0.31, 0.0);
	     else if (distChance == 4)
	        rmPlacePlayersCircular(0.36, 0.37, 0.0);
           else if (distChance == 5)
              rmPlacePlayersCircular(0.33, 0.34, 0.0);
	     else if (distChance == 6)
	        rmPlacePlayersCircular(0.34, 0.35, 0.0);
         }
         else if (axisChance == 2)
         {
	      if (sectionChance == 9)
	      {
		    wBigIs = 1;
	      }
	      if (sectionChance == 10)
	      {
		    wEdgeIs = 1;
	      }
	      if (sectionChance == 11)
	      {
		    eBigIs = 1;
	      }
	      if (sectionChance == 12)
	      {
		    eEdgeIs = 1;
	      }

	    if (playerSide == 1)
		 rmSetPlacementTeam(0);
          else if (playerSide == 2)
		 rmSetPlacementTeam(1);

	    if (sectionChance == 1)
             rmSetPlacementSection(0.42, 0.58);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.40, 0.60);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.38, 0.62);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.36, 0.64);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.35, 0.59); // toward CC
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.34, 0.56); // toward CC
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.41, 0.65); // toward C
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.44, 0.66); // toward C
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.37, 0.57); // toward E
	    else if (sectionChance == 10)
             rmSetPlacementSection(0.35, 0.50); // toward E
	    else if (sectionChance == 11)
             rmSetPlacementSection(0.43, 0.63); // toward W
	    else if (sectionChance == 12)
             rmSetPlacementSection(0.48, 0.65); // toward W

 	     if (distChance == 1)
      	 rmPlacePlayersCircular(0.32, 0.33, 0.0);
  	     else if (distChance == 2)
  	       rmPlacePlayersCircular(0.31, 0.32, 0.0);
 	     else if (distChance == 3)
              rmPlacePlayersCircular(0.30, 0.31, 0.0);
	     else if (distChance == 4)
	        rmPlacePlayersCircular(0.36, 0.37, 0.0);
           else if (distChance == 5)
              rmPlacePlayersCircular(0.33, 0.34, 0.0);
	     else if (distChance == 6)
	        rmPlacePlayersCircular(0.34, 0.35, 0.0);

	    if (playerSide == 1)
		 rmSetPlacementTeam(1);
          else if (playerSide == 2)
		 rmSetPlacementTeam(0);
	    
	    if (sectionChance == 1)
             rmSetPlacementSection(0.92, 0.08);
	    else if (sectionChance == 2)
             rmSetPlacementSection(0.90, 0.10);
	    else if (sectionChance == 3)
             rmSetPlacementSection(0.88, 0.12);
	    else if (sectionChance == 4)
             rmSetPlacementSection(0.86, 0.14);
	    else if (sectionChance == 5)
             rmSetPlacementSection(0.85, 0.09); // toward CC
	    else if (sectionChance == 6)
             rmSetPlacementSection(0.84, 0.06); // toward CC
	    else if (sectionChance == 7)
             rmSetPlacementSection(0.91, 0.15); // toward C
	    else if (sectionChance == 8)
             rmSetPlacementSection(0.94, 0.16); // toward C
	    else if (sectionChance == 9)
             rmSetPlacementSection(0.93, 0.13); // toward E
	    else if (sectionChance == 10)
             rmSetPlacementSection(0.00, 0.15); // toward E
	    else if (sectionChance == 11)
             rmSetPlacementSection(0.87, 0.07); // toward W
	    else if (sectionChance == 12)
             rmSetPlacementSection(0.85, 0.02); // toward W

 	     if (distChance == 1)
      	 rmPlacePlayersCircular(0.32, 0.33, 0.0);
  	     else if (distChance == 2)
  	       rmPlacePlayersCircular(0.31, 0.32, 0.0);
 	     else if (distChance == 3)
              rmPlacePlayersCircular(0.30, 0.31, 0.0);
	     else if (distChance == 4)
	        rmPlacePlayersCircular(0.36, 0.37, 0.0);
           else if (distChance == 5)
              rmPlacePlayersCircular(0.33, 0.34, 0.0);
	     else if (distChance == 6)
	        rmPlacePlayersCircular(0.34, 0.35, 0.0);
         }	  
        }
        else if (cNumberNonGaiaPlayers < 7) // for 2 teams, for 5-6 players  
        {
	    sectionChance = rmRandInt(1,15);
	    if (sectionChance < 13)
  	    {
	       directionChance = 0;

             if (axisChance == 1)
             { 
	        if (sectionChance == 9)
	        {
	          if (twoChance == 1)
		     sBigIs = 1;
	          else if (twoChance == 2)
	 	     sEdgeIs = 1;
	        }
	        if (sectionChance == 10)
	        {
	          if (twoChance == 1)
		     sBigIs = 1;
	          else if (twoChance == 2)
	 	     sEdgeIs = 1;
	        }
	        if (sectionChance == 11)
	        {
	          if (twoChance == 1)
		     nBigIs = 1;
	          else if (twoChance == 2)
	 	     nEdgeIs = 1;
	        }
	        if (sectionChance == 12)
	        {
	          if (twoChance == 1)
		     nBigIs = 1;
	          else if (twoChance == 2)
	 	     nEdgeIs = 1;
	        }
 
             if (playerSide == 1)
	  	    rmSetPlacementTeam(0);
             else if (playerSide == 2)
		    rmSetPlacementTeam(1);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.13, 0.37);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.12, 0.38);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.11, 0.39);
	       else if (sectionChance == 4)
                rmSetPlacementSection(0.10, 0.40);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.1, 0.34); // toward CC
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.09, 0.31); // toward CC
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.16, 0.4); // toward C
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.19, 0.41); // toward C
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.12, 0.32); // toward N
	       else if (sectionChance == 10)
	  	    rmSetPlacementSection(0.07, 0.27); // toward N
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.18, 0.38); // toward S
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.16, 0.40); // toward S

             if (distChance == 1)
         	    rmPlacePlayersCircular(0.30, 0.31, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
        	 else if (distChance == 3)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
		 else if (distChance == 4)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
      	 else if (distChance == 5)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
		 else if (distChance == 6)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);

	       if (playerSide == 1)
		    rmSetPlacementTeam(1);
             else if (playerSide == 2)
		    rmSetPlacementTeam(0);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.63, 0.87);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.62, 0.88);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.61, 0.89);
	       else if (sectionChance == 4)
                rmSetPlacementSection(0.60, 0.90);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.60, 0.84); // cc
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.59, 0.81); // cc
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.66, 0.90); // c
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.69, 0.91); // c
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.68, 0.88); // n
	       else if (sectionChance == 10)
                rmSetPlacementSection(0.73, 0.93); // n
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.62, 0.82); // s
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.60, 0.84); // s

             if (distChance == 1)
         	    rmPlacePlayersCircular(0.30, 0.31, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
        	 else if (distChance == 3)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
		 else if (distChance == 4)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
      	 else if (distChance == 5)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
		 else if (distChance == 6)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
             }
             else if (axisChance == 2)
             {
	        if (sectionChance == 9)
	        {
	          if (twoChance == 1)
		     wBigIs = 1;
	          else if (twoChance == 2)
	 	     wEdgeIs = 1;
	        }
	        if (sectionChance == 10)
	        {
	          if (twoChance == 1)
		     wBigIs = 1;
	          else if (twoChance == 2)
	 	     wEdgeIs = 1;
	        }
	        if (sectionChance == 11)
	        {
	          if (twoChance == 1)
		     eBigIs = 1;
	          else if (twoChance == 2)
	 	     eEdgeIs = 1;
	        }
	        if (sectionChance == 12)
	        {
	          if (twoChance == 1)
		     eBigIs = 1;
	          else if (twoChance == 2)
	 	     eEdgeIs = 1;
	        }

	       if (playerSide == 1)
		    rmSetPlacementTeam(0);
             else if (playerSide == 2)
		    rmSetPlacementTeam(1);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.38, 0.62);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.37, 0.63);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.36, 0.64);
	       else if (sectionChance == 4)
                rmSetPlacementSection(0.35, 0.65);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.35, 0.59); // toward CC
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.34, 0.56); // toward CC
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.41, 0.65); // toward C
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.44, 0.66); // toward C
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.37, 0.57); // toward E
	       else if (sectionChance == 10)
                rmSetPlacementSection(0.32, 0.52); // toward E
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.43, 0.63); // toward W
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.41, 0.65); // toward W

             if (distChance == 1)
         	    rmPlacePlayersCircular(0.30, 0.31, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
        	 else if (distChance == 3)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
		 else if (distChance == 4)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
      	 else if (distChance == 5)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
		 else if (distChance == 6)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
   
	       if (playerSide == 1)
	   	    rmSetPlacementTeam(1);
             else if (playerSide == 2)
		    rmSetPlacementTeam(0);

	       if (sectionChance == 1)
                rmSetPlacementSection(0.88, 0.12);
	       else if (sectionChance == 2)
                rmSetPlacementSection(0.87, 0.13);
	       else if (sectionChance == 3)
                rmSetPlacementSection(0.86, 0.14);
   	       else if (sectionChance == 4)
                rmSetPlacementSection(0.85, 0.15);
	       else if (sectionChance == 5)
                rmSetPlacementSection(0.85, 0.09); // toward CC
	       else if (sectionChance == 6)
                rmSetPlacementSection(0.84, 0.06); // toward CC
	       else if (sectionChance == 7)
                rmSetPlacementSection(0.91, 0.15); // toward C
	       else if (sectionChance == 8)
                rmSetPlacementSection(0.94, 0.16); // toward C
	       else if (sectionChance == 9)
                rmSetPlacementSection(0.93, 0.13); // toward E
	       else if (sectionChance == 10)
                rmSetPlacementSection(0.98, 0.18); // toward E
	       else if (sectionChance == 11)
                rmSetPlacementSection(0.87, 0.07); // toward W
	       else if (sectionChance == 12)
                rmSetPlacementSection(0.85, 0.09); // toward W

             if (distChance == 1)
         	    rmPlacePlayersCircular(0.30, 0.31, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
        	 else if (distChance == 3)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
		 else if (distChance == 4)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
      	 else if (distChance == 5)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
		 else if (distChance == 6)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
	       } 
	    }
	    else if (sectionChance > 12)
          {
		 directionChance = 0;
             if (distChance == 1)
         	    rmPlacePlayersCircular(0.30, 0.31, 0.0);
             else if (distChance == 2)
                rmPlacePlayersCircular(0.31, 0.32, 0.0);
        	 else if (distChance == 3)
                rmPlacePlayersCircular(0.32, 0.33, 0.0);
		 else if (distChance == 4)
         	    rmPlacePlayersCircular(0.33, 0.34, 0.0);
      	 else if (distChance == 5)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
		 else if (distChance == 6)
	   	    rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.37, 0.38, 0.0);
          }
        }
        else  // for 2 teams, for over 6 players
        {  
	     sectionChance = rmRandInt(1,7);
	     if (sectionChance > 5) // chances 6 and 7, opp sides
           {
              if (axisChance == 1)
              {
                 if (playerSide == 1)
	  	       rmSetPlacementTeam(0);
                 else if (playerSide == 2)
		       rmSetPlacementTeam(1);
                 rmSetPlacementSection(0.11, 0.39);

 	           if (distChance == 1)
	              rmPlacePlayersCircular(0.30, 0.31, 0.0);
	           else if (distChance == 2)
	              rmPlacePlayersCircular(0.32, 0.33, 0.0);
	           else if (distChance == 3)
	              rmPlacePlayersCircular(0.34, 0.35, 0.0);
	           else if (distChance == 4)
	              rmPlacePlayersCircular(0.36, 0.37, 0.0);
	           else if (distChance == 5)
	              rmPlacePlayersCircular(0.38, 0.39, 0.0);
	           else if (distChance == 6)
	              rmPlacePlayersCircular(0.40, 0.41, 0.0);
	           else if (distChance == 7)
	              rmPlacePlayersCircular(0.42, 0.43, 0.0);

	           if (playerSide == 1)
			 rmSetPlacementTeam(1);
                 else if (playerSide == 2)
			 rmSetPlacementTeam(0);
                 rmSetPlacementSection(0.61, 0.89);

 	           if (distChance == 1)
	              rmPlacePlayersCircular(0.30, 0.31, 0.0);
	           else if (distChance == 2)
	              rmPlacePlayersCircular(0.32, 0.33, 0.0);
	           else if (distChance == 3)
	              rmPlacePlayersCircular(0.34, 0.35, 0.0);
	           else if (distChance == 4)
	              rmPlacePlayersCircular(0.36, 0.37, 0.0);
	           else if (distChance == 5)
	              rmPlacePlayersCircular(0.38, 0.39, 0.0);
	           else if (distChance == 6)
	              rmPlacePlayersCircular(0.40, 0.41, 0.0);
	           else if (distChance == 7)
	              rmPlacePlayersCircular(0.42, 0.43, 0.0);
              }
              else if (axisChance == 2)
              {
                 if (playerSide == 1)
	  	       rmSetPlacementTeam(0);
                 else if (playerSide == 2)
		       rmSetPlacementTeam(1);
                 rmSetPlacementSection(0.36, 0.64);

 	           if (distChance == 1)
	              rmPlacePlayersCircular(0.30, 0.31, 0.0);
	           else if (distChance == 2)
	              rmPlacePlayersCircular(0.32, 0.33, 0.0);
	           else if (distChance == 3)
	              rmPlacePlayersCircular(0.34, 0.35, 0.0);
	           else if (distChance == 4)
	              rmPlacePlayersCircular(0.36, 0.37, 0.0);
	           else if (distChance == 5)
	              rmPlacePlayersCircular(0.38, 0.39, 0.0);
	           else if (distChance == 6)
	              rmPlacePlayersCircular(0.40, 0.41, 0.0);
	           else if (distChance == 7)
	              rmPlacePlayersCircular(0.42, 0.43, 0.0);

	           if (playerSide == 1)
			 rmSetPlacementTeam(1);
                 else if (playerSide == 2)
			 rmSetPlacementTeam(0);
                 rmSetPlacementSection(0.86, 0.14);

 	           if (distChance == 1)
	              rmPlacePlayersCircular(0.30, 0.31, 0.0);
	           else if (distChance == 2)
	              rmPlacePlayersCircular(0.32, 0.33, 0.0);
	           else if (distChance == 3)
	              rmPlacePlayersCircular(0.34, 0.35, 0.0);
	           else if (distChance == 4)
	              rmPlacePlayersCircular(0.36, 0.37, 0.0);
	           else if (distChance == 5)
	              rmPlacePlayersCircular(0.38, 0.39, 0.0);
	           else if (distChance == 6)
	              rmPlacePlayersCircular(0.40, 0.41, 0.0);
	           else if (distChance == 7)
	              rmPlacePlayersCircular(0.42, 0.43, 0.0);
              }   
           }  
	     else if (sectionChance == 1) // 0.7 of map, gap to E
           {
		 eBigIs = 1;	
             rmSetPlacementSection(0.39, 0.11);
 	       if (distChance == 1)
	          rmPlacePlayersCircular(0.30, 0.31, 0.0);
	       else if (distChance == 2)
	          rmPlacePlayersCircular(0.32, 0.33, 0.0);
	       else if (distChance == 3)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
	       else if (distChance == 4)
	          rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 5)
	          rmPlacePlayersCircular(0.38, 0.39, 0.0);
	       else if (distChance == 6)
	          rmPlacePlayersCircular(0.40, 0.41, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.42, 0.43, 0.0);
		 if (rmRandInt(1,4) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
		 }
		 else
	       {
		    axisChance = 2;		     
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
                   directionChance = 2;
		 }
           }
	     else if (sectionChance == 2) // 0.7 of map, gap to W
           {
		 wBigIs = 1;	
             rmSetPlacementSection(0.89, 0.61);
 	       if (distChance == 1)
	          rmPlacePlayersCircular(0.30, 0.31, 0.0);
	       else if (distChance == 2)
	          rmPlacePlayersCircular(0.32, 0.33, 0.0);
	       else if (distChance == 3)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
	       else if (distChance == 4)
	          rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 5)
	          rmPlacePlayersCircular(0.38, 0.39, 0.0);
	       else if (distChance == 6)
	          rmPlacePlayersCircular(0.40, 0.41, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.42, 0.43, 0.0);
		 if (rmRandInt(1,4) == 1)
		 {
		    axisChance = 1;
		    directionChance = 0;
		 }
		 else
	       {
		    axisChance = 2;		     
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
                   directionChance = 1;
		 }
           }
           else if (sectionChance == 3) // 0.7 of map, gap to S
           {
		 sBigIs = 1;	
             rmSetPlacementSection(0.64, 0.36);
 	       if (distChance == 1)
	          rmPlacePlayersCircular(0.30, 0.31, 0.0);
	       else if (distChance == 2)
	          rmPlacePlayersCircular(0.32, 0.33, 0.0);
	       else if (distChance == 3)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
	       else if (distChance == 4)
	          rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 5)
	          rmPlacePlayersCircular(0.38, 0.39, 0.0);
	       else if (distChance == 6)
	          rmPlacePlayersCircular(0.40, 0.41, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.42, 0.43, 0.0);
		 if (rmRandInt(1,4) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
		 }
		 else
	       {
		    axisChance = 1;		     
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
                   directionChance = 1;
		 }
           }
           else if (sectionChance == 4) // 0.7 of map, gap to N
           {
		 nBigIs = 1;	
             rmSetPlacementSection(0.14, 0.86);
 	       if (distChance == 1)
	          rmPlacePlayersCircular(0.30, 0.31, 0.0);
	       else if (distChance == 2)
	          rmPlacePlayersCircular(0.32, 0.33, 0.0);
	       else if (distChance == 3)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
	       else if (distChance == 4)
	          rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 5)
	          rmPlacePlayersCircular(0.38, 0.39, 0.0);
	       else if (distChance == 6)
	          rmPlacePlayersCircular(0.40, 0.41, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.42, 0.43, 0.0);
		 if (rmRandInt(1,4) == 1)
		 {
		    axisChance = 2;
		    directionChance = 0;
		 }
		 else
	       {
		    axisChance = 1;		     
		    if (rmRandInt(1,3) == 1)
		       directionChance = 0;
		    else
                   directionChance = 2;
             }
           }
           else if (sectionChance == 5) // another circular chance
	     {
	       directionChance = 0;
 	       if (distChance == 1)
	          rmPlacePlayersCircular(0.30, 0.31, 0.0);
	       else if (distChance == 2)
	          rmPlacePlayersCircular(0.32, 0.33, 0.0);
	       else if (distChance == 3)
	          rmPlacePlayersCircular(0.34, 0.35, 0.0);
	       else if (distChance == 4)
	          rmPlacePlayersCircular(0.36, 0.37, 0.0);
	       else if (distChance == 5)
	          rmPlacePlayersCircular(0.38, 0.39, 0.0);
	       else if (distChance == 6)
	          rmPlacePlayersCircular(0.40, 0.41, 0.0);
	       else if (distChance == 7)
	          rmPlacePlayersCircular(0.42, 0.43, 0.0);
	     }
        }
      }
      else  // for FFA or over 2 teams
      {
	   sectionChance = rmRandInt(1,5);
	   if (sectionChance > 4) // another chance at circular placement
	   {
            directionChance = 0;
            if (cNumberNonGaiaPlayers < 6) //FFA 4 or 5 pl
            {
               if (distChance == 1)
         	      rmPlacePlayersCircular(0.30, 0.31, 0.0);
               else if (distChance == 2)
                  rmPlacePlayersCircular(0.31, 0.32, 0.0);
      	   else if (distChance == 3)
                  rmPlacePlayersCircular(0.32, 0.33, 0.0);
		   else if (distChance == 4)
         	      rmPlacePlayersCircular(0.33, 0.34, 0.0);
      	   else if (distChance == 5)
	            rmPlacePlayersCircular(0.34, 0.35, 0.0);
		   else if (distChance == 6)
	   	      rmPlacePlayersCircular(0.36, 0.37, 0.0);
	         else if (distChance == 7)
	            rmPlacePlayersCircular(0.37, 0.38, 0.0);
            }
            else  // over 5 FFA 
            { 
 	         if (distChance == 1)
	            rmPlacePlayersCircular(0.30, 0.31, 0.0);
	         else if (distChance == 2)
	            rmPlacePlayersCircular(0.32, 0.33, 0.0);
	         else if (distChance == 3)
	            rmPlacePlayersCircular(0.34, 0.35, 0.0);
	         else if (distChance == 4)
	            rmPlacePlayersCircular(0.36, 0.37, 0.0);
	         else if (distChance == 5)
	            rmPlacePlayersCircular(0.38, 0.39, 0.0);
	         else if (distChance == 6)
	            rmPlacePlayersCircular(0.40, 0.41, 0.0);
	         else if (distChance == 7)
                  rmPlacePlayersCircular(0.42, 0.43, 0.0);
            }
	   }
         else 
         {
	      if (sectionChance == 1) // 0.7 of map, gap to E	
		{
		    if (threeChance == 1)
			eBigIs = 1;
		    else if (threeChance == 2)
		    {
		       axisChance = 1;
		       directionChance = 0;
		    }
		    else
	          {
		       axisChance = 2;		     
		       if (rmRandInt(1,3) == 1)
		          directionChance = 0;
		       else
                      directionChance = 2;
		    }
                rmSetPlacementSection(0.39, 0.11);
		}
	      else if (sectionChance == 2) // 0.7 of map, gap to W
            {
		    if (threeChance == 1)
			wBigIs = 1;
		    else if (threeChance == 2)
		   {
		      axisChance = 1;
		      directionChance = 0;
		   }
		   else
	         {
		      axisChance = 2;		     
		      if (rmRandInt(1,3) == 1)
		         directionChance = 0;
		      else
                     directionChance = 1;
		   }
               rmSetPlacementSection(0.89, 0.61);
		}
            else if (sectionChance == 3) // 0.7 of map, gap to S
            {	
		    if (threeChance == 1)
			sBigIs = 1;
		    else if (threeChance == 2)
		   {
		      axisChance = 2;
		      directionChance = 0;
		   }
		   else
	         {
		      axisChance = 1;		     
		      if (rmRandInt(1,3) == 1)
		         directionChance = 0;
		      else
                     directionChance = 1;
		   }
               rmSetPlacementSection(0.64, 0.36);
            }
            else if (sectionChance == 4) // 0.7 of map, gap to N
            {	
		    if (threeChance == 1)
			nBigIs = 1;
		    else if (threeChance == 2)
		   {
		      axisChance = 2;
		      directionChance = 0;
		   }
		   else
	         {
		      axisChance = 1;		     
		      if (rmRandInt(1,3) == 1)
		         directionChance = 0;
		      else
                     directionChance = 2;
               }
               rmSetPlacementSection(0.14, 0.86);
            }  
		if (cNumberNonGaiaPlayers < 6)
		{
               if (distChance == 1)
         	      rmPlacePlayersCircular(0.30, 0.31, 0.0);
               else if (distChance == 2)
                  rmPlacePlayersCircular(0.31, 0.32, 0.0);
      	   else if (distChance == 3)
                  rmPlacePlayersCircular(0.32, 0.33, 0.0);
		   else if (distChance == 4)
         	      rmPlacePlayersCircular(0.33, 0.34, 0.0);
      	   else if (distChance == 5)
	            rmPlacePlayersCircular(0.34, 0.35, 0.0);
		   else if (distChance == 6)
	   	      rmPlacePlayersCircular(0.36, 0.37, 0.0);
	         else if (distChance == 7)
	            rmPlacePlayersCircular(0.37, 0.38, 0.0);
		}
		else
		{
 	         if (distChance == 1)
	            rmPlacePlayersCircular(0.30, 0.31, 0.0);
	         else if (distChance == 2)
	            rmPlacePlayersCircular(0.32, 0.33, 0.0);
	         else if (distChance == 3)
	            rmPlacePlayersCircular(0.34, 0.35, 0.0);
	         else if (distChance == 4)
	            rmPlacePlayersCircular(0.36, 0.37, 0.0);
	         else if (distChance == 5)
	            rmPlacePlayersCircular(0.38, 0.39, 0.0);
	         else if (distChance == 6)
	            rmPlacePlayersCircular(0.40, 0.41, 0.0);
	         else if (distChance == 7)
                  rmPlacePlayersCircular(0.42, 0.43, 0.0);
		}
         }
      }
   }
}

// Set up player areas.
   float playerFraction=rmAreaTilesToFraction(7000 + cNumberNonGaiaPlayers*150);
   float randomIslandChance=rmRandFloat(0, 1);
   for(i=1; <cNumberPlayers)
   {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      rmSetAreaSize(id, 0.95*playerFraction, 1.05*playerFraction);
      rmAddAreaToClass(id, classPlayer);
	if (noHeight == 1)
         rmSetAreaBaseHeight(id, 0.5);
	else
         rmSetAreaBaseHeight(id, baseHeight);
      rmSetAreaSmoothDistance(id, 15);
	rmSetAreaCoherence(id, 0.8);
      rmSetAreaElevationVariation(id, 1.0);
      rmSetAreaElevationMinFrequency(id, 0.09);
      rmSetAreaElevationOctaves(id, 3);
      rmSetAreaElevationPersistence(id, 0.2);
	rmSetAreaElevationNoiseBias(id, 1);
      rmAddAreaConstraint(id, avoidCenter); 
      rmAddAreaConstraint(id, mediumPlayerConstraint);
      rmAddAreaConstraint(id, circleEdgeConstraint);
      rmSetAreaLocPlayer(id, i);
      rmSetAreaMix(id, baseType);
   }
   rmBuildAllAreas();

// Text
   rmSetStatusText("",0.25);

// Starting TCs and units 		
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 6.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);

   int startingTCID= rmCreateObjectDef("startingTC");
   rmSetObjectDefMaxDistance(startingTCID, 10.0);
   rmAddObjectDefConstraint(startingTCID, avoidAll);
   rmAddObjectDefConstraint(startingTCID, longAvoidImpassableLand);               
   if ( rmGetNomadStart())
   {
	rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }

   int startingWood= rmCreateObjectDef("startingWood");
   rmSetObjectDefMinDistance(startingWood, 6.0);
   rmSetObjectDefMaxDistance(startingWood, 9.0);
   rmAddObjectDefConstraint(startingWood, avoidAll);
   rmAddObjectDefItem(startingWood, "CrateOfWood", 2, 0.0);

   for(i=1; <cNumberPlayers)
   {	
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingWood, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
      if(ypIsAsian(i) && rmGetNomadStart() == false)
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
   }

// Big or Center Island
   int bigIslandID=rmCreateArea("big island");
   rmSetAreaSize(bigIslandID, rmAreaTilesToFraction(5000 + cNumberNonGaiaPlayers*500), rmAreaTilesToFraction(5500 + cNumberNonGaiaPlayers*500));
 if (wBigIs == 1)
 {
   rmSetAreaLocation(bigIslandID, 0.28, 0.5);
   rmAddAreaInfluenceSegment(bigIslandID, 0.12, 0.5, 0.44, 0.5);
 }
 else if (wEdgeIs == 1)
 {
   rmSetAreaLocation(bigIslandID, 0.2, 0.5);
   rmAddAreaInfluenceSegment(bigIslandID, 0.19, 0.5, 0.28, 0.69);
   rmAddAreaInfluenceSegment(bigIslandID, 0.19, 0.5, 0.28, 0.31);
 }
 else if (eBigIs == 1)
 {
   rmSetAreaLocation(bigIslandID, 0.72, 0.5);
   rmAddAreaInfluenceSegment(bigIslandID, 0.56, 0.5, 0.88, 0.5);
 } 
 else if (eEdgeIs == 1)
 {
   rmSetAreaLocation(bigIslandID, 0.81, 0.5);
   rmAddAreaInfluenceSegment(bigIslandID, 0.82, 0.5, 0.72, 0.69);
   rmAddAreaInfluenceSegment(bigIslandID, 0.82, 0.5, 0.72, 0.31);
 } 
 else if (sBigIs == 1)
 {
   rmSetAreaLocation(bigIslandID, 0.5, 0.28);
   rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.12, 0.5, 0.44);
 }
 else if (sEdgeIs == 1)
 {
   rmSetAreaLocation(bigIslandID, 0.5, 0.2);
   rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.19, 0.69, 0.28);
   rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.19, 0.31, 0.28);
 }
 else if (nBigIs == 1)
 {
   rmSetAreaLocation(bigIslandID, 0.5, 0.72);
   rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.88, 0.5, 0.56);
 }
 else if (nEdgeIs == 1)
 {
   rmSetAreaLocation(bigIslandID, 0.5, 0.8);
   rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.81, 0.69, 0.72);
   rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.81, 0.31, 0.72);
 } 
 else
 {
   centeredBigIsland = 1;
   rmSetAreaLocation(bigIslandID, 0.5, 0.5);
   if (axisChance == 1)
   {
	   if (directionChance == 1)
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.28, 0.5, 0.55);           
	   else if (directionChance == 2)
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.72, 0.5, 0.45);
	   else if (directionChance == 0)
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.38, 0.5, 0.62);
	   if (variantChance == 1)
           rmAddAreaInfluenceSegment(bigIslandID, 0.45, 0.5, 0.5, 0.5);  
	   else
           rmAddAreaInfluenceSegment(bigIslandID, 0.55, 0.5, 0.5, 0.5);  

   }
   else if (axisChance == 2)
   {
	   if (directionChance == 1)
           rmAddAreaInfluenceSegment(bigIslandID, 0.55, 0.5, 0.28, 0.5);
	   else if (directionChance == 2)
           rmAddAreaInfluenceSegment(bigIslandID, 0.45, 0.5, 0.72, 0.5);
	   else if (directionChance == 0)
           rmAddAreaInfluenceSegment(bigIslandID, 0.38, 0.5, 0.62, 0.5);
	   if (variantChance == 1)
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.45, 0.5, 0.5);  
	   else
           rmAddAreaInfluenceSegment(bigIslandID, 0.5, 0.55, 0.5, 0.5);  
   }
 }
   rmSetAreaMix(bigIslandID, baseType);
   rmSetAreaWarnFailure(bigIslandID, false);
   rmAddAreaConstraint(bigIslandID, playerConstraint); 
   rmAddAreaToClass(bigIslandID, classSettlementIsland);
   rmAddAreaToClass(bigIslandID, classCenterIsland);
   rmAddAreaToClass(bigIslandID, classGoldIsland);
   rmSetAreaCoherence(bigIslandID, 0.5);
   rmSetAreaSmoothDistance(bigIslandID, 12);
   rmSetAreaHeightBlend(bigIslandID, 2);
   rmSetAreaBaseHeight(bigIslandID, baseHeight);
   rmBuildArea(bigIslandID);

// Extra Big Island Land
   int extraCount=cNumberNonGaiaPlayers + 2;  // num players plus some extra
   if (cNumberNonGaiaPlayers > 6)
      extraCount=cNumberNonGaiaPlayers + 1;
  
   for(i=0; <extraCount)
   {
      int extraLandID=rmCreateArea("extraland"+i);
      rmSetAreaSize(extraLandID, rmAreaTilesToFraction(500 + cNumberNonGaiaPlayers*100), rmAreaTilesToFraction(600 + cNumberNonGaiaPlayers*120));
      rmSetAreaMix(extraLandID, baseType);
      rmSetAreaWarnFailure(extraLandID, false);
	if ((eBigIs == 1) || (eEdgeIs == 1))
  	   rmAddAreaConstraint(extraLandID, Eastward);
	else if ((wBigIs == 1) || (wEdgeIs == 1))
  	   rmAddAreaConstraint(extraLandID, Westward);
	else if ((nBigIs == 1) || (nEdgeIs == 1))
  	   rmAddAreaConstraint(extraLandID, Northward);
	else if ((sBigIs == 1) || (sEdgeIs == 1))
  	   rmAddAreaConstraint(extraLandID, Southward);
	else
	{
      if (cNumberNonGaiaPlayers > 5)
         rmAddAreaConstraint(extraLandID, centralExtraLandConstraint2);
	else	
         rmAddAreaConstraint(extraLandID, centralExtraLandConstraint);
	}
      rmAddAreaConstraint(extraLandID, playerConstraint); 
      rmAddAreaToClass(extraLandID, classCenterIsland);
      rmAddAreaToClass(extraLandID, classGoldIsland);
      rmSetAreaCoherence(extraLandID, 0.55);
      rmSetAreaSmoothDistance(extraLandID, 20);
      rmSetAreaHeightBlend(extraLandID, 2);
      rmSetAreaBaseHeight(extraLandID, baseHeight);
      rmBuildArea(extraLandID);
   }

// Text
   rmSetStatusText("",0.30);

// Trade Route
int tradeRouteID = rmCreateTradeRoute();
if (wBigIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.13, 0.5);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.24, 0.525);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.34, 0.475);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.43, 0.5);
}
else if (eBigIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.5);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.76, 0.525);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.66, 0.475);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.57, 0.5);
}
else if (wEdgeIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.27, 0.68);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 0.53);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 0.47);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.27, 0.32);
}
else if (eEdgeIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.73, 0.68);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.81, 0.53);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.81, 0.47);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.73, 0.32);
}
else if (sBigIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.13);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.52, 0.24);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.48, 0.34);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.43);
}
else if (nBigIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.87);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.52, 0.76);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.48, 0.66);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.57);
}
else if (sEdgeIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.27);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.53, 0.2);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.47, 0.2);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.32, 0.27);
}
else if (nEdgeIs == 1)
{
   rmAddTradeRouteWaypoint(tradeRouteID, 0.68, 0.73);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.53, 0.81);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.47, 0.81);
   rmAddTradeRouteWaypoint(tradeRouteID, 0.32, 0.73);
}
else
{
   if (axisChance == 1) 
   {
	if (directionChance == 1)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.53);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.475, 0.48);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.525, 0.35);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.3);
	}
	else if (directionChance == 2)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.47);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.475, 0.52);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.525, 0.65);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.7);
	}
	else if (directionChance == 0)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.39);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.525, 0.44);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.475, 0.56);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.61);
	}
   }
   else if (axisChance == 2) 
   {
	if (directionChance == 1)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.53, 0.5);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.48, 0.525);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.475);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.5);
	}
	else if (directionChance == 2)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.47, 0.5);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.52, 0.475);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.525);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 0.5);
	}
	else if (directionChance == 0)
	{
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.39, 0.5);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.44, 0.475);
  	   rmAddTradeRouteWaypoint(tradeRouteID, 0.56, 0.525);
	   rmAddTradeRouteWaypoint(tradeRouteID, 0.61, 0.5);
	}
   }
}
rmBuildTradeRoute(tradeRouteID, tradeRouteType);	

// Trade sockets
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 6.0);

   // add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.09);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   if(cNumberNonGaiaPlayers > 5)
   {
      socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   }
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.91);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

// Text
   rmSetStatusText("",0.35);

// KOTH game mode - on the center Big Island

  int myKingsHillAvoidImpassableLand=rmCreateTerrainDistanceConstraint("my kings hill avoids impassable land", "Land", false, 4.0);
  int myKingsHillAvoidAll=rmCreateTypeDistanceConstraint("my kings hill avoids all", "all", 4.0);
  int myKingsHillAvoidTradeRouteSocket = rmCreateTypeDistanceConstraint("my kings hill avoids trade route socket", "socketTradeRoute", 5.0);
  int myKingsHillAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("my kings hill avoids trade route", 6.0);

   if(rmGetIsKOTH())
   {
      int myKingsHillID = rmCreateObjectDef("MyKingsHill");
      rmAddObjectDefItem(myKingsHillID, "ypKingsHill", 1, 0);
      rmAddObjectDefToClass(myKingsHillID, rmClassID("importantItem"));
      rmSetObjectDefMinDistance(myKingsHillID, 0.0);
      rmSetObjectDefMaxDistance(myKingsHillID, 10);
      rmAddObjectDefConstraint(myKingsHillID, myKingsHillAvoidImpassableLand);
      rmAddObjectDefConstraint(myKingsHillID, myKingsHillAvoidAll);
      rmAddObjectDefConstraint(myKingsHillID, myKingsHillAvoidTradeRouteSocket);
      rmAddObjectDefConstraint(myKingsHillID, myKingsHillAvoidTradeRoute);
      rmAddObjectDefConstraint(myKingsHillID, avoidWater10);
	if (cNumberNonGaiaPlayers == 2)
         rmAddObjectDefConstraint(myKingsHillID, farPlayerConstraint);
	else
         rmAddObjectDefConstraint(myKingsHillID, fartherPlayerConstraint);
      // Place on big island
      rmPlaceObjectDefInArea(myKingsHillID, 0, rmAreaID("big island"), 1);
   }

// Player Nuggets
   int playerNuggetID=rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
   rmSetObjectDefMinDistance(playerNuggetID, 35.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 55.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
   rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
   rmAddObjectDefConstraint(playerNuggetID, avoidNativesShort);
   rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
   rmAddObjectDefConstraint(playerNuggetID, avoidWater10);

   for(i=1; <cNumberPlayers)
   {
 	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
 	rmSetNuggetDifficulty(2, 2);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
 	rmSetNuggetDifficulty(3, 3);
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	rmPlaceGroupingAtLoc(villageAID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }

// Random Nuggets
   int nuggetID= rmCreateObjectDef("nugget"); 
   rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
   rmAddObjectDefToClass(nuggetID, rmClassID("nuggets"));
   rmAddObjectDefToClass(nuggetID, rmClassID("importantItem"));
   rmSetObjectDefMinDistance(nuggetID, 0.0);
   rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.1));
   rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nuggetID, avoidNugget);
   rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
   rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
   rmAddObjectDefConstraint(nuggetID, avoidSocket);
   rmAddObjectDefConstraint(nuggetID, avoidAll);
   rmAddObjectDefConstraint(nuggetID, farPlayerConstraint);
   rmAddObjectDefConstraint(nuggetID, circleConstraint);
   rmAddObjectDefConstraint(nuggetID, avoidWater10);

// Start area trees 
   int StartAreaTreeID=rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(StartAreaTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(StartAreaTreeID, 8);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 12);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidAll);
   rmPlaceObjectDefPerPlayer(StartAreaTreeID, false, 4);

// Mines
   int silverType = -1;
   silverType = rmRandInt(1,10);
   int playerGoldID=rmCreateObjectDef("player silver closer");
   rmAddObjectDefItem(playerGoldID, mineType, 1, 0.0);
   rmAddObjectDefToClass(playerGoldID, rmClassID("all mines"));
   rmAddObjectDefToClass(playerGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(playerGoldID, avoidSocket);
   rmAddObjectDefConstraint(playerGoldID, coinAvoidCoin);
   rmAddObjectDefConstraint(playerGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(playerGoldID, avoidAll);
   rmAddObjectDefConstraint(playerGoldID, avoidWater10);
   rmSetObjectDefMinDistance(playerGoldID, 12.0);
   rmSetObjectDefMaxDistance(playerGoldID, 23.0);
   rmPlaceObjectDefPerPlayer(playerGoldID, false, 1);

   silverType = rmRandInt(1,10);
   int GoldMediumID=rmCreateObjectDef("player silver med");
   rmAddObjectDefItem(GoldMediumID, mineType, 1, 0.0);
   rmAddObjectDefToClass(GoldMediumID, rmClassID("all mines"));
   rmAddObjectDefToClass(GoldMediumID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(GoldMediumID, avoidTradeRoute);
   rmAddObjectDefConstraint(GoldMediumID, avoidSocket);
   rmAddObjectDefConstraint(GoldMediumID, coinAvoidCoin);
   rmAddObjectDefConstraint(GoldMediumID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(GoldMediumID, avoidAll);
   rmAddObjectDefConstraint(GoldMediumID, avoidWater10);
   rmSetObjectDefMinDistance(GoldMediumID, 36.0);
   rmSetObjectDefMaxDistance(GoldMediumID, 60.0);
   rmPlaceObjectDefPerPlayer(GoldMediumID, false, 1);

   silverType = rmRandInt(1,10);
   int extraGoldID = rmCreateObjectDef("possible gold mines");
   if (rmRandInt(1,2) == 1)
      rmAddObjectDefItem(extraGoldID, "minegold", 1, 0.0);
   else
      rmAddObjectDefItem(extraGoldID, mineType, 1, 0.0);
   rmAddObjectDefToClass(extraGoldID, rmClassID("all mines"));
   rmAddObjectDefToClass(extraGoldID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraGoldID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraGoldID, avoidSocket);
   rmAddObjectDefConstraint(extraGoldID, longAvoidCoin);
   rmAddObjectDefConstraint(extraGoldID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraGoldID, avoidWater15);
   rmAddObjectDefConstraint(extraGoldID, avoidAll);
   rmSetObjectDefMinDistance(extraGoldID, 10.0);
   rmSetObjectDefMaxDistance(extraGoldID, 75.0);

   silverType = rmRandInt(1,10);
   int extraSilverID = rmCreateObjectDef("extra silver mines");
   rmAddObjectDefItem(extraSilverID, mineType, 1, 0.0);
   rmAddObjectDefToClass(extraSilverID, rmClassID("all mines"));
   rmAddObjectDefToClass(extraSilverID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(extraSilverID, avoidTradeRoute);
   rmAddObjectDefConstraint(extraSilverID, avoidSocket);
   rmAddObjectDefConstraint(extraSilverID, longAvoidCoin);
   rmAddObjectDefConstraint(extraSilverID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(extraSilverID, avoidWater10);
   rmAddObjectDefConstraint(extraSilverID, avoidAll);
   rmSetObjectDefMinDistance(extraSilverID, 10.0);
   rmSetObjectDefMaxDistance(extraSilverID, 75.0);

// Berries
   int berryNum = rmRandInt(2,5);
   int StartBerryBushID=rmCreateObjectDef("starting berry bush");
   rmAddObjectDefItem(StartBerryBushID, "BerryBush", rmRandInt(2,4), 4.0);
   rmSetObjectDefMinDistance(StartBerryBushID, 10.0);
   rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
   rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartBerryBushID, avoidAll);
   if (placeBerries == 1)
      rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);
   if (tropical == 1)
   {
      rmPlaceObjectDefPerPlayer(StartBerryBushID, false, 1);
      rmPlaceObjectDefInArea(StartBerryBushID, 0, rmAreaID("big island"), rmRandInt(1,3));
   }

// Start area huntable
   int deerNum = rmRandInt(4, 6);
   int startPronghornID=rmCreateObjectDef("starting pronghorn");
   rmAddObjectDefItem(startPronghornID, deerType, deerNum, 4.0);
   rmAddObjectDefToClass(startPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(startPronghornID, 16);
   rmSetObjectDefMaxDistance(startPronghornID, 22);
   rmAddObjectDefConstraint(startPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(startPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(startPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(startPronghornID, true);
   rmPlaceObjectDefPerPlayer(startPronghornID, false, 1);

// Extra tree clumps near players - to ensure fair access to wood
   int extraTreesID=rmCreateObjectDef("extra trees");
   rmAddObjectDefItem(extraTreesID, treeType, 7, 7.0);
   rmSetObjectDefMinDistance(extraTreesID, 16);
   rmSetObjectDefMaxDistance(extraTreesID, 20);
   rmAddObjectDefConstraint(extraTreesID, avoidAll);
   rmAddObjectDefConstraint(extraTreesID, avoidImportantItem);
   rmAddObjectDefConstraint(extraTreesID, avoidCoin);
   rmAddObjectDefConstraint(extraTreesID, avoidSocket);
   rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
   rmPlaceObjectDefPerPlayer(extraTreesID, false, 1);

// Second huntable
   int deer2Num = rmRandInt(4, 7);
   int farPronghornID=rmCreateObjectDef("far pronghorn");
   rmAddObjectDefItem(farPronghornID, deer2Type, deer2Num, 4.0);
   rmAddObjectDefToClass(farPronghornID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(farPronghornID, 42.0);
   rmSetObjectDefMaxDistance(farPronghornID, 65.0);
   rmAddObjectDefConstraint(farPronghornID, avoidStartResource);
   rmAddObjectDefConstraint(farPronghornID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farPronghornID, avoidNativesShort);
   rmAddObjectDefConstraint(farPronghornID, huntableConstraint);
   rmAddObjectDefConstraint(farPronghornID, avoidAll);
   rmSetObjectDefCreateHerd(farPronghornID, true);
   rmPlaceObjectDefPerPlayer(farPronghornID, false, 1);

// Sheep etc
   int sheepID=rmCreateObjectDef("herdable animal");
   rmAddObjectDefItem(sheepID, sheepType, 2, 4.0);
   rmAddObjectDefToClass(sheepID, rmClassID("herdableFood"));
   rmSetObjectDefMinDistance(sheepID, 35.0);
   rmSetObjectDefMaxDistance(sheepID, 70.0);
   rmAddObjectDefConstraint(sheepID, avoidSheep);
   rmAddObjectDefConstraint(sheepID, avoidAll);
   rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
   if (sheepChance > 0)
   {
      for(i=1; <cNumberPlayers)
	{
         rmPlaceObjectDefInArea(sheepID, 0, rmAreaID("player"+i), rmRandInt(2,3));
	}
   }

// Big island huntable
   deer2Num = rmRandInt(4, 7);
   int huntableID=rmCreateObjectDef("huntable 1");
   rmAddObjectDefItem(huntableID, centerHerdType, deer2Num, 5.0);
   rmAddObjectDefToClass(huntableID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(huntableID, 42.0);
   rmSetObjectDefMaxDistance(huntableID, 65.0);
   rmAddObjectDefConstraint(huntableID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(huntableID, avoidNativesShort);
   rmAddObjectDefConstraint(huntableID, huntableConstraint);
   rmAddObjectDefConstraint(huntableID, avoidAll);
   rmSetObjectDefCreateHerd(huntableID, true);

// More island animals
   int centralHerdID=rmCreateObjectDef("central herd");  
   rmAddObjectDefItem(centralHerdID, centerHerdType, rmRandInt(2,3), 4.0);
   rmAddObjectDefToClass(centralHerdID, rmClassID("huntableFood"));
   rmSetObjectDefMinDistance(centralHerdID, 0);
   rmSetObjectDefMaxDistance(centralHerdID, rmXFractionToMeters(0.1));
   rmAddObjectDefConstraint(centralHerdID, avoidTradeRoute);
   rmAddObjectDefConstraint(centralHerdID, avoidImportantItem);
   rmAddObjectDefConstraint(centralHerdID, avoidWater10);
   rmAddObjectDefConstraint(centralHerdID, longPlayerConstraint);
   rmAddObjectDefConstraint(centralHerdID, huntableConstraint);

// Big island objects placement
   rmSetGroupingMinDistance(villageAID, 0.0);
   rmSetGroupingMaxDistance(villageAID, rmXFractionToMeters(0.05));
   if (cNumberNonGaiaPlayers > 4)
   {
	if (rmRandInt(1,2) == 1)
         rmPlaceGroupingInArea(villageDID, 0, rmAreaID("big island"), 1);
	else
         rmPlaceGroupingInArea(villageAID, 0, rmAreaID("big island"), 1);
	if (rmRandInt(1,2) == 1)
         rmPlaceGroupingInArea(villageDID, 0, rmAreaID("big island"), 1);
	else
         rmPlaceGroupingInArea(villageAID, 0, rmAreaID("big island"), 1);
   }
   else if (cNumberNonGaiaPlayers > 2)
   {
	if (rmRandInt(1,2) == 1)
         rmPlaceGroupingInArea(villageDID, 0, rmAreaID("big island"), 1);
	else
         rmPlaceGroupingInArea(villageAID, 0, rmAreaID("big island"), 1);
   }
   else if (cNumberNonGaiaPlayers == 2)
   {
	if (rmRandInt(1,3) < 3)
	{
	   if (rmRandInt(1,2) == 1)
            rmPlaceGroupingInArea(villageDID, 0, rmAreaID("big island"), 1);
	   else
            rmPlaceGroupingInArea(villageAID, 0, rmAreaID("big island"), 1);
	}
   }
   rmPlaceObjectDefInArea(extraGoldID, 0, rmAreaID("big island"), 1);
   rmPlaceObjectDefInArea(huntableID, 0, rmAreaID("big island"), 2);
   rmSetNuggetDifficulty(3, 3);
   rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("big island"), 1);
   if (cNumberNonGaiaPlayers > 3)
      rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("big island"), 1);
   rmSetNuggetDifficulty(4, 4);
   rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("big island"), 1);
   rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("big island"), 1);
   if (cNumberNonGaiaPlayers > 4)
      rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("big island"), 1);
   if (cNumberNonGaiaPlayers > 4)
      rmPlaceObjectDefInArea(extraGoldID, 0, rmAreaID("big island"), 1);
   if (sheepChance > 0)
   {
      rmPlaceObjectDefInArea(sheepID, 0, rmAreaID("big island"), rmRandInt(2,3));
   }

// Text
   rmSetStatusText("",0.40);

// Native Islands 
   int chanceSetup = 0;
   int constraintChance4 = 0;
   if (cNumberNonGaiaPlayers > 4)
      extraNativeIs = 1;
   else if (cNumberNonGaiaPlayers > 2)
   {
	if (rmRandInt(1,3) > 1)
	   extraNativeIs = 1;
   }
   else
   {
	if (rmRandInt(1,2) == 1)
	   extraNativeIs = 1;
   }

   int nativeIsland1ID=rmCreateArea("native island 1");
   rmSetAreaSize(nativeIsland1ID, rmAreaTilesToFraction(2500 + cNumberNonGaiaPlayers*200), rmAreaTilesToFraction(3000 + cNumberNonGaiaPlayers*280));
   rmSetAreaMix(nativeIsland1ID, baseType);
   rmAddAreaConstraint(nativeIsland1ID, centerIslandConstraint);
   rmAddAreaConstraint(nativeIsland1ID, circleEdgeConstraint);
   rmAddAreaConstraint(nativeIsland1ID, playerConstraint);
   if  (centeredBigIsland == 1) 
      rmAddAreaConstraint(nativeIsland1ID, nativeIslandConstraintLarge);
   else
      rmAddAreaConstraint(nativeIsland1ID, nativeIslandConstraint);
   rmAddAreaToClass(nativeIsland1ID, classSettlementIsland);
   rmAddAreaToClass(nativeIsland1ID, classNativeIsland);
   rmAddAreaToClass(nativeIsland1ID, classGoldIsland);
   rmSetAreaCoherence(nativeIsland1ID, 0.35);
   rmSetAreaSmoothDistance(nativeIsland1ID, 12);
   rmSetAreaHeightBlend(nativeIsland1ID, 2);
   rmSetAreaBaseHeight(nativeIsland1ID, baseHeight);
   rmBuildArea(nativeIsland1ID);

   int nativeIsland2ID=rmCreateArea("native island 2");
   rmSetAreaSize(nativeIsland2ID, rmAreaTilesToFraction(2500 + cNumberNonGaiaPlayers*180), rmAreaTilesToFraction(3000 + cNumberNonGaiaPlayers*250));
   rmSetAreaMix(nativeIsland2ID, baseType);
   rmAddAreaConstraint(nativeIsland2ID, settlementIslandConstraint);
   rmAddAreaConstraint(nativeIsland2ID, centerIslandConstraint);
   rmAddAreaConstraint(nativeIsland2ID, playerConstraint);
   if  (centeredBigIsland == 1) 
      rmAddAreaConstraint(nativeIsland2ID, nativeIslandConstraintLarge);
   else
      rmAddAreaConstraint(nativeIsland2ID, nativeIslandConstraint);
   rmAddAreaConstraint(nativeIsland2ID, circleEdgeConstraint);
   rmAddAreaToClass(nativeIsland2ID, classSettlementIsland);
   rmAddAreaToClass(nativeIsland2ID, classNativeIsland);
   rmAddAreaToClass(nativeIsland2ID, classGoldIsland);
   rmSetAreaCoherence(nativeIsland2ID, 0.4);
   rmSetAreaSmoothDistance(nativeIsland2ID, 12);
   rmSetAreaHeightBlend(nativeIsland2ID, 2);
   rmSetAreaBaseHeight(nativeIsland2ID, baseHeight);
   rmBuildArea(nativeIsland2ID);

if (extraNativeIs == 1)
{
   int nativeIsland3ID=rmCreateArea("native island 3");
   rmSetAreaSize(nativeIsland3ID, rmAreaTilesToFraction(2200 + cNumberNonGaiaPlayers*180), rmAreaTilesToFraction(2800 + cNumberNonGaiaPlayers*250));
   rmSetAreaMix(nativeIsland3ID, baseType);
   rmAddAreaConstraint(nativeIsland3ID, settlementIslandConstraint);
   rmAddAreaConstraint(nativeIsland3ID, centerIslandConstraint);
   rmAddAreaConstraint(nativeIsland3ID, playerConstraint);
   rmAddAreaConstraint(nativeIsland3ID, nativeIslandConstraint); 
   rmAddAreaConstraint(nativeIsland3ID, circleEdgeConstraint);
   rmAddAreaToClass(nativeIsland3ID, classSettlementIsland);
   rmAddAreaToClass(nativeIsland3ID, classNativeIsland);
   rmAddAreaToClass(nativeIsland3ID, classGoldIsland);
   rmSetAreaCoherence(nativeIsland3ID, 0.4);
   rmSetAreaSmoothDistance(nativeIsland3ID, 12);
   rmSetAreaHeightBlend(nativeIsland3ID, 2);
   rmSetAreaBaseHeight(nativeIsland3ID, baseHeight);
   rmBuildArea(nativeIsland3ID);
}

// Native Island Objects placement
   rmPlaceGroupingInArea(villageDID, 0, rmAreaID("native island 1"), 1);
   rmPlaceGroupingInArea(villageDID, 0, rmAreaID("native island 2"), 1);
   rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("native island 1"), 1);
   rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("native island 2"), 1);
   if (sheepChance > 0)
   {
	if (rmRandInt(1,2) == 1)
         rmPlaceObjectDefInArea(sheepID, 0, rmAreaID("native island 1"), 1);
	if (rmRandInt(1,2) == 1)
         rmPlaceObjectDefInArea(sheepID, 0, rmAreaID("native island 2"), 1);
   }
   if (extraNativeIs == 1)
   {
	if (rmRandInt(1,2) == 1)
         rmPlaceGroupingInArea(villageDID, 0, rmAreaID("native island 3"), 1);
	else
         rmPlaceGroupingInArea(villageAID, 0, rmAreaID("native island 3"), 1);
      rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("native island 3"), 1);
      if (sheepChance > 0)
      {
	   if (rmRandInt(1,3) > 1)
            rmPlaceObjectDefInArea(sheepID, 0, rmAreaID("native island 3"), 1);
	}
   }

// Text
   rmSetStatusText("",0.45);
     
// More Islands/land - may merge with big island or each other
   int numIslands = cNumberNonGaiaPlayers - 1;
   if (cNumberNonGaiaPlayers > 4)
      numIslands = cNumberNonGaiaPlayers - 2;
   if (cNumberNonGaiaPlayers > 7)
      numIslands = cNumberNonGaiaPlayers - 3;

   for(i=0; <numIslands)
   {
      int settlementIslandID=rmCreateArea("settlement island"+i);
      rmSetAreaSize(settlementIslandID, rmAreaTilesToFraction(2500 + cNumberNonGaiaPlayers*150), rmAreaTilesToFraction(3000 + cNumberNonGaiaPlayers*200));
      rmSetAreaMix(settlementIslandID, baseType);
      rmSetAreaWarnFailure(settlementIslandID, false);

      constraintChance4 = rmRandFloat(0.0,1.0);
	if (cNumberNonGaiaPlayers < 5)
	{
         if (constraintChance4 > 0.5)
            rmAddAreaConstraint(settlementIslandID, settlementIslandConstraint);
	}
	else 	if (cNumberNonGaiaPlayers < 7)
	{
         if (constraintChance4 > 0.5)
            rmAddAreaConstraint(settlementIslandID, settlementIslandConstraint); 
	}
	else 	
	{
         if (constraintChance4 > 0.3)
            rmAddAreaConstraint(settlementIslandID, settlementIslandConstraint); 
	}

      chanceSetup = rmRandFloat(0.0,1.0);
	if (cNumberNonGaiaPlayers < 5)
	{
         if (chanceSetup < 0.4)
            rmAddAreaConstraint(settlementIslandID, centerIslandConstraint);
	}
	else if (cNumberNonGaiaPlayers < 7)
	{
         if (chanceSetup < 0.6)
            rmAddAreaConstraint(settlementIslandID, centerIslandConstraint);
	}
	else 
	{	
         if (chanceSetup < 0.7)
            rmAddAreaConstraint(settlementIslandID, centerIslandConstraint);
	}

      rmAddAreaConstraint(settlementIslandID, playerConstraint); 
      rmAddAreaConstraint(settlementIslandID, circleEdgeConstraint);
	if (rmRandInt(1,3) > 1)
         rmAddAreaConstraint(settlementIslandID, nativeIslandConstraint);
      rmAddAreaToClass(settlementIslandID, classSettlementIsland);
      rmAddAreaToClass(settlementIslandID, classGoldIsland);
      rmSetAreaCoherence(settlementIslandID, 0.35);
      rmSetAreaSmoothDistance(settlementIslandID, 12);
      rmSetAreaHeightBlend(settlementIslandID, 2);
      rmSetAreaBaseHeight(settlementIslandID, baseHeight);
      rmBuildArea(settlementIslandID);
	
   // Settlement Island Objects placement
	if (cNumberNonGaiaPlayers > 5)
	{
         if (chanceSetup < 0.7)
            rmPlaceGroupingInArea(villageDID, 0, rmAreaID("settlement island"+i), 1);
	   else
	   {
            if (rmRandInt(1,4) == 1)
               rmPlaceGroupingInArea(villageDID, 0, rmAreaID("settlement island"+i), 1);
	   }
	}
      rmSetNuggetDifficulty(3, 3);
      rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("settlement island"+i), 1);
      if (rmRandInt(1,4) > 1)
         rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("settlement island"+i), 1);
      if (sheepChance > 0)
      {
	   if (rmRandInt(1,3) == 1)
            rmPlaceObjectDefInArea(sheepID, 0, rmAreaID("settlement island"+i), 1);
	}
   }

// Text
   rmSetStatusText("",0.50);

// Bonus Resource Islands - can merge with other extra islands.
   int bonusCount=cNumberNonGaiaPlayers + 2;  // num players plus some extra
   if (cNumberNonGaiaPlayers > 5)
      bonusCount=cNumberNonGaiaPlayers + 1;
  
   for(i=0; <bonusCount)
   {
      int bonusIslandID=rmCreateArea("bonus island"+i);
      rmSetAreaSize(bonusIslandID, rmAreaTilesToFraction(1800 + cNumberNonGaiaPlayers*150), rmAreaTilesToFraction(2000 + cNumberNonGaiaPlayers*200));
      rmSetAreaMix(bonusIslandID, baseType);
      rmSetAreaWarnFailure(bonusIslandID, false);
      rmAddAreaConstraint(bonusIslandID, circleEdgeConstraint);
      if (rmRandInt(1,3) == 1)
        rmAddAreaConstraint(bonusIslandID, settlementIslandConstraint); 
	if (cNumberNonGaiaPlayers > 5)
	{
         if (rmRandInt(1,10) > 4)
            rmAddAreaConstraint(bonusIslandID, centerIslandConstraint);
	}
	else
	{
         if (rmRandInt(1,2) > 1)
            rmAddAreaConstraint(bonusIslandID, centerIslandConstraint);
	}
      if (rmRandInt(1,2) == 1)
         rmAddAreaConstraint(bonusIslandID, nativeIslandConstraint);
      rmAddAreaConstraint(bonusIslandID, secondPlayerConstraint); 
      rmAddAreaToClass(bonusIslandID, classBonusIsland);
      rmAddAreaToClass(bonusIslandID, classGoldIsland);
      rmSetAreaCoherence(bonusIslandID, 0.55);
      rmSetAreaSmoothDistance(bonusIslandID, 20);
      rmSetAreaHeightBlend(bonusIslandID, 2);
      rmSetAreaBaseHeight(bonusIslandID, baseHeight);

      // Island avoidance determination
      randomIslandChance=rmRandFloat(0.0, 1.0);
      if(randomIslandChance < 0.33)
      {
         rmAddAreaToClass(bonusIslandID, islandsX);
         rmAddAreaConstraint(bonusIslandID, islandsXvsY);
         rmAddAreaConstraint(bonusIslandID, islandsXYvsZ);
      }
      else if(randomIslandChance < 0.66)        
      {
         rmAddAreaToClass(bonusIslandID, islandsY);
         rmAddAreaConstraint(bonusIslandID, islandsYvsX);
         rmAddAreaConstraint(bonusIslandID, islandsXYvsZ);
      }
      else
      {
         rmAddAreaToClass(bonusIslandID, islandsZ);
         rmAddAreaConstraint(bonusIslandID, islandsZvsX);
         rmAddAreaConstraint(bonusIslandID, islandsZvsY); 
      }
      rmBuildArea(bonusIslandID);

	// Bonus Island Objects
      rmPlaceObjectDefInArea(centralHerdID, 0, rmAreaID("bonus island"+i), 1);
      if (rmRandInt(1,3) == 1)
	{
         rmSetNuggetDifficulty(2, 3);
         rmPlaceObjectDefInArea(nuggetID, 0, rmAreaID("bonus island"+i), 1);
	}
   }

// Text
   rmSetStatusText("",0.55);

// Caches and bonus objects  
   // Campfire cache
   int campfireID=rmCreateObjectDef("campfire cache");
   if (rmRandInt(1,2) == 1)
   {
      rmAddObjectDefItem(campfireID, "Campfire", 1, 0.0);
      rmAddObjectDefItem(campfireID, "TanningRack", 1, 4.0);
   }
   else
   {
      if (rmRandInt(1,2) == 1)
	   rmAddObjectDefItem(campfireID, "SPCSignalFire", 1, 0.0);
	else
	   rmAddObjectDefItem(campfireID, "SPCSignalFireLit", 1, 0.0);
   }
   if (rmRandInt(1,2) == 1)
      rmAddObjectDefItem(campfireID, "CrateOfWood", rmRandInt(2,3), 4.0);
   else
	rmAddObjectDefItem(campfireID, "CrateOfWoodLarge", 1, 4.0);
   rmAddObjectDefToClass(campfireID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(campfireID, avoidTradeRoute);
   rmAddObjectDefConstraint(campfireID, avoidImportantItemMed);
   rmAddObjectDefConstraint(campfireID, avoidWater10);
   rmAddObjectDefConstraint(campfireID, fartherPlayerConstraint);
   if (rmRandInt(1,5) < 5)
	campfireCache = 1;

   // House cache  ====================================================================================================
   int cacheContents = rmRandInt(1,5);
   int houseCacheID=rmCreateObjectDef("house cache");
   if (cacheType == 1) // northern
   {
      rmAddObjectDefItem(houseCacheID, "NativeHouseIroquois", 1, 0.0);
      rmAddObjectDefItem(houseCacheID, "Campfire", 1, 4.0);
   }
   else if (cacheType == 2) // plains
   {
	rmAddObjectDefItem(houseCacheID, "Teepee", 1, 6.0);
      rmAddObjectDefItem(houseCacheID, "Campfire", 1, 5.0);
   }
   else if (cacheType == 3) // southern
   {
	rmAddObjectDefItem(houseCacheID, "NativeHouseCarib", 2, 6.0);
	if (rmRandInt(1,2) == 1)
	   rmAddObjectDefItem(houseCacheID, "Skulls", rmRandInt(1,2), 5.0);
   }	
   else if (cacheType == 4) // leanto
   {
      rmAddObjectDefItem(houseCacheID, "LeanTo", 2, 6.0);
	if (rmRandInt(1,2) == 1)
	   rmAddObjectDefItem(houseCacheID, "Skulls", rmRandInt(1,2), 5.0);
   }
   else if (cacheType == 5) // meso
	rmAddObjectDefItem(houseCacheID, "NativeHouseAztec", 1, 4.0);
   else if (cacheType == 6) // southern Asian - India/Ceylon/Himalaya/Borneo
   {
	if (patternChance == 32) // Himalaya
	   threeChoice = rmRandInt(1,2);
	else
	   threeChoice = rmRandInt(1,3);
	if (threeChoice == 1)
	   rmAddObjectDefItem(houseCacheID, "ypNativeTempleBhakti", rmRandInt(1,2), 6.0);
	else if (threeChoice == 2)
	   rmAddObjectDefItem(houseCacheID, "ypNativeTempleUdasi", rmRandInt(1,2), 6.0);
	else if (threeChoice == 3)
	{
         rmAddObjectDefItem(houseCacheID, "LeanTo", 2, 6.0);
         rmAddObjectDefItem(houseCacheID, "Campfire", 1, 3.0);
	}
   }
   else if (cacheType == 7) // northern Asian 
   {
      rmAddObjectDefItem(houseCacheID, "ypMonastery", 1, 2.0);
	if (patternChance == 30) 
	   rmAddObjectDefItem(houseCacheID, "ypPropsJapaneseBanner", 2, 5.0);
   }
   if (cacheType < 5)
   {
	if (threeChoice > 1)
	   rmAddObjectDefItem(houseCacheID, "TanningRack", 1, 4.0);
   }
   if (cacheContents == 1) 	    
      rmAddObjectDefItem(houseCacheID, "CrateOfFood", 2, 5.0);
   else if (cacheContents == 2) 	    
	rmAddObjectDefItem(houseCacheID, "CrateOfFoodLarge", 1, 4.0);
   else if (cacheContents == 3) 	    
      rmAddObjectDefItem(houseCacheID, "CrateOfCoin", 2, 5.0);
   else if (cacheContents == 4) 	    
	rmAddObjectDefItem(houseCacheID, "CrateOfCoinLarge", 1, 4.0);
   else if (cacheContents == 5)
   { 	    
      rmAddObjectDefItem(houseCacheID, "CrateOfFood", 1, 5.0);
      rmAddObjectDefItem(houseCacheID, "CrateOfCoin", 1, 6.0);
   }
   rmAddObjectDefToClass(houseCacheID, rmClassID("importantItem"));
   rmAddObjectDefConstraint(houseCacheID, avoidTradeRoute);
   rmAddObjectDefConstraint(houseCacheID, avoidImportantItemMed);
   rmAddObjectDefConstraint(houseCacheID, avoidWater10);
   rmAddObjectDefConstraint(houseCacheID, fartherPlayerConstraint);
   rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classCenterIsland, rmRandInt(1,2)); 
   rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classGoldIsland, 1);
   if (cNumberNonGaiaPlayers > 2)
      rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classSettlementIsland, 1);
   if (cNumberNonGaiaPlayers > 3)
      rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classSettlementIsland, 1);
   if (cNumberNonGaiaPlayers > 4)
      rmPlaceObjectDefInRandomAreaOfClass(houseCacheID, 0, classGoldIsland, 1);

   // Shrine cache
   if ((patternChance == 30) || (patternChance == 32) || (patternChance == 34) || (patternChance == 36))
   {
      cacheContents = rmRandInt(1,2);
      int shrineCacheID=rmCreateObjectDef("shrine cache");
      rmAddObjectDefItem(shrineCacheID, "ypShrineJapanese", 1, 0.0);
      if (cacheContents == 1) 	    
         rmAddObjectDefItem(shrineCacheID, "CrateOfFood", rmRandInt(2,3), 4.0);
      else if (cacheContents == 2) 	      
         rmAddObjectDefItem(shrineCacheID, "CrateOfCoin", rmRandInt(2,3), 4.0);
      rmAddObjectDefItem(shrineCacheID, deer2Type, 4, 5.0);
      rmAddObjectDefToClass(shrineCacheID, rmClassID("importantItem"));
      rmAddObjectDefConstraint(shrineCacheID, avoidTradeRoute);
      rmAddObjectDefConstraint(shrineCacheID, avoidImportantItemMed);
      rmAddObjectDefConstraint(shrineCacheID, avoidWater10);
      rmAddObjectDefConstraint(shrineCacheID, fartherPlayerConstraint);
      rmPlaceObjectDefInRandomAreaOfClass(shrineCacheID, 0, classGoldIsland, 1); 
      if (cNumberNonGaiaPlayers > 2)  
         rmPlaceObjectDefInRandomAreaOfClass(shrineCacheID, 0, classGoldIsland, 1);  
      if (cNumberNonGaiaPlayers > 4)  
         rmPlaceObjectDefInRandomAreaOfClass(shrineCacheID, 0, classGoldIsland, 1);      
      if (rmRandInt(1,2)==1)  
         rmPlaceObjectDefInRandomAreaOfClass(shrineCacheID, 0, classGoldIsland, 1); 
   }

   // Mural cache
   if ((patternChance == 13) || (patternChance == 14) || (patternChance == 15) || (patternChance == 28)) // yucatan, sonora, palm desert, caribbean 
   {
      int muralCacheID=rmCreateObjectDef("mural cache");
      rmAddObjectDefItem(muralCacheID, "SPCAztecMural", 1, 0.0);
      rmAddObjectDefItem(muralCacheID, "CrateOfCoin", 1, 4.0);
      rmAddObjectDefToClass(muralCacheID, rmClassID("importantItem"));
      rmAddObjectDefConstraint(muralCacheID, avoidTradeRoute);
      rmAddObjectDefConstraint(muralCacheID, avoidImportantItemMed);
      rmAddObjectDefConstraint(muralCacheID, avoidWater10);
      rmAddObjectDefConstraint(muralCacheID, fartherPlayerConstraint);
      rmPlaceObjectDefInRandomAreaOfClass(muralCacheID, 0, classGoldIsland, 1); 
   }

   // Arctic cache
   if (arctic == 1)
   {
      int arcticCacheID=rmCreateObjectDef("arctic cache");
      rmAddObjectDefItem(arcticCacheID, "Inuksuk", 1, 0.0);
      rmAddObjectDefItem(arcticCacheID, "CrateOfCoin", rmRandInt(2,3), 6.0);
      rmAddObjectDefToClass(arcticCacheID, rmClassID("importantItem"));
      rmAddObjectDefConstraint(arcticCacheID, avoidTradeRoute);
      rmAddObjectDefConstraint(arcticCacheID, avoidImportantItemMed);
      rmAddObjectDefConstraint(arcticCacheID, avoidWater10);
      rmAddObjectDefConstraint(arcticCacheID, fartherPlayerConstraint);
      rmPlaceObjectDefInRandomAreaOfClass(arcticCacheID, 0, classCenterIsland, 1);
      rmPlaceObjectDefInRandomAreaOfClass(arcticCacheID, 0, classGoldIsland, 1);
   }

   // Inca outpost cache
   if ((patternChance == 16) || (patternChance == 22) || (patternChance == 23) || (patternChance == 24) || (patternChance == 29))  // amazon, andes, atacama, central and north araucania 
   {
      int incaCacheID=rmCreateObjectDef("inca cache");
      rmAddObjectDefItem(incaCacheID, "SPCIncaOutpost", 1, 0.0);
      rmAddObjectDefItem(incaCacheID, "CrateOfCoin", rmRandInt(2,3), 4.0);
      rmAddObjectDefToClass(incaCacheID, rmClassID("importantItem"));
      rmAddObjectDefConstraint(incaCacheID, avoidTradeRoute);
      rmAddObjectDefConstraint(incaCacheID, avoidImportantItemMed);
      rmAddObjectDefConstraint(incaCacheID, avoidWater10);
      rmAddObjectDefConstraint(incaCacheID, fartherPlayerConstraint);
      rmPlaceObjectDefInRandomAreaOfClass(incaCacheID, 0, classCenterIsland, 1);
      rmPlaceObjectDefInRandomAreaOfClass(incaCacheID, 0, classSettlementIsland, 1);
      if (cNumberNonGaiaPlayers > 4)
      {
         rmPlaceObjectDefInRandomAreaOfClass(incaCacheID, 0, classSettlementIsland, 1);
	}	
   }

   if (berryCache == 1) // Berry patches
   {
         int berryPatchType = rmRandInt(1,4);
         int berryPatch = 0;
         berryPatch = rmCreateGrouping("Berry patch", "BerryPatch "+berryPatchType);
         rmSetGroupingMinDistance(berryPatch, 0.0);
         rmSetGroupingMaxDistance(berryPatch, 12.0);
         rmAddGroupingToClass(berryPatch, rmClassID("importantItem"));
         rmAddGroupingConstraint(berryPatch, avoidAll);
         rmAddGroupingConstraint(berryPatch, avoidWater10);
         rmAddGroupingConstraint(berryPatch, avoidImportantItemMed);
	   if ((patternChance == 30) || (patternChance == 31) || (patternChance == 35) || (patternChance == 36))
	   {
	      rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("big island"), 1);
            for(i=0; <numIslands)
            {
	         if (rmRandInt(1,3) == 1)  
	            rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("settlement island"+i), 1);
		}
	   }
	   else
   	   {
	      rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("big island"), 1);
	      if (rmRandInt(1,3) == 1)
	         rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("big island"), 1);
	      if (rmRandInt(1,2) == 1)
	         rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("native island 2"), 1);
	      if (rmRandInt(1,2) == 1)
	         rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("native island 1"), 1);
            for(i=0; <numIslands)
            {
	         if (rmRandInt(1,2) == 1)  
	            rmPlaceGroupingInArea(berryPatch, 0, rmAreaID("settlement island"+i), 1);
	      }
	   }
   }
   if (llamaCache == 1) // Herdable pen
   {        
         int herdablePenType = rmRandInt(1,4);
         int herdablePen = 0;
         herdablePen = rmCreateGrouping("Herdable Pen", "Araucania_HerdablePen "+herdablePenType);
         rmSetGroupingMinDistance(herdablePen, 0.0);
         rmSetGroupingMaxDistance(herdablePen, 20.0);
         rmAddGroupingToClass(herdablePen, rmClassID("importantItem"));
         rmAddGroupingConstraint(herdablePen, avoidImportantItemMed);
         rmAddGroupingConstraint(herdablePen, avoidAll);
         rmAddGroupingConstraint(herdablePen, avoidWater10);
	   rmPlaceGroupingInArea(herdablePen, 0, rmAreaID("big island"), 1);
	   if (rmRandInt(1,3) == 1)
	      rmPlaceGroupingInArea(herdablePen, 0, rmAreaID("big island"), 1);
	   if (rmRandInt(1,2) == 1)
	      rmPlaceGroupingInArea(herdablePen, 0, rmAreaID("native island 2"), 1);
	   if (rmRandInt(1,2) == 1)
	      rmPlaceGroupingInArea(herdablePen, 0, rmAreaID("native island 1"), 1);
         for(i=0; <numIslands)
         {
	      if (rmRandInt(1,2) == 1) 
	         rmPlaceGroupingInArea(herdablePen, 0, rmAreaID("settlement island"+i), 1);
	   }
	   if (berryCache == 1)
	      campfireCache = 0;
   }

   if (campfireCache == 1) 
   {
      rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classCenterIsland, 1);
	rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classSettlementIsland, 1);
      rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classBonusIsland, 1);
	if (rmRandInt(1,2) == 1)
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classBonusIsland, 1);
	if (rmRandInt(1,2) == 1)
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classSettlementIsland, 1);
      if (cNumberNonGaiaPlayers > 4)
      {
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classCenterIsland, 1);
	   rmPlaceObjectDefInRandomAreaOfClass(campfireID, 0, classSettlementIsland, 1);
	}
   }

// Additional Island Mines
   rmPlaceObjectDefInRandomAreaOfClass(extraGoldID, 0, classSettlementIsland, 1);
   if (cNumberNonGaiaPlayers > 3)
      rmPlaceObjectDefInRandomAreaOfClass(extraGoldID, 0, classBonusIsland, 1);
   rmPlaceObjectDefInRandomAreaOfClass(extraGoldID, 0, classGoldIsland, 1);
   rmPlaceObjectDefInRandomAreaOfClass(extraGoldID, 0, classGoldIsland, 1);
   rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classGoldIsland, 1);
   rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classGoldIsland, 1);
   if (cNumberNonGaiaPlayers > 4)
   {
      rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classGoldIsland, 1);
      rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classBonusIsland, 1);
   }
   if (cNumberNonGaiaPlayers > 6)
   {
      rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classGoldIsland, 1);
      rmPlaceObjectDefInRandomAreaOfClass(extraSilverID, 0, classBonusIsland, 1);
   }

// Forests
// Large player forests.
   int failCount = 0;
   for(i=1; <cNumberPlayers)
   {
      failCount=0;
      int forestID=rmCreateArea("player"+i+"forest", rmAreaID("player"+i));
	if (lowForest == 1)
         rmSetAreaSize(forestID, rmAreaTilesToFraction(180), rmAreaTilesToFraction(250));
	else
         rmSetAreaSize(forestID, rmAreaTilesToFraction(250), rmAreaTilesToFraction(290));
      rmSetAreaWarnFailure(forestID, false);
      rmSetAreaForestType(forestID, forestType);
      rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
      rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
      rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
      rmSetAreaCoherence(forestID, rmRandFloat(0.5, 0.8));
      rmAddAreaConstraint(forestID, avoidStartingUnits);
      rmAddAreaConstraint(forestID, avoidNativesShort);
      rmAddAreaConstraint(forestID, avoidWater10);
      rmAddAreaConstraint(forestID, avoidAll);
      rmAddAreaConstraint(forestID, forestConstraint);
      rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
      rmAddAreaToClass(forestID, rmClassID("classForest")); 
      rmSetAreaMinBlobs(forestID, 1);
      rmSetAreaMaxBlobs(forestID, 3);
      rmSetAreaMinBlobDistance(forestID, 10.0);
      rmSetAreaMaxBlobDistance(forestID, 15.0);
      rmSetAreaSmoothDistance(forestID, rmRandInt(10,20));
      rmSetAreaBaseHeight(forestID, rmRandFloat(3.0, 4.0));
      rmSetAreaHeightBlend(forestID, 1);
      if(rmBuildArea(forestID)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==3)
            break;
      }
      else
         failCount=0;

	if (forestCoverUp == 1)
	{
      int coverForestPatchID = rmCreateArea("cover forest patch"+i, rmAreaID("player"+i+"forest"));   
      rmSetAreaWarnFailure(coverForestPatchID, false);
	if (lowForest == 1)
         rmSetAreaSize(coverForestPatchID, rmAreaTilesToFraction(270), rmAreaTilesToFraction(270));
	else
         rmSetAreaSize(coverForestPatchID, rmAreaTilesToFraction(315), rmAreaTilesToFraction(315));
      rmSetAreaCoherence(coverForestPatchID, 0.99);
      rmSetAreaMix(coverForestPatchID, baseType);
      rmBuildArea(coverForestPatchID);
	}
   }

   for(j=0; <2)   
   {
      for(k=1; <cNumberPlayers)
      {
         failCount=0;
         forestID=rmCreateArea(("another player"+k+"forest"+j), rmAreaID("player"+k));
	   if (lowForest == 1)
            rmSetAreaSize(forestID, rmAreaTilesToFraction(170), rmAreaTilesToFraction(200));
	   else
            rmSetAreaSize(forestID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(230));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidStartingUnits);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, forestConstraint);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaMinBlobs(forestID, 1);
         rmSetAreaMaxBlobs(forestID, 3);
         rmSetAreaMinBlobDistance(forestID, 12.0);
         rmSetAreaMaxBlobDistance(forestID, 25.0);
         rmSetAreaSmoothDistance(forestID, rmRandInt(10,20));
         rmSetAreaBaseHeight(forestID, rmRandFloat(3.0, 4.0));
         rmSetAreaHeightBlend(forestID, 1);
         if(rmBuildArea(forestID)==false)
         {
            // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==3)
               break;
         }
         else
            failCount=0;

	   if (forestCoverUp == 1)
	   {
         int coverForestPatch2ID = rmCreateArea(("cover forest patch two"+j+k), rmAreaID("another player"+k+"forest"+j));   
         rmSetAreaWarnFailure(coverForestPatch2ID, false);
	   if (lowForest == 1)
            rmSetAreaSize(coverForestPatch2ID, rmAreaTilesToFraction(220), rmAreaTilesToFraction(220));
	   else
            rmSetAreaSize(coverForestPatch2ID, rmAreaTilesToFraction(245), rmAreaTilesToFraction(245));
         rmSetAreaCoherence(coverForestPatch2ID, 0.99);
         rmSetAreaMix(coverForestPatch2ID, baseType);
         rmBuildArea(coverForestPatch2ID);
   	   }
      }
   }

// Text
   rmSetStatusText("",0.60);

// Smaller player forests
   int forestCount=rmRandInt(7, 8);
   if (lowForest == 1)
      forestCount=rmRandInt(2, 3);
   for(i=1; <cNumberPlayers)
   {
      failCount=0;
      for(j=0; <forestCount)
      {
         forestID=rmCreateArea("player"+i+"small forest"+j, rmAreaID("player"+i));
	   if (lowForest == 1)
            rmSetAreaSize(forestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(160));
	   else
            rmSetAreaSize(forestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(180));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidStartingUnits);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaMinBlobs(forestID, 1);
         rmSetAreaMaxBlobs(forestID, 3);
         rmSetAreaMinBlobDistance(forestID, 8.0);
         rmSetAreaMaxBlobDistance(forestID, 12.0);
	   rmSetAreaSmoothDistance(forestID, rmRandInt(10,20));
         if(rmBuildArea(forestID)==false)
         {
            // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==3)
               break;
         }
         else
            failCount=0;

	   if (forestCoverUp == 1)
	   {
         int coverForestPatch3ID = rmCreateArea(("cover forest patch three"+i+j), rmAreaID("player"+i+"small forest"+j));   
         rmSetAreaWarnFailure(coverForestPatch3ID, false);
	   if (lowForest == 1)
            rmSetAreaSize(coverForestPatch3ID, rmAreaTilesToFraction(180), rmAreaTilesToFraction(180));
	   else
            rmSetAreaSize(coverForestPatch3ID, rmAreaTilesToFraction(195), rmAreaTilesToFraction(195));
         rmSetAreaCoherence(coverForestPatch3ID, 0.99);
         rmSetAreaMix(coverForestPatch3ID, baseType);
         rmBuildArea(coverForestPatch3ID);
   	   }
      }
   }

// Big island forests
   int forestNo = rmRandInt(6,7);
   if (cNumberNonGaiaPlayers > 5)
     forestNo = rmRandInt(8,9);
   else if (cNumberNonGaiaPlayers > 3)
     forestNo = rmRandInt(7,8);

   if (lowForest == 1)
   {
	if (cNumberNonGaiaPlayers > 5)
         forestCount=rmRandInt(4, 5);
	else
         forestCount=rmRandInt(3, 4);
   }

   for(i=0; < forestNo)
   {
         forestID=rmCreateArea("big island forest"+i, rmAreaID("big island"));
         rmAddAreaToClass(forestID, rmClassID("classForest"));
	   if (lowForest == 1)
            rmSetAreaSize(forestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(160));
	   else 
            rmSetAreaSize(forestID, rmAreaTilesToFraction(145), rmAreaTilesToFraction(175));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, avoidTradeRoute);
         rmAddAreaConstraint(forestID, avoidSocket);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand); 
         if(rmRandFloat(0.0, 1.0)<0.4)
            rmSetAreaBaseHeight(forestID, rmRandFloat(3.0, 4.0)); 
         rmBuildArea(forestID);

	   if (forestCoverUp == 1)
	   {
         int coverForestPatch4ID = rmCreateArea(("big island forest cover"+i), rmAreaID("big island forest"+i));   
         rmSetAreaWarnFailure(coverForestPatch4ID, false);
	   if (lowForest == 1)
            rmSetAreaSize(coverForestPatch4ID, rmAreaTilesToFraction(175), rmAreaTilesToFraction(175));
	   else 
            rmSetAreaSize(coverForestPatch4ID, rmAreaTilesToFraction(190), rmAreaTilesToFraction(190));
         rmSetAreaCoherence(coverForestPatch4ID, 0.99);
         rmSetAreaMix(coverForestPatch4ID, baseType);
         rmBuildArea(coverForestPatch4ID);
   	   }
   }

// Text
   rmSetStatusText("",0.65);

// Settlement island forests
   for(i=0; <numIslands)
   {
      forestCount=rmRandInt(3,4);
      if (lowForest == 1)
         forestCount=2;
      for(j=0; <forestCount)
      {
         forestID=rmCreateArea("settlement island"+i+"forest"+j, rmAreaID("settlement island"+i));
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaSize(forestID, rmAreaTilesToFraction(140), rmAreaTilesToFraction(185));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, avoidTradeRoute);
         rmAddAreaConstraint(forestID, avoidSocket);
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand); 
         rmBuildArea(forestID);

	   if (forestCoverUp == 1)
	   {
         int coverForestPatch5ID = rmCreateArea(("5th forest cover"+i+j), rmAreaID("settlement island"+i+"forest"+j));   
         rmSetAreaWarnFailure(coverForestPatch5ID, false);
         rmSetAreaSize(coverForestPatch5ID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
         rmSetAreaCoherence(coverForestPatch5ID, 0.99);
         rmSetAreaMix(coverForestPatch5ID, baseType);
         rmBuildArea(coverForestPatch5ID);
   	   }
      }
   }

// Text
   rmSetStatusText("",0.70);

// Native island forests
   int natForest = rmRandInt(3,4);
   if (lowForest == 1)
      natForest=2;
   for(i=0; < natForest)
   {
         forestID=rmCreateArea("native island 1 forest"+i, rmAreaID("native island 1"));
         rmAddAreaToClass(forestID, rmClassID("classForest"));  
         rmSetAreaSize(forestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(180));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmBuildArea(forestID);

	   if (forestCoverUp == 1)
	   {
         int coverForestPatch6ID = rmCreateArea(("6th forest cover"+i), rmAreaID("native island 1 forest"+i));   
         rmSetAreaWarnFailure(coverForestPatch6ID, false);
         rmSetAreaSize(coverForestPatch6ID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
         rmSetAreaCoherence(coverForestPatch6ID, 0.99);
         rmSetAreaMix(coverForestPatch6ID, baseType);
         rmBuildArea(coverForestPatch6ID);
   	   }
   }

   for(i=0; < natForest)
   {
         forestID=rmCreateArea("native island 2 forest"+i, rmAreaID("native island 2")); 
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaSize(forestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(180));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmBuildArea(forestID);

	   if (forestCoverUp == 1)
	   {
         int coverForestPatch7ID = rmCreateArea(("7th forest cover"+i), rmAreaID("native island 2 forest"+i));   
         rmSetAreaWarnFailure(coverForestPatch7ID, false);
         rmSetAreaSize(coverForestPatch7ID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
         rmSetAreaCoherence(coverForestPatch7ID, 0.99);
         rmSetAreaMix(coverForestPatch7ID, baseType);
         rmBuildArea(coverForestPatch7ID);
	   }
   }

   if (extraNativeIs == 1)
   {
      for(i=1; < natForest)
      {
         forestID=rmCreateArea("native island 3 forest"+i, rmAreaID("native island 3")); 
         rmAddAreaToClass(forestID, rmClassID("classForest")); 
         rmSetAreaSize(forestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(150));
         rmSetAreaWarnFailure(forestID, false);
         rmSetAreaForestType(forestID, forestType);
         rmSetAreaForestDensity(forestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(forestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(forestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(forestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(forestID, avoidNativesShort);
         rmAddAreaConstraint(forestID, avoidAll);
         rmAddAreaConstraint(forestID, avoidWater10);
         rmAddAreaConstraint(forestID, forestConstraint2);
         rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
         rmBuildArea(forestID);

	   if (forestCoverUp == 1)
	   {
         int coverForestPatch8ID = rmCreateArea(("8th forest cover"+i), rmAreaID("native island 3 forest"+i));   
         rmSetAreaWarnFailure(coverForestPatch8ID, false);
         rmSetAreaSize(coverForestPatch8ID, rmAreaTilesToFraction(170), rmAreaTilesToFraction(170));
         rmSetAreaCoherence(coverForestPatch8ID, 0.99);
         rmSetAreaMix(coverForestPatch8ID, baseType);
         rmBuildArea(coverForestPatch8ID);
	   }
      }
   }

// Text
   rmSetStatusText("",0.75);

// Bonus island forests.
   for(i=0; <bonusCount)
   {
      forestCount=rmRandInt(2, 3);
      if (lowForest == 1)
         forestCount=rmRandInt(1,2);
      for(j=0; <forestCount)
      {
         int bonusForestID=rmCreateArea("bonus"+i+"forest"+j, rmAreaID("bonus island"+i));
         rmAddAreaToClass(bonusForestID, rmClassID("classForest"));  
	   rmSetAreaSize(bonusForestID, rmAreaTilesToFraction(140), rmAreaTilesToFraction(170));
         rmSetAreaWarnFailure(bonusForestID, false);
         rmSetAreaForestType(bonusForestID, forestType);
         rmSetAreaForestDensity(bonusForestID, rmRandFloat(0.7, 1.0));
         rmSetAreaForestClumpiness(bonusForestID, rmRandFloat(0.5, 0.9));
         rmSetAreaForestUnderbrush(bonusForestID, rmRandFloat(0.0, 0.5));
         rmSetAreaCoherence(bonusForestID, rmRandFloat(0.4, 0.7));
         rmAddAreaConstraint(bonusForestID, avoidNativesShort);
         rmAddAreaConstraint(bonusForestID, avoidAll);
         rmAddAreaConstraint(bonusForestID, forestConstraint2);
         rmAddAreaConstraint(bonusForestID, avoidTradeRoute);
         rmAddAreaConstraint(bonusForestID, avoidSocket);
         rmAddAreaConstraint(bonusForestID, shortAvoidImpassableLand);
         rmBuildArea(bonusForestID);

	   if (forestCoverUp == 1)
	   {
         int coverForestPatch9ID = rmCreateArea(("9th forest cover"+i+j), rmAreaID("bonus"+i+"forest"+j));   
         rmSetAreaWarnFailure(coverForestPatch9ID, false);
         rmSetAreaSize(coverForestPatch9ID, rmAreaTilesToFraction(190), rmAreaTilesToFraction(190));
         rmSetAreaCoherence(coverForestPatch9ID, 0.99);
         rmSetAreaMix(coverForestPatch9ID, baseType);
         rmBuildArea(coverForestPatch9ID);
	   }
      }
   }

// Text
   rmSetStatusText("",0.80);

// Trees
   int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, treeType, 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 8);
   rmSetObjectDefMaxDistance(randomTreeID, 15);
   rmAddObjectDefConstraint(randomTreeID, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(randomTreeID, avoidImportantItemSmall);
   rmAddObjectDefConstraint(randomTreeID, avoidTradeRoute);
   rmAddObjectDefConstraint(randomTreeID, avoidAll);
   rmAddObjectDefConstraint(randomTreeID, avoidWater10);
   for(i=1; <cNumberPlayers)
      rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("Player"+i), 6);
   rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("big island"), rmRandInt(6,10));
   for(i=0; <numIslands)
      rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("settlement island"+i), rmRandInt(2,4));
   for(i=0; <bonusCount)
      rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("bonus island"+i), rmRandInt(2,4));
   for(i=0; <extraCount)
      rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("extraland"+i), 2);
   rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("native island 1"), 3);
   rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("native island 2"), 3);
   if (extraNativeIs == 1)
      rmPlaceObjectDefInArea(randomTreeID, 0, rmAreaID("native island 3"), 3);

// Spanish shpwreck
   int avoidWreck=rmCreateTypeDistanceConstraint("avoids wreck", "SPCSpanishShipRuins", 100.0);
   int shipRuinsID=rmCreateObjectDef("island ship ruins");
   rmAddObjectDefItem(shipRuinsID, "SPCSpanishShipRuins", 1, 0);
   rmSetObjectDefMinDistance(shipRuinsID, 0.0);
   rmSetObjectDefMaxDistance(shipRuinsID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(shipRuinsID, fartherPlayerConstraint);
   rmAddObjectDefConstraint(shipRuinsID, nearWater);
   rmAddObjectDefConstraint(shipRuinsID, avoidWreck);
   rmAddObjectDefConstraint(shipRuinsID, avoidImportantItemMed);
   if (sixChoice == 1)
      rmPlaceObjectDefInArea(shipRuinsID, 0, rmAreaID("native island 1"));
   else if (sixChoice == 2)
      rmPlaceObjectDefInArea(shipRuinsID, 0, rmAreaID("native island 2"));
   else if (sixChoice == 3)
      rmPlaceObjectDefInRandomAreaOfClass(shipRuinsID, 0, classSettlementIsland, 1);
   else 
	rmPlaceObjectDefInArea(shipRuinsID, 0, rmAreaID("big island"));
   if (cNumberNonGaiaPlayers > 3)
   {
      if (sixChoice == 4)
         rmPlaceObjectDefInArea(shipRuinsID, 0, rmAreaID("native island 1"));
      else if (sixChoice == 5)
         rmPlaceObjectDefInArea(shipRuinsID, 0, rmAreaID("native island 2"));
      else if (sixChoice == 6)
	   rmPlaceObjectDefInRandomAreaOfClass(shipRuinsID, 0, classSettlementIsland, 1);
      else 
	   rmPlaceObjectDefInArea(shipRuinsID, 0, rmAreaID("big island"));
   }

// Text
   rmSetStatusText("",0.85);

// Deco
   if (eaglerock == 1)
	propType = "PropEaglesRocks";
   else if (eagles == 1)
	propType = "EaglesNest";
   else if (vultures == 1)
	propType = "PropVulturePerching";
   else if (kingfishers == 1)
	propType = "PropKingfisher";
   else if (texasProp == 1)
	propType = "BigPropTexas";

   int avoidProp=rmCreateTypeDistanceConstraint("avoids prop", propType, 90.0);
   int specialPropID=rmCreateObjectDef("special prop");
   rmAddObjectDefItem(specialPropID, propType, 1, 0.0);
   rmSetObjectDefMinDistance(specialPropID, 0.0);
   rmSetObjectDefMaxDistance(specialPropID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(specialPropID, avoidAll);
   rmAddObjectDefConstraint(specialPropID, avoidProp);
   rmAddObjectDefConstraint(specialPropID, shortAvoidImpassableLand);
   if ((vultures == 1) || (eaglerock == 1)) 
	rmAddObjectDefConstraint(specialPropID, avoidWater20);
   else
	rmAddObjectDefConstraint(specialPropID, avoidWater10);
   rmAddObjectDefConstraint(specialPropID, avoidImportantItem);
   rmAddObjectDefConstraint(specialPropID, longPlayerConstraint);
   rmPlaceObjectDefAtLoc(specialPropID, 0, 0.5, 0.5, (cNumberNonGaiaPlayers + 1));

   if (underbrush == 1)
   {
	int avoidBrush=rmCreateTypeDistanceConstraint("avoids brush", brushType, 30.0);
	int decoUnderbrushID=rmCreateObjectDef("underbrush");
	rmAddObjectDefItem(decoUnderbrushID, brushType, rmRandInt(2,4), 4.0);
	rmSetObjectDefMinDistance(decoUnderbrushID, 0.0);
	rmSetObjectDefMaxDistance(decoUnderbrushID, rmXFractionToMeters(0.5));
      rmAddObjectDefConstraint(decoUnderbrushID, avoidAll);
      rmAddObjectDefConstraint(decoUnderbrushID, avoidWater10);
	rmAddObjectDefConstraint(decoUnderbrushID, avoidImpassableLand);
	rmAddObjectDefConstraint(decoUnderbrushID, playerConstraintShort);
	rmAddObjectDefConstraint(decoUnderbrushID, avoidBrush);
	rmAddObjectDefConstraint(decoUnderbrushID, avoidTradeRoute);
      rmPlaceObjectDefAtLoc(decoUnderbrushID, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers);
   }

// Water Flag
   int waterFlagID=-1;
   for(i=1; <cNumberPlayers)
   {
      rmClearClosestPointConstraints();
      waterFlagID=rmCreateObjectDef("HC water flag "+i);
      rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 1.0);
      rmAddObjectDefItem(waterFlagID, fishType, 2, 3.0);
      rmAddClosestPointConstraint(flagEdgeConstraint);
      rmAddClosestPointConstraint(flagVsFlag);
      rmAddClosestPointConstraint(flagLand);
      vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
      vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));
      rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
      rmClearClosestPointConstraints();
   }

// Text
   rmSetStatusText("",0.90);

// Fish
   int fishVsFishID=rmCreateClassDistanceConstraint("fish v fish", rmClassID("classFish"), rmRandInt(23,27));
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 5.0);
   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, fishType, 2, 5.0);
   rmAddObjectDefToClass(fishID, rmClassID("classFish"));
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   if (cNumberNonGaiaPlayers < 4)
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*12);
   else if (cNumberNonGaiaPlayers < 6)
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*10);
   else
      rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*9);

   int fishVsFish2ID=rmCreateClassDistanceConstraint("another fish v fish", rmClassID("classFish"), rmRandInt(18,22));
   int fish2ID=rmCreateObjectDef("second type fish");
   int fishLand2 = rmCreateTerrainDistanceConstraint("second fish land", "land", true, 3.0);
   rmAddObjectDefItem(fish2ID, fish2Type, 1, 5.0);
   rmAddObjectDefToClass(fish2ID, rmClassID("classFish"));
   rmSetObjectDefMinDistance(fish2ID, 0.0);
   rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fish2ID, fishVsFish2ID);
   rmAddObjectDefConstraint(fish2ID, fishLand2);
   if (cNumberNonGaiaPlayers < 4)
      rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*16);
   else if (cNumberNonGaiaPlayers < 6)
      rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*14);
   else if (cNumberNonGaiaPlayers == 6)
      rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*13);
   else
      rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*12);

// Text
   rmSetStatusText("",0.95);

// Whales
   int whaleID=rmCreateObjectDef("whale");
   int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 18.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", whaleType, 70.0);
   rmAddObjectDefItem(whaleID, whaleType, 1, 5.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(1.0));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   if (cNumberNonGaiaPlayers == 2)
      rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);
   else if (cNumberNonGaiaPlayers < 5)
      rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);
   else
      rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

// Water nuggets - random type - works for Asian map types only
if (waterNuggets < 1)  
{
   if (patternChance > 28)
   {
      waterNuggets = 1;
      threeChoice = rmRandInt(1,3);
      if (threeChoice == 1) 
 	   rmSetMapType("Ceylon");
      else if (threeChoice == 2) 
    	   rmSetMapType("Borneo");
      else if (threeChoice == 3) 
 	   rmSetMapType("Japan");
   }
}

if (waterNuggets == 1)  
{
   int nuggetW= rmCreateObjectDef("nugget water"); 
   rmAddObjectDefItem(nuggetW, "ypNuggetBoat", 1, 0.0);
   rmAddObjectDefToClass(nuggetW, rmClassID("nuggets"));   
   rmSetNuggetDifficulty(5, 5);
   rmSetObjectDefMinDistance(nuggetW, 0.0);
   rmSetObjectDefMaxDistance(nuggetW, size*0.5);
   rmAddObjectDefConstraint(nuggetW, avoidLand10);
   rmAddObjectDefConstraint(nuggetW, avoidNuggetLong);
   rmAddObjectDefConstraint(nuggetW, flagVsFlag);
   rmPlaceObjectDefAtLoc(nuggetW, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
}

// Text
   rmSetStatusText("",0.99);
}  
