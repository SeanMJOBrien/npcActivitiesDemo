////////////////////////////////////////////////////////////////////////////////
// lib_nais_move - Movement Library Functions
// By Deva B. Winblood. 04/09/2007
////////////////////////////////////////////////////////////////////////////////
/* MOVEMENT PLANS THIS MODULE SUPPORTS
   ===================================
   op_ to non-op_ areas = _ILLEGAL
   non-syl to syl_ areas with no sylvan pendant = _NOKEY
   Placeable with tag DOORWAY is a placeable door.  Destination waypoint tag
   stored on it as sDestTag.  If the door requires a key it is sKeyTag.
   PORTAL_TREE has nInventoryID which leads to SYL_PORTAL_# which requires
   syl_pendant item to access.
*/
////////////////////////////////////////////////////////////////////////////////

#include "lib_nais_path"
#include "lib_nais_tool"

//////////////////////////////////
// CONSTANTS
//////////////////////////////////

const int   MOVE_RESULT_SUCCESS       = 1; // Destination Reached
const int   MOVE_RESULT_UNKNOWN       = 0; // Still Moving
const int   MOVE_RESULT_UNREACHABLE   = -1;// Could not reach destination
const int   MOVE_RESULT_ILLEGAL       = -2;// Illegal destination
const int   MOVE_RESULT_NOKEY         = -3;// Lack Key
const int   MOVE_RESULT_TIMEOUT       = -4;// Movement Time Out
const int   MOVE_ROUTE_UNSPECIFIED    = 0; // Whatever works the best
const int   MOVE_ROUTE_SURFACE        = 1; // Prefer surface routes
const int   MOVE_ROUTE_SUBSURFACE     = 2; // Prefer underground routes
const int   MOVE_ROUTE_RANDOM         = 3; // Not always the best route


//////////////////////////////////
// PROTOTYPES
//////////////////////////////////


// FILE: lib_nais_move              FUNCTION: Move_GetNearestDestination()
// This will return the nearest transition object to oCreature that will lead
// them to oFinalDestination by the specified route.
object Move_GetNearestDestination(object oCreature,object oFinalDestination,int nRoute=MOVE_ROUTE_UNSPECIFIED);

// FILE: lib_nais_move              FUNCTION: Move_GetMoveLegal()
// This will check to see if moving to oFinalDestination is even legal based
// on oCreatures current status.   It will return MOVE_RESULT_.  If it is a
// _UNREACHABLE, _ILLEGAL, _NOKEY, or _TIMEOUT then it is not a legal move.
int Move_GetMoveLegal(object oCreature,object oFinalDestination);

// FILE: lib_nais_move              FUNCTION: Move_MoveToDestination()
// This function will move oCreature to oFinalDestination by the specified route
// until they are within fRange.  If it gets stuck timeout will be decremented
// by 1.  This function will return MOVE_RESULT_.  It will return _SUCCESS if
// destination is reached, _UNKNOWN if still moving, _UNREACHABLE, or _TIMEOUT.
int Move_MoveToDestination(object oCreature,object oFinalDestination,float fRange=5.0,int nRoute=MOVE_ROUTE_UNSPECIFIED,int nTimeOut=3);


// FILE: lib_nais_move              FUNCTION: Move_ActionMoveToObject()
// This is a replacement for the standard ActionMoveToObject() which has some
// very basic anti-stuck routines.
void Move_ActionMoveToObject(object oDestination,int bRun=FALSE,float fRange=1.0);


//////////////////////////////////
// FUNCTIONS
//////////////////////////////////



