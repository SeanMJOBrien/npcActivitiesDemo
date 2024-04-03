////////////////////////////////////////////////////////////////////////////////
// npcact_h_moving - The movement library for NPC ACTIVITIES 6.1
// By Deva Bryson Winblood.
// Last original by: Deva Bryson Winblood  2/4/2006
// Modifications, rewrites, perquisites, corrections - Peak (Peter D. Busby)
// Pathways (c) added 6/14/10 - Peak
// Last modified 6/30/10 - Peak
////////////////////////////////////////////////////////////////////////////////
#include "x0_i0_anims"
#include "x3_inc_string"

const int MOVE_DEBUG_ON = FALSE; // set to TRUE if you want movement debug messages
const string MOVE_DEBUG_NPC = "Guard02"; // set to tag of specific NPC to debug its movement only

/////////////////////////////////////////
// PROTOTYPES
/////////////////////////////////////////

// FILE: npcact_h_moving  FUNCTION: fnMoveToDestination()
//-------------------------------------------------------
// This function is called to move an npc to a specified destination oDest
// to the range fRange.  This function uses anti-stuck scripting technology,
// supports multiple movement methods, and can make calls to more complex pathing
// commands if need be. [Aha! - p] It also checks nearby doors, triggers, and placeables to
// insure that the closest entrance to another area is chosen.  This is done to
// prevent the choosing a further door problem that Bioware pathing sometimes uses
// when there are more than one door linking to another area.  It will with Bioware
// sometimes wander to another door rather than using the one it is standing directly
// next to.   This has been addressed by this function. For clarity: the door nearest
// the destination in the next area is chosen - pk. The function returns the
// following values:  0 = still pathing, 1=arrived, -1 = error unreachable
// -1 and 1 you must react to.  -1 is returned when even with all the anti-stuck
// technology the NPC was still unable to reach the destination.
// Rewritten 5/10 peak, for efficiency, handle fRange and normal doors. Added Pathways 6/10.
int fnMoveToDestination(object oNPC,object oDest,float fRange=1.0);

// FILE: npcact_h_moving  FUNCTION: MOVE_LocationInDirection
//----------------------------------------------------------
// This function will take a specified starting direction and provide another
// location in the direction specified fDistance from the specified location.
location MOVE_LocationInDirection(location lStart,float fDirection,float fDistance);

// FILE: npcact_h_moving  FUNCTION: string fnPadTheNum
//----------------------------------------------------
// For int nNum between 0 - 99, return string in format ##
string fnPadTheNum(int nNum);

// FILE: npcact_h_moving  FUNCTION: fnCompareFloats
//-------------------------------------------------
// Compare 2 floating-point numbers within specified precision, returns 1 (TRUE) if equal.
// Default is good for checking static position
int fnCompareFloats(float fFloat1, float fFloat2, float fPrecision=1.0);

/////////////////////////////////////////
// FUNCTIONS
/////////////////////////////////////////

location MOVE_LocationInDirection(location lStart,float fDirection,float fDistance)
{ // PURPOSE: Return a new location fDistance in the fDirection facing from lStart
  // rewritten 6/10 peak
  location lRet;
  vector vVec=GetPositionFromLocation(lStart);
  float fX,fY,fZ,fNX,fNY,fNZ;
  float fDX,fDY,fDZ;
  object oArea=GetAreaFromLocation(lStart);
  fX=vVec.x;
  fY=vVec.y;
  fZ=vVec.z;
  fDX=sin(fDirection);
  fDY=cos(fDirection);
  fNX=(fDX*fDistance)+fX;
  fNY=(fDY*fDistance)+fY;
  vVec.x=fNX;
  vVec.y=fNY;
  lRet=Location(oArea,vVec,fDirection);
  return lRet;
} // MOVE_LocationInDirection()

void DebugMove(string sSay)
{ // PURPOSE: To display debug messages for movement
  // LAST MODIFIED BY: Deva Bryson Winblood  6/25/2004
  // modPeak 5/10 to remove redundant statement
  if (MOVE_DEBUG_ON&&(MOVE_DEBUG_NPC==GetTag(OBJECT_SELF)||MOVE_DEBUG_NPC==""))
  { // okay to display
    string sArea=GetName(GetArea(OBJECT_SELF));
    sSay="["+GetTag(OBJECT_SELF)+"] [_h_moving: Area "+sArea+"] "+sSay;
    SendMessageToPC(GetFirstPC(),sSay);
    PrintString(sSay);
  } // okay to display
} // DebugMove()

object fnFindRandomDestination(object oFrom,int bUseObjects=FALSE)
{ // PURPOSE: To find a random destination from a specific object
  // If bUseObjects is set to TRUE it will use the older method of
  // grabbing a random object as opposed to calculating a new destination
  // This is Deva's script, I believe - modified for failsafe 7/01/10 Peak
  object oOb=OBJECT_INVALID;
  if (bUseObjects)
  { // use random objects
    oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oFrom,d100());
    if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oFrom,d20());
    if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oFrom,d12());
    if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,oFrom,d20());
    if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,oFrom,d12());
    if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_ITEM,oFrom,d20());
    if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_ITEM,oFrom,d12());
    if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_ALL,oFrom,d10());
    if (oOb!=OBJECT_INVALID) return oOb;
  } // use random objects
 // calculate location
  int nL, nN, nXSize, nYSize;
  float fF;
  vector vVec;
  location lLoc;
  object oArea=GetArea(oFrom);
  float fX, fY;
  nXSize=GetAreaSize(AREA_WIDTH,oArea);
  nYSize=GetAreaSize(AREA_HEIGHT,oArea);
  nN=Random(nXSize*10);
  fX=IntToFloat(nN);
  nN=Random(nYSize*10);
  fY=IntToFloat(nN);
  vVec=GetPosition(oFrom);
  vVec.x=fX;
  vVec.y=fY;
  lLoc=Location(oArea,vVec,GetFacing(oFrom));
  oOb=CreateObject(OBJECT_TYPE_WAYPOINT,"nw_waypoint001",lLoc,FALSE,"NPCACT_TEMPORARY");
  DelayCommand(10.0,DestroyObject(oOb));
  return oOb;
  // calculate location
} // fnFindRandomDestination()

