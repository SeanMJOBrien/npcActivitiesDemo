////////////////////////////////////////////////////////////////////////////////
// lib_nais_unit - Unit specific library for Unit commands
// By Deva B. Winblood.  10/10/2007
////////////////////////////////////////////////////////////////////////////////

#include "lib_nais_team"
#include "lib_nais_move"
#include "lib_nais_persist"
#include "lib_nais_area"

////////////////////////////
// CONSTANTS
////////////////////////////

const int UNIT_TYPE_COMMON             = 0;
const int UNIT_TYPE_SPECIALIST         = 1;
const int UNIT_TYPE_OUTDOOR_LOW        = 2;
const int UNIT_TYPE_OUTDOOR_MEDIUM     = 3;
const int UNIT_TYPE_OUTDOOR_HIGH       = 4;
const int UNIT_TYPE_GUARD_LOW          = 5;
const int UNIT_TYPE_GUARD_MEDIUM       = 6;
const int UNIT_TYPE_GUARD_HIGH         = 7;
const int UNIT_TYPE_SQUAD_LEADER       = 8;
const int UNIT_TYPE_SQUAD_MEMBER       = 9;

const int UNIT_BUILDER_TYPE_PLACEABLE  = 0;
const int UNIT_BUILDER_TYPE_PC         = 1;
const int UNIT_BUILDER_TYPE_NPC        = 2;
const int UNIT_BUILDER_TYPE_SQUAD_LEAD = 3;

const int STATE_AGGRESSIVE             = 0;
const int STATE_PASSIVE                = 1;
const int STATE_PASSIVE_AGGRESSIVE     = 2;

////////////////////////////
// PROTOTYPES
////////////////////////////


// FILE: lib_nais_unit          FUNCTION: Unit_GetWaypointString()
// This function will return the waypoint that defines this unit type.  It
// will return OBJECT_INVALID if the waypoint does not exist.
// This is defined as:
// <teamid>_<unittype>_#
// The unit type strings are COMMON, SPECIAL, OUTLOW, OUTMID, OUTHIGH,
// GUARDLOW, GUARDMID, GUARDHIGH, SQUADL, and SQUAD
object Unit_GetWaypoint(string sTeamID,int nUnitType,int nN=1);


