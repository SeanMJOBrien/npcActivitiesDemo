////////////////////////////////////////////////////////////////////////////////
// lib_nais_team - This is the include library for faction, and team control
// By Deva B. Winblood  3/17/2007
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////

#include "lib_nais_var"
#include "x2_inc_itemprop"

////////////////////////
// CONSTANTS
////////////////////////

const int TEAM_RELATION_ENEMY       = -1;
const int TEAM_RELATION_NEUTRAL     = 0;
const int TEAM_RELATION_FRIEND      = 1;
const int STANCE_AGGRESSIVE         = 0;  // AI stance - attack enemy on sight
const int STANCE_PASSIVE_AGGRESSIVE = 1;  // Attack only if attacked
const int STANCE_PASSIVE            = 2;  // Attack under NO circumstances
const int ITEM_COLOR_BROWN          = 2;
const int ITEM_COLOR_GREEN          = 48;
const int ITEM_COLOR_LIGHT_GREEN    = 31;
const int ITEM_COLOR_BLUE           = 26;
const int ITEM_COLOR_BLACK          = 23;
const int ITEM_COLOR_RED            = 37;
const int ITEM_COLOR_YELLOW         = 32;
const int ITEM_COLOR_PURPLE         = 41;
const int ITEM_COLOR_GRAY           = 20;
const int ITEM_COLOR_METAL_GREEN    = 40;
const int ITEM_COLOR_METAL_BLACK    = 3;
const int ITEM_COLOR_METAL_CHROME   = 0;
const int ITEM_COLOR_METAL_RED      = 24;
const int ITEM_COLOR_METAL_YELLOW   = 8;
const int ITEM_COLOR_METAL_BLUE     = 32;

///////////////////////
// PROTOTYPES
///////////////////////


// FILE: lib_nais_team              FUNCTION: Team_JoinTeam()
// This function will remove oTarget from whatever team they are in and will
// set them to the specified team.
void Team_JoinTeam(object oTarget,string sTeamID);


// FILE: lib_nais_team              FUNCTION: Team_EnemyTeams()
// This will set Team 1 and Team 2 to be enemies
void Team_EnemyTeams(string sTeamID1,string sTeamID2);


// FILE: lib_nais_team              FUNCTION: Team_NeutralTeams()
// This will set Team 1 and Team 2 to be neutral
void Team_NeutralTeams(string sTeamID1,string sTeamID2);


// FILE: lib_nais_team              FUNCTION: Team_FriendTeams()
// This will set Team 1 and Team 2 to be friends
void Team_FriendTeams(string sTeamID1,string sTeamID2);


// FILE: lib_nais_team              FUNCTION: Team_SetTeamLeader()
// This will make oTarget the leader of sTeamID
void Team_SetTeamLeader(object oTarget,string sTeamID,int bBackup=FALSE);


// FILE: lib_nais_team              FUNCTION: GetTeamID()
// This function will return the team ID for oTarget
string GetTeamID(object oTarget);


// FILE: lib_nais_team              FUNCTION: Team_GetRelationship()
// This function will return the relationship between the teams.
// 0 = neutral, -1 = enemies, 1 = friends
int Team_GetRelationship(string sTeamID1,string sTeamID2);


// FILE: lib_nais_team              FUNCTION: Team_GetTeamID()
// This is a wrapper function for GetTeamID() - This will return the TeamID
// of oTarget.
string Team_GetTeamID(object oTarget);


// FILE: lib_nais_team              FUNCTION: SetTeamID()
// This is a wrapper function for Team_JoinTeam()
void SetTeamID(object oTarget,string sTeamID);


// FILE: lib_nais_team              FUNCTION: GetNPCUID()
// This function will return a unique ID for the NPC in question.  This will
// only need to be done if they are a very important NPC.
string GetNPCUID(object oNPC);


// FILE: lib_nais_team              FUNCTION: Team_AdjustAlignment()
// This function will adjust oCreatures alignment to fit the team they have
// joined if necessary. The alignment reactions are hard coded within this
// function.
void Team_AdjustAlignment(object oCreature,string sTeamID);


// FILE: lib_nais_team              FUNCTION: Team_GetTeamName()
// This function will get the team name to match the sTeamID.   For purposes
// of this module this function provides hard coded names from within this
// function.
string Team_GetTeamName(string sTeamID);


// FILE: lib_nais_team              FUNCTION: Team_GetPrimaryColor()
// This will return the primary color of the item to use for the team sent.
int Team_GetPrimaryColor(string sTeamID);


