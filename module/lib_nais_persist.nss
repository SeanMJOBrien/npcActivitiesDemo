////////////////////////////////////////////////////////////////////////////////
// lib_nais_persist - Persistance Functions for NPCs, Placeables, and Items
// By Deva B. Winblood - 03/25/2007
////////////////////////////////////////////////////////////////////////////////

#include "lib_nais_tool"
#include "nbde_inc"

////////////////////////
// CONSTANTS
////////////////////////



////////////////////////
// PROTOTYPES
////////////////////////


int List_GetFirstMember(string sDatabase,string sList);

int List_GetNextMember(string sDatabase,string sList);

int List_AddMember(string sDatabase,string sList);

void List_DeleteMember(string sDatabase,string sList,int nMember,int bNoCleanup=FALSE);

int List_GetMemberInt(string sDatabase,string sList,string sVar,int nMember);

string List_GetMemberString(string sDatabase,string sList,string sVar,int nMember);

float List_GetMemberFloat(string sDatabase,string sList,string sVar,int nMember);

location List_GetMemberLocation(string sDatabase,string sList,string sVar,int nMember);

void List_SetMemberInt(string sDatabase,string sList,string sVar,int nMember,int nValue);

void List_SetMemberString(string sDatabase,string sList,string sVar,int nMember,string sValue);

void List_SetMemberFloat(string sDatabase,string sList,string sVar,int nMember,float fValue);

void List_SetMemberLocation(string sDatabase,string sList,string sVar,int nMember,location lValue);

// FILE: lib_nais_persist           FUNCTION: PLC_GetFirstPlaceable()
// This will return the first Placeable list member number.
int PLC_GetFirstPlaceable();

// FILE: lib_nais_persist           FUNCTION: PLC_GetNextPlaceable()
// This will return the next Placeable list member number.
int PLC_GetNextPlaceable();

// FILE: lib_nais_persist           FUNCTION: PLC_UpdatePlaceable()
// This will update oOb to be stored for nID placeable ID. If nID = 0 then it
// will assign a new nID to oOb
void PLC_UpdatePlaceable(object oOb,int nID=0);

// FILE: lib_nais_persist           FUNCTION: PLC_RespawnPlaceable()
// This will respawn the specific placeable.
object PLC_RespawnPlaceable(int nID);

// FILE: lib_nais_persist           FUNCTION: PLC_DestroyPlaceable()
// This will destroy the persistent information for oOb.
void PLC_DestroyPlaceable(object oOb);


// FILE: lib_nais_persist       FUNCTION: NPC_GetFirstNPC()
// This function will return the first persistently stored NPC.
int NPC_GetFirstNPC();


// FILE: lib_nais_persist       FUNCTION: NPC_GetNextNPC()
// This function will return the next persistently stored NPC.
int NPC_GetNextNPC();


// FILE: lib_nais_persist       FUNCTION: NPC_UpdateNPC()
// This function will update the specific nID persistent database to be equivalent to oNPC.
// If nID is 0 it will create a new persistently stored NPC.
void NPC_UpdateNPC(object oNPC,int nID=0);


// FILE: lib_nais_persist       FUNCTION: NPC_RespawnNPC()
// This function will respawn an NPC from the persistent stored NPC information nID.
object NPC_RespawnNPC(int nID);


// FILE: lib_nais_persist       FUNCTION: NPC_DestroyNPC()
// This will destroy oNPC and if they are persistently stored it will remove the
// persistent NPC information.
void NPC_DestroyNPC(object oNPC,int nUID=0);


// FILE: lib_nais_persist       FUNCTION: NPC_GetNPCObjectByID()
// This will return an object referencing the specific NPC by User ID.
object NPC_GetNPCObjectByID(int nUID);


////////////////////////
// FUNCTIONS
////////////////////////


int List_GetFirstMember(string sDatabase,string sList)
{ // PURPOSE: Return the id of the first member 0 = none
    int nRet=NBDE_GetCampaignInt(sDatabase,"nLRt_"+sList);
    if (nRet!=0)
    { // set traverse pointer
        NBDE_SetCampaignInt(sDatabase,"nLPos_"+sList,nRet);
    } // set traverse pointer
    return nRet;
} // List_GetFirstMember()


