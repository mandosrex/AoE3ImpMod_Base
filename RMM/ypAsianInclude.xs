
// Some functions to ease inclusion of Asians into the new and existing RMs

bool ypIsAsian (int pID = 0){
  
      //~ if (rmGetPlayerCiv(pID) ==  rmGetCivID("Japanese") || rmGetPlayerCiv(pID) ==  rmGetCivID("Chinese") || rmGetPlayerCiv(pID) ==  rmGetCivID("Indians"))
        //~ return(true);
  
      if (rmGetPlayerCiv(pID) ==  rmGetCivID("Japanese"))
        return(true);
  
      return(false);
} // end ypIsAsian

string ypTCChooser (int pID = 0) {

    string playerTCType = "";

    if (ypIsAsian(pID))
        playerTCType = "YPTownCenterAsian";
 
    else 
        playerTCType = "Towncenter";

return(playerTCType);

} // end ypTCChooser

int ypMonasteryBuilder (int pID = 0, int berryWagon = 0) {
  
  // Have to declare separate constraints each time this function is called to avoid duplicate constraints (and then having to declare them in each separate RM file).
  // Would have liked to initialize them once in a separate function, but the script compiler doesn't like that.
  
  string objectType = "ypConsulate";
  string objectType2 = "ypBerryWagon1";
  
  int monasteryAvoidImpassableLand=rmCreateTerrainDistanceConstraint("monastery avoids impassable land" + pID, "Land", false, 4.0);
  int monasteryAvoidAll=rmCreateTypeDistanceConstraint("monastery avoids all"+ pID, "all", 4.0);
 	int monasteryAvoidTradeRouteSocket = rmCreateTypeDistanceConstraint("monastery avoids trade route socket"+ pID, "socketTradeRoute", 8.0);
  int monasteryAvoidsMonastery=rmCreateTypeDistanceConstraint("monastery avoids same" + pID, objectType, 8.0);
  int monasteryEdgeConstraint= rmCreatePieConstraint("monastery edge of map" + pID, 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int monasteryAvoidsTC = rmCreateTypeDistanceConstraint("Monastery avoids TCs a bit" + pID, "Towncenter", 7.0);
  int monasteryAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("Monastery avoids trade route" + pID, 6.0);
	int monasteryAvoidResource=rmCreateTypeDistanceConstraint("monastery avoid resource" + pID, "resource", 5.0);

  int monID = rmCreateObjectDef("Monastery" + pID);
  //~ rmAddObjectDefItem(monID, objectType, 1, 3.0);
  if(berryWagon == 1)
    rmAddObjectDefItem(monID, objectType2, 1, 6.0);
  //~ rmAddObjectDefItem(monID, "ypMonastery", 1, 0);
  rmSetObjectDefMinDistance(monID, 12);
  rmSetObjectDefMaxDistance(monID, 19);
 	rmAddObjectDefConstraint(monID, monasteryAvoidAll);
 	rmAddObjectDefConstraint(monID, monasteryAvoidTradeRouteSocket);
 	rmAddObjectDefConstraint(monID, monasteryAvoidImpassableLand);
  rmAddObjectDefConstraint(monID, monasteryAvoidsMonastery);
  rmAddObjectDefConstraint(monID, monasteryEdgeConstraint);
  rmAddObjectDefConstraint(monID, monasteryAvoidsTC);
  rmAddObjectDefConstraint(monID, monasteryAvoidTradeRoute);
  rmAddObjectDefConstraint(monID, monasteryAvoidResource);
  
  return(monID);

} // end ypMonasteryBuilder


int ypRicePaddyBuilder (int pID = 0) {
  
  // Have to declare separate constraints each time this function is called to avoid duplicate constraints (and then having to declare them in each separate RM file).
  // Would have liked to initialize them once in a separate function, but the script compiler doesn't like that.
  
  int ricePaddyAvoidImpassableLand=rmCreateTerrainDistanceConstraint("rice paddy avoids impassable land" + pID, "Land", false, 4.0);
  int ricePaddyAvoidAll=rmCreateTypeDistanceConstraint("rice paddy avoids all"+ pID, "all", 4.0);
 	int ricePaddyAvoidTradeRouteSocket = rmCreateTypeDistanceConstraint("rice paddy avoids trade route socket"+ pID, "socketTradeRoute", 8.0);
  int ricePaddyAvoidsMonastery=rmCreateTypeDistanceConstraint("rice paddy avoids monastery" + pID, "ypMonastery", 8.0);
  int ricePaddyAvoidsRicePaddy=rmCreateTypeDistanceConstraint("rice paddy avoids same" + pID, "ypRicePaddy", 8.0);
  int ricePaddyEdgeConstraint= rmCreatePieConstraint("rice paddy edge of map" + pID, 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int ricePaddyAvoidsTC = rmCreateTypeDistanceConstraint("Rice Paddy avoids TCs a bit" + pID, "Towncenter", 7.0);
  int ricePaddyAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("Rice Paddy avoids trade route" + pID, 6.0);
	int ricePaddyAvoidResource=rmCreateTypeDistanceConstraint("rice paddy avoid resource" + pID, "resource", 5.0);

  int rpID = rmCreateObjectDef("RicePaddy" + pID);
  rmAddObjectDefItem(rpID, "ypRicePaddy", 1, 0);
  rmSetObjectDefMinDistance(rpID, 9);
  rmSetObjectDefMaxDistance(rpID, 16);
 	rmAddObjectDefConstraint(rpID, ricePaddyAvoidAll);
 	rmAddObjectDefConstraint(rpID, ricePaddyAvoidTradeRouteSocket);
 	rmAddObjectDefConstraint(rpID, ricePaddyAvoidImpassableLand);
  rmAddObjectDefConstraint(rpID, ricePaddyAvoidsMonastery);
  rmAddObjectDefConstraint(rpID, ricePaddyAvoidsRicePaddy);
  rmAddObjectDefConstraint(rpID, ricePaddyEdgeConstraint);
  rmAddObjectDefConstraint(rpID, ricePaddyAvoidsTC);
  rmAddObjectDefConstraint(rpID, ricePaddyAvoidTradeRoute);
  rmAddObjectDefConstraint(rpID, ricePaddyAvoidResource);
  
  return(rpID);

} // end ypRicePaddyBuilder













