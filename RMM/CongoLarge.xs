/* 
# Mosquito Coast
# 
# Monteverde / Tortuguero / Cano Negro
# 
# The map portrays a corner of the Caribbean lowlands - a maze of rivers, canals, lagoons 
# and tidal wetlands. Showcasing lush and dense cloud forests, home of a unique mix of 
# animals and plants, the region gets heavy rainfall throughout the year.
# 
# The script may randomly load one of two variations:
# 1. A coastal plateau with numerous deep water pockets, rock ridges and some cliffs peppering the landscape
# 2. A strip of land with a trade route in the middle section and two smaller land areas on opposite edges of the map, separated by winding water canals
# 
# FFA has a separate variation with delta islands, divided by pathable waters, and two trade route areas on opposite edges of the map (their positions are random).
# 
# Each player side gets a native settlement (Caribs or Maya/Jesuits on TAD) in the trade route variation. More settlements can be found 
# close to the edges of the map, in the coastal variation.
# 
# April-July-November
# 
# Mister 2014
*/

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

bool Asian = false;

bool IsYP(){
	if (rmGetCivID("Japanese")==19)
		Asian = true;
	return(Asian);
}

int landnoise=0; 
int num=0; 
void Area(float Asize=0.0, float spotX=0.0, float spotZ=0.0, string Paint=""){
	landnoise=rmCreateArea("Some Area"+num); 
	rmSetAreaSize(landnoise, Asize, Asize); 
	rmSetAreaTerrainType(landnoise, Paint); 
	rmSetAreaCliffType(landnoise, "uger"); 
	rmSetAreaCliffHeight(landnoise, 1.0, 0.0, 1.0); 
	rmSetAreaCliffEdge(landnoise, 1, 1.0, 0.0, 0.0, 0); 
	rmSetAreaCliffPainting(landnoise, true, false, false, 0, true); 
	rmSetAreaCoherence(landnoise, 0.80); 
	rmSetAreaSmoothDistance(landnoise, 3); 
	rmSetAreaHeightBlend(landnoise, 4); 
	rmSetAreaBaseHeight(landnoise, 0.0); 
	rmSetAreaElevationNoiseBias(landnoise, 0);
    rmSetAreaElevationEdgeFalloffDist(landnoise, 3);
	rmSetAreaElevationVariation(landnoise, 2);
	rmSetAreaElevationPersistence(landnoise, 0.3);
	rmSetAreaElevationOctaves(landnoise, 4);
	rmSetAreaElevationMinFrequency(landnoise, 0.04);
	rmSetAreaElevationType(landnoise, cElevTurbulence);
	rmSetAreaLocation(landnoise, spotX, spotZ); 			// DBG flag -- line 912
	num=num+1;												
}

float PI = 3.1415926535897932384626433832795;
float pow(float x = 0,int p = 0) { 
	float x2 = 1;	float x4 = 1; float x8 = 1; float x16 = 1; float x32 = 1; float x64 = 1; 
	if(p>=2) x2 = x*x; 
	if(p>=4) x4 = x2*x2; 
	if(p>=8) x8 = x4*x4; 
	if(p>=16) x16 = x8*x8; 
	if(p>=32) x32 = x16*x16; 
	if(p>=64) x64 = x32*x32; 
	float ret = 1;	
	while(p>=64) {	ret = ret * x64; p = p - 64; }	
	if(p>=32) { ret = ret * x32; p = p - 32; } 
	if(p>=16) { ret = ret * x16; p = p - 16; } 
	if(p>=8) { ret = ret * x8; p = p - 8; } 
	if(p>=4) { ret = ret * x4; p = p - 4; } 
	if(p>=2) { ret = ret * x2; p = p - 2; } 
	if(p>=1) { ret = ret * x; p = p - 1; } 
	return (ret); 
}
float atan(float n = 0) { 
	float m = n; 
	if(n > 1) m = 1.0 / n; 
	if(n < -1) m = -1.0 / n; 
	float r = m; 
	for(i = 1; < 100) { int j = i * 2 + 1; float k = pow(m,j) / j; 
		if(k == 0) break; 
		if(i % 2 == 0) r = r + k; 
		if(i % 2 == 1) r = r - k; 
	} 
	if(n > 1 || n < -1) r = PI / 2.0 - r; 
	if(n < -1) r = 0.0 - r; 
	return (r); 
}
float atan2(float z = 0,float x = 0) { 
	if(x > 0) return (atan(z / x)); 
	if(x < 0) { if(z < 0) return (atan(z / x) - PI); 
		if(z > 0) return (atan(z / x) + PI); 	
		return (PI); 
	} 
	if(z > 0) return (PI / 2.0); 
	if(z < 0) return (0.0 - (PI / 2.0)); 
	return (0); 
}
float fact(float n = 0) { 
	float r = 1; 
	for(i = 1; <= n) { r = r * i; } 
	return (r); 
}
float cos(float n = 0) { 
	float r = 1; 
	for(i = 1; < 100) { 
		int j = i * 2; float k = pow(n,j) / fact(j); 
		if(k == 0) break; 
		if(i % 2 == 0) r = r + k; 
		if(i % 2 == 1) r = r - k; 
	} 
	return (r); 
}
float sin(float n = 0) { 
	float r = n; 
	for(i = 1; < 100) { 
		int j = i * 2 + 1; 
		float k = pow(n,j) / fact(j); 
		if(k == 0) break; 
		if(i % 2 == 0) r = r + k; 
		if(i % 2 == 1) r = r - k; 
	} 
	return (r); 
} 

float LocX = 0; 
float LocZ = 0; 
float wAngle = 0;

float getLocX(float xOrigin=0, float rad=0, float MyAngle=0) { 
	wAngle = (2*PI*MyAngle)/360; 
	LocX=cos(wAngle)*rad + xOrigin; 
	return(LocX); 
}
	
float getLocZ(float zOrigin=0, float rad=0, float MyAngle=0) { 
	wAngle = (2*PI*MyAngle)/360; 
	LocZ=sin(wAngle)*rad + zOrigin; 
	return(LocZ); 
}

int classSmallIsland = 0;
int islandConstraint2 = 0; 
int avoidSmallIslands = 0;
int islandEdgeConstraint = 0;

int buildTradeArea (string TradeIslandName = "", float xLoc = 0.0, float zLoc = 0.0, float xFrac1 = 0.0, float zFrac1 = 0.0, float xFrac2 = 0.0, float zFrac2 = 0.0, string socketDef="") { 
    int tradeIslandID=rmCreateArea(TradeIslandName); 
    rmSetAreaSize(tradeIslandID, 0.09, 0.09);
    rmAddAreaToClass(tradeIslandID, classSmallIsland);  
    rmSetAreaTerrainType(tradeIslandID, "borneo\ground_grass1_borneo");
    //rmAddAreaTerrainLayer(tradeIslandID, "amazon\river1_am", 0, 14);
    //rmSetAreaMix(tradeIslandID, "yucatan_grass");  
    rmSetAreaEdgeFilling(tradeIslandID, 0);
    rmSetAreaBaseHeight(tradeIslandID, 2.0);
    rmSetAreaSmoothDistance(tradeIslandID, 5);
    /*rmAddAreaConstraint(tradeIslandID, avoidSmallIslands); 
    rmAddAreaConstraint(tradeIslandID, islandConstraint2); */
    rmSetAreaCoherence(tradeIslandID, 0.6);
    rmSetAreaLocation(tradeIslandID, xLoc, zLoc);  
    rmSetAreaElevationType(tradeIslandID, cElevTurbulence);
    rmSetAreaElevationVariation(tradeIslandID, 4.0);
    rmSetAreaElevationMinFrequency(tradeIslandID, 0.09);
    rmSetAreaElevationOctaves(tradeIslandID, 3);
    rmSetAreaElevationPersistence(tradeIslandID, 0.2);
    rmSetAreaElevationNoiseBias(tradeIslandID, 1);
    rmAddAreaInfluenceSegment(tradeIslandID, xFrac1, zFrac1, xFrac2, zFrac2);
	rmAddAreaRemoveType(tradeIslandID, "borneo_underbrush");
	rmAddAreaRemoveType(tradeIslandID, "PropTurtles");
	rmAddAreaRemoveType(tradeIslandID, "PropSwan");
	rmAddAreaRemoveType(tradeIslandID, "PropFish");
	rmAddAreaRemoveType(tradeIslandID, "DuckFamily");
    rmBuildArea(tradeIslandID);

    int tradeRouteID = rmCreateTradeRoute();
    int socketID=rmCreateObjectDef(socketDef);
    rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
    rmSetObjectDefAllowOverlap(socketID, true);
    rmSetObjectDefMinDistance(socketID, 0.0);
    rmSetObjectDefMaxDistance(socketID, 8.0);
    rmAddTradeRouteWaypoint(tradeRouteID, xFrac1, zFrac1);
    rmAddRandomTradeRouteWaypoints(tradeRouteID, xFrac2, zFrac2, 6, 6);
    //	rmAddTradeRouteWaypoint(tradeRouteID, xFrac2, zFrac2);
    rmBuildTradeRoute(tradeRouteID, "dirt");
    rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
    vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  
    return(tradeIslandID);
}

void main(void){

rmSetStatusText("", 0.0);

	if (rmGetIsFFA()==false) {
		float diceThrow = rmRandFloat(0,1.8);
			// <0.9 coastal version with noisy plateau, no trade route
			// >=0.9 central plateau with trade route
	}

	float playerTiles=18000;
		if (cNumberNonGaiaPlayers>4)
			playerTiles = 16800;
		if (cNumberNonGaiaPlayers>6)
			playerTiles = 14000;			
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);

	rmSetSeaType("Borneo Water");
		
	if (rmGetIsFFA()) {	
		rmSetSeaLevel(-2.0);
			if (IsYP()) 
				rmSetMapType("deccan");
			else
				rmSetMapType("deccan");
	}
	else {
		if (IsYP()) {
			if (diceThrow<0.0) {			// Coastal variation
				rmSetSeaLevel(-5.0);
				rmSetMapType("deccan");   
			}
			else {							// Trade route variation
				if (rmRandFloat(0,1)>0.67) {
					rmSetMapType("deccan");
				}
				else {
					rmSetMapType("deccan");
				}
				rmSetSeaLevel(0.0);
				rmSetGlobalRain(0.0);
			}
		}
		else {
			if (diceThrow<0.0) {			// Coastal variation
				rmSetSeaLevel(-5.0);
				rmSetMapType("deccan");  
			}
			else {							// Trade route variation
				if (rmRandFloat(0,1)>0.67) {
					rmSetMapType("deccan");
				}
				else {
					rmSetMapType("deccan");
				}
				rmSetSeaLevel(0.0);
				rmSetGlobalRain(0.0);
			}
		}
	}
	
	rmSetMapType("deccan");
	rmSetMapType("water");
	rmSetLightingSet("301a_malta");
	rmTerrainInitialize("water");