int List_GetNextMember(string sDatabase,string sList)
{ // PURPOSE: Return the id of the next member 0 = none
    int nRet;
    int nPos=NBDE_GetCampaignInt(sDatabase,"nLPos_"+sList);
    nRet=NBDE_GetCampaignInt(sDatabase,"nLNx_"+sList+"_"+IntToString(nPos));
    if (nRet!=0)
    { // set traverse pointer
        NBDE_SetCampaignInt(sDatabase,"nLPos_"+sList,nRet);
    } // set traverse pointer
    return nRet;
} // List_GetNextMember()


int List_AddMember(string sDatabase,string sList)
{ // PURPOSE: Add a new list member
    int nRoot=NBDE_GetCampaignInt(sDatabase,"nLRt_"+sList);
    int nNew=Random(9999)+1;
    while(NBDE_GetCampaignInt(sDatabase,"bLA_"+sList+"_"+IntToString(nNew)))
    { // that one is used keep looking
        nNew++;
    } // that one is used keep looking
    NBDE_SetCampaignInt(sDatabase,"bLA_"+sList+"_"+IntToString(nNew),TRUE);
    if (nRoot>0)
    { // prepend
        NBDE_SetCampaignInt(sDatabase,"nLPr_"+sList+"_"+IntToString(nRoot),nNew);
        NBDE_SetCampaignInt(sDatabase,"nLNx_"+sList+"_"+IntToString(nNew),nRoot);
    } // prepend
    NBDE_SetCampaignInt(sDatabase,"nLRt_"+sList,nNew);
    return nNew;
} // List_AddMember()