// FILE: lib_nais_team              FUNCTION: Team_GetSecondaryColor()
// This will return the secondary color of the item to use for the team sent.
int Team_GetSecondaryColor(string sTeamID);

// FILE: lib_nais_team              FUNCTION: Team_GetMetalColor()
// This will return the color of metal for the team.
int Team_GetMetalColor(string sTeamID);


// FILE: lib_nais_team              FUNCTION: Team_ColorItem()
// This will color oItem to match the colors of sTeamID
void Team_ColorItem(object oItem,string sTeamID);

// FILE: lib_nais_team              FUNCTION: Team_GiveEquipment()
// Give starting equipment
void Team_GiveEquipment(object oPC);

// FILE: lib_nais_team              FUNCTION: Team_GiveStartingGold()
// This will give oPC the starting gold based on game setting level.
void Team_GiveStartingGold(object oPC);


// FILE: lib_nais_team              FUNCTION: Team_GetTeamLeaderDB()
// This will retrieve the current team leader information from the DB
string Team_GetTeamLeaderDB(string sTeamID,int bBackup=FALSE);


// FILE: lib_nais_team              FUNCTION: Team_GetTeamLeader()
// This will return the handle to the team leader object.
object Team_GetTeamLeader(string sTeamID,int bBackup=FALSE);


// FILE: lib_nais_team              FUNCTION: Team_TransferInventory()
// This will transfer inventory from one object to another. If oTo is
// OBJECT_INVALID it will put the items on the ground. It will return the
// total gold piece value of everything transferred. If bDroppableOnly is set to
// TRUE then it will only transfer items flagged as dropable.  If bNoRelics is set to true
// then any item with a resref starting with res_relic will not be dropped.
int Team_TransferInventory(object oFrom,object oTo=OBJECT_INVALID,int bDroppableOnly=FALSE,int bNoRelics=FALSE);


///////////////////////
// FUNCTIONS
///////////////////////



void fnTeam_AdjustFactions(object oTarget,string sTeamID)
{ // PURPOSE: Adjust faction reputation of oTarget
    int nTeam=1;
    string sID;
    object oProxy;
    object oMod=GetModule();
    int nRep;
    sID=GetLocalString(oMod,"sTeamIDs"+IntToString(nTeam));
    while(GetStringLength(sID)>0)
    { // set reputations
        nRep=Team_GetRelationship(sTeamID,sID);
        oProxy=GetObjectByTag("proxy_"+sID);
        if (sTeamID==sID||nRep==TEAM_RELATION_FRIEND)
        { // friend
            SetIsTemporaryFriend(oProxy,oTarget);
            SetIsTemporaryFriend(oTarget,oProxy);
            AdjustReputation(oTarget,oProxy,100);
        } // friend
        else if (nRep==TEAM_RELATION_NEUTRAL)
        { // neutral
            SetIsTemporaryNeutral(oProxy,oTarget);
            SetIsTemporaryNeutral(oTarget,oProxy);
            AdjustReputation(oTarget,oProxy,50);
        } // neutral
        else
        { // enemy
            SetIsTemporaryEnemy(oProxy,oTarget);
            SetIsTemporaryEnemy(oTarget,oProxy);
            AdjustReputation(oTarget,oProxy,-100);
        } // enemy
        nTeam=nTeam+1;
        sID=GetLocalString(oMod,"sTeamIDs"+IntToString(nTeam));
    } // set reputations
} // fnTeam_AdjustFactions()



void Team_JoinTeam(object oTarget,string sTeamID)
{ // PURPOSE: Cause oTarget to join the team sTeamID
    string sUID=GetPCUID(oTarget);
    object oItem;
    SetSkinString(oTarget,"sTeamID",sTeamID);
    if (!GetIsPC(oTarget)) SetLocalString(oTarget,"sTeamID",sTeamID);
    if (GetStringLength(sUID)>3)
    { // set on DB
        NBDE_SetCampaignString("NAIS1PC","s"+sUID+"_TID",sTeamID,oTarget);
        SetLocalObject(GetModule(),"oPC_"+sUID,oTarget);
    } // set on DB
    oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oTarget);
    if (GetIsObjectValid(oItem)) Team_ColorItem(oItem,sTeamID);
    oItem=GetItemInSlot(INVENTORY_SLOT_HEAD,oTarget);
    if (GetIsObjectValid(oItem)) Team_ColorItem(oItem,sTeamID);
    AssignCommand(oTarget,fnTeam_AdjustFactions(oTarget,sTeamID));
} // Team_JoinTeam()


