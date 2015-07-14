////////////////////////////////////////////////////////////////////////////////
// lib_nais_race - This provides the functions for setting and determining
// the race of a PC or NPC.
// By Deva B. Winblood.  3/28/2007
////////////////////////////////////////////////////////////////////////////////
// Races are defined on: RACE_WP_# where # is the race # beginning with 1 and
// being consecutive.  RACE_WP_raceID = nNum = stores the race #
//------------------------------------------------------------------------------
// sName = name
// sShortDesc = Short Description
// sDesc = Long Description
// sAbilAdj = Ability Adjustments   ability.adjust/ability.adjust
// sFreeF = Free Feats     feat_num/feat_num
// sPerS = Persistent Script      script_name/frequency_repeat_seconds
// sOneTimeS = One Time Script    script_name
// sBaseR = Base Races acceptable    RaceID/RaceID
// sBaseT = Base Teams Acceptable    ALL = all    teamid/teamid
// nXPD = XP Divisor  0 = no divisor
// nXPL = Level XP Divisor is no longer used
// sRaceID = the RaceID to store as primary/secondary race
// bIsSecondary = if set to 1 this is treated as a secondary race
// sRemovalS = Script to run upon removal of this race
// sApp = Appearance male/female
// sHeadM = Heads allowed Male  #/head#/head#
// sHeadF = Heads allowed Female #/head#/head#
// nPheno = Phenotype #
// nTail = Tail #
// nWings = Wings #
////////////////////////////////////////////////////////////////////////////////

#include "lib_nais_var"
#include "lib_nais_tool"
#include "lib_nais_team"
#include "x2_inc_itemprop"

///////////////////////
// CONSTANT
///////////////////////


///////////////////////
// PROTOTYPE
///////////////////////


// FILE: lib_nais_race          FUNCTION:GetRace()
// This function will return which race the PC or NPC is.   If bPrimary is set
// to FALSE then it will return a secondary race if one exists.
string GetRace(object oCreature,int bPrimary=TRUE);


// FILE: lib_nais_race          FUNCTION: Race_GetRace()
// This is a wrapper for the GetRace() function.
string Race_GetRace(object oCreature,int bPrimary=TRUE);