void Move_ActionMoveToObject(object oDestination,int bRun=FALSE,float fRange=1.0)
{ // PURPOSE: ActionMoveToObject() replacement with minor anti-stuck
    object oMe=OBJECT_SELF;
    object oPrev=GetLocalObject(oMe,"oPrevDest");
    float fLast=GetLocalFloat(oMe,"fLastDist");
    float fCur=GetDistanceBetween(oMe,oDestination);
    object oOb;
    if (oPrev!=oDestination)
    { // new destination
        AssignCommand(oMe,ClearAllActions());
        AssignCommand(oMe,ActionMoveToObject(oDestination,bRun,fRange));
        SetLocalObject(oMe,"oPrevDest",oDestination);
        SetLocalFloat(oMe,"fLastDist",fCur);
    } // new destination
    else
    { // same destination
        if (fLast==fCur)
        { // stuck
            oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oMe,d20());
            if (!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oMe,d20());
            if (!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oMe,d20());
            if (!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oMe,d4());
            if (GetIsObjectValid(oOb))
            { // move towards arbitrary point to try and get unstuck
                AssignCommand(oMe,ClearAllActions());
                AssignCommand(oMe,ActionMoveToObject(oOb,TRUE,1.0));
            } // move towards arbitrary point to try and get unstuck
        } // stuck
        else
        { // not stuck
            AssignCommand(oMe,ClearAllActions());
            AssignCommand(oMe,ActionMoveToObject(oDestination,bRun,fRange));
            SetLocalFloat(oMe,"fLastDist",fCur);
        } // not stuck
    } // same destination
} // Move_ActionMoveToObject()



object fnFind_NearestPortalTree(object oLocation)
{ // PURPOSE: Return the portal tree that is the nearest choices to use
    object oRet=OBJECT_INVALID;
    int nN=0;
    int nD=999;
    int nR;
    object oBest=OBJECT_INVALID;
    object oOb;
    oOb=GetObjectByTag("PORTAL_TREE",nN);
    while(GetIsObjectValid(oOb))
    { // find best
        nR=Path_GetDistanceBetween(GetArea(oOb),GetArea(oLocation));
        if (nR<nD)
        { // new destination
            oBest=oOb;
            nD=nR;
        } // new destination
        nN++;
        oOb=GetObjectByTag("PORTAL_TREE",nN);
    } // find best
    if (GetIsObjectValid(oBest)) oRet=oBest;
    return oRet;
} // fnFind_NearestPortalTree()