chooseMercs();

	// Make it rain
   rmSetGlobalRain( 0.7 );

rmSetWindMagnitude(2);
//rmSetGlobalStormLength(20, 20);

int classPlayer=rmDefineClass("player"); 
int classBase=rmDefineClass("land base"); 
rmDefineClass("startingUnit"); 
rmDefineClass("natives"); 
rmDefineClass("importantItem"); 
rmDefineClass("nuggets"); 
rmDefineClass("classCliff"); 
rmDefineClass("classForest");
rmDefineClass("socketClass");
rmDefineClass("deltaIsland");
int classIsland=rmDefineClass("island");
int classPlateau=rmDefineClass("plateau");
classSmallIsland=rmDefineClass("smallIsland");
int classLake=rmDefineClass("lake");
int classLakeIsland=rmDefineClass("lakeIsland");
int classBay=rmDefineClass("bay");
int classBonusIsland=rmDefineClass("bonus island");
int classSideIsland=rmDefineClass("side island");

int bonusIslandConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classBonusIsland, 10.0);
int bonusIslandConstraintMed=rmCreateClassDistanceConstraint("avoid bonus island medium", classBonusIsland, 16.0);
int longBonusIslandConstraint=rmCreateClassDistanceConstraint("long avoid bonus island", classBonusIsland, 30.0);
int medSideIslandConstraint=rmCreateClassDistanceConstraint("avoid side island medium", classSideIsland, 12.0);
int longSideIslandConstraint=rmCreateClassDistanceConstraint("long avoid side island", classSideIsland, 30.0);
int lakeConstraint=rmCreateClassDistanceConstraint("avoid bay", classLake, 15.0);
//int bayConstraint=rmCreateClassDistanceConstraint("avoid bay", classBay, 3);
int avoidIslet=rmCreateClassDistanceConstraint("small island avoid islands", rmClassID("deltaIsland"), 12.0);
int islandConstraint=rmCreateClassDistanceConstraint("islands avoid each other", classIsland, 15.0);
int islandConstraintSmall=rmCreateClassDistanceConstraint("islets avoid big Islands", classIsland, 12.0);
int plateauConstraint=rmCreateClassDistanceConstraint("plateaus avoid each other", classPlateau, 18.0);
islandConstraint2=rmCreateClassDistanceConstraint("stay away from main island", classIsland, 12.0);
avoidSmallIslands = rmCreateClassDistanceConstraint("stay away from other bonus islands", classSmallIsland, 10.0);
int avoidLakes=rmCreateClassDistanceConstraint("avoid lakes", classLake, 8.0);
int avoidLakeIsland=rmCreateClassDistanceConstraint("avoid big lake islands", classLakeIsland, 20.0);
int avoidLakeIslandSmall=rmCreateClassDistanceConstraint("avoid lake islands", classLakeIsland, 10.0);
islandEdgeConstraint = rmCreatePieConstraint("Islands away from edge of map", 0.5, 0.5, 0, rmGetMapXSize()-12, 0, 0, 0);
int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01); 
int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));
int avoidEdgeMore=rmCreatePieConstraint("avoid the edge of map", 0.5, 0.5, 0, rmZFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));
int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 20.0); 
int playerConstraintSmall=rmCreateClassDistanceConstraint("stuff vs. player small", classPlayer, 5.0); 
int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 35.0);
int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
int avoidTownCenterMedium=rmCreateTypeDistanceConstraint("avoid Town Center medium", "townCenter", 18.0);
int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 10.0);
int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 0.0);
int avoidNativesMed=rmCreateClassDistanceConstraint("stuff avoids natives medium", rmClassID("natives"), 0.0);
int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
int avoidImpassableShort=rmCreateTerrainDistanceConstraint("avoid impassable short", "Land", false, 5.0);
int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.9);
int cliffConstraint=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 45.0);	
int avoidCliff=rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 5.0);	
int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 20.0);
int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 6);
int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 4.0);
int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 5.0);
int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);
int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0); 
int avoidNuggetSmall=rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 10.0); 
int avoidWater = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 8.0);
int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 6.0);
int avoidWaterPlants = rmCreateTypeDistanceConstraint("water plants avoid each other", "UnderbrushLake", 8);
int avoidBrush=rmCreateTypeDistanceConstraint("props avoid each other", "UnderbrushJungle", 10.0);
int avoidCoinShort=rmCreateTypeDistanceConstraint("avoid coin short", "Mine", 5.0);
int waterConstraint = rmCreateTerrainDistanceConstraint("avoid land short", "Land", true, -1.0);	
int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
int classPatch = rmDefineClass("patch");

rmSetStatusText("", 0.1);

if (rmGetIsFFA()==false) {	
    
  if (diceThrow>=0.0){			// Trade route variation
    
	int pool=rmCreateArea("the waterpool");
	rmSetAreaSize(pool, 0.8, 0.8); 
	rmSetAreaLocation(pool, 0.5, 0.5);
	rmSetAreaBaseHeight(pool, -0.5);
	rmSetAreaCoherence(pool, 1.00);
	rmBuildArea(pool);
    
	int plateauCenter=rmCreateArea("center plateau");
	rmSetAreaSize(plateauCenter, 0.17, 0.17); 
	rmSetAreaTerrainType(plateauCenter, "borneo\ground_grass2_borneo");	
//	rmSetAreaMix(plateauCenter, "yucatan_grass");
	rmSetAreaLocation(plateauCenter, 0.5, 0.5);
	rmSetAreaCoherence(plateauCenter, 0.5);
	rmAddAreaToClass(plateauCenter, classPlateau);
	rmSetAreaBaseHeight(plateauCenter, 1.0);
	rmSetAreaSmoothDistance(plateauCenter, 20);
	rmSetAreaElevationType(plateauCenter, cElevTurbulence);
	rmSetAreaElevationVariation(plateauCenter, 4.0);
	rmSetAreaElevationMinFrequency(plateauCenter, 0.04);
	rmSetAreaElevationOctaves(plateauCenter, 4);
	rmSetAreaElevationPersistence(plateauCenter, 0.5);
	rmSetAreaElevationNoiseBias(plateauCenter, 1);
	rmSetAreaEdgeFilling(plateauCenter, 1);
	rmAddAreaInfluenceSegment(plateauCenter, -0.15, 0.5, 0.5, 0.5);
	//rmAddAreaRemoveType(plateauCenter, "UnderbrushLake");
	rmBuildArea(plateauCenter);

	int plateauCenter2=rmCreateArea("center plateau 2");
	rmSetAreaSize(plateauCenter2, 0.17, 0.17); 
	rmSetAreaTerrainType(plateauCenter2, "borneo\ground_grass1_borneo");	
//	rmSetAreaMix(plateauCenter2, "yucatan_grass");
	rmSetAreaLocation(plateauCenter2, 0.5, 0.5);
	rmSetAreaCoherence(plateauCenter2, 0.5);
	rmAddAreaToClass(plateauCenter2, classPlateau);
	rmSetAreaBaseHeight(plateauCenter2, 1.0);
	rmSetAreaSmoothDistance(plateauCenter2, 20);
	rmSetAreaElevationType(plateauCenter2, cElevTurbulence);
	rmSetAreaElevationVariation(plateauCenter2, 4.0);
	rmSetAreaElevationMinFrequency(plateauCenter2, 0.04);
	rmSetAreaElevationOctaves(plateauCenter2, 4);
	rmSetAreaElevationPersistence(plateauCenter2, 0.5);
	rmSetAreaElevationNoiseBias(plateauCenter2, 1);
	rmSetAreaEdgeFilling(plateauCenter2, 1);
	rmAddAreaInfluenceSegment(plateauCenter2, 0.5, 0.5, 1.1, 0.5);
	//rmAddAreaRemoveType(plateauCenter2, "UnderbrushLake");
	rmBuildArea(plateauCenter2);

	// Trade route

	int tradeRouteID = rmCreateTradeRoute();
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);
   
	rmAddTradeRouteWaypoint(tradeRouteID, -0.1, .53);

	if (cNumberNonGaiaPlayers==2){
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .2, .43, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .3, .50, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .5, .45, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .7, .53, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .9, .45, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 1.1, .55, 5, 6);
	}
	else {
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .1, .45, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .3, .55, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .5, .45, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .7, .55, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, .9, .45, 5, 6);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 1.1, .52, 5, 6);
	}
	rmBuildTradeRoute(tradeRouteID, "dirt");
	  
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.14);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  
	vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID, 0.37);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);  
	vector socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID, 0.6);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc3);  
	vector socketLoc4 = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc4);  

	int plateauNorthID=rmCreateArea("north platform 2");
	if (cNumberNonGaiaPlayers==2){
		rmSetAreaSize(plateauNorthID, 0.175, 0.175); 		// Was 0.15
	}
	else {
		rmSetAreaSize(plateauNorthID, 0.2, 0.2); 
	}
	rmSetAreaTerrainType(plateauNorthID, "borneo\ground_grass1_borneo");
	rmSetAreaLocation(plateauNorthID, 0.5, 0.9);
	rmSetAreaCoherence(plateauNorthID, 0.80);
	rmAddAreaToClass(plateauNorthID, classIsland);
	rmAddAreaConstraint(plateauNorthID, plateauConstraint);
	rmSetAreaBaseHeight(plateauNorthID, 1.0);
	rmSetAreaSmoothDistance(plateauNorthID, 20);
	rmSetAreaElevationType(plateauNorthID, cElevTurbulence);
	rmSetAreaElevationVariation(plateauNorthID, 4.0);
	rmSetAreaElevationMinFrequency(plateauNorthID, 0.04);
	rmSetAreaElevationOctaves(plateauNorthID, 4);
	rmSetAreaElevationPersistence(plateauNorthID, 0.5);
	rmSetAreaElevationNoiseBias(plateauNorthID, 1);
	rmSetAreaEdgeFilling(plateauNorthID, 10);
	rmAddAreaInfluencePoint(plateauNorthID, 0.10, 0.89);
	rmAddAreaInfluencePoint(plateauNorthID, 0.30, 0.89);
	rmAddAreaInfluencePoint(plateauNorthID, 0.50, 0.89);
	rmAddAreaInfluencePoint(plateauNorthID, 0.70, 0.89);
	rmAddAreaInfluencePoint(plateauNorthID, 0.90, 0.89); 
	//rmAddAreaRemoveType(plateauNorthID, "UnderbrushLake");
	rmBuildArea(plateauNorthID);

	int plateauSouthID=rmCreateArea("south platform 2");
		if (cNumberNonGaiaPlayers==2){
			rmSetAreaSize(plateauSouthID, 0.175, 0.175); 	// Was 0.15
		}
		else {
			rmSetAreaSize(plateauSouthID, 0.2, 0.2); 
		}
	rmSetAreaTerrainType(plateauSouthID, "borneo\ground_grass1_borneo");
