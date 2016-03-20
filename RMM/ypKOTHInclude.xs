
// KingsHill placements 

void ypKingsHillPlacer (float xLoc = 0.0, float yLoc = 0.0, float walkDistance = 0.0, int extraConstraint = 0) {

  int kingsHillAvoidImpassableLand=rmCreateTerrainDistanceConstraint("kings hill avoids impassable land", "Land", false, 4.0);
  int kingsHillAvoidAll=rmCreateTypeDistanceConstraint("kings hill avoids all", "all", 4.0);
  int kingsHillAvoidTradeRouteSocket = rmCreateTypeDistanceConstraint("kings hill avoids trade route socket", "socketTradeRoute", 4.0);
  int kingsHillEdgeConstraint= rmCreatePieConstraint("kings hill edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int kingsHillAvoidsTC = rmCreateTypeDistanceConstraint("kings hill avoids TCs", "Towncenter", 45.0);
  int kingsHillAvoidsCW = rmCreateTypeDistanceConstraint("kings hill avoids CWs", "CoveredWagon", 45.0);
  int kingsHillAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("kings hill avoids trade route", 6.0);
  int kingsHillAvoidFlag = rmCreateTypeDistanceConstraint("avoid flag", "HomeCityWaterSpawnFlag", 4.0);

  int kingsHillID = rmCreateObjectDef("KingsHill");
  rmAddObjectDefItem(kingsHillID, "ypKingsHill", 1, 0);
  
  // Assign generic constraints to the Hill
  rmSetObjectDefMinDistance(kingsHillID, 0.0);
  rmSetObjectDefMaxDistance(kingsHillID, rmXFractionToMeters(walkDistance));
  rmAddObjectDefConstraint(kingsHillID, kingsHillAvoidImpassableLand);
  rmAddObjectDefConstraint(kingsHillID, kingsHillAvoidAll);
  rmAddObjectDefConstraint(kingsHillID, kingsHillAvoidTradeRouteSocket);
  rmAddObjectDefConstraint(kingsHillID, kingsHillEdgeConstraint);
  rmAddObjectDefConstraint(kingsHillID, kingsHillAvoidsTC);
  rmAddObjectDefConstraint(kingsHillID, kingsHillAvoidsCW);
  rmAddObjectDefConstraint(kingsHillID, kingsHillAvoidTradeRoute);
  rmAddObjectDefConstraint(kingsHillID, kingsHillAvoidFlag);
  
  // Assign any extra constraints passed in by the script. Allows a little extra flexibility for map specific constraints (avoiding cliffs, canyons, etc)
  if (extraConstraint > 0) {
    rmAddObjectDefConstraint(kingsHillID, extraConstraint);
  }
    
  rmPlaceObjectDefAtLoc(kingsHillID, 0, xLoc, yLoc, 1);  
   
} // end ypKingsHillPlacer

void ypKingsHillLandfill (float xLoc = 0.0, float yLoc = 0.0, float fillSize = 0.0, float fillHeight = 0.0, string fillMix = "", int extraConstraint = 0) {
  
  int fill = rmCreateArea("hill placer");
  rmSetAreaLocation(fill, xLoc, yLoc);
  rmSetAreaMix(fill, fillMix);
  rmSetAreaSize(fill, fillSize, fillSize);
  rmSetAreaCoherence(fill, 0.9);

  rmSetAreaBaseHeight(fill, fillHeight);
  rmSetAreaSmoothDistance(fill, 5);

  if (extraConstraint > 0)
    rmAddAreaConstraint(fill, extraConstraint);
  
  rmSetAreaWarnFailure(fill, false);
  rmBuildArea(fill);  
} // end ypKingsHillLandfill