void List_DeleteMember(string sDatabase,string sList,int nMember,int bNoCleanup=FALSE)
{ // PURPOSE: Delete nMember node from sList
    int nRoot=NBDE_GetCampaignInt(sDatabase,"nLRt_"+sList);
    int nNext;
    int nPrev;
    int nN;
    string sS;
    string sMList;
    if (NBDE_GetCampaignInt(sDatabase,"bLA_"+sList+"_"+IntToString(nMember)))
    { // node exists
        //SendMessageToPC(GetFirstPC(),"       List_DeleteMember("+sDatabase+","+sList+","+IntToString(nMember)+")");
        nNext=NBDE_GetCampaignInt(sDatabase,"nLNx_"+sList+"_"+IntToString(nMember));
        if (nNext==nMember) nNext=0;
        nPrev=NBDE_GetCampaignInt(sDatabase,"nLPr_"+sList+"_"+IntToString(nMember));
        if (nPrev==nMember) nPrev=0;
        if (nMember==nRoot)
        { // deleting the root
            //SendMessageToPC(GetFirstPC(),"              Root");
            if (nNext>0)
            { // next exists
                NBDE_SetCampaignInt(sDatabase,"nLRt_"+sList,nNext);
                NBDE_DeleteCampaignInt(sDatabase,"nLPr_"+sList+"_"+IntToString(nNext));
            } // next exists
            else
            { // delete the root variable
                NBDE_DeleteCampaignInt(sDatabase,"nLRt_"+sList);
            } // delete the root variable
            NBDE_DeleteCampaignInt(sDatabase,"nLPr_"+sList+"_"+IntToString(nMember));
            NBDE_DeleteCampaignInt(sDatabase,"nLNx_"+sList+"_"+IntToString(nMember));
            NBDE_DeleteCampaignInt(sDatabase,"nLA_"+sList+"_"+IntToString(nMember));
        } // deleting the root
        else
        { // not the root
            if (nNext>0)
            { // next exists
                NBDE_SetCampaignInt(sDatabase,"nLPr_"+sList+"_"+IntToString(nNext),nPrev);
            } // next exists
            if (nPrev>0)
            { // previous exists
                if (nNext>0)
                { // link
                    NBDE_SetCampaignInt(sDatabase,"nLNx_"+sList+"_"+IntToString(nPrev),nNext);
                } // link
                else
                { // delete next
                    NBDE_DeleteCampaignInt(sDatabase,"nLNx_"+sList+"_"+IntToString(nPrev));
                } // delete next
            } // previous exists
            NBDE_DeleteCampaignInt(sDatabase,"nLPr_"+sList+"_"+IntToString(nMember));
            NBDE_DeleteCampaignInt(sDatabase,"nLNx_"+sList+"_"+IntToString(nMember));
            NBDE_DeleteCampaignInt(sDatabase,"nLA_"+sList+"_"+IntToString(nMember));
        } // not the root
        // clean up variables
            if (!bNoCleanup)
            { // cleanup
                sMList=sList+IntToString(nMember)+"nV";
                //SendMessageToPC(GetFirstPC(),"               Cleanup");
                nNext=List_GetFirstMember(sDatabase,sMList);
                while(nNext>0)
                { // delete int variables
                    sS=NBDE_GetCampaignString(sDatabase,sMList+IntToString(nNext));
                    //SendMessageToPC(GetFirstPC(),"                 Cleanup[Int]:"+IntToString(nNext)+":"+sS);
                    NBDE_DeleteCampaignInt(sDatabase,sMList+IntToString(nNext)+sS);
                    NBDE_DeleteCampaignString(sDatabase,sMList+IntToString(nNext));
                    NBDE_DeleteCampaignInt(sDatabase,sMList+"a"+sS);
                    List_DeleteMember(sDatabase,sMList,nNext,TRUE);
                    nNext=List_GetNextMember(sDatabase,sMList);
                } // delete int variables
                sMList=sList+IntToString(nMember)+"sV";
                nNext=List_GetFirstMember(sDatabase,sMList);
                while(nNext>0)
                { // delete string variables
                    sS=NBDE_GetCampaignString(sDatabase,sMList+IntToString(nNext));
                    //SendMessageToPC(GetFirstPC(),"                 Cleanup[String]:"+IntToString(nNext)+":"+sS);
                    NBDE_DeleteCampaignString(sDatabase,sMList+IntToString(nNext)+sS);
                    NBDE_DeleteCampaignString(sDatabase,sMList+IntToString(nNext));
                    NBDE_DeleteCampaignInt(sDatabase,sMList+"a"+sS);
                    List_DeleteMember(sDatabase,sMList,nNext,TRUE);
                    nNext=List_GetNextMember(sDatabase,sMList);
                } // delete string variables
                sMList=sList+IntToString(nMember)+"fV";
                nNext=List_GetFirstMember(sDatabase,sMList);
                while(nNext>0)
                { // delete float variables
                    sS=NBDE_GetCampaignString(sDatabase,sMList+IntToString(nNext));
                    //SendMessageToPC(GetFirstPC(),"                 Cleanup[Float]:"+IntToString(nNext)+":"+sS);
                    NBDE_DeleteCampaignFloat(sDatabase,sMList+IntToString(nNext)+sS);
                    NBDE_DeleteCampaignString(sDatabase,sMList+IntToString(nNext));
                    NBDE_DeleteCampaignInt(sDatabase,sMList+"a"+sS);
                    List_DeleteMember(sDatabase,sMList,nNext,TRUE);
                    nNext=List_GetNextMember(sDatabase,sMList);
                } // delete float variables
                sMList=sList+IntToString(nMember)+"lV";
                nNext=List_GetFirstMember(sDatabase,sMList);
                while(nNext>0)
                { // delete location variables
                    sS=NBDE_GetCampaignString(sDatabase,sMList+IntToString(nNext));
                    //SendMessageToPC(GetFirstPC(),"                 Cleanup[Location]:"+IntToString(nNext)+":"+sS);
                    NBDE_DeleteCampaignLocation(sDatabase,sMList+IntToString(nNext)+sS);
                    NBDE_DeleteCampaignString(sDatabase,sMList+IntToString(nNext));
                    NBDE_DeleteCampaignInt(sDatabase,sMList+"a"+sS);
                    List_DeleteMember(sDatabase,sMList,nNext,TRUE);
                    nNext=List_GetNextMember(sDatabase,sMList);
                } // delete location variables
            } // cleanup
        NBDE_DeleteCampaignInt(sDatabase,"bLA_"+sList+"_"+IntToString(nMember));
    } // node exists
} // List_DeleteMember()


int List_GetMemberInt(string sDatabase,string sList,string sVar,int nMember)
{ // PURPOSE: Return the specified Integer attached to nMember
    return NBDE_GetCampaignInt(sDatabase,sList+IntToString(nMember)+"nV"+sVar);
} // List_GetMemberInt()


