// Painted Desert
// Jan 2006
// Dec 06 - YP update
// Main entry point for random map script
include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

// ***************** CHOOSE NATIVES ******************
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;

   
   int nativeMix=rmRandInt(0,1);
   
   if (rmAllocateSubCivs(4) == true)
   {
		
		if (nativeMix <= 0.5)
		{
	   
			// Apache Outside, Navajo Inside.
			subCiv0=rmGetCivID("apache");
			if (subCiv0 >= 0)
				rmSetSubCiv(0, "apache");

			subCiv3=rmGetCivID("apache");
			if (subCiv3 >= 0)
				rmSetSubCiv(3, "apache");

			subCiv1=rmGetCivID("navajo");
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "navajo");

			subCiv2=rmGetCivID("navajo");
			if (subCiv2 >= 0)
				rmSetSubCiv(2, "navajo");
		}
		else
		{
			// Navajo Outside, Apache Inside.
			subCiv0=rmGetCivID("navajo");
			if (subCiv0 >= 0)
				rmSetSubCiv(0, "navajo");

			subCiv3=rmGetCivID("navajo");
			if (subCiv3 >= 0)
				rmSetSubCiv(3, "navajo");

			subCiv1=rmGetCivID("apache");
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "apache");

			subCiv2=rmGetCivID("apache");
			if (subCiv2 >= 0)
				rmSetSubCiv(2, "apache");

		}

   }
// ********************* MAP PARAMETERS ************************
	// Picks the map size
	//  int playerTiles=10000; old setting
	int playerTiles = 8000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 9000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 10000;		
/*
	if(cMapSize == 1)
	{
      playerTiles = 18000;
      rmEchoInfo("Large map");
	}
*/

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.5, 3.0);  // DAL - original
	rmSetMapElevationParameters(cElevTurbulence, 0.02, 5, 0.7, 8.0);
	rmSetMapElevationHeightBlend(1);

	// Picks a default water height
	rmSetSeaLevel(4.0);

    // Picks default terrain and water
	rmSetSeaType("Amazon River");


	//float terrainPicker = rmRandFloat(0.0, 1.0);
	//if (terrainPicker <= 0.5)
	//{
		rmSetBaseTerrainMix("painteddesert_groundmix_1");
	//}
	//else
	//{
	//	rmSetBaseTerrainMix("painteddesert_groundmix_4");
	//}

	rmTerrainInitialize("painteddesert\pd_ground_diffuse_d", 4.0);
	rmSetMapType("sonora");
	rmSetMapType("desert");
	rmSetMapType("land");
	rmSetLightingSet("Sonora");

	// Choose mercs.
	chooseMercs();

	// Corner constraint.
	rmSetWorldCircleConstraint(true);

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
	rmDefineClass("classNugget");
	rmDefineClass("center");
	int canyon=rmDefineClass("canyon");

	int avoidVultures=rmCreateTypeDistanceConstraint("avoids Vultures", "PropVulturePerching", 40.0);
	int avoidCanyons=rmCreateClassDistanceConstraint("avoid canyons", rmClassID("canyon"), 35.0);
	int shortAvoidCanyons=rmCreateClassDistanceConstraint("short avoid canyons", rmClassID("canyon"), 15.0);
	int avoidNatives=rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 15.0);
	int avoidSilver=rmCreateTypeDistanceConstraint("gold avoid gold", "Mine", 55.0);
	int shortAvoidSilver=rmCreateTypeDistanceConstraint("short gold avoid gold", "Mine", 20.0);
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
	int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), rmXFractionToMeters(0.23));
	int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), rmXFractionToMeters(0.10));
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 50.0);
	int shortForestConstraint=rmCreateClassDistanceConstraint("short forest vs. forest", rmClassID("classForest"), 10.0);
	int mediumForestConstraint=rmCreateClassDistanceConstraint("medium forest vs. forest", rmClassID("classForest"), 25.0);
	int avoidCow=rmCreateTypeDistanceConstraint("cow avoids cow", "cow", 40.0);
	int shortAvoidImportantItem=rmCreateClassDistanceConstraint("short avoid important", rmClassID("importantItem"), 5.0);

	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int avoidBuzzards=rmCreateTypeDistanceConstraint("buzzard avoid buzzard", "BuzzardFlock", 70.0);
	int avoidBison=rmCreateTypeDistanceConstraint("avoid Bison", "Bison", 25);
	int avoidPronghorn=rmCreateTypeDistanceConstraint("avoid Pronghorn", "Pronghorn", 25);
	int avoidTradeRoute=rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("long stay away from players", classPlayer, 40.0);
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 20.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players short", classPlayer, 8.0);
	int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 60.0);
	int shortAvoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget short", rmClassID("classNugget"), 8.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid Trade Socket", "sockettraderoute", 10);
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 8.0);
	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

		
