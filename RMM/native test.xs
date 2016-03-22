// TEXAS
// October 2003
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
   int subCiv4=-1;
   int subCiv5=-1;
   int subCiv6=-1;
   int subCiv7=-1;
   int subCiv8=-1;
   int subCiv9=-1;
   int subCiv10=-1;
   int subCiv11=-1;

   if (rmAllocateSubCivs(12) == true)
   {
		subCiv0=rmGetCivID("Comanche");
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Comanche");

		subCiv1=rmGetCivID("Iroquois");
      if (subCiv1 >= 0)
         rmSetSubCiv(1, "Iroquois"); 

		subCiv2=rmGetCivID("Aztecs");
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "Aztecs");

		subCiv3=rmGetCivID("Maya");
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Maya");

		subCiv4=rmGetCivID("Lakota");
      if (subCiv4 >= 0)
         rmSetSubCiv(4, "Lakota");

		subCiv5=rmGetCivID("Nootka");
      if (subCiv5 >= 0)
         rmSetSubCiv(5, "Nootka");

		subCiv6=rmGetCivID("Cherokee");
      if (subCiv6 >= 0)
         rmSetSubCiv(6, "Cherokee");

		subCiv7=rmGetCivID("Cree");
      if (subCiv7 >= 0)
         rmSetSubCiv(7, "Cree");

		subCiv8=rmGetCivID("Tupi");
      if (subCiv8 >= 0)
         rmSetSubCiv(8, "Tupi");

		subCiv9=rmGetCivID("Caribs");
      if (subCiv9 >= 0)
         rmSetSubCiv(9, "Caribs");

		subCiv10=rmGetCivID("Seminoles");
      if (subCiv10 >= 0)
         rmSetSubCiv(10, "Seminoles");

		subCiv11=rmGetCivID("Incas");
      if (subCiv11 >= 0)
         rmSetSubCiv(11, "Incas"); 

	}



   // Picks the map size
   int playerTiles=12000;		// DAL modified from 16K
   if(cMapSize == 1)
   {
      playerTiles = 15000;			// DAL modified from 18K
      rmEchoInfo("Large map");
   }
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

	// Picks a default water height
   rmSetSeaLevel(4.0);

   // Picks default terrain and water
   rmSetSeaType("Amazon River");
   rmTerrainInitialize("carolinas\grass4");

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classHill");
   rmDefineClass("classPatch");
   rmDefineClass("corner");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
	rmDefineClass("classCliff");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 24.0);

   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
 
   // Nature avoidance
   // int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   // int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 50.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 30.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   
   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
   int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 10.0);
   int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);


   // Specify true so constraint stays outside of circle (i.e. inside corners)
   int cornerConstraint0=rmCreateCornerConstraint("in corner 0", 0, true);
   int cornerConstraint1=rmCreateCornerConstraint("in corner 1", 1, true);
   int cornerConstraint2=rmCreateCornerConstraint("in corner 2", 2, true);
   int cornerConstraint3=rmCreateCornerConstraint("in corner 3", 3, true);
   int insideCircleConstraint=rmCreateCornerConstraint("inside circle", -1, false);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 40.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 20.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 12.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

     // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);

   // -------------Define objects
   // These objects are all defined so they can be placed later

	//colony ship
	/*
   int colonyShipID=rmCreateObjectDef("colony ship");
   rmAddObjectDefItem(colonyShipID, "caravel", 1, 0.0);
   rmSetObjectDefGarrisonStartingUnits(colonyShipID, true);
   rmSetObjectDefMinDistance(colonyShipID, 0.0);
   rmSetObjectDefMaxDistance(colonyShipID, 0.0);
   rmAddObjectDefConstraint(colonyShipID, playerEdgeConstraint);
   rmAddObjectDefConstraint(colonyShipID, fishLand);
	*/

	// DAL Define the "Fort" Here instead!
   int playerFortID = -1;
   int playerFortType = 1;
   playerFortID = rmCreateGrouping("player fort", "texas fort "+playerFortType);
	// playerFortID = rmCreateGrouping("player fort", "native tupi village "+playerFortType);

   // rmSetGroupingMinDistance(playerFortID, 0.0);
   // rmSetGroupingMaxDistance(playerFortID, rmXFractionToMeters(0.35));
   
	// Groupings
	// rmAddGroupingConstraint(playerFortID, avoidImpassableLand);
	//   rmAddGroupingToClass(playerFortID, rmClassID("importantItem"));
   
	// Removed all constraints for now - DAL

	// rmAddGroupingConstraint(playerFortID, avoidImportantItem);
   // rmAddGroupingConstraint(playerFortID, insideCircleConstraint);
   // rmAddGroupingConstraint(playerFortID, avoidTradeRoute);
	// rmAddGroupingConstraint(playerFortID, playerConstraint);
   // rmAddObjectDefConstraint(playerFortID, Southward);


	//EXAMPLE OF PLACING OBJECTS AWAY FROM PLAYER
	//  int farGoldID=rmCreateObjectDef("far gold");
	//  rmAddObjectDefItem(farGoldID, "Gold mine", 1, 0.0);
	//  rmSetObjectDefMinDistance(farGoldID, 60);
	//  rmSetObjectDefMaxDistance(farGoldID, 160.0);
	//  rmAddObjectDefConstraint(farGoldID, avoidGold);
	//  rmAddObjectDefConstraint(farGoldID, avoidImpassableLand);

	//  rmPlaceObjectDefPerPlayer(farGoldID, false, 3);
   
	// food resources


   // Text
   rmSetStatusText("",0.10);

   // Text
   rmSetStatusText("",0.10);

   // *** Set up player starting locations. Circular around the outside of the map.
   // rmPlacePlayersCircular(0.1, 0.9, rmDegreesToRadians(5.0));
	rmSetPlacementTeam(0);
	rmSetPlacementSection(0.1, 0.4);
	rmPlacePlayersCircular(0.38, 0.42, 0.0);

	rmSetPlacementTeam(1);
	rmSetPlacementSection(0.6, 0.9);
	rmPlacePlayersCircular(0.38, 0.42, 0.0);

   // Set up player areas.
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
      rmSetAreaLocPlayer(id, i);
		// rmSetAreaTerrainType(id, "carolina\marshflats");
		// rmSetAreaBaseHeight(id, 8.0);
      rmSetAreaWarnFailure(id, false);
   }


   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.20);

   // Text
   rmSetStatusText("",0.30);



	// Placement order
	// Players -> Trade route -> River (none on this map) -> Natives -> Secrets -> Cliffs -> Nuggets
	// Place other objects that were defined earlier
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   // rmSetObjectDefMinDistance(startingUnits, 10.0);
   // rmSetObjectDefMaxDistance(startingUnits, 20.0);

	// Player placement
	for(i=1; <cNumberPlayers)
	{
		// DAL Stuff taken out.
		rmPlaceGroupingAtLoc(playerFortID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		/*	
		if (rmGetNumberUnitsPlaced(playerFortID) > 0)
		{
		  vector playerFortLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(playerFortID, i));
		  // rmSetHomeCityGatherPoint(i, rmGetAreaClosestPoint(-1, playerFortLocation, 8.0));
		}
		*/

		// Test of Marcin's Starting Units stuff...
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Place starting resources - DAL

		vector closestPoint=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
		rmSetHomeCityGatherPoint(i, closestPoint);
	}

	// Text
	rmSetStatusText("",0.40);



	// Define and place the Native Villages and Secrets of the New World
	// Text
	rmSetStatusText("",0.50);

	if (subCiv0 == rmGetCivID("Comanche"))
	{  
		int comancheVillageID = -1;
		comancheVillageID = rmCreateGrouping("comanche village", "native comanche village 1");
		rmSetGroupingMinDistance(comancheVillageID, 0.0);
		rmSetGroupingMaxDistance(comancheVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(comancheVillageID, avoidImpassableLand);
		rmAddGroupingToClass(comancheVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(comancheVillageID, avoidImportantItem);
		rmAddGroupingConstraint(comancheVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.5, 0.5);
	} 

	if (subCiv1 == rmGetCivID("iroquois"))
	{  
		int iroquoisVillageID = -1;
		iroquoisVillageID = rmCreateGrouping("iroquois village", "native iroquois village 1");
		rmSetGroupingMinDistance(iroquoisVillageID, 0.0);
		rmSetGroupingMaxDistance(iroquoisVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(iroquoisVillageID, avoidImpassableLand);
		rmAddGroupingToClass(iroquoisVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(iroquoisVillageID, avoidImportantItem);
		rmAddGroupingConstraint(iroquoisVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(iroquoisVillageID, 0, 0.5, 0.5);
	} 

	if (subCiv2 == rmGetCivID("aztecs"))
	{  
		int aztecsVillageID = -1;
		aztecsVillageID = rmCreateGrouping("aztecs village", "native aztec village 1");
		rmSetGroupingMinDistance(aztecsVillageID, 0.0);
		rmSetGroupingMaxDistance(aztecsVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(aztecsVillageID, avoidImpassableLand);
		rmAddGroupingToClass(aztecsVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(aztecsVillageID, avoidImportantItem);
		rmAddGroupingConstraint(aztecsVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(aztecsVillageID, 0, 0.5, 0.5);
	}

	if (subCiv3 == rmGetCivID("maya"))
	{  
		int mayaVillageID = -1;
		mayaVillageID = rmCreateGrouping("maya village", "native maya village 1");
		rmSetGroupingMinDistance(mayaVillageID, 0.0);
		rmSetGroupingMaxDistance(mayaVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(mayaVillageID, avoidImpassableLand);
		rmAddGroupingToClass(mayaVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(mayaVillageID, avoidImportantItem);
		rmAddGroupingConstraint(mayaVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(mayaVillageID, 0, 0.5, 0.5);
	} 
	
	if (subCiv4 == rmGetCivID("lakota"))
	{  
		int lakotaVillageID = -1;
		lakotaVillageID = rmCreateGrouping("lakota village", "native lakota village 1");
		rmSetGroupingMinDistance(lakotaVillageID, 0.0);
		rmSetGroupingMaxDistance(lakotaVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(lakotaVillageID, avoidImpassableLand);
		rmAddGroupingToClass(lakotaVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(lakotaVillageID, avoidImportantItem);
		rmAddGroupingConstraint(lakotaVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(lakotaVillageID, 0, 0.5, 0.5);
	} 

	if (subCiv5 == rmGetCivID("nootka"))
	{  
		int nootkaVillageID = -1;
		nootkaVillageID = rmCreateGrouping("nootka village", "native nootka village 1");
		rmSetGroupingMinDistance(nootkaVillageID, 0.0);
		rmSetGroupingMaxDistance(nootkaVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(nootkaVillageID, avoidImpassableLand);
		rmAddGroupingToClass(nootkaVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(nootkaVillageID, avoidImportantItem);
		rmAddGroupingConstraint(nootkaVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(nootkaVillageID, 0, 0.5, 0.5);
	} 
		
	if (subCiv6 == rmGetCivID("cherokee"))
	{  
		int cherokeeVillageID = -1;
		cherokeeVillageID = rmCreateGrouping("cherokee village", "native cherokee village 1");
		rmSetGroupingMinDistance(cherokeeVillageID, 0.0);
		rmSetGroupingMaxDistance(cherokeeVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(cherokeeVillageID, avoidImpassableLand);
		rmAddGroupingToClass(cherokeeVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(cherokeeVillageID, avoidImportantItem);
		rmAddGroupingConstraint(cherokeeVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(cherokeeVillageID, 0, 0.5, 0.5);
	} 
				
	if (subCiv7 == rmGetCivID("cree"))
	{  
		int creeVillageID = -1;
		creeVillageID = rmCreateGrouping("cree village", "native cree village 1");
		rmSetGroupingMinDistance(creeVillageID, 0.0);
		rmSetGroupingMaxDistance(creeVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(creeVillageID, avoidImpassableLand);
		rmAddGroupingToClass(creeVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(creeVillageID, avoidImportantItem);
		rmAddGroupingConstraint(creeVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(creeVillageID, 0, 0.5, 0.5);
	} 

	if (subCiv8 == rmGetCivID("tupi"))
	{  
		int tupiVillageID = -1;
		tupiVillageID = rmCreateGrouping("tupi village", "native tupi village 1");
		rmSetGroupingMinDistance(tupiVillageID, 0.0);
		rmSetGroupingMaxDistance(tupiVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(tupiVillageID, avoidImpassableLand);
		rmAddGroupingToClass(tupiVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(tupiVillageID, avoidImportantItem);
		rmAddGroupingConstraint(tupiVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.5, 0.5);
	}
				
	if (subCiv9 == rmGetCivID("caribs"))
	{  
		int caribsVillageID = -1;
		caribsVillageID = rmCreateGrouping("caribs village", "native carib village 1");
		rmSetGroupingMinDistance(caribsVillageID, 0.0);
		rmSetGroupingMaxDistance(caribsVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(caribsVillageID, avoidImpassableLand);
		rmAddGroupingToClass(caribsVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(caribsVillageID, avoidImportantItem);
		rmAddGroupingConstraint(caribsVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(caribsVillageID, 0, 0.5, 0.5);
	} 
		
	if (subCiv10 == rmGetCivID("seminoles"))
	{  
		int seminolesVillageID = -1;
		seminolesVillageID = rmCreateGrouping("seminoles village", "native seminole village 1");
		rmSetGroupingMinDistance(seminolesVillageID, 0.0);
		rmSetGroupingMaxDistance(seminolesVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(seminolesVillageID, avoidImpassableLand);
		rmAddGroupingToClass(seminolesVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(seminolesVillageID, avoidImportantItem);
		rmAddGroupingConstraint(seminolesVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(seminolesVillageID, 0, 0.5, 0.5);
	} 
			
	if (subCiv11 == rmGetCivID("incas"))
	{  
		int incasVillageID = -1;
		incasVillageID = rmCreateGrouping("incas village", "native inca village 1");
		rmSetGroupingMinDistance(incasVillageID, 0.0);
		rmSetGroupingMaxDistance(incasVillageID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(incasVillageID, avoidImpassableLand);
		rmAddGroupingToClass(incasVillageID, rmClassID("importantItem"));
		rmAddGroupingConstraint(incasVillageID, avoidImportantItem);
		rmAddGroupingConstraint(incasVillageID, insideCircleConstraint);
		rmPlaceGroupingAtLoc(incasVillageID, 0, 0.5, 0.5);
	} 



}  