string List_GetMemberString(string sDatabase,string sList,string sVar,int nMember)
{ // PURPOSE: Return the specified string attached to nMember
    return NBDE_GetCampaignString(sDatabase,sList+IntToString(nMember)+"sV"+sVar);
} // List_GetMemberString()


float List_GetMemberFloat(string sDatabase,string sList,string sVar,int nMember)
{ // PURPOSE: Return the specified float attached to nMember
    return NBDE_GetCampaignFloat(sDatabase,sList+IntToString(nMember)+"fV"+sVar);
} // List_GetMemberFloat()


location List_GetMemberLocation(string sDatabase,string sList,string sVar,int nMember)
{ // PURPOSE: Return the specified Location attached to nMember
    return NBDE_GetCampaignLocation(sDatabase,sList+IntToString(nMember)+"lV"+sVar);
} // List_GetMemberLocation()


void List_SetMemberInt(string sDatabase,string sList,string sVar,int nMember,int nValue)
{ // PURPOSE: Set the sVar value on sList for member nMember
    int nNew;
    string sMList=sList+IntToString(nMember)+"nV";
    if (!NBDE_GetCampaignInt(sDatabase,"bLA_"+sList+"_"+IntToString(nMember))) return;
    nNew=NBDE_GetCampaignInt(sDatabase,sMList+"a"+sVar);
    if (nNew<1)
    { // create it
       nNew=List_AddMember(sDatabase,sMList);
       NBDE_SetCampaignInt(sDatabase,sMList+"a"+sVar,nNew);
       NBDE_SetCampaignString(sDatabase,sMList+IntToString(nNew),sVar);
    } // create it
    NBDE_SetCampaignInt(sDatabase,sMList+sVar,nValue);
} // List_SetMemberInt()


void List_SetMemberString(string sDatabase,string sList,string sVar,int nMember,string sValue)
{ // PURPOSE: Set the sVar value on sList for member nMember
    int nNew;
    string sMList=sList+IntToString(nMember)+"sV";
    if (!NBDE_GetCampaignInt(sDatabase,"bLA_"+sList+"_"+IntToString(nMember))) return;
    nNew=NBDE_GetCampaignInt(sDatabase,sMList+"a"+sVar);
    if (nNew<1)
    { // create it
       nNew=List_AddMember(sDatabase,sMList);
       NBDE_SetCampaignInt(sDatabase,sMList+"a"+sVar,nNew);
       NBDE_SetCampaignString(sDatabase,sMList+IntToString(nNew),sVar);
    } // create it
    NBDE_SetCampaignString(sDatabase,sMList+sVar,sValue);
} // List_SetMemberString()


void List_SetMemberFloat(string sDatabase,string sList,string sVar,int nMember,float fValue)
{ // PURPOSE: Set the sVar value on sList for member nMember
    int nNew;
    string sMList=sList+IntToString(nMember)+"fV";
    if (!NBDE_GetCampaignInt(sDatabase,"bLA_"+sList+"_"+IntToString(nMember))) return;
    nNew=NBDE_GetCampaignInt(sDatabase,sMList+"a"+sVar);
    if (nNew<1)
    { // create it
       nNew=List_AddMember(sDatabase,sMList);
       NBDE_SetCampaignInt(sDatabase,sMList+"a"+sVar,nNew);
       NBDE_SetCampaignString(sDatabase,sMList+IntToString(nNew),sVar);
    } // create it
    NBDE_SetCampaignFloat(sDatabase,sMList+sVar,fValue);
} // List_SetMemberFloat()


void List_SetMemberLocation(string sDatabase,string sList,string sVar,int nMember,location lValue)
{ // PURPOSE: Set the sVar value on sList for member nMember
    int nNew;
    string sMList=sList+IntToString(nMember)+"lV";
    if (!NBDE_GetCampaignInt(sDatabase,"bLA_"+sList+"_"+IntToString(nMember))) return;
    nNew=NBDE_GetCampaignInt(sDatabase,sMList+"a"+sVar);
    if (nNew<1)
    { // create it
       nNew=List_AddMember(sDatabase,sMList);
       NBDE_SetCampaignInt(sDatabase,sMList+"a"+sVar,nNew);
       NBDE_SetCampaignString(sDatabase,sMList+IntToString(nNew),sVar);
    } // create it
    NBDE_SetCampaignLocation(sDatabase,sMList+sVar,lValue);
} // List_SetMemberLocation()