void SetTeamID(object oTarget,string sTeamID)
{ // PURPOSE: Wraps Team_JoinTeam()
    Team_JoinTeam(oTarget,sTeamID);
} // SetTeamID()


string GetTeamID(object oTarget)
{ // PURPOSE: To return the sTeamID of oTarget
    string sID=GetLocalString(oTarget,"sTeamID");
    if (GetIsPC(oTarget)) sID=GetSkinString(oTarget,"sTeamID");
    return sID;
} // GetTeamID()


string Team_GetTeamID(object oTarget)
{ // PURPOSE: Wraps GetTeamID()
    return GetTeamID(oTarget);
} // Team_GetTeamID()


void Team_EnemyTeams(string sTeamID1,string sTeamID2)
{ // PURPOSE: Set the teams to be enemies
    NBDE_SetCampaignInt("NAIS1TEAM","nREL"+sTeamID1+"_"+sTeamID2,TEAM_RELATION_ENEMY);
    NBDE_SetCampaignInt("NAIS1TEAM","nREL"+sTeamID2+"_"+sTeamID1,TEAM_RELATION_ENEMY);
} // Team_EnemyTeams()


void Team_NeutralTeams(string sTeamID1,string sTeamID2)
{ // PURPOSE: Set the teams to be neutral
    NBDE_SetCampaignInt("NAIS1TEAM","nREL"+sTeamID1+"_"+sTeamID2,TEAM_RELATION_NEUTRAL);
    NBDE_SetCampaignInt("NAIS1TEAM","nREL"+sTeamID2+"_"+sTeamID1,TEAM_RELATION_NEUTRAL);
} // Team_NeutralTeams()


void Team_FriendTeams(string sTeamID1,string sTeamID2)
{ // PURPOSE: Set the teams to be friends
    NBDE_SetCampaignInt("NAIS1TEAM","nREL"+sTeamID1+"_"+sTeamID2,TEAM_RELATION_FRIEND);
    NBDE_SetCampaignInt("NAIS1TEAM","nREL"+sTeamID2+"_"+sTeamID1,TEAM_RELATION_FRIEND);
} // Team_FriendTeams()


int Team_GetRelationship(string sTeamID1,string sTeamID2)
{ // PURPOSE: Return the relationship between the two teams
    return NBDE_GetCampaignInt("NAIS1TEAM","nREL"+sTeamID1+"_"+sTeamID2);
} // Team_GetRelationship()