//	rmSetAreaMix(plateauSouthID, "yucatan_grass");
	rmSetAreaLocation(plateauSouthID, 0.5, 0.1);
	rmSetAreaCoherence(plateauSouthID, 0.80);
	rmAddAreaToClass(plateauSouthID, classIsland);
	rmSetAreaBaseHeight(plateauSouthID, 1.0);
	rmSetAreaSmoothDistance(plateauSouthID, 20);
	rmSetAreaElevationType(plateauSouthID, cElevTurbulence);
	rmSetAreaElevationVariation(plateauSouthID, 4.0);
	rmSetAreaElevationMinFrequency(plateauSouthID, 0.04);
	rmSetAreaElevationOctaves(plateauSouthID, 4);
	rmSetAreaElevationPersistence(plateauSouthID, 0.5);
	rmSetAreaElevationNoiseBias(plateauSouthID, 1);
	rmSetAreaEdgeFilling(plateauSouthID, 10);
	rmAddAreaInfluencePoint(plateauSouthID, 0.10, 0.11);
	rmAddAreaInfluencePoint(plateauSouthID, 0.30, 0.11);
	rmAddAreaInfluencePoint(plateauSouthID, 0.50, 0.11);
	rmAddAreaInfluencePoint(plateauSouthID, 0.70, 0.11);
	rmAddAreaInfluencePoint(plateauSouthID, 0.90, 0.11);
	//rmAddAreaRemoveType(plateauSouthID, "UnderbrushLake");
	rmBuildArea(plateauSouthID);
    
    
    // Water weed and wild life

	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land", "Water", false, 5.0);

    
//	for (i=0;<(80*cNumberNonGaiaPlayers)) {	
		int waterWeed = rmCreateObjectDef("water weed");
		rmAddObjectDefItem(waterWeed, "UnderbrushLake", 1, 10.0);
		rmSetObjectDefMinDistance(waterWeed, 0);
		rmSetObjectDefMaxDistance(waterWeed, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(waterWeed, avoidEdgeMore);
	  	rmAddObjectDefConstraint(waterWeed, avoidWaterPlants);
  		rmAddObjectDefConstraint(waterWeed, waterConstraint);
	  	//rmAddObjectDefConstraint(waterWeed, avoidLand);
  		//rmAddObjectDefConstraint(waterWeed, avoidImpassableShort);
		rmPlaceObjectDefAtLoc(waterWeed, 0, 0.5, 0.5, 50);
//	}

	int wildChance = -1;

    for (i=0;<(4*cNumberNonGaiaPlayers)) {
		int phloat = rmCreateObjectDef("phloat"+i);
		wildChance = rmRandInt(0,3);
		switch(wildChance) {				// Many moni, say me say many, many, many
			case 0: rmAddObjectDefItem(phloat, "PropTurtles", 1, 0.0);
			case 1: rmAddObjectDefItem(phloat, "PropSwan", 1, 0.0);
			case 2: rmAddObjectDefItem(phloat, "PropFish", 1, 0.0);
			case 3: rmAddObjectDefItem(phloat, "DuckFamily", 1, 0.0);
		}
		rmSetObjectDefMinDistance(phloat, 0);
		rmSetObjectDefMaxDistance(phloat, rmXFractionToMeters(0.5));
	  	rmAddObjectDefConstraint(phloat, avoidEdgeMore);
	  	rmAddObjectDefConstraint(phloat, avoidWaterPlants);
	  	rmAddObjectDefConstraint(phloat, waterConstraint);
	  	rmAddObjectDefConstraint(phloat, avoidLand);
	// rmAddObjectDefConstraint(phloat, avoidImpassableShort);
		rmPlaceObjectDefAtLoc(phloat, 0, 0.5, 0.5, 1);
	}
    
}							// End of trade route variation

}							// End of non-FFA area creation

else {						// FFA area creation
    
    
    int pool2=rmCreateArea("the waterpool 2");
    rmSetAreaSize(pool2, 0.8, 0.8); 
    rmSetAreaLocation(pool2, 0.5, 0.5);
    rmSetAreaBaseHeight(pool2, -2.5);
    rmSetAreaCoherence(pool2, 1.00);
    rmBuildArea(pool2);

 
}

rmSetStatusText("", 0.2);

// Starting positions for players placement

	float pSwitch = rmRandFloat(0, 1.2);

if (diceThrow<0.0){

    	if (rmGetIsFFA())
		rmPlacePlayersCircular(0.35, 0.35, 0);
	else {
		if (pSwitch < 0.55) {
			rmSetPlacementSection(0.10, 0.30);
			rmSetPlacementTeam(0);
			rmPlacePlayersCircular(0.33, 0.33, 0);
			rmSetPlacementSection(0.60, 0.80);
			rmSetPlacementTeam(1);
			rmPlacePlayersCircular(0.33, 0.33, 0); 
		}
		else {
			rmSetPlacementSection(0.60, 0.80);
			rmSetPlacementTeam(0);
			rmPlacePlayersCircular(0.33, 0.33, 0);
			rmSetPlacementSection(0.10, 0.30);
			rmSetPlacementTeam(1);
			rmPlacePlayersCircular(0.33, 0.33, 0); 
		}
	}
    
}
else{
    
	if (rmGetIsFFA()) {
		if (cNumberNonGaiaPlayers==3) {
			rmPlacePlayer(1, 0.75, 0.7); 
			rmPlacePlayer(2, 0.2, 0.7); 
			rmPlacePlayer(3, 0.5, 0.1);
		}
		else {
			rmPlacePlayer(1, 0.75, 0.7); 
			rmPlacePlayer(2, 0.1, 0.4); 
			rmPlacePlayer(3, 0.5, 0.1); 
			rmPlacePlayer(6, 0.5, 0.5); 
			rmPlacePlayersLine(0.3, 0.8, 0.8, 0.3, 0.0, 0.0); 
		}
	}
	else if (cNumberNonGaiaPlayers==2){
		if (pSwitch < 0.55) {
			rmPlacePlayer(1, 0.45, 0.88);
			rmPlacePlayer(2, 0.46, 0.12);	// correction for the weird unequal placement, given symmetrical coords		// Solved
		}
		else {
			rmPlacePlayer(1, 0.46, 0.12);	// 
			rmPlacePlayer(2, 0.45, 0.88);	 
		}		
	}
	else {
		if (pSwitch < 0.55) {
			rmSetPlacementSection(0.9, 0.07);
			rmSetPlacementTeam(0);
			rmPlacePlayersCircular(0.4, 0.4, 0);

			rmSetPlacementSection(0.43, 0.6);
			rmSetPlacementTeam(1);
			rmPlacePlayersCircular(0.4, 0.4, 0); 
		}
		else {
			rmSetPlacementSection(0.43, 0.6);
			rmSetPlacementTeam(0);
			rmPlacePlayersCircular(0.4, 0.4, 0);
			rmSetPlacementSection(0.9, 0.07);
			rmSetPlacementTeam(1);
			rmPlacePlayersCircular(0.4, 0.4, 0); 
		}
	}
}

// Players starting units and resources

int TCvsWater = rmCreateTerrainDistanceConstraint("TC vs water", "Land", false, 15.0);

	int playerStart = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(playerStart, 7.0);
	rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefConstraint(playerStart, avoidAll);

	int startID = rmCreateObjectDef("starting object"); 
	rmAddObjectDefItem(startID, "TownCenter", 1, 0.0); 
	rmAddObjectDefToClass(startID, rmClassID("startingUnit")); 
	rmSetObjectDefMinDistance(startID, 0.0); 
	if (cNumberNonGaiaPlayers==2) {
		rmSetObjectDefMaxDistance(startID, 1.0); 
	}
	else if (cNumberNonGaiaPlayers>2 && cNumberNonGaiaPlayers<7) {
		rmSetObjectDefMaxDistance(startID, 5.0); 		
		rmAddObjectDefConstraint(startID, avoidImpassableLand);
	}
    else {
        rmSetObjectDefMaxDistance(startID, 20.0);
    }
	rmAddObjectDefConstraint(startID, TCvsWater);
//	rmAddObjectDefConstraint(startID, avoidImpassableLand);

	int berryID = rmCreateObjectDef("starting berries"); 
	rmAddObjectDefItem(berryID, "BerryBush", 3, 4.0); 
	rmSetObjectDefMinDistance(berryID, 6.0); 
	rmSetObjectDefMaxDistance(berryID, 10.0); 
	rmAddObjectDefConstraint(berryID, avoidCoin);
	rmAddObjectDefConstraint(berryID, avoidWater);
	rmAddObjectDefConstraint(berryID, avoidImpassableShort);

	int treeID = rmCreateObjectDef("starting trees"); 
	rmAddObjectDefItem(treeID, "ypTreeBorneo", rmRandInt(8,12), 10.0); 
	rmSetObjectDefMinDistance(treeID, 12.0); 
	rmSetObjectDefMaxDistance(treeID, 18.0);
	rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
	rmAddObjectDefConstraint(treeID, avoidCoin);
