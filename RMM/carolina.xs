// CAROLINA

// The First Age of Empires III Random Map
// Jan 2003
// Mar 2005
// Nov 2006 - Update to include Asians

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

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
      subCiv0=rmGetCivID("Seminoles");
      rmEchoInfo("subCiv0 is Seminoles "+subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Seminoles");
	
		// Seminoles only half the time
		if(rmRandFloat(0,1) < 0.5)
		{
			subCiv1=rmGetCivID("Seminoles");
			rmEchoInfo("subCiv1 is Seminoles "+subCiv1);
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "Seminoles");
		}

		// Subciv2 is Cherokee	
		subCiv2=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv2 is Cherokee "+subCiv2);
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "Cherokee");
	  
		// Subciv 3 is Cherokee
		subCiv3=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv3 is Cherokee "+subCiv3);
		if (subCiv3 >= 0)
			rmSetSubCiv(3, "Cherokee");
 
	}

   float handedness = rmRandFloat(0.0, 1.0);
	// > 0.5 is ocean to SE
	// < 0.5 is ocean to NE


   // Picks the map size
	int playerTiles = 12500;
	if (cNumberNonGaiaPlayers >4)
		 playerTiles = 11500;
	if (cNumberNonGaiaPlayers >6)
		 playerTiles = 10500;			

   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   // Picks a default water height
   rmSetSeaLevel(3);

   // Picks default terrain and water
   rmSetSeaType("atlantic coast");
   rmEnableLocalWater(false);
   rmTerrainInitialize("water");
	rmSetMapType("carolina");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
	rmSetMapType("grass");
   rmSetLightingSet("carolina");

	chooseMercs();

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classCliff");
   int classbigContinent=rmDefineClass("big continent");
   rmDefineClass("corner");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("flag");
	rmDefineClass("classInvis");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int longPlayerConstraint=rmCreateClassDistanceConstraint("continent stays away from players", classPlayer, rmXFractionToMeters(0.15));
	//	rmEchoInfo("long player constraint = "+rmXFractionToMeters(0.15));


   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 20.0);
   
	int TCvsTC=rmCreateTypeDistanceConstraint("TC avoid same", "TownCenter", 50.0);
   int CWvsCW=rmCreateTypeDistanceConstraint("CW avoid same", "CoveredWagon", 50.0);
	int forestvsTC=rmCreateTypeDistanceConstraint("forest vs. TC", "TownCenter", 20.0);
	int forestvsCW=rmCreateTypeDistanceConstraint("forest vs. CW", "CoveredWagon", 20.0);
	int avoidTC=rmCreateTypeDistanceConstraint("stuff vs TC", "TownCenter", 60.0);
	int shortAvoidTC=rmCreateTypeDistanceConstraint("stuff less vs TC", "TownCenter", 20.0);
	int avoidCW=rmCreateTypeDistanceConstraint("stuff vs CW", "CoveredWagon", 60.0);

   int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 20.0);
   int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);
   int invisConstraint=rmCreateClassDistanceConstraint("continent avoid invis continent", rmClassID("classInvis"), rmXFractionToMeters(0.15));
	if (cNumberNonGaiaPlayers >6)
		invisConstraint=rmCreateClassDistanceConstraint("continent avoid invis continent large map", rmClassID("classInvis"), rmXFractionToMeters(0.20));

   // Bonus area constraint.
   int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classbigContinent, 20.0);

   // Resource avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
   int avoidDeer=rmCreateTypeDistanceConstraint("deer avoids deer", "deer", 40.0);
   int avoidBerries=rmCreateTypeDistanceConstraint("berry vs berry", "berryBush", 60.0);
	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 40.0);
	int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 40.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "abstractNugget", 30.0);
    int avoidNuggetWater=rmCreateTypeDistanceConstraint("nugget vs. nugget water", "AbstractNugget", 80.0);
   int avoidLand = rmCreateTerrainDistanceConstraint("ship avoid land", "land", true, 15.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 20.0);
	if (cNumberNonGaiaPlayers < 3)
		longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land small map", "Land", false, 12.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "abstractFish", 10.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "humpbackWhale", 25.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 20.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 20);
	int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);

   // Unit avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);

   // Important object avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int nativeAvoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 20.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("sockets avoid each other", rmClassID("importantItem"), 40.0);
   int silverAvoidImportantItem=rmCreateClassDistanceConstraint("silver avoids sockets", rmClassID("importantItem"), 12.0);

   // Constraint to avoid water.
   int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 8.0);
   int avoidWater16 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 16.0);
	int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 20.0);


   // Text
   rmSetStatusText("",0.10);

	// DEFINE AREAS

	// Complex placement to avoid water and enemy players

	if(handedness < 0.5)  // NE ocean
	{
		// If only 2 players place as 2 points
		if(cNumberNonGaiaPlayers == 2)
		{
			rmPlacePlayer(1, 0.5, 0.85);
			rmPlacePlayer(2, 0.5, 0.15);
		}
		// Place by team if 2 teams and sane teams
		else if(cNumberTeams == 2 && rmGetNumberPlayersOnTeam(0) < 5 && rmGetNumberPlayersOnTeam(1) < 5)
		{
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.85, 0.05);
			rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.45, 0.65);
			rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
		}
		// otherwise just place in one arc FFA style
		else
		{
			rmSetPlacementSection(0.45, 0.05);
			rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
		}
	}
   else // SE ocean
	{
		// If only 2 players place as 2 points
		if(cNumberNonGaiaPlayers == 2)
		{
			rmPlacePlayer(1, 0.85, 0.5);
			rmPlacePlayer(2, 0.15, 0.5);
		}
		// Place by team if 2 teams and sane teams
		else if(cNumberTeams == 2 && rmGetNumberPlayersOnTeam(0) < 5 && rmGetNumberPlayersOnTeam(1) < 5)
		{
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.10, 0.30);
			rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.70, 0.90);
			rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
		}
		// otherwise just place in one arc FFA style
		else
		{
			rmSetPlacementSection(0.70, 0.30);
			rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
		}
	}

    // Set up player areas.
  float playerFraction=rmAreaTilesToFraction(1000);
  for(i=1; <cNumberPlayers){
    int id=rmCreateArea("Player"+i);
    rmSetPlayerArea(i, id);
		rmSetAreaWarnFailure(id, false);
    rmSetAreaSize(id, playerFraction, playerFraction);
		rmAddAreaToClass(id, classPlayer);
    rmSetAreaMinBlobs(id, 1);
    rmSetAreaMaxBlobs(id, 1);
    rmAddAreaConstraint(id, playerConstraint);
		rmAddAreaConstraint(id, avoidWater8);
    rmSetAreaLocPlayer(id, i);
		rmSetAreaCoherence(id, 0.9);
  }
   
   rmBuildAllAreas();


	// Text
   rmSetStatusText("",0.20);

	// Invisible continent added to have big continent avoid player areas

  int invisContinentID=rmCreateArea("invisible continent for constraint");
	rmSetAreaSize(invisContinentID, 0.01, 0.01);
  rmSetAreaWarnFailure(invisContinentID, false);

	if(handedness < 0.5) // NE ocean
	{
		rmSetAreaLocation(invisContinentID, 0.99, 0.5);
		rmAddAreaInfluenceSegment(invisContinentID, 0.95, 0.30, 0.99, 0.5);
		rmAddAreaInfluenceSegment(invisContinentID, 0.99, 0.5, 0.95, 0.70);
	}
	else	{			
		rmSetAreaLocation(invisContinentID, 0.5, 0.01);
		rmAddAreaInfluenceSegment(invisContinentID, 0.30, 0.05, 0.5, 0.01);
		rmAddAreaInfluenceSegment(invisContinentID, 0.5, 0.01, 0.70, 0.05);
	}
	rmAddAreaToClass(invisContinentID, rmClassID("classInvis"));
	rmSetAreaCoherence(invisContinentID, 0.8);
  