// FILE: lib_nais_unit          FUNCTION: Unit_GetUnitName()
// This function will return the name of the unit defined by the specified
// waypoint.  Stored as sName on the waypoint.
string Unit_GetUnitName(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetUnitTag()
// This function will return the tag of the unit defined by the specified
// waypoint.  Stored as sTag on the waypoint.
string Unit_GetUnitTag(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetRandomResRef()
// This function will return the resref to use for this unit as defined on the
// specified waypoint.   This is stored in sResRef in the format of #/resref/
// resref/resref where # is the number of different resrefs and each resref
// is separated by slashes.   1/resref is what you would want to use if there
// is only a single resref that should be returned each time.
string Unit_GetRandomResRef(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetRandomAppearance()
// This function will return a random appearance number to use for this unit.
// if -1 is returned then it will use the appearance on the resref.  This is
// stored on the waypoint as sRApp and is stored in the format #/appearance/
// appearance .  The # is the number of random appearances to choose from.  This
// is useful for making a single blueprint be able to have multiple appearances.
// appearance is the appearance number as found in appearance.2da
int Unit_GetRandomAppearance(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetTail()
// This function will return the tail number to use for this unit as specified
// on waypoint with the variable nTail.   If the value is -1 then it will not
// alter the tail the unit already has.
int Unit_GetTail(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetWings()
// This function will return the wings number to use for this unit as specified
// on waypoint with the variable nWings.   If the value is -1 then it will not
// alter the wings the unit already has.
int Unit_GetWings(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetEventWP()
// This function will return the EventWP (see lib_nais_wrap) to use with this
// unit.  It is stored as sEEventWP on the waypoint.
string Unit_GetEventWP(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetDialog()
// This function will return the special dialog that this unit should use
// when someone from the same team targets them with an interaction item.  This
// is stored as sDialog on the waypoint.
string Unit_GetDialog(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetRandomRightHandItem()
// This function will return a random item to equip in the units right hand.
// This is stored on the waypoint as sRightHand in the format #/resref/resref
// where # is the number of resrefs to randomly choose from and resref is the
// resref of the item to create and then equip on this unit.
string Unit_GetRandomRightHandItem(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetRandomLeftHandItem()
// This function will return a random item to equip in the units left hand.
// This is stored on the waypoint as sLeftHand in the format #/resref/resref
// where # is the number of resrefs to randomly choose from and resref is the
// resref of the item to create and then equip on this unit.
string Unit_GetRandomLeftHandItem(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetAmmo()
// This function will return the resref of the ammo to create upon this unit.
// This is stored on the waypoint as sAmmo.
string Unit_GetAmmo(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetRandomArmor()
// This function will return a random set of armor or clothes to equip on the
// chest slot of the NPC.  It is stored on the waypoint as sArmor in the format
// #/resref/resef.
string Unit_GetRandomArmor(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetCorpse()
// This will return the resref of any corpse object that should be used for
// this NPC.   It is stored on the waypoint as sCorpse.
string Unit_GetCorpse(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetCombatStyle()
// This will return the combat style to be used for this NPC that is stored
// on the waypoint as sCombatStyle.   The valid values are as follows:
// D or none = default, RF = Ranged Flee, R = Ranged, M = Melee, S = Summon,
// MD = Magic Distance, MB = Magic Buff, MC = Magic Close, MON = Monster,
// SN = Sneak, MS = Magic Stealth, AS = Assassin.
string Unit_GetCombatStyle(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetResourceReq()
// This will return the resource required in the format resource#/amount which
// is stored on the waypoint.  nN is the resource required starting with 1.
string Unit_GetResourceReq(object oWaypoint,int nN=1);


// FILE: lib_nais_unit          FUNCTION: Unit_PlaceableExistsReq()
// This will return the tag of a placeable that must exist in the module some-
// where as stored on the waypoint as variable sPlaceExists#
string Unit_PlaceableExistsReq(object oWaypoint,int nN=1);


// FILE: lib_nais_unit          FUNCTION: Unit_PlaceableInAreaReq()
// This will return the tag of placeable that must exist in this area.  This
// will be stored on the waypoint as variable sPlaceArea#
string Unit_PlaceableInAreaReq(object oWaypoint,int nN=1);


// FILE: lib_nais_unit          FUNCTION: Unit_UnitExistsReq()
// This will return the tag of a unit that must exist in the module.  This will
// be stored on the waypoint as variable sUnitExists#
string Unit_UnitExistsReq(object oWaypoint,int nN=1);


// FILE: lib_nais_unit          FUNCTION: Unit_ControlAreaReq()
// This will return the tag of areas that must be controlled by the team
// for this unit to appear.  This is stored on the waypoint as sControlArea#
string Unit_ControlAreaReq(object oWaypoint,int nN=1);


// FILE: lib_nais_unit          FUNCTION: Unit_ItemConsumeReq()
// This will return the tag of an item that must be in misc storage which will
// be consumed to create this unit.  This is stored on the waypoint as
// sItemConsume#.
string Unit_ItemConsumeReq(object oWaypoint,int nN=1);


// FILE: lib_nais_unit          FUNCTION: Unit_GetSpawnScript()
// This will return the special script this NPC type should run when it is
// spawned and it is stored as sSpawnScript on the waypoint.
string Unit_GetSpawnScript(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_PersistScript()
// This will return the persistent script this NPC should run once it has been
// spawned and that it should consistently run as long as a PC or enemy is in
// range.   This is stored on the waypoint as sPersistScript.
string Unit_PersistScript(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_SquadLeaderReq()
// This will return what team Squad Leader Type number must exist for this
// NPC to be spawned.   This is stored on the waypoint as nSquadLeaderReq
int Unit_SquadLeaderReq(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetKillerScript()
// This will return the killer script that should be used whenever this npc
// kills a target.  This is stored on the waypoint as sKillerScript
string Unit_GetKillerScript(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetRandomHelmet()
// This will return a random helmet item that should be equipped and used by
// the NPC.  It is stored on the waypoint as sHelmet in the format
// #/resref/resref/resref.
string Unit_GetRandomHelmet(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GiveBonusItems()
// This will create bonus items on oUnit as defined on the waypoint with resrefs
// sBonusItem in the format resref/resref/resref.
void Unit_GiveBonusItems(object oWaypoint,object oUnit);


// FILE: lib_nais_unit          FUNCTION: Unit_GetPopulationLimit()
// This will return the maximum number of this type of unit allowed in the
// module.  This is stored on the waypoint as nPopulationLimit
int Unit_GetPopulationLimit(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetReqAreaType()
// This will return the required area type that the builder must be in if this
// unit is to spawned.  It is stored on the waypoint as nReqAreaType and the
// following values are valid. 0 = none, 1 = above ground, 2 = below ground,
// 3 = outer planes
int Unit_GetReqAreaType(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetRandomHead()
// This will return a random head from sHead which is stored on the waypoint
// in the format #/head/head/head/head.   If it returns -1 then there is no
// random head to be used.
int Unit_GetRandomHead(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetPlaceableVarValue()
// This will return the value that must be set on the placeable that is building
// the unit.   It is stored on the waypoint as nPlaceVar.   If the value is not
// 0 then the value on the placeable for variable nCategory must match this
// number.
int Unit_GetPlaceableVarValue(object oWaypoint);


// FILE: lib_nais_unit          FUNCTION: Unit_GetCanBuild()
// This will return TRUE if oBuilder can build the specified unit.  It will
// return FALSE if the unit cannot be built.
int Unit_GetCanBuild(object oWaypoint,object oBuilder,int bVerbose=FALSE);


// FILE: lib_nais_unit          FUNCTION: Unit_GetBuildRequirements()
// This will return a string of what things are required to build this unit.
// It will check the waypoint for sBuildReq first and if that is defined it will
// simply return that to conserve CPU usage.
string Unit_GetBuildRequirements(object oWaypoint,object oBuilder);


// FILE: lib_nais_unit          FUNCTION: Unit_SpawnUnit()
// This function is used to create the specified unit type.
// oWaypoint is the waypoint that defines the unit.
// oBuilder is the object that is building the unit.
// nUnit is used for storing unit numbers on squad leaders
// lLoc is the location to spawn the unit at
// bSpendResources if TRUE will consume resources required to spawn the unit.
// bPesist if TRUE will add this NPC to the persistent NPC storage
// bAttachToSquad if TRUE will attach the unit to oBuilder as squad leader.
object Unit_SpawnUnit(object oWaypoint,object oBuilder,int nUnit,location lLoc,int bSpendResources=TRUE,int bPersist=FALSE,int bAttachToSquad=FALSE);


// FILE: lib_nais_unit          FUNCTION: Unit_Persist()
// This will handle the persistent script which will be fired every 8+-2 seconds
// as long as a PC or an enemy is present.
void Unit_Persist(string sScript);


// SQUAD SPECIFIC DETAILS
/*
    oActSquad# - active squad members
    nActSquadT - active squad members top of list
    nActSquadN_# - active squad members next
    nActSquadP_# - active squad members previous

    Persistent List - SQL# where number is the PID of the Squad Leader
    These are consolidated units.
    SQM - Squad Member Unit Number type
    SQMQ - Squad Member Quantity

    Persistent List - SQLA# where number is the PID of the Squad Leader
    These are active (deconsolidated) units.
    SQAT - Squad Member Active Unit Type
*/



// Set Leader on oUnit
void Unit_SetSquadLeader(object oUnit,object oLeader);


// Get Squad Leader
object Unit_GetSquadLeader(object oUnit);


// Despawn all squad members except squad leader
void Unit_ConsolidateSquad(object oLeader);


// Deconsolidate and spawn up to nQty units from squad leader
void Unit_DeconsolidateSquad(object oLeader,int nQty=5);


// Update Squad - go through and update squad lists.   If there is a change
// it may be necessary to update persistance.
void Unit_UpdateSquad(object oLeader);


// Add oUnit to oLeaders squad with oUnit having specified unit number
void Unit_AddSquadMember(object oLeader,object oUnit,int nUnitNum);


// Remove oUnit from the Squad
void Unit_RemoveSquadMember(object oUnit);


// Get first unit that is currently spawned
object Unit_GetFirstActiveSquadMember(object oLeader);


// Get next unit that is currently spawned
object Unit_GetNextActiveSquadMember(object oLeader);


// Get first unit that is not spawned
int Unit_GetFirstConsolidatedUnit(object oLeader);


// Get next unit that is not spawned
int Unit_GetNextConsolidatedUnit(object oLeader);


// Spawn the specified unit
void Unit_SpawnConsolidatedUnit(object oLeader,int nUnitNum);


// Consolidate the specified unit
void Unit_ConsolidateUnit(object oUnit);


// Manage the squad persistent function.  Will monitor if the squad needs
// more members and make sure members move properly and will keep deconsolidating
// as appropriate until bDeconsoldate is FALSE.
// It will keep deconsolidating units as long as a PC or enemy are present and
// within fRange of oLeader.
void Unit_ManageSquad(object oLeader,int bDeconsolidate=TRUE,int bSize=5,float fRange=80.0);


////////////////////////////
// FUNCTIONS
////////////////////////////


object Unit_GetWaypoint(string sTeamID,int nUnitType,int nN=1)
{ // PURPOSE: Return the unit Waypoint
    object oRet;
    string sWP=sTeamID+"_";
    if (nUnitType==UNIT_TYPE_COMMON) sWP=sWP+"COMMON_";
    else if (nUnitType==UNIT_TYPE_GUARD_HIGH) sWP=sWP+"GUARDHIGH_";
    else if (nUnitType==UNIT_TYPE_GUARD_LOW) sWP=sWP+"GUARDLOW_";
    else if (nUnitType==UNIT_TYPE_GUARD_MEDIUM) sWP=sWP+"GUARDMID_";
    else if (nUnitType==UNIT_TYPE_OUTDOOR_HIGH) sWP=sWP+"OUTHIGH_";
    else if (nUnitType==UNIT_TYPE_OUTDOOR_LOW) sWP=sWP+"OUTLOW_";
    else if (nUnitType==UNIT_TYPE_OUTDOOR_MEDIUM) sWP=sWP+"OUTMID_";
    else if (nUnitType==UNIT_TYPE_SPECIALIST) sWP=sWP+"SPECIAL_";
    else if (nUnitType==UNIT_TYPE_SQUAD_LEADER) sWP=sWP+"SQUADL_";
    else if (nUnitType==UNIT_TYPE_SQUAD_MEMBER) sWP=sWP+"SQUAD_";
    sWP=sWP+IntToString(nN);
    oRet=GetWaypointByTag(sWP);
    return oRet;
} // Unit_GetWaypoint()


string Unit_GetUnitName(object oWaypoint)
{ // PURPOSE: Return the name of the specified unit on the waypoint
    return GetLocalString(oWaypoint,"sName");
} // Unit_GetUnitName()


string Unit_GetUnitTag(object oWaypoint)
{ // PURPOSE: Return the tag of the specified unit on the waypoint
    return GetLocalString(oWaypoint,"sTag");
} // Unit_GetUnitTag()


string Unit_GetRandomResRef(object oWaypoint)
{ // PURPOSE: Return the random resref of the unit on the waypoint
    string sRet="";
    string sMaster=GetLocalString(oWaypoint,"sResRef");
    string sParse;
    int nC;
    int nR;
    sParse=lib_ParseString(sMaster,"/");
    sMaster=lib_RemoveParsed(sMaster,sParse,"/");
    nC=StringToInt(sParse);
    nR=Random(nC)+1;
    nC=0;
    while(nC<nR&&GetStringLength(sMaster)>0)
    { // parse
        sParse=lib_ParseString(sMaster,"/");
        nC++;
        if (nC!=nR)
        { // keep going
            sMaster=lib_RemoveParsed(sMaster,sParse,"/");
        } // keep going
        else { sRet=sParse; }
    } // parse
    return sRet;
} // Unit_GetRandomResRef()


int Unit_GetRandomAppearance(object oWaypoint)
{ // PURPOSE: Return the random appearance number of the unit on the waypoint
    int nRet=-1;
    string sMaster=GetLocalString(oWaypoint,"sRApp");
    string sParse;
    int nC;
    int nR;
    sParse=lib_ParseString(sMaster,"/");
    sMaster=lib_RemoveParsed(sMaster,sParse,"/");
    nC=StringToInt(sParse);
    nR=Random(nC)+1;
    nC=0;
    while (nC<nR&&GetStringLength(sMaster)>0)
    { // parse
        sParse=lib_ParseString(sMaster,"/");
        nC++;
        if (nC!=nR)
        { // keep going
            sMaster=lib_RemoveParsed(sMaster,sParse,"/");
        } // keep going
        else { nRet=StringToInt(sParse); }
    } // parse
    return nRet;
} // Unit_GetRandomAppearance()


int Unit_GetTail(object oWaypoint)
{ // PURPOSE: Return the tail number as stored on the waypoint
    return GetLocalInt(oWaypoint,"nTail");
} // Unit_GetTail()


int Unit_GetWings(object oWaypoint)
{ // PURPOSE: Return the wings number as stored on the waypoint
    return GetLocalInt(oWaypoint,"nWings");
} // Unit_GetWings()


string Unit_GetEventWP(object oWaypoint)
{ // PURPOSE: Return the EventWP of the specified unit on the waypoint
    return GetLocalString(oWaypoint,"sEEventWP");
} // Unit_GetEventWP()


string Unit_GetDialog(object oWaypoint)
{ // PURPOSE: Return the Dialog of the specified unit on the waypoint
    return GetLocalString(oWaypoint,"sDialog");
} // Unit_GetDialog()


string Unit_GetRandomRightHandItem(object oWaypoint)
{ // PURPOSE: Return a random right handed item to equip
    string sRet="";
    string sMaster=GetLocalString(oWaypoint,"sRightHand");
    string sParse;
    int nC;
    int nR;
    sParse=lib_ParseString(sMaster,"/");
    sMaster=lib_RemoveParsed(sMaster,sParse,"/");
    nC=StringToInt(sParse);
    nR=Random(nC)+1;
    nC=0;
    while(nC<nR&&GetStringLength(sMaster)>0)
    { // parse
        sParse=lib_ParseString(sMaster,"/");
        nC++;
        if (nC!=nR)
        { // keep going
            sMaster=lib_RemoveParsed(sMaster,sParse,"/");
        } // keep going
        else { sRet=sParse; }
    } // parse
    return sRet;
} // Unit_GetRandomRightHandItem()


string Unit_GetRandomLeftHandItem(object oWaypoint)
{ // PURPOSE: Return a random left handed item to equip
    string sRet="";
    string sMaster=GetLocalString(oWaypoint,"sLeftHand");
    string sParse;
    int nC;
    int nR;
    sParse=lib_ParseString(sMaster,"/");
    sMaster=lib_RemoveParsed(sMaster,sParse,"/");
    nC=StringToInt(sParse);
    nR=Random(nC)+1;
    nC=0;
    while(nC<nR&&GetStringLength(sMaster)>0)
    { // parse
        sParse=lib_ParseString(sMaster,"/");
        nC++;
        if (nC!=nR)
        { // keep going
            sMaster=lib_RemoveParsed(sMaster,sParse,"/");
        } // keep going
        else { sRet=sParse; }
    } // parse
    return sRet;
} // Unit_GetRandomLeftHandItem()


string Unit_GetAmmo(object oWaypoint)
{ // PURPOSE: Return the Ammo of the specified unit on the waypoint
    return GetLocalString(oWaypoint,"sAmmo");
} // Unit_GetAmmo()


string Unit_GetRandomArmor(object oWaypoint)
{ // PURPOSE: Return a random armor to equip
    string sRet="";
    string sMaster=GetLocalString(oWaypoint,"sArmor");
    string sParse;
    int nC;
    int nR;
    sParse=lib_ParseString(sMaster,"/");
    sMaster=lib_RemoveParsed(sMaster,sParse,"/");
    nC=StringToInt(sParse);
    nR=Random(nC)+1;
    nC=0;
    while(nC<nR&&GetStringLength(sMaster)>0)
    { // parse
        sParse=lib_ParseString(sMaster,"/");
        nC++;
        if (nC!=nR)
        { // keep going
            sMaster=lib_RemoveParsed(sMaster,sParse,"/");
        } // keep going
        else { sRet=sParse; }
    } // parse
    return sRet;
} // Unit_GetRandomArmor()


string Unit_GetCorpse(object oWaypoint)
{ // PURPOSE: Return the resref of the corpse to create for this NPC
    return GetLocalString(oWaypoint,"sCorpse");
} // Unit_GetCorpse()


string Unit_GetCombatStyle(object oWaypoint)
{ // PURPOSE: Return the combat style of this NPC
    return GetLocalString(oWaypoint,"sCombatStyle");
} // Unit_GetCombatStyle()


string Unit_GetResourceReq(object oWaypoint,int nN=1)
{ // PURPOSE: Return the resource required
    return GetLocalString(oWaypoint,"sCostResource"+IntToString(nN));
} // Unit_GetResourceReq()


string Unit_PlaceableExistsReq(object oWaypoint,int nN=1)
{ // PURPOSE: Return the tag of a placeable which must exist in the module
    return GetLocalString(oWaypoint,"sPlaceExists"+IntToString(nN));
} // Unit_PlaceableExistsReq()


string Unit_PlaceableInAreaReq(object oWaypoint,int nN=1)
{ // PURPOSE: Return the tag of a placeable which must exist in the area
    return GetLocalString(oWaypoint,"sPlaceArea"+IntToString(nN));
} // Unit_PlaceableInAreaReq()


string Unit_UnitExistsReq(object oWaypoint,int nN=1)
{ // PURPOSE: Return the tag of a unit which must exist in the module
    return GetLocalString(oWaypoint,"sUnitExists"+IntToString(nN));
} // Unit_UnitExistsReq()


string Unit_ControlAreaReq(object oWaypoint,int nN=1)
{ // PURPOSE: Return the tag of an area which must be controlled
    return GetLocalString(oWaypoint,"sControlArea"+IntToString(nN));
} // Unit_ControlAreaReq()


string Unit_ItemConsumeReq(object oWaypoint,int nN=1)
{ // PURPOSE: Return the tag of an item which must be consumed from misc
    return GetLocalString(oWaypoint,"sItemConsume"+IntToString(nN));
} // Unit_ItemConsumeReq()


string Unit_GetSpawnScript(object oWaypoint)
{ // PURPOSE: Return the Spawn Script of this NPC
    return GetLocalString(oWaypoint,"sSpawnScript");
} // Unit_GetSpawnScript()


string Unit_PersistScript(object oWaypoint)
{ // PURPOSE: Return the Persistent Script of this NPC
    return GetLocalString(oWaypoint,"sPersistScript");
} // Unit_PersistScript()


int Unit_SquadLeaderReq(object oWaypoint)
{ // PURPOSE: Return the Squad Leader Type Number
    return GetLocalInt(oWaypoint,"nSquadLeaderReq");
} // Unit_SquadLeaderReq()


string Unit_GetKillerScript(object oWaypoint)
{ // PURPOSE: Return the Killer Script of this NPC
    return GetLocalString(oWaypoint,"sKillerScript");
} // Unit_GetKillerScript()


string Unit_GetRandomHelmet(object oWaypoint)
{ // PURPOSE: Return a random helmet to equip
    string sRet="";
    string sMaster=GetLocalString(oWaypoint,"sHelmet");
    string sParse;
    int nC;
    int nR;
    sParse=lib_ParseString(sMaster,"/");
    sMaster=lib_RemoveParsed(sMaster,sParse,"/");
    nC=StringToInt(sParse);
    nR=Random(nC)+1;
    nC=0;
    while(nC<nR&&GetStringLength(sMaster)>0)
    { // parse
        sParse=lib_ParseString(sMaster,"/");
        nC++;
        if (nC!=nR)
        { // keep going
            sMaster=lib_RemoveParsed(sMaster,sParse,"/");
        } // keep going
        else { sRet=sParse; }
    } // parse
    return sRet;
} // Unit_GetRandomHelmet()


void Unit_GiveBonusItems(object oWaypoint,object oUnit)
{ // PURPOSE: To create bonus items by resref on oUnit
    string sMaster=GetLocalString(oWaypoint,"sBonusItem");
    string sResRef;
    object oItem;
    while(GetStringLength(sMaster)>0)
    { // create items
        sResRef=lib_ParseString(sMaster,"/");
        sMaster=lib_RemoveParsed(sMaster,sResRef,"/");
        oItem=CreateItemOnObject(sResRef,oUnit,1);
    } // create items
} // Unit_GiveBonusItems()


int Unit_GetPopulationLimit(object oWaypoint)
{ // PURPOSE: Return the max population allowed for this unit type
    return GetLocalInt(oWaypoint,"nPopulationLimit");
} // Unit_GetPopulationLimit()


int Unit_GetRandomHead(object oWaypoint)
{ // PURPOSE: Return a random head
    int nRet=-1;
    string sMaster=GetLocalString(oWaypoint,"sHelmet");
    string sParse;
    int nC;
    int nR;
    sParse=lib_ParseString(sMaster,"/");
    sMaster=lib_RemoveParsed(sMaster,sParse,"/");
    nC=StringToInt(sParse);
    nR=Random(nC)+1;
    nC=0;
    while(nC<nR&&GetStringLength(sMaster)>0)
    { // parse
        sParse=lib_ParseString(sMaster,"/");
        nC++;
        if (nC!=nR)
        { // keep going
            sMaster=lib_RemoveParsed(sMaster,sParse,"/");
        } // keep going
        else { nRet=StringToInt(sParse); }
    } // parse
    return nRet;
} // Unit_GetRandomHead()


int Unit_GetPlaceableVarValue(object oWaypoint)
{ // PURPOSE: Return the value nCategory on the placeable must be set to
    return GetLocalInt(oWaypoint,"nPlaceVar");
} // Unit_GetPlaceableVarValue()


int Unit_GetCanBuild(object oWaypoint,object oBuilder,int bVerbose=FALSE)
{ // PURPOSE: Return whether oBuilder can build this object
  // Types of builders: Placeable, PC, NPC, Squad Leader
    int nBuilderType=UNIT_BUILDER_TYPE_PLACEABLE;
    int nN,nNN,nNNN;
    string sS,sSS;
    object oOb,oOb2;
    if (GetObjectType(oBuilder)==OBJECT_TYPE_CREATURE)
    { // builder identify
        if (GetIsPC(oBuilder)||GetIsDM(oBuilder)) nBuilderType=UNIT_BUILDER_TYPE_PC;
        else if (GetLocalInt(oBuilder,"nSquadLeaderType")>0) nBuilderType=UNIT_BUILDER_TYPE_SQUAD_LEAD;
        else { nBuilderType=UNIT_BUILDER_TYPE_NPC; }
    } // builder identify
    if (nBuilderType==UNIT_BUILDER_TYPE_PLACEABLE)
    { // placeable
        nN=Unit_SquadLeaderReq(oWaypoint);
        if (nN>0) return FALSE;
        nN=Unit_GetPlaceableVarValue(oWaypoint);
        if (nN!=0)
        { // test
            if (GetLocalInt(oBuilder,"nCategory")!=nN) return FALSE;
        } // test
        nN=Unit_GetReqAreaType(oWaypoint);
        if (nN==1)
        { // above ground
            if (!GetIsAreaAboveGround(GetArea(oBuilder))) return FALSE;
        } // above ground
        else if (nN==2)
        { // below ground
            if (GetIsAreaAboveGround(GetArea(oBuilder))) return FALSE;
        } // below ground
        else if (nN==3)
        { // outer planes\
            sS=GetTag(GetArea(oBuilder));
            sS=GetStringLeft(sS,3);
            sS=GetStringLowerCase(sS);
            if (sS!="op_") return FALSE;
        } // outer planes
        nN=1;
        sS=Unit_ControlAreaReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // see if areas are controlled
            oOb=GetWaypointByTag("AREA_"+sS);
            if (GetIsObjectValid(oOb))
            { // area is valid
                sS=Area_GetController(GetArea(oOb));
                if (GetLocalString(oBuilder,"sTeamID")!=sS)
                { // wrong team
                    return FALSE;
                } // wrong team
            } // area is valid
            nN++;
            sS=Unit_ControlAreaReq(oWaypoint,nN);
        } // see if areas are controlled
        nN=1;
        sS=Unit_UnitExistsReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // unit exists
            oOb=GetObjectByTag(sS);
            if (!GetIsObjectValid(oOb))
            { // not a valid object
                return FALSE;
            } // not a valid object
            nN++;
            sS=Unit_UnitExistsReq(oWaypoint,nN);
        } // unit exists
        nN=1;
        sS=Unit_PlaceableExistsReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // placeable exists
            oOb=GetObjectByTag(sS);
            if (!GetIsObjectValid(oOb))
            { // not a valid object
                return FALSE;
            } // not a valid object
            nN++;
            sS=Unit_PlaceableExistsReq(oWaypoint,nN);
        } // placeable exists
        nN=1;
        sS=Unit_PlaceableInAreaReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // placeable exists
            oOb=GetNearestObjectByTag(sS,oBuilder);
            if (!GetIsObjectValid(oOb))
            { // not a valid object
                return FALSE;
            } // not a valid object
            nN++;
            sS=Unit_PlaceableInAreaReq(oWaypoint,nN);
        } // placeable exists
        nNN=Unit_GetPopulationLimit(oWaypoint);
        if (nNN>0)
        { // population limit
            nN=0;
            sS=Unit_GetUnitTag(oWaypoint);
            oOb=GetObjectByTag(sS,nN);
            while(GetIsObjectValid(oOb))
            { // count
                nN++;
                if (nN>=nNN)
                { // population limit reached
                    return FALSE;
                } // population limit reached
                oOb=GetObjectByTag(sS,nN);
            } // count
        } // population limit
        nN=1;
        sS=Unit_GetResourceReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // check for resource requirements met
            sSS=lib_ParseString(sS,"/");
            sS=lib_RemoveParsed(sS,sSS,"/");
            nNN=StringToInt(sSS);
            if (nNN>0)
            { // resources
                nNNN=Area_GetResourceAmount(GetArea(oBuilder),nNN);
                if (nNNN<StringToInt(sS))
                { // not enough
                    return FALSE;
                } // not enough
            } // resources
            nN++;
            sS=Unit_GetResourceReq(oWaypoint,nN);
        } // check for resource requirements met
        nN=1;
        oOb=Area_GetStorage(GetArea(oBuilder),0); // misc storage
        sS=Unit_ItemConsumeReq(oWaypoint,nN);
        while(GetStringLength(sS)>0&&GetIsObjectValid(oOb))
        { // required consumeables
            oOb2=GetItemPossessedBy(oOb,sS);
            if (!GetIsObjectValid(oOb2))
            { // consumeable does not exist
                return FALSE;
            } // consumeable does not exist
            nN++;
            sS=Unit_ItemConsumeReq(oWaypoint,nN);
        } // required consumeables
    } // placeable
    else if (nBuilderType==UNIT_BUILDER_TYPE_PC)
    { // PC
        nN=Unit_SquadLeaderReq(oWaypoint);
        if (nN>0)
        { // squad leader required
            if (bVerbose) SendMessageToPC(oBuilder,"Only squad leader NPCs can build this type of unit.");
            return FALSE;
        } // squad leader required
        nN=Unit_GetReqAreaType(oWaypoint);
        if (nN==1)
        { // above ground
            if (!GetIsAreaAboveGround(GetArea(oBuilder)))
            { // above ground
                if (bVerbose) SendMessageToPC(oBuilder,"Cannot build that unit unless you are above ground.");
                return FALSE;
            } // above ground
        } // above ground
        else if (nN==2)
        { // below ground
            if (GetIsAreaAboveGround(GetArea(oBuilder)))
            { // below ground
                if (bVerbose) SendMessageToPC(oBuilder,"Cannot build that unit unless you are below ground.");
                return FALSE;
            } // below ground
        } // below ground
        else if (nN==3)
        { // outer planes\
            sS=GetTag(GetArea(oBuilder));
            sS=GetStringLeft(sS,3);
            sS=GetStringLowerCase(sS);
            if (sS!="op_")
            { // outer planes
                if (bVerbose) SendMessageToPC(oBuilder,"Cannot build that unit unless you are in the outer planes.");
                return FALSE;
            } // outer planes
        } // outer planes
        nN=1;
        sS=Unit_ControlAreaReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // see if areas are controlled
            oOb=GetWaypointByTag("AREA_"+sS);
            if (GetIsObjectValid(oOb))
            { // area is valid
                sS=Area_GetController(GetArea(oOb));
                if (GetLocalString(oBuilder,"sTeamID")!=sS)
                { // wrong team
                    if (bVerbose) SendMessageToPC(oBuilder,"Your team must control the area '"+GetName(GetArea(oOb))+"' in order to build that unit.");
                    return FALSE;
                } // wrong team
            } // area is valid
            nN++;
            sS=Unit_ControlAreaReq(oWaypoint,nN);
        } // see if areas are controlled
        nN=1;
        sS=Unit_UnitExistsReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // unit exists
            oOb=GetObjectByTag(sS);
            if (!GetIsObjectValid(oOb))
            { // not a valid object
                if (bVerbose) SendMessageToPC(oBuilder,"A unit with the tag '"+sS+"' must exist before you can build this unit type.");
                return FALSE;
            } // not a valid object
            nN++;
            sS=Unit_UnitExistsReq(oWaypoint,nN);
        } // unit exists
        nN=1;
        sS=Unit_PlaceableExistsReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // placeable exists
            oOb=GetObjectByTag(sS);
            if (!GetIsObjectValid(oOb))
            { // not a valid object
                if (bVerbose) SendMessageToPC(oBuilder,"A placeable with the tag '"+sS+"' must exist before you can build this unit type.");
                return FALSE;
            } // not a valid object
            nN++;
            sS=Unit_PlaceableExistsReq(oWaypoint,nN);
        } // placeable exists
        nN=1;
        sS=Unit_PlaceableInAreaReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // placeable exists
            oOb=GetNearestObjectByTag(sS,oBuilder);
            if (!GetIsObjectValid(oOb))
            { // not a valid object
                if (bVerbose) SendMessageToPC(oBuilder,"A placeable with the tag '"+sS+"' must exist in this area before you can build this unit type.");
                return FALSE;
            } // not a valid object
            nN++;
            sS=Unit_PlaceableInAreaReq(oWaypoint,nN);
        } // placeable exists
        nNN=Unit_GetPopulationLimit(oWaypoint);
        if (nNN>0)
        { // population limit
            nN=0;
            sS=Unit_GetUnitTag(oWaypoint);
            oOb=GetObjectByTag(sS,nN);
            while(GetIsObjectValid(oOb))
            { // count
                nN++;
                if (nN>=nNN)
                { // population limit reached
                    if (bVerbose) SendMessageToPC(oBuilder,"Only "+IntToString(nNN)+" units of this type are allowed in the game at a time.");
                    return FALSE;
                } // population limit reached
                oOb=GetObjectByTag(sS,nN);
            } // count
        } // population limit
        nN=1;
        sS=Unit_GetResourceReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // check for resource requirements met
            sSS=lib_ParseString(sS,"/");
            sS=lib_RemoveParsed(sS,sSS,"/");
            nNN=StringToInt(sSS);
            if (nNN>0)
            { // resources
                nNNN=Area_GetResourceAmount(GetArea(oBuilder),nNN);
                if (nNNN<StringToInt(sS))
                { // not enough
                    if (bVerbose) SendMessageToPC(oBuilder,"To build this unit "+sS+" "+Area_GetResourceName(nNN)+" must be stored in this area.");
                    return FALSE;
                } // not enough
            } // resources
            nN++;
            sS=Unit_GetResourceReq(oWaypoint,nN);
        } // check for resource requirements met
        nN=1;
        oOb=Area_GetStorage(GetArea(oBuilder),0); // misc storage
        sS=Unit_ItemConsumeReq(oWaypoint,nN);
        while(GetStringLength(sS)>0&&GetIsObjectValid(oOb))
        { // required consumeables
            oOb2=GetItemPossessedBy(oOb,sS);
            if (!GetIsObjectValid(oOb2)&&!GetIsObjectValid(GetItemPossessedBy(oBuilder,sS)))
            { // consumeable does not exist
                if (bVerbose) SendMessageToPC(oBuilder,"A miscellaneous item with the tag '"+sS+"' should be in the area or in your inventory in order to build this unit type.");
                return FALSE;
            } // consumeable does not exist
            nN++;
            sS=Unit_ItemConsumeReq(oWaypoint,nN);
        } // required consumeables
    } // PC
    else if (nBuilderType==UNIT_BUILDER_TYPE_NPC||nBuilderType==UNIT_BUILDER_TYPE_SQUAD_LEAD)
    { // NPCs
        nN=Unit_SquadLeaderReq(oWaypoint);
        if (nN>0)
        { // check squad leader type
            nNN=GetLocalInt(oBuilder,"nSquadLeaderType");
            if (nNN!=nN) return FALSE;
        } // check squad leader type
        nN=Unit_GetReqAreaType(oWaypoint);
        if (nN==1)
        { // above ground
            if (!GetIsAreaAboveGround(GetArea(oBuilder))) return FALSE;
        } // above ground
        else if (nN==2)
        { // below ground
            if (GetIsAreaAboveGround(GetArea(oBuilder))) return FALSE;
        } // below ground
        else if (nN==3)
        { // outer planes\
            sS=GetTag(GetArea(oBuilder));
            sS=GetStringLeft(sS,3);
            sS=GetStringLowerCase(sS);
            if (sS!="op_") return FALSE;
        } // outer planes
        nN=1;
        sS=Unit_ControlAreaReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // see if areas are controlled
            oOb=GetWaypointByTag("AREA_"+sS);
            if (GetIsObjectValid(oOb))
            { // area is valid
                sS=Area_GetController(GetArea(oOb));
                if (GetLocalString(oBuilder,"sTeamID")!=sS)
                { // wrong team
                    return FALSE;
                } // wrong team
            } // area is valid
            nN++;
            sS=Unit_ControlAreaReq(oWaypoint,nN);
        } // see if areas are controlled
        nN=1;
        sS=Unit_UnitExistsReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // unit exists
            oOb=GetObjectByTag(sS);
            if (!GetIsObjectValid(oOb))
            { // not a valid object
                return FALSE;
            } // not a valid object
            nN++;
            sS=Unit_UnitExistsReq(oWaypoint,nN);
        } // unit exists
        nN=1;
        sS=Unit_PlaceableExistsReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // placeable exists
            oOb=GetObjectByTag(sS);
            if (!GetIsObjectValid(oOb))
            { // not a valid object
                return FALSE;
            } // not a valid object
            nN++;
            sS=Unit_PlaceableExistsReq(oWaypoint,nN);
        } // placeable exists
        nN=1;
        sS=Unit_PlaceableInAreaReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // placeable exists
            oOb=GetNearestObjectByTag(sS,oBuilder);
            if (!GetIsObjectValid(oOb))
            { // not a valid object
                return FALSE;
            } // not a valid object
            nN++;
            sS=Unit_PlaceableInAreaReq(oWaypoint,nN);
        } // placeable exists
        nNN=Unit_GetPopulationLimit(oWaypoint);
        if (nNN>0)
        { // population limit
            nN=0;
            sS=Unit_GetUnitTag(oWaypoint);
            oOb=GetObjectByTag(sS,nN);
            while(GetIsObjectValid(oOb))
            { // count
                nN++;
                if (nN>=nNN)
                { // population limit reached
                    return FALSE;
                } // population limit reached
                oOb=GetObjectByTag(sS,nN);
            } // count
        } // population limit
        nN=1;
        sS=Unit_GetResourceReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // check for resource requirements met
            sSS=lib_ParseString(sS,"/");
            sS=lib_RemoveParsed(sS,sSS,"/");
            nNN=StringToInt(sSS);
            if (nNN>0)
            { // resources
                nNNN=Area_GetResourceAmount(GetArea(oBuilder),nNN);
                if (nNNN<StringToInt(sS))
                { // not enough
                    return FALSE;
                } // not enough
            } // resources
            nN++;
            sS=Unit_GetResourceReq(oWaypoint,nN);
        } // check for resource requirements met
        nN=1;
        oOb=Area_GetStorage(GetArea(oBuilder),0); // misc storage
        sS=Unit_ItemConsumeReq(oWaypoint,nN);
        while(GetStringLength(sS)>0&&GetIsObjectValid(oOb))
        { // required consumeables
            oOb2=GetItemPossessedBy(oOb,sS);
            if (!GetIsObjectValid(oOb2))
            { // consumeable does not exist
                return FALSE;
            } // consumeable does not exist
            nN++;
            sS=Unit_ItemConsumeReq(oWaypoint,nN);
        } // required consumeables
    } // NPCs
    return TRUE;
} // Unit_GetCanBuild()


string Unit_GetBuildRequirements(object oWaypoint,object oBuilder)
{ // PURPOSE: Return what requirements exist for this unit
    int nN,nNN,nNNN;
    string sS,sSS;
    object oOb,oOb2;
    string sMsg=GetLocalString(oWaypoint,"sBuildReq");
    if (GetStringLength(sMsg)>0) return sMsg;
    else
    { // build requirements
        sMsg=sMsg+"[Resources:";
        nN=1;
        sS=Unit_GetResourceReq(oWaypoint,nN);
        while(GetStringLength(sS)>0)
        { // check for resource requirements met
            sSS=lib_ParseString(sS,"/");
            sS=lib_RemoveParsed(sS,sSS,"/");
            nNN=StringToInt(sSS);
            if (nNN>0)
            { // resources
                sMsg=sMsg+sS+" "+Area_GetResourceName(nNN)+",";
            } // resources
            nN++;
            sS=Unit_GetResourceReq(oWaypoint,nN);
        } // check for resource requirements met
        sMsg=GetStringLeft(sMsg,GetStringLength(sMsg)-1)+"]";
        nN=1;
        sS=Unit_ItemConsumeReq(oWaypoint,nN);
        if (GetStringLength(sS)>0)
        { // miscellaneous consumeables
            sMsg=sMsg+"[Misc Items:";
            while(GetStringLength(sS)>0)
            { // required consumeables
                sMsg=sMsg+sS+",";
                nN++;
                sS=Unit_ItemConsumeReq(oWaypoint,nN);
            } // required consumeables
            sMsg=GetStringLeft(sMsg,GetStringLength(sMsg)-1)+"]";
        } // miscellaneous consumeables
        nN=Unit_GetReqAreaType(oWaypoint);
        if (nN==1) sMsg=sMsg+"[Above Ground]";
        else if (nN==2) sMsg=sMsg+"[Below Ground]";
        else if (nN==3) sMsg=sMsg+"[Outer Planes]";
        nN=1;
        sS=Unit_ControlAreaReq(oWaypoint,nN);
        if (GetStringLength(sS)>0)
        { // control areas
            sMsg=sMsg+"[Control of:";
            while(GetStringLength(sS)>0)
            { // see if areas are controlled
                oOb=GetWaypointByTag("AREA_"+sS);
                if (GetIsObjectValid(oOb))
                { // area is valid
                    sMsg=sMsg+GetName(GetArea(oOb))+",";
                } // area is valid
                nN++;
                sS=Unit_ControlAreaReq(oWaypoint,nN);
            } // see if areas are controlled
            sMsg=GetStringLeft(sMsg,GetStringLength(sMsg)-1)+"]";
        } // control areas
        nN=1;
        sS=Unit_UnitExistsReq(oWaypoint,nN);
        if (GetStringLength(sS)>0)
        { // unit type exist required
            sMsg=sMsg+"[Unit Exists:";
            while(GetStringLength(sS)>0)
            { // unit exists
                sMsg=sMsg+sS+",";
                nN++;
                sS=Unit_UnitExistsReq(oWaypoint,nN);
            } // unit exists
            sMsg=GetStringLeft(sMsg,GetStringLength(sMsg)-1)+"]";
        } // unit type exist required
        nN=1;
        sS=Unit_PlaceableExistsReq(oWaypoint,nN);
        if (GetStringLength(sS)>0)
        { // placeable exists
            sMsg=sMsg+"[Placeable Exists:";
            while(GetStringLength(sS)>0)
            { // placeable exists
                sMsg=sMsg+sS+",";
                nN++;
                sS=Unit_PlaceableExistsReq(oWaypoint,nN);
           } // placeable exists
           sMsg=GetStringLeft(sMsg,GetStringLength(sMsg)-1)+"]";
        } // placeable exists
        nN=1;
        sS=Unit_PlaceableInAreaReq(oWaypoint,nN);
        if (GetStringLength(sS)>0)
        { // placeable in area
            sMsg=sMsg+"[Placeable in area:";
            while(GetStringLength(sS)>0)
            { // placeable exists
                sMsg=sMsg+sS+",";
                nN++;
                sS=Unit_PlaceableInAreaReq(oWaypoint,nN);
            } // placeable exists
            sMsg=GetStringLeft(sMsg,GetStringLength(sMsg)-1)+"]";
        } // placeable in area
        nNN=Unit_GetPopulationLimit(oWaypoint);
        if (nNN>0)
        { // population limit
            sMsg=sMsg+"(Limit:"+IntToString(nNN)+")";
        } // population limit
    } // build requirements
    return sMsg;
} // Unit_GetBuildRequirements()


void fnUnit_SpendResources(object oWaypoint,object oBuilder)
{ // PURPOSE: To spend the cost of the unit
    int nN,nNN,nAm;
    string sS,sSS;
    object oOb,oOb2;
    nN=1;
    sS=Unit_GetResourceReq(oWaypoint,nN);
    while(GetStringLength(sS)>0)
    { // resources
        sSS=lib_ParseString(sS,"/");
        sS=lib_RemoveParsed(sS,sSS,"/");
        nNN=StringToInt(sSS);
        if (nNN>0)
        { // spend resources
            nAm=Area_GetResourceAmount(GetArea(oBuilder),nNN);
            nAm=nAm-StringToInt(sS);
            Area_SetResourceAmount(GetArea(oBuilder),nNN,nAm);
        } // spend resources
        nN++;
        sS=Unit_GetResourceReq(oWaypoint,nN);
    } // resources
    nN=1;
    sS=Unit_ItemConsumeReq(oWaypoint,nN);
    while(GetStringLength(sS)>0)
    { // consumeable items
        if (GetObjectType(oBuilder)==OBJECT_TYPE_CREATURE&&GetIsPC(oBuilder))
        { // PC
            oOb=GetItemPossessedBy(oBuilder,sS);
            if (GetIsObjectValid(oOb))
            { // PC
                nNN=GetItemStackSize(oOb);
                if (nNN>1) SetItemStackSize(oOb,nNN-1);
                else { DestroyObject(oOb); }
            } // PC
            else
            { // other
                oOb=Area_GetStorage(GetArea(oBuilder),0); // misc storage
                oOb2=GetItemPossessedBy(oOb,sS);
                if (GetIsObjectValid(oOb2))
                { // valid
                    nNN=GetItemStackSize(oOb2);
                    if (nNN>1) SetItemStackSize(oOb2,nNN-1);
                    else { DestroyObject(oOb2); }
                } // valid
            } // other
        } // PC
        else
        { // other
            oOb=Area_GetStorage(GetArea(oBuilder),0); // misc storage
            oOb2=GetItemPossessedBy(oOb,sS);
            if (GetIsObjectValid(oOb2))
            { // valid
                nNN=GetItemStackSize(oOb2);
                if (nNN>1) SetItemStackSize(oOb2,nNN-1);
                else { DestroyObject(oOb2); }
            } // valid
        } // other
        nN++;
        sS=Unit_ItemConsumeReq(oWaypoint,nN);
    } // consumeable items
} // fnUnit_SpendResources()


object Unit_SpawnUnit(object oWaypoint,object oBuilder,int nUnit,location lLoc,int bSpendResources=TRUE,int bPersist=FALSE,int bAttachToSquad=FALSE)
{ // PURPOSE: To spawn the unit in question
    object oUnit;
    object oOb,oOb2;
    int nN,nNN;
    string sS,sSS;
    if (GetIsObjectValid(oWaypoint))
    { // valid
        sS=Unit_GetRandomResRef(oWaypoint);
        if (GetStringLength(sS)>0)
        { // valid
            sSS=Unit_GetUnitTag(oWaypoint);
            oUnit=CreateObject(OBJECT_TYPE_CREATURE,sS,lLoc,FALSE,sSS);
            if (GetIsObjectValid(oUnit))
            { // unit created
                sS=Unit_GetUnitName(oWaypoint);
                if (GetStringLength(sS)>0) SetName(oUnit,sS);
                nN=Unit_GetTail(oWaypoint);
                nN=nN-1;
                if (nN>-1) SetCreatureTailType(nN,oUnit);
                nN=Unit_GetWings(oWaypoint);
                nN=nN-1;
                if (nN>-1) SetCreatureWingType(nN,oUnit);
                nN=Unit_GetRandomHead(oWaypoint);
                if (nN>-1) SetCreatureBodyPart(CREATURE_PART_HEAD,nN,oUnit);
                sS=Unit_GetRandomArmor(oWaypoint);
                if (GetStringLength(sS)>0)
                { // create armor
                    oOb=CreateItemOnObject(sS,oUnit);
                    if (GetIsObjectValid(oOb))
                    { // force equip
                        DelayCommand(1.0,lib_ForceEquip(oUnit,oOb,INVENTORY_SLOT_CHEST,10));
                    } // force equip
                } // create armor
                sS=Unit_GetRandomHelmet(oWaypoint);
                if (GetStringLength(sS)>0)
                { // create helmet
                    oOb=CreateItemOnObject(sS,oUnit);
                    if (GetIsObjectValid(oOb))
                    { // force equip
                        DelayCommand(3.0,lib_ForceEquip(oUnit,oOb,INVENTORY_SLOT_HEAD,10));
                    } // force equip
                } // create helmet
                sS=Unit_GetRandomRightHandItem(oWaypoint);
                if (GetStringLength(sS)>0)
                { // create right hand item
                    oOb=CreateItemOnObject(sS,oUnit);
                    if (GetIsObjectValid(oOb))
                    { // force equip
                        DelayCommand(5.0,lib_ForceEquip(oUnit,oOb,INVENTORY_SLOT_RIGHTHAND));
                    } // force equip
                } // create right hand item
                sS=Unit_GetAmmo(oWaypoint);
                if (GetStringLength(sS)>0)
                { // create ammo
                    oOb=CreateItemOnObject(sS,oUnit);
                    if (GetIsObjectValid(oOb))
                    { // force equip
                        nNN=INVENTORY_SLOT_ARROWS;
                        nN=GetBaseItemType(oOb);
                        if (nN==BASE_ITEM_BULLET) nNN=INVENTORY_SLOT_BULLETS;
                        else if (nN==BASE_ITEM_BOLT) nNN=INVENTORY_SLOT_BOLTS;
                        DelayCommand(7.0,lib_ForceEquip(oUnit,oOb,nNN));
                    } // force equip
                } // create ammo
                sS=Unit_GetRandomLeftHandItem(oWaypoint);
                if (GetStringLength(sS)>0)
                { // create left hand item
                    oOb=CreateItemOnObject(sS,oUnit);
                    if (GetIsObjectValid(oOb))
                    { // force equip
                        DelayCommand(9.0,lib_ForceEquip(oUnit,oOb,INVENTORY_SLOT_LEFTHAND));
                    } // force equip
                } // create left hand item
                nN=Unit_GetRandomAppearance(oWaypoint);
                if (nN>0)
                { // set appearance
                    SetCreatureAppearanceType(oUnit,nN);
                } // set appearance
                sS=Unit_GetCombatStyle(oWaypoint);
                if (GetStringLength(sS)>0) SetLocalString(oUnit,"sCombatStyle",sS);
                sS=Unit_GetCorpse(oWaypoint);
                if (GetStringLength(sS)>0) SetLocalString(oUnit,"sCorpse",sS);
                sS=Unit_GetDialog(oWaypoint);
                if (GetStringLength(sS)>0) SetLocalString(oUnit,"sDialog",sS);
                sS=Unit_GetEventWP(oWaypoint);
                if (GetStringLength(sS)>0) SetLocalString(oUnit,"sEEventWP",sS);
                sS=Unit_GetKillerScript(oWaypoint);
                if (GetStringLength(sS)>0) SetLocalString(oUnit,"sEKiller",sS);
                sS=Unit_GetSpawnScript(oWaypoint);
                if (GetStringLength(sS)>0) ExecuteScript(sS,oUnit);
                sS=Unit_PersistScript(oWaypoint);
                if (GetStringLength(sS)>0) DelayCommand(1.0,AssignCommand(oUnit,Unit_Persist(sS)));
                Unit_GiveBonusItems(oWaypoint,oUnit);
                if (bSpendResources) DelayCommand(0.03,fnUnit_SpendResources(oWaypoint,oBuilder));
                if (bPersist) DelayCommand(12.0,NPC_UpdateNPC(oUnit));
                if (bAttachToSquad) DelayCommand(0.06,Unit_AddSquadMember(oBuilder,oUnit,nUnit));
                sS=Team_GetTeamID(oBuilder);
                if (GetStringLength(sS)>0)
                { // join team
                    SetLocalString(oUnit,"sTeamID",sS);
                } // join team
                return oUnit;
            } // unit created
        } // valid
    } // valid
    return OBJECT_INVALID;
} // Unit_SpawnUnit()


void Unit_Persist(string sScript)
{ // PURPOSE: Persistent script handling
    object oMe=OBJECT_SELF;
    float fR;
    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oMe,1))||GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,oMe,1,CREATURE_TYPE_IS_ALIVE,TRUE)))
    { // enemy or PC near
        ExecuteScript(sScript,oMe);
    } // enemy or PC near
    fR=IntToFloat(Random(40))/10.0;
    fR=fR-2.0;
    DelayCommand(fR+8.0,Unit_Persist(sScript));
} // Unit_Persist

void main(){}