void Team_SetTeamLeader(object oTarget,string sTeamID,int bBackup=FALSE)
{ // PURPOSE: Set Leader
  // s<TeamID>_Lead = UID, or NPC_<ID>
  // IF NPC
  // sNPC_<NPCID>_res = resref
  // sNPC_<NPCID>_tag = tag
  // sNPC_<NPCID>_name = name
  // sNPC_<NPCID>_armor = equipped armor resref
  // sNPC_<NPCID>_weapon = equipped weapon resref
  // lNPC_<NPCID>_loc = location
  // nNPC_<NPCID>_app = appearance
  // nNPC_<NPCID>_pheno = phenotype
  // nNPC_<NPCID>_head = head
    string sS;
    string sSufix="_Lead";
    string sPrefix="oLead_";
    if (GetIsObjectValid(oTarget)&&GetStringLength(sTeamID)>0&&GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
    { // parameters were valid
        if (GetIsPC(oTarget))
        { // PC is the Leader
            if (bBackup) { sSufix="_BLead"; sPrefix="oBLead_"; }
            sS=GetPCUID(oTarget);
            NBDE_SetCampaignString("NAIS1TEAM","s"+GetStringLowerCase(sTeamID)+sSufix,sS);
            SetLocalObject(GetModule(),"oPC_"+sS,oTarget);
            SetLocalObject(GetModule(),sPrefix+GetStringLowerCase(sTeamID),oTarget);
        } // PC is the Leader
        else
        { // NPC is the Leader
            sS=GetNPCUID(oTarget);
            NBDE_SetCampaignString("NAIS1TEAM","s"+GetStringLowerCase(sTeamID)+sSufix,"NPC_"+sS);
            SetLocalObject(GetModule(),sPrefix+GetStringLowerCase(sTeamID),oTarget);
        } // NPC is the Leader
    } // parameters were valid
    else
    { // bad
        PrintString("Error [lib_nais_team] Team_SetTeamLeader("+GetName(oTarget)+","+sTeamID+")");
    } // bad
} // Team_SetTeamLeader()


string GetNPCUID(object oNPC)
{ // PURPOSE: Return a Unique ID for an NPC
    if (GetStringLength(GetLocalString(oNPC,"sNPCUID"))>3) return GetLocalString(oNPC,"sNPCUID");
    int nID=Random(999999);
    string sID="NID"+IntToString(nID);
    string sChk=NBDE_GetCampaignString("NAIS1TEAM","sNPC_"+sID+"_res");
    while(GetStringLength(sChk)>0)
    { // find unused id
        nID++;
        sID="NID"+IntToString(nID);
        sChk=NBDE_GetCampaignString("NAIS1TEAM","sNPC_"+sID+"_res");
    } // find unused id
    SetLocalString(oNPC,"sNPCUID",sID);
    NBDE_SetCampaignString("NAIS1TEAM","sNPC_"+sID+"_res",GetResRef(oNPC));
    NBDE_SetCampaignString("NAIS1TEAM","sNPC_"+sID+"_tag",GetTag(oNPC));
    NBDE_SetCampaignString("NAIS1TEAM","sNPC_"+sID+"_name",GetName(oNPC));
    sChk=GetResRef(GetItemInSlot(INVENTORY_SLOT_CHEST,oNPC));
    NBDE_SetCampaignString("NAIS1TEAM","sNPC_"+sID+"_armor",sChk);
    sChk=GetResRef(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oNPC));
    NBDE_SetCampaignString("NAIS1TEAM","sNPC_"+sID+"_weapon",sChk);
    NBDE_SetCampaignLocation("NAIS1TEAM","lNPC_"+sID+"_loc",GetLocation(oNPC));
    NBDE_SetCampaignInt("NAIS1TEAM","nNPC_"+sID+"_app",GetAppearanceType(oNPC));
    NBDE_SetCampaignInt("NAIS1TEAM","nNPC_"+sID+"_pheno",GetPhenoType(oNPC));
    NBDE_SetCampaignInt("NAIS1TEAM","nNPC_"+sID+"_head",GetCreatureBodyPart(CREATURE_PART_HEAD,oNPC));
    return sID;
} // GetNPCUID()


void Team_AdjustAlignment(object oCreature,string sTeamID)
{ // PURPOSE: Adjust alignment if need be
    int nAGE=GetAlignmentGoodEvil(oCreature);
    int nALC=GetAlignmentLawChaos(oCreature);
    if (sTeamID=="syl")
    { // sylvan
        if (nAGE!=ALIGNMENT_NEUTRAL&&nALC!=ALIGNMENT_NEUTRAL)
        { // need adjusting
            AdjustAlignment(oCreature,ALIGNMENT_NEUTRAL,100);
        } // need adjusting
    } // sylvan
    else if (sTeamID=="cul")
    { // cultists
        if (nAGE!=ALIGNMENT_EVIL)
        { // adjust
            AdjustAlignment(oCreature,ALIGNMENT_EVIL,100);
        } // adjust
    } // cultists
    else if (sTeamID=="jus")
    { // justicars
        if (nAGE==ALIGNMENT_EVIL)
        { // adjust
            AdjustAlignment(oCreature,ALIGNMENT_GOOD,60);
        } // adjust
        if (nALC==ALIGNMENT_CHAOTIC)
        { // adjust
            AdjustAlignment(oCreature,ALIGNMENT_LAWFUL,60);
        } // adjust
    } // justicars
    else if (sTeamID=="anc")
    { // ancients
        if (nAGE==ALIGNMENT_EVIL)
        { // adjust
            AdjustAlignment(oCreature,ALIGNMENT_GOOD,100);
        } // adjust
    } // ancients
    else if (sTeamID=="hor")
    { // horde
        if (nAGE==ALIGNMENT_GOOD)
        { // adjust
            AdjustAlignment(oCreature,ALIGNMENT_EVIL,100);
        } // adjust
        if (nALC==ALIGNMENT_LAWFUL)
        { // adjust
            AdjustAlignment(oCreature,ALIGNMENT_CHAOTIC,60);
        } // adjust
    } // horde
} // Team_AdjustAlignment()


string Team_GetTeamName(string sTeamID)
{ // PURPOSE: To return the team name
    if (sTeamID=="syl") return "sylvan";
    else if (sTeamID=="hor") return "horde";
    else if (sTeamID=="anc") return "ancients";
    else if (sTeamID=="jus") return "justicars";
    else if (sTeamID=="cul") return "cultists";
    return "unknown";
} // Team_GetTeamName()