// starting resources

	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(TCID, "townCenter", 1, 0);
	}
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 10.0);
	rmAddObjectDefConstraint(TCID, avoidTradeRoute);
	rmAddObjectDefToClass(TCID, rmClassID("player"));
	rmAddObjectDefToClass(TCID, rmClassID("startingUnit"));

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 8.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startingUnits, avoidStartingUnits);

	int playerSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
	rmSetObjectDefMinDistance(playerSilverID, 20.0);
	rmSetObjectDefMaxDistance(playerSilverID, 25.0);
	//rmAddObjectDefConstraint(playerSilverID, avoidAll);
	rmAddObjectDefToClass(playerSilverID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerSilverID, avoidStartingUnits);

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreePaintedDesert", rmRandInt(9,10), 4.0);
	// rmAddObjectDefItem(StartAreaTreeID, "UnderbrushDesert", rmRandInt(4,6), 4.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 9);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 14);
	rmAddObjectDefToClass(StartAreaTreeID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);
	//rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidSilver);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnits);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidResource);


 
//   ----------------------------Bison Herd-----------------------------------

	int startBisonID = rmCreateObjectDef("starting bison");
	rmAddObjectDefItem(startBisonID, "bison", rmRandInt(7,9), 8.0);
	rmSetObjectDefCreateHerd(startBisonID, true);
	rmSetObjectDefMinDistance(startBisonID, 16);
	rmSetObjectDefMaxDistance(startBisonID, 20);
	rmAddObjectDefToClass(startBisonID, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startBisonID, avoidImpassableLand);
	rmAddObjectDefConstraint(startBisonID, shortAvoidImportantItem);
	// rmAddObjectDefConstraint(startBisonID, avoidTradeRoute);
	rmAddObjectDefConstraint(startBisonID, avoidStartingUnits);
	rmAddObjectDefConstraint(startBisonID, avoidResource);

	
//-----------------------------------------------------------------------------
//


// --> TCID, startingUnits, playerSilverID, StartAreaTreeID and StartTurkeyID all added to rmClassID("startingUnit")
	
// Text
	rmSetStatusText("",0.2);


	int canyonConstraint=rmCreateClassDistanceConstraint("canyons start away from each other", canyon, 5.0);

	int failCount=0;
	int numTries=cNumberNonGaiaPlayers*15;


		// ****************************** PLACE PLAYERS *********************

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
// 2 team and FFA support
	float OneVOnePlacement=rmRandFloat(0, 1);
	if (cNumberNonGaiaPlayers == 2)
	{
		if ( OneVOnePlacement < 0.5)
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.2, 0.4, 0.2, 0.6, 0, 0.05);

			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.8, 0.4, 0.8, 0.6, 0, 0.05);
		}
		else
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.8, 0.4, 0.8, 0.6, 0, 0.05);

			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.2, 0.4, 0.2, 0.6, 0, 0.05);
		}
	}
	else if ( cNumberTeams <= 2 && teamZeroCount <= 4 && teamOneCount <= 4)
	{
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.6, 0.85); // 0.5   KSW ---> Was (0.35, 0.6)
		rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.38, 0.40, 0);

		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.1, 0.35); // 0.5  KSW ---> Was (0.85, 0.10)
		rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.38, 0.40, 0);
	}
	else
	{	
		rmSetTeamSpacingModifier(0.7);
		rmPlacePlayersCircular(0.42, 0.44, 0.0);
	}



		 // Build an invisible "west desert" area.
		int westDesertID = rmCreateArea("west desert");
		rmSetAreaLocation(westDesertID, 0.45, 1.0); 
		rmSetAreaWarnFailure(westDesertID, false);
		rmSetAreaSize(westDesertID, 0.2, 0.2);
		rmSetAreaCoherence(westDesertID, 0.5);
		// rmAddAreaInfluenceSegment(westDesertID, 0.45, 0.1, 0., 0.9);
		rmSetAreaTerrainType(westDesertID, "texas\ground4_tex");
		rmAddAreaTerrainLayer(westDesertID, "painteddesert\pd_ground_diffuse_d", 0, 4);
		rmAddAreaTerrainLayer(westDesertID, "painteddesert\pd_ground_diffuse_e", 4, 10);
		rmAddAreaTerrainLayer(westDesertID, "painteddesert\pd_ground_diffuse_f", 10, 16);
		rmSetAreaObeyWorldCircleConstraint(westDesertID, false);
		rmSetAreaMix(westDesertID, "painteddesert_groundmix_2");
		rmBuildArea(westDesertID);
	

	
	
	// ----------------------- *** Set up player areas *** ---------------------


	float playerFraction=rmAreaTilesToFraction(120);   //KSW ---> Was 100
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
		//  rmAddAreaConstraint(id, playerConstraint); 
		//  rmAddAreaConstraint(id, playerEdgeConstraint); 
		rmSetAreaLocPlayer(id, i);

		rmSetAreaMix(id, "painteddesert_groundmix_4");  //KSW ---> Was groundmix_2
		rmSetAreaWarnFailure(id, false);
	}
	// Build the areas.
   rmBuildAllAreas();


   
 /*
   
   // ******************************* PLACE BIG MESA ****************************


	int bigMesaID = rmCreateObjectDef("large mesa"); 
	rmAddObjectDefItem(bigMesaID, "BigPropPaintedDesert", 1, 0);
																					//<--- Mesa Looks Weird ************
	rmSetObjectDefMinDistance(bigMesaID, 0.0);
	rmSetObjectDefMaxDistance(bigMesaID, 0.0);
	rmAddObjectDefToClass(bigMesaID, rmClassID("importantItem"));
	rmPlaceObjectDefAtLoc(bigMesaID, 0, 0.45, 0.9);


*/

