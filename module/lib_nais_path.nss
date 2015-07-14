////////////////////////////////////////////////////////////////////////////////
// lib_nais_path - Path Building Library
// By Deva B. Winblood.   04/10/2007
////////////////////////////////////////////////////////////////////////////////
/*
   Pathing will use AREA_<areatag> waypoints to find specific areas quickly.
   Each area must have a unique tag.  It will find every area using AREAMARKER
   waypoints.   There must be only one AREAMARKER waypoint per area.
   It will store the following in the database:
   s<AreaTag>_P_# = tag of other areas known to this area
   n<AreaTag>_PEND = Last # of known areas (tail of list)
   n<AreaTag>_PD_<DAreaTag> = Shortest distance to DAreaTag
   s<AreaTag>_PD_<DAreaTag> = Object to use to transition
*/
////////////////////////////////////////////////////////////////////////////////

#include "nbde_inc"
#include "lib_nais_msg"

//////////////////////////////
// CONSTANTS
//////////////////////////////

const string PATH_DB_NAME = "NAIS1PATH"; // database to store path in
const int PATH_DB_DEBUG = FALSE;         // Sends Debug Messages when TRUE

//////////////////////////////
// PROTOTYPES
//////////////////////////////


// FILE: lib_nais_path           FUNCTION: Path_BuildConnections()
// This function will check all connections for directly connected areas
// and will return the number of updates to this connection that were found.
int Path_BuildConnections(object oArea,object oConnectingArea);


// FILE: lib_nais_path           FUNCTION: Path_BuildInitialConnections()
// This function will check all transition objects and initialize the pathing
// database for this area.  It will use triggers, doors, and Plot Placeables
// with sDestTag set to a waypoint tag.
void Path_BuildInitialConnections(object oArea);


// FILE: lib_nais_path          FUNCTION: Path_DeterminePaths()
// This function will cycle through all areas with an AREAMARKER and will
// build pathing information.  It will call Path_BuildConnections and will
// start over from the beginning until there are no new connections found.
void Path_DeterminePaths(int nArea);


// FILE: lib_nais_path          FUNCTION: Path_BuildPathDB()
// This function will call Path_BuildInitialConnections for each area and
// it will then launch Path_DeterminePaths to begin the final build.
void Path_BuildPathDB();


// FILE: lib_nais_path          FUNCTION: Path_GetDistanceBetween()
// This function will return the shortest distance between the areas.   It
// will return 0 if they are the same area or -1 if there is no known path.
int Path_GetDistanceBetween(object oArea1,object oArea2);


// FILE: lib_nais_path          FUNCTION: Path_GetQuickestTransition()
// This will return the transition that should be used for the shortest trip
// to specified location.
object Path_GetQuickestTransition(object oArea1,object oArea2);


//////////////////////////////
// FUNCTIONS
//////////////////////////////


void Path_BuildPathDB()
{ // PURPOSE: Start the process of building the path database
    object oWP;
    float fDelay=0.5;
    int nN=0;
    object oPC=GetFirstPC();
    DestroyCampaignDatabase(PATH_DB_NAME);
    if (PATH_DB_DEBUG)
    { // debug
        PrintString("Path_BuildPathDB()");
        SendMessageToPC(oPC,"Path_BuildPathDB()");
    } // debug
    oWP=GetObjectByTag("AREAMARKER",nN);
    while(GetIsObjectValid(oWP))
    { // process waypoints
        if (PATH_DB_DEBUG)
        { // debug
            SendMessageToPC(oPC,"  AREA#"+IntToString(nN)+"='"+GetName(GetArea(oWP))+"'");
        } // debug
        DelayCommand(fDelay,Path_BuildInitialConnections(GetArea(oWP)));
        fDelay=fDelay+0.5;
        nN++;
        oWP=GetObjectByTag("AREAMARKER",nN);
    } // process waypoints
    DelayCommand(fDelay+2.0,Path_DeterminePaths(0));
    if (PATH_DB_DEBUG)
    { // debug
        DelayCommand(fDelay+0.1,PrintString("End->Path_BuildPathDB()"));
        DelayCommand(fDelay+0.12,SendMessageToPC(oPC,"End->Path_BuildPathDB()"));
    } // debug
} // Path_BuildPathDB()


