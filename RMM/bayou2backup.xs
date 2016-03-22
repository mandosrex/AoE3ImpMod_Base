// BAYOU Joes revision

// Main entry point for random map script
include "mercenaries.xs";
void main(void)
{

   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;
   int subCiv4=-1;

   if (rmAllocateSubCivs(5) == true)
   {
		subCiv0=rmGetCivID("Seminoles");
		rmEchoInfo("subCiv0 is Seminole "+subCiv0);
      if (subCiv0 >= 0)
			rmSetSubCiv(0, "Seminoles");
		
		subCiv1=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv1 is Cherokee "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Cherokee");

		subCiv2=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv2 is Cherokee "+subCiv2);
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "Cherokee");

		subCiv3=rmGetCivID("Seminoles");
		rmEchoInfo("subCiv3 is Seminoles "+subCiv3);
		if (subCiv3 >= 0)
			rmSetSubCiv(3, "Seminoles");
		
		if (rmRandFloat(0,1) < 0.5)
		{
			subCiv4=rmGetCivID("Seminoles");
			rmEchoInfo("subCiv4 is Seminoles "+subCiv4);
			if (subCiv4 >= 0)
				rmSetSubCiv(4, "Seminoles");
		}
	}			

   // Picks the map size
   int playerTiles=14400;
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   // Picks a default water height
   rmSetSeaLevel(1.0);

   // Picks default terrain and water

// rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
//	rmSetMapElevationParameters(cElevTurbulence, 0.1, 4, 0.3, 2.0);
	rmSetSeaType("new england coast");
   rmEnableLocalWater(false);
	rmSetBaseTerrainMix("carolina_marsh");
   rmTerrainInitialize("water");
	rmSetMapType("bayou");
	rmSetMapType("water");
//	rmSetMapType("grass");
	rmSetWorldCircleConstraint(true);

	// Choose mercs.
	chooseMercs();

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classCliff");
   rmDefineClass("classPatch");
   int classbigContinent=rmDefineClass("big continent");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
	rmDefineClass("secrets");
	int classBay=rmDefineClass("bay");

   int classIsland=rmDefineClass("island");
   int classBonusIsland=rmDefineClass("bonus island");
   int classSideIsland=rmDefineClass("side island");
   rmDefineClass("corner");



   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("continent stays away from players", classPlayer, 40.0);

   // Player constraints
	int islandConstraint=rmCreateClassDistanceConstraint("stay away from islands", classIsland, 20.0);
	int playerConstraint=rmCreateClassDistanceConstraint("bonus Settlement stay away from players", classPlayer, 10);
	int bonusIslandConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classBonusIsland, 10.0);
	int longBonusIslandConstraint=rmCreateClassDistanceConstraint("long avoid bonus island", classBonusIsland, 30.0);
	int longSideIslandConstraint=rmCreateClassDistanceConstraint("long avoid side island", classSideIsland, 30.0);
	int cornerConstraint=rmCreateClassDistanceConstraint("stay away from corner", rmClassID("corner"), 15.0);
	int cornerOverlapConstraint=rmCreateClassDistanceConstraint("don't overlap corner", rmClassID("corner"), 2.0);
	int bayConstraint=rmCreateClassDistanceConstraint("avoid bay", classBay, 3);

	int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
	int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 30.0);
	int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);
	int avoidBoats=rmCreateTypeDistanceConstraint("avoid boats", "caravel", 30.0);

	// Bonus area constraint.
	 int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid big island", classbigContinent, 20.0);

	// Resource avoidance
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 50.0);
	int farAvoidCoin=rmCreateTypeDistanceConstraint("silver avoid coin", "gold", 70.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "nugget", 50.0);
	int avoidDeer=rmCreateTypeDistanceConstraint("food avoids food", "deer", 70.0);
	int avoidTurkey=rmCreateTypeDistanceConstraint("avoid turkeys", "turkey", 50.0);
	int avoidCotton=rmCreateTypeDistanceConstraint("avoid cotton", "cotton", 50.0);
	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 1.0);
   int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // VP avoidance
   int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 80.0);

   // Constraint to avoid water.
   int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 8.0);


  // Text
   rmSetStatusText("",0.10);


	 // Create center section
   int centerIslandID=rmCreateArea("Center Island area");
   rmSetAreaSize(centerIslandID, 0.06, 0.10);
   rmSetAreaLocation(centerIslandID, 0.5, 0.5);
   rmSetAreaMix(centerIslandID, "carolina_marsh");
   rmSetAreaBaseHeight(centerIslandID, 4.0); // Was 10
   rmSetAreaMinBlobs(centerIslandID, 8);
   rmSetAreaMaxBlobs(centerIslandID, 10);
   rmSetAreaMinBlobDistance(centerIslandID, 10);
   rmSetAreaMaxBlobDistance(centerIslandID, 20);
   rmSetAreaSmoothDistance(centerIslandID, 50);
   rmSetAreaCoherence(centerIslandID, 0.50);
	rmAddAreaToClass(centerIslandID, rmClassID("bay"));
   rmSetAreaObeyWorldCircleConstraint(centerIslandID, false);
    rmBuildArea(centerIslandID);

