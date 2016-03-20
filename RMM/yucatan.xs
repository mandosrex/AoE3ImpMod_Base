// YUCATAN
// Nov. 2005 - JSB - Aztecs changed to Zapotec for Age3Xpack.  Maya left as-is.
// Nov. 06 - Updated for Ypack

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// *******************  Main entry point for random map script  ***************************
void main(void)
{

   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   // *********************  Picks the map size, Map Lighting, Wind, Terrain, and Water  ****************
   float playerTiles=12800;
        if (cNumberNonGaiaPlayers >4)
	        playerTiles = 10800;
        if (cNumberNonGaiaPlayers >6)
	        playerTiles = 8800;			
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   //Map Lighting
   rmSetLightingSet("yucatan");

	//rmSetWindMagnitude(3);
	rmSetWindMagnitude(2);

   // Picks a default water height
   rmSetSeaLevel(4);

   // Picks default terrain and water
   rmSetSeaType("yucatan Coast");
   rmEnableLocalWater(false);
   rmTerrainInitialize("water", 4);
	rmSetMapType("yucatan");
	rmSetMapType("tropical");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);

	chooseMercs();

   // ***************************  Define some classes. These are used later for constraints.  ***************************
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classGold");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("classForest2");
   rmDefineClass("importantItem");
   rmDefineClass("classCliff");
   rmDefineClass("classNatives");
   rmDefineClass("classNuggets");

   // *******************************  Define constraints: used to have objects and areas avoid each other  *****************
    
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
//   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 24.0);

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
   int avoidCW=rmCreateTypeDistanceConstraint("stuff vs CW", "CoveredWagon", 20.0);
  // int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);
     
    // Nature avoidance
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   //int fishVsFish2ID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "AbstractWhale", 10.0);
   int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 18.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
   int forestConstraintSmall=rmCreateClassDistanceConstraint("forest2 vs. forest2", rmClassID("classForest2"), 12.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
   int avoidFood=rmCreateTypeDistanceConstraint("food avoids food", "huntable", 40.0);
   int smallAvoidCoin=rmCreateTypeDistanceConstraint("smallavoid coin", "gold", 30.0);
   int tinyAvoidCoin=rmCreateTypeDistanceConstraint("tinyAvoid coin", "gold", 10.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 50.0);
   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   int avoidStartUnits=rmCreateClassDistanceConstraint("stuff avoid start res", rmClassID("startingUnit"), 2.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
   int avoidCliff=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 6.0);
   int smallavoidCliff=rmCreateClassDistanceConstraint("small vs. cliff", rmClassID("classCliff"), 6.0);
   int mediumavoidCliff=rmCreateClassDistanceConstraint("medium vs. cliff", rmClassID("classCliff"), 12.0);
   int largeAvoidCliff=rmCreateClassDistanceConstraint("large vs. cliff", rmClassID("classCliff"), 18.0);
   int cliffAvoidCliff=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 20.0);
   int cliffFarAvoidCliff=rmCreateClassDistanceConstraint("big cliff vs. cliff", rmClassID("classCliff"), 40.0);
   int avoidFakeLand=rmCreateTerrainDistanceConstraint("avoid passable land", "Land", false, 4.0);

   
	// Constraint to avoid water.
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
   int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 8.0);
   int avoidWater12 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 12.0);
   int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);
   // int oceanConstraint=rmCreateBoxConstraint("land stay away from edges", 0.13, 0, 0.87, 1);

   /*// Cardinal Directions
   int NorthEward=rmCreatePieConstraint("northMapConstraint", 0.75, 0.75, 0, rmZFractionToMeters(0.3), rmDegreesToRadians(355), rmDegreesToRadians(85));
   int SouthWward=rmCreatePieConstraint("southMapConstraint", 0.25, 0.25, 0, rmZFractionToMeters(0.3), rmDegreesToRadians(175), rmDegreesToRadians(275));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));
	*/
   
   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

     // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("avoid natives, trade etc", rmClassID("importantItem"), 10.0);
   int forestAvoidImportantItem=rmCreateClassDistanceConstraint("forest avoid items", rmClassID("importantItem"), 15.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget vs nugget", "abstractnugget", 60.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidImportantItemSmall=rmCreateClassDistanceConstraint("important item small avoidance", rmClassID("importantItem"), 10.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("classNatives"), 30.0);
   int avoidNuggets=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("classNuggets"), 40.0);
   int nuggetAvoidNugget=rmCreateClassDistanceConstraint("nugget avoids nugget", rmClassID("classNuggets"), 20.0);
   int avoidTC=rmCreateTypeDistanceConstraint("objects avoid TC", "towncenter", 25.0);
   int tcAvoidTC=rmCreateTypeDistanceConstraint("Towncenter avoid TC", "towncenter", 20.0);
   int avoidTCTiny=rmCreateTypeDistanceConstraint("objects avoid TC small", "towncenter", 10.0);
   int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 20);
   int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 15.0);
   int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);
   int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 20.0);
   int tcAvoidEdgeConstraint=rmCreatePieConstraint("towncenter avoid edge of map",  0.5, 0.5, 0, rmGetMapXSize()-30, 0, 0, 0);
   int nuggetAvoidEdgeConstraint=rmCreatePieConstraint("nugget avoid edge of map",  0.5, 0.5, 0, rmGetMapXSize()-5, 0, 0, 0);
   int coinAvoidEdgeConstraint=rmCreatePieConstraint("coin avoid edge of map",  0.5, 0.5, 0, rmGetMapXSize()-7, 0, 0, 0);



   // ****************************** Define objects
   // These objects are all defined so they can be placed later

   // Text
   rmSetStatusText("",0.10);

   int bigContinentID = rmCreateArea("big visible continent");
   rmSetAreaLocation(bigContinentID, 0.5, 0.5); 
   rmSetAreaWarnFailure(bigContinentID, false);
   rmSetAreaSize(bigContinentID, 0.6, 0.6);