// FILE: lib_nais_race          FUNCTION: Race_GetRaceInacceptableString()
// If this race is unacceptable for oCreature it will return a short string
// explaining why.   If it is acceptable it will return "".
string Race_GetRaceInacceptableString(object oCreature,int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetRaceShortDescription()
// This will return a short description of the specified race.
string Race_GetRaceShortDescription(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetRaceDescription()
// This will return a complete description of the specified race.
string Race_GetRaceDescription(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetPersistentScript()
// This will return a string script_name/repeat_freq_in_seconds if such
// a script has been defined.
string Race_GetPersistentScript(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetOneTimeScript()
// This will return a script name that is to be executed once by a creature
// when it becomes this race.
string Race_GetOneTimeScript(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetAbilityAdjustments()
// This will return ability adjustments ability.adjust/ability.adjust for
// the specified race adjustment.
string Race_GetAbilityAdjustments(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetFreeFeats()
// This will return feat_number/feat_number for free feats that should be added
// when someone becomes this race.  These come from itemprop_feats.
string Race_GetFreeFeats(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetRaceID()
// This will return the race ID that should be set for this specific race.
string Race_GetRaceID(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetRaceName()
// This will return the name of the specified race.
string Race_GetRaceName(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetBaseRaces()
// This will return the base race that should be used for this race number.
string Race_GetBaseRaces(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetBaseTeams()
// This will return TeamID/TeamID for which teams can become this race.
string Race_GetBaseTeams(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetXPDivisor()
// This will return the XP divisor.  If it returns 0 then there is no XP divisor.
int Race_GetXPDivisor(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetXPLevelDivisorCap()
// This will get the level at which the level divisor is no longer used for this
// race.
int Race_GetXPLevelDivisorCap(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetIsSecondary()
// This will return TRUE if this type of race should be applied as a secondary
// race.
int Race_GetIsSecondary(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetRaceRemovalScript()
// This will return the script to run when this race is removed.
string Race_GetRaceRemovalScript(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_BecomeRace()
// This will make oCreature the specified race.
void Race_BecomeRace(object oCreature,int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_RemoveRace()
// This will remove the specified race.
void Race_RemoveRace(object oCreature,int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetAppearance()
// This will return the appearance number to use based upon gender.
int Race_GetAppearance(int nRaceNumber,int nGender);

// FILE: lib_nais_race          FUNCTION: Race_GetHeads()
// This will return heads that are allowed for this race and gender
// as head/head/head.
string Race_GetHeads(int nRaceNumber,int nGender);

// FILE: lib_nais_race          FUNCTION: Race_GetPhenotype()
// This will return which phenotype to use for the specified race
int Race_GetPhenotype(int nRaceNumber);

// FILE: lib_nais_race          FUNCTION: Race_GetTail()
// This will return which tail to use for the specified race.
int Race_GetTail(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_GetWings()
// This will return which wings to use for the specified race.
int Race_GetWings(int nRaceNumber);


// FILE: lib_nais_race          FUNCTION: Race_StripRacialProperties()
// This will remove all properties from the skin and will remove racial settings.
// If bResetAppearance is set to TRUE it will reset the PC to the default race
// and choose a random head from 1 to 6.
void Race_StripRacialProperties(object oCreature,int bResetAppearance=FALSE);


///////////////////////
// FUNCTION
///////////////////////


void Race_RunPersistentScript(object oCreature,string sScript,string sRaceID,float fFreq=6.0)
{ // PURPOSE: Run a persistent script on oCreature until sRaceID no longer matches
    int bStillActive=FALSE;
    if (Race_GetRace(oCreature)==sRaceID) bStillActive=TRUE;
    else if (Race_GetRace(oCreature,FALSE)==sRaceID) bStillActive=TRUE;
    if (bStillActive)
    { // persistent
        DelayCommand(fFreq,Race_RunPersistentScript(oCreature,sScript,sRaceID,fFreq));
        //SendMessageToPC(oCreature,"ExecuteScript("+sScript+")");
        ExecuteScript(sScript,oCreature);
    } // persistent
    else
    { // end
        SendMessageToPC(oCreature,"End Persistent Script '"+sScript+"' for RaceID '"+sRaceID+"'");
    } // end
} // Race_RunPersistentScript()


string Race_GetRace(object oCreature,int bPrimary=TRUE)
{ // PURPOSE: This a wrapper for GetRace()
    return GetRace(oCreature,bPrimary);
} // Race_GetRace()


string GetRace(object oCreature,int bPrimary=TRUE)
{ // PURPOSE: Return the race in all uppercase
    string sRet;
    int nRace;
    if (bPrimary)
    { // primary race
        sRet=GetSkinString(oCreature,"sPRace");
        if (GetStringLength(sRet)<1)
        { // set standard race
            nRace=GetRacialType(oCreature);
            sRet="NPC"; // generic
            if (nRace==RACIAL_TYPE_DWARF) sRet="DWARF";
            else if (nRace==RACIAL_TYPE_ELF) sRet="ELF";
            else if (nRace==RACIAL_TYPE_GNOME) sRet="GNOME";
            else if (nRace==RACIAL_TYPE_HALFELF) sRet="HALFELF";
            else if (nRace==RACIAL_TYPE_HALFLING) sRet="HALFLING";
            else if (nRace==RACIAL_TYPE_HALFORC) sRet="HALFORC";
            else if (nRace==RACIAL_TYPE_HUMAN) sRet="HUMAN";
            SetSkinString(oCreature,"sPRace",sRet);
        } // set standard race
    } // primary race
    else
    { // secondary
        sRet=GetSkinString(oCreature,"sSRace");
    } // secondary
    return sRet;
} // GetRace()


string Race_GetRaceShortDescription(int nRaceNumber)
{ // PURPOSE: Return the short description for this race
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sShortDesc");
    return sRet;
} // Race_GetRaceShortDescription()


string Race_GetRaceDescription(int nRaceNumber)
{ // PURPOSE: Return the longer description of the race
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sDesc");
    return sRet;
} // Race_GetRaceDescription()


string Race_GetPersistentScript(int nRaceNumber)
{ // PURPOSE: Return the persistent script for the race number
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sPerS");
    return sRet;
} // Race_GetPersistentScript()


string Race_GetOneTimeScript(int nRaceNumber)
{ // PURPOSE: Return the one time script
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sOneTimeS");
    return sRet;
} // Race_GetOneTimeScript()


string Race_GetFreeFeats(int nRaceNumber)
{ // PURPOSE: Free Feats
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sFreeF");
    return sRet;
} // Race_GetFreeFeats()


string Race_GetRaceID(int nRaceNumber)
{ // PURPOSE: Returns the raceID for race number
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sRaceID");
    return sRet;
} // Race_GetRaceID()


string Race_GetRaceName(int nRaceNumber)
{ // PURPOSE: Returns the race name for the race number
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sName");
    return sRet;
} // Race_GetRaceName()


string Race_GetBaseRaces(int nRaceNumber)
{ // PURPOSE: Returns base races for RaceNumber
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sBaseR");
    return sRet;
} // Race_GetBaseRaces()


string Race_GetBaseTeams(int nRaceNumber)
{ // PURPOSE: Return base team IDs allowed to play this race ALL = any
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sBaseT");
    return sRet;
} // Race_GetBaseTeams()


int Race_GetXPDivisor(int nRaceNumber)
{ // PURPOSE: Return the XP divisor for this race
    int nRet=0;
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) nRet=GetLocalInt(oWP,"nXPD");
    return nRet;
} // Race_GetXPDivisor()


int Race_GetXPLevelDivisorCap(int nRaceNumber)
{ // PURPOSE: Return XP Divisor Level Cap
    int nRet=0;
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) nRet=GetLocalInt(oWP,"nXPL");
    return nRet;
} // Race_GetXPLevelDivisorCap()


int Race_GetIsSecondary(int nRaceNumber)
{ // PURPOSE: Return TRUE if this race is a secondary race
    int nRet=0;
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) nRet=GetLocalInt(oWP,"bIsSecondary");
    return nRet;
} // Race_GetIsSecondary()


string Race_GetRaceRemovalScript(int nRaceNumber)
{ // PURPOSE: Return the removal script to run when this race is removed
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sRemovalS");
    return sRet;
} // Race_GetRaceRemovalScript()

int Race_GetAppearance(int nRaceNumber,int nGender)
{ // PURPOSE: Return the race appearance based on gender
    int nRet=0;
    string sVar;
    string sP;
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP))
    { // waypoint valid
        sVar=GetLocalString(oWP,"sApp");
        sP=lib_ParseString(sVar);
        sVar=lib_RemoveParsed(sVar,sP);
        if (nGender==GENDER_FEMALE) nRet=StringToInt(sVar);
        else { nRet=StringToInt(sP); }
    } // waypoint valid
    return nRet;
} // Race_GetAppearance()


string Race_GetHeads(int nRaceNumber,int nGender)
{ // PURPOSE: Return the head list
    string sRet="1";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP))
    { // valid waypoint
        if (nGender==GENDER_FEMALE) sRet=GetLocalString(oWP,"sHeadF");
        else { sRet=GetLocalString(oWP,"sHeadM"); }
    } // valid waypoint
    return sRet;
} // Race_GetHeads()


int Race_GetPhenotype(int nRaceNumber)
{ // PURPOSE: Get phenotype
    int nRet=0;
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) nRet=GetLocalInt(oWP,"nPheno");
    return nRet;
} // Race_GetPhenotype()


int Race_GetTail(int nRaceNumber)
{ // PURPOSE: Get Tail
    int nRet=0;
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) nRet=GetLocalInt(oWP,"nTail");
    return nRet;
} // Race_GetTail()


int Race_GetWings(int nRaceNumber)
{ // PURPOSE: Get Wings
    int nRet=0;
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) nRet=GetLocalInt(oWP,"nWings");
    return nRet;
} // Race_GetWings()


string Race_GetAbilityAdjustments(int nRaceNumber)
{ // PURPOSE: Return Race Ability Adjustments
    string sRet="";
    object oWP=GetWaypointByTag("RACE_WP_"+IntToString(nRaceNumber));
    if (GetIsObjectValid(oWP)) sRet=GetLocalString(oWP,"sAbilAdj");
    return sRet;
} // Race_GetAbilityAdjustments()


void fnRace_Scripts(object oCreature,int nRaceNumber)
{ // PURPOSE: Breaking the function up
    string sS;
    string sP;
    string sW;
    int nN;
        sS=Race_GetOneTimeScript(nRaceNumber);
        if (GetStringLength(sS)>0) ExecuteScript(sS,oCreature);
        sS=Race_GetPersistentScript(nRaceNumber);
        if (GetStringLength(sS)>0)
        { // persistent script
            sP=sS;
            sS=lib_ParseString(sP);
            sP=lib_RemoveParsed(sP,sS);
            if (GetStringLength(sS)>0)
            { // persistent script listed
                nN=StringToInt(sP);
                if (nN<1) nN=6;
                sW=Race_GetRaceID(nRaceNumber);
                SendMessageToPC(oCreature,"Launch Persistent Script '"+sS+"' every "+IntToString(nN)+" seconds.  RaceID:'"+sW+"'");
                DelayCommand(3.0,AssignCommand(oCreature,Race_RunPersistentScript(oCreature,sS,sW,IntToFloat(nN))));
            } // persistent script listed
        } // persistent script
} // fnRace_Scripts()


void fnRace_Abilities(object oCreature,int nRaceNumber,object oSkin)
{ // PURPOSE: Break the function up
    int nN;
    int nR;
    int nC=0;
    string sS;
    string sW;
    string sP;
    itemproperty ip;
    sS=Race_GetAbilityAdjustments(nRaceNumber);
        if (GetStringLength(sS)>0)
        { // adjust abilities
            //SendMessageToPC(oCreature,"  Adjust Abilities='"+sS+"'");
            sW=lib_ParseString(sS);
            while(GetStringLength(sS)>0&&nC<7)
            { // react to each adjustment
                nC++;
                nN=-1; // ability
                nR=0; // adjustment
                sS=lib_RemoveParsed(sS,sW,"/");
                //SendMessageToPC(oCreature,"sS:'"+sS+"'");
                //SendMessageToPC(oCreature,"sW1:"+sW);
                sP=lib_ParseString(sW,".");
                //SendMessageToPC(oCreature,"sP:"+sP);
                sW=lib_RemoveParsed(sW,sP,".");
                //SendMessageToPC(oCreature,"sW2:"+sW);
                sP=GetStringUpperCase(sP);
                nN=-1;
                if (sP=="STR") nN=IP_CONST_ABILITY_STR;
                else if (sP=="CHA") nN=IP_CONST_ABILITY_CHA;
                else if (sP=="CON") nN=IP_CONST_ABILITY_CON;
                else if (sP=="DEX") nN=IP_CONST_ABILITY_DEX;
                else if (sP=="INT") nN=IP_CONST_ABILITY_INT;
                else if (sP=="WIS") nN=IP_CONST_ABILITY_WIS;
                nR=StringToInt(sW);
                //SendMessageToPC(oCreature,"   '"+sP+"' "+sW+"="+IntToString(nR)+" nN:"+IntToString(nN));
                if (nN>-1&&nR!=0)
                { // ability score listed and non-zero modifier specified
                    if (nR<0)
                    { // reduce ability
                        nR=abs(nR);
                        if (nR>10) nR=10;
                        SendMessageToPC(oCreature,"  Decrease '"+sP+'" by "+IntToString(nR));
                        ip=ItemPropertyDecreaseAbility(nN,nR);
                    } // reduce ability
                    else
                    { // increase ability
                        if (nR>12) nR=12;
                        SendMessageToPC(oCreature,"  Increase '"+sP+'" by "+IntToString(nR));
                        ip=ItemPropertyAbilityBonus(nN,nR);
                    } // increase ability
                    IPSafeAddItemProperty(oSkin,ip,0.0,X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
                } // ability score listed and non-zero modifier specified
                sW=lib_ParseString(sS);
            } // react to each adjustment
        } // adjust abilities
} // fnRace_Abilities()


void fnRace_Feats(object oCreature,int nRaceNumber,object oSkin)
{ // PURPOSE: Break the function up
    int nN;
    int nR;
    string sS;
    string sW;
    string sP;
    itemproperty ip;
    sS=Race_GetFreeFeats(nRaceNumber);
        if (GetStringLength(sS)>0)
        { // free feats
            sP=lib_ParseString(sS);
            while(GetStringLength(sS)>0)
            { // give free feats
                nN=StringToInt(sP);
                if (nN>0)
                { // feat
                    SendMessageToPC(oCreature," Bonus Feat:"+IntToString(nN)+" '"+Get2DAString("iprp_feats","Label",nN)+"'");
                    ip=ItemPropertyBonusFeat(nN);
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oSkin);
                } // feat
                sS=lib_RemoveParsed(sS,sP);
                sP=lib_ParseString(sS);
            } // give free feats
        } // free feats
} // fnRace_Feats()


string fnRace_ChooseRandomHead(string sHeads)
{ // PURPOSE: Returns a random head to choose from
    string sParse;
    string sMaster=sHeads;
    string sRet=lib_ParseString(sMaster);
    int nCount;
    int nR;
    // count them
    while(GetStringLength(sMaster)>0)
    { // count
        sParse=lib_ParseString(sMaster);
        sMaster=lib_RemoveParsed(sMaster,sParse);
        nCount++;
    } // count
    if (nCount>0)
    { // more than one head
        nR=Random(nCount)+1;
        nCount=0;
        sMaster=sHeads;
        while(nCount<nR)
        { // get the head
            sRet=lib_ParseString(sMaster);
            sMaster=lib_RemoveParsed(sMaster,sParse);
            nCount++;
        } // get the head
    } // more than one head
    return sRet;
} // fnRace_ChooseRandomHead()

void fnRace_Appearance(object oCreature,int nRaceNumber)
{ // PURPOSE: break up function
    int nN;
    int nR;
    string sS;
    string sW;
    string sP;
    nN=Race_GetAppearance(nRaceNumber,GetGender(oCreature));
        if (nN!=-1) SetCreatureAppearanceType(oCreature,nN);
        nN=Race_GetPhenotype(nRaceNumber);
        if (nN!=-1) SetPhenoType(nN,oCreature);
        nN=Race_GetTail(nRaceNumber);
        if (nN!=-1) SetCreatureTailType(nN,oCreature);
        nN=Race_GetWings(nRaceNumber);
        if (nN!=-1) SetCreatureWingType(nN,oCreature);
        sS=Race_GetHeads(nRaceNumber,GetGender(oCreature));
        if (GetStringLength(sS)>0)
        { // adjust head
            sS=fnRace_ChooseRandomHead(sS);
            nN=StringToInt(sS);
            SendMessageToPC(oCreature,"  HEAD:'"+sS+"' = "+IntToString(nN));
            SetCreatureBodyPart(CREATURE_PART_HEAD,nN,oCreature);
        } // adjust head
} // fnRace_Appearance()


void Race_BecomeRace(object oCreature,int nRaceNumber)
{ // PURPOSE: Become Race
    object oSkin=GetSkinObject(oCreature);
    int nN;
    int nR;
    string sS;
    string sW;
    string sP;
    object oOb;
    effect eE;
    itemproperty ip;
    string sID=Race_GetRaceID(nRaceNumber);
    int bSecondary=FALSE;
    if (GetIsObjectValid(oCreature)&&GetObjectType(oCreature)==OBJECT_TYPE_CREATURE&&GetStringLength(sID)>0)
    { // valid parameters
        if (Race_GetIsSecondary(nRaceNumber))
        { // setup as secondary
            SetSkinString(oCreature,"sSRace",sID);
            SetSubRace(oCreature,Race_GetRaceName(nRaceNumber));
            bSecondary=TRUE;
            SetSkinInt(oCreature,"nSRaceID",nRaceNumber);
        } // setup as secondary
        else
        { // primary
            Race_StripRacialProperties(oCreature);
            SetSkinString(oCreature,"sPRace",sID);
            SetSkinInt(oCreature,"nPRaceID",nRaceNumber);
        } // primary
        fnRace_Abilities(oCreature,nRaceNumber,oSkin);
        fnRace_Feats(oCreature,nRaceNumber,oSkin);
        if (!bSecondary) fnRace_Appearance(oCreature,nRaceNumber);
        fnRace_Scripts(oCreature,nRaceNumber);
    } // valid parameters
} // Race_BecomeRace()

void Race_RemoveRace(object oCreature,int nRaceNumber)
{ // PURPOSE: Remove Race
    string sID;
    string sS;
    if (GetIsObjectValid(oCreature)&&GetObjectType(oCreature)==OBJECT_TYPE_CREATURE&&nRaceNumber>0)
    { // valid parameters
        sID=Race_GetRaceID(nRaceNumber);
        if (Race_GetRace(oCreature)==sID||Race_GetRace(oCreature,FALSE)==sID)
        { // is the race
            sS=Race_GetRaceRemovalScript(nRaceNumber);
            if (GetStringLength(sS)>0) ExecuteScript(sS,oCreature);
        } // is the race
    } // valid parameters
} // Race_RemoveRace()


string Race_GetRaceInacceptableString(object oCreature,int nRaceNumber)
{ // PURPOSE: Return the string for if this race is not acceptable
    string sRet="";
    string sP;
    string sW;
    int nN;
    if (GetIsObjectValid(oCreature)&&GetObjectType(oCreature)==OBJECT_TYPE_CREATURE&&nRaceNumber>0)
    { // valid parameters
        sW=Race_GetBaseRaces(nRaceNumber);
        if (GetStringLength(sW)>0)
        { // base race
            sP=Race_GetRace(oCreature);
            if (FindSubString(sW,sP)==-1)
            { // not valid race
                sRet=sRet+"not a valid race ("+sW+")";
            } // not valid race
        } // base race
        sW=Race_GetBaseTeams(nRaceNumber);
        if (GetStringLength(sW)>0)
        { // base teams
            sP=Team_GetTeamID(oCreature);
            if (FindSubString(sW,sP)==-1)
            { // not valid team
                sRet=sRet+" not a valid team ("+sW+")";
            } // not valid team
        } // base teams
    } // valid parameters
    return sRet;
} // Race_GetRaceInacceptableString()


void Race_StripRacialProperties(object oCreature,int bResetAppearance=FALSE)
{ // PURPOSE: This will strip skin properties and remove all racial properties
    object oSkin=GetSkinObject(oCreature);
    int nRace;
    int nApp;
    int nHead;
    int nPR;
    int nSR;
    string sS;
    if (GetIsObjectValid(oSkin))
    { // valid parameters
        DeleteSkinString(oCreature,"sPRace");
        DeleteSkinString(oCreature,"sSRace");
        nPR=GetSkinInt(oCreature,"nPRaceID");
        nSR=GetSkinInt(oCreature,"nSRaceID");
        DeleteSkinInt(oCreature,"nPRaceID");
        DeleteSkinInt(oCreature,"nSRaceID");
        SetSubRace(oCreature,"");
        IPRemoveAllItemProperties(oSkin,DURATION_TYPE_PERMANENT);
        if (bResetAppearance)
        { // reset appearance
            nRace=GetRacialType(oCreature);
            if (nRace==RACIAL_TYPE_DWARF) nApp=APPEARANCE_TYPE_DWARF;
            else if (nRace==RACIAL_TYPE_ELF) nApp=APPEARANCE_TYPE_ELF;
            else if (nRace==RACIAL_TYPE_GNOME) nApp=APPEARANCE_TYPE_GNOME;
            else if (nRace==RACIAL_TYPE_HALFELF) nApp=APPEARANCE_TYPE_HALF_ELF;
            else if (nRace==RACIAL_TYPE_HALFORC) nApp=APPEARANCE_TYPE_HALF_ORC;
            else if (nRace==RACIAL_TYPE_HALFLING) nApp=APPEARANCE_TYPE_HALFLING;
            else if (nRace==RACIAL_TYPE_HUMAN) nApp=APPEARANCE_TYPE_HUMAN;
            SetCreatureAppearanceType(oCreature,nApp);
            nHead=d6();
            SetCreatureBodyPart(CREATURE_PART_HEAD,nHead,oCreature);
        } // reset appearance
        if (nPR>0)
        { // check for remove script
            Race_RemoveRace(oCreature,nPR);
        } // check for remove script
        if (nSR>0)
        { // check for remove script
            Race_RemoveRace(oCreature,nSR);
        } // check for remove script
    } // valid parameters
} // Race_StripRacialProperties()



//void main(){}