object Move_GetNearestDestination(object oCreature,object oFinalDestination,int nRoute=MOVE_ROUTE_UNSPECIFIED)
{ // PURPOSE: Get Nearest Transition object
    object oRet=OBJECT_INVALID;
    string sSourceTag;
    string sDestTag;
    object oSourceArea;
    object oDestArea;
    int nN;
    int nR;
    int nD;
    string sS;
    object oBest;
    object oOb;
    string sPreS;
    string sPreD;
    string sPostS;
    string sPostD;
    if (GetIsObjectValid(oCreature)&&GetIsObjectValid(oFinalDestination))
    { // valid parameters
        oSourceArea=GetArea(oCreature);
        oDestArea=GetArea(oFinalDestination);
        sSourceTag=GetTag(oSourceArea);
        sDestTag=GetTag(oDestArea);
        if (oSourceArea==oDestArea) oRet=oFinalDestination;
        else
        { // other
            sPreS=lib_ParseString(sSourceTag,"_");
            sPostS=lib_RemoveParsed(sSourceTag,sPreS,"_");
            sPreD=lib_ParseString(sDestTag,"_");
            sPostD=lib_RemoveParsed(sDestTag,sPreD,"_");
            if (sPostS=="syl"&&sPostD!="syl")
            { // travel from sylvan
                oOb=fnFind_NearestPortalTree(oFinalDestination);
                if (oOb!=OBJECT_INVALID)
                { // known
                    nN=GetLocalInt(oOb,"nInventoryID");
                    oRet=GetWaypointByTag("SYL_PORTAL_"+IntToString(nN));
                } // known
            } // travel from sylvan
            else if (sPostS!="syl"&&sPostD=="syl")
            { // travel to sylvan
                oRet=fnFind_NearestPortalTree(oCreature);
            } // travel to sylvan
            else
            { // check for placeable with direct link
                nN=1;
                oBest=OBJECT_INVALID;
                oOb=GetNearestObjectByTag("DOORWAY",oCreature,nN);
                while(GetIsObjectValid(oOb))
                { // check for placeable door
                    sS=GetLocalString(oOb,"sDestTag");
                    if (GetStringLength(sS)>0)
                    { // doorway
                        oBest=GetWaypointByTag(sS);
                        if (GetArea(oBest)==GetArea(oFinalDestination))
                        { // valid
                            return oOb;
                        } // valid
                    } // doorway
                    nN++;
                    oOb=GetNearestObjectByTag("DOORWAY",oCreature,nN);
                } // check for placeable door
                // Placeable not linked
                if (nRoute==MOVE_ROUTE_UNSPECIFIED) return Path_GetQuickestTransition(oSourceArea,oDestArea);
                else if (nRoute==MOVE_ROUTE_SURFACE)
                { // surface
                    oBest=Path_GetQuickestTransition(oSourceArea,oDestArea);
                    nN=FALSE;
                    oOb=GetTransitionTarget(oBest);
                    if (GetIsObjectValid(oOb))
                    { // is transition
                        if (GetIsAreaAboveGround(GetArea(oOb))||GetIsAreaInterior(GetArea(oOb))) nN=TRUE;
                    } // is transition
                    else
                    { // check for sDestTag
                        sS=GetLocalString(oBest,"sDestTag");
                        oOb=GetWaypointByTag(sS);
                        if (GetIsObjectValid(oOb))
                        { // waypoint exists
                            if (GetIsAreaAboveGround(GetArea(oOb))||GetIsAreaInterior(GetArea(oOb))) nN=TRUE;
                        } // waypoint exists
                    } // check for sDestTag
                    if (nN)
                    { // best destination is surface
                        return oBest;
                    } // best destination is surface
                    else
                    { // best destination is below ground
                    } // best destination is below ground
                } // surface
                else if (nRoute==MOVE_ROUTE_SUBSURFACE)
                { // subsurface
                    oBest=Path_GetQuickestTransition(oSourceArea,oDestArea);
                    nN=FALSE;
                    oOb=GetTransitionTarget(oBest);
                    if (GetIsObjectValid(oOb))
                    { // is transition
                        if (!GetIsAreaAboveGround(GetArea(oOb))||GetIsAreaInterior(GetArea(oOb))) nN=TRUE;
                    } // is transition
                    else
                    { // check for sDestTag
                        sS=GetLocalString(oBest,"sDestTag");
                        oOb=GetWaypointByTag(sS);
                        if (GetIsObjectValid(oOb))
                        { // waypoint exists
                            if (!GetIsAreaAboveGround(GetArea(oOb))||GetIsAreaInterior(GetArea(oOb))) nN=TRUE;
                        } // waypoint exists
                    } // check for sDestTag
                    if (nN)
                    { // best destination is below ground
                        return oBest;
                    } // best destination is below ground
                    else
                    { // best destination is surface
                    } // best destination is surface
                } // subsurface
                else
                { // random
                    nR=d100();
                    if (nR<34) return Path_GetQuickestTransition(oSourceArea,oDestArea);
                    else
                    { // random exit
                        nN=1;
                        oOb=GetNearestObject(OBJECT_TYPE_TRIGGER,oCreature,nN);
                        while(GetIsObjectValid(oOb))
                        { // find trigger
                            oBest=GetTransitionTarget(oOb);
                            if (GetIsObjectValid(oBest)&&d100()<11) return oOb;
                            nN++;
                            oOb=GetNearestObject(OBJECT_TYPE_TRIGGER,oCreature,nN);
                        } // find trigger
                        nN=1;
                        oOb=GetNearestObject(OBJECT_TYPE_DOOR,oCreature,nN);
                        while(GetIsObjectValid(oOb))
                        { // find door
                            oBest=GetTransitionTarget(oOb);
                            if (GetIsObjectValid(oBest)&&d100()<11) return oOb;
                            nN++;
                            oOb=GetNearestObject(OBJECT_TYPE_DOOR,oCreature,nN);
                        } // find door
                        return Path_GetQuickestTransition(oSourceArea,oDestArea);
                    } // random exit
                } // random
            } // check for placeable with direct link
        } // other
    } // valid parameters
    return oRet;
} // Move_GetNearestDestination()