void MTDCleanup(object oNPC)
{ // clear variables on oNPC - last mod Peak 6/10
      DeleteLocalInt(oNPC,"nGNBASC"); // clear these in case PC changed area
      DeleteLocalInt(oNPC,"nGNBASR");
      DeleteLocalFloat(oNPC,"fLastDist");
      DeleteLocalObject(oNPC,"oGNBNearbyObject");
      DeleteLocalObject(oNPC,"oPWLastDest");
      DeleteLocalObject(oNPC,"oPWLastFinal");
      DeleteLocalInt(oNPC,"bModulePossessed");
      DeleteLocalString(oNPC,"sPWChain");
      DeleteLocalString(oNPC,"sPWMapIdx");
      DeleteLocalInt(oNPC,"nMTDChangeArea");
} // fnMTDCleanup()

int fnHandleStuck(object oNPC,object oDest,int bRun, float fRange)
{ // PURPOSE: To handle anti-stuck situations
  // LAST MODIFIED BY: Deva Bryson Winblood  6/25/2004
  // rewritten 5/10 last modified 7/01/10 Peak (Peter D Busby)
  DebugMove("Just entering fnHandleStuck with oDest: "+GetName(oDest));
  if(GetLocalObject(oNPC,"oPWLastDest")!=OBJECT_INVALID) oDest=GetLocalObject(oNPC,"oPWLastDest");
  int nASC=GetLocalInt(oNPC,"nGNBASC");
  if (nASC>3)
  { // can't get there
    MTDCleanup(oNPC);
    return -1;
  } // can't get there
  nASC++;
  SetLocalInt(oNPC,"nGNBASC",nASC);
  if (nASC==1)
  { // first encounter
    if (GetArea(oNPC)!=GetArea(oDest))
    { // handle door
      object oC=GetNearestObject(OBJECT_TYPE_DOOR,oNPC,1);
      if (oC!=OBJECT_INVALID&&GetDistanceBetween(oNPC,oC)<1.5f)
      { // transition
        object oTarget=GetTransitionTarget(oC);
        if(GetArea(oDest)==GetArea(oTarget))
        { // valid xn
          if(GetIsOpen(oC)==FALSE)
          { // face and open door
            AssignCommand(oNPC,ActionOpenDoor(oC));
            if (GetObjectType(GetTransitionTarget(oC))==OBJECT_TYPE_DOOR)
              AssignCommand(GetTransitionTarget(oC),ActionOpenDoor(oC));
          } // face and open door
          object oPCN=GetNearestObject(OBJECT_TYPE_WAYPOINT,oTarget,1);
          if (oPCN==OBJECT_INVALID) oPCN=GetNearestObject(OBJECT_TYPE_PLACEABLE,oTarget,1);
          if (oPCN==OBJECT_INVALID) oPCN=oTarget;
          DeleteLocalFloat(oNPC,"fLastDist");
          AssignCommand(oNPC,JumpToObject(oPCN));
          return 0;
        } // valid xn
      } // transition
    } // handle door
    AssignCommand(oNPC,ClearAllActions(TRUE));
    AssignCommand(oNPC,ActionForceMoveToObject(oDest,bRun,fRange));//@@@
    return 0;
  } // first encounter
  int nASR=GetLocalInt(oNPC,"nGNBASR");
  if (nASR<3)
  { // pick a nearby object to move near
    object oOb=fnFindRandomDestination(oNPC);
    SetLocalInt(oNPC,"nGNBDisabled",1);
    AssignCommand(oNPC,ClearAllActions(TRUE));
    AssignCommand(oNPC,ActionMoveToObject(oOb,bRun));
    int nR=d4();
    float fR=3.0+IntToFloat(nR);
    DelayCommand(fR,AssignCommand(oNPC,ClearAllActions(TRUE)));
    DelayCommand(fR+0.1,AssignCommand(oNPC,ActionMoveToObject(oDest,bRun,fRange)));
    DelayCommand(fR+0.2,DeleteLocalInt(oNPC,"nGNBDisabled"));
    SetLocalInt(oNPC,"nGNBASC",0);
    nASR++;
    SetLocalInt(oNPC,"nGNBASR",nASR);
  } // pick a nearby object to move near
  else
  { // teleport
    AssignCommand(oNPC,ClearAllActions(TRUE));
    AssignCommand(oNPC,JumpToLocation(GetLocation(oDest)));
  } // teleport
  return 0;
} // fnHandleStuck()

void fnJumpNPC(object oNPC,object oDest,float fRange)
{ // PURPOSE: Move the NPC quick
  // Another of Deva's.
  if (GetArea(oNPC)!=GetArea(oDest)||GetDistanceBetween(oNPC,oDest)>fRange)
  { // teleport
    if (GetIsInCombat(oNPC)==FALSE)
    { // okay to teleport
      AssignCommand(oNPC,ClearAllActions());
      AssignCommand(oNPC,JumpToObject(oDest));
      DelayCommand(6.0,fnJumpNPC(oNPC,oDest,fRange));
    } // okay to teleport
  } // teleport
} // fnJumpNPC()

string fnPadTheNum(int nNum)
{ // from Deva's npcact_states
  // last modified by peak 5/10
  string sRet="";
  if (nNum<10) sRet="0";
  if (nNum<100) sRet=sRet+IntToString(nNum);
  return sRet;
} // fnPadTheNum

int fnCompareFloats(float fFloat1, float fFloat2, float fPrecision=1.0)
{ // Compare 2 floating numbers within specified precision
  // so for comparing distance @ 1m, use default 1/2 m
  // Peak 5/10
  if((fFloat1+fPrecision/2)>=fFloat2&&(fFloat1-fPrecision/2)<=fFloat2) return 1;
  return 0;
} // fnCompareFloats