void Path_BuildInitialConnections(object oArea)
{ // PURPOSE: To setup initial known connections for this area
    string sTag=GetTag(oArea);
    object oCenter=GetWaypointByTag("AREA_"+sTag);
    object oOb;
    object oDest;
    string sDTag;
    int nEnd=0;
    int nN;
    if (GetIsObjectValid(oCenter))
    { // area waypoint found
        if (PATH_DB_DEBUG)
        { // initial connections
            PrintString("PATH:InitialConnections("+GetName(oArea)+")");
            SendMessageToPC(GetFirstPC(),"PATH:InitialConnections("+GetName(oArea)+")");
        } // initial connections
        nN=1;
        oOb=GetNearestObject(OBJECT_TYPE_TRIGGER,oCenter,nN);
        while(GetIsObjectValid(oOb))
        { // triggers
            oDest=GetTransitionTarget(oOb);
            if (GetIsObjectValid(oDest)&&GetArea(oDest)!=oArea)
            { // transition
                sDTag=GetTag(GetArea(oDest));
                if (NBDE_GetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sDTag)==0)
                { // new path
                    nEnd++;
                    NBDE_SetCampaignString(PATH_DB_NAME,"s"+sTag+"_P_"+IntToString(nEnd),sDTag);
                    NBDE_SetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sDTag,1);
                    NBDE_SetCampaignString(PATH_DB_NAME,"s"+sTag+"_PD_"+sDTag,GetTag(oOb));
                } // new path
            } // transition
            nN++;
            oOb=GetNearestObject(OBJECT_TYPE_TRIGGER,oCenter,nN);
        } // triggers
        nN=1;
        oOb=GetNearestObject(OBJECT_TYPE_DOOR,oCenter,nN);
        while(GetIsObjectValid(oOb))
        { // doors
            oDest=GetTransitionTarget(oOb);
            if (GetIsObjectValid(oDest)&&GetArea(oDest)!=oArea)
            { // transition
                sDTag=GetTag(GetArea(oDest));
                if (NBDE_GetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sDTag)==0)
                { // new path
                    nEnd++;
                    NBDE_SetCampaignString(PATH_DB_NAME,"s"+sTag+"_P_"+IntToString(nEnd),sDTag);
                    NBDE_SetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sDTag,1);
                    NBDE_SetCampaignString(PATH_DB_NAME,"s"+sTag+"_PD_"+sDTag,GetTag(oOb));
                } // new path
            } // transition
            nN++;
            oOb=GetNearestObject(OBJECT_TYPE_DOOR,oCenter,nN);
        } // doors
        nN=1;
        oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,oCenter,nN);
        while(GetIsObjectValid(oOb))
        { // placeables
            oDest=OBJECT_INVALID;
            sDTag=GetLocalString(oOb,"sDestTag");
            if (GetStringLength(sDTag)>0&&GetPlotFlag(oOb)) oDest=GetWaypointByTag(sDTag);
            if (GetIsObjectValid(oDest)&&GetArea(oDest)!=oArea)
            { // transition
                sDTag=GetTag(GetArea(oDest));
                if (NBDE_GetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sDTag)==0)
                { // new path
                    nEnd++;
                    NBDE_SetCampaignString(PATH_DB_NAME,"s"+sTag+"_P_"+IntToString(nEnd),sDTag);
                    NBDE_SetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sDTag,1);
                    NBDE_SetCampaignString(PATH_DB_NAME,"s"+sTag+"_PD_"+sDTag,GetTag(oOb));
                } // new path
            } // transition
            nN++;
            oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,oCenter,nN);
        } // placeables
        NBDE_SetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PEND",nEnd);
    } // area waypoint found
    if (PATH_DB_DEBUG)
    { // PATH DEBUG
        sTag="Path:Build_InitialConnections("+GetName(oArea)+")="+IntToString(nEnd);
        PrintString(sTag);
        SendMessageToPC(GetFirstPC(),sTag);
    } // PATH DEBUG
} // Path_BuildInitialConnections()