//	rmAddAreaInfluencePoint(bigContinentID, 0.3, 1);
	rmAddAreaInfluencePoint(bigContinentID, 0.5, 1);
//	rmAddAreaInfluencePoint(bigContinentID, 0.7, 1);
//	rmAddAreaInfluencePoint(bigContinentID, 0.3, 0);
	rmAddAreaInfluencePoint(bigContinentID, 0.5, 0);
//	rmAddAreaInfluencePoint(bigContinentID, 0.7, 0);
//   rmAddAreaConstraint(bigContinentID, oceanConstraint);
   rmSetAreaElevationType(bigContinentID, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinentID, 4.0);
   rmSetAreaBaseHeight(bigContinentID, 5.0);
   rmSetAreaElevationMinFrequency(bigContinentID, 0.09);
   rmSetAreaElevationOctaves(bigContinentID, 3);
   rmSetAreaElevationPersistence(bigContinentID, 0.2); // 0.7
	rmSetAreaElevationNoiseBias(bigContinentID, 1); 
	rmSetAreaMix(bigContinentID, "yucatan_grass");
//	rmPaintAreaTerrainByHeight(bigContinentID, "amazon\ground2_am", 8.0, 10.0);
//	rmPaintAreaTerrainByHeight(bigContinentID, "amazon\ground1_am", 10.0, 16.0);
   rmSetAreaObeyWorldCircleConstraint(bigContinentID, false);
//   rmSetAreaEdgeFilling(bigContinentID, 20);
  	rmSetAreaCoherence(bigContinentID, 0.7);
   rmSetAreaSmoothDistance(bigContinentID, 12);

   rmBuildArea(bigContinentID);


   // Text
   rmSetStatusText("",0.20);

 // *********  Set up player starting locations along the river. These are used to place Starting TC's  ************

   // Place Players
   rmSetTeamSpacingModifier(0.3);

   int teamZeroCount = rmGetNumberPlayersOnTeam(0);
   int teamOneCount = rmGetNumberPlayersOnTeam(1);
   float teamOrientation = rmRandFloat(0, 1);
   float OneVOnePlacement=rmRandFloat(0, 1);
  
   if ( teamOrientation < 0.5)
   {
	 if ( cNumberTeams == 2 && teamZeroCount <= 4 && teamOneCount <= 4 )
	{
	   // TEAM ONE PLACEMENT RULES
	   if ( teamZeroCount == 1)
	   {	
		   rmSetPlacementTeam(0);
		   //if ( OneVOnePlacement < 0.5)
		   if ( teamOrientation < 0.5)
		   {
		  	   rmPlacePlayersLine(0.28, 0.80, 0.72, 0.80, 0, 0.05);
		   }
		   else
		   {
		 	   rmPlacePlayersLine(0.72, 0.20, 0.28, 0.20, 0, 0.05);
		   }
	   }
	   else if ( teamZeroCount >= 2 )
	   {	
		   rmSetPlacementTeam(0);
		   if ( teamOrientation < 0.5)
		   {
			   rmPlacePlayersLine(0.25, 0.80, 0.75, 0.80, 0.05, 0.2);
		       rmSetTeamSpacingModifier(0.25);
		   }
		   else
		   {
			   rmPlacePlayersLine(0.75, 0.20, 0.25, 0.20, 0.05, 0.2);
			   rmSetTeamSpacingModifier(0.25);
		   }
		   //rmSetPlacementSection(0.01, 0.25);
	   }

	   // TEAM 2 PLACEMENT RULES
	   if ( teamOneCount == 1)
	   {
		   rmSetPlacementTeam(1);
		  // if ( OneVOnePlacement < 0.5)
		   if ( teamOrientation < 0.5)
		   {
			   rmPlacePlayersLine(0.72, 0.20, 0.28, 0.20, 0, 0.05);
		   }
		   else
		   {
			   rmPlacePlayersLine(0.28, 0.80, 0.72, 0.80, 0, 0.05);
		   }
	   }
	   else if (teamOneCount >= 2 )
	   {
		   rmSetPlacementTeam(1);
		   if ( teamOrientation < 0.5)
		   {
		       rmPlacePlayersLine(0.75, 0.20, 0.25, 0.20, 0.05, 0.02);
		       rmSetTeamSpacingModifier(0.25);
		   }
		   else 
		   {
		       rmPlacePlayersLine(0.25, 0.80, 0.75, 0.80, 0.05, 0.02);
			   rmSetTeamSpacingModifier(0.25);
		   }
		   //rmSetPlacementSection(0.5, 0.75);
	   }
	}
	 else
	   {
		   rmSetTeamSpacingModifier(0.7);
		   rmPlacePlayersSquare(0.38, 0.0, 0.0);
	   }
   }

  else 
    {
	   if ( cNumberTeams == 2 && teamZeroCount <= 4 && teamOneCount <= 4 )
	   {
		   // TEAM ONE PLACEMENT RULES
		   if ( teamZeroCount == 1)
		   {	
			   rmSetPlacementTeam(0);
			   //if ( OneVOnePlacement < 0.5)
			   if ( teamOrientation < 0.5)
			   {
				   rmPlacePlayersLine(0.72, 0.80, 0.28, 0.80, 0, 0.05);
			   }
			   else
			   {
				   rmPlacePlayersLine(0.28, 0.20, 0.72, 0.20, 0, 0.05);
			   }
		   }
		   else if ( teamZeroCount >= 2 )
		   {	
			   rmSetPlacementTeam(0);
			   if ( teamOrientation < 0.5)
			   {
				   rmPlacePlayersLine(0.75, 0.80, 0.25, 0.80, 0.05, 0.2);
				   rmSetTeamSpacingModifier(0.25);
			   }
			   else
			   {
				   rmPlacePlayersLine(0.25, 0.20, 0.75, 0.20, 0.05, 0.2);
				   rmSetTeamSpacingModifier(0.25);
			   }
			   //rmSetPlacementSection(0.01, 0.25);
		   }

		   // TEAM 2 PLACEMENT RULES
		   if ( teamOneCount == 1)
		   {
			   rmSetPlacementTeam(1);
			   // if ( OneVOnePlacement < 0.5)
			   if ( teamOrientation < 0.5)
			   {
				   rmPlacePlayersLine(0.28, 0.20, 0.72, 0.20, 0, 0.05);
			   }
			   else
			   {
				   rmPlacePlayersLine(0.72, 0.80, 0.28, 0.80, 0, 0.05);
			   }
		   }
		   else if (teamOneCount >= 2 )
		   {
			   rmSetPlacementTeam(1);
			   if ( teamOrientation < 0.5)
			   {
				   rmPlacePlayersLine(0.25, 0.20, 0.75, 0.20, 0.05, 0.02);
				   rmSetTeamSpacingModifier(0.25);
			   }
			   else 
			   {
				   rmPlacePlayersLine(0.75, 0.80, 0.25, 0.80, 0.05, 0.02);
				   rmSetTeamSpacingModifier(0.25);
			   }
			   //rmSetPlacementSection(0.5, 0.75);
		   }
	   }
	 else
		{
		   rmSetTeamSpacingModifier(0.7);
		   rmPlacePlayersSquare(0.38, 0.0, 0.0);
	    }
	}

    // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.`
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
//      rmSetAreaTerrainType(id, "carolina\marshflats");
//      rmSetAreaBaseHeight(id, 8.0);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();

	// Text
   rmSetStatusText("",0.20);

   // Clear out constraints for good measure.
   rmClearClosestPointConstraints();

   // Text
   rmSetStatusText("",0.30); 


   // Placement order
   // Trade route -> River (none on this map) -> Natives -> Secrets -> Cliffs -> Nuggets