int PWTestJCTs(object oNPC, string sChain, int nIndex)
{ // test map strings common to JCT with final JCTs, extend JCT chains, return nChainIndex
  // supporting Pathways - (c)copyright Peter D. Busby 5/31/10 see caveat below
  DebugMove("entering PWTestJCTs with sChain "+sChain+" nIndex "+IntToString(nIndex));
  if(sChain=="") return 0;
  string sJ, sS, sTest, sEnds;
  string sFinalChain="";
  string sd=".";
  string sChEnd=StringParse(sChain,sd,TRUE);
  string sFinalJCT1=GetLocalString(oNPC,"sPWFinalJCT1"); // @fnPW
  string sFinalJCT2=GetLocalString(oNPC,"sPWFinalJCT2"); // @fnPW
  string sTestedJCTs=GetLocalString(oNPC,"sPWTestedJCTs"); //@local
  string sMapIdx=GetLocalString(oNPC,"sPWMapIdx"); // @fnPW
  DebugMove("sPWMapIdx: "+sMapIdx);
//  int nN=1;
  object oPathways=GetNearestObjectByTag("PW_Pathways");
  string sMap=GetLocalString(oPathways,"sPathway"+GetStringLeft(sMapIdx,2));
  sMapIdx=GetStringRight(sMapIdx,GetStringLength(sMapIdx)-2);
  while (sMap!="")
  { // find ends
    DebugMove("sMap "+sMap);
    sJ=StringParse(sMap,sd);
    if(sJ!=sChEnd) sJ=StringParse(sMap,sd,TRUE);
    if(sJ==sChEnd)
    { // found next jct/end
      sTest=StringParse(sMap,sd);
      sEnds=sTest+"|"+StringParse(sMap,sd,TRUE);
      if(sTest==sJ) sTest=StringParse(sMap,sd,TRUE);
      if(sTest!="END")
      { // found a JCT
        if(sMapIdx==""&&d4()>1&&GetLocalString(oNPC,"sPWAvoidAddress")!="")
        { // 25% chance of passing address
          nIndex=-nIndex; // flag recover test
          DebugMove("avoiding address");
        } // 25% chance of passing address
        else
        { // otherwise
          if(sTest==sFinalJCT1)
            sFinalChain=sChain+sd+sFinalJCT1+sd+GetLocalString(oNPC,"sPWFinalADD");
          if(sTest==sFinalJCT2)
           sFinalChain=sChain+sd+sFinalJCT2+sd+GetLocalString(oNPC,"sPWFinalADD");
          if(sFinalChain!="")
          { // found our way
            SetLocalString(oNPC,"sPWChain",sFinalChain);
            DebugMove("sFinalChain: "+sFinalChain);
            return 0;
          } // found our way
          sJ=sTestedJCTs;
          while(sJ!="")
          { // check for circular PW
            sS=StringParse(sJ,sd);
            if(sS==sEnds) break;
            sJ=StringRemoveParsed(sJ,sS,sd);
          } // check for circular PW
          if(sJ=="")
          { // untested JCT
            nIndex++;
            SetLocalString(oNPC,"sPWChain"+IntToString(nIndex),sChain+sd+sTest);
            DebugMove("nIndex= "+IntToString(nIndex));
            sTestedJCTs=sTestedJCTs+sd+sEnds;
          } // untested JCT
        } // otherwise
      } // found a JCT
    } // found next jct/end
//    nN++;
    sMap=GetLocalString(oPathways,"sPathway"+GetStringLeft(sMapIdx,2));
    sMapIdx=GetStringRight(sMapIdx,GetStringLength(sMapIdx)-2);
  } // find ends
  SetLocalString(oNPC,"sPWTestedJCTs",sTestedJCTs);
  return nIndex;
} // PWTestJCTs()

void PWCleanup(int nLow, int nHigh)
{ // sbr to clean up PW variables
  // Peak 6/02/10
      object oNPC=OBJECT_SELF;
      while(nHigh>=nLow)
      { // clear test chains
        DeleteLocalString(oNPC,"sPWChain"+IntToString(nHigh));
        nHigh--;
      } // clear test chains
      DeleteLocalString(oNPC,"sPWFinalADD");
      DeleteLocalString(oNPC,"sPWLocalADD");
      DeleteLocalString(oNPC,"sPWFinalJCT1");
      DeleteLocalString(oNPC,"sPWFinalJCT2");
      DeleteLocalInt(oNPC,"nPWChainIndexHigh");
      DeleteLocalInt(oNPC,"nPWChainIndexLow");
      DeleteLocalInt(oNPC,"nGNBASC");
      DeleteLocalFloat(oNPC,"fLastDist");
      DeleteLocalString(oNPC,"sPWTestedJCTs");
} // PWCleanup()

object PWTagFromName(string sName)
{ // PW sbr to find JCT, ADD or GAT object tag
  // Peak 6/03/10
  int nN;
  int nI=3;
  string sType="JCT";
  object oMe=OBJECT_SELF;
  object oTarget;
  while(nI)
  { // scan for Type
    nN=1;
    oTarget=oMe;
    while(oTarget!=OBJECT_INVALID)
    { // scan for object sName
      oTarget=GetNearestObjectByTag("PW_"+sType,oMe,nN);
      if(GetName(oTarget)==sName) return oTarget;
      nN++;
    } // scan for object sName
    nI--;
    if(nI==2) sType="ADD";
    else sType="GAT";
  } // scan for Type
  oTarget=GetLocalObject(oMe,"oPWLastFinal");
  DebugMove("No Tag from name found, cleanup from PWTagFromName");
  PWCleanup(GetLocalInt(oMe,"nPWChainIndexLow"),GetLocalInt(oMe,"nPWChainIndexHigh"));
  return oTarget;
} // PWTagFromName()

int PWGetMap(string sDest)
{ // find map with sDest
  // supports Pathways Peak 6/26/10
  DebugMove("PWGetMap sDest "+sDest);
  int nN=1;
  object oPathways=GetNearestObjectByTag("PW_Pathways");
  string sMap=GetLocalString(oPathways,"sPathway01");
  string sd=".";
  string sFirst, sStub;
  while (sMap!="")
  { // obtain map
    sFirst=StringParse(sMap,sd,TRUE);
    sStub=StringRemoveParsed(sMap,sFirst,sd,TRUE);
    sFirst=StringParse(sStub,sd);
    sStub=StringRemoveParsed(sStub,sFirst,sd);
    while(sStub!="")
    { // find address
      sFirst=StringParse(sStub,sd);
      if(sFirst==sDest) // found ADDress on Map(nN)
        return nN;
      sStub=StringRemoveParsed(sStub,sFirst,sd);
    } // find address
    nN++;
    sMap=GetLocalString(oPathways,"sPathway"+fnPadTheNum(nN));
  } // obtain map
  return 0; // failure
} // PWGetMap()