int Move_GetMoveLegal(object oCreature,object oFinalDestination)
{ // PURPOSE: Is Move Legal
    int nRet=MOVE_RESULT_UNKNOWN;
    string sSourceTag;
    string sDestTag;
    object oSourceArea;
    object oDestArea;
    int nN;
    int nR;
    int nD;
    string sS;
    object oBest;
    object oOb;
    string sPreS;
    string sPreD;
    string sPostS;
    string sPostD;
    if (GetIsObjectValid(oCreature)&&GetIsObjectValid(oFinalDestination))
    { // parameters are valid
        oSourceArea=GetArea(oCreature);
        oDestArea=GetArea(oFinalDestination);
        sSourceTag=GetTag(oSourceArea);
        sDestTag=GetTag(oDestArea);
        sPreS=lib_ParseString(sSourceTag,"_");
        sPostS=lib_RemoveParsed(sSourceTag,sPreS,"_");
        sPreD=lib_ParseString(sDestTag,"_");
        sPostD=lib_RemoveParsed(sDestTag,sPreD,"_");
        if ((sPreS=="op"&&sPreD!="op")||(sPreD=="op"&&sPreS!="op")) return MOVE_RESULT_ILLEGAL;
        oBest=Path_GetQuickestTransition(GetArea(oCreature),GetArea(oFinalDestination));
        if (!GetIsObjectValid(oBest)) return MOVE_RESULT_UNREACHABLE;
        sS=GetLocalString(oBest,"sKeyTag");
        if (GetStringLength(sS)>0)
        { // key required
            oOb=GetItemPossessedBy(oCreature,sS);
            if (!GetIsObjectValid(oOb)) return MOVE_RESULT_NOKEY;
        } // key required
    } // parameters are valid
    return nRet;
} // Move_GetMoveLegal()


void fnMove_Delete(object oCreature)
{ // PURPOSE: To delete the variables
    DeleteLocalInt(oCreature,"nMASCount");
    DeleteLocalInt(oCreature,"nMASReset");
    DeleteLocalFloat(oCreature,"fMLastDist");
    DeleteLocalInt(oCreature,"nCurrMState");
    DeleteLocalInt(oCreature,"nFinalMState");
    DeleteLocalObject(oCreature,"oFinalDest");
    DeleteLocalObject(oCreature,"oCurrDest");
} // fnMove_Delete()