//********************************************  Place Trade Route  *******************************************

	// Trade Route on the north side of the river
	int tradeRouteID = rmCreateTradeRoute();

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
   rmSetObjectDefAllowOverlap(socketID, true);
   rmSetObjectDefMinDistance(socketID, 0.0);
   rmSetObjectDefMaxDistance(socketID, 12.0);

	float tradeRouteLoc = -1;
	
	if ( cNumberTeams == 2 && teamZeroCount <= 1 && teamOneCount <= 1 )
	{
		tradeRouteLoc = (0.25);
	}
	else if (cNumberTeams <= 2)  
	{
		tradeRouteLoc = (rmRandFloat(0,1));		
	}
	else 
	{
		tradeRouteLoc = (rmRandFloat(0,0.99));
	}

	if (tradeRouteLoc < 0.33) // Center
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 1);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0, 18, 22);
	}
	else if (tradeRouteLoc < 0.66) // Triangle left route
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 1);
		//rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.8);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.6, 0.8, 8, 10);
		//rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.5);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.3, 0.5, 8, 10);
		//rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.2);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.6, 0.2, 8, 10);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.7, 0, 8, 10);
	}
	else  // Triangle right route
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 1);
		//rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.8);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.4, 0.8, 8, 10);
		//rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 0.5);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.7, 0.5, 8, 10);
		//rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 0.2);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.4, 0.2, 8, 10);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.3, 0, 8, 10);
	} 
 	/*else if (tradeRouteLoc < 0.86) // left route
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.3, 1);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.3, 0, 18, 22);
	}
	else // right route
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.7, 1);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.7, 0, 18, 22);
	}
*/
   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 

   // add the sockets along the trade route.`
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);// was 0.1
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	if(tradeRouteLoc < 0.25) // if center place 1/4 and 3/4
	{
		if(rmRandFloat(0,1)<0.5)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.30);//.25
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.70);//.75
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
	}

	if(tradeRouteLoc < 0.25) // if center place 1/2
	{
		if(rmRandFloat(0,1)<0.5)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
	}
	else if(tradeRouteLoc < 0.5) // if triangle place middle socket
	{
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}


	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);//was 0.9
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	

   // Text
   rmSetStatusText("",0.40);

// ************************************  Build Invisible Islands  ************************************

   // Build an invisible north island area.
   int northIslandID = rmCreateArea("north east invisible island");