object fnPathways(object oNPC, object oFinalDest, float fRange=1.0)
{ // move along roads and paths, returns interim destination object for fnMoveToDestination
  // (c)copyright Peter D. Busby 6/14/10 - usual caveat, free use with acknowledgement, commercial use requires a license.
  // Not called if bPWDoNOtUsePW is set on oNPC. Non-civilized creatures won't use normally (unless following NPC)
  // Called if nPWUsePathways is set on Area or oNPC
  // Given: Waypoints tagged PW_ADD, PW_GAT, PW_JCT, PW_BAR. All but the last carry exclusive names
/* Added Pathways, using PW_... waypoints: PW_ADD (_GAT), _JCT (_END), _BAR
   Waypoint PW_Pathways, located in Area, holds map as variables in form of
   sPathway##,string,"JCTName.ADDName.ADDName.JCTName" where JCT may be END,
   ADD may be GAT, any number of ADDs. ## increments from 01. The Names must be
   exclusive in the Area; 2 JCTs can't directly join each other twice, nor JCT
   to 2 ENDs.  Every point of departure, including near the ends (at an area
   transition, e.g.) is an ADD. The algorithm works by moving to the nearest
   ADDress, finding a shared JunCTion and moving (through other junctions as
   needed), then to the departure ADD and direct to oDestination. Unless moving
   to a specific ADD, movement is away from ENDs. If the nearest
   PW waypoint is a PW_BAR, algorithm moves to nearest GATe, so select GAT
   locations carefully if using a line of BARs: along a river, for instance,
   the GATes would be at or equally beyond each end of the bridge - Peak 5/10 */
// Very effective if roads are transition boxes, specifying slower movement on
// exit, maybe 40%. See slowdown, speedup, speedup_areaexit.
  // Entry states:
  //   First time, anywhere in area, need to find Pathway access point ADD
  //     Check if Pathways needed, already close to oFinalDest
  //     If BAR in way (is closer), go to nearest GATe
  //   Second time, at access point ADD, need to explore map, find junction chain to final dest
  //     Get map, check Jcts: if one is END, drop, otherwise have to check both.
  //     Possible random check of Jcts, using random weighting to exercise wantonness
  //     This requires determining local & final maps, finding chain of Jcts between
  //     In the case of moving to different area, need to find xn point
  //   En route, with map in hand
  //   Arrived at last junction, need to move near final access point
  //   Arrived at final access point, or failsafe, depart direct to oFinalDest
  //   Already close to oFinalDest, proceed direct
  DebugMove("Just entering fnPW with FinalDest: "+GetTag(oFinalDest)+": "+GetName(oFinalDest));
  if(GetLocalInt(oNPC,"bPWDoNotUsePW")) return oFinalDest;
  object oDest=GetLocalObject(oNPC,"oPWLastFinal"); // @ (stowed by) local
  string sS;
  string sChain=GetLocalString(oNPC,"sPWChain");
  string sd=".";
  if(oDest==oFinalDest)
  { // in Pathway
    DeleteLocalFloat(oNPC,"fLastDist");
    if(sChain!="**PW_Chain_Init_Flag**")
    { // following Chain
      if(sChain!="")
      { // en route :: Phase 3
        DebugMove("en route, Phase 3, Chain "+sChain);
        sS=StringParse(sChain,sd);
        sChain=StringRemoveParsed(sChain,sS,sd);
        SetLocalString(oNPC,"sPWChain",sChain);
        oDest=PWTagFromName(sS);
        return oDest;
      } // en route
      // arrived :: Phase 4
      DebugMove("arrived, Phase 4");
      PWCleanup(1,0);
      return oFinalDest;
    } // following Chain
  } // in Pathway
  // reset
  SetLocalObject(oNPC,"oPWLastFinal",oFinalDest);
  int nN, nI, nChainIndexLow, nChainIndexHigh;
  string sFinalADD, sLocalMap, sFinalMap, sDest, sMap, sFirst, sStub, sTestedJCTs;
  string sLocalADD=GetLocalString(oNPC,"sPWLocalADD"); // @local
  DeleteLocalString(oNPC,"sPWLocalADD");
  object oFinalADD, oBar;
  if(sLocalADD!="")
  { // first point en route :: Phase 2
    DebugMove("first point, Phase 2");
    SetLocalInt(oNPC,"nGNBDisabled",1);
    SetLocalString(oNPC,"sPWChain","");
    int nI=2;
    object oPathways=GetNearestObjectByTag("PW_Pathways");
    object oXnDest=oDest;
    sDest=sLocalADD;
    while(nI)
    { // get address maps for oNPC and oFinalDest
      if(nI==1)
      { // get local object for oFinalDest
        sLocalMap=sFinalMap;
        if(GetArea(oNPC)!=GetArea(oFinalDest))
        { // find transition object
          // different area - Deva's work
          DebugMove("fnPW mapping different area");
          oXnDest=OBJECT_INVALID;
          // accurate pathing
          nN=1;
          object oT=GetNearestObject(OBJECT_TYPE_TRIGGER,oNPC,1);
          object oD=GetNearestObject(OBJECT_TYPE_DOOR,oNPC,1);
          while(oXnDest==OBJECT_INVALID&&(oT!=OBJECT_INVALID||oD!=OBJECT_INVALID))
          { // look for nearest transition
            if (oT!=OBJECT_INVALID)
            { // trigger found
              if (GetTransitionTarget(oT)!=OBJECT_INVALID)
              { // transition found
                if (GetArea(GetTransitionTarget(oT))==GetArea(oFinalDest))
                { // same area
                  oXnDest=oT;
                } // same area
              } // transition found
            } // trigger found
            if (oD!=OBJECT_INVALID&&(oXnDest==OBJECT_INVALID||GetDistanceBetween(oT,oNPC)>GetDistanceBetween(oD,oNPC)))
            { // door found
              if (GetTransitionTarget(oD)!=OBJECT_INVALID)
              { // transition found
                if (GetArea(GetTransitionTarget(oD))==GetArea(oFinalDest))
                { // same area
                  oXnDest=oD;
                } // same area
              } // transition found
            } // door found
            nN++;
            oT=GetNearestObject(OBJECT_TYPE_TRIGGER,oNPC,nN);
            oD=GetNearestObject(OBJECT_TYPE_DOOR,oNPC,nN);
          } // look for nearest transition
          // accurate pathing
          if (oXnDest==OBJECT_INVALID)
          { // error
            DebugMove("Pathways map error: Can't find a transition. Cleanup");
            PWCleanup(1,0);
            DeleteLocalInt(oNPC,"nGNBDisabled");
            return oFinalDest;
          } // error
        } // find transition object
        oDest=GetNearestObjectByTag("PW_ADD",oXnDest);
        oBar=GetNearestObjectByTag("PW_BAR",oXnDest);
        if(oBar!=OBJECT_INVALID&&GetDistanceBetween(oXnDest,oBar)<GetDistanceBetween(oXnDest,oDest))
          oDest=GetNearestObjectByTag("PW_GAT",oXnDest);
        sFinalADD=GetName(oDest);
        SetLocalString(oNPC,"sPWFinalADD",sFinalADD);
        oFinalADD=oDest;
        sDest=sFinalADD;
      } // get local object for oFinalDest
      nN=PWGetMap(sDest);
      sFinalMap=GetLocalString(oPathways,"sPathway"+fnPadTheNum(nN));
      if(sFinalMap=="")
        DebugMove("Pathways map error: can't find ADDress");
      nI--;
    } // get address maps for oNPC and oFinalDest
    DebugMove("maps: "+sLocalMap+", "+sFinalMap);
    if(sFinalMap!=""&&sLocalMap==sFinalMap)
    { // on same street
      DebugMove("on same street");
      if(GetDistanceBetween(oXnDest,oFinalADD)+fRange*3>GetDistanceBetween(oNPC,oXnDest))
      { // collect $200...
        PWCleanup(1,0);
        DeleteLocalInt(oNPC,"nGNBDisabled");
        return oFinalDest;
      } // direct to transition
      SetLocalString(oNPC,"sPWChain",sFinalADD);
      DeleteLocalInt(oNPC,"nGNBDisabled");
      return oFinalADD;
    } // on same street
    string sJunction=StringParse(sFinalMap,sd);
//    if(sJunction==sS) sS="retrace";
    if(sJunction!="END") SetLocalString(oNPC,"sPWFinalJCT1",sJunction);
    sJunction=StringParse(sFinalMap,sd,TRUE);
//    if((sJunction==sS||sS=="retrace")&&GetLocalInt(oNPC,"bPWHabitual"))
/*    { // retrace path - may be a future enhancement - Peak
      DebugMove("Retracing habitual path.");
      sS=GetLocalString(oNPC,"sPWChain");
      while(sS!="")
      { // reverse route
        sJunction=StringParse(sS,sd,TRUE);
        sS=StringRemoveParsed(sS,sJunction,sd,TRUE);
      } // reverse route
      SetLocalString(oNPC,"sPWChain",sJunction+sFinalADD);
        DeleteLocalString(oNPC,"sPWFinalJCT1");
        oDest=PWTagFromName(StringParse(sChain,sd));
        return oDest;
      } // retrace path */
    if(sJunction!="END") SetLocalString(oNPC,"sPWFinalJCT2",sJunction);
    nChainIndexLow=1;
    nChainIndexHigh=1;
    sJunction=StringParse(sLocalMap,sd);
    sTestedJCTs=sJunction+"|"+StringParse(sLocalMap,sd,TRUE);
    if(sJunction!="END")
    { // start JCT chains
      nChainIndexHigh=1;
      SetLocalString(oNPC,"sPWChain1",sJunction);
      DebugMove("sPWChain01: "+sJunction);
    } // start JCT chains
    sJunction=StringParse(sLocalMap,sd,TRUE);
    if(sJunction!="END")
    { // start JCT chains
      nChainIndexHigh++;
      SetLocalString(oNPC,"sPWChain"+IntToString(nChainIndexHigh),sJunction);
      DebugMove("sPWChain"+IntToString(nChainIndexHigh)+": "+sJunction);
    } // start JCT chains
    SetLocalString(oNPC,"sPWTestedJCTs",sTestedJCTs);
    if(GetLocalString(oNPC,"sPWMapIdx")=="")
    { // mix maps
      string sIdx="";
      nN=1;
      sMap=GetLocalString(oPathways,"sPathway01");
      while(sMap!="")
      { // build initial index
        sIdx=sIdx+fnPadTheNum(nN);
        nN++;
        sMap=GetLocalString(oPathways,"sPathway"+fnPadTheNum(nN));
      } // build initial index
      sS=GetLocalString(oNPC,"sPWAvoidAddress");
      nN=0;
      if(sS!="")
      { // last street for avoiding
        nN=PWGetMap(sS);
        if(nN)
          sIdx=GetStringLeft(sIdx,nN*2-2)+GetStringRight(sIdx,GetStringLength(sIdx)-nN*2);
          SetLocalString(oNPC,"sPWMapIdx",fnPadTheNum(nN));
      } // last street for avoiding
      int nHabit=GetLocalInt(oNPC,"nPWHabitual"); // 1=rigid, 7=chaotic
      if(nHabit<1||nHabit>9) nHabit=4;
      string sMapIdx=sIdx;
      nN=1;
      while(nN<nHabit)
      { // resort maps
        sMapIdx="";
        while(sIdx!="")
        { // random shifts
          if(GetStringLength(sIdx)>2) nI=d2();
          else nI=1;
          sMapIdx=sMapIdx+GetSubString(sIdx,nI*2-2,2);
          sIdx=GetStringLeft(sIdx,nI*2-2)+GetStringRight(sIdx,GetStringLength(sIdx)-nI*2);
        } // random shifts
        sIdx=sMapIdx;
        nN++;
      } // resort maps
      SetLocalString(oNPC,"sPWMapIdx",sMapIdx+GetLocalString(oNPC,"sPWMapIdx"));
    } // mix maps
    int nIndex=1;
    while(nIndex)
    { // find route using haphazard or habitual choices
      if(nChainIndexHigh>nChainIndexLow)
      { // select local JCT
        int nChoose=d2()-1;
//        if(nChoose)
//          nChoose=d2()-1; // increase probability of selecting 1st JCT
        if(nChoose&&GetLocalInt(oNPC,"nPWHabitual"))
          nChoose=d2()-1;
        nIndex=nChainIndexLow;
        if(nChoose)
          nIndex=nChainIndexHigh;
        if(nChoose) nChainIndexHigh--;
        else nChainIndexLow++;
        DebugMove("choose L H "+IntToString(nChoose)+" "+IntToString(nChainIndexLow)+" "+IntToString(nChainIndexHigh));
      } // select local JCT
      else nChainIndexHigh--;
      sJunction=GetLocalString(oNPC,"sPWChain"+IntToString(nIndex));
      DeleteLocalString(oNPC,"sPWChain"+IntToString(nIndex));
      DebugMove("Chain indices L H sJunction: "+IntToString(nChainIndexLow)+" "+IntToString(nChainIndexHigh)+" "+sJunction);
      nIndex=nChainIndexHigh;
      nIndex=PWTestJCTs(oNPC,sJunction,nIndex);
      DebugMove("PWTestJCTs returned "+IntToString(nIndex));
      if(nIndex<0)
      { // avoided address
        nIndex=-nIndex+1;
        SetLocalString(oNPC,"sPWChain"+IntToString(nIndex),sJunction);
        DebugMove("if NIndex: sPWChain("+IntToString(nIndex)+") "+sJunction);
      } // avoided address
      nChainIndexHigh=nIndex;
      DeleteLocalString(oNPC,"sPWLocalADD");
    } // find route
    PWCleanup(nChainIndexLow,nChainIndexHigh);
    sChain=GetLocalString(oNPC,"sPWChain");
    oDest=PWTagFromName(StringParse(sChain,sd));
    DebugMove("YES, Going to: "+GetName(oDest)+". Chain: "+sChain);
    DeleteLocalInt(oNPC,"nGNBDisabled");
    DeleteLocalFloat(oNPC,"fLastDist");
    return oDest;
  } // first point en route
  DebugMove("init, Phase 1");
  oDest=GetNearestObjectByTag("PW_ADD"); // :: Phase 1
  oBar=GetNearestObjectByTag("PW_BAR");
  if(oBar!=OBJECT_INVALID&&GetDistanceBetween(oNPC,oBar)<GetDistanceBetween(oNPC,oDest)) oDest=oBar;
  if(GetDistanceBetween(oNPC,oFinalDest)<GetDistanceBetween(oNPC,oDest)+fRange||oDest==OBJECT_INVALID)
  { // no Pathway needed, collect $200...
    if(oDest==OBJECT_INVALID) DebugMove("No Pathways ADDress found or needed. Cleanup");
    PWCleanup(nChainIndexLow,nChainIndexHigh);
    return oFinalDest;
  } // no Pathway needed
  if(GetTag(oDest)=="PW_BAR") // can't go that way
    oDest=GetNearestObjectByTag("PW_GAT");
  SetLocalString(oNPC,"sPWLocalADD",GetName(oDest));
  SetLocalString(oNPC,"sPWChain","**PW_Chain_Init_Flag**");
  return oDest;
} // fnPathways()