int fnMove_DifferentArea(object oCreature,object oFinalDestination,float fRange=5.0,int nRoute=MOVE_ROUTE_UNSPECIFIED,int nTimeOut=3)
{ // PURPOSE: Different Area Movement
    int nRet=MOVE_RESULT_UNKNOWN;
    object oCurr;
    int nN;
    string sS;
    object oOb;
    float fLF;
    float fF;
    nN=GetLocalInt(oCreature,"nFinalMState");
            if (nN==0)
            { // initialize
                nN=Move_GetMoveLegal(oCreature,oFinalDestination);
                if (nN!=MOVE_RESULT_UNKNOWN)
                { // illegal move
                    fnMove_Delete(oCreature);
                    return nN;
                } // illegal move
                SetLocalInt(oCreature,"nFinalMState",1);
            } // initialize
            oCurr=GetLocalObject(oCreature,"oCurrDest");
            if (!GetIsObjectValid(oCurr))
            { // find transition object
                oCurr=Move_GetNearestDestination(oCreature,oFinalDestination,nRoute);
                if (!GetIsObjectValid(oCurr))
                { // not reachable
                    fnMove_Delete(oCreature);
                    return MOVE_RESULT_UNREACHABLE;
                } // not reachable
                SetLocalObject(oCreature,"oCurrDest",oCurr);
            } // find transition object
            if (GetDistanceBetween(oCreature,oCurr)<3.5)
            { // in range to transition
                DeleteLocalInt(oCreature,"nMASCount");
                DeleteLocalInt(oCreature,"nCurrMState");
                DeleteLocalFloat(oCreature,"fMLastDist");
                AssignCommand(oCreature,ClearAllActions());
                oOb=OBJECT_INVALID;
                if (GetObjectType(oCurr)==OBJECT_TYPE_PLACEABLE)
                { // placeable
                    if (GetTag(oCurr)=="PORTAL_TREE")
                    { // portal
                        nN=GetLocalInt(oCurr,"nInventoryID");
                        oOb=GetWaypointByTag("SYL_PORTAL_"+IntToString(nN));
                    } // portal
                    else
                    { // door
                        sS=GetLocalString(oCurr,"sDestTag");
                        oOb=GetWaypointByTag(sS);
                    } // door
                } // placeable
                else if (GetObjectType(oCurr)==OBJECT_TYPE_DOOR)
                { // door
                    oOb=GetTransitionTarget(oCurr);
                    AssignCommand(oOb,ActionOpenDoor(oOb));
                } // door
                else
                { // trigger
                    oOb=GetTransitionTarget(oCurr);
                } // trigger
                if (GetIsObjectValid(oOb)) AssignCommand(oCreature,JumpToObject(oOb));
            } // in range to transition
            if (TRUE) //else
            { // move
                fLF=GetLocalFloat(oCreature,"fMLastDist");
                fF=GetDistanceBetween(oCreature,oCurr);
                SetLocalFloat(oCreature,"fMLastDist",fF);
                if (fLF==0.0)
                { // first move
                    AssignCommand(oCreature,ClearAllActions());
                    AssignCommand(oCreature,ActionMoveToObject(oCurr,TRUE,1.0));
                } // first move
                else
                { // in motion
                    if (fF==fLF)
                    { // might be stuck
                        nN=GetLocalInt(oCreature,"nMASCount");
                        nN++;
                        SetLocalInt(oCreature,"nMASCount",nN);
                        if (nN==0)
                        { // try moving again
                            AssignCommand(oCreature,ClearAllActions());
                            AssignCommand(oCreature,ActionMoveToObject(oCurr,TRUE,1.0));
                        } // try moving again
                        else if (nN==1)
                        { // try moving away
                            oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,d20());
                            if (!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,d20());
                            if (!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,d10());
                            if (!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,1);
                            if (GetIsObjectValid(oOb))
                            { // move
                                AssignCommand(oCreature,ClearAllActions());
                                AssignCommand(oCreature,ActionMoveToObject(oOb,TRUE,1.0));
                                DelayCommand(6.0,AssignCommand(oCreature,ClearAllActions()));
                                DelayCommand(6.02,AssignCommand(oCreature,ActionMoveToObject(oCurr,TRUE,1.0)));
                            } // move
                        } // try moving away
                        else
                        { // try jumping
                            nN=GetLocalInt(oCreature,"nMASReset");
                            nN++;
                            SetLocalInt(oCreature,"nMASReset",nN);
                            if (nN>=nTimeOut)
                            { // time out
                                fnMove_Delete(oCreature);
                                return MOVE_RESULT_TIMEOUT;
                            } // time out
                            AssignCommand(oCreature,ClearAllActions());
                            AssignCommand(oCreature,JumpToObject(oCurr));
                        } // try jumping
                    } // might be stuck
                    else if (fF<fLF) { DeleteLocalInt(oCreature,"nMASCount"); }
                } // in motion
            } // move
    return nRet;
} // fnMovE_DifferentArea()