void fnPath_BuildConnections(object oArea,object oArea2)
{ // PURPOSE: Handling Path_BuildConnections so, can delay it
    int nR;
    int nV;
    nR=Path_BuildConnections(oArea,oArea2);
    if(nR>0)
    { // more paths
        nV=GetLocalInt(GetModule(),"nNaisPathCount");
        nV=nV+nR;
        SetLocalInt(GetModule(),"nNaisPathCount",nV);
    } // more paths
} // fnPath_BuildConnections()

void Path_DeterminePaths(int nArea)
{ // PURPOSE: Handle updating paths
    object oAreaMarker=GetObjectByTag("AREAMARKER",nArea);
    int nR;
    object oArea;
    int nC;
    object oArea2;
    object oMod=GetModule();
    string sS;
    float fFloat=0.05;
    if (PATH_DB_DEBUG)
    { // debug
        SendMessageToPC(GetFirstPC(),"Path_DeterminePaths("+IntToString(nArea)+"):"+GetName(GetArea(oAreaMarker)));
    } // debug
    if (nArea==0) DeleteLocalInt(oMod,"nNaisPathCount");
    nR=GetLocalInt(oMod,"nNaisPathCount");
    if (GetIsObjectValid(oAreaMarker))
    { // process this area
        oArea=GetArea(oAreaMarker);
        if (PATH_DB_DEBUG)
        { // debug
            PrintString("   Path:"+GetName(oArea)+"["+GetTag(oArea)+"]");
        } // debug
        nC=1;
        sS=NBDE_GetCampaignString(PATH_DB_NAME,"s"+GetTag(oArea)+"_P_"+IntToString(nC));
        while(GetStringLength(sS)>0)
        { // check each area
            if (PATH_DB_DEBUG)
            { // debug
                SendMessageToPC(GetFirstPC(),"    :"+IntToString(nC)+"='"+sS+"'");
            } // debug
            oArea2=GetWaypointByTag("AREA_"+sS);
            if (GetIsObjectValid(oArea2))
            { // valid waypoint marker
                oArea2=GetArea(oArea2);
                if (oArea2!=oArea)
                { // check
                    fFloat=fFloat+0.05;
                    DelayCommand(fFloat,fnPath_BuildConnections(oArea,oArea2));
                } // check
            } // valid waypoint marker
            nC++;
            sS=NBDE_GetCampaignString(PATH_DB_NAME,"s"+GetTag(oArea)+"_P_"+IntToString(nC));
        } // check each area
        DelayCommand(fFloat+0.1,Path_DeterminePaths(nArea+1));
    } // process this area
    else
    { // end of area
        if (nR>0)
        { // changes found - run another pass
            if (PATH_DB_DEBUG)
            { // another pass
                PrintString(" Path:Do another pass.");
                SendMessageToPC(GetFirstPC()," Path:Do another pass.");
            } // another pass
            DelayCommand(1.0,Path_DeterminePaths(0));
        } // changes found - run another pass
        else
        { // end
            DeleteLocalInt(oMod,"nNaisPathCount");
            NBDE_FlushCampaignDatabase(PATH_DB_NAME);
            if (PATH_DB_DEBUG)
            { // debug messages
                PrintString("Path:DeterminePaths Completed!");
                SendMessageToPC(GetFirstPC(),"Path:DeterminePaths Completed!");
                oArea=GetArea(GetWaypointByTag("AREA_lair_cul"));
                oArea2=GetArea(GetWaypointByTag("AREA_AG1010"));
                nC=NBDE_GetCampaignInt(PATH_DB_NAME,"n"+GetTag(oArea)+"_PD_"+GetTag(oArea2));
                SendMessageToPC(GetFirstPC(),"Shortest distance between lair_cul and AG1010 = "+IntToString(nC));
                oArea2=GetArea(GetWaypointByTag("AREA_AG0609"));
                nC=NBDE_GetCampaignInt(PATH_DB_NAME,"n"+GetTag(oArea)+"_PD_"+GetTag(oArea2));
                SendMessageToPC(GetFirstPC(),"Shortest distance between lair_cul and AG0609 = "+IntToString(nC));
            } // debug messages
            Msg_Players(GetModule(),"Pathing is completed! You may now Journey Onward into the world!","066","as_an_koboldwee");
            NBDE_SetCampaignInt(PATH_DB_NAME,"bPathingComplete",TRUE);
            NBDE_FlushCampaignDatabase(PATH_DB_NAME);
        } // end
    } // end of area
} // Path_DeterminePaths()