//  ********************************** Island fingers *******************************
   
      int bonusIsland1ID=rmCreateArea("bonus island 1");
      rmSetAreaSize(bonusIsland1ID, 0.04, 0.04);
	  rmSetAreaLocation(bonusIsland1ID, 0.23, 0.5);
      rmSetAreaMix(bonusIsland1ID, "carolina_marsh");
      rmSetAreaWarnFailure(bonusIsland1ID, false);
    //  if(rmRandFloat(0.0, 1.0)<0.70)
      rmAddAreaConstraint(bonusIsland1ID, bonusIslandConstraint);
      rmAddAreaToClass(bonusIsland1ID, classIsland);
      rmAddAreaToClass(bonusIsland1ID, classBonusIsland);
      //rmAddAreaConstraint(bonusIsland1ID, bayConstraint);
	  //rmAddAreaConstraint(bonusIsland1ID, playerEdgeConstraint);
      rmSetAreaCoherence(bonusIsland1ID, 0.25);
      rmSetAreaSmoothDistance(bonusIsland1ID, 12);
	  rmSetAreaElevationType(bonusIsland1ID, cElevTurbulence);
	  rmSetAreaElevationVariation(bonusIsland1ID, 2.0);
		rmSetAreaBaseHeight(bonusIsland1ID, 4.0);
		rmSetAreaElevationMinFrequency(bonusIsland1ID, 0.09);
		rmSetAreaElevationOctaves(bonusIsland1ID, 3);
		rmSetAreaElevationPersistence(bonusIsland1ID, 0.2);      
  