//	rmSetAreaWarnFailure(northIslandID, false);
   rmSetAreaLocation(northIslandID, 0.5, 0.75); 
   rmSetAreaWarnFailure(northIslandID, false);
   rmSetAreaSize(northIslandID, 0.25, 0.25);
   rmSetAreaCoherence(northIslandID, 1.0);
//	rmSetAreaTerrainType(northIslandID, "carolinas\bluestemgrass");

   // Build an invisible south island area.
   int southIslandID = rmCreateArea("south west invisible island");
   rmSetAreaLocation(southIslandID, 0.5, 0.25); 
   rmSetAreaWarnFailure(southIslandID, false);
   rmSetAreaSize(southIslandID, 0.25, 0.25);
   rmSetAreaCoherence(southIslandID, 1.0);
//	rmSetAreaTerrainType(southIslandID, "carolinas\cobblestone");

   rmBuildAllAreas();

   int northeastConstraint=rmCreateAreaConstraint("NE", northIslandID);
   int southwestConstraint=rmCreateAreaConstraint("SW", southIslandID);

//***************************************  Starting Resources  ********************************************  

   // PLAYER STARTING TC, Natives, and RESOURCES

   rmClearClosestPointConstraints(); // Clear for waterflag placement

   // Native placement point
   float nativemintile=20;
   float nativemaxtile=30;
   float nativeplaceminX = (rmXTilesToFraction(nativemintile));
   float nativeplaceminZ = (rmZTilesToFraction(nativemintile));
   float nativeplacemaxX = (rmXTilesToFraction(nativemaxtile));
   float nativeplacemaxZ = (rmZTilesToFraction(nativemaxtile));
   float nativemeterminX = (rmXFractionToMeters(nativeplaceminX));
   float nativemetermaxX = (rmXFractionToMeters(nativeplacemaxX));
   float nativemeterminZ = (rmZFractionToMeters(nativeplaceminZ));
   float nativemetermaxZ = (rmZFractionToMeters(nativeplacemaxZ));

   int TCfloat = -1;
   if (cNumberTeams == 2 && cNumberNonGaiaPlayers <= 4)
	   TCfloat = 32;
   else 
	   TCfloat = 60;

   int TCID = rmCreateObjectDef("player TC");
   if ( rmGetNomadStart())
   {
	   rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
	   rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
   }
   rmSetObjectDefMinDistance(TCID, 0.0);
   rmSetObjectDefMaxDistance(TCID, TCfloat);
   rmAddObjectDefConstraint(TCID, avoidTradeRoute);
   rmAddObjectDefConstraint(TCID, avoidWater8); 
   rmAddObjectDefConstraint(TCID, tcAvoidTC);
   rmAddObjectDefConstraint(TCID, tcAvoidEdgeConstraint);
   //rmPlaceObjectDefPerPlayer(TCID, true);

   int subCiv = -1;
 
   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 5.0);
   rmSetObjectDefMaxDistance(startingUnits, 10.0);
   rmAddObjectDefConstraint(startingUnits, avoidAll);
   rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);
   rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
   //rmPlaceObjectDefPerPlayer(startingUnits, true);
   //rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      
   int playerSilverID = rmCreateObjectDef("player silver");
   rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
   rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
   rmSetObjectDefMinDistance(playerSilverID, 15.0);
   rmSetObjectDefMaxDistance(playerSilverID, 25.0);
   rmAddObjectDefConstraint(playerSilverID, avoidAll);
   rmAddObjectDefToClass(playerSilverID, rmClassID("classGold"));
   rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);
   //rmPlaceObjectDefPerPlayer(playerSilverID, true);
   //rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

   int playerSilver2ID = rmCreateObjectDef("player silver2");
   rmAddObjectDefItem(playerSilver2ID, "mine", 1, 0);
   rmAddObjectDefConstraint(playerSilver2ID, avoidTradeRoute);
   rmSetObjectDefMinDistance(playerSilver2ID, 35.0);
   rmSetObjectDefMaxDistance(playerSilver2ID, 45.0);
   rmAddObjectDefConstraint(playerSilver2ID, avoidAll);
   rmAddObjectDefConstraint(playerSilver2ID, tinyAvoidCoin);
   rmAddObjectDefToClass(playerSilver2ID, rmClassID("classGold"));
   rmAddObjectDefConstraint(playerSilver2ID, avoidImpassableLand);
   //rmPlaceObjectDefPerPlayer(playerSilver2ID, true);
   //rmPlaceObjectDefAtLoc(playerSilver2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

   int playerTreeID=rmCreateObjectDef("player trees");
   rmAddObjectDefItem(playerTreeID, "TreeYucatan", 6, 8.0);
   rmSetObjectDefMinDistance(playerTreeID, 5);
   rmSetObjectDefMaxDistance(playerTreeID, 10);
   rmAddObjectDefConstraint(playerTreeID, avoidAll);
   rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
   //rmPlaceObjectDefPerPlayer(playerTreeID, false, rmRandInt(3,5));
   //rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

   int playerBerryID=rmCreateObjectDef("player berries");
   rmAddObjectDefItem(playerBerryID, "berryBush", rmRandInt(2,3), 5.0);
   rmSetObjectDefMinDistance(playerBerryID, 8);
   rmSetObjectDefMaxDistance(playerBerryID, 15);
   rmAddObjectDefConstraint(playerBerryID, avoidAll);
   rmAddObjectDefConstraint(playerBerryID, avoidImpassableLand);
   rmAddObjectDefToClass(playerBerryID, rmClassID("startingUnit"));
   //rmPlaceObjectDefPerPlayer(playerBerryID, false);
   //rmPlaceObjectDefAtLoc(playerBerryID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

   int waterFlagID=rmCreateObjectDef("HC water flag "+i);
   rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
   rmAddClosestPointConstraint(flagEdgeConstraint);
   rmAddClosestPointConstraint(flagVsFlag);
   rmAddClosestPointConstraint(flagLand);



   // John's sweet solution to placing stuff around the TC regardless of where the player start area actually is, YAY!!!!!!
   for(i=1; <cNumberPlayers)
   {

	   rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	   vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
	   vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	   //vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
	   float NativePicker = rmRandFloat(0,1.0);
	   int nativeVillageID = -1;
	   int nativeVillageType = -1;
	   if(NativePicker < 0.55)

	   {
		   subCiv = rmGetCivID("zapotec");
		   if (subCiv >= 0)
			   rmSetSubCiv(i, "zapotec"); 

		   nativeVillageType = rmRandInt(1,3);
		   nativeVillageID = rmCreateGrouping("zapotec village"+i, "native zapotec village "+nativeVillageType);

	   }
	   else
	   {
		   subCiv = rmGetCivID("Maya");
		   if (subCiv >= 0)
			   rmSetSubCiv(i, "Maya");

		   nativeVillageType = rmRandInt(1,3);
		   nativeVillageID = rmCreateGrouping("Maya village"+i, "native Maya village "+nativeVillageType);

	   }

		   rmSetGroupingMinDistance(nativeVillageID, 15.0);
		   rmSetGroupingMaxDistance(nativeVillageID, 40.0);
		   rmAddGroupingConstraint(nativeVillageID, avoidImpassableLand);
		   rmAddGroupingToClass(nativeVillageID, rmClassID("importantItem"));
		   rmAddGroupingConstraint(nativeVillageID, avoidTradeRoute);
		   rmAddGroupingConstraint(nativeVillageID, avoidImportantItem);
		   rmAddGroupingConstraint(nativeVillageID, avoidTCTiny);
	  

	   int test = 20;	
	   float NativeLocX = -1;
	   float NativeLocZ = -1;
	   float angle = -1;
	   float radius = -1;
	   int done = 0;
	   while(test > 0 && done == 0)
	   {	
		   /*
		   angle = rmRandFloat(0, 2*PI);
		   radius = rmRandFloat(nativemeterminX, nativemetermaxX);
		   NativeLocX = radius * _cos(angle) + xsVectorGetX(TCLoc);
		   NativeLocZ = radius * _sin(angle) + xsVectorGetZ(TCLoc);
		   */
		   done = rmPlaceGroupingAtLoc(nativeVillageID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		   test = test-1;
	   }
      
	   rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	   rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	   rmPlaceObjectDefAtLoc(playerSilver2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	   rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	   rmPlaceObjectDefAtLoc(playerBerryID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
     
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 0), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      
	   rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));

   }