//    *********************************** PLACE NATIVES *************************

	if (subCiv0 == rmGetCivID("apache"))
	{  
		int apacheVillageID = -1;
		int apacheVillageType = rmRandInt(1,5);
		int randomPlacement = rmRandInt(1,10);
		apacheVillageID = rmCreateGrouping("apache village", "native apache village "+apacheVillageType);
		rmSetGroupingMinDistance(apacheVillageID, 0.0);
		rmSetGroupingMaxDistance(apacheVillageID, 20.0);
		rmAddGroupingConstraint(apacheVillageID, avoidImpassableLand);
		rmAddGroupingToClass(apacheVillageID, rmClassID("natives"));
		rmAddGroupingToClass(apacheVillageID, rmClassID("importantItem"));
			if (randomPlacement <= 8)
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.45, 0.85);  //KSW ---> Was 0.82, 0.5
			else
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.45, 0.83);
		
	}

	
	if (subCiv0 == rmGetCivID("navajo"))
	{  
		int navajoVillageID = -1;
		int navajoVillageType = rmRandInt(1,5);
		randomPlacement = rmRandInt(1,10);
		navajoVillageID = rmCreateGrouping("navajo village", "native navajo village "+navajoVillageType);
		rmSetGroupingMinDistance(navajoVillageID, 0.0);
		rmSetGroupingMaxDistance(navajoVillageID, 20.0);
		rmAddGroupingConstraint(navajoVillageID, avoidImpassableLand);
		rmAddGroupingToClass(navajoVillageID, rmClassID("natives"));
		rmAddGroupingToClass(navajoVillageID, rmClassID("importantItem"));
			if (randomPlacement <= 8)
			rmPlaceGroupingAtLoc(navajoVillageID, 0, 0.45, 0.85);  //KSW ---> Was 0.82, 0.5
			else
			rmPlaceGroupingAtLoc(navajoVillageID, 0, 0.45, 0.83);
		
	}

	if (subCiv1 == rmGetCivID("navajo"))
	{
		navajoVillageID = -1;
		navajoVillageType = rmRandInt(1,5);
		randomPlacement = rmRandInt(1,10);
		navajoVillageID = rmCreateGrouping("navajo village", "native navajo village "+navajoVillageType);
		rmSetGroupingMinDistance(navajoVillageID, 0.0);
		rmSetGroupingMaxDistance(navajoVillageID, 20.0);
		rmAddGroupingConstraint(navajoVillageID, avoidImpassableLand);
		rmAddGroupingToClass(navajoVillageID, rmClassID("natives"));
		
		if (randomPlacement <= 8)
			rmPlaceGroupingAtLoc(navajoVillageID, 0, 0.48, 0.6);
		else
			rmPlaceGroupingAtLoc(navajoVillageID, 0, 0.48, 0.63);
		
	}

	if (subCiv1 == rmGetCivID("apache"))
	{
		apacheVillageID = -1;
		apacheVillageType = rmRandInt(1,5);
		randomPlacement = rmRandInt(1,10);
		apacheVillageID = rmCreateGrouping("apache village", "native apache village "+apacheVillageType);
		rmSetGroupingMinDistance(apacheVillageID, 0.0);
		rmSetGroupingMaxDistance(apacheVillageID, 20.0);
		rmAddGroupingConstraint(apacheVillageID, avoidImpassableLand);
		rmAddGroupingToClass(apacheVillageID, rmClassID("natives"));
		
		if (randomPlacement <= 8)
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.48, 0.6);
		else
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.48, 0.63);
		
	}

	if (subCiv2 == rmGetCivID("navajo"))
	{
		navajoVillageID = -1;
		navajoVillageType = rmRandInt(1,5);
		randomPlacement = rmRandInt(1,10);
		navajoVillageID = rmCreateGrouping("navajo village2", "native navajo village "+navajoVillageType);
		rmSetGroupingMinDistance(navajoVillageID, 0.0);
		rmSetGroupingMaxDistance(navajoVillageID, 20.0);
		rmAddGroupingConstraint(navajoVillageID, avoidImpassableLand);
		rmAddGroupingToClass(navajoVillageID, rmClassID("natives"));
		
		if (randomPlacement <= 8)
			rmPlaceGroupingAtLoc(navajoVillageID, 0, 0.52, 0.4);
		else
			rmPlaceGroupingAtLoc(navajoVillageID, 0, 0.52, 0.33);
	}

	if (subCiv2 == rmGetCivID("apache"))
	{
		apacheVillageID = -1;
		apacheVillageType = rmRandInt(1,5);
		randomPlacement = rmRandInt(1,10);
		apacheVillageID = rmCreateGrouping("apache village2", "native apache village "+apacheVillageType);
		rmSetGroupingMinDistance(apacheVillageID, 0.0);
		rmSetGroupingMaxDistance(apacheVillageID, 20.0);
		rmAddGroupingConstraint(apacheVillageID, avoidImpassableLand);
		rmAddGroupingToClass(apacheVillageID, rmClassID("natives"));
		
		if (randomPlacement <= 8)
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.52, 0.4);
		else
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.52, 0.33);
	}
	
	if (subCiv3 == rmGetCivID("navajo"))
	{
		navajoVillageID = -1;
		navajoVillageType = rmRandInt(1,5);
		randomPlacement = rmRandInt(1,10);
		navajoVillageID = rmCreateGrouping("navajo village2", "native navajo village "+navajoVillageType);
		rmSetGroupingMinDistance(navajoVillageID, 0.0);
		rmSetGroupingMaxDistance(navajoVillageID, 20.0);
		rmAddGroupingConstraint(navajoVillageID, avoidImpassableLand);
		rmAddGroupingToClass(navajoVillageID, rmClassID("natives"));
		
		if (randomPlacement <= 8)
			rmPlaceGroupingAtLoc(navajoVillageID, 0, 0.55, 0.11);
		else
			rmPlaceGroupingAtLoc(navajoVillageID, 0, 0.55, 0.17);
		
	}

	if (subCiv3 == rmGetCivID("apache"))
	{
		apacheVillageID = -1;
		apacheVillageType = rmRandInt(1,5);
		randomPlacement = rmRandInt(1,10);
		apacheVillageID = rmCreateGrouping("apache village2", "native apache village "+apacheVillageType);
		rmSetGroupingMinDistance(apacheVillageID, 0.0);
		rmSetGroupingMaxDistance(apacheVillageID, 20.0);
		rmAddGroupingConstraint(apacheVillageID, avoidImpassableLand);
		rmAddGroupingToClass(apacheVillageID, rmClassID("natives"));
		
		if (randomPlacement <= 8)
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.55, 0.11);
		else
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.55, 0.17);
		
	}