int Team_GetPrimaryColor(string sTeamID)
{ // PURPOSE: Return the primary color
    if (sTeamID=="syl") return ITEM_COLOR_GREEN;
    else if (sTeamID=="anc") return ITEM_COLOR_YELLOW;
    else if (sTeamID=="cul") return ITEM_COLOR_BLACK;
    else if (sTeamID=="hor") return ITEM_COLOR_RED;
    else if (sTeamID=="jus") return ITEM_COLOR_BLUE;
    if (d8()<5) return ITEM_COLOR_BROWN;
    return ITEM_COLOR_GRAY;
} // Team_GetPrimaryColor()


int Team_GetSecondaryColor(string sTeamID)
{ // PURPOSE: Return the secondary color
    if (sTeamID=="syl") return ITEM_COLOR_LIGHT_GREEN;
    else if (sTeamID=="anc") return ITEM_COLOR_GREEN;
    else if (sTeamID=="cul") return ITEM_COLOR_PURPLE;
    else if (sTeamID=="hor") return ITEM_COLOR_BLACK;
    else if (sTeamID=="jus") return ITEM_COLOR_GRAY;
    if (d8()<5) return ITEM_COLOR_GRAY;
    return ITEM_COLOR_BROWN;
} // Team_GetSecondaryColor()


int Team_GetMetalColor(string sTeamID)
{ // PURPOSE: Return the metal color
    if (sTeamID=="syl") return ITEM_COLOR_METAL_GREEN;
    else if (sTeamID=="anc") return ITEM_COLOR_METAL_YELLOW;
    else if (sTeamID=="cul") return ITEM_COLOR_METAL_BLACK;
    else if (sTeamID=="hor") return ITEM_COLOR_METAL_RED;
    else if (sTeamID=="jus") return ITEM_COLOR_METAL_BLUE;
    return ITEM_COLOR_METAL_CHROME;
} // Team_GetMetalColor()



void libteam_Color(object oItem,int nPrime,int nSecond,int nMetal,int nSlot=-1)
{ // PURPOSE: do the color change
    object oNew;
    object oCreature=GetItemPossessor(oItem);
    object oChest=GetObjectByTag("HOLDING_CHEST");
    object oCopy=CopyItem(oItem,oChest,TRUE);
    oNew=IPDyeArmor(oCopy,ITEM_APPR_ARMOR_COLOR_CLOTH1,nPrime);
    oNew=IPDyeArmor(oNew,ITEM_APPR_ARMOR_COLOR_CLOTH2,nSecond);
    oNew=IPDyeArmor(oNew,ITEM_APPR_ARMOR_COLOR_LEATHER1,nPrime);
    oNew=IPDyeArmor(oNew,ITEM_APPR_ARMOR_COLOR_LEATHER2,nSecond);
    oNew=IPDyeArmor(oNew,ITEM_APPR_ARMOR_COLOR_METAL1,nMetal);
    oNew=IPDyeArmor(oNew,ITEM_APPR_ARMOR_COLOR_METAL2,nMetal);
    DestroyObject(oItem);
    oCopy=CopyItem(oNew,oCreature,TRUE);
    DestroyObject(oNew);
    SetLocalString(oCopy,"sTeamID",Team_GetTeamID(oCreature));
    if (nSlot!=-1&&GetIsObjectValid(oCreature)) AssignCommand(oCreature,lib_ForceEquip(oCreature,oCopy,nSlot));
} // libteam_Color()


void Team_ColorItem(object oItem,string sTeamID)
{ // PURPOSE: Color the item to match the team
    int nPrime=Team_GetPrimaryColor(sTeamID);
    int nSecond=Team_GetSecondaryColor(sTeamID);
    int nMetal=Team_GetMetalColor(sTeamID);
    object oNew;
    object oCreature=GetItemPossessor(oItem);
    int nSlot=-1;
    if (GetLocalString(oItem,"sTeamID")==sTeamID) return;
    if (GetIsObjectValid(oItem)&&GetObjectType(oItem)==OBJECT_TYPE_ITEM)
    { // valid
        if (GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature)==oItem) nSlot=INVENTORY_SLOT_CHEST;
        else if (GetItemInSlot(INVENTORY_SLOT_HEAD,oCreature)==oItem) nSlot=INVENTORY_SLOT_HEAD;
        if (nSlot!=-1)
        { // equipped
            AssignCommand(oCreature,ClearAllActions());
            AssignCommand(oCreature,ActionUnequipItem(oItem));
            AssignCommand(oCreature,ActionDoCommand(libteam_Color(oItem,nPrime,nSecond,nMetal,nSlot)));
        } // equipped
        else
        { // not equipped
            libteam_Color(oItem,nPrime,nSecond,nMetal);
        } // not equipped
    } // valid
} // Team_ColorItem()