//	rmAddObjectDefConstraint(treeID, avoidWater);

	int foodID = rmCreateObjectDef("starting hunt"); 
	rmAddObjectDefItem(foodID, "rhea", 6, 8.0); 
	rmSetObjectDefMinDistance(foodID, 2.0); 
	rmSetObjectDefMaxDistance(foodID, 7.0); 
	rmSetObjectDefCreateHerd(foodID, true);

	int startnuggetID= rmCreateObjectDef("starting nugget"); 
	rmAddObjectDefItem(startnuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(startnuggetID, 15.0); 
	rmSetObjectDefMaxDistance(startnuggetID, 20.0);
	rmAddObjectDefConstraint(startnuggetID, avoidWater);
	rmAddObjectDefConstraint(startnuggetID, avoidTownCenterSmall);
	rmAddObjectDefConstraint(startnuggetID, avoidImpassableShort);
	rmSetNuggetDifficulty(1, 1); 

    int top2=rmCreateArea("top layer 2");
	rmSetAreaSize(top2, 0.80, 0.80); 
	rmSetAreaTerrainType(top2, "borneo\ground_grass1_borneo");
	rmSetAreaElevationNoiseBias(top2, 1);
	rmSetAreaElevationEdgeFalloffDist(top2, 3);
	rmSetAreaElevationVariation(top2, 2);
	rmSetAreaElevationPersistence(top2, 0.3);
	rmSetAreaElevationOctaves(top2, 4);
	rmSetAreaElevationMinFrequency(top2, 0.05);
	rmSetAreaElevationType(top2, cElevTurbulence);
	rmBuildArea(top2);
    

// Natives
	
if (rmGetIsFFA()==false){

if (diceThrow<0.0){	
      
	// Natives areas

	int tupiIsland=rmCreateArea("land base for tupi village");
	rmSetAreaSize(tupiIsland, 0.017, 0.017); 
	rmSetAreaBaseHeight(tupiIsland, 2.0);

	if (cNumberNonGaiaPlayers == 2)
		rmSetAreaLocation(tupiIsland, 0.7, 0.3);
	else if (cNumberNonGaiaPlayers > 2 && cNumberNonGaiaPlayers < 6)
		rmSetAreaLocation(tupiIsland, 0.6, 0.2);
	else 
		rmSetAreaLocation(tupiIsland, 0.6, 0.15);
	rmSetAreaTerrainType(tupiIsland, "borneo\ground_grass2_borneo"); 
	rmSetAreaCoherence(tupiIsland, 1.0); 
	rmBuildArea(tupiIsland);

	int seminoleIsland=rmCreateArea("land base for seminole village");
	rmSetAreaSize(seminoleIsland, 0.017, 0.017); 
	rmSetAreaBaseHeight(seminoleIsland, 2.0);

	if (cNumberNonGaiaPlayers == 2)
		rmSetAreaLocation(seminoleIsland, 0.3, 0.7);
	else if (cNumberNonGaiaPlayers > 2 && cNumberNonGaiaPlayers < 6)
		rmSetAreaLocation(seminoleIsland, 0.4, 0.8);
	else
		rmSetAreaLocation(seminoleIsland, 0.4, 0.85);

	rmSetAreaTerrainType(seminoleIsland, "borneo\ground_grass2_borneo"); 
	rmSetAreaCoherence(seminoleIsland, 1.0); 
	rmBuildArea(seminoleIsland);
            
	int avoidTupiArea = rmCreateAreaDistanceConstraint("avoid tupi village area", tupiIsland, 5.0);
	int avoidSeminoleArea = rmCreateAreaDistanceConstraint("avoid seminole village area", seminoleIsland, 5.0);
                
}
}

	string nativeType = "";

	if (IsYP()) {
		rmAllocateSubCivs(2); 
		rmSetSubCiv(0, "Caribs");
		rmSetSubCiv(1, "Jesuit");
		nativeType = "uger";
	}
	else {  
		rmAllocateSubCivs(2); 
		rmSetSubCiv(0, "Caribs");
		rmSetSubCiv(1, "Maya");
		nativeType = "uger";
	}
	
	int tupiVillageID = rmCreateGrouping("edge carib village", "uger"+rmRandInt(1,4));
	rmSetGroupingMinDistance(tupiVillageID, 0.0);
	rmSetGroupingMaxDistance(tupiVillageID, 10.0);
	//rmAddGroupingToClass(tupiVillageID, rmClassID("natives"));
	//rmAddGroupingToClass(tupiVillageID, rmClassID("importantItem"));
	//rmAddGroupingConstraint(tupiVillageID, avoidImpassableShort);

	if (rmGetIsFFA()==false){
		if (cNumberNonGaiaPlayers==2){
			if (diceThrow < 0.0) {
				rmPlaceGroupingInArea(tupiVillageID, 0, tupiIsland, 1);
				//rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.7, 0.3, 1);
			}
			else {
				rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.65, 0.9);
				rmAddGroupingConstraint(tupiVillageID, avoidTradeRouteSmall);
				rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.5, 0.56);
			}
		}
		else {
			if (diceThrow < 0.0) {
				rmPlaceGroupingInArea(tupiVillageID, 0, tupiIsland, 1);
				//rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.65, 0.4);
			}
			else {
				rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.8, 0.85);
				rmAddGroupingConstraint(tupiVillageID, avoidTradeRouteSmall);
				rmPlaceGroupingAtLoc(tupiVillageID, 0, 0.5, 0.57);
			}
		}
	}

	int seminoleVillageID = rmCreateGrouping("edge native village", nativeType+rmRandInt(1,4));
	rmSetGroupingMinDistance(seminoleVillageID, 0.0);
	rmSetGroupingMaxDistance(seminoleVillageID, 10.0);
	//rmAddGroupingToClass(seminoleVillageID, rmClassID("natives"));
	//rmAddGroupingToClass(seminoleVillageID, rmClassID("importantItem"));
	//rmAddGroupingConstraint(seminoleVillageID, avoidImpassableShort);

	if (rmGetIsFFA()==false){
		if (cNumberNonGaiaPlayers==2){
			if (diceThrow < 0.0) {
				//rmPlaceGroupingAtLoc(seminoleVillageID, 0, 0.14, 0.6);
				rmPlaceGroupingInArea(seminoleVillageID, 0, seminoleIsland, 1);
			}
			else {
				rmPlaceGroupingAtLoc(seminoleVillageID, 0, 0.65, 0.1);
				rmAddGroupingConstraint(seminoleVillageID, avoidTradeRouteSmall);
				rmPlaceGroupingAtLoc(seminoleVillageID, 0, 0.20, 0.55);
			}
		}
		else {
			if (diceThrow < 0.0) {
				rmPlaceGroupingInArea(seminoleVillageID, 0, seminoleIsland, 1);
				//rmPlaceGroupingAtLoc(seminoleVillageID, 0, 0.14, 0.6);
			}
			else {
				rmPlaceGroupingAtLoc(seminoleVillageID, 0, 0.75, 0.15);	// Not returning bool
				rmAddGroupingConstraint(seminoleVillageID, avoidTradeRouteSmall);
				rmPlaceGroupingAtLoc(seminoleVillageID, 0, 0.15, 0.55);
			}
		}
	}