int bonusIsland2ID=rmCreateArea("bonus island 2");
      rmSetAreaSize(bonusIsland2ID, 0.04, 0.04);
	  rmSetAreaLocation(bonusIsland2ID, 0.4, 0.30);
      rmSetAreaMix(bonusIsland2ID, "carolina_marsh");
      rmSetAreaWarnFailure(bonusIsland2ID, false);
    //  if(rmRandFloat(0.0, 1.0)<0.70)
      rmAddAreaConstraint(bonusIsland2ID, bonusIslandConstraint);
      rmAddAreaToClass(bonusIsland2ID, classIsland);
      rmAddAreaToClass(bonusIsland2ID, classBonusIsland);
     // rmAddAreaConstraint(bonusIsland2ID, bayConstraint);
	 // rmAddAreaConstraint(bonusIsland2ID, playerEdgeConstraint);
      rmSetAreaCoherence(bonusIsland2ID, 0.25);
      rmSetAreaSmoothDistance(bonusIsland2ID, 12);
	  rmSetAreaElevationType(bonusIsland2ID, cElevTurbulence);
		rmSetAreaElevationVariation(bonusIsland2ID, 2.0);
		rmSetAreaBaseHeight(bonusIsland2ID, 4.0);
		rmSetAreaElevationMinFrequency(bonusIsland2ID, 0.09);
		rmSetAreaElevationOctaves(bonusIsland2ID, 3);
		rmSetAreaElevationPersistence(bonusIsland2ID, 0.2);     

		int bonusIsland3ID=rmCreateArea("bonus island 3");
      rmSetAreaSize(bonusIsland3ID, 0.025, 0.04);
	  rmSetAreaLocation(bonusIsland3ID, 0.4, 0.75);
      rmSetAreaMix(bonusIsland3ID, "carolina_marsh");
      rmSetAreaWarnFailure(bonusIsland3ID, false);
    //  if(rmRandFloat(0.0, 1.0)<0.70)
      rmAddAreaConstraint(bonusIsland3ID, bonusIslandConstraint);
      rmAddAreaToClass(bonusIsland3ID, classIsland);
      rmAddAreaToClass(bonusIsland3ID, classBonusIsland);
      //rmAddAreaConstraint(bonusIsland3ID, bayConstraint);
	  //rmAddAreaConstraint(bonusIsland3ID, playerEdgeConstraint);
      rmSetAreaCoherence(bonusIsland3ID, 0.25);
      rmSetAreaSmoothDistance(bonusIsland3ID, 12);
	  rmSetAreaElevationType(bonusIsland3ID, cElevTurbulence);
		rmSetAreaElevationVariation(bonusIsland3ID, 2.0);
		rmSetAreaBaseHeight(bonusIsland3ID, 4.0);
		rmSetAreaElevationMinFrequency(bonusIsland3ID, 0.09);
		rmSetAreaElevationOctaves(bonusIsland3ID, 3);
		rmSetAreaElevationPersistence(bonusIsland3ID, 0.2);     


		rmSetStatusText("",0.20);


		int bonusIsland4ID=rmCreateArea("bonus island 4");
      rmSetAreaSize(bonusIsland4ID, 0.04, 0.04);
	  rmSetAreaLocation(bonusIsland4ID, 0.75, 0.5);
      rmSetAreaMix(bonusIsland4ID, "carolina_marsh");
      rmSetAreaWarnFailure(bonusIsland4ID, false);
    //  if(rmRandFloat(0.0, 1.0)<0.70)
      rmAddAreaConstraint(bonusIsland4ID, bonusIslandConstraint);
      rmAddAreaToClass(bonusIsland4ID, classIsland);
      rmAddAreaToClass(bonusIsland4ID, classBonusIsland);
    //  rmAddAreaConstraint(bonusIsland4ID, bayConstraint);
	 // rmAddAreaConstraint(bonusIsland4ID, playerEdgeConstraint);
      rmSetAreaCoherence(bonusIsland4ID, 0.25);
      rmSetAreaSmoothDistance(bonusIsland4ID, 12);
	  rmSetAreaElevationType(bonusIsland4ID, cElevTurbulence);
		rmSetAreaElevationVariation(bonusIsland4ID, 2.0);
		rmSetAreaBaseHeight(bonusIsland4ID, 4.0);
		rmSetAreaElevationMinFrequency(bonusIsland4ID, 0.09);
		rmSetAreaElevationOctaves(bonusIsland4ID, 3);
		rmSetAreaElevationPersistence(bonusIsland4ID, 0.2);     

		int bonusIsland5ID=rmCreateArea("bonus island 5");
      rmSetAreaSize(bonusIsland5ID, 0.02, 0.04);
	  rmSetAreaLocation(bonusIsland5ID, 0.65, 0.25);
      rmSetAreaMix(bonusIsland5ID, "carolina_marsh");
      rmSetAreaWarnFailure(bonusIsland5ID, false);
    //  if(rmRandFloat(0.0, 1.0)<0.70)
      rmAddAreaConstraint(bonusIsland5ID, bonusIslandConstraint);
      rmAddAreaToClass(bonusIsland5ID, classIsland);
      rmAddAreaToClass(bonusIsland5ID, classBonusIsland);
     // rmAddAreaConstraint(bonusIsland5ID, bayConstraint);
	 // rmAddAreaConstraint(bonusIsland5ID, playerEdgeConstraint);
      rmSetAreaCoherence(bonusIsland5ID, 0.25);
      rmSetAreaSmoothDistance(bonusIsland5ID, 12);
	  rmSetAreaElevationType(bonusIsland5ID, cElevTurbulence);
		rmSetAreaElevationVariation(bonusIsland5ID, 2.0);
		rmSetAreaBaseHeight(bonusIsland5ID, 4.0);
		rmSetAreaElevationMinFrequency(bonusIsland5ID, 0.09);
		rmSetAreaElevationOctaves(bonusIsland5ID, 3);
		rmSetAreaElevationPersistence(bonusIsland5ID, 0.2);     

		int bonusIsland6ID=rmCreateArea("bonus island 6");
      rmSetAreaSize(bonusIsland6ID, 0.04, 0.04);
	  rmSetAreaLocation(bonusIsland6ID, 0.65, 0.70);
      rmSetAreaMix(bonusIsland6ID, "carolina_marsh");
      rmSetAreaWarnFailure(bonusIsland6ID, false);
    //  if(rmRandFloat(0.0, 1.0)<0.70)
      rmAddAreaConstraint(bonusIsland6ID, bonusIslandConstraint);
      rmAddAreaToClass(bonusIsland6ID, classIsland);
      rmAddAreaToClass(bonusIsland6ID, classBonusIsland);
      //rmAddAreaConstraint(bonusIsland6ID, bayConstraint);
	  //rmAddAreaConstraint(bonusIsland6ID, playerEdgeConstraint);
      rmSetAreaCoherence(bonusIsland6ID, 0.25);
      rmSetAreaSmoothDistance(bonusIsland6ID, 12);
	  rmSetAreaElevationType(bonusIsland6ID, cElevTurbulence);
		rmSetAreaElevationVariation(bonusIsland6ID, 2.0);
		rmSetAreaBaseHeight(bonusIsland6ID, 4.0);
		rmSetAreaElevationMinFrequency(bonusIsland6ID, 0.09);
		rmSetAreaElevationOctaves(bonusIsland6ID, 3);
		rmSetAreaElevationPersistence(bonusIsland6ID, 0.2);     
  
   rmBuildAllAreas();