//  *******************  WATER HC ARRIVAL POINT  *********************
      
  /* int waterFlagID = 0;
   for(i=1; <cNumberPlayers)

   {
	   waterFlagID=rmCreateObjectDef("HC water flag "+i);
	   rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
	   rmAddObjectDefConstraint(waterFlagID, fishLand);
	   rmAddObjectDefConstraint(waterFlagID, flagVsFlag);
	   rmSetObjectDefMinDistance(waterFlagID, rmXFractionToMeters(0.4));
	   rmSetObjectDefMaxDistance(waterFlagID, rmXFractionToMeters(0.45));
	   rmPlaceObjectDefAtLoc(waterFlagID, i, 0.50, 0.5, 1);
   }  
*/

 
   int numTries = -1;
   int failCount = -1;

  // ************************  Define and place Cliffs then nuggets  *******************************
   numTries=cNumberNonGaiaPlayers+1;
   failCount=0;
   for(i=0; <numTries)
   {
      int cliffID=rmCreateArea("cliff"+i);
	  rmSetAreaSize(cliffID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(45));
      //rmSetAreaSize(cliffID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(90));
	  //rmSetAreaSize(cliffID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(400));
      rmSetAreaWarnFailure(cliffID, false);
	  rmSetAreaCliffType(cliffID, "Amazon");
      int edgeRand=rmRandInt(0,100);
      rmSetAreaCliffEdge(cliffID, 1, 1);
      rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, true);
      rmSetAreaCliffHeight(cliffID, 6, 2.0, 0.5);
      rmSetAreaHeightBlend(cliffID, 1);
      //rmAddAreaTerrainLayer(cliffID, "Amazon\ground2_ama", 0, 2);
      rmAddAreaToClass(cliffID, rmClassID("classCliff")); 
      rmAddAreaConstraint(cliffID, cliffFarAvoidCliff);
      rmAddAreaConstraint(cliffID, avoidTradeRoute);
      rmAddAreaConstraint(cliffID, avoidImportantItem);
      rmAddAreaConstraint(cliffID, avoidWater12);
	  rmAddAreaConstraint(cliffID, tinyAvoidCoin);
	  rmAddAreaConstraint(cliffID, avoidTC);
	  rmAddAreaConstraint(cliffID, avoidCW);
	  rmAddAreaConstraint(cliffID, avoidStartUnits);	  
      /*rmSetAreaMinBlobs(cliffID, 2); //3
      rmSetAreaMaxBlobs(cliffID, 3); //5
      rmSetAreaMinBlobDistance(cliffID, 4.0); //16
      rmSetAreaMaxBlobDistance(cliffID, 8.0); //40
	  */
      //rmSetAreaCoherence(cliffID, 0.0);
      rmSetAreaSmoothDistance(cliffID, 10);
      rmSetAreaCoherence(cliffID, 0.25);

      if(rmBuildArea(cliffID)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==6)
            break;
      }
      else
         failCount=0;
   }

   // Text
   rmSetStatusText("",0.60);


  // Another cliff

   numTries=cNumberNonGaiaPlayers*2;
   failCount=0;
   for(i=0; <numTries)
   {
      int cliff2ID=rmCreateArea("cliff small tall "+i);
      rmSetAreaSize(cliff2ID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(90));
      rmSetAreaWarnFailure(cliff2ID, false);
      rmSetAreaCliffType(cliff2ID, "Amazon");
      edgeRand=rmRandInt(0,100);
      rmSetAreaCliffEdge(cliff2ID, 1, 1);
      rmSetAreaCliffPainting(cliff2ID, false, true, true, 1.5, true);
      rmSetAreaCliffHeight(cliff2ID, 6, 2.0, 0.5);
      rmSetAreaHeightBlend(cliff2ID, 1);
      rmAddAreaTerrainLayer(cliff2ID, "Amazon\ground2_ama", 0, 2);
      rmAddAreaToClass(cliff2ID, rmClassID("classCliff")); 
      rmAddAreaConstraint(cliff2ID, cliffAvoidCliff);
      rmAddAreaConstraint(cliff2ID, avoidTradeRoute);
      rmAddAreaConstraint(cliff2ID, avoidImportantItem);
      rmAddAreaConstraint(cliff2ID, avoidWater12);
	  rmAddAreaConstraint(cliff2ID, tinyAvoidCoin);
	  rmAddAreaConstraint(cliff2ID, avoidTC);
	  rmAddAreaConstraint(cliff2ID, avoidCW);
	  rmAddAreaConstraint(cliff2ID, avoidStartUnits);
      /*rmSetAreaMinBlobs(cliff2ID, 3);
      rmSetAreaMaxBlobs(cliff2ID, 5);
      rmSetAreaMinBlobDistance(cliff2ID, 16.0);
      rmSetAreaMaxBlobDistance(cliff2ID, 40.0);
      */
	  //rmSetAreaCoherence(cliff2ID, 0.0);
      rmSetAreaSmoothDistance(cliff2ID, 10);
      rmSetAreaCoherence(cliff2ID, 0.25);

      if(rmBuildArea(cliff2ID)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==6)
            break;
      }
      else
         failCount=0;
   }
	// Place nuggets
  
   int nugget1= rmCreateObjectDef("nugget easy"); 
   rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(1, 1);
   rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget1, avoidNugget);
   rmAddObjectDefConstraint(nugget1, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget1, avoidAll);
   rmAddObjectDefConstraint(nugget1, nuggetAvoidEdgeConstraint);
   rmAddObjectDefToClass(nugget1, rmClassID("classNuggets"));
   rmSetObjectDefMinDistance(nugget1, 20.0);
   rmSetObjectDefMaxDistance(nugget1, 40.0);
   rmPlaceObjectDefPerPlayer(nugget1, false, 2);

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
   rmAddObjectDefConstraint(nugget2, avoidWater12);
   rmAddObjectDefConstraint(nugget2, nuggetAvoidEdgeConstraint);
   rmAddObjectDefToClass(nugget2, rmClassID("classNuggets"));
   rmSetObjectDefMinDistance(nugget2, 60.0);
   rmSetObjectDefMaxDistance(nugget2, 100.0);
   rmPlaceObjectDefPerPlayer(nugget2, false, 2);

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
   rmAddObjectDefConstraint(nugget3, avoidWater12);
   rmAddObjectDefConstraint(nugget3, nuggetAvoidEdgeConstraint);
   rmAddObjectDefToClass(nugget3, rmClassID("classNuggets"));
   rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

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
   rmAddObjectDefConstraint(nugget4, avoidWater12);
   rmAddObjectDefConstraint(nugget4, nuggetAvoidEdgeConstraint);
   rmAddObjectDefToClass(nugget4, rmClassID("classNuggets"));
   rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(0,3));

   /*
	int nuggetID= rmCreateObjectDef("NE nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmAddObjectDefConstraint(nuggetID, northeastConstraint);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, (cNumberNonGaiaPlayers*3));

	int nugget2ID= rmCreateObjectDef("SW nugget"); 
	rmAddObjectDefItem(nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget2ID, 0.0);
	rmSetObjectDefMaxDistance(nugget2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(nugget2ID, avoidNugget);
	rmAddObjectDefConstraint(nugget2ID, avoidAll);
	rmAddObjectDefConstraint(nugget2ID, southwestConstraint);
	rmPlaceObjectDefAtLoc(nugget2ID, 0, 0.5, 0.5, (cNumberNonGaiaPlayers*3));
   */
		