rmSetStatusText("", 0.3);

	for(i=1; <cNumberPlayers) { 
		int id=rmCreateArea("Player"+i); 
		rmSetPlayerArea(i, id); 
		rmSetAreaSize(id, rmAreaTilesToFraction(900), rmAreaTilesToFraction(900)); 
        rmSetAreaTerrainType(id, "borneo\ground_grass1_borneo");
        rmAddAreaToClass(id, classPlayer); 

			if (rmGetIsFFA()==false){ 
				rmSetAreaBaseHeight(id, 1.0);
				rmSetAreaElevationNoiseBias(id, 0);
				rmSetAreaElevationEdgeFalloffDist(id, 3);
				rmSetAreaElevationVariation(id, 3);
				rmSetAreaElevationPersistence(id, 0.3);
				rmSetAreaElevationOctaves(id, 5);
				rmSetAreaElevationMinFrequency(id, 0.04);
				rmSetAreaElevationType(id, cElevTurbulence);
				rmSetAreaCoherence(id, 0.75); 
				rmAddAreaConstraint(id, playerConstraint); 
				rmAddAreaConstraint(id, playerEdgeConstraint); 
				rmSetAreaLocPlayer(id, i); 
				if (diceThrow<0.0){ 
					rmBuildArea(id); 
				}
			}
			else {
				rmSetAreaBaseHeight(id, 1.0);
				rmSetAreaElevationVariation(id, 2);
				rmSetAreaElevationNoiseBias(id, 0);
				rmSetAreaElevationEdgeFalloffDist(id, 3);
				rmSetAreaElevationOctaves(id, 4);
				rmSetAreaElevationMinFrequency(id, 0.05);
				rmAddAreaToClass(id, rmClassID("deltaIsland"));
				rmAddAreaConstraint(id, avoidIslet);
				rmAddAreaConstraint(id, islandConstraintSmall);
				rmSetAreaCoherence(id, 0.5);
				rmSetAreaLocPlayer(id, i); 
				rmBuildArea(id); 
			}

		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

rmSetStatusText("", 0.4);

	

if (rmGetIsFFA()==false) {
	if (diceThrow < 0.0) {

    // Dem eagles, mon'

	int avoidRocks = rmCreateTypeDistanceConstraint("eagles avoid eagles", "PropEaglesRocks", 50);
//	int eagleWaterConstraint = rmCreateTerrainDistanceConstraint("avoid land short", "Land", true, -1.0);	

	//for(i=0;<(20*cNumberNonGaiaPlayers)){
		int eagleRocks = rmCreateObjectDef("eagle rocks");
		rmAddObjectDefItem(eagleRocks, "PropEaglesRocks", 1, 0.0);
		rmSetObjectDefMinDistance(eagleRocks, 0);
		rmSetObjectDefMaxDistance(eagleRocks, rmXFractionToMeters(0.5));
	//	rmAddObjectDefConstraint(eagleRocks, avoidImportantItem);
	// 	rmAddObjectDefConstraint(eagleRocks, playerConstraint);
		rmAddObjectDefConstraint(eagleRocks, circleConstraint);
	// 	rmAddObjectDefConstraint(eagleRocks, eagleWaterConstraint);
		rmAddObjectDefConstraint(eagleRocks, avoidRocks);
	// 	rmAddObjectDefConstraint(eagleRocks, avoidCoin);
	//	rmAddObjectDefConstraint(eagleRocks, avoidImpassableShort);
	// 	rmAddObjectDefConstraint(eagleRocks, avoidCliff);
		rmPlaceObjectDefAtLoc(eagleRocks, 0, 0.5, 0.5, 40*cNumberNonGaiaPlayers);
	//	rmPlaceObjectDefInArea(eagleRocks, 0, pool, 1);
	//}

    
    // Build the "noisy" land base

	float Float1=0.00; 
	float Float2=0.00; 
	float Float3=0.00; 
	float Float4=0.00; 
	float Float5=0.00; 
	int Int1=0; 
	int Int2=0; 
	int Int3=0; 
	int Int4=0;

		for(Float1=1; <=10){
			for(Float2=1; <=10){
				Int1=rmRandInt(1,3);
				Int2=rmRandInt(1,2);
				Int3=rmRandInt(1,2);
				if(Int1==1) Float3=0.006;
				if(Int1==2) Float3=0.011;
				if(Int1==3) Float3=0.021;
				if(Int2==1) Float4=0.015;
				if(Int2==2) Float4=-0.015;
				if(Int3==1) Float5=0.015;
				if(Int3==2) Float5=-0.015;
				Area(Float3, Float1/10, Float2/10, "borneo\ground_grass1_borneo");						
				rmAddAreaToClass(landnoise, classBase);
				rmAddAreaRemoveType(landnoise, "PropEaglesRocks");
				rmBuildArea(landnoise);
				Area(Float3, (Float1/10)+Float4, (Float2/10)+Float5, "borneo\ground_grass2_borneo");	// The compiler doesn't like this (float -> int index variable -> float)
				rmAddAreaRemoveType(landnoise, "PropEaglesRocks");
				rmBuildArea(landnoise);
			}
		}

	// Some cliffs
	
	for (i=0; <26) {
		int cliffs=rmCreateArea("cliff"+i); 
		rmSetAreaSize(cliffs, 0.001, 0.0016); 
		rmAddAreaToClass(cliffs, rmClassID("classCliff"));
		rmSetAreaCliffType(cliffs, "uger"); // Cave
		rmSetAreaCliffHeight(cliffs, 10.0, 0.0, 0.5); 
		rmSetAreaCliffEdge(cliffs, 1, 2.0, 0.0, 0.0, 0); 
		rmSetAreaTerrainType(cliffs, "borneo\ground_grass2_borneo"); 
		rmSetAreaCliffPainting(cliffs, true, true, true, 0, true); 
	//	rmAddAreaTerrainReplacement(cliffs, "cave\cave_top", "amazon\ground2_ama");
		rmSetAreaMinBlobs(cliffs, 1); 
		rmSetAreaMaxBlobs(cliffs, 1); 
		rmSetAreaCoherence(cliffs, 0.5); 
		rmAddAreaConstraint(cliffs, avoidTownCenter);
		rmAddAreaConstraint(cliffs, avoidTupiArea);
		rmAddAreaConstraint(cliffs, avoidSeminoleArea);
		rmAddAreaConstraint(cliffs, cliffConstraint);
		rmBuildArea(cliffs);
	}
       
    // Layer on top of the noise land base

		int top=rmCreateArea("top layer");
		rmSetAreaSize(top, 0.80, 0.80); 
		rmSetAreaTerrainType(top, "borneo\ground_grass1_borneo");
		rmSetAreaElevationNoiseBias(top, 1);
		rmSetAreaElevationEdgeFalloffDist(top, 3);
		rmSetAreaElevationVariation(top, 2);
		rmSetAreaElevationPersistence(top, 0.3);
		rmSetAreaElevationOctaves(top, 4);
		rmSetAreaElevationMinFrequency(top, 0.05);
		rmSetAreaElevationType(top, cElevTurbulence);
		rmBuildArea(top);		
	}
}
 
rmSetStatusText("", 0.5);
 
// Player gold

	int goldID = rmCreateObjectDef("starting gold"); 
	rmAddObjectDefItem(goldID, "mine", 1, 0.0); 
	rmSetObjectDefMinDistance(goldID, 0.0); 
	rmSetObjectDefMaxDistance(goldID, 8.0); 
//	rmAddObjectDefConstraint(goldID, avoidWaterShort);
//	rmAddObjectDefConstraint(goldID, avoidImpassableShort);

		if (cNumberNonGaiaPlayers==2){
			//rmSetIgnoreForceToGaia(true);
			int positionSwitch = rmRandInt(1,2);
			vector locTC1 = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startID, 1));
   			vector locTC2 = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startID, 2));
   		       	
			if (positionSwitch == 1) {
		       		rmPlaceObjectDefAtLoc(goldID, 0, rmXMetersToFraction(xsVectorGetX(locTC1)), rmZMetersToFraction((xsVectorGetZ(locTC1))-5));
       	   	         		rmPlaceObjectDefAtLoc(goldID, 0, rmXMetersToFraction(xsVectorGetX(locTC2)), rmZMetersToFraction((xsVectorGetZ(locTC2))+5));
       	   	         	}
       	   	         	else {
           	   	         		rmPlaceObjectDefAtLoc(goldID, 0, rmXMetersToFraction(xsVectorGetX(locTC1)), rmZMetersToFraction((xsVectorGetZ(locTC1))+5));
 			        	rmPlaceObjectDefAtLoc(goldID, 0, rmXMetersToFraction(xsVectorGetX(locTC2)), rmZMetersToFraction((xsVectorGetZ(locTC2))-5));
       	   	           	} 
       	   	}
		else {

			for(i=1; <cNumberPlayers) { 		
				int placed = rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));	
				if (placed==0) {
					int gold2ID = rmCreateObjectDef("starting gold 2"+i); 
					rmAddObjectDefItem(gold2ID, "mine", 1, 0.0); 
					rmSetObjectDefMinDistance(gold2ID, 0.0); 
					rmSetObjectDefMaxDistance(gold2ID, 15.0); 
					int placed2 = rmPlaceObjectDefAtLoc(gold2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));	
				}
			
			// 	int t = rmCreateTrigger("Obj Def Placement Check"+i);
		    //	rmSwitchToTrigger(t);
		    //	rmAddTriggerCondition("Always");
		    //	rmAddTriggerEffect("Send Chat As String");
		    //	rmSetTriggerEffectParamInt("PlayerID", 0);
		    //	rmSetTriggerEffectParam("Message", "Player"+i+"'s starting mine="+placed); 
			//  rmSetTriggerEffectParam("Message", "Player"+i+"'s starting mine="+placed2);
			}
		}

	for(i=1; <cNumberPlayers) { 
		rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));	
		rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));	
		rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));	
		rmPlaceObjectDefAtLoc(startnuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}


rmSetStatusText("", 0.6);

if (rmGetIsFFA()==true){

	int islandCounter = 0;
	int avoidLand2 = rmCreateTerrainDistanceConstraint("avoid land 2", "Water", false, 2.0);

    
//	for (i=0;<(80*cNumberNonGaiaPlayers)) {	
		int waterWeed2 = rmCreateObjectDef("water weed 2");
		rmAddObjectDefItem(waterWeed2, "UnderbrushLake", 1, 10.0);
		rmSetObjectDefMinDistance(waterWeed2, 0);
		rmSetObjectDefMaxDistance(waterWeed2, rmXFractionToMeters(0.5));
  		rmAddObjectDefConstraint(waterWeed2, avoidEdgeMore);
	  	rmAddObjectDefConstraint(waterWeed2, avoidWaterPlants);
  		rmAddObjectDefConstraint(waterWeed2, waterConstraint);
	  	//rmAddObjectDefConstraint(waterWeed2, avoidLand2);
  		//rmAddObjectDefConstraint(waterWeed2, avoidImpassableShort);
		rmPlaceObjectDefAtLoc(waterWeed2, 0, 0.5, 0.5, 50);
//	}

	int wildChance2 = -1;

    for (i=0;<(4*cNumberNonGaiaPlayers)) {
		int phloat2 = rmCreateObjectDef("phloat 2"+i);
		wildChance2 = rmRandInt(0,3);
		switch(wildChance2) {				
			case 0: rmAddObjectDefItem(phloat2, "PropTurtles", 1, 0.0);
			case 1: rmAddObjectDefItem(phloat2, "PropSwan", 1, 0.0);
			case 2: rmAddObjectDefItem(phloat2, "PropFish", 1, 0.0);
			case 3: rmAddObjectDefItem(phloat2, "DuckFamily", 1, 0.0);
		}
		rmSetObjectDefMinDistance(phloat2, 0);
		rmSetObjectDefMaxDistance(phloat2, rmXFractionToMeters(0.5));
	  	rmAddObjectDefConstraint(phloat2, avoidEdgeMore);
	  	rmAddObjectDefConstraint(phloat2, avoidWaterPlants);
	  	rmAddObjectDefConstraint(phloat2, waterConstraint);
	// 	rmAddObjectDefConstraint(phloat2, avoidLand2);
	// 	rmAddObjectDefConstraint(phloat2, avoidImpassableShort);
		rmPlaceObjectDefAtLoc(phloat2, 0, 0.5, 0.5, 1);
	}	

	   // Two trade islands at opposite ends of map (the location is randomly chosen)
	int bonusSwitch = rmRandInt(1,3);
		switch(bonusSwitch) {											// area locX		// area locZ		// xFrac1			// zFrac1				// xFrac2			// zFrac2
			case 1: { 	
				int bonusIslandID11= buildTradeArea("bonus island 11", getLocX(0.47, 0.47, 0), getLocZ(0.47, 0.47, 0), getLocX(0.47, 0.47, 0), (getLocZ(0.47, 0.47, 0)-0.2), getLocX(0.47, 0.47, 0), (getLocZ(0.47, 0.47, 0)+0.2), "socket1"); // 0.940000,0.470000  
				int bonusIslandID12= buildTradeArea("bonus island 12", getLocX(0.47, 0.47, 180), 	getLocZ(0.47, 0.47, 180), getLocX(0.47, 0.47, 180), (getLocZ(0.47, 0.47, 180)-0.2), getLocX(0.47, 0.47, 180), (getLocZ(0.47, 0.47, 180)+0.2),	"socket2"); // 0.004704,0.536326  
			}	
			case 2: {
				int bonusIslandID21= buildTradeArea("bonus island 21", getLocX(0.47, 0.47, 300), 	getLocZ(0.47, 0.47, 300), (getLocX(0.47, 0.47, 300)-0.2), (getLocZ(0.47, 0.47, 300)), 	(getLocX(0.47, 0.47, 300)+0.2), getLocZ(0.47, 0.47, 300), "socket1"); // 0.603321,0.019305  
				int bonusIslandID22= buildTradeArea("bonus island 22", getLocX(0.47, 0.47, 120), 	getLocZ(0.47, 0.47, 120), (getLocX(0.47, 0.47, 120)-0.2), (getLocZ(0.47, 0.47, 120)+0.05), (getLocX(0.48, 0.48, 120)+0.4), (getLocZ(0.48, 0.48, 120)+0.05), "socket2"); // 0.274411,0.897370    
			}	
			case 3: {
				int bonusIslandID31= buildTradeArea("bonus island 31", getLocX(0.47, 0.47, 240), 	getLocZ(0.47, 0.47, 240), (getLocX(0.47, 0.47, 240)+0.2), (getLocZ(0.47, 0.47, 240)-0.1), (getLocX(0.47, 0.47, 240)-0.1), (getLocZ(0.47, 0.47, 240)+0.2), "socket1"); // 0.162788,0.114303   
				int bonusIslandID32= buildTradeArea("bonus island 32", getLocX(0.47, 0.47, 60), 	getLocZ(0.47, 0.47, 60), (getLocX(0.47, 0.47, 60)+0.2), (getLocZ(0.47, 0.47, 60)-0.2), (getLocX(0.47, 0.47, 60)-0.2), (getLocZ(0.47, 0.47, 60)+0.2), "socket2"); // 0.723942,0.865491  
			}	
		}
	
	// Complete the delta with extra islands
	for (i=0; <18) {
		int deltaIsletID = rmCreateArea("bonus islands"+i);
		rmAddAreaToClass(deltaIsletID, rmClassID("deltaIsland"));
	//	rmSetAreaMix(deltaIsletID, "yucatan_grass");
		rmSetAreaTerrainType(deltaIsletID, "borneo\ground_grass1_borneo");
		rmSetAreaSize(deltaIsletID, 0.025, 0.035);
		rmSetAreaCoherence(deltaIsletID, 0.75);
		rmSetAreaBaseHeight(deltaIsletID, -1.5);
		//rmSetAreaMinBlobs(deltaIsletID, 6);
		//rmSetAreaMaxBlobs(deltaIsletID, 12);
		//rmSetAreaMinBlobDistance(deltaIsletID, 8.0);
		//rmSetAreaMaxBlobDistance(deltaIsletID, 10.0);
		rmSetAreaSmoothDistance(deltaIsletID, 12);
		rmSetAreaElevationType(deltaIsletID, cElevTurbulence);
		rmSetAreaElevationVariation(deltaIsletID, 5.0);
		rmSetAreaElevationMinFrequency(deltaIsletID, 0.04);
		rmSetAreaElevationOctaves(deltaIsletID, 4);
		rmSetAreaElevationPersistence(deltaIsletID, 0.5);
		rmSetAreaElevationNoiseBias(deltaIsletID, 1);
		rmAddAreaConstraint(deltaIsletID, avoidIslet);
		rmAddAreaConstraint(deltaIsletID, islandConstraintSmall);
		rmAddAreaConstraint(deltaIsletID, islandEdgeConstraint);
		//rmSetAreaEdgeFilling(deltaIsletID, 1);
		rmAddAreaConstraint(deltaIsletID, avoidSmallIslands);
		rmAddAreaRemoveType(deltaIsletID, "UnderbrushLake");
		bool ok = rmBuildArea(deltaIsletID);
			if(ok){
				islandCounter++;
				if ((islandCounter%4)==0){
					rmSetGroupingMaxDistance(tupiVillageID, 15.0);
					rmAddGroupingConstraint(tupiVillageID, islandEdgeConstraint);
					rmPlaceGroupingInArea(tupiVillageID, 0, deltaIsletID, 1);
				}
				if ((islandCounter%5)==0) {
					rmSetGroupingMaxDistance(tupiVillageID, 15.0);
					rmAddGroupingConstraint(seminoleVillageID, islandEdgeConstraint);
					rmPlaceGroupingInArea(seminoleVillageID, 0, deltaIsletID, 1);		
				}
			}
	}
}


