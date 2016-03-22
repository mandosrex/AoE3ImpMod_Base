// GREAT LAKES
// March 2004 - JG
// Main entry point for random map script
void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
	int subCiv3=-1;

   if (rmAllocateSubCivs(4) == true)
   {
		// Always "Big" Comanche
		subCiv0=rmGetCivID("Comanche");
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Comanche", true);


		// Usually Lakota, sometimes Iroquois
	 
			subCiv1=rmGetCivID("Iroquois");
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "Iroquois");
	
	
			subCiv2=rmGetCivID("Lakota");
		   if (subCiv2 >= 0)
			   rmSetSubCiv(2, "Lakota");
	  

	  

	  // Usually Aztec, sometimes Maya
	  if(rmRandFloat(0,1) < 0.35)
	  {
	  		subCiv3=rmGetCivID("Cherokee");
			if (subCiv3 >= 0)
				rmSetSubCiv(3, "Cherokee");

	  }
	  else
	  {
			subCiv3=rmGetCivID("Cherokee");
		   if (subCiv3 >= 0)
			   rmSetSubCiv(3, "Cherokee");
	  }
	}

   // Chooses which Mercenaries appear on the map
   if (rmRandFloat(0,1) < 0.4)
      rmAddMerc("MercSwissPikeman", rmRandInt(4,8)*cNumberNonGaiaPlayers);
   else
   {
      if (rmRandFloat(0,1) < 0.75)
	     rmAddMerc("MercLandsknecht", rmRandInt(4,8)*cNumberNonGaiaPlayers);
      else
	     rmAddMerc("MercRonin", rmRandInt(4,8)*cNumberNonGaiaPlayers);
   }

   if (rmRandFloat(0,1) < 0.5)
      rmAddMerc("MercHighlander", rmRandInt(3,5)*cNumberNonGaiaPlayers);
   else
      rmAddMerc("MercJaeger", rmRandInt(3,5)*cNumberNonGaiaPlayers);
   
   if (rmRandFloat(0,1) < 0.4)
      rmAddMerc("MercStradiot", rmRandInt(3,5)*cNumberNonGaiaPlayers);
   else
   {  if (rmRandFloat(0,1) < 0.5)
	     rmAddMerc("MercMameluke", rmRandInt(3,5)*cNumberNonGaiaPlayers);
      else
	     rmAddMerc("MercHackapell", rmRandInt(3,5)*cNumberNonGaiaPlayers);
	}

	if (rmRandFloat(0,1) < 0.5) 
	{
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercBlackRider", rmRandInt(3,5)*cNumberNonGaiaPlayers);
		 else
			rmAddMerc("MercManchu", rmRandInt(3,5)*cNumberNonGaiaPlayers);
	}

   // Picks the map size
   int playerTiles=14000;		// DAL modified from 16K
   if(cMapSize == 1)
   {
      playerTiles = 16000;			// DAL modified from 18K
      rmEchoInfo("Large map");
   }
   int size=2.5*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

	// rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.5, 3.0);  // DAL - original
	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);
	rmSetMapElevationHeightBlend(1);
	
	// Picks a default water height
   rmSetSeaLevel(8.0);

   // Picks default terrain and water
   rmSetSeaType("new england coast");
	rmEnableLocalWater(false);
   rmTerrainInitialize("saguenay\ground5_sag", 5.0);
	rmSetMapType("greatlakes");
	rmSetMapType("grass");
	rmSetMapType("water");

	// Corner constraint.
	rmSetWorldCircleConstraint(true);

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classHill");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("secrets");
	rmDefineClass("nuggets");
	rmDefineClass("center");
	rmDefineClass("tradeIslands");
	int classGreatLake=rmDefineClass("great lake");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
	int bisonEdgeConstraint=rmCreateBoxConstraint("bison edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0);  //DAL - was 24
	// int goldCenterConstraint=rmCreateBoxConstraint("gold keeps away from middle", 0.2, 0.2, 0.8, 0.8, 0.01);
	int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 30.0);
	int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 60.0);


   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

   // Player constraints
   int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 20.0);
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
	int avoidTradeIslands=rmCreateClassDistanceConstraint("stay away from trade islands", rmClassID("tradeIslands"), 40.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);

   // Nature avoidance
   // int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   // int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 40.0);
	int shortAvoidCoin=rmCreateTypeDistanceConstraint("short avoid coin", "gold", 10.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   
   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
   int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 10.0);
   int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);

	int nearShore=rmCreateTerrainMaxDistanceConstraint("near shore", "water", false, 10.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 45.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 20.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 30.0);
	int avoidSecrets=rmCreateClassDistanceConstraint("stuff avoids secrets", rmClassID("secrets"), 20.0);
	int avoidNuggets=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 50.0);
	int fortConstraint=rmCreateTypeDistanceConstraint("avoid the fort", "SecretRuinAbandonedFort", 20.0);
	int deerConstraint=rmCreateTypeDistanceConstraint("avoid the deer", "deer", 30.0);
	int shortDeerConstraint=rmCreateTypeDistanceConstraint("short avoid the deer", "deer", 10.0);
	int mooseConstraint=rmCreateTypeDistanceConstraint("avoid the moose", "moose", 20.0);
   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

     // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);

   // -------------Define objects
   // These objects are all defined so they can be placed later

	
   int bisonID=rmCreateObjectDef("bison herd center");
   rmAddObjectDefItem(bisonID, "bison", rmRandInt(10,12), 6.0);
	rmSetObjectDefCreateHerd(bisonID, true);
   rmSetObjectDefMinDistance(bisonID, 0.0);
   rmSetObjectDefMaxDistance(bisonID, 5.0);
	// rmAddObjectDefConstraint(bisonID, playerConstraint);
	// rmAddObjectDefConstraint(bisonID, bisonEdgeConstraint);
	// rmAddObjectDefConstraint(bisonID, avoidResource);
   // rmAddObjectDefConstraint(bisonID, avoidImpassableLand);
	// rmAddObjectDefConstraint(bisonID, Northward);


   // wood resources
   int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, "longleafPine", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomTreeID, avoidResource);
   rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);

   // starting resources
	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "longleafPine", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 2);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 12);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidNatives);

	// DAL - taken out now 'cause it's silly with the new model.
	/*
	int StartAreaSilverID=rmCreateObjectDef("starting silver");
	rmAddObjectDefItem(StartAreaSilverID, "silverOre", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaSilverID, 2);
	rmSetObjectDefMaxDistance(StartAreaSilverID, 12);
	rmAddObjectDefConstraint(StartAreaSilverID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaSilverID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaSilverID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaSilverID, avoidNatives);
	*/

	int StartPronghornID=rmCreateObjectDef("starting pronghorn");
	rmAddObjectDefItem(StartPronghornID, "pronghorn", 1, 0.0);
	rmSetObjectDefCreateHerd(StartPronghornID, true);
	rmSetObjectDefMinDistance(StartPronghornID, 3);
	rmSetObjectDefMaxDistance(StartPronghornID, 12);
	rmAddObjectDefConstraint(StartPronghornID, avoidStartResource);
	rmAddObjectDefConstraint(StartPronghornID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartPronghornID, avoidNatives);

	// -------------Done defining objects
   // Text
   rmSetStatusText("",0.10);

   // Text
   rmSetStatusText("",0.10);

	// ************************ LAKE MICHIGAN *******************************
	int michiganID=rmCreateArea("Lake Michigan 1");
   rmSetAreaSize(michiganID, 0.09, 0.09);
   rmSetAreaLocation(michiganID, 0.05, 0.6);
   rmSetAreaWaterType(michiganID, "new england coast");
   rmAddAreaToClass(michiganID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(michiganID, 0.0);
	rmAddAreaInfluencePoint(michiganID, 0.5, 0.5);
	rmSetAreaObeyWorldCircleConstraint(michiganID, false);
   rmSetAreaMinBlobs(michiganID, 20);
   rmSetAreaMaxBlobs(michiganID, 30);
   rmSetAreaMinBlobDistance(michiganID, 20);
   rmSetAreaMaxBlobDistance(michiganID, 40);
   rmSetAreaSmoothDistance(michiganID, 10);
   rmSetAreaCoherence(michiganID, 0.05);
   rmBuildArea(michiganID); 

	int michigan2ID=rmCreateArea("Lake Michigan 2");
   rmSetAreaSize(michigan2ID, 0.06, 0.06);
   rmSetAreaLocation(michigan2ID, 0.05, 0.75);
   rmSetAreaWaterType(michigan2ID, "new england coast");
   rmAddAreaToClass(michigan2ID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(michigan2ID, 0.0);
	rmSetAreaObeyWorldCircleConstraint(michigan2ID, false);
	rmAddAreaInfluencePoint(michigan2ID, 0.7, 0.5);
   rmSetAreaMinBlobs(michigan2ID, 20);
   rmSetAreaMaxBlobs(michigan2ID, 30);
   rmSetAreaMinBlobDistance(michigan2ID, 20);
   rmSetAreaMaxBlobDistance(michigan2ID, 40);
   rmSetAreaSmoothDistance(michigan2ID, 10);
   rmSetAreaCoherence(michigan2ID, 0.05);
   rmBuildArea(michigan2ID); 

	int michigan3ID=rmCreateArea("Lake Michigan 3");
   rmSetAreaSize(michigan3ID, 0.04, 0.04);
   rmSetAreaLocation(michigan3ID, 0.30, 0.50);
   rmSetAreaWaterType(michigan3ID, "new england coast");
   rmAddAreaToClass(michigan3ID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(michigan3ID, 0.0);
	rmAddAreaInfluencePoint(michigan3ID, 0.7, 0.5);
   rmSetAreaMinBlobs(michigan3ID, 20);
   rmSetAreaMaxBlobs(michigan3ID, 30);
   rmSetAreaMinBlobDistance(michigan3ID, 20);
   rmSetAreaMaxBlobDistance(michigan3ID, 40);
   rmSetAreaSmoothDistance(michigan3ID, 10);
   rmSetAreaCoherence(michigan3ID, 0.25);
   rmBuildArea(michigan3ID); 

	int michigan4ID=rmCreateArea("Lake Michigan 4");
   rmSetAreaSize(michigan4ID, 0.05, 0.05);
   rmSetAreaLocation(michigan4ID, 0.30, 0.62);
   rmSetAreaWaterType(michigan4ID, "new england coast");
   rmAddAreaToClass(michigan4ID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(michigan4ID, 0.0);
	rmAddAreaInfluencePoint(michigan4ID, 0.7, 0.5);
   rmSetAreaMinBlobs(michigan4ID, 20);
   rmSetAreaMaxBlobs(michigan4ID, 30);
   rmSetAreaMinBlobDistance(michigan4ID, 20);
   rmSetAreaMaxBlobDistance(michigan4ID, 40);
   rmSetAreaSmoothDistance(michigan4ID, 10);
   rmSetAreaCoherence(michigan4ID, 0.25);
   rmBuildArea(michigan4ID); 

	int michigan5ID=rmCreateArea("Lake Michigan 5");
   rmSetAreaSize(michigan5ID, 0.03, 0.03);
   rmSetAreaLocation(michigan5ID, 0.45, 0.5);
   rmSetAreaWaterType(michigan5ID, "new england coast");
   rmAddAreaToClass(michigan5ID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(michigan5ID, 0.0);
	rmAddAreaInfluencePoint(michigan5ID, 0.7, 0.5);
   rmSetAreaMinBlobs(michigan5ID, 10);
   rmSetAreaMaxBlobs(michigan5ID, 20);
   rmSetAreaMinBlobDistance(michigan5ID, 10);
   rmSetAreaMaxBlobDistance(michigan5ID, 20);
   rmSetAreaSmoothDistance(michigan5ID, 10);
   rmSetAreaCoherence(michigan5ID, 0.25);
   rmBuildArea(michigan5ID); 


// ****************************** LAKE HURON *************************************
	int huron1ID=rmCreateArea("Lake Huron 1");
   rmSetAreaSize(huron1ID, 0.06, 0.06);
   rmSetAreaLocation(huron1ID, 0.75, 0.0);
   rmSetAreaWaterType(huron1ID, "new england coast");
   rmAddAreaToClass(huron1ID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(huron1ID, 0.0);
	rmSetAreaObeyWorldCircleConstraint(huron1ID, false);
	rmAddAreaInfluencePoint(huron1ID, 0.7, 0.5);
   rmSetAreaMinBlobs(huron1ID, 20);
   rmSetAreaMaxBlobs(huron1ID, 30);
   rmSetAreaMinBlobDistance(huron1ID, 20);
   rmSetAreaMaxBlobDistance(huron1ID, 40);
   rmSetAreaSmoothDistance(huron1ID, 10);
   rmSetAreaCoherence(huron1ID, 0.05);
   rmBuildArea(huron1ID); 

	int huron2ID=rmCreateArea("Lake Huron 2");
   rmSetAreaSize(huron2ID, 0.06, 0.06);
   rmSetAreaLocation(huron2ID, 0.70, 0.10);
   rmSetAreaWaterType(huron2ID, "new england coast");
   rmAddAreaToClass(huron2ID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(huron2ID, 0.0);
	rmSetAreaObeyWorldCircleConstraint(huron2ID, false);
	rmAddAreaInfluencePoint(huron2ID, 0.7, 0.5);
   rmSetAreaMinBlobs(huron2ID, 20);
   rmSetAreaMaxBlobs(huron2ID, 30);
   rmSetAreaMinBlobDistance(huron2ID, 20);
   rmSetAreaMaxBlobDistance(huron2ID, 40);
   rmSetAreaSmoothDistance(huron2ID, 10);
   rmSetAreaCoherence(huron2ID, 0.05);
   rmBuildArea(huron2ID); 

	int huron3ID=rmCreateArea("Lake Huron 3");
   rmSetAreaSize(huron3ID, 0.04, 0.04);
   rmSetAreaLocation(huron3ID, 0.70, 0.25);
   rmSetAreaWaterType(huron3ID, "new england coast");
   rmAddAreaToClass(huron3ID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(huron3ID, 0.0);
	rmAddAreaInfluencePoint(huron3ID, 0.7, 0.5);
   rmSetAreaMinBlobs(huron3ID, 20);
   rmSetAreaMaxBlobs(huron3ID, 30);
   rmSetAreaMinBlobDistance(huron3ID, 20);
   rmSetAreaMaxBlobDistance(huron3ID, 40);
   rmSetAreaSmoothDistance(huron3ID, 10);
   rmSetAreaCoherence(huron3ID, 0.25);
   rmBuildArea(huron3ID); 

	int huron4ID=rmCreateArea("Lake Huron 4");
   rmSetAreaSize(huron4ID, 0.04, 0.04);
   rmSetAreaLocation(huron4ID, 0.70, 0.30);
   rmSetAreaWaterType(huron4ID, "new england coast");
   rmAddAreaToClass(huron4ID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(huron4ID, 0.0);
	rmAddAreaInfluencePoint(huron4ID, 0.7, 0.5);
   rmSetAreaMinBlobs(huron4ID, 20);
   rmSetAreaMaxBlobs(huron4ID, 30);
   rmSetAreaMinBlobDistance(huron4ID, 20);
   rmSetAreaMaxBlobDistance(huron4ID, 40);
   rmSetAreaSmoothDistance(huron4ID, 10);
   rmSetAreaCoherence(huron4ID, 0.25);
   rmBuildArea(huron4ID); 

	int huron5ID=rmCreateArea("Lake Huron 5");
   rmSetAreaSize(huron5ID, 0.03, 0.03);
   rmSetAreaLocation(huron5ID, 0.57, 0.35);
   rmSetAreaWaterType(huron5ID, "new england coast");
   rmAddAreaToClass(huron5ID, rmClassID("great lake"));
//   rmSetAreaBaseHeight(huron5ID, 0.0);
	rmAddAreaInfluencePoint(huron5ID, 0.7, 0.5);
   rmSetAreaMinBlobs(huron5ID, 10);
   rmSetAreaMaxBlobs(huron5ID, 20);
   rmSetAreaMinBlobDistance(huron5ID, 20);
   rmSetAreaMaxBlobDistance(huron5ID, 30);
   rmSetAreaSmoothDistance(huron5ID, 10);
   rmSetAreaCoherence(huron5ID, 0.15);
   rmBuildArea(huron5ID); 

	int greatLakesConstraint=rmCreateClassDistanceConstraint("avoid the great lakes", classGreatLake, 10.0);
	int farGreatLakesConstraint=rmCreateClassDistanceConstraint("far avoid the great lakes", classGreatLake, 20.0);
	
// ********************* create Trade islands *********************

	int tradeIslandA=rmCreateArea("trade island A");
   rmSetAreaSize(tradeIslandA, rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
   rmSetAreaLocation(tradeIslandA, 0.15, 0.6);
   rmAddAreaToClass(tradeIslandA, rmClassID("great lake"));
	rmAddAreaToClass(tradeIslandA, rmClassID("tradeIslands"));
   rmSetAreaBaseHeight(tradeIslandA, 2.0);
	rmSetAreaMix(tradeIslandA, "carolina grass");
   rmSetAreaMinBlobs(tradeIslandA, 3);
   rmSetAreaMaxBlobs(tradeIslandA, 5);
   rmSetAreaMinBlobDistance(tradeIslandA, 5);
   rmSetAreaMaxBlobDistance(tradeIslandA, 10);
   rmSetAreaSmoothDistance(tradeIslandA, 20);
   rmSetAreaCoherence(tradeIslandA, 0.15);
   rmBuildArea(tradeIslandA); 

	int tradeIslandB=rmCreateArea("trade island B");
   rmSetAreaSize(tradeIslandB, rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
   rmSetAreaLocation(tradeIslandB, 0.70, 0.15);
   rmAddAreaToClass(tradeIslandB, rmClassID("great lake"));
	rmAddAreaToClass(tradeIslandB, rmClassID("tradeIslands"));
   rmSetAreaBaseHeight(tradeIslandB, 2.0);
	rmSetAreaMix(tradeIslandB, "carolina grass");
   rmSetAreaMinBlobs(tradeIslandB, 3);
   rmSetAreaMaxBlobs(tradeIslandB, 5);
   rmSetAreaMinBlobDistance(tradeIslandB, 5);
   rmSetAreaMaxBlobDistance(tradeIslandB, 10);
   rmSetAreaSmoothDistance(tradeIslandB, 20);
   rmSetAreaCoherence(tradeIslandB, 0.15);
   rmBuildArea(tradeIslandB); 

	int socketID=rmCreateObjectDef("socket for trade post in lake");
   rmAddObjectDefItem(socketID, "socket", 1, 0.0);
   rmAddObjectDefItem(socketID, "socketIconTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 12.0);

   

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

	if ( cNumberTeams == 2 )
	{
		if ( teamZeroCount == 3 )
		{	
			rmSetPlacementTeam(0);
		//	rmSetPlacementSection(0.1, 0.4);
			rmSetPlacementSection(0.77, 0.8);
			rmSetTeamSpacingModifier(0.3); 
			rmPlacePlayersCircular(0.47, 0.47, 0);
		//	rmPlacePlayersLine(0.15, 0.10, 0.25, 0.10, 0, 0.05);
		}
		else
		{
			rmSetPlacementTeam(0);
		//	rmSetPlacementSection(0.1, 0.4);
			rmSetPlacementSection(0.75, 0.85);
			rmSetTeamSpacingModifier(0.5); 
			rmPlacePlayersCircular(0.47, 0.47, 0);
		//	rmPlacePlayersLine(0.15, 0.10, 0.15, 0.6, 0, 0.15);
		}

		if (teamOneCount == 3 )
		{
			rmSetPlacementTeam(1);
		//	rmSetPlacementSection(0.6, 0.9);
			rmSetPlacementSection(0.4, 0.45);
			rmSetTeamSpacingModifier(0.3); 
			rmPlacePlayersCircular(0.47, 0.47, 0);
		//	rmPlacePlayersLine(0.75, 0.6, 0.85, 0.6, 0, 0.05);
		}
		else
		{
			rmSetPlacementTeam(1);
		//	rmSetPlacementSection(0.6, 0.9);
			rmSetPlacementSection(0.4, 0.45);
			rmSetTeamSpacingModifier(0.3); 
			rmPlacePlayersCircular(0.47, 0.47, 0);
		//	rmPlacePlayersLine(0.85, 0.10, 0.85, 0.6, 0, 0.15);
		}
	}
	else
	{
  		rmSetPlacementSection(0.0, 0.95);
		rmPlacePlayersSquare(0.35, 0.05, 0.1);
	}
	

	float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint); 
//		rmAddAreaConstraint(id, avoidWater);
		rmAddAreaConstraint(id, longAvoidImpassableLand);
		rmSetAreaLocPlayer(id, i);
		rmSetAreaWarnFailure(id, false);
   }

	// Build the areas.
   rmBuildAllAreas();
	
	int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
	int colonyShipID=rmCreateObjectDef("colony ship");
   rmAddObjectDefItem(colonyShipID, "caravel", 1, 0.0);
   rmSetObjectDefGarrisonStartingUnits(colonyShipID, true);
   rmSetObjectDefMinDistance(colonyShipID, 0.0);
   rmSetObjectDefMaxDistance(colonyShipID, 10.0);
 
   // Set up for finding closest land points.
	int avoidHCFlags=rmCreateHCGPConstraint("avoid HC flags", 20);
   rmAddClosestPointConstraint(avoidImpassableLand);
	rmAddClosestPointConstraint(avoidTradeIslands);
	rmAddClosestPointConstraint(avoidHCFlags);

   
   for(i=1; <cNumberPlayers)
   {
      // Place boat.
      int count = rmPlaceObjectDefAtLoc(colonyShipID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      if(count<1)
      {
         rmEchoError("Failed to place player "+i);
         continue;
      }
      
      // Get where it placed.
      vector colonyShipLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(colonyShipID, i));
      
      // Find closest point.
      vector closestPoint = rmFindClosestPointVector(colonyShipLocation, 200.0);
      
      // Set HCGP.
      rmSetHomeCityGatherPoint(i, closestPoint);
   }
   
   // Clear out constraints for good measure.
   rmClearClosestPointConstraints();


// ************************* PLACE THE UBER FORT SECRET **************************

	int abandonedFortID=rmCreateObjectDef("capturable fort");
   rmAddObjectDefItem(abandonedFortID, "SecretRuinAbandonedFort", 1, 0.0);
//	rmAddObjectDefItem(abandonedFortID, "SecretRuinWildTales", 1, 10.0);
   rmSetObjectDefMinDistance(abandonedFortID, 0.0);
   rmSetObjectDefMaxDistance(abandonedFortID, 20.0);
	rmAddObjectDefConstraint(abandonedFortID, farGreatLakesConstraint);
	rmAddObjectDefConstraint(abandonedFortID, nearShore);
	rmPlaceObjectDefAtLoc(abandonedFortID, 0, 0.42, 0.34);


// **************************** PLACE WATER TRADE ROUTE ***************************

	int tradeRouteID = rmCreateTradeRoute();
	rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.6);
	 rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.56);
    rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.64);
	 rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.4);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.7, 0.15, 2, 2);
	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
	if(placedTradeRoute == false)
		rmEchoError("Failed to place trade route #1");

	
	
	rmPlaceObjectDefInArea(socketID, 0, tradeIslandA);
	rmPlaceObjectDefInArea(socketID, 0, tradeIslandB);




   // Text
   rmSetStatusText("",0.20);

   // Text
   rmSetStatusText("",0.30);

	// Text
	rmSetStatusText("",0.50);
	int numTries = -1;
	int failCount = -1;

	// Define and place the Native Villages and Secrets of the New World
	// Text
	rmSetStatusText("",0.50);

	float NativeVillageLoc = rmRandFloat(0,1);
	float ComancheVillageLoc = rmRandFloat(0,1);

	// Comanche, Iroquois, Aztec rules (DAL - these are stub for now.)
	if (subCiv0 == rmGetCivID("Comanche"))
	{  
		int comancheVillageID = -1;
		int comancheVillageType = rmRandInt(1,3);
		comancheVillageID = rmCreateGrouping("comanche village", "native comanche village "+comancheVillageType);
		rmSetGroupingMinDistance(comancheVillageID, 0.0);
		rmSetGroupingMaxDistance(comancheVillageID, 20.0);
		rmAddGroupingConstraint(comancheVillageID, greatLakesConstraint);
		rmAddGroupingConstraint(comancheVillageID, nearShore);
		rmAddGroupingToClass(comancheVillageID, rmClassID("natives"));
		rmAddGroupingToClass(comancheVillageID, rmClassID("importantItem"));

		if ( ComancheVillageLoc < 0.5 )
		{
			rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.3, 0.75);
		}
		else
		{
			rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.3, 0.75);
		}
	}

	if (subCiv1 == rmGetCivID("Iroquois"))
	{
		int iroquoisVillageID = -1;
		int iroquoisVillageType = rmRandInt(1,3);
		iroquoisVillageID = rmCreateGrouping("iroquois village", "native iroquois village "+iroquoisVillageType);
		rmSetGroupingMinDistance(iroquoisVillageID, 0.0);
		rmSetGroupingMaxDistance(iroquoisVillageID, 20.0);
		rmAddGroupingConstraint(iroquoisVillageID, avoidImpassableLand);
		rmAddGroupingToClass(iroquoisVillageID, rmClassID("natives"));
		rmAddGroupingToClass(iroquoisVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(iroquoisVillageID, avoidImportantItem);
		rmAddGroupingConstraint(iroquoisVillageID, avoidTradeRoute);

		if (NativeVillageLoc < 0.5)
		{
		  rmPlaceGroupingAtLoc(iroquoisVillageID, 0, 0.2, 0.38);
		}
		else
		{
		  rmPlaceGroupingAtLoc(iroquoisVillageID, 0, 0.2, 0.38);
		}
	}
	
	if (subCiv2 == rmGetCivID("Lakota"))
	{
		int lakotaVillageID = -1;
		int lakotaVillageType = rmRandInt(1,3);
		lakotaVillageID = rmCreateGrouping("lakota village", "native lakota village "+lakotaVillageType);
		rmSetGroupingMinDistance(lakotaVillageID, 0.0);
		rmSetGroupingMaxDistance(lakotaVillageID, 20.0);
		rmAddGroupingConstraint(lakotaVillageID, avoidImpassableLand);
		rmAddGroupingToClass(lakotaVillageID, rmClassID("natives"));
		rmAddGroupingToClass(lakotaVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(lakotaVillageID, avoidImportantItem);
		rmAddGroupingConstraint(lakotaVillageID, avoidTradeRoute);

		if (NativeVillageLoc < 0.5)
		{
		  rmPlaceGroupingAtLoc(lakotaVillageID, 0, 0.8, 0.45);
		}
		else
		{
		  rmPlaceGroupingAtLoc(lakotaVillageID, 0, 0.8, 0.45);
		}
	}

	if (subCiv3 == rmGetCivID("Cherokee"))
	{   
		int aztecVillageID = -1;
		int cherokeeVillageType = rmRandInt(1,3);
		aztecVillageID = rmCreateGrouping("cherokee village", "native cherokee village "+cherokeeVillageType);
		rmSetGroupingMinDistance(aztecVillageID, 0.0);
		rmSetGroupingMaxDistance(aztecVillageID, 20.0);
		rmAddGroupingConstraint(aztecVillageID, avoidImpassableLand);
		rmAddGroupingToClass(aztecVillageID, rmClassID("natives"));
		rmAddGroupingToClass(aztecVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(aztecVillageID, avoidImportantItem);
		rmAddGroupingConstraint(aztecVillageID, avoidTradeRoute);
		rmAddGroupingConstraint(aztecVillageID, avoidNatives);

		if (NativeVillageLoc < 0.5)
		{
		  rmPlaceGroupingAtLoc(aztecVillageID, 0, 0.5, 0.2);
		}
		else
		{
		  rmPlaceGroupingAtLoc(aztecVillageID, 0, 0.5, 0.2);
		}
	}
	else
	{   
		int mayaVillageID = -1;
		int mayaVillageType = rmRandInt(1,3);
		mayaVillageID = rmCreateGrouping("maya village", "native maya village "+mayaVillageType);
		rmSetGroupingMinDistance(mayaVillageID, 0.0);
		rmSetGroupingMaxDistance(mayaVillageID, 20.0);
		rmAddGroupingConstraint(mayaVillageID, avoidImpassableLand);
		rmAddGroupingToClass(mayaVillageID, rmClassID("natives"));
		rmAddGroupingToClass(mayaVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(mayaVillageID, avoidImportantItem);
		rmAddGroupingConstraint(mayaVillageID, avoidTradeRoute);
		rmAddGroupingConstraint(mayaVillageID, avoidNatives);

		if (NativeVillageLoc < 0.5)
		{
		  rmPlaceGroupingAtLoc(mayaVillageID, 0, 0.53, 0.2);
		}
		else
		{
		  rmPlaceGroupingAtLoc(mayaVillageID, 0, 0.53, 0.2);
		}
	}

// ************************* the other 2 Secrets **********************************
	float SecretLoc = rmRandFloat(0,1);
	float RandomSecret = rmRandFloat(0,1);
/*
	int secretID1= rmCreateObjectDef("Secret Ruin Number One"); 
	if ( 	RandomSecret < 0.5)
	{
		rmAddObjectDefItem(secretID1, "secretRuinAmbush", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(secretID1, "secretRuinSecretPath", 1, 0.0);
	}
	rmSetObjectDefMinDistance(secretID1, 0.0);
	rmSetObjectDefMaxDistance(secretID1, 0.05);
	rmAddObjectDefConstraint(secretID1, avoidImpassableLand);
	rmAddObjectDefToClass(secretID1, rmClassID("importantItem"));
	rmAddObjectDefToClass(secretID1, rmClassID("secrets"));
	rmPlaceObjectDefAtLoc(secretID1, 0, 0.85, 0.7);

	int secretID2= rmCreateObjectDef("Secret Ruin Number Two"); 
	if ( 	RandomSecret < 0.99)
	{
		rmAddObjectDefItem(secretID2, "secretRuinBuccaneer", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(secretID2, "secretRuinIcelanders", 1, 0.0);
	}
	rmSetObjectDefMinDistance(secretID2, 0.0);
	rmSetObjectDefMaxDistance(secretID2, 0.05);
	rmAddObjectDefConstraint(secretID2, avoidImpassableLand);
	rmAddObjectDefToClass(secretID2, rmClassID("importantItem"));
	rmAddObjectDefToClass(secretID2, rmClassID("secrets"));
	rmPlaceObjectDefAtLoc(secretID2, 0, 0.58, 0.85);

*/

	// Define and place Nuggets
	int nuggetID = 0;
	for(i=0; <cNumberNonGaiaPlayers*4)
	{
		nuggetID= rmCreateObjectDef("nugget "+i); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nuggetID, 0.0);
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nuggetID, playerConstraint);
		rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
		rmAddObjectDefToClass(nuggetID, rmClassID("importantItem"));
		rmAddObjectDefToClass(nuggetID, rmClassID("nuggets"));
//		rmAddObjectDefConstraint(nuggetID, avoidResource);
//		rmAddObjectDefConstraint(nuggetID, avoidImportantItem);
//		rmAddObjectDefConstraint(nuggetID, avoidSecrets);
		rmAddObjectDefConstraint(nuggetID, avoidNuggets);
		rmAddObjectDefConstraint(nuggetID, playerEdgeConstraint);
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5);
	}

	// make Mainland more pretty by placing patches of terrain
      // For this map, place patches before cliffs so they can avoid impassable land by a lot
      for (i=0; <80)
      {
         int patch=rmCreateArea("first patch "+i);
         rmSetAreaWarnFailure(patch, false);
         rmSetAreaSize(patch, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
         rmSetAreaTerrainType(patch, "saguenay\ground6_sag");
         rmAddAreaTerrainLayer(patch, "saguenay\ground4_sag", 0, 1);
         rmAddAreaToClass(patch, rmClassID("classPatch"));
         rmSetAreaMinBlobs(patch, 1);
         rmSetAreaMaxBlobs(patch, 5);
         rmSetAreaMinBlobDistance(patch, 16.0);
         rmSetAreaMaxBlobDistance(patch, 40.0);
         rmSetAreaCoherence(patch, 0.0);
			rmAddAreaConstraint(patch, shortAvoidImpassableLand);
         rmBuildArea(patch); 
      }

// Define and place forests - north and south
	int forestTreeID = 0;
	
	numTries=5*cNumberNonGaiaPlayers;  // DAL - 4 here, 4 below
	failCount=0;
	for (i=0; <numTries)
		{   
			int northForest=rmCreateArea("northforest"+i);
			rmSetAreaWarnFailure(northForest, false);
			rmSetAreaSize(northForest, rmAreaTilesToFraction(500), rmAreaTilesToFraction(700));
			rmSetAreaForestType(northForest, "saguenay forest");
			rmSetAreaForestDensity(northForest, 0.8);
			rmAddAreaToClass(northForest, rmClassID("classForest"));
			rmSetAreaForestClumpiness(northForest, 0.5);		//DAL more forest with more clumps
			rmSetAreaForestUnderbrush(northForest, 0.6);
			rmSetAreaMinBlobs(northForest, 1);
			rmSetAreaMaxBlobs(northForest, 3);					//DAL was 5
			rmSetAreaMinBlobDistance(northForest, 16.0);
			rmSetAreaMaxBlobDistance(northForest, 30.0);
			rmSetAreaCoherence(northForest, 0.4);
			rmSetAreaSmoothDistance(northForest, 10);
			rmAddAreaConstraint(northForest, avoidImportantItem);		   // DAL added, to try and make sure natives got on the map w/o override.
			rmAddAreaConstraint(northForest, avoidSecrets);
			rmAddAreaConstraint(northForest, greatLakesConstraint);
//			rmAddAreaConstraint(northForest, playerConstraintForest);		// DAL adeed, to keep forests away from the player.
			rmAddAreaConstraint(northForest, forestConstraint);   // DAL adeed, to keep forests away from each other.
			rmAddAreaConstraint(northForest, Northward);				// DAL adeed, to keep forests in the north.
//			rmAddAreaConstraint(northForest, avoidTradeRoute);
			if(rmBuildArea(northForest)==false)
			{
				// Stop trying once we fail 5 times in a row.  
				failCount++;
				if(failCount==5)
					break;
			}
			else
				failCount=0; 
		}

	
	numTries=3*cNumberNonGaiaPlayers;  // DAL - 4 here, 4 above.
	failCount=0;
	for (i=0; <numTries)
		{   
			int southForest=rmCreateArea("southforest"+i);
			rmSetAreaWarnFailure(southForest, false);
			rmSetAreaSize(southForest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
			rmSetAreaForestType(southForest, "saguenay forest");
			rmSetAreaForestDensity(southForest, 0.8);
			rmAddAreaToClass(southForest, rmClassID("classForest"));
			rmSetAreaForestClumpiness(southForest, 0.5);		//DAL more forest with more clumps
			rmSetAreaForestUnderbrush(southForest, 0.6);
			rmSetAreaMinBlobs(southForest, 1);
			rmSetAreaMaxBlobs(southForest, 3);						//DAL was 5
			rmSetAreaMinBlobDistance(southForest, 16.0);
			rmSetAreaMaxBlobDistance(southForest, 30.0);
			rmSetAreaCoherence(southForest, 0.4);
			rmSetAreaSmoothDistance(southForest, 10);
			rmAddAreaConstraint(southForest, avoidImportantItem); // DAL added, to try and make sure natives got on the map w/o override.
			rmAddAreaConstraint(southForest, avoidSecrets);
			rmAddAreaConstraint(southForest, greatLakesConstraint);
//			rmAddAreaConstraint(southForest, playerConstraintForest);   // DAL adeed, to keep forests away from the player.
			rmAddAreaConstraint(southForest, forestConstraint);   // DAL adeed, to keep forests away from each other.
			rmAddAreaConstraint(southForest, Southward);				// DAL adeed, to keep forests in the south.
			rmAddAreaConstraint(southForest, fortConstraint);
			if(rmBuildArea(southForest)==false)
			{
				// Stop trying once we fail 5 times in a row.  
				failCount++;
				if(failCount==5)
					break;
			}
			else
				failCount=0; 
		} 

// Silver mines
   int mineType = -1;
   int mineID = -1;
	int silverTries=2*cNumberNonGaiaPlayers;
   
   for(i=0; <silverTries)
   {
	   mineType = rmRandInt(1,10);
      int northSilverID = rmCreateGrouping("north silver "+i, "resource silver ore "+mineType);
      rmSetGroupingMinDistance(northSilverID, 0.0);
      rmSetGroupingMaxDistance(northSilverID, rmXFractionToMeters(0.50));
		rmAddGroupingConstraint(northSilverID, avoidCoin);
      rmAddGroupingConstraint(northSilverID, avoidImpassableLand);
      rmAddGroupingConstraint(northSilverID, avoidTradeRoute);
		rmAddGroupingConstraint(northSilverID, avoidAll);
		rmAddGroupingConstraint(northSilverID, Northward);
		rmAddGroupingConstraint(northSilverID, greatLakesConstraint);
		rmPlaceGroupingAtLoc(northSilverID, 0, 0.5, 0.5);
   }

   for(i=0; <silverTries)
   {
	   mineType = rmRandInt(1,10);
      int southSilverID = rmCreateGrouping("south silver "+i, "resource silver ore "+mineType);
      rmSetGroupingMinDistance(southSilverID, 0.0);
      rmSetGroupingMaxDistance(southSilverID, rmXFractionToMeters(0.50));
		rmAddGroupingConstraint(southSilverID, avoidCoin);
      rmAddGroupingConstraint(southSilverID, avoidImpassableLand);
      rmAddGroupingConstraint(southSilverID, avoidTradeRoute);
		rmAddGroupingConstraint(southSilverID, avoidAll);
		rmAddGroupingConstraint(southSilverID, Southward);
		rmAddGroupingConstraint(southSilverID, greatLakesConstraint);
		rmPlaceGroupingAtLoc(southSilverID, 0, 0.5, 0.2);
   }

   
// Place some extra deer herds.  
   int deerHerdID=rmCreateObjectDef("northern deer herd");
   rmAddObjectDefItem(deerHerdID, "deer", rmRandInt(6,8), 6.0);
	rmSetObjectDefCreateHerd(deerHerdID, true);
   rmSetObjectDefMinDistance(deerHerdID, 0.0);
   rmSetObjectDefMaxDistance(deerHerdID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(deerHerdID, avoidCoin);
	rmAddObjectDefConstraint(deerHerdID, greatLakesConstraint);
	rmAddObjectDefConstraint(deerHerdID, avoidAll);
	rmAddObjectDefConstraint(deerHerdID, avoidImpassableLand);
	rmAddObjectDefConstraint(deerHerdID, deerConstraint);
	rmAddObjectDefConstraint(deerHerdID, Northward);
	numTries=2*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(deerHerdID, 0, 0.5, 0.5);
	}
	// Text
	rmSetStatusText("",0.70);

	int deerHerdID2=rmCreateObjectDef("southern deer herd");
   rmAddObjectDefItem(deerHerdID2, "deer", rmRandInt(6,8), 6.0);
	rmSetObjectDefCreateHerd(deerHerdID2, true);
   rmSetObjectDefMinDistance(deerHerdID2, 0.0);
   rmSetObjectDefMaxDistance(deerHerdID2, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(deerHerdID2, shortAvoidCoin);
	rmAddObjectDefConstraint(deerHerdID2, greatLakesConstraint);
	rmAddObjectDefConstraint(deerHerdID2, avoidAll);
	rmAddObjectDefConstraint(deerHerdID2, avoidImpassableLand);
	rmAddObjectDefConstraint(deerHerdID2, deerConstraint);
	rmAddObjectDefConstraint(deerHerdID2, Southward);
	numTries=2*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(deerHerdID2, 0, 0.5, 0.5);
	}
	// Text
	rmSetStatusText("",0.70);


// Place some extra deer herds.  
   int mooseHerdID=rmCreateObjectDef("moose herd");
   rmAddObjectDefItem(mooseHerdID, "moose", rmRandInt(2,4), 6.0);
	rmSetObjectDefCreateHerd(mooseHerdID, true);
   rmSetObjectDefMinDistance(mooseHerdID, 0.0);
   rmSetObjectDefMaxDistance(mooseHerdID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(mooseHerdID, shortAvoidCoin);
	rmAddObjectDefConstraint(mooseHerdID, greatLakesConstraint);
	rmAddObjectDefConstraint(mooseHerdID, avoidAll);
	rmAddObjectDefConstraint(mooseHerdID, avoidImpassableLand);
	rmAddObjectDefConstraint(mooseHerdID, Northward);
	rmAddObjectDefConstraint(mooseHerdID, mooseConstraint);
	rmAddObjectDefConstraint(mooseHerdID, shortDeerConstraint);
	numTries=2*cNumberNonGaiaPlayers;
	for (i=0; <numTries)
	{
		rmPlaceObjectDefAtLoc(mooseHerdID, 0, 0.5, 0.5);
	}
	// Text
	rmSetStatusText("",0.70);


	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);

	int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishSalmon", 3, 9.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
	/*
      
*/
	// Placement order
	// Trade Route -> Players and player stuff -> Natives -> Secrets -> Cliffs -> Nuggets
	// Place other objects that were defined earlier

	// DAL added - two trade routes placed

/*
	

   int playerGoldID=rmCreateObjectDef("player silver ore");
	int silverType = rmRandInt(1,10);

*/	
	// Player placement

/*
	
*/
	
	
	// Define and place cliffs
	
/*

	numTries=cNumberNonGaiaPlayers*4;
	failCount=0;
	for(i=0; <numTries)
	{
		int cliffID=rmCreateArea("cliff"+i);
	   rmSetAreaSize(cliffID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(900));  // DAL - larger cliffs?
		rmSetAreaWarnFailure(cliffID, false);
		rmSetAreaCliffType(cliffID, "Amazon");
		rmAddAreaToClass(cliffID, rmClassID("classCliff"));	// Attempt to keep cliffs away from each other.
		int edgeRand=rmRandInt(0,100);
		rmSetAreaCliffEdge(cliffID, 1, 0.6, 0.1, 1.0, 0);
		rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffID, 6, 1.0, 1.0);
		rmSetAreaHeightBlend(cliffID, 1);
		rmAddAreaTerrainLayer(cliffID, "carolinas\grass4", 0, 2);

		rmAddAreaConstraint(cliffID, avoidCliffs);		// Avoid cliffs, please!
		rmAddAreaConstraint(cliffID, playerConstraint); // Keep cliffs away from the player.
		rmAddAreaConstraint(cliffID, avoidImportantItem);
		rmAddAreaConstraint(cliffID, avoidTradeRoute);
		rmAddAreaConstraint(cliffID, greatLakesConstraint);
		rmAddAreaConstraint(cliffID, avoidSecrets);			// And especially freakin' secrets!
		rmSetAreaMinBlobs(cliffID, 3);
		rmSetAreaMaxBlobs(cliffID, 5);
		rmSetAreaMinBlobDistance(cliffID, 16.0);
		rmSetAreaMaxBlobDistance(cliffID, 40.0);
		rmSetAreaCoherence(cliffID, 0.0);
		rmSetAreaSmoothDistance(cliffID, 30);	// DAL - used to be 10
		rmSetAreaCoherence(cliffID, 0.25);

		if(rmBuildArea(cliffID)==false)
		{
			// Stop trying once we fail 3 times in a row
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}
*/
	// Text
	rmSetStatusText("",0.60);
	// */

	
/*
	// Text
	rmSetStatusText("",0.70);

	



	
	

	// Text
	rmSetStatusText("",0.80);

	// Resources that can be placed after forests - bison and random straggler trees.
	// rmPlaceObjectDefPerPlayer(bisonID, false, 1);
	// rmPlaceObjectDefPerPlayer(bisonID2, false, 1);

	// rmPlaceObjectDefAtLoc(bisonID, 0, 0.5, 0.5, 1);

	rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);  //DAL used to be 18.

		// Text
	rmSetStatusText("",0.90);

	// Define and place decorations: rocks and grass and stuff 
	int rockID=rmCreateObjectDef("lone rock");
	int avoidRock=rmCreateTypeDistanceConstraint("avoid rock", "underbrushRock", 8.0);
	rmAddObjectDefItem(rockID, "underbrushRock", 1, 0.0);
	rmSetObjectDefMinDistance(rockID, 0.0);
	rmSetObjectDefMaxDistance(rockID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rockID, avoidAll);
	rmAddObjectDefConstraint(rockID, avoidImpassableLand);
	rmAddObjectDefConstraint(rockID, avoidRock);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 15*cNumberNonGaiaPlayers);

	int Grass=rmCreateObjectDef("grass");
	rmAddObjectDefItem(Grass, "underbrushShrub", 1, 0.0);
	rmSetObjectDefMinDistance(Grass, 0.0);
	rmSetObjectDefMaxDistance(Grass, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(Grass, avoidAll);
	rmAddObjectDefConstraint(Grass, avoidImpassableLand);
	rmAddObjectDefConstraint(Grass, avoidRock);
	rmPlaceObjectDefAtLoc(Grass, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);

	int rockAndGrass=rmCreateObjectDef("grass and rock");
	rmAddObjectDefItem(rockAndGrass, "underbrushShrub", 2, 2.0);
	rmAddObjectDefItem(rockAndGrass, "underbrushRock", 1, 2.0);
	rmSetObjectDefMinDistance(rockAndGrass, 0.0);
	rmSetObjectDefMaxDistance(rockAndGrass, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rockAndGrass, avoidAll);
	rmAddObjectDefConstraint(rockAndGrass, avoidImpassableLand);
	rmAddObjectDefConstraint(rockAndGrass, avoidRock);
	rmPlaceObjectDefAtLoc(rockAndGrass, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);
*/
	// Text
	rmSetStatusText("",1.0);
   
	}  

}  