int Move_MoveToDestination(object oCreature,object oFinalDestination,float fRange=5.0,int nRoute=MOVE_ROUTE_UNSPECIFIED,int nTimeOut=3)
{ // PURPOSE: To Move to specified destination
  // oFinalDest = Ultimate destination
  // oCurrDest = Current destination
  // nCurrMState = Current destination move state
  // nFinalMState = Final destination move state
  // nMASCount = Anti-Stuck Counter
  // nMASReset = Anti-Stuck resets
  // fMLastDist = Last distance between oCreature, oFinalDest
    int nRet=MOVE_RESULT_UNKNOWN;
    float fF;
    float fLF;
    int nN;
    object oOb;
    object oCurr;
    string sS;
    if (GetIsObjectValid(oCreature)&&GetIsObjectValid(oFinalDestination))
    { // valid parameters
        if (GetArea(oCreature)==GetArea(oFinalDestination))
        { // same area
            if (GetDistanceBetween(oCreature,oFinalDestination)<=fRange)
            { // arrived
                fnMove_Delete(oCreature);
                return MOVE_RESULT_SUCCESS;
            } // arrived
            else
            { // move
                nN=GetLocalInt(oCreature,"nCurrMState");
                if (nN==0)
                { // no move issued
                    AssignCommand(oCreature,ActionMoveToObject(oFinalDestination,TRUE,fRange));
                    SetLocalInt(oCreature,"nCurrMState",1);
                    DeleteLocalInt(oCreature,"nMASCount");
                    fF=GetDistanceBetween(oCreature,oFinalDestination);
                    SetLocalFloat(oCreature,"fMLastDist",fF);
                } // no move issued
                else
                { // move issued
                    fLF=GetLocalFloat(oCreature,"fMLastDist");
                    fF=GetDistanceBetween(oCreature,oFinalDestination);
                    SetLocalFloat(oCreature,"fMLastDist",fF);
                    if (fLF==fF)
                    { // not moving
                        nN=GetLocalInt(oCreature,"nMASCount");
                        nN++;
                        SetLocalInt(oCreature,"nMASCount",nN);
                        if (nN==0)
                        { // move
                            AssignCommand(oCreature,ActionMoveToObject(oFinalDestination,TRUE,fRange));
                        } // move
                        else if (nN==1)
                        { // move to nearby
                            oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,d20());
                            if(!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,d20());
                            if(!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,d10());
                            if(!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,1);
                            AssignCommand(oCreature,ClearAllActions());
                            AssignCommand(oCreature,ActionMoveToObject(oOb,TRUE));
                            DelayCommand(4.0,AssignCommand(oCreature,ClearAllActions()));
                            DelayCommand(4.02,AssignCommand(oCreature,ActionMoveToObject(oFinalDestination,TRUE,fRange)));
                        } // move to nearby
                        else if (nN>4)
                        { // stuck - reset - check for timeout
                            nN=GetLocalInt(oCreature,"nMASReset");
                            nN++;
                            if (nN>=nTimeOut)
                            { // timed out
                                fnMove_Delete(oCreature);
                                return MOVE_RESULT_TIMEOUT;
                            } // timed out
                            else
                            { // try a jump
                                AssignCommand(oCreature,ClearAllActions());
                                AssignCommand(oCreature,JumpToObject(oFinalDestination));
                            } // try a jump
                            SetLocalInt(oCreature,"nMASReset",nN);
                        } // stuck - reset - check for timeout
                    } // not moving
                    else if (fF>fLF)
                    { // moving away
                        nN=GetLocalInt(oCreature,"nMASCount");
                        nN++;
                        SetLocalInt(oCreature,"nMASCount",nN);
                        if (nN<4)
                        { // move away
                            oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,d20());
                            if(!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,d20());
                            if(!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,d10());
                            if(!GetIsObjectValid(oOb)) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oCreature,1);
                            AssignCommand(oCreature,ClearAllActions());
                            AssignCommand(oCreature,ActionMoveToObject(oOb,TRUE));
                            DelayCommand(6.0,AssignCommand(oCreature,ClearAllActions()));
                            DelayCommand(6.02,AssignCommand(oCreature,ActionMoveToObject(oFinalDestination,TRUE,fRange)));
                        } // move away
                        else
                        { // move back
                            AssignCommand(oCreature,ClearAllActions());
                            AssignCommand(oCreature,ActionMoveToObject(oFinalDestination,TRUE,fRange));
                        } // move back
                    } // moving away
                    else
                    { // moving towards
                        DeleteLocalInt(oCreature,"nMASCount");
                    } // moving towards
                } // move issued
            } // move
        } // same area
        else
        { // different area
            nRet=fnMove_DifferentArea(oCreature,oFinalDestination,fRange,nRoute,nTimeOut);
        } // different area
    } // valid parameters
    else
    { // error
        nRet=MOVE_RESULT_UNREACHABLE;
    } // error
    return nRet;
} // Move_MoveToDestination()

//void main(){}
