////////////////////////////////////////////////////////////////////////////////
// lib_nais_xp - Experience Point Library
// By Deva B. Winblood.  3/26/2007
////////////////////////////////////////////////////////////////////////////////

#include "lib_nais_team"
#include "lib_nais_race"

/////////////////////////
// CONSTANTS
/////////////////////////


/////////////////////////
// PROTOTYPES
/////////////////////////


// FILE: lib_nais_xp        FUNCTION: XP_GiveVirtualXP()
// This will store virtual XP on oCreature. It will give the nAmount
// of Virtual XP to oCreature.  sVarMod is only used when tracking multiple
// virtual XP types on a single oCreature.
void XP_GiveVirtualXP(object oCreature,int nAmount,string sVarMod="",int bAnnounce=FALSE);


// FILE: lib_nais_xp        FUNCTION: XP_GetVirtualXP()
// This will return how much virtual xp oCreature has.  sVarMod is used when
// accessing modified additional virtual XP types on oCreature.
int XP_GetVirtualXP(object oCreature,string sVarMod="");


// FILE: lib_nais_xp        FUNCTION: XP_TransferVirtualXP()
// This will transfer virtual XP to actual XP on oCreature.
void XP_TransferVirtualXP(object oCreature,string sVarMod="");


// FILE: lib_nais_xp        FUNCTION: XP_AwardVirtual()
// This function is used to determine how much XP to award oTarget for killing
// oCreatureKilled. This will also handle the awards to the leader of the team
// if they are on the lair and those rules are enabled.
void XP_AwardVirtual(object oTarget,object oCreatureKilled,string sVarMod="",int bAnnounce=FALSE);

/////////////////////////
// FUNCTIONS
/////////////////////////


void XP_GiveVirtualXP(object oCreature,int nAmount,string sVarMod="",int bAnnounce=FALSE)
{ // PURPOSE: To Give virtual XP
    int nCur;
    string sVar="nVXP"+sVarMod;
    string sPID;
    if (GetIsObjectValid(oCreature)&&GetObjectType(oCreature)==OBJECT_TYPE_CREATURE)
    { // creature
        if (GetIsPC(oCreature))
        { // PC
            sPID=GetPCUID(oCreature);
            nCur=NBDE_GetCampaignInt("NAIS1PC",sVar+sPID);
            nCur=nCur+nAmount;
            NBDE_SetCampaignInt("NAIS1PC",sVar+sPID,nCur);
            if (bAnnounce)
            { // announce
                sVar="You have been given "+IntToString(nAmount)+" Virtual XP";
                if (GetStringLength(sVarMod)>0) sVar=sVar+" of type "+sVarMod;
                sVar=sVar+" bringing your total to "+IntToString(nCur)+".";
                SendMessageToPC(oCreature,sVar);
            } // announce
        } // PC
        else
        { // NPC
            nCur=GetLocalInt(oCreature,sVar);
            nCur=nCur+nAmount;
            SetLocalInt(oCreature,sVar,nCur);
        } // NPC
    } // creature
} // XP_GiveVirtualXP()


int XP_GetVirtualXP(object oCreature,string sVarMod="")
{ // PURPOSE: Return the amount of virtual XP
    string sVar="nVXP"+sVarMod;
    string sPID;
    int nRet=0;
    if (GetIsObjectValid(oCreature)&&GetObjectType(oCreature)==OBJECT_TYPE_CREATURE)
    { // valid creature
        if (GetIsPC(oCreature))
        { // PC
            sPID=GetPCUID(oCreature);
            nRet=NBDE_GetCampaignInt("NAIS1PC",sVar+sPID);
        } // PC
        else
        { // NPC
            nRet=GetLocalInt(oCreature,sVar);
        } // NPC
    } // valid creature
    return nRet;
} // XP_GetVirtualXP()