int smallPondID=rmCreateArea("small pond");
		rmSetAreaSize(smallPondID, 0.01, 0.01);
		rmSetAreaWaterType(smallPondID, "great plains pond");
		rmSetAreaBaseHeight(smallPondID, 4);
		rmSetAreaMinBlobs(smallPondID, 4);
		rmSetAreaMaxBlobs(smallPondID, 6);
		rmSetAreaMinBlobDistance(smallPondID, 5.0);
		rmSetAreaMaxBlobDistance(smallPondID, 30.0);
		rmSetAreaCoherence(smallPondID, 0.3);
		rmSetAreaSmoothDistance(smallPondID, 5);
		rmSetAreaLocation(smallPondID, 0.5, 0.5); 
		rmBuildArea(smallPondID);


// text
rmSetStatusText("",0.30);

 //  rmBuildConnection(shallowsID);


	// Add Natives

	float nativeLoc = rmRandFloat(0,1);

	if (subCiv0 == rmGetCivID("Seminoles"))
   {   
      int SeminolesVillageID = -1;
      int SeminolesVillageType = rmRandInt(1,10);
      SeminolesVillageID = rmCreateGrouping("Seminole village", "native seminole village "+SeminolesVillageType);
      rmSetGroupingMinDistance(SeminolesVillageID, 0.0);
      rmSetGroupingMaxDistance(SeminolesVillageID, rmXFractionToMeters(0.05));
      rmAddGroupingConstraint(SeminolesVillageID, avoidImpassableLand);
      rmAddGroupingConstraint(SeminolesVillageID, avoidImportantItem);
      rmAddGroupingToClass(SeminolesVillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(SeminolesVillageID, 0, 0.75, 0.5);
		else
			rmPlaceGroupingAtLoc(SeminolesVillageID, 0, 0.4, 0.3);
	}

	if (subCiv1 == rmGetCivID("Cherokee"))
   {   
      int CherokeeVillageID = -1;
      int CherokeeVillageType = rmRandInt(1,10);
      CherokeeVillageID = rmCreateGrouping("Cherokee village", "native Cherokee village "+CherokeeVillageType);
      rmSetGroupingMinDistance(CherokeeVillageID, 0.0);
      rmSetGroupingMaxDistance(CherokeeVillageID, rmXFractionToMeters(0.05));
      rmAddGroupingConstraint(CherokeeVillageID, avoidImpassableLand);
		rmAddGroupingConstraint(CherokeeVillageID, avoidImportantItem);
      rmAddGroupingToClass(CherokeeVillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(CherokeeVillageID, 0, 0.4, 0.75);
		else
			rmPlaceGroupingAtLoc(CherokeeVillageID, 0, 0.4, 0.75);
	}

	if (subCiv2 == rmGetCivID("Cherokee"))
   {   
      int Cherokee2VillageID = -1;
      int Cherokee2VillageType = rmRandInt(1,10);
      Cherokee2VillageID = rmCreateGrouping("Cherokee2 village", "native cherokee village "+Cherokee2VillageType);
      rmSetGroupingMinDistance(Cherokee2VillageID, 0.0);
      rmSetGroupingMaxDistance(Cherokee2VillageID, rmXFractionToMeters(0.05));
      rmAddGroupingConstraint(Cherokee2VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(Cherokee2VillageID, avoidImportantItem);
      rmAddGroupingToClass(Cherokee2VillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(Cherokee2VillageID, 0, 0.23, 0.5);
		else
			rmPlaceGroupingAtLoc(Cherokee2VillageID, 0, 0.65, 0.7);
	}
  
	if (subCiv3 == rmGetCivID("Seminoles"))
   {   
      int Seminoles2VillageID = -1;
      int Seminoles2VillageType = rmRandInt(1,10);
      Seminoles2VillageID = rmCreateGrouping("Seminole2 village", "native seminole village "+Seminoles2VillageType);
      rmSetGroupingMinDistance(Seminoles2VillageID, 0.0);
      rmSetGroupingMaxDistance(Seminoles2VillageID, rmXFractionToMeters(0.05));
      rmAddGroupingConstraint(Seminoles2VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(Seminoles2VillageID, avoidImportantItem);
      rmAddGroupingToClass(Seminoles2VillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(Seminoles2VillageID, 0, 0.65, 0.25);
		else
			rmPlaceGroupingAtLoc(Seminoles2VillageID, 0, 0.65, 0.25);
	}

	if (subCiv4 == rmGetCivID("Seminoles"))
   {   
      int Seminoles3VillageID = -1;
      int Seminoles3VillageType = rmRandInt(1,10);
      Seminoles3VillageID = rmCreateGrouping("Seminole3 village", "native seminole village "+Seminoles3VillageType);
      rmSetGroupingMinDistance(Seminoles3VillageID, 0.0);
      rmSetGroupingMaxDistance(Seminoles3VillageID, rmXFractionToMeters(0.05));
      rmAddGroupingConstraint(Seminoles3VillageID, avoidImpassableLand);
		rmAddGroupingConstraint(Seminoles3VillageID, avoidImportantItem);
      rmAddGroupingToClass(Seminoles3VillageID, rmClassID("importantItem"));
		if (nativeLoc < 0.5)
			rmPlaceGroupingAtLoc(Seminoles3VillageID, 0, 0.5, 0.5);
		else
			rmPlaceGroupingAtLoc(Seminoles3VillageID, 0, 0.5, 0.5);
	}

	// Set up player starting locations. These are just used to place Caravels away from each other.

//   rmSetPlacementSection(0.9, 0.3);
//   rmSetPlayerPlacementArea(0, 0, 0.35, 0.35);
//   rmSetTeamSpacingModifier(0.50);
   rmPlacePlayersCircular(0.48, 0.48, 0);


    // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(1000);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
//	  rmSetAreaMix(id, "yukon snow");
//	  rmSetAreaBaseHeight(id, 4);
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
  //    rmSetAreaTerrainType(id, "saguenay\ground5_sag");
   //   rmSetAreaBaseHeight(id, 10.0);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();


   // Text
   rmSetStatusText("",0.60);

   int colonyShipID=rmCreateObjectDef("colony ship");
   rmAddObjectDefItem(colonyShipID, "caravel", 1, 0.0);
   rmSetObjectDefGarrisonStartingUnits(colonyShipID, true);
   rmSetObjectDefMinDistance(colonyShipID, 0.0);
   rmSetObjectDefMaxDistance(colonyShipID, 5.0);

  // Set up for finding closest land points.
   rmAddClosestPointConstraint(avoidWater8);
	rmAddClosestPointConstraint(playerEdgeConstraint);
	rmAddClosestPointConstraint(flagConstraint);
	rmAddClosestPointConstraint(nearWater10);
   
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
      vector closestPoint = rmFindClosestPointVector(colonyShipLocation, rmXFractionToMeters(0.25));
      rmEchoInfo("0.25 Fraction to Meters = "+rmXFractionToMeters(0.25));

      // Set HCGP.
      rmSetHomeCityGatherPoint(i, closestPoint);
   }
   


   // ***************************** side islands *****************************
for(i=0; <rmRandInt(28,30))
   {
      int smallIslandID=rmCreateArea("small island"+i);
      rmSetAreaSize(smallIslandID, 0.03, 0.04);
      rmSetAreaMix(smallIslandID, "carolina_marsh");
      rmSetAreaWarnFailure(smallIslandID, false);
    //  if(rmRandFloat(0.0, 1.0)<0.70)
         rmAddAreaConstraint(smallIslandID, longBonusIslandConstraint);
	//	 rmAddAreaConstraint(smallIslandID, longSideIslandConstraint);
      rmAddAreaToClass(smallIslandID, classIsland);
      rmAddAreaToClass(smallIslandID, classBonusIsland);
	  rmAddAreaToClass(smallIslandID, classSideIsland);
      rmAddAreaConstraint(smallIslandID, bayConstraint);
	  rmAddAreaConstraint(smallIslandID, longPlayerConstraint);
	  rmAddAreaConstraint(smallIslandID, avoidBoats);
      rmSetAreaCoherence(smallIslandID, 0.25);
      rmSetAreaSmoothDistance(smallIslandID, 12);
	   rmSetAreaElevationType(smallIslandID, cElevTurbulence);
		rmSetAreaElevationVariation(smallIslandID, 2.0);
		rmSetAreaBaseHeight(smallIslandID, 4.0);
		rmSetAreaElevationMinFrequency(smallIslandID, 0.09);
		rmSetAreaObeyWorldCircleConstraint(smallIslandID, false);
		rmSetAreaElevationOctaves(smallIslandID, 3);
		rmSetAreaElevationPersistence(smallIslandID, 0.2);      
      }   
rmBuildAllAreas();


// text
rmSetStatusText("",0.70);
	


	int cottonType = -1;
	int cottonID = -1;
	for(i=0; <(2+cNumberNonGaiaPlayers))
   {
		cottonType = rmRandInt(1,4);
      cottonID = rmCreateGrouping("cotton "+i, "resource cotton "+cottonType);
      rmSetGroupingMinDistance(cottonID, 0.0);
      rmSetGroupingMaxDistance(cottonID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(cottonID, avoidCoin);
      rmAddGroupingConstraint(cottonID, shortAvoidImpassableLand);
	   rmAddGroupingConstraint(cottonID, avoidCotton);

		rmPlaceGroupingAtLoc(cottonID, 0, 0.5, 0.5);
   }

	int silverType = rmRandInt(1,10);
	int silverID = -1;
	int silver2ID = -1;
	int silverCount = (cNumberNonGaiaPlayers*3);
	int bonusSilverCount = (cNumberNonGaiaPlayers);	
	rmEchoInfo("silver count = "+silverCount);
	rmEchoInfo("bonus silver count = "+bonusSilverCount);

	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
      silverID = rmCreateGrouping("silver "+i, "resource silver ore "+silverType);
      rmSetGroupingMinDistance(silverID, 0.0);
      rmSetGroupingMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(silverID, farAvoidCoin);
		rmAddGroupingConstraint(silverID, avoidAll);
      rmAddGroupingConstraint(silverID, avoidImpassableLand);
		rmPlaceGroupingAtLoc(silverID, 0, 0.5, 0.5);
   }

	for(i=0; < bonusSilverCount)
	{
		silverType = rmRandInt(1,10);
      silver2ID = rmCreateGrouping("bonus silver "+i, "resource silver ore "+silverType);
      rmSetGroupingMinDistance(silver2ID, 0.0);
      rmSetGroupingMaxDistance(silver2ID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(silver2ID, avoidCoin);
		rmAddGroupingConstraint(silver2ID, avoidAll);
      rmAddGroupingConstraint(silver2ID, avoidImpassableLand);
		rmPlaceGroupingAtLoc(silver2ID, 0, 0.5, 0.5);
   }

	// text
rmSetStatusText("",0.90);

	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*rmRandInt(9,10));

	int deerID=rmCreateObjectDef("deer herd");
   rmAddObjectDefItem(deerID, "deer", rmRandInt(8,10), 10.0);
   rmSetObjectDefMinDistance(deerID, 0.0);
   rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(deerID, avoidDeer);
	rmAddObjectDefConstraint(deerID, avoidAll);
   rmAddObjectDefConstraint(deerID, shortAvoidImpassableLand);
    rmAddObjectDefConstraint(deerID, longSideIslandConstraint);
   rmSetObjectDefCreateHerd(deerID, true);
	rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);

	int turkeyID=rmCreateObjectDef("turkey flock");
   rmAddObjectDefItem(turkeyID, "turkey", rmRandInt(10,14), 10.0);
   rmSetObjectDefMinDistance(turkeyID, 0.0);
   rmSetObjectDefMaxDistance(turkeyID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(turkeyID, avoidDeer);
   rmAddObjectDefConstraint(turkeyID, avoidTurkey);
	rmAddObjectDefConstraint(turkeyID, avoidAll);
   rmAddObjectDefConstraint(turkeyID, shortAvoidImpassableLand);
       rmAddObjectDefConstraint(turkeyID, longSideIslandConstraint);
   rmSetObjectDefCreateHerd(turkeyID, true);
	rmPlaceObjectDefAtLoc(turkeyID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);

   // Define and place Forests
   int forestTreeID = 0;
   int numTries=6*cNumberNonGaiaPlayers;
   int failCount=0;
   for (i=0; <numTries)
      {   
         int forest=rmCreateArea("forest "+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(500));
         rmSetAreaForestType(forest, "carolina marsh forest");
         rmSetAreaForestDensity(forest, 1.0);
         rmSetAreaForestClumpiness(forest, 0.0);
         rmSetAreaForestUnderbrush(forest, 0.7);
         rmSetAreaMinBlobs(forest, 1);
         rmSetAreaMaxBlobs(forest, 5);
         rmSetAreaMinBlobDistance(forest, 16.0);
         rmSetAreaMaxBlobDistance(forest, 40.0);
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
         rmAddAreaConstraint(forest, forestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
         rmAddAreaConstraint(forest, shortAvoidImpassableLand); 
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

   // wood resources
   /*
	int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, "treeBayou", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomTreeID, avoidAll);
   rmAddObjectDefConstraint(randomTreeID, shortAvoidImpassableLand);

   rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers);
*/
   int treeVsLand = rmCreateTerrainDistanceConstraint("tree v. land", "land", true, 2.0);
   int nearShore=rmCreateTerrainMaxDistanceConstraint("tree v. water", "land", true, 14.0);

   int randomWaterTreeID=rmCreateObjectDef("random tree in water");
   rmAddObjectDefItem(randomWaterTreeID, "treeBayou", 1, 0.0);
   rmSetObjectDefMinDistance(randomWaterTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomWaterTreeID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomWaterTreeID, nearShore);
   rmAddObjectDefConstraint(randomWaterTreeID, treeVsLand);

	  int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishSalmon", 5, 9.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);

   rmPlaceObjectDefAtLoc(randomWaterTreeID, 0, 0.5, 0.5, 50*cNumberNonGaiaPlayers);
// text
rmSetStatusText("",0.99);
}