//	rmSetAreaBaseHeight(invisContinentID, 3);
//	rmSetAreaMix(invisContinentID, "carolina_grass");

   // Build the areas.
  rmBuildArea(invisContinentID);

  // Build up big continent called "big continent"
  int bigContinentID = -1;
  bigContinentID=rmCreateArea("big continent");
  rmSetAreaSize(bigContinentID, 0.40, 0.47); // 0.38 0.47
  rmSetAreaWarnFailure(bigContinentID, false);
  rmAddAreaConstraint(bigContinentID, invisConstraint);
  rmAddAreaToClass(bigContinentID, classbigContinent);

  rmSetAreaMinBlobs(bigContinentID, 10);
  rmSetAreaMaxBlobs(bigContinentID, 10);
  rmSetAreaMinBlobDistance(bigContinentID, rmXFractionToMeters(0.1));
  rmSetAreaMaxBlobDistance(bigContinentID, rmXFractionToMeters(0.4));

  rmSetAreaSmoothDistance(bigContinentID, 50);
  rmSetAreaMix(bigContinentID, "carolina_grass");
  rmSetAreaElevationType(bigContinentID, cElevTurbulence);
  rmSetAreaElevationVariation(bigContinentID, 4.0);
  rmSetAreaBaseHeight(bigContinentID, 3.5);
  rmSetAreaElevationMinFrequency(bigContinentID, 0.09);
  rmSetAreaElevationOctaves(bigContinentID, 3);
  rmSetAreaElevationPersistence(bigContinentID, 0.2);
  rmSetAreaElevationNoiseBias(bigContinentID, 1);
		
  rmSetAreaCoherence(bigContinentID, 0.15);

  // CHOOSE RIGHT OR LEFT-HANDED CONTINENT
  if(handedness < 0.5) // NE ocean
  {
    rmSetAreaLocation(bigContinentID, 0.25, 0.5);
    rmAddAreaInfluenceSegment(bigContinentID, 0.5, 0.0, 0.5, 1.0); 
    rmAddAreaInfluenceSegment(bigContinentID, 0.0, 0.5, 0.4, 0.5);
  }
  else // SE ocean
  {
    rmSetAreaLocation(bigContinentID, 0.5, 0.75);
    rmAddAreaInfluenceSegment(bigContinentID, 0.0, 0.5, 1.0, 0.5); 
    rmAddAreaInfluenceSegment(bigContinentID, 0.5, 1.0, 0.5, 0.6);
  }
		
  rmSetAreaEdgeFilling(bigContinentID, 10);
  rmSetAreaObeyWorldCircleConstraint(bigContinentID, false);

  rmBuildArea(bigContinentID);
  
  // Text
  rmSetStatusText("",0.30);

  // TRADE ROUTES
  int tradeRouteID = rmCreateTradeRoute();

  int socketID=rmCreateObjectDef("sockets for Trade Route");
  rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmAddObjectDefConstraint(socketID, avoidWater8);
  rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
  rmSetObjectDefAllowOverlap(socketID, true);
  rmSetObjectDefMinDistance(socketID, 0.0);
  rmSetObjectDefMaxDistance(socketID, 8.0);

  rmAddClosestPointConstraint(avoidWater16);
  vector tradeRoutePoint = cOriginVector;

	if(handedness < 0.5) // Ocean to NE
	{
		tradeRoutePoint = rmFindClosestPoint(0.3, 0.05, 20.0);
		rmAddTradeRouteWaypoint(tradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));

		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.5, 6, 6);

		tradeRoutePoint = rmFindClosestPoint(0.3, 0.95, 20.0);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
	}
	else // Ocean to SE
	{
		tradeRoutePoint = rmFindClosestPoint(0.05, 0.7, 20.0);
		rmAddTradeRouteWaypoint(tradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)));

		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.5, 6, 6);

		tradeRoutePoint = rmFindClosestPoint(0.95, 0.7, 20.0);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, rmXMetersToFraction(xsVectorGetX(tradeRoutePoint)), rmZMetersToFraction(xsVectorGetZ(tradeRoutePoint)), 4, 6);
	} 

   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route");  

  // Text
  rmSetStatusText("",0.40);
   
  // add the sockets along the trade route.
  rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
  vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.20);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.40);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.60);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.80);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	rmClearClosestPointConstraints();
  
	// PLAYER STARTING RESOURCES

	// Place TC or CW now. Find location later to place other resources.

	int TCID = rmCreateObjectDef("player TC");
	if ( rmGetNomadStart())
		rmAddObjectDefItem(TCID, "coveredWagon", 1, 0);
	else
		rmAddObjectDefItem(TCID, "townCenter", 1, 0);
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 20.0);
	rmAddObjectDefConstraint(TCID, avoidTradeRoute);
   rmAddObjectDefConstraint(TCID, TCvsTC);
   rmAddObjectDefConstraint(TCID, CWvsCW);
   rmAddObjectDefConstraint(TCID, avoidImpassableLand);
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	}

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
  rmSetObjectDefMinDistance(startingUnits, 6.0);
  rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
  rmAddObjectDefConstraint(startingUnits, shortAvoidImpassableLand);

	int playerSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmSetObjectDefMinDistance(playerSilverID, 18.0);
	rmSetObjectDefMaxDistance(playerSilverID, 22.0);
	rmAddObjectDefConstraint(playerSilverID, avoidAll);
  rmAddObjectDefConstraint(playerSilverID, shortAvoidImpassableLand);

	int playerCrateID=rmCreateObjectDef("bonus starting crates");
  rmAddObjectDefItem(playerCrateID, "crateOfFood", rmRandInt(2, 3), 4.0);
  rmAddObjectDefItem(playerCrateID, "crateOfWood", rmRandInt(1, 2), 4.0);
  rmAddObjectDefItem(playerCrateID, "crateOfCoin", 1, 4.0);
  rmSetObjectDefMinDistance(playerCrateID, 6);
  rmSetObjectDefMaxDistance(playerCrateID, 10);
	rmAddObjectDefConstraint(playerCrateID, avoidAll);
  rmAddObjectDefConstraint(playerCrateID, shortAvoidImpassableLand);

	int playerBerryID=rmCreateObjectDef("player berries");
   rmAddObjectDefItem(playerBerryID, "berryBush", rmRandInt(2,3), 2.0);
   rmSetObjectDefMinDistance(playerBerryID, 10);
   rmSetObjectDefMaxDistance(playerBerryID, 15);
	rmAddObjectDefConstraint(playerBerryID, avoidAll);
   rmAddObjectDefConstraint(playerBerryID, shortAvoidImpassableLand);

	int farBerriesID=rmCreateObjectDef("far berries");
  rmAddObjectDefItem(farBerriesID, "berryBush", rmRandInt(5,8), 4.0);
  rmSetObjectDefMinDistance(farBerriesID, 80);
  rmSetObjectDefMaxDistance(farBerriesID, 120);
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidTC);
	rmAddObjectDefConstraint(farBerriesID, avoidCW);
	rmAddObjectDefConstraint(farBerriesID, avoidBerries);
  rmAddObjectDefConstraint(farBerriesID, avoidImpassableLand);

	int playerTreeID=rmCreateObjectDef("player trees");
  rmAddObjectDefItem(playerTreeID, "TreeCarolinaGrass", 1, 0.0);
  rmSetObjectDefMinDistance(playerTreeID, 8);
  rmSetObjectDefMaxDistance(playerTreeID, 12);
	rmAddObjectDefConstraint(playerTreeID, avoidAll);
  rmAddObjectDefConstraint(playerTreeID, shortAvoidImpassableLand);

	int waterFlagID=rmCreateObjectDef("HC water flag "+i);
	rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
  rmAddClosestPointConstraint(flagEdgeConstraint);
	rmAddClosestPointConstraint(flagVsFlag);
	rmAddClosestPointConstraint(bigContinentConstraint);
	rmAddClosestPointConstraint(fishLand);
	 
   // Nuggets per player
	int nugget1= rmCreateObjectDef("nugget easy"); 
	rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(nugget1, avoidNugget);
  rmAddObjectDefConstraint(nugget1, avoidTradeRoute);
  rmAddObjectDefConstraint(nugget1, avoidAll);
	rmSetObjectDefMinDistance(nugget1, 40.0);
	rmSetObjectDefMaxDistance(nugget1, 60.0);

	int nugget2= rmCreateObjectDef("nugget medium"); 
	rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmSetObjectDefMinDistance(nugget2, 0.0);
	rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(nugget2, avoidNugget);
  rmAddObjectDefConstraint(nugget2, avoidTC);
  rmAddObjectDefConstraint(nugget2, avoidCW);
  rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
  rmAddObjectDefConstraint(nugget2, avoidAll);
  rmAddObjectDefConstraint(nugget2, avoidWater20);
	rmSetObjectDefMinDistance(nugget2, 80.0);
	rmSetObjectDefMaxDistance(nugget2, 120.0);

  // Text
   rmSetStatusText("",0.50); 
	
	// FOOD	
  int nearDeerID=rmCreateObjectDef("deer herds near town");
  rmAddObjectDefItem(nearDeerID, "deer", rmRandInt(8,10), 10.0);
  rmSetObjectDefMinDistance(nearDeerID, 30);
  rmSetObjectDefMaxDistance(nearDeerID, 40);
  rmAddObjectDefConstraint(nearDeerID, avoidDeer);
  rmAddObjectDefConstraint(nearDeerID, avoidAll);
  rmAddObjectDefConstraint(nearDeerID, avoidImpassableLand);
  rmSetObjectDefCreateHerd(nearDeerID, true);

	int farDeerID=rmCreateObjectDef("deer herds far away");
	int bonusChance=rmRandFloat(0, 1);
  if(bonusChance<0.5)   
    rmAddObjectDefItem(farDeerID, "deer", rmRandInt(8,10), 10.0);
  else
    rmAddObjectDefItem(farDeerID, "deer", rmRandInt(12,16), 10.0);
  rmSetObjectDefMinDistance(farDeerID, 60);
  rmSetObjectDefMaxDistance(farDeerID, 90);
  rmAddObjectDefConstraint(farDeerID, avoidDeer);
	rmAddObjectDefConstraint(farDeerID, avoidAll);
	rmAddObjectDefConstraint(farDeerID, avoidTC);
	rmAddObjectDefConstraint(farDeerID, avoidCW);
  rmAddObjectDefConstraint(farDeerID, avoidImpassableLand);
  rmSetObjectDefCreateHerd(farDeerID, true);
   
  // NATIVE AMERICANS

  // Text
  rmSetStatusText("",0.60);
   
  if (subCiv0 == rmGetCivID("Seminoles")) // center
  {  
    int seminoleVillageID = -1;
    int seminoleVillageType = rmRandInt(1,5);
    seminoleVillageID = rmCreateGrouping("Seminole village 1", "native Seminole village "+seminoleVillageType);
    rmSetGroupingMinDistance(seminoleVillageID, 0.0);
    rmSetGroupingMaxDistance(seminoleVillageID, 30);
    rmAddGroupingConstraint(seminoleVillageID, avoidImpassableLand);
    rmAddGroupingToClass(seminoleVillageID, rmClassID("importantItem"));
    rmAddGroupingConstraint(seminoleVillageID, avoidTradeRoute);
    rmAddGroupingConstraint(seminoleVillageID, avoidImportantItem);
    rmAddGroupingConstraint(seminoleVillageID, nativeAvoidTradeRouteSocket);
    rmAddGroupingConstraint(seminoleVillageID, avoidTC);
    rmAddGroupingConstraint(seminoleVillageID, avoidCW);
    if (handedness < 0.5)
      rmPlaceGroupingAtLoc(seminoleVillageID, 0, 0.05, 0.5);
    else //handedness > 0.5
      rmPlaceGroupingAtLoc(seminoleVillageID, 0, 0.5, 0.95);
	}

   if (subCiv1 == rmGetCivID("Seminoles")) // beach
   {   
      int seminole2VillageID = -1;
      int seminole2VillageType = rmRandInt(1,5);
      seminole2VillageID = rmCreateGrouping("Seminole village", "native Seminole village "+seminole2VillageType);
      rmSetGroupingMinDistance(seminole2VillageID, 0.0);
      rmSetGroupingMaxDistance(seminole2VillageID, 40);
      rmAddGroupingConstraint(seminole2VillageID, avoidImpassableLand);
      rmAddGroupingToClass(seminole2VillageID, rmClassID("importantItem"));
      rmAddGroupingConstraint(seminole2VillageID, avoidTradeRoute);
      rmAddGroupingConstraint(seminole2VillageID, avoidImportantItem);
      rmAddGroupingConstraint(seminole2VillageID, nativeAvoidTradeRouteSocket);
      rmAddGroupingConstraint(seminole2VillageID, avoidTC);
      rmAddGroupingConstraint(seminole2VillageID, avoidCW);
      if (handedness < 0.5)
        rmPlaceGroupingAtLoc(seminole2VillageID, 0, 0.65, 0.5); 
      else //handedness > 0.5
        rmPlaceGroupingAtLoc(seminole2VillageID, 0, 0.5, 0.35); 
	}

	if (subCiv2 == rmGetCivID("Cherokee")) // edge
  {   
    int cherokeeVillageID = -1;
    int cherokeeVillageType = rmRandInt(1,5);
    cherokeeVillageID = rmCreateGrouping("cherokee village 2", "native cherokee village "+cherokeeVillageType);
    rmSetGroupingMinDistance(cherokeeVillageID, 0.0);
    rmSetGroupingMaxDistance(cherokeeVillageID, 30);
    rmAddGroupingConstraint(cherokeeVillageID, avoidImpassableLand);
    rmAddGroupingToClass(cherokeeVillageID, rmClassID("importantItem"));
    rmAddGroupingConstraint(cherokeeVillageID, avoidTradeRoute);
    rmAddGroupingConstraint(cherokeeVillageID, avoidImportantItem);
    rmAddGroupingConstraint(cherokeeVillageID, nativeAvoidTradeRouteSocket);
    rmAddGroupingConstraint(cherokeeVillageID, shortAvoidTC);

    if (handedness < 0.5)
    {
      rmPlaceGroupingAtLoc(cherokeeVillageID, 0, 0.25, 0.30); // NE
    }
    else
    {
       rmPlaceGroupingAtLoc(cherokeeVillageID, 0, 0.30, 0.75); // SE
    }
	}

	if(subCiv3 == rmGetCivID("Cherokee")) // edge
  {
    int cherokee2VillageID = -1;
    int cherokee2VillageType = rmRandInt(1,5);
    cherokee2VillageID = rmCreateGrouping("cherokee village 3", "native cherokee village "+cherokee2VillageType);
    rmSetGroupingMinDistance(cherokee2VillageID, 0.0);
    rmSetGroupingMaxDistance(cherokee2VillageID, 30);
    rmAddGroupingConstraint(cherokee2VillageID, avoidImpassableLand);
    rmAddGroupingToClass(cherokee2VillageID, rmClassID("importantItem"));
    rmAddGroupingConstraint(cherokee2VillageID, avoidTradeRoute);
    rmAddGroupingConstraint(cherokee2VillageID, avoidImportantItem);
    rmAddGroupingConstraint(cherokee2VillageID, nativeAvoidTradeRouteSocket);
    rmAddGroupingConstraint(cherokee2VillageID, shortAvoidTC);

		if (handedness < 0.5){
			rmPlaceGroupingAtLoc(cherokee2VillageID, 0, 0.25, 0.70); // NE
		}
		else{
			rmPlaceGroupingAtLoc(cherokee2VillageID, 0, 0.70, 0.75); //SE
		}
	}

   // Text
   rmSetStatusText("",0.70);

	// Place Far Silver

	int silverID = -1;
	int silverCount = (cNumberNonGaiaPlayers*2 + rmRandInt(4,6));
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount){
    silverID = rmCreateObjectDef("silver "+i);
    rmAddObjectDefItem(silverID, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(silverID, 0.0);
    rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, avoidFastCoin);
    rmAddObjectDefConstraint(silverID, avoidAll);
    rmAddObjectDefConstraint(silverID, avoidTC);
		rmAddObjectDefConstraint(silverID, avoidCW);
		rmAddObjectDefConstraint(silverID, silverAvoidImportantItem);
    rmAddObjectDefConstraint(silverID, longAvoidImpassableLand);
    rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
  }

   // Create an island with crates

	if(rmRandFloat(0,1) < 0.75){
		int shipwreckIslandID=rmCreateArea("shipwreck island");
		rmSetAreaSize(shipwreckIslandID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
		rmSetAreaTerrainType(shipwreckIslandID, "Carolinas\shoreline1");
		rmSetAreaBaseHeight(shipwreckIslandID, 3.5);
		rmSetAreaHeightBlend(shipwreckIslandID, 1.0);
		rmSetAreaSmoothDistance(shipwreckIslandID, 10);
		rmSetAreaWarnFailure(shipwreckIslandID, false);
		rmSetAreaCoherence(shipwreckIslandID, 1.0);
		rmAddAreaConstraint(shipwreckIslandID, bigContinentConstraint);
		rmAddAreaConstraint(shipwreckIslandID, longPlayerConstraint);
		rmBuildArea(shipwreckIslandID);

		int islandCrateID= rmCreateObjectDef("island crates"); 
		rmAddObjectDefItem(islandCrateID, "TreeCaribbean", rmRandInt(1,2), 1);
		rmAddObjectDefItem(islandCrateID, "CrateofFood", rmRandInt(0,2), 3);
		rmAddObjectDefItem(islandCrateID, "CrateofWood", rmRandInt(0,2), 4);
		rmAddObjectDefItem(islandCrateID, "CrateofCoin", rmRandInt(0,1), 4);
		rmPlaceObjectDefInArea(islandCrateID, 0, rmAreaID("shipwreck island"), 1);
	}
   
   // fish

   int fishID=rmCreateObjectDef("sardine");
   rmAddObjectDefItem(fishID, "FishSardine", 1, 0.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);

   int fish2ID=rmCreateObjectDef("tarpon");
   rmAddObjectDefItem(fish2ID, "FishTarpon", 1, 0.0);
   rmSetObjectDefMinDistance(fish2ID, 0.0);
   rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fish2ID, fishVsFishID);
   rmAddObjectDefConstraint(fish2ID, fishLand);
   rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	int whaleID=rmCreateObjectDef("whale");
   rmAddObjectDefItem(whaleID, "humpbackWhale", 1, 9.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

   // Text
   rmSetStatusText("",0.80); 
 
	// Place player starting resources

	for(i=1; <cNumberPlayers)
	{
          
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
    vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

		if (rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(playerCrateID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		
		rmPlaceObjectDefAtLoc(playerBerryID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(farBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		
		rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

		rmPlaceObjectDefAtLoc(nugget1, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(nugget1, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(nugget2, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

		rmPlaceObjectDefAtLoc(nearDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(farDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

		rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
	}

	rmClearClosestPointConstraints();

	// Text
   rmSetStatusText("",0.90);

	// Place extra nuggets not per player
  
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
    float yLoc = 0.5;
    float walk = 0.075;
    
    //~ if(randLoc == 1)
      //~ yLoc = .5;
    
    //~ else
      //~ yLoc = .8;
      
    //~ if(cNumberTeams > 2) {
      //~ yLoc = rmRandFloat(.1, .9);
      //~ walk = 0.25;
    //~ }
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

	int nugget3= rmCreateObjectDef("nugget hard"); 
	rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nugget3, 0.0);
	rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(nugget3, avoidNugget);
  rmAddObjectDefConstraint(nugget3, avoidTC);
  rmAddObjectDefConstraint(nugget3, avoidCW);
  rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
  rmAddObjectDefConstraint(nugget3, avoidAll);
  rmAddObjectDefConstraint(nugget3, avoidWater20);
	rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	if (rmRandFloat(0,1) < 0.1)
	{
		int nugget4= rmCreateObjectDef("nugget nuts"); 
		rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmSetObjectDefMinDistance(nugget4, 0.0);
		rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
    rmAddObjectDefConstraint(nugget4, avoidNugget);
    rmAddObjectDefConstraint(nugget4, avoidTC);
    rmAddObjectDefConstraint(nugget4, avoidCW);
    rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
    rmAddObjectDefConstraint(nugget4, avoidAll);
    rmAddObjectDefConstraint(nugget4, avoidWater20);
		rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(0,3));
	}

  // FORESTS
  int forestTreeID = 0;
  int numTries=5*cNumberNonGaiaPlayers;
  int failCount=0;
  for (i=0; <numTries) {   
    int forest=rmCreateArea("forest "+i, rmAreaID("big continent"));
    rmSetAreaWarnFailure(forest, false);
    rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
    rmSetAreaForestType(forest, "carolina pine forest");
    // rmSetAreaForestType(forest, "dunes");
    rmSetAreaForestDensity(forest, 0.8);
    rmSetAreaForestClumpiness(forest, 0.6);
    rmSetAreaForestUnderbrush(forest, 0.0);
    rmSetAreaMinBlobs(forest, 1);
    rmSetAreaMaxBlobs(forest, 5);
    rmSetAreaMinBlobDistance(forest, 16.0);
    rmSetAreaMaxBlobDistance(forest, 70.0);
    rmSetAreaCoherence(forest, 0.4);
    rmSetAreaSmoothDistance(forest, 0);
    rmAddAreaToClass(forest, rmClassID("classForest")); 
    rmAddAreaConstraint(forest, forestConstraint);
    rmAddAreaConstraint(forest, avoidAll);
    rmAddAreaConstraint(forest, forestvsTC);
    rmAddAreaConstraint(forest, forestvsCW); 
    rmAddAreaConstraint(forest, longAvoidImpassableLand); 
    rmAddAreaConstraint(forest, avoidTradeRoute);

    if(rmBuildArea(forest)==false) {
      // Stop trying once we fail 3 times in a row.
      failCount++;
      if(failCount==5)
        break;
    }
    else
      failCount=0; 
  } 

   // Text
   rmSetStatusText("",1.0); 

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

}  