void Team_GiveEquipment(object oPC)
{ // PURPOSE: Give equipment based on team
    string sTID=Team_GetTeamID(oPC);
    string sRes;
    object oItem;
    int nClass=GetClassByPosition(1,oPC);
    int nRace=GetRacialType(oPC);
    int bSmallRace=FALSE;
    int nGender=GetGender(oPC);
    if (nRace==RACIAL_TYPE_DWARF||nRace==RACIAL_TYPE_GNOME||nRace==RACIAL_TYPE_HALFLING) bSmallRace=TRUE;
    // Tower Shield
    if ((nClass==CLASS_TYPE_PALADIN||(nClass==CLASS_TYPE_FIGHTER&&d20()<6))&&!bSmallRace)
    { // tower shield
        sRes="ts_"+sTID;
        oItem=CreateItemOnObject(sRes,oPC);
    } // tower shield
    else if (nClass==CLASS_TYPE_FIGHTER||nClass==CLASS_TYPE_PALADIN||((nClass==CLASS_TYPE_BARBARIAN||nClass==CLASS_TYPE_CLERIC)&&d20()<11))
    { // large shield
        sRes="ts_"+sTID;
        oItem=CreateItemOnObject(sRes,oPC);
    } // large shield
    else if (nClass==CLASS_TYPE_BARBARIAN||nClass==CLASS_TYPE_CLERIC)
    { // small shield
        sRes="nw_ashsw001";
        oItem=CreateItemOnObject(sRes,oPC);
    } // small shield
    if (nClass==CLASS_TYPE_BARBARIAN||nClass==CLASS_TYPE_FIGHTER||nClass==CLASS_TYPE_PALADIN)
    { // helmet
        sRes="helm_"+sTID;
        oItem=CreateItemOnObject(sRes,oPC);
    } // helmet
    if (sTID=="hor")
    { // horde
        if (d6()<4) sRes="nw_ashsw001";
        else if (nGender==GENDER_FEMALE) sRes="zep_commonw";
        else { sRes="zep_common"; }
        oItem=CreateItemOnObject(sRes,oPC);
        sRes="";
        if (nClass==CLASS_TYPE_FIGHTER&&d20()<11) sRes="zep_goblin";
        else if (nClass==CLASS_TYPE_FIGHTER||nClass==CLASS_TYPE_BARBARIAN||nClass==CLASS_TYPE_CLERIC||nClass==CLASS_TYPE_PALADIN||nClass==CLASS_TYPE_RANGER) sRes="medarm_hor";
        else if (nClass==CLASS_TYPE_DRUID) sRes="zep_druidarmor";
        else if (nClass==CLASS_TYPE_BARD) sRes="zep_studdedleath";
        else if (nClass==CLASS_TYPE_ROGUE) sRes="nais_leather";
        else if (nClass==CLASS_TYPE_SORCERER) sRes="x2_cloth008";
        else if (nClass==CLASS_TYPE_WIZARD) sRes="zep_wizrobes";
        if (GetStringLength(sRes)>0)
        { // more
            oItem=CreateItemOnObject(sRes,oPC);
            sRes="";
        } // more
    } // horde
    else if (sTID=="syl")
    { // sylvan
        if (d6()<4) sRes="zep_brownieoutf";
        else if (nGender==GENDER_FEMALE) sRes="zep_commonw";
        else { sRes="zep_common"; }
        oItem=CreateItemOnObject(sRes,oPC);
        sRes="";
        if (nClass==CLASS_TYPE_FIGHTER&&d20()<11) sRes="nw_aarcl005";
        else if (nClass==CLASS_TYPE_FIGHTER||nClass==CLASS_TYPE_BARBARIAN||nClass==CLASS_TYPE_CLERIC||nClass==CLASS_TYPE_PALADIN||nClass==CLASS_TYPE_RANGER) sRes="medarm_syl";
        else if (nClass==CLASS_TYPE_DRUID) sRes="zep_druidarmor";
        else if (nClass==CLASS_TYPE_BARD) sRes="zep_studdedleath";
        else if (nClass==CLASS_TYPE_ROGUE) sRes="nais_leather";
        else if (nClass==CLASS_TYPE_SORCERER) sRes="x2_cloth008";
        else if (nClass==CLASS_TYPE_WIZARD) sRes="zep_wizrobes";
        if (GetStringLength(sRes)>0)
        { // more
            oItem=CreateItemOnObject(sRes,oPC);
            sRes="";
        } // more
    } // sylvan
    else if (sTID=="anc")
    { // ancients
        if (d6()<4) sRes="nw_cloth007";
        else if (nGender==GENDER_FEMALE) sRes="zep_commonw";
        else { sRes="zep_common"; }
        oItem=CreateItemOnObject(sRes,oPC);
        sRes="";
        if (nClass==CLASS_TYPE_FIGHTER&&d20()<11) sRes="nw_aarcl005";
        else if (nClass==CLASS_TYPE_FIGHTER||nClass==CLASS_TYPE_BARBARIAN||nClass==CLASS_TYPE_CLERIC||nClass==CLASS_TYPE_PALADIN||nClass==CLASS_TYPE_RANGER) sRes="medarm_anc";
        else if (nClass==CLASS_TYPE_DRUID) sRes="zep_druidarmor";
        else if (nClass==CLASS_TYPE_BARD) sRes="zep_studdedleath";
        else if (nClass==CLASS_TYPE_ROGUE) sRes="nais_leather";
        else if (nClass==CLASS_TYPE_SORCERER) sRes="zep_evoker";
        else if (nClass==CLASS_TYPE_WIZARD) sRes="zep_wizrobes";
        if (GetStringLength(sRes)>0)
        { // more
            oItem=CreateItemOnObject(sRes,oPC);
            sRes="";
        } // more
    } // ancients
    else if (sTID=="cul")
    { // cultists
        if (d6()<4) sRes="nw_cloth007";
        else if (nGender==GENDER_FEMALE) sRes="zep_commonw";
        else { sRes="zep_common"; }
        oItem=CreateItemOnObject(sRes,oPC);
        sRes="";
        if (nClass==CLASS_TYPE_FIGHTER&&d20()<11) sRes="zep_goblin";
        else if (nClass==CLASS_TYPE_FIGHTER||nClass==CLASS_TYPE_BARBARIAN||nClass==CLASS_TYPE_CLERIC||nClass==CLASS_TYPE_PALADIN) sRes="medarm_cul";
        else if (nClass==CLASS_TYPE_DRUID) sRes="zep_druidarmor";
        else if (nClass==CLASS_TYPE_BARD||nClass==CLASS_TYPE_RANGER) sRes="zep_studdedleath";
        else if (nClass==CLASS_TYPE_ROGUE) sRes="nais_leather";
        else if (nClass==CLASS_TYPE_SORCERER) sRes="zep_evoker";
        else if (nClass==CLASS_TYPE_WIZARD) sRes="zep_wizrobes";
        if (GetStringLength(sRes)>0)
        { // more
            oItem=CreateItemOnObject(sRes,oPC);
            sRes="";
        } // more
    } // cultists
    else if (sTID=="jus")
    { // justicars
        if (d6()<4) sRes="zep_formalkilt";
        else if (nGender==GENDER_FEMALE) sRes="zep_commonw";
        else { sRes="zep_formalkilt"; }
        oItem=CreateItemOnObject(sRes,oPC);
        sRes="";
        if (nClass==CLASS_TYPE_FIGHTER&&d20()<11) sRes="nw_aarcl005";
        else if (nClass==CLASS_TYPE_FIGHTER||nClass==CLASS_TYPE_BARBARIAN||nClass==CLASS_TYPE_CLERIC||nClass==CLASS_TYPE_PALADIN) sRes="medarm_jus";
        else if (nClass==CLASS_TYPE_DRUID) sRes="zep_druidarmor";
        else if (nClass==CLASS_TYPE_BARD||nClass==CLASS_TYPE_RANGER) sRes="zep_studdedleath";
        else if (nClass==CLASS_TYPE_ROGUE) sRes="nais_leather";
        else if (nClass==CLASS_TYPE_SORCERER) sRes="x2_cloth008";
        else if (nClass==CLASS_TYPE_WIZARD) sRes="zep_wizrobes";
        if (GetStringLength(sRes)>0)
        { // more
            oItem=CreateItemOnObject(sRes,oPC);
            sRes="";
        } // more
    } // justicars
} // Team_GiveEquipment()