//**************************************** cliff embellishments *********************************************
	
	for(i=0; <numTries)
	{
		int cliffHeight=rmRandInt(3,6);     //KSW ---> Was 2, 8
		int mesaID=rmCreateArea("mesa"+i);
		rmSetAreaSize(mesaID, rmAreaTilesToFraction(4), rmAreaTilesToFraction(70));  // used to be 300 KSW ---> Used to be 200
		rmSetAreaWarnFailure(mesaID, false);
		rmSetAreaCliffType(mesaID, "Painteddesert");
		rmAddAreaToClass(mesaID, rmClassID("canyon"));	// Attempt to keep cliffs away from each other.
		rmSetAreaCliffEdge(mesaID, 1, 1.0, 0.1, 1.0, 0);
		/*  if (cliffHeight <= 5)
		rmSetAreaCliffHeight(mesaID, rmRandInt(3,5), 1.0, 1.0);
		else */
		rmSetAreaCliffHeight(mesaID, rmRandInt(3,8), 1.0, 1.0);  // KSW --> digs into ground to make ditch. Now only grows up. Was (4, 10)
		rmAddAreaConstraint(mesaID, avoidCanyons);
		rmAddAreaConstraint(mesaID, avoidNatives);
		//rmSetAreaMinBlobs(mesaID, 3);
		//rmSetAreaMaxBlobs(mesaID, 5);
		//rmSetAreaMinBlobDistance(mesaID, 3.0);
		//rmSetAreaMaxBlobDistance(mesaID, 5.0);
		rmSetAreaCoherence(mesaID, 0.5);
		rmAddAreaConstraint(mesaID, playerConstraint); 
	//	rmAddAreaConstraint(mesaID, avoidTradeRouteSockets);
	//	rmAddAreaConstraint(mesaID, avoidTradeRoute);
		rmAddAreaConstraint(mesaID, shortAvoidSilver);
		rmAddAreaConstraint(mesaID, avoidStartingUnits);
		rmAddAreaConstraint(mesaID, shortAvoidImportantItem);  // Added New
		if(rmBuildArea(mesaID)==false)
		{
			// Stop trying once we fail 2 times in a row.
			failCount++;
			if(failCount==2)
				break;
		}
		else
			failCount=0;
	}