int fnMoveToDestination(object oNPC,object oDest,float fRange=1.0)
{ // PURPOSE: Version 3.0 of the fnMoveToDestination function
  // original by Deva, rewritten 5/10 Peak, last modified 6/14/10 Peak
  // VARIABLES:
  // On Module:
  // bGNBAccuratePathing if set to 1 will always try to get nearby transition
  // ========
  // On Area:
  // nPWUsePathways if set to 1, NPCs will use specified routes (roads, paths)
  // ========
  // On NPC:
  // bGNBAccuratePathing if set to 1 will always try to get nearby transition
  // nPWUsePathways if set to 1, will use specified routes, address to address
  // bPWDoNotUsePW if set to 1 (TRUE), will not use Pathways
  // bGNBQuickMove  if set to 1 will use jump and such to move NPCs when no PCs
  //                are around to witness it.
  // ========
  DebugMove("Entering fnMTD, checking movement to dest "+GetTag(oDest)+": "+GetName(oDest));
  //DebugMove("oDest=oMTDLastDest/oPWLastDest: "+GetTag(oDest)+" = "+GetTag(GetLocalObject(oNPC,"oMTDLastDest"))+" or "+GetTag(GetLocalObject(oNPC,"oPWLastDest")));
  //DebugMove("fLastDist>fRange: "+FloatToString(GetLocalFloat(oNPC,"fLastDist"))+"::"+FloatToString(fRange));
  int nN=0;
  float fDist;
  object oPWLastDest=GetLocalObject(oNPC,"oPWLastDest");
  if(GetArea(oDest)!=GetArea(oNPC)) SetLocalInt(oNPC,"nMTDChangeArea",1);
  else if(GetLocalInt(oNPC,"nMTDChangeArea"))
  { // flag initialization
    DeleteLocalInt(oNPC,"nMTDChangeArea");
    nN=1;
  } // flag initialization
  if(oDest==GetLocalObject(oNPC,"oMTDLastDest")&&!nN)
  { // same Final Dest
    if(oPWLastDest!=OBJECT_INVALID)
      oDest=oPWLastDest;
    fDist=GetDistanceBetween(oNPC,oDest);
    if(oDest==GetLocalObject(oNPC,"oMTDLastDest")||oDest==oPWLastDest)
    { // processing same destination
      if(fDist>fRange+1.0)
      { // not there yet
        if(fnCompareFloats(fDist,GetLocalFloat(oNPC,"fLastDist"),fRange/9)==0)
        { // still moving
          SetLocalFloat(oNPC,"fLastDist",fDist);
          if(GetLocalInt(oNPC,"nGNBStateSpeed")||GetLocalInt(GetModule(),"nGNBStateSpeed"))
          { // reduce State calls whilst moving - Peak 6/10/10
            nN=FloatToInt(fDist/2);
            if(nN>6) nN=6;
            SetLocalInt(oNPC,"nGNBStateSpeed",nN);
          } // reduce State calls whilst moving - Peak 6/10/10
          return 0;
        } // still moving
        // may be stuck
        int bRun=(GetLocalInt(oNPC,"nGNBRun")==1);
        nN=fnHandleStuck(oNPC,oDest,bRun,fRange);
        return nN;
      } // not there yet
      if(oPWLastDest==OBJECT_INVALID)
      { // arrived
        MTDCleanup(oNPC);
        DebugMove("fnMTD: ARRIVED, return 1");
        return 1;
      } // arrived
    } // processing same destination
  } // same Final Dest
  if(oPWLastDest!=OBJECT_INVALID) oDest=GetLocalObject(oNPC,"oMTDLastDest");
  else SetLocalObject(oNPC,"oMTDLastDest",oDest);
  DeleteLocalObject(oNPC,"oPWLastDest");
  if(nN) DeleteLocalObject(oNPC,"oPWLastFinal");
  DebugMove("fnMTD New or new PW destination");
  int nAIL=GetAILevel(oNPC);
  object oPCN=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oNPC,1,CREATURE_TYPE_IS_ALIVE,TRUE);
  object oPCD=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oDest,1,CREATURE_TYPE_IS_ALIVE,TRUE);
  object oTarget=GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,oNPC,1,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
  if (oPCN==OBJECT_INVALID&&oPCD==OBJECT_INVALID&&oTarget==OBJECT_INVALID&&GetLocalInt(oNPC,"bGNBQuickMove")==TRUE)
  { // might be able to take short cut
    if (nAIL!=AI_LEVEL_HIGH&&nAIL!=AI_LEVEL_VERY_HIGH&&nAIL!=AI_LEVEL_NORMAL)
    { // handle no PC present and low AI level
      fDist=GetDistanceBetween(oNPC,oDest);
      if (GetArea(oDest)!=GetArea(oNPC)||fDist>fRange)
      { // fnLowAINoPCMove - used only once thus incorporated - peak
        DebugMove("fnMTD Execute Low-AI and No PC present movement routines");
        float fTime=5.0;
        if (GetLocalInt(oNPC,"bModulePossessed")!=TRUE)
        { // possess
          SetLocalInt(oNPC,"bModulePossessed",TRUE);
          if (GetArea(oDest)==GetArea(oNPC))
          { // same area
            fTime=fTime+(fDist/3.0);
            DelayCommand(fTime,fnJumpNPC(oNPC,oDest,fRange));
          } // same area
          else
          { // different area
            DelayCommand(60.0,fnJumpNPC(oNPC,oDest,fRange));
          } // different area
        } // possess
        return 0;
      } // move
      // arrived
      MTDCleanup(oNPC);
      return 1;
    } // handle no PC present and low AI level
  } // might be able to take short cut
  int nGRun=GetLocalInt(oNPC,"nGNBRun");
  if (nGRun<5)
  { // no instant movement
    if ((GetLocalInt(GetArea(oNPC),"nPWUsePathways")&&(GetAnimationCondition(NW_ANIM_FLAG_IS_CIVILIZED))||GetLocalInt(oNPC,"nPWUsePathways")))
    { // use Pathways to follow roads/paths/shortcuts, avoid water/muck/taboos
      DebugMove("fnMTD going to fnPathways with oDestTag: "+GetTag(oDest)+" PWFinalDest: "+GetTag(GetLocalObject(oNPC,"oPWFinalDest")));
      oTarget=oDest;
      oDest=fnPathways(oNPC,oDest,fRange); // get interim destination
      if(oDest!=oTarget) SetLocalObject(oNPC,"oPWLastDest",oDest);
      DebugMove("fnMTD: fnPathways returned oDest: "+GetTag(oDest)+": "+GetName(oDest));
    } // use Pathways
    DebugMove("fnMTD oDest: "+GetTag(oDest)+": "+GetName(oDest));
    if (GetArea(oNPC)==GetArea(oDest))
    { // NPC is in the same area as the destination
      DebugMove("fnMTD Same Area");
      int bRun=(nGRun==1); // flags: 1=run, 2=stealth, 3=detect, 4=both latter
      if (nGRun<2)
      { // no stealth or search
        SetActionMode(oNPC,ACTION_MODE_DETECT,FALSE);
        SetActionMode(oNPC,ACTION_MODE_STEALTH,FALSE);
      } // no stealth or search
      else if (nGRun==2||nGRun==4)
      { // hide
        SetActionMode(oNPC,ACTION_MODE_STEALTH,TRUE);
      } // hide
      if (nGRun>2)
      { // search
        SetActionMode(oNPC,ACTION_MODE_DETECT,TRUE);
      } // search
      SetLocalFloat(oNPC,"fLastDist",GetDistanceBetween(oNPC,oDest));
      AssignCommand(oNPC,ClearAllActions());
      AssignCommand(oNPC,ActionMoveToObject(oDest,bRun,fRange));
      DebugMove("fnMTD Same area move complete");
      return 0;
    } // NPC is in the same area as the destination
    // different area
    DebugMove("fnMTD Different Area, PWCleanup");
    PWCleanup(1,0);
    int bRun=(nGRun==1);
    oTarget=OBJECT_INVALID;
    object oT=OBJECT_INVALID;
    object oD=OBJECT_INVALID;
    if(GetLocalInt(GetModule(),"bGNBAccuratePathing")||GetLocalInt(oNPC,"bGNBAccuratePathing")||GetLocalInt(GetArea(oDest),"nPWUsePathways")||GetLocalInt(oNPC,"nPWUsePathways"))
    { // accurate pathing
      nN=1;
      oT=GetNearestObject(OBJECT_TYPE_TRIGGER,oNPC,01);
      oD=GetNearestObject(OBJECT_TYPE_DOOR,oNPC,01);
      while(oTarget==OBJECT_INVALID&&(oT!=OBJECT_INVALID||oD!=OBJECT_INVALID))
      { // look for nearest transition
        if (oT!=OBJECT_INVALID)
        { // trigger found
          if (GetTransitionTarget(oT)!=OBJECT_INVALID)
          { // transition found
            if (GetArea(GetTransitionTarget(oT))==GetArea(oDest))
            { // same area
              oTarget=oT;
            } // same area
          } // transition found
        } // trigger found
        if (oD!=OBJECT_INVALID&&(GetDistanceBetween(oT,oNPC)<GetDistanceBetween(oD,oNPC)||oTarget==OBJECT_INVALID))
        { // door found
          if (GetTransitionTarget(oD)!=OBJECT_INVALID)
          { // transition found
            if (GetArea(GetTransitionTarget(oD))==GetArea(oDest))
            { // same area
              oTarget=oD;
            } // same area
          } // transition found
        } // door found
        nN++;
        oT=GetNearestObject(OBJECT_TYPE_TRIGGER,oNPC,nN);
        oD=GetNearestObject(OBJECT_TYPE_DOOR,oNPC,nN);
      } // look for nearest transition
    } // accurate pathing
    if (oTarget==OBJECT_INVALID)
    { // long distance pathing
      DebugMove("fnMTD Long Distance Pathing");
      oTarget=GetLocalObject(oNPC,"oGNBNearbyObject");
      if (oTarget==OBJECT_INVALID||GetArea(oTarget)!=GetArea(oNPC))
      { // find nearby object
        oTarget=GetNearestObject(OBJECT_TYPE_WAYPOINT,oNPC,1);
        if (oTarget==OBJECT_INVALID) oTarget=GetNearestObject(OBJECT_TYPE_PLACEABLE,oNPC,1);
        if (oTarget==OBJECT_INVALID) oTarget=GetNearestObject(OBJECT_TYPE_DOOR,oNPC,1);
        if (oTarget==OBJECT_INVALID) oTarget=GetNearestObject(OBJECT_TYPE_TRIGGER,oNPC,1);
        if (oTarget!=OBJECT_INVALID)
          SetLocalObject(oNPC,"oGNBNearbyObject",oTarget);
        else
        { // no transition exists to leave area
          MTDCleanup(oNPC);
          return -1;
        } // no transition
      } // find nearby object
      DeleteLocalFloat(oNPC,"fLastDist");
      AssignCommand(oNPC,ClearAllActions());
      AssignCommand(oNPC,ActionMoveToObject(oDest,bRun,fRange));
      return 0;
    } // long distance pathing
    // use nearest transition
    DebugMove("fnMTD Use nearby transition");
    if (GetDistanceBetween(oNPC,oTarget)<=1.5)
    { // arrived at transition
      AssignCommand(oNPC,ClearAllActions());
      if (GetObjectType(oTarget)==OBJECT_TYPE_DOOR&&GetIsOpen(oTarget)==FALSE)
      { // face and open door
        AssignCommand(oNPC,ActionOpenDoor(oTarget));
        if (GetObjectType(GetTransitionTarget(oTarget))==OBJECT_TYPE_DOOR)
          AssignCommand(GetTransitionTarget(oTarget),ActionOpenDoor(oTarget));
      } // face and open door
      oTarget=GetTransitionTarget(oTarget);
      oPCN=GetNearestObject(OBJECT_TYPE_WAYPOINT,oTarget,1);
      if (oPCN==OBJECT_INVALID) oPCN=GetNearestObject(OBJECT_TYPE_PLACEABLE,oTarget,1);
      if (oPCN==OBJECT_INVALID) oPCN=oTarget;
      DeleteLocalFloat(oNPC,"fLastDist");
      AssignCommand(oNPC,JumpToObject(oPCN));
      return 0;
    } // arrived at transition
    // move to nearby transition
    SetLocalFloat(oNPC,"fLastDist",GetDistanceBetween(oNPC,oTarget));
    AssignCommand(oNPC,ActionMoveToObject(oDest,bRun,fRange));
    return 0;
  } // no instant movement
  // teleport like movement
  int nASC=GetLocalInt(oNPC,"nGNBASC");
  int nASR=GetLocalInt(oNPC,"nGNBASR");
  effect eEff;
  DebugMove("fnMTD Teleport Style Movement");
  if (nASR==0)
  { // do teleport
    AssignCommand(oNPC,ClearAllActions(TRUE));
    if (nGRun==5) { AssignCommand(oNPC,JumpToObject(oDest)); }
    else if (nGRun==6)
    { // teleport w/ VFX
      eEff=EffectVisualEffect(VFX_FNF_IMPLOSION);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eEff,GetLocation(oNPC),3.0);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eEff,GetLocation(oDest),3.0);
      DelayCommand(0.8,AssignCommand(oNPC,JumpToObject(oDest)));
    } // teleport w/ VFX
    else if (nGRun==7)
    { // fly out and then in
      eEff=EffectDisappearAppear(GetLocation(oDest),1);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEff,oNPC,4.0);
    } // fly out and then in
    else if (nGRun==8)
    { // custom VFX teleport
      nN=GetLocalInt(oNPC,"nGNBEDepart");
      eEff=EffectVisualEffect(nN);
      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eEff,GetLocation(oNPC),4.0);
      nN=GetLocalInt(oNPC,"nGNBEAppear");
      eEff=EffectVisualEffect(nN);
      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eEff,GetLocation(oDest),4.0);
      DelayCommand(2.5,AssignCommand(oNPC,JumpToObject(oDest)));
    } // custom VFX teleport
    SetLocalInt(oNPC,"nGNBASR",1);
  } // do teleport
  else if (nASR==1)
  { // effect called, waiting
    nASC++;
    if (GetArea(oDest)==GetArea(oNPC)&&GetDistanceBetween(oDest,oNPC)<=fRange)
    { // arrived
      MTDCleanup(oNPC);
      return 1;
    } // arrived
    else if (nASC>4)
    { // did not arrive
      MTDCleanup(oNPC);
      return -1;
    } // did not arrive
    SetLocalInt(oNPC,"nGNBASC",nASC);
  } // effect called
  return 0;
} // fnMoveToDestination()

//void main(){} //comment out after compile, then save