// Resources

int avoidCoinFar=0;
	if (cNumberNonGaiaPlayers == 2) avoidCoinFar=rmCreateTypeDistanceConstraint("avoid coin far for less players", "Mine", 50.0);
	else avoidCoinFar=rmCreateTypeDistanceConstraint("avoid coin far", "Mine", 60.0);
int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
int AvoidWaterShort2 = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 5.0);
int MineVSWaterMed = rmCreateTerrainDistanceConstraint("mine avoid water medium", "Land", false, 12.0);	
int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);
int NorthPie=rmCreatePieConstraint("Stay North",0.5,0.5,0,rmXFractionToMeters(0.48), rmDegreesToRadians(320),rmDegreesToRadians(140)); 	
int SouthPie=rmCreatePieConstraint("Stay South",0.5,0.5,0,rmXFractionToMeters(0.48), rmDegreesToRadians(140),rmDegreesToRadians(320));

// Silver mines

if (rmGetIsFFA()==false) {

// Coastal variation
	if (diceThrow<0.0){
		int playerSilverID = rmCreateObjectDef("player silver");
		rmAddObjectDefItem(playerSilverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(playerSilverID, 0.0);
		rmSetObjectDefMaxDistance(playerSilverID, rmXFractionToMeters(0.35));
		rmAddObjectDefConstraint(playerSilverID, avoidCoinMed);
		//rmAddObjectDefConstraint(playerSilverID, avoidNatives);
		rmAddObjectDefConstraint(playerSilverID, avoidTownCenterMore);
		rmAddObjectDefConstraint(playerSilverID, NorthPie);
		rmAddObjectDefConstraint(playerSilverID, avoidCliff);
		//rmAddObjectDefConstraint(playerSilverID, avoidSocket);
		//rmAddObjectDefConstraint(playerSilverID, AvoidWaterShort2);
		//rmAddObjectDefConstraint(playerSilverID, forestConstraintShort);
		//rmAddObjectDefConstraint(playerSilverID, circleConstraint);
		rmPlaceObjectDefAtLoc(playerSilverID, 0, 0.75, 0.5, cNumberNonGaiaPlayers+2);
			
		int playerSilver2ID = rmCreateObjectDef("player silver 2");
		rmAddObjectDefItem(playerSilver2ID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(playerSilver2ID, 0.0);
		rmSetObjectDefMaxDistance(playerSilver2ID, rmXFractionToMeters(0.35));
		rmAddObjectDefConstraint(playerSilver2ID, avoidCoinMed);
		//rmAddObjectDefConstraint(playerSilver2ID, avoidNatives);
		rmAddObjectDefConstraint(playerSilver2ID, avoidTownCenterMore);
		rmAddObjectDefConstraint(playerSilver2ID, SouthPie);
		rmAddObjectDefConstraint(playerSilver2ID, avoidCliff);
		//rmAddObjectDefConstraint(playerSilver2ID, avoidSocket);
		rmAddObjectDefConstraint(playerSilver2ID, AvoidWaterShort2);
		//rmAddObjectDefConstraint(playerSilver2ID, forestConstraintShort);
		//rmAddObjectDefConstraint(playerSilver2ID, circleConstraint);
		rmPlaceObjectDefAtLoc(playerSilver2ID, 0, 0.25, 0.5, cNumberNonGaiaPlayers+2);
	}

// Trade route variation
	else {
	
		int avoidMineMed=rmCreateTypeDistanceConstraint("avoid mines medium", "Mine", 58.0);
	
		int playerSilverNorthID = rmCreateObjectDef("player silver north");
		rmAddObjectDefItem(playerSilverNorthID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(playerSilverNorthID, 0.0);
		rmSetObjectDefMaxDistance(playerSilverNorthID, rmXFractionToMeters(0.18));
		rmAddObjectDefConstraint(playerSilverNorthID, avoidMineMed);
		//rmAddObjectDefConstraint(playerSilverNorthID, avoidNatives);
		//rmAddObjectDefConstraint(playerSilverNorthID, avoidTownCenterMore);
		rmAddObjectDefConstraint(playerSilverNorthID, MineVSWaterMed);
		//rmAddObjectDefConstraint(playerSilverNorthID, forestConstraintShort);
		rmAddObjectDefConstraint(playerSilverNorthID, circleConstraint);
		if (cNumberNonGaiaPlayers==2)
			rmPlaceObjectDefInArea(playerSilverNorthID, 0, plateauNorthID, cNumberNonGaiaPlayers);
		else
			rmPlaceObjectDefInArea(playerSilverNorthID, 0, plateauNorthID, cNumberNonGaiaPlayers/2);
		
		int playerSilverSouthID = rmCreateObjectDef("player silver south");
		rmAddObjectDefItem(playerSilverSouthID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(playerSilverSouthID, 0.0);
		rmSetObjectDefMaxDistance(playerSilverSouthID, rmXFractionToMeters(0.18));
		rmAddObjectDefConstraint(playerSilverSouthID, avoidMineMed);
		//rmAddObjectDefConstraint(playerSilverSouthID, avoidNatives);
		//rmAddObjectDefConstraint(playerSilverSouthID, avoidTownCenterMore);
		//rmAddObjectDefConstraint(playerSilverSouthID, avoidSocket);
		rmAddObjectDefConstraint(playerSilverSouthID, MineVSWaterMed);
		//rmAddObjectDefConstraint(playerSilverSouthID, forestConstraintShort);
		rmAddObjectDefConstraint(playerSilverSouthID, circleConstraint);
		if (cNumberNonGaiaPlayers==2)
			rmPlaceObjectDefInArea(playerSilverSouthID, 0, plateauSouthID, cNumberNonGaiaPlayers);
		else
			rmPlaceObjectDefInArea(playerSilverSouthID, 0, plateauSouthID, cNumberNonGaiaPlayers/2);

		int centralBox = rmCreateBoxConstraint("keep in the central box", 0.05, 0.3, 0.95, 0.7, 0.0);
		int avoidMineMed2=rmCreateTypeDistanceConstraint("avoid mines medium 2", "Mine", 47.0);
				
		int silverCentralPlateauID = rmCreateObjectDef("central plateau silver");
		rmAddObjectDefItem(silverCentralPlateauID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverCentralPlateauID, 0.0);
		rmSetObjectDefMaxDistance(silverCentralPlateauID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverCentralPlateauID, avoidMineMed2);
		rmAddObjectDefConstraint(silverCentralPlateauID, avoidNatives);
		rmAddObjectDefConstraint(silverCentralPlateauID, centralBox);
		rmAddObjectDefConstraint(silverCentralPlateauID, MineVSWaterMed);
		rmAddObjectDefConstraint(silverCentralPlateauID, avoidSocket);
		rmAddObjectDefConstraint(silverCentralPlateauID, circleConstraint);
		if (cNumberNonGaiaPlayers==2){
			rmAddObjectDefConstraint(silverCentralPlateauID, avoidMineMed2);
			rmPlaceObjectDefAtLoc(silverCentralPlateauID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
		}
		else if (cNumberNonGaiaPlayers<5){
			rmAddObjectDefConstraint(silverCentralPlateauID, avoidMineMed2);
			rmPlaceObjectDefAtLoc(silverCentralPlateauID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);	
		}
		else{
			rmAddObjectDefConstraint(silverCentralPlateauID, avoidCoinMed);
			rmPlaceObjectDefAtLoc(silverCentralPlateauID, 0, 0.5, 0.5, cNumberNonGaiaPlayers+4);	
		}
	}	
}
else{
// FFA
		int islandminesID = rmCreateObjectDef("island silver");
		rmAddObjectDefItem(islandminesID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(islandminesID, 0.0);
		rmSetObjectDefMaxDistance(islandminesID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(islandminesID, avoidCoinMed);
		rmAddObjectDefConstraint(islandminesID, avoidNatives);
		rmAddObjectDefConstraint(islandminesID, avoidTownCenterMore);
		//rmAddObjectDefConstraint(islandminesID, avoidSocket);
		rmAddObjectDefConstraint(islandminesID, AvoidWaterShort2);
		//rmAddObjectDefConstraint(islandminesID, forestConstraintShort);
		rmAddObjectDefConstraint(islandminesID, circleConstraint);
		rmPlaceObjectDefAtLoc(islandminesID, 0, 0.5, 0.5, (2*cNumberNonGaiaPlayers+rmRandInt(2,3)));
}	

rmSetStatusText("", 0.7);

// Trees

	for (j=0; < (10*cNumberNonGaiaPlayers)) {   
		int StartAreaTree2ID=rmCreateObjectDef("starting trees dirt"+j);
		rmAddObjectDefItem(StartAreaTree2ID, "ypTreeBorneo", rmRandInt(8,12), 16.0);
		rmAddObjectDefItem(StartAreaTree2ID, "ypTreeBorneo", rmRandInt(3,6), 12.0);
		rmAddObjectDefToClass(StartAreaTree2ID, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(StartAreaTree2ID, 0);
		rmSetObjectDefMaxDistance(StartAreaTree2ID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidTradeRoute);
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidSocket);
		rmAddObjectDefConstraint(StartAreaTree2ID, forestConstraint);
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidCoin);
		rmAddObjectDefConstraint(StartAreaTree2ID, avoidTownCenter);	
		rmAddObjectDefConstraint(StartAreaTree2ID, AvoidWaterShort2);	
		rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);
	}

	
// Huntables

	int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 40.0);
	
if (rmGetIsFFA()==false) {

// Coastal variation
	if (diceThrow<0.0){
	int rhea1ID = rmCreateObjectDef("rhea group 1");
	rmAddObjectDefItem(rhea1ID, "ypIbex", rmRandInt(8,10), 10.0);
	rmSetObjectDefCreateHerd(rhea1ID, true);
	rmSetObjectDefMinDistance(rhea1ID, 0);
	rmSetObjectDefMaxDistance(rhea1ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rhea1ID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(rhea1ID, avoidHunt);
	rmAddObjectDefConstraint(rhea1ID, avoidCliff);
	rmAddObjectDefConstraint(rhea1ID, NorthPie);
	
	int antelope1ID = rmCreateObjectDef("antelope group 1");
	rmAddObjectDefItem(antelope1ID, "Rhea", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(antelope1ID, true);
	rmSetObjectDefMinDistance(antelope1ID, 0);
	rmSetObjectDefMaxDistance(antelope1ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(antelope1ID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(antelope1ID, avoidHunt);
	rmAddObjectDefConstraint(antelope1ID, avoidCliff);
	rmAddObjectDefConstraint(antelope1ID, NorthPie);

	int tapir1ID = rmCreateObjectDef("tapir herd 1");
	rmAddObjectDefItem(tapir1ID, "ypIbex", rmRandInt(7,9), 12.0);
	rmSetObjectDefCreateHerd(tapir1ID, true);
	rmSetObjectDefMinDistance(tapir1ID, 0);
	rmSetObjectDefMaxDistance(tapir1ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(tapir1ID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(tapir1ID, avoidHunt);
	rmAddObjectDefConstraint(tapir1ID, avoidCliff);	
	rmAddObjectDefConstraint(tapir1ID, NorthPie);

	int moose1ID = rmCreateObjectDef("moose group 1");
	rmAddObjectDefItem(moose1ID, "rhea", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(moose1ID, true);
	rmSetObjectDefMinDistance(moose1ID, 0);
	rmSetObjectDefMaxDistance(moose1ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(moose1ID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(moose1ID, avoidHunt);
	rmAddObjectDefConstraint(moose1ID, avoidCliff);
	rmAddObjectDefConstraint(moose1ID, NorthPie);
	
	int rhea2ID = rmCreateObjectDef("rhea group 2");
	rmAddObjectDefItem(rhea2ID, "ypIbex", rmRandInt(8,10), 10.0);
	rmSetObjectDefCreateHerd(rhea2ID, true);
	rmSetObjectDefMinDistance(rhea2ID, 0);
	rmSetObjectDefMaxDistance(rhea2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rhea2ID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(rhea2ID, avoidHunt);
	rmAddObjectDefConstraint(rhea2ID, avoidCliff);
	rmAddObjectDefConstraint(rhea2ID, SouthPie);

	int antelope2ID = rmCreateObjectDef("antelope group 2");
	rmAddObjectDefItem(antelope2ID, "Rhea", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(antelope2ID, true);
	rmSetObjectDefMinDistance(antelope2ID, 0);
	rmSetObjectDefMaxDistance(antelope2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(antelope2ID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(antelope2ID, avoidHunt);
	rmAddObjectDefConstraint(antelope2ID, avoidCliff);
	rmAddObjectDefConstraint(antelope2ID, SouthPie);	

	int tapir2ID = rmCreateObjectDef("tapir herd 2");
	rmAddObjectDefItem(tapir2ID, "ypIbex", rmRandInt(7,9), 12.0);
	rmSetObjectDefCreateHerd(tapir2ID, true);
	rmSetObjectDefMinDistance(tapir2ID, 0);
	rmSetObjectDefMaxDistance(tapir2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(tapir2ID, avoidTownCenterMedium);		
	rmAddObjectDefConstraint(tapir2ID, avoidHunt);
	rmAddObjectDefConstraint(tapir2ID, avoidCliff);	
	rmAddObjectDefConstraint(tapir2ID, SouthPie);	

	int moose2ID = rmCreateObjectDef("moose group 2");
	rmAddObjectDefItem(moose2ID, "ypIbex", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(moose2ID, true);
	rmSetObjectDefMinDistance(moose2ID, 0);
	rmSetObjectDefMaxDistance(moose2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(moose2ID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(moose2ID, avoidHunt);
	rmAddObjectDefConstraint(moose2ID, avoidCliff);
	rmAddObjectDefConstraint(moose2ID, SouthPie);	

	int huntCount = -1;
		if (cNumberNonGaiaPlayers==2)
			huntCount = cNumberNonGaiaPlayers/2;
		else if (cNumberNonGaiaPlayers<=5)
			huntCount = cNumberNonGaiaPlayers/2;
		else
			huntCount = cNumberNonGaiaPlayers/2;
	
	rmPlaceObjectDefAtLoc(rhea1ID, 0, 0.75, 0.5, huntCount+1);
	rmPlaceObjectDefAtLoc(antelope1ID, 0, 0.75, 0.5, huntCount);
	rmPlaceObjectDefAtLoc(tapir1ID, 0, 0.75, 0.5, huntCount);
	rmPlaceObjectDefAtLoc(moose1ID, 0, 0.75, 0.5, huntCount);
	rmPlaceObjectDefAtLoc(rhea2ID, 0, 0.25, 0.5, huntCount+1);
	rmPlaceObjectDefAtLoc(antelope2ID, 0, 0.25, 0.5, huntCount);
	rmPlaceObjectDefAtLoc(tapir2ID, 0, 0.25, 0.5, huntCount);
	rmPlaceObjectDefAtLoc(moose2ID, 0, 0.25, 0.5, huntCount);
	}

// Trade route variation
	else {
	int rhea3bID = rmCreateObjectDef("rhea group 3 player");
	rmAddObjectDefItem(rhea3bID, "rhea", rmRandInt(8,10), 10.0);
	rmSetObjectDefCreateHerd(rhea3bID, true);
	rmSetObjectDefMinDistance(rhea3bID, 0);
	rmSetObjectDefMaxDistance(rhea3bID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rhea3bID, circleConstraint);
	rmAddObjectDefConstraint(rhea3bID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(rhea3bID, avoidHunt);	

	int tapir3bID = rmCreateObjectDef("tapir herd 3 player");
	rmAddObjectDefItem(tapir3bID, "ypIbex", rmRandInt(7,9), 12.0);
	rmSetObjectDefCreateHerd(tapir3bID, true);
	rmSetObjectDefMinDistance(tapir3bID, 0);
	rmSetObjectDefMaxDistance(tapir3bID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(tapir3bID, circleConstraint);
	rmAddObjectDefConstraint(tapir3bID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(tapir3bID, avoidHunt);
	
	rmPlaceObjectDefInArea(rhea3bID, 0, plateauNorthID, 1);
	rmPlaceObjectDefInArea(rhea3bID, 0, plateauSouthID, 1);
	rmPlaceObjectDefInArea(tapir3bID, 0, plateauNorthID, 1);
	rmPlaceObjectDefInArea(tapir3bID, 0, plateauSouthID, 1);
	
	int rhea3ID = rmCreateObjectDef("rhea group 3");
	rmAddObjectDefItem(rhea3ID, "ypIbex", rmRandInt(8,10), 10.0);
	rmSetObjectDefCreateHerd(rhea3ID, true);
	rmSetObjectDefMinDistance(rhea3ID, 0);
	rmSetObjectDefMaxDistance(rhea3ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rhea3ID, circleConstraint);
	rmAddObjectDefConstraint(rhea3ID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(rhea3ID, avoidHunt);
	
	int antelope3ID = rmCreateObjectDef("antelope group 3");
	rmAddObjectDefItem(antelope3ID, "Rhea", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(antelope3ID, true);
	rmSetObjectDefMinDistance(antelope3ID, 0);
	rmSetObjectDefMaxDistance(antelope3ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(antelope3ID, circleConstraint);
	rmAddObjectDefConstraint(antelope3ID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(antelope3ID, avoidHunt);

	int tapir3ID = rmCreateObjectDef("tapir herd 3");
	rmAddObjectDefItem(tapir3ID, "ypIbex", rmRandInt(7,9), 12.0);
	rmSetObjectDefCreateHerd(tapir3ID, true);
	rmSetObjectDefMinDistance(tapir3ID, 0);
	rmSetObjectDefMaxDistance(tapir3ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(tapir3ID, circleConstraint);
	rmAddObjectDefConstraint(tapir3ID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(tapir3ID, avoidHunt);

	int moose3ID = rmCreateObjectDef("moose group 3");
	rmAddObjectDefItem(moose3ID, "rhea", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(moose3ID, true);
	rmSetObjectDefMinDistance(moose3ID, 0);
	rmSetObjectDefMaxDistance(moose3ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(moose3ID, circleConstraint);
	rmAddObjectDefConstraint(moose3ID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(moose3ID, avoidHunt);
	
	int rhea4ID = rmCreateObjectDef("rhea group 4");
	rmAddObjectDefItem(rhea4ID, "ypIbex", rmRandInt(8,10), 10.0);
	rmSetObjectDefCreateHerd(rhea4ID, true);
	rmSetObjectDefMinDistance(rhea4ID, 0);
	rmSetObjectDefMaxDistance(rhea4ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rhea4ID, circleConstraint);
	rmAddObjectDefConstraint(rhea4ID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(rhea4ID, avoidHunt);

	int antelope4ID = rmCreateObjectDef("antelope group 4");
	rmAddObjectDefItem(antelope4ID, "Rhea", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(antelope4ID, true);
	rmSetObjectDefMinDistance(antelope4ID, 0);
	rmSetObjectDefMaxDistance(antelope4ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(antelope4ID, circleConstraint);
	rmAddObjectDefConstraint(antelope4ID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(antelope4ID, avoidHunt);

	int tapir4ID = rmCreateObjectDef("tapir herd 4");
	rmAddObjectDefItem(tapir4ID, "ypIbex", rmRandInt(7,9), 12.0);
	rmSetObjectDefCreateHerd(tapir4ID, true);
	rmSetObjectDefMinDistance(tapir4ID, 0);
	rmSetObjectDefMaxDistance(tapir4ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(tapir4ID, circleConstraint);
	rmAddObjectDefConstraint(tapir4ID, avoidTownCenterMedium);		
	rmAddObjectDefConstraint(tapir4ID, avoidHunt);

	int moose4ID = rmCreateObjectDef("moose group 4");
	rmAddObjectDefItem(moose4ID, "rhea", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(moose4ID, true);
	rmSetObjectDefMinDistance(moose4ID, 0);
	rmSetObjectDefMaxDistance(moose4ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(moose4ID, circleConstraint);
	rmAddObjectDefConstraint(moose4ID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(moose4ID, avoidHunt);
	
	int huntsVSLandstrips = rmCreateClassDistanceConstraint("extra hunts outside of players starting areas", classIsland, 1.0);
	
	int herdCount = -1;
		if (cNumberNonGaiaPlayers==2)
			herdCount = cNumberNonGaiaPlayers/2;
		else if (cNumberNonGaiaPlayers<=5)
			herdCount = cNumberNonGaiaPlayers/2;
		else
			herdCount = cNumberNonGaiaPlayers/2;
	
	rmAddObjectDefConstraint(rhea3ID, huntsVSLandstrips);	
	rmPlaceObjectDefAtLoc(rhea3ID, 0, 0.5, 0.5, herdCount);
		
	rmAddObjectDefConstraint(antelope3ID, huntsVSLandstrips);	
	rmPlaceObjectDefAtLoc(antelope3ID, 0, 0.5, 0.5, herdCount);

	rmAddObjectDefConstraint(tapir3ID, huntsVSLandstrips);	
	rmPlaceObjectDefAtLoc(tapir3ID, 0, 0.5, 0.5, herdCount);

	rmAddObjectDefConstraint(moose3ID, huntsVSLandstrips);	
	rmPlaceObjectDefAtLoc(moose3ID, 0, 0.5, 0.5, herdCount);

	rmAddObjectDefConstraint(rhea4ID, huntsVSLandstrips);	
	rmPlaceObjectDefAtLoc(rhea4ID, 0, 0.5, 0.5, herdCount+1);
	
	rmAddObjectDefConstraint(antelope4ID, huntsVSLandstrips);	
	rmPlaceObjectDefAtLoc(antelope4ID, 0, 0.5, 0.5, herdCount);

	rmAddObjectDefConstraint(tapir4ID, huntsVSLandstrips);	
	rmPlaceObjectDefAtLoc(tapir4ID, 0, 0.5, 0.5, herdCount);

	rmAddObjectDefConstraint(moose4ID, huntsVSLandstrips);	
	rmPlaceObjectDefAtLoc(moose4ID, 0, 0.5, 0.5, herdCount);	
	}	
}
else{
// FFA

	int rheaxID = rmCreateObjectDef("rhea groups");
	rmAddObjectDefItem(rheaxID, "ypIbex", rmRandInt(8,10), 10.0);
	rmSetObjectDefCreateHerd(rheaxID, true);
	rmSetObjectDefMinDistance(rheaxID, 0);
	rmSetObjectDefMaxDistance(rheaxID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rheaxID, circleConstraint);
	rmAddObjectDefConstraint(rheaxID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(rheaxID, avoidHunt);
	
	int antelopexID = rmCreateObjectDef("antelope groups");
	rmAddObjectDefItem(antelopexID, "Rhea", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(antelopexID, true);
	rmSetObjectDefMinDistance(antelopexID, 0);
	rmSetObjectDefMaxDistance(antelopexID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(antelopexID, circleConstraint);
	rmAddObjectDefConstraint(antelopexID, avoidTownCenterMedium);
	rmAddObjectDefConstraint(antelopexID, avoidHunt);

	int tapirxID = rmCreateObjectDef("tapir herds");
	rmAddObjectDefItem(tapirxID, "ypIbex", rmRandInt(7,9), 12.0);
	rmSetObjectDefCreateHerd(tapirxID, true);
	rmSetObjectDefMinDistance(tapirxID, 0);
	rmSetObjectDefMaxDistance(tapirxID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(tapirxID, circleConstraint);
	rmAddObjectDefConstraint(tapirxID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(tapirxID, avoidHunt);

	int moosexID = rmCreateObjectDef("moose groups");
	rmAddObjectDefItem(moosexID, "rhea", rmRandInt(9,12), 8.0);
	rmSetObjectDefCreateHerd(moosexID, true);
	rmSetObjectDefMinDistance(moosexID, 0);
	rmSetObjectDefMaxDistance(moosexID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(moosexID, circleConstraint);
	rmAddObjectDefConstraint(moosexID, avoidTownCenterMedium);	
	rmAddObjectDefConstraint(moosexID, avoidHunt);

	rmPlaceObjectDefAtLoc(rheaxID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(antelopexID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(tapirxID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(moosexID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
}	

rmSetStatusText("", 0.8);

// Nuggets!

	int avoidImpassableLandMore=rmCreateTerrainDistanceConstraint("avoid impassable land more", "Land", false, 15.0);

	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, avoidEdgeMore);
	//rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, avoidCoin); 
	//rmAddObjectDefConstraint(nuggetID, avoidImpassableLandMore);
	rmAddObjectDefConstraint(nuggetID, avoidNatives); 
	rmAddObjectDefConstraint(nuggetID, avoidAll); 
	rmAddObjectDefConstraint(nuggetID, avoidWaterShort); 
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidSocket); 
	rmSetNuggetDifficulty(1, 2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*(cNumberNonGaiaPlayers + rmRandInt(2,4))); 

rmSetStatusText("", 0.9);

    
// Land underbrush stuff -- shrubs, twigs, rocks

	int props = rmCreateObjectDef("ground underbrush");
	rmAddObjectDefItem(props, "UnderbrushBorneo", 1, 0.0);
	rmSetObjectDefMinDistance(props, 0);
	rmSetObjectDefMaxDistance(props, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(props, avoidImportantItem);
  	//rmAddObjectDefConstraint(props, playerConstraint);
  	rmAddObjectDefConstraint(props, avoidEdgeMore);
  	rmAddObjectDefConstraint(props, avoidBrush);
	rmAddObjectDefConstraint(props, avoidNativesMed);
  	rmAddObjectDefConstraint(props, avoidCoinShort);
  	rmAddObjectDefConstraint(props, avoidWaterShort);
  	rmAddObjectDefConstraint(props, avoidTownCenterSmall);
  	rmAddObjectDefConstraint(props, avoidCliff);
	rmPlaceObjectDefAtLoc(props, 0, 0.5, 0.5, 90*cNumberNonGaiaPlayers);

 
	// Ruins

	int ruinCount = (cNumberNonGaiaPlayers + rmRandInt(1,2));
	rmDefineClass("classWall");
	int wallConstraint=rmCreateClassDistanceConstraint("wall vs. wall", rmClassID("classWall"), 40.0);

	for(i=0; < ruinCount) {
		int stoneWallID = rmCreateGrouping("stone wall "+i, "uger"+rmRandInt(1,4));
		rmAddGroupingToClass(stoneWallID, rmClassID("classWall"));
		rmSetGroupingMinDistance(stoneWallID, 0.0);
		rmSetGroupingMaxDistance(stoneWallID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(stoneWallID, avoidEdgeMore);
		rmAddGroupingConstraint(stoneWallID, forestConstraintShort);
		rmAddGroupingConstraint(stoneWallID, avoidTradeRoute);
		rmAddGroupingConstraint(stoneWallID, avoidSocket);
		rmAddGroupingConstraint(stoneWallID, wallConstraint);
		rmAddGroupingConstraint(stoneWallID, avoidWater);
		rmAddGroupingConstraint(stoneWallID, avoidNativesMed);
		rmAddGroupingConstraint(stoneWallID, avoidTownCenter);
		rmAddGroupingConstraint(stoneWallID, avoidNuggetSmall);
		rmAddGroupingConstraint(stoneWallID, avoidAll);
		rmPlaceGroupingAtLoc(stoneWallID, 0, 0.5, 0.5);
	}

	// KOTH game mode
   if(rmGetIsKOTH())
   {
      float xLoc = 0.5;
      float yLoc = 0.5;
      float walk = 0.03;
      
      ypKingsHillPlacer(yLoc, yLoc, walk, 0);
      rmEchoInfo("XLOC = "+yLoc);
      rmEchoInfo("XLOC = "+yLoc);
   }
	
	// Water buffalos

	if (IsYP()){
		int avoidBuffalo=rmCreateTypeDistanceConstraint("buffalo avoids buffalo", "ypWaterBuffalo", 60.0);

		int randomSheep = rmCreateObjectDef("random sheep");
		rmAddObjectDefItem(randomSheep, "ypWaterBuffalo", 1, 3.0);
		rmSetObjectDefMinDistance(randomSheep, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomSheep, rmXFractionToMeters(0.33));
		//rmAddObjectDefConstraint(randomSheep, avoidAll);
		//rmAddObjectDefConstraint(randomSheep, avoidImpassableLand);
		rmAddObjectDefConstraint(randomSheep, avoidCliff);
		rmAddObjectDefConstraint(randomSheep, avoidBuffalo);
		rmPlaceObjectDefAtLoc(randomSheep, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3+rmRandInt(2,3));
	}

		for (i=0; < cNumberNonGaiaPlayers*50){
			int patchID = rmCreateArea("the redder stuff"+i);
			rmSetAreaWarnFailure(patchID, false);
			rmSetAreaSize(patchID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(51));
			rmAddAreaTerrainReplacement(patchID, "borneo\ground_grass1_borneo", "borneo\ground_forest_borneo");
			rmPaintAreaTerrain(patchID);
			rmAddAreaToClass(patchID, rmClassID("patch"));
			rmSetAreaSmoothDistance(patchID, 1.0);
			rmAddAreaConstraint(patchID, circleConstraint2);
			rmBuildArea(patchID); 
		}

rmSetMapClusteringNoiseParams(0.05, 5, 0.5);  
rmSetMapClusteringPlacementParams(0.2, 0.3, 0.4, cClusterLand);
rmSetMapClusteringObjectParams(0, 0, 0.5);
rmPlaceMapClusters("", "borneo_underbrush"); 
   
rmSetStatusText("", 1.0);
    
}