int PLC_GetFirstPlaceable()
{ // PURPOSE: Return the first placeable number
    return List_GetFirstMember("NAIS1PLC","PLC");
} // PLC_GetFirstPlaceable()


int PLC_GetNextPlaceable()
{ // PURPOSE: Return the next placeable number
    return List_GetNextMember("NAIS1PLC","PLC");
} // PLC_GetNextPlaceable()


void PLC_UpdatePlaceable(object oOb,int nID=0)
{ // PURPOSE: Update placeable
    string sRes=GetResRef(oOb);
    string sTag=GetTag(oOb);
    string sEvent=GetLocalString(oOb,"sEEventWP");
    string sName=GetName(oOb);
    location lLoc=GetLocation(oOb);
    string sTeamID=GetLocalString(oOb,"sTeamID");
    int nInv=GetLocalInt(oOb,"nInventoryID");
    int nNID=nID;
    if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_PLACEABLE)
    { // valid
        if (nNID==0)
        { // need new ID
            nNID=List_AddMember("NAIS1PLC","PLC");
        } // need new ID
        List_SetMemberString("NAIS1PLC","PLC","sR",nNID,sRes);
        List_SetMemberString("NAIS1PLC","PLC","sT",nNID,sTag);
        List_SetMemberString("NAIS1PLC","PLC","sE",nNID,sEvent);
        List_SetMemberString("NAIS1PLC","PLC","sN",nNID,sName);
        List_SetMemberString("NAIS1PLC","PLC","sTID",nNID,sTeamID);
        List_SetMemberInt("NAIS1PLC","PLC","nI",nNID,nInv);
        List_SetMemberLocation("NAIS1PLC","PLC","lL",nNID,lLoc);
        SetLocalInt(oOb,"nPID",nNID);
    } // valid
} // PLC_UpdatePlaceable()


object PLC_RespawnPlaceable(int nID)
{ // PURPOSE: To recreate the placeable for nID
    object oRet=OBJECT_INVALID;
    string sRes;
    string sTag;
    string sEvent;
    string sName;
    string sTeamID;
    location lLoc;
    int nInv;
    object oArea;
    //float fTime=11.0;
    //DelayCommand(fTime,SendMessageToPC(GetFirstPC(),"PLC_RespawnPlaceable("+IntToString(nID)+")"));
    sRes=List_GetMemberString("NAIS1PLC","PLC","sR",nID);
    if (GetStringLength(sRes)>0)
    { // stored placeable found
        //fTime=fTime+0.1;
        //DelayCommand(fTime,SendMessageToPC(GetFirstPC(),"  sR='"+sRes+"'"));
        sTag=List_GetMemberString("NAIS1PLC","PLC","sT",nID);
        //DelayCommand(fTime+0.2,SendMessageToPC(GetFirstPC(),"  sT='"+sTag+"'"));
        sEvent=List_GetMemberString("NAIS1PLC","PLC","sE",nID);
        //DelayCommand(fTime+0.3,SendMessageToPC(GetFirstPC(),"  sE='"+sEvent+"'"));
        sName=List_GetMemberString("NAIS1PLC","PLC","sN",nID);
        //DelayCommand(fTime+0.4,SendMessageToPC(GetFirstPC(),"  sN='"+sName+"'"));
        sTeamID=List_GetMemberString("NAIS1PLC","PLC","sTID",nID);
        //DelayCommand(fTime+0.5,SendMessageToPC(GetFirstPC(),"  sTID='"+sTeamID+"'"));
        lLoc=List_GetMemberLocation("NAIS1PLC","PLC","lL",nID);
        oArea=GetAreaFromLocation(lLoc);
        //DelayCommand(fTime+0.7,SendMessageToPC(GetFirstPC(),"  Area From Location='"+GetName(GetArea(oArea))+"'"));
        nInv=List_GetMemberInt("NAIS1PLC","PLC","nI",nID);
        //DelayCommand(fTime+0.6,SendMessageToPC(GetFirstPC(),"  nI='"+IntToString(nInv)+"'"));
        oRet=CreateObject(OBJECT_TYPE_PLACEABLE,sRes,lLoc,FALSE,sTag);
        if (!GetIsObjectValid(oRet)) PrintString("PLC_RespawnPlaceable(): Failed for sRes='"+sRes+"' sTag='"+sTag+"' Location Area='"+GetName(GetAreaFromLocation(lLoc))+"'");
        else
        { // success
            SetName(oRet,sName);
            SetLocalString(oRet,"sTeamID",sTeamID);
            SetLocalString(oRet,"sEEventWP",sEvent);
            SetLocalInt(oRet,"nPID",nID);
            SetLocalInt(oRet,"nInventoryID",nInv);
        } // success
        //DelayCommand(fTime+0.8,SendMessageToPC(GetFirstPC(),"  Respawned At='"+GetName(GetArea(oRet))+"'"));
        //fTime=fTime+0.9;
    } // stored placeable found
    return oRet;
} // PLC_RespawnPlaceable()