// *********************  Place fish in both water bodies  ****************************

   int fishID=rmCreateObjectDef("NE fish");
   rmAddObjectDefItem(fishID, "FishSalmon", 3, 9.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 1.0, 0.5, 4*cNumberNonGaiaPlayers);

   int whaleID=rmCreateObjectDef(" NE whale");
   rmAddObjectDefItem(whaleID, "HumpbackWhale", 1, 9.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   rmPlaceObjectDefAtLoc(whaleID, 0, 1.0, 0.5, 2*cNumberNonGaiaPlayers);

   int fish2ID=rmCreateObjectDef("SE fish");
   rmAddObjectDefItem(fish2ID, "FishSalmon", 3, 9.0);
   rmSetObjectDefMinDistance(fish2ID, 0.0);
   rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fish2ID, fishVsFishID);
   rmAddObjectDefConstraint(fish2ID, fishLand);
   rmPlaceObjectDefAtLoc(fish2ID, 0, 0.0, 0.5, 4*cNumberNonGaiaPlayers);

   int whale2ID=rmCreateObjectDef("SE whale");
   rmAddObjectDefItem(whale2ID, "HumpbackWhale", 1, 9.0);
   rmSetObjectDefMinDistance(whale2ID, 0.0);
   rmSetObjectDefMaxDistance(whale2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whale2ID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whale2ID, whaleLand);
   rmPlaceObjectDefAtLoc(whale2ID, 0, 0.0, 0.5, 2*cNumberNonGaiaPlayers);

   // Text
   rmSetStatusText("",0.70);
 
 //  ******************  Place resources that we want forests to avoid (Coin) ***************************

   int silverID = -1;
   int silverCount = (cNumberNonGaiaPlayers*2 + rmRandInt(4,6));
   rmEchoInfo("silver count = "+silverCount);

   for(i=0; < silverCount)
   {
	   silverID = rmCreateObjectDef("silver "+i);
	   rmAddObjectDefItem(silverID, "mine", 1, 0.0);
	   rmSetObjectDefMinDistance(silverID, 0.0);
	   rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(silverID, avoidCoin);
	   rmAddObjectDefConstraint(silverID, avoidAll);
	   rmAddObjectDefConstraint(silverID, avoidTC);
	   rmAddObjectDefConstraint(silverID, avoidCW);
	   rmAddObjectDefConstraint(silverID, avoidImportantItem);
	   rmAddObjectDefConstraint(silverID, avoidImpassableLand);
	   rmAddObjectDefConstraint(silverID, avoidTradeRoute);
	   rmAddObjectDefConstraint(silverID, coinAvoidEdgeConstraint);
	   rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   }

	