int Path_BuildConnections(object oArea,object oConnectingArea)
{ // PURPOSE: Build connections
    int nRet=0;
    string sTag=GetTag(oArea);
    string sCTag=GetTag(oConnectingArea);
    int nC;
    string sS;
    string sSS;
    string sD;
    int nD;
    object oOb;
    object oA;
    int nN;
    if (PATH_DB_DEBUG)
    { // debug
        SendMessageToPC(GetFirstPC()," Path_BuildConnections("+GetName(oArea)+","+GetName(oConnectingArea)+")");
    } // debug
    if (GetIsObjectValid(oArea)&&GetIsObjectValid(oConnectingArea))
    { // valid
        sD=NBDE_GetCampaignString(PATH_DB_NAME,"s"+sTag+"_PD_"+sCTag); // get destination to use
        nC=1;
        sS=NBDE_GetCampaignString(PATH_DB_NAME,"s"+sCTag+"_P_"+IntToString(nC)); // Get Tag of a connection known to connecting area
        while(GetStringLength(sS)>0)
        { // check paths
            sSS=NBDE_GetCampaignString(PATH_DB_NAME,"s"+sTag+"_PD_"+sS); // see if the area is known to sTag area
            if (GetStringLength(sSS)<1&&sS!=sTag)
            { // new transition info
                if (PATH_DB_DEBUG)
                { // new
                    SendMessageToPC(GetFirstPC(),"   New Path:"+sS+" for area "+sTag);
                } // new
                nRet++;
                nN=NBDE_GetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PEND");
                nN++;
                NBDE_SetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PEND",nN);
                NBDE_SetCampaignString(PATH_DB_NAME,"s"+sTag+"_P_"+IntToString(nN),sS);
                NBDE_SetCampaignString(PATH_DB_NAME,"s"+sTag+"_PD_"+sS,sD);
                nN=NBDE_GetCampaignInt(PATH_DB_NAME,"n"+sCTag+"_PD_"+sS)+NBDE_GetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sCTag);
                NBDE_SetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sS,nN);
            } // new transition info
            else if (sS!=sTag)
            { // greater
                nD=NBDE_GetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sS);
                nN=NBDE_GetCampaignInt(PATH_DB_NAME,"n"+sCTag+"_PD_"+sS)+NBDE_GetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sCTag);
                if (nN<nD)
                { // shorter
                     if (PATH_DB_DEBUG)
                     { // shorter
                         SendMessageToPC(GetFirstPC(),"   Shorter Path "+sTag+"->"+sS+" Previous:"+IntToString(nD)+" New:"+IntToString(nN));
                     } // shorter
                     nRet++;
                     NBDE_SetCampaignString(PATH_DB_NAME,"s"+sTag+"_PD_"+sS,sD);
                     NBDE_SetCampaignInt(PATH_DB_NAME,"n"+sTag+"_PD_"+sS,nN);
                } // shorter
            } // greater
            nC++;
            sS=NBDE_GetCampaignString(PATH_DB_NAME,"s"+sCTag+"_P_"+IntToString(nC));
        } // check paths
        if (PATH_DB_DEBUG&&nRet>0)
        { // path update
            PrintString("  Path:"+GetName(oArea)+"->"+GetName(oConnectingArea)+"="+IntToString(nRet)+" changes.");
            SendMessageToPC(GetFirstPC(),"  Path:"+GetName(oArea)+"->"+GetName(oConnectingArea)+"="+IntToString(nRet)+" changes.");
        } // path update
    } // valid
    return nRet;
} // Path_BuildConnections()



//void main(){}