void Team_GiveStartingGold(object oPC)
{ // PURPOSE: To give starting gold
    int nBase=100;
    int nClass=GetClassByPosition(1,oPC);
    int nStartLevel=NBDE_GetCampaignInt("NAIS1MOD","nStartingLevel");
    if (nStartLevel<1) nStartLevel=1;
    if (GetIsObjectValid(oPC)&&GetObjectType(oPC)==OBJECT_TYPE_CREATURE)
    { // starting gold
        if (nClass==CLASS_TYPE_BARBARIAN||nClass==CLASS_TYPE_CLERIC) nBase=200;
        else if (nClass==CLASS_TYPE_BARD||nClass==CLASS_TYPE_ROGUE) nBase=150;
        else if (nClass==CLASS_TYPE_FIGHTER||nClass==CLASS_TYPE_PALADIN) nBase=300;
        else if (nClass==CLASS_TYPE_RANGER) nClass==250;
        else if (nClass==CLASS_TYPE_MONK) nClass=50;
        nBase=(nBase*nStartLevel);
        if (nStartLevel>14) nBase=nBase*15;
        GiveGoldToCreature(oPC,nBase);
    } // starting gold
} // Team_GiveStartingGold()


string Team_GetTeamLeaderDB(string sTeamID,int bBackup=FALSE)
{ // PURPOSE: Get the Team Leader from the database
    string sSufix="_Lead";
    if (bBackup) sSufix="_BLead";
    return NBDE_GetCampaignString("NAIS1TEAM","s"+GetStringLowerCase(sTeamID)+sSufix);
} // Team_GetTeamLeaderDB()