void XP_TransferVirtualXP(object oCreature,string sVarMod="")
{ // PURPOSE: To transfer virtual XP to real XP
    string sVar="nVXP"+sVarMod;
    string sPID;
    int nT;
    int nC;
    if (GetIsObjectValid(oCreature)&&GetObjectType(oCreature)==OBJECT_TYPE_CREATURE)
    { // valid creature
        if (GetIsPC(oCreature))
        { // PC
            sPID=GetPCUID(oCreature);
            nT=XP_GetVirtualXP(oCreature);
            if (nT>0) GiveXPToCreature(oCreature,nT);
            NBDE_DeleteCampaignInt("NAIS1PC",sVar+sPID);
        } // PC
        else
        { // NPC
            nC=GetLocalInt(oCreature,"nXP");
            nT=XP_GetVirtualXP(oCreature,sVarMod);
            SetLocalInt(oCreature,"nXP",nC+nT);
            DeleteLocalInt(oCreature,sVarMod);
        } // NPC
    } // valid creature
} // XP_TransferVirtualXP()


void XP_AwardVirtual(object oTarget,object oCreatureKilled,string sVarMod="",int bAnnounce=FALSE)
{ // PURPOSE: To Award Virtual XP based on killing a target
    string sVar="nVXP"+sVarMod;
    string sTID;
    int nT;
    int nC;
    int nAward;
    int nDiv=1;
    int nRace;
    object oLead;
    if (GetIsObjectValid(oTarget)&&GetIsObjectValid(oCreatureKilled)&&GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
    { // award virtual xp
        nT=GetLevelByPosition(1,oTarget)+GetLevelByPosition(2,oTarget)+GetLevelByPosition(3,oTarget);
        nC=GetLevelByPosition(1,oCreatureKilled)+GetLevelByPosition(2,oCreatureKilled)+GetLevelByPosition(3,oCreatureKilled);
        if (nC<nT)
        { // target is lower level
            nT=nT-nC;
            nAward=0;
            if (nT<6) nAward=50/nT;
        } // target is lower level
        else
        { // target is same level or higher
            nAward=100;
            nT=nC-nT;
            nC=nT*nT*100;
            nAward=nAward+nC;
        } // target is same level or higher
        nRace=GetSkinInt(oTarget,"nPRace");
        if (nRace>0)
        { // virtual race defined
            nC=Race_GetXPDivisor(nRace);
            if (nC>0&&nT<Race_GetXPLevelDivisorCap(nRace)) nDiv=nDiv+nC;
        } // virtual race defined
        nRace=GetSkinInt(oTarget,"nSRace");
        if (nRace>0)
        { // virtual race defined
            nC=Race_GetXPDivisor(nRace);
            if (nC>0&&nT<Race_GetXPLevelDivisorCap(nRace)) nDiv=nDiv+nC;
        } // virtual race defined
        if (nDiv>1)
        { // divide award
            nAward=nAward/nDiv;
            if (nAward<1) nAward=1;
        } // divide award
        nT=NBDE_GetCampaignInt("NAIS1MOD","nXPSpeed");
        if (nT>0&&nT<3)
        { // less XP
            if (nT==1) nAward=nAward/4;
            else if (nT==2) nAward=nAward/2;
        } // less XP
        else if (nT>2)
        { // more XP
            if (nT==3) nAward=nAward*2;
            else if (nT==4) nAward=nAward*3;
        } // more XP
        XP_GiveVirtualXP(oTarget,nAward,sVarMod,bAnnounce);
        nT=NBDE_GetCampaignInt("NAIS1MOD","nXPLeader");
        if (nT>0)
        { // provide XP to leader also
            if (nT==1) nAward=nAward/20;
            else if (nT==2) nAward=nAward/10;
            else { nAward=nAward/5; }
            sTID=Team_GetTeamID(oTarget);
            oLead=GetLocalObject(GetModule(),"oLead_"+sTID);
            if (GetIsObjectValid(oLead)&&oLead!=oTarget)
            { // award leader xp
                if (GetLocalString(GetArea(oLead),"sLair")==sTID)
                { // in lair
                    if (GetIsPC(oLead))
                    { // PC leader
                        GiveXPToCreature(oLead,nAward);
                    } // PC leader
                    else
                    { // NPC leader
                        nT=GetLocalInt(oLead,"nXP");
                        nT=nT+nAward;
                        SetLocalInt(oLead,"nXP",nT);
                    } // NPC Leader
                } // in lair
            } // award leader xp
        } // provide XP to leader also
    } // award virtual xp
} // XP_AwardVirtual()


//void main(){}