void PLC_DestroyPlaceable(object oOb)
{ // PURPOSE: Destroy the placeable
    int nID=GetLocalInt(oOb,"nPID");
    if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_PLACEABLE)
    { // valid object
        if (nID>0)
        { // database
            List_DeleteMember("NAIS1PLC","PLC",nID);
        } // database
        DelayCommand(0.1,DestroyObject(oOb));
    } // valid object
} // PLC_DestroyPlaceable()


int NPC_GetFirstNPC()
{ // PURPOSE: To return the first NPC member
    return List_GetFirstMember("NAIS1NPC","NPC");
} // NPC_GetFirstNPC()


int NPC_GetNextNPC()
{ // PURPOSE: To return the next NPC Member
    return List_GetNextMember("NAIS1NPC","NPC");
} // NPC_GetNextNPC()


void NPC_UpdateNPC(object oNPC,int nID=0)
{ // PURPOSE: To update the oNPC in member nID in NPC DB list
    int nNID=nID;
    object oOb;
    string sS;
    int nN;
    if (GetIsObjectValid(oNPC)&&GetObjectType(oNPC)==OBJECT_TYPE_CREATURE)
    { // valid parameters
        if (nNID==0)
        { // create new entry
            nNID=List_AddMember("NAIS1NPC","NPC");
        } // create new entry
        SetLocalInt(oNPC,"nUID",nNID);
        List_SetMemberString("NAIS1NPC","NPC","sN",nNID,GetName(oNPC));
        List_SetMemberString("NAIS1NPC","NPC","sT",nNID,GetTag(oNPC));
        List_SetMemberString("NAIS1NPC","NPC","sE",nNID,GetLocalString(oNPC,"sEEventWP"));
        List_SetMemberString("NAIS1NPC","NPC","sR",nNID,GetResRef(oNPC));
        List_SetMemberString("NAIS1NPC","NPC","sTID",nNID,GetLocalString(oNPC,"sTeamID"));
        oOb=GetItemInSlot(INVENTORY_SLOT_CHEST,oNPC);
        if (GetIsObjectValid(oOb)) List_SetMemberString("NAIS1NPC","NPC","sCR",nNID,GetResRef(oOb));
        else { List_SetMemberString("NAIS1NPC","NPC","sCR",nNID,""); }
        List_SetMemberString("NAIS1NPC","NPC","sD",nNID,GetLocalString(oNPC,"sDestTag"));
        List_SetMemberLocation("NAIS1NPC","NPC","lL",nNID,GetLocation(oNPC));
        List_SetMemberInt("NAIS1NPC","NPC","nHP",nNID,GetCurrentHitPoints(oNPC));
        List_SetMemberInt("NAIS1NPC","NPC","nG",nNID,GetGold(oNPC));
        List_SetMemberInt("NAIS1NPC","NPC","nC",nNID,GetLocalInt(oNPC,"nXP"));
        List_SetMemberInt("NAIS1NPC","NPC","nA",nNID,GetAppearanceType(oNPC));
        List_SetMemberInt("NAIS1NPC","NPC","nP",nNID,GetPhenoType(oNPC));
        List_SetMemberInt("NAIS1NPC","NPC","nH",nNID,GetCreatureBodyPart(CREATURE_PART_HEAD,oNPC));
        List_SetMemberInt("NAIS1NPC","NPC","nL",nNID,GetLocalInt(oNPC,"nLeadership"));
        List_SetMemberInt("NAIS1NPC","NPC","nAID",nNID,GetLocalInt(oNPC,"nArmyID"));
        List_SetMemberInt("NAIS1NPC","NPC","nTA",nNID,GetCreatureTailType(oNPC));
        List_SetMemberInt("NAIS1NPC","NPC","nUnitN",nNID,GetLocalInt(oNPC,"nUnitN"));
        nN=GetLevelByPosition(1,oNPC)+GetLevelByPosition(2,oNPC)+GetLevelByPosition(3,oNPC);
        List_SetMemberInt("NAIS1NPC","NPC","nLevel",nNID,nN);
        List_SetMemberInt("NAIS1NPC","NPC","nLUID",nNID,GetLocalInt(oNPC,"nLUID"));
        SetLocalObject(GetModule(),"oNPCBYUID_"+IntToString(nNID),oNPC);
    } // valid parameters
} // NPC_UpdateNPC()