object Team_GetTeamLeader(string sTeamID,int bBackup=FALSE)
{ // PURPOSE: To retrieve the leader from the module object
    string sPrefix="oLead_";
    if (bBackup) sPrefix="oBLead_";
    return GetLocalObject(GetModule(),sPrefix+GetStringLowerCase(sTeamID));
} // Team_GetTeamLeader()


int Team_TransferInventory(object oFrom,object oTo=OBJECT_INVALID ,int bDroppableOnly=FALSE,int bNoRelics=FALSE)
{ // PURPOSE: Transfer inventory
    int nV=0;
    object oItem;
    int nN;
    object oCopy;
    object oCorpse=oTo;
    object oMe=oFrom;
    int bDrop;
    oItem=GetFirstItemInInventory(oMe);
           while(GetIsObjectValid(oItem))
           { // transfer inventory
               nN=GetItemStackSize(oItem);
               bDrop=TRUE;
               if (!GetDroppableFlag(oItem)&&bDroppableOnly) bDrop=FALSE;
               if (bNoRelics&&GetStringLeft(GetResRef(oItem),9)=="res_relic") { bDrop=FALSE; SetDroppableFlag(oItem,FALSE); }
               if (bDrop)
               { // drop
                   if (GetIsObjectValid(oTo))
                   { // target exists
                       if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                       else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
                   } // target exists
                   else
                   { // copy on ground
                       if (nN==0) nN=1;
                       oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                       SetName(oCopy,GetName(oItem));
                       SetItemStackSize(oCopy,nN);
                   } // copy on ground
                   nV=nV+GetGoldPieceValue(oItem);
                   AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
               } // drop
               oItem=GetNextItemInInventory(oMe);
           } // transfer inventory
           oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_BELT,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_BOOTS,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_CLOAK,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_HEAD,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_LEFTRING,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_NECK,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
           oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oMe);
           if (GetIsObjectValid(oItem))
           { // copy
               nN=GetItemStackSize(oItem);
               nV=nV+GetGoldPieceValue(oItem);
               if (GetIsObjectValid(oTo))
               { // target exists
                   if (nN<2) oCopy=CopyItem(oItem,oCorpse,TRUE);
                   else { oCopy=CreateItemOnObject(GetResRef(oItem),oCorpse,nN,GetTag(oItem));  SetName(oCopy,GetName(oItem)); }
               } // target exists
               else
               { // copy on ground
                   if (nN==0) nN=1;
                   oCopy=CreateObject(OBJECT_TYPE_ITEM,GetResRef(oItem),GetLocation(oMe),FALSE,GetTag(oItem));
                   SetName(oCopy,GetName(oItem));
                   SetItemStackSize(oCopy,nN);
               } // copy on ground
               AssignCommand(GetModule(),DelayCommand(0.1,DestroyObject(oItem)));
           } // copy
    return nV;
} // Team_TransferInventory()


//void main(){}