//  ***************************  Define and place Forests  *******************************
   int forestTreeID = 0;
   numTries=6*cNumberNonGaiaPlayers;
   failCount=0;
   for (i=0; <numTries)
   {
	   if(cNumberNonGaiaPlayers > 2)
      {   
         int forest=rmCreateArea("forest"+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(500));
         rmSetAreaForestType(forest, "Yucatan forest");
         rmSetAreaForestDensity(forest, .7);
         rmSetAreaForestClumpiness(forest, 0.0);
		 rmSetAreaForestUnderbrush(forest, 0.0);
         rmSetAreaMinBlobs(forest, 3);
         rmSetAreaMaxBlobs(forest, 5);
         rmSetAreaMinBlobDistance(forest, 8.0);  // 12
         rmSetAreaMaxBlobDistance(forest, 16.0);  // 24
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
	      rmAddAreaToClass(forest, rmClassID("classForest"));
         rmAddAreaConstraint(forest, forestConstraint);
			rmAddAreaConstraint(forest, avoidAll);
			rmAddAreaConstraint(forest, tinyAvoidCoin);
			rmAddAreaConstraint(forest, avoidImportantItem);
         rmAddAreaConstraint(forest, avoidCliff);
         rmAddAreaConstraint(forest, avoidWater4); 
         rmAddAreaConstraint(forest, avoidTradeRoute); 
         rmAddAreaConstraint(forest, avoidTCTiny);
		 if(rmBuildArea(forest)==false)
		 {
			 // Stop trying once we fail 3 times in a row.
			 failCount++;
			 if(failCount==6)
				 break;
		 } 
		 else 
			 failCount=0; 
	  }
	   else
	   {
       numTries=10*cNumberNonGaiaPlayers;
	   int forest2=rmCreateArea("forest2"+i);
	   rmSetAreaWarnFailure(forest2, false);
	   rmSetAreaSize(forest2, rmAreaTilesToFraction(100), rmAreaTilesToFraction(375));
	   rmSetAreaForestType(forest2, "Yucatan forest");
	   rmSetAreaForestDensity(forest2, .7);
	   rmSetAreaForestClumpiness(forest2, 0.0);
	   rmSetAreaForestUnderbrush(forest, 0.0);
	   rmSetAreaMinBlobs(forest2, 2);
	   rmSetAreaMaxBlobs(forest2, 3);
	   rmSetAreaMinBlobDistance(forest2, 4.0);  // 8
	   rmSetAreaMaxBlobDistance(forest2, 9.0);  // 16
	   rmSetAreaCoherence(forest2, 0.4);
	   rmSetAreaSmoothDistance(forest2, 10);
	   rmAddAreaToClass(forest2, rmClassID("classForest2"));
	   rmAddAreaConstraint(forest2, forestConstraintSmall);
	   rmAddAreaConstraint(forest2, avoidAll);
	   rmAddAreaConstraint(forest2, tinyAvoidCoin);
	   rmAddAreaConstraint(forest2, forestAvoidImportantItem);
	   rmAddAreaConstraint(forest2, avoidCliff);
	   rmAddAreaConstraint(forest2, avoidWater4); 
	   rmAddAreaConstraint(forest2, avoidTradeRoute); 
	   if(rmBuildArea(forest2)==false)
	   {
		   // Stop trying once we fail 3 times in a row.
		   failCount++;
		   if(failCount==5)
			   break;
	   }
	   else
		   failCount=0; 
	   }
        
	}
 
  // Text
   rmSetStatusText("",0.80);
   
  bool weird = false;
    
  if (cNumberTeams > 2 || (teamZeroCount - teamOneCount) > 1 || (teamOneCount - teamZeroCount) > 1)
    weird = true;
  
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
    
    int randLoc = rmRandInt(1,3);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.045;
    
    //~ if(randLoc == 1 || weird)
      //~ xLoc = .5;
    
    //~ else if(randLoc == 2)
      //~ xLoc = .65;
      
    ypKingsHillPlacer(xLoc, yLoc, walk, avoidCliff);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