// Text
rmSetStatusText("",0.4);
	
	
// ------------------------- *** small cliffs ***--------------------------------------

	for(i=0; <numTries)
	{
		int smallCliffHeight=rmRandInt(0,5);
		int smallMesaID=rmCreateArea("small mesa"+i);
		rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(8), rmAreaTilesToFraction(12));  // used to be 300
		rmSetAreaWarnFailure(smallMesaID, false);
		rmSetAreaCliffType(smallMesaID, "Painteddesert");
		rmAddAreaToClass(smallMesaID, rmClassID("canyon"));	// Attempt to keep cliffs away from each other.
		rmSetAreaCliffEdge(smallMesaID, 1, 1.0, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(smallMesaID, rmRandInt(6,8), 1.0, 1.0);
		//rmAddAreaConstraint(smallMesaID, shortAvoidCanyons);
		rmAddAreaConstraint (smallMesaID, avoidCanyons);
		//rmSetAreaMinBlobs(smallMesaID, 3);
		//rmSetAreaMaxBlobs(smallMesaID, 5);
		//rmSetAreaMinBlobDistance(smallMesaID, 3.0);
		//rmSetAreaMaxBlobDistance(smallMesaID, 5.0);
		rmSetAreaCoherence(smallMesaID, 0.6);
		rmAddAreaConstraint(smallMesaID, mediumPlayerConstraint); 
		rmAddAreaConstraint(smallMesaID, avoidNatives); 
	//	rmAddAreaConstraint(smallMesaID, avoidTradeRouteSockets);
	//	rmAddAreaConstraint(smallMesaID, avoidTradeRoute);
		rmAddAreaConstraint(smallMesaID, avoidStartingUnits);
		rmAddAreaConstraint(smallMesaID, shortAvoidSilver);
		rmAddAreaConstraint(smallMesaID, shortAvoidImportantItem);    // Added New
		if(rmBuildArea(smallMesaID)==false)
		{
			// Stop trying once we fail 10 times in a row.
			failCount++;
			if(failCount==6)   //KSW ---> Was 20
				break;
		}
		else
			failCount=0;
	}



// ---------------------- *** Place Players and Starting Units *** -------------------------------------------------------------------

	for(i=1; <cNumberPlayers)
	{
		
		// Test of Marcin's Starting Units stuff...
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerSilverID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	  //	rmPlaceObjectDefAtLoc(StartTurkeyID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startBisonID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		//vector closestPoint=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
		//rmSetHomeCityGatherPoint(i, closestPoint);
	}

// ------------------------------------------------------------------------------------------------------------------------------------	
	