object NPC_GetNPCObjectByID(int nUID)
{ // PURPOSE: Return the NPC object
    return GetLocalObject(GetModule(),"oNPCBYUID_"+IntToString(nUID));
} // NPC_GetNPCObjectByID()


void fnpersistLevelUp(object oNPC,int nLevel)
{ // PURPOSE: Internal respawn NPC at proper level
    int nClass;
    int nPackage;
    if (nLevel<1) return;
    nClass=GetLocalInt(oNPC,"nClass");
    nPackage=GetLocalInt(oNPC,"nPackage");
    LevelUpHenchman(oNPC,nClass,TRUE,nPackage);
    DelayCommand(0.05,fnpersistLevelUp(oNPC,nLevel-1));
} // fnpersistLevelUp()

object NPC_RespawnNPC(int nID)
{ // PURPOSE: This function will spawn an NPC based on stored info on nID.
    object oNPC=OBJECT_INVALID;
    string sS;
    int nN;
    string sT;
    string sR;
    effect eE;
    object oItem;
    object oProxy;
    location lLoc;
    if (nID>0)
    { // possible valid ID
        if (GetIsObjectValid(GetLocalObject(GetModule(),"oNPCBYUID_"+IntToString(nID)))) return OBJECT_INVALID;
        if (NBDE_GetCampaignInt("NAIS1NPC","bLA_NPC_"+IntToString(nID)))
        { // properly allocated ID
            sT=List_GetMemberString("NAIS1NPC","NPC","sT",nID);
            sR=List_GetMemberString("NAIS1NPC","NPC","sR",nID);
            lLoc=List_GetMemberLocation("NAIS1NPC","NPC","lL",nID);
            oNPC=CreateObject(OBJECT_TYPE_CREATURE,sR,lLoc,FALSE,sT);
            if (GetIsObjectValid(oNPC))
            { // creature spawned
                sS=List_GetMemberString("NAIS1NPC","NPC","sN",nID);
                SetName(oNPC,sS);
                sS=List_GetMemberString("NAIS1NPC","NPC","sE",nID);
                SetLocalString(oNPC,"sEEventWP",sS);
                sS=List_GetMemberString("NAIS1NPC","NPC","sTID",nID);
                SetLocalString(oNPC,"sTeamID",sS);
                SetLocalObject(GetModule(),"oNPCBYUID_"+IntToString(nID),oNPC);
                if (GetStringLength(sS)>1)
                { // team
                    oProxy=GetObjectByTag("proxy_"+sS);
                    if (!GetIsObjectValid(oProxy)) oProxy=GetObjectByTag("proxy_"+GetLocalString(GetArea(oNPC),"sDefaultAffiliation"));
                    if (!GetIsObjectValid(oProxy)) oProxy=GetObjectByTag("proxy_abs");
                    if (GetIsObjectValid(oProxy))
                    { // proxy found
                        ChangeFaction(oNPC,oProxy);
                    } // proxy found
                    nN=List_GetMemberInt("NAIS1NPC","NPC","nLUID",nID);
                    if (nN>0) SetLocalInt(oNPC,"nLUID",nN);
                } // team
                sS=List_GetMemberString("NAIS1NPC","NPC","sD",nID);
                SetLocalString(oNPC,"sDestTag",sS);
                sS=List_GetMemberString("NAIS1NPC","NPC","sCR",nID);
                if (GetStringLength(sS)>0)
                { // chest object defined
                    oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oNPC);
                    if (GetResRef(oItem)!=sS)
                    { // replace
                        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
                        oItem=CreateItemOnObject(sS,oNPC);
                        if (GetIsObjectValid(oItem))
                        { // equip it
                            AssignCommand(oNPC,lib_ForceEquip(oNPC,oItem,INVENTORY_SLOT_CHEST));
                        } // equip it
                    } // replace
                } // chest object defined
                nN=List_GetMemberInt("NAIS1NPC","NPC","nHP",nID);
                if (nN<GetCurrentHitPoints(oNPC))
                { // damage
                    nN=GetCurrentHitPoints(oNPC)-nN;
                    eE=EffectDamage(nN);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eE,oNPC);
                } // damage
                nN=List_GetMemberInt("NAIS1NPC","NPC","nG",nID);
                if (nN<GetGold(oNPC))
                { // give gold
                    nN=nN-GetGold(oNPC);
                    GiveGoldToCreature(oNPC,nN);
                } // give gold
                else if (nN>GetGold(oNPC))
                { // take gold
                    nN=GetGold(oNPC)-nN;
                    TakeGoldFromCreature(nN,oNPC,TRUE);
                } // take gold
                nN=List_GetMemberInt("NAIS1NPC","NPC","nX",nID);
                SetLocalInt(oNPC,"nXP",nN);
                nN=List_GetMemberInt("NAIS1NPC","NPC","nA",nID);
                SetCreatureAppearanceType(oNPC,nN);
                nN=List_GetMemberInt("NAIS1NPC","NPC","nAID",nID);
                SetLocalInt(oNPC,"nArmyID",nN);
                nN=List_GetMemberInt("NAIS1NPC","NPC","nTA",nID);
                if (nN>0) SetCreatureTailType(nN,oNPC);
                SetLocalInt(oNPC,"nUID",nID);
                nN=List_GetMemberInt("NAIS1NPC","NPC","nUnitN",nID);
                SetLocalInt(oNPC,"nUnitN",nN);
                nN=GetLevelByPosition(1,oNPC)+GetLevelByPosition(2,oNPC)+GetLevelByPosition(3,oNPC);
                nN=nN-List_GetMemberInt("NAIS1NPC","NPC","nLevel",nID);
                if (nN>0) DelayCommand(0.5,fnpersistLevelUp(oNPC,nN));
                PrintString("NPC_RespawnNPC():Respawned '"+GetName(oNPC)+"' nID="+IntToString(nID)+" sTeamID='"+GetLocalString(oNPC,"sTeamID")+"'  oProxy='"+GetTag(oProxy)+"'");
            } // creature spawned
            else
            { // failed
                PrintString("NPC_RespawnNPC():Respawn Failed for nID="+IntToString(nID));
            } // failed
        } // properly allocated ID
        else
        { // not proper
            PrintString("NPC_RespawnNPC():Failed nID="+IntToString(nID)+" is not properly allocated.");
        } // not proper
    } // possible valid ID
    return oNPC;
} // NPC_RespawnNPC()


void NPC_DestroyNPC(object oNPC,int nUID=0)
{ // PURPOSE: Destroy persistently stored NPC
    int nID=GetLocalInt(oNPC,"nUID");
    if (nUID==0)
    { // no UID specified
        if (GetObjectType(oNPC)==OBJECT_TYPE_CREATURE&&nID>0)
        { // destroy
            List_DeleteMember("NAIS1NPC","NPC",nID);
            DestroyObject(oNPC);
        } // destroy
    } // no UID specified
    else
    { // delete UID info
        List_DeleteMember("NAIS1NPC","NPC",nID);
    } // delete UID info
} // NPC_DestroyNPC()

//void main(){}