// **************************  Resources that can be placed after forests (Hunting)  ***************************

	int tapirCount = rmRandInt(4,6);
	int capyCount = rmRandInt(6,8);

   int tapirID=rmCreateObjectDef("NW tapir crash");
   rmAddObjectDefItem(tapirID, "tapir", tapirCount, 2.0);
   rmSetObjectDefMinDistance(tapirID, 0.0);
   rmSetObjectDefMaxDistance(tapirID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(tapirID, avoidFood);
   rmAddObjectDefConstraint(tapirID, avoidImpassableLand);
   rmAddObjectDefConstraint(tapirID, avoidCliff);
   rmAddObjectDefConstraint(tapirID, avoidAll);
	rmAddObjectDefConstraint(tapirID, northeastConstraint);
   rmSetObjectDefCreateHerd(tapirID, true);
   rmPlaceObjectDefAtLoc(tapirID, 0, 0.5, 0.5, tapirCount*0.5*cNumberNonGaiaPlayers);

	int tapir2ID=rmCreateObjectDef("SE tapir crash");
   rmAddObjectDefItem(tapir2ID, "tapir", tapirCount, 2.0);
   rmSetObjectDefMinDistance(tapir2ID, 0.0);
   rmSetObjectDefMaxDistance(tapir2ID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(tapir2ID, avoidFood);
   rmAddObjectDefConstraint(tapir2ID, avoidImpassableLand);
   rmAddObjectDefConstraint(tapir2ID, avoidCliff);
   rmAddObjectDefConstraint(tapir2ID, avoidAll);
	rmAddObjectDefConstraint(tapir2ID, southwestConstraint);
   rmSetObjectDefCreateHerd(tapir2ID, true);
   rmPlaceObjectDefAtLoc(tapir2ID, 0, 0.5, 0.5, tapirCount*0.5*cNumberNonGaiaPlayers);

	int capybaraID=rmCreateObjectDef("NW capybara pack");
   rmAddObjectDefItem(capybaraID, "capybara", capyCount, 2.0);
   rmSetObjectDefMinDistance(capybaraID, 0.0);
   rmSetObjectDefMaxDistance(capybaraID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(capybaraID, avoidFood);
   rmAddObjectDefConstraint(capybaraID, avoidImpassableLand);
   rmAddObjectDefConstraint(capybaraID, avoidCliff);
   rmAddObjectDefConstraint(capybaraID, avoidAll);
	rmAddObjectDefConstraint(capybaraID, northeastConstraint);
   rmSetObjectDefCreateHerd(capybaraID, true);
	rmPlaceObjectDefAtLoc(capybaraID, 0, 0.5, 0.5, capyCount*2*cNumberNonGaiaPlayers);

	int capybara2ID=rmCreateObjectDef("SE capybara pack");
   rmAddObjectDefItem(capybara2ID, "capybara", capyCount, 2.0);
   rmSetObjectDefMinDistance(capybara2ID, 0.0);
   rmSetObjectDefMaxDistance(capybara2ID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(capybara2ID, avoidFood);
   rmAddObjectDefConstraint(capybara2ID, avoidImpassableLand);
   rmAddObjectDefConstraint(capybara2ID, avoidCliff);
   rmAddObjectDefConstraint(capybara2ID, avoidAll);
	rmAddObjectDefConstraint(capybara2ID, southwestConstraint);
   rmSetObjectDefCreateHerd(capybara2ID, true);
	rmPlaceObjectDefAtLoc(capybara2ID, 0, 0.5, 0.5, capyCount*2*cNumberNonGaiaPlayers);

   // wood resources
   /*int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, "treeamazon", 1, 0.0);
   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomTreeID, avoidResource);
   rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
   rmAddObjectDefConstraint(randomTreeID, avoidCliff);
   rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 12*cNumberNonGaiaPlayers);
  */
  // Text
   rmSetStatusText("",0.90);

   // Define and place decorations: rocks and grass and stuff 
/*
   rmSetMapClusteringPlacementParams(0.0, 0.2, 1.0, cClusterLand);
   rmSetMapClusteringObjectParams(0, 2, 0.5);
   rmPlaceMapClusters("amazon\ground3_am", "OpenbrushAmazon");
*/
   // Text
   rmSetStatusText("",1.0); 
      
}  