// ************************************ FORESTS **************************************


	
	for(i=0; <cNumberNonGaiaPlayers*6)
	{
		int edgeForestID=rmCreateArea("edgeForest"+i);
		rmSetAreaWarnFailure(edgeForestID, false);
		rmSetAreaSize(edgeForestID, rmAreaTilesToFraction(140), rmAreaTilesToFraction(200));  // was 200 to 250
		rmSetAreaForestType(edgeForestID, "painteddesert forest");
		rmSetAreaForestDensity(edgeForestID, 20.0);                         //KSW --> Was 1.0
		rmSetAreaForestClumpiness(edgeForestID, 3.0);		
		rmSetAreaForestUnderbrush(edgeForestID, 0.0);
		rmAddAreaToClass(edgeForestID, rmClassID("classForest"));
		rmSetAreaMinBlobs(edgeForestID, 1);
		rmSetAreaMaxBlobs(edgeForestID, 3);					
		rmSetAreaMinBlobDistance(edgeForestID, 16.0);
		rmSetAreaMaxBlobDistance(edgeForestID, 30.0);
		rmSetAreaCoherence(edgeForestID, 0.4);
		rmSetAreaSmoothDistance(edgeForestID, 8);
		rmAddAreaConstraint(edgeForestID, shortPlayerConstraint);
		rmAddAreaConstraint(edgeForestID, forestConstraint); 
		rmAddAreaConstraint(edgeForestID, shortAvoidSilver);  
		rmAddAreaConstraint(edgeForestID, shortAvoidCanyons); 
	//	rmAddAreaConstraint(edgeForestID, avoidTradeRoute);
	//	rmAddAreaConstraint(edgeForestID, avoidTradeRouteSockets);
		rmAddAreaConstraint(edgeForestID, avoidStartingUnits);
		rmAddAreaConstraint(edgeForestID, avoidNatives);
		rmAddAreaConstraint(edgeForestID, shortAvoidImportantItem);  // Added New
			if(rmBuildArea(edgeForestID)==false)
			{
				// Stop trying once we fail 10 times in a row.  
				failCount++;
				if(failCount==24)
					break;
			}
			else
				failCount=0; 
	}
	

	// COIN RESOURCES

	int silverType = rmRandInt(1,10);   
	int silverID = -1;
	int silverCount = cNumberNonGaiaPlayers*4;	//KSW ---> Was number*3
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount)
	{
		silverID = rmCreateObjectDef("silver"+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(silverID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(silverID, canyonConstraint);
		rmAddObjectDefConstraint(silverID, avoidSilver);
		rmAddObjectDefConstraint(silverID, mediumPlayerConstraint);
		rmAddObjectDefConstraint(silverID, shortForestConstraint);
		rmAddObjectDefConstraint(silverID, avoidNatives);
		rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);          // Added New
		//rmAddObjectDefConstraint(silverID, avoidTradeRouteSockets);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);

	}


// Text
	rmSetStatusText("",0.6);


// ------------------------------------- *** Random Trees *** ------------------------------------------------
	
	for(i=0; < 16*cNumberNonGaiaPlayers)  
	{
		int randomTreeID=rmCreateObjectDef("random tree "+i);
		rmAddObjectDefItem(randomTreeID, "TreePaintedDesert", rmRandInt(4,8), 3.0);
		rmSetObjectDefMinDistance(randomTreeID, 0.0);
		rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.3));
		rmAddObjectDefConstraint(randomTreeID, avoidResource);
		//rmAddObjectDefConstraint(randomTreeID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(randomTreeID, avoidTradeRouteSockets);
		rmAddObjectDefConstraint(randomTreeID, shortPlayerConstraint);
		rmAddObjectDefConstraint(randomTreeID, avoidStartingUnits);
		rmAddObjectDefConstraint(randomTreeID, shortAvoidCanyons); 
		rmAddObjectDefConstraint(randomTreeID, shortAvoidImportantItem);				// Added New
		rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5);
   }




	// ************************************ TREASURES ***********************************

		int nugget1= rmCreateObjectDef("nugget easy"); 
		rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(1, 1);
		rmAddObjectDefToClass(nugget1, rmClassID("classNugget"));
		rmAddObjectDefConstraint(nugget1, avoidResource);
		rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
	//	rmAddObjectDefConstraint(nugget1, avoidTradeRouteSockets);
	//	rmAddObjectDefConstraint(nugget1, avoidTradeRoute);

		rmAddObjectDefConstraint(nugget1, mediumPlayerConstraint);
		
		rmAddObjectDefConstraint(nugget1, avoidStartingUnits);
		rmAddObjectDefConstraint(nugget1, shortAvoidCanyons);
		rmAddObjectDefConstraint(nugget1, avoidNugget);
		rmAddObjectDefConstraint(nugget1, avoidNatives);
		rmAddObjectDefConstraint(nugget1, circleConstraint);
		rmAddObjectDefConstraint(nugget1, shortAvoidImportantItem);			// Added New
		rmSetObjectDefMinDistance(nugget1, 40.0);
		rmSetObjectDefMaxDistance(nugget1, 60.0);
		rmPlaceObjectDefPerPlayer(nugget1, false, 2);

		int nugget2= rmCreateObjectDef("nugget medium"); 
		rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2, 2);
		rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
		rmSetObjectDefMinDistance(nugget2, 0.0);
		rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(nugget2, avoidResource);
		rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
	//	rmAddObjectDefConstraint(nugget2, avoidTradeRouteSockets);
	//	rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget2, mediumPlayerConstraint);
		rmAddObjectDefConstraint(nugget2, shortAvoidCanyons);
		rmAddObjectDefConstraint(nugget2, avoidStartingUnits);
		rmAddObjectDefConstraint(nugget2, avoidNugget);
		rmAddObjectDefConstraint(nugget2, avoidNatives);
		rmAddObjectDefConstraint(nugget2, circleConstraint);
		rmAddObjectDefConstraint(nugget2, shortAvoidImportantItem);				// Added New
		rmSetObjectDefMinDistance(nugget2, 80.0);
		rmSetObjectDefMaxDistance(nugget2, 120.0);
		rmPlaceObjectDefPerPlayer(nugget2, false, 1);

		int nugget3= rmCreateObjectDef("nugget hard"); 
		rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(3, 3);
		rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
		rmSetObjectDefMinDistance(nugget3, 0.0);
		rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.4));
		rmAddObjectDefConstraint(nugget3, avoidResource);
		rmAddObjectDefConstraint(nugget3, shortAvoidImpassableLand);
	//	rmAddObjectDefConstraint(nugget3, avoidTradeRouteSockets);
	//	rmAddObjectDefConstraint(nugget3, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget3, mediumPlayerConstraint);
		rmAddObjectDefConstraint(nugget3, shortAvoidCanyons);
		rmAddObjectDefConstraint(nugget3, avoidStartingUnits);
		rmAddObjectDefConstraint(nugget3, avoidNugget);
		rmAddObjectDefConstraint(nugget3, avoidNatives);
		rmAddObjectDefConstraint(nugget3, circleConstraint);
		rmAddObjectDefConstraint(nugget3, shortAvoidImportantItem);					// Added New
		rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

		int nugget4= rmCreateObjectDef("nugget nuts"); 
		rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(4, 4);
		rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
		rmSetObjectDefMinDistance(nugget4, 0.0);
		rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.4));
		rmAddObjectDefConstraint(nugget4, avoidResource);
		rmAddObjectDefConstraint(nugget4, shortAvoidImpassableLand);
	//	rmAddObjectDefConstraint(nugget4, avoidTradeRouteSockets);
	//	rmAddObjectDefConstraint(nugget4, avoidTradeRoute);
		rmAddObjectDefConstraint(nugget4, mediumPlayerConstraint);
		rmAddObjectDefConstraint(nugget4, shortAvoidCanyons);
		rmAddObjectDefConstraint(nugget4, avoidStartingUnits);
		rmAddObjectDefConstraint(nugget4, avoidNugget);
		rmAddObjectDefConstraint(nugget4, avoidNatives);
		rmAddObjectDefConstraint(nugget4, circleConstraint);
		rmAddObjectDefConstraint(nugget4, shortAvoidImportantItem);			// Added New
		rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(0,3));


  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.075;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }


// Text
	rmSetStatusText("",0.8);
	
//------------------------ *** Place Cows *** ---------------------------------------

	int cowID=rmCreateObjectDef("cow");
	rmAddObjectDefItem(cowID, "cow", 2, 4.0);
	rmSetObjectDefMinDistance(cowID, 0.0);
	rmSetObjectDefMaxDistance(cowID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(cowID, avoidCow);
	// rmAddObjectDefConstraint(cowID, avoidAll);
	rmAddObjectDefConstraint(cowID, playerConstraint);
	rmAddObjectDefConstraint(cowID, shortAvoidCanyons);
	rmAddObjectDefConstraint(cowID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(cowID, shortAvoidNugget);
	rmAddObjectDefConstraint(cowID, shortAvoidImportantItem);					// Added New
	rmPlaceObjectDefAtLoc(cowID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);


	// ----------------------- *** Place Bison Herds *** --------------------------------

	int bisonID=rmCreateObjectDef("Bison herd");
	rmAddObjectDefItem(bisonID, "bison", rmRandInt(5,7), 6.0);
	rmSetObjectDefCreateHerd(bisonID, true);
	rmSetObjectDefMinDistance(bisonID, 0.0);
	rmSetObjectDefMaxDistance(bisonID, rmXFractionToMeters(0.35));
	rmAddObjectDefConstraint(bisonID, avoidResource);
	// rmAddObjectDefConstraint(bisonID, centerConstraint);
	rmAddObjectDefConstraint(bisonID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(bisonID, avoidBison);
	rmAddObjectDefConstraint(bisonID, avoidNatives);
	rmAddObjectDefConstraint(bisonID, avoidPronghorn);
	rmAddObjectDefConstraint(bisonID, shortAvoidNugget);
	rmAddObjectDefConstraint(bisonID, playerConstraint);
	rmAddObjectDefConstraint(bisonID, shortAvoidCanyons);
	rmAddObjectDefConstraint(bisonID, shortAvoidImportantItem);					// Added New
	// rmAddObjectDefConstraint(bisonID, avoidTradeRouteSockets);
	rmPlaceObjectDefAtLoc(bisonID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);


// --------------------------- *** Place Pronghorn Herds *** -------------------------------

	int pronghornID=rmCreateObjectDef("pronghorn herd");
	rmAddObjectDefItem(pronghornID, "Pronghorn", rmRandInt(6, 8), 6.0);
	rmSetObjectDefCreateHerd(pronghornID, true);
	rmSetObjectDefMinDistance(pronghornID, 0.0);
	rmSetObjectDefMaxDistance(pronghornID, rmXFractionToMeters(0.35));
	rmAddObjectDefConstraint(pronghornID, avoidResource);
	// rmAddObjectDefConstraint(pronghornID, centerConstraint);
	rmAddObjectDefConstraint(pronghornID, shortAvoidImpassableLand);		// TEMP fix to allow pronghorn to be placed
	// rmAddObjectDefConstraint(pronghornID, avoidImpassableLand);			// Problem Child
	rmAddObjectDefConstraint(pronghornID, avoidNatives);
	rmAddObjectDefConstraint(pronghornID, avoidPronghorn);
	rmAddObjectDefConstraint(pronghornID, shortAvoidNugget);
	rmAddObjectDefConstraint(pronghornID, playerConstraint);
	rmAddObjectDefConstraint(pronghornID, avoidBison);
	rmAddObjectDefConstraint(pronghornID, avoidStartingUnits);
	//rmAddObjectDefConstraint(pronghornID, shortAvoidCanyons);
	rmAddObjectDefConstraint(pronghornID, shortAvoidImportantItem);					// Added New
	// rmAddObjectDefConstraint(pronghornID, avoidTradeRouteSockets);
	rmPlaceObjectDefAtLoc(pronghornID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);
	
	int buzzardFlockID=rmCreateObjectDef("buzzards");
	rmAddObjectDefItem(buzzardFlockID, "BuzzardFlock", 1, 3.0);
	rmSetObjectDefMinDistance(buzzardFlockID, 0.0);
	rmSetObjectDefMaxDistance(buzzardFlockID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(buzzardFlockID, avoidBuzzards);
	rmAddObjectDefConstraint(buzzardFlockID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(buzzardFlockID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(buzzardFlockID, playerConstraint);
	rmAddObjectDefConstraint(buzzardFlockID, avoidStartingUnits);
	rmPlaceObjectDefAtLoc(buzzardFlockID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int randomVultureTreeID=rmCreateObjectDef("random vulture tree");
	rmAddObjectDefItem(randomVultureTreeID, "PropVulturePerching", 1, 3.0);
	rmAddObjectDefItem(randomVultureTreeID, "UnderbrushPampas", rmRandInt(4,6), 3.0);
	rmSetObjectDefMinDistance(randomVultureTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomVultureTreeID, rmXFractionToMeters(0.40));
    rmAddObjectDefConstraint(randomVultureTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomVultureTreeID, playerConstraint);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidStartingUnits);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidBuzzards);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidVultures);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidTradeRouteSockets);
	rmPlaceObjectDefAtLoc(randomVultureTreeID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);


	// --------------------------- *** Build Dirt Patches *** ----------------------------------------------
	for (i=0; <10)
	{
		int dirtPatch=rmCreateArea("open dirt patch "+i);
		rmSetAreaWarnFailure(dirtPatch, false);
		rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(20), rmAreaTilesToFraction(50));  // Was 100, 300
		
		rmAddAreaTerrainLayer(dirtPatch, "painteddesert\pd_ground_diffuse_j", 0, 4);
		rmAddAreaTerrainLayer(dirtPatch, "painteddesert\pd_ground_diffuse_l", 4, 10);
		rmAddAreaTerrainLayer(dirtPatch, "painteddesert\pd_ground_diffuse_h", 10, 100);
		
		rmSetAreaMix(dirtPatch, "painteddesert_groundmix_1");
		// rmAddAreaTerrainLayer(dirtPatch, "great_plains\ground2_gp", 0, 1);
		rmAddAreaToClass(dirtPatch, rmClassID("classPatch"));
		//rmSetAreaBaseHeight(dirtPatch, 4.0);
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


		// Text
	rmSetStatusText("",1.0);
	}
}  
