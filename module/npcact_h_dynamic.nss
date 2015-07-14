////////////////////////////////////////////////////////////////////////////////
// npcact_h_dynamic - Support for Dynamic Lairs, Encounters, and Raiders
//------------------------------------------------------------------------------
// By Deva B. Winblood.   11/10/2006
// Requested by Daemon Blackrazor
//------------------------------------------------------------------------------
// PURPOSE: To functions used in several scripts in supporting dynamic lairs
//------------------------------------------------------------------------------
// MODIFIED: 09/23/2007 by Deva B. Winblood.
//        Added support for nEncounterChance
////////////////////////////////////////////////////////////////////////////////

#include "npcactivitiesh"

//////////////////////////////
// CONSTANTS
//////////////////////////////

const int DL_DEBUG_ON   = FALSE;  // set this to TRUE and rebuild scripts for
                                 // debugging information.


//////////////////////////////
// PROTOTYPES
//////////////////////////////


// FILE: npcact_h_dynamic    FUNCTION: NPCACT_DL_ProcessQuantity()
// This function will process the sQty parameter and return an amount.
int NPCACT_DL_ProcessQuantity(string sQty);


// FILE: npcact_h_dynamic    FUNCTION: NPCACT_DL_ProcessConditionals()
// This function will return TRUE if all conditions are met
// MODULE int <variable name> <comparison> <value>
// AREA int <variable name> <comparison> <value>
// WEATHER <weather type>    CLEAR, RAINING, SNOWING
// DELAY <game hours>
// oEncounterWP is the waypoint the encounter info is on.
int NPCACT_DL_ProcessConditionals(string sCondition,int nEncounterNum,object oEncounterWP);


// FILE: npcact_h_dynamic    FUNCTION: NPCACT_DL_GetAbsoluteHour()
// Returns the absolute hour it currently is.
int NPCACT_DL_GetAbsoluteHour();


// FILE: npcact_h_dynamic    FUNCTION: NPCACT_DL_SpawnCreature()
// This function will spawn a creature as defined by sType and will link it to
// the object oLinkTo.   sLocation is the tag of a waypoint to spawn the creature
// at.  sDespawn is the despawn condition which is # of game hours to despawn...
// P = permanent... does not despawn, R = Raining, C = Clear, S = Snow,
// D = Day, N = Night  oDataWP = Data Waypoint
object NPCACT_DL_SpawnCreature(object oLinkTo,string sType,string sLocation,string sDespawn,object oDataWP);


// FILE: npcact_h_dynamic    FUNCTION: NPCACT_DL_List_Add()
// This function will add oObject to a linked list on oLinkTo
void NPCACT_DL_List_Add(object oLinkTo,object oObject);


// FILE: npcact_h_dynamic    FUNCTION: NPCACT_DL_List_GetFirst()
// This function will return the first object in the linked list on oLinkTo.
object NPCACT_DL_List_GetFirst(object oLinkTo);


// FILE: npcact_h_dynamic    FUNCTION: NPCACT_DL_List_GetNext()
// This function will return the next object in the linked list on oLinkTo.
object NPCACT_DL_List_GetNext(object oLinkTo);


// FILE: npcact_h_dynamic    FUNCTION: NPCACT_DL_HandleEncounter()
// This function will handle the encounter object and process the parameters
// that stored on it to see if it should spawn some additional encounters.
void NPCACT_DL_HandleEncounter(object oEncounter);


// FILE: npcact_h_dynamic    FUNCTION: NPCACT_DL_DEBUG()
// This function will send debug messages.
void NPCACT_DL_DEBUG(string sMsg);


//////////////////////////////
// FUNCTIONS
//////////////////////////////

int NPCACT_DL_ProcessQuantity(string sQty)
{ // PURPOSE: Process quantities in the formats:
  // #, R#, or B#:#
    int nRet=0;
    string sIn=GetStringUpperCase(sQty);
    string sParse;
    if (GetStringLeft(sIn,1)=="R")
    { // random
        sIn=GetStringRight(sIn,GetStringLength(sIn)-1);
        nRet=Random(StringToInt(sIn))+1;
    } // random
    else if (GetStringLeft(sIn,1)=="B")
    { // bounded random
        sIn=GetStringRight(sIn,GetStringLength(sIn)-1);
        sParse=fnParse(sIn,":");
        sIn=fnRemoveParsed(sIn,sParse,":");
        nRet=Random(StringToInt(sIn)-StringToInt(sParse))+StringToInt(sParse);
    } // bounded random
    else
    { // numeric
        nRet=StringToInt(sIn);
    } // numeric
    NPCACT_DL_DEBUG("NPCACT_DL_ProcessQty("+sQty+") returns:"+IntToString(nRet));
    return nRet;
} // NPCACT_DL_ProcessQuantity()


int NPCACT_DL_GetAbsoluteHour()
{ // PURPOSE: Return the absolute hour
    return GetTimeHour()+(GetCalendarDay()*24)+(GetCalendarMonth()*24*30)+(GetCalendarYear()*24*30*12);
} // NPCACT_DL_GetAbsoluteHour()


int NPCACT_DL_ProcessConditionals(string sCondition,int nEncounterNum,object oEncounterWP)
{ // PURPOSE: Process conditionals and return TRUE if all conditions are met
    string sIn=sCondition;
    string sParse;
    string sS;
    int nN;
    string sVar;
    object oOb=GetModule();
    NPCACT_DL_DEBUG("NPCACT_DL_ProcessConditionals("+sCondition+","+IntToString(nEncounterNum)+","+GetTag(oEncounterWP)+")");
    while(GetStringLength(sIn)>0)
    { // process all conditions
        sParse=fnParse(sIn);
        sIn=fnRemoveParsed(sIn,sParse);
        sS=fnParse(sParse," ");
        sParse=fnRemoveParsed(sParse,sS," ");
        sS=GetStringUpperCase(sS);
        NPCACT_DL_DEBUG("   "+sS);
        if (sS=="MODULE"||sS=="AREA")
        { // variable
            if (sS=="AREA") oOb=GetArea(oEncounterWP);
            sS=fnParse(sParse," ");
            sParse=fnRemoveParsed(sParse,sS," ");
            sS=GetStringUpperCase(sS);
            if (sS=="INT")
            { // integer parameter
                sVar=fnParse(sParse," ");
                sParse=fnRemoveParsed(sParse,sVar," ");
                if (GetStringLength(sVar)<1)
                { // error
                    PrintString("NPC ACTIVITIES Dynamic Lair Error: Area:'"+GetName(GetArea(OBJECT_SELF))+"' object:'"+GetName(OBJECT_SELF)+"' Tag:'"+GetTag(OBJECT_SELF)+"' variable type conditional invalid variable name.");
                    return FALSE;
                } // error
                sS=fnParse(sParse," ");
                sParse=fnRemoveParsed(sParse,sS," ");
                nN=StringToInt(sParse);
                if (sS=="==")
                { // equal
                    if (GetLocalInt(oOb,sVar)!=nN) return FALSE;
                } // equal
                else if (sS=="!=")
                { // not equal
                    if (GetLocalInt(oOb,sVar)==nN) return FALSE;
                } // not equal
                else if (sS=="<")
                { // less than
                    if (GetLocalInt(oOb,sVar)>=nN) return FALSE;
                } // less than
                else if (sS==">")
                { // greater than
                    if (GetLocalInt(oOb,sVar)<=nN) return FALSE;
                } // greater than
                else if (sS=="<=")
                { // less than or equal to
                    if (GetLocalInt(oOb,sVar)>nN) return FALSE;
                } // less than or equal to
                else if (sS==">=")
                { // greater than or equal to
                    if (GetLocalInt(oOb,sVar)<nN) return FALSE;
                } // greater than or equal to
                else
                { // invalid comparison
                    PrintString("NPC ACTIVITIES Dynamic Lair Error: Area:'"+GetName(GetArea(OBJECT_SELF))+"' object:'"+GetName(OBJECT_SELF)+"' Tag:'"+GetTag(OBJECT_SELF)+"' variable type conditional invalid comparison '"+sS+"'");
                    return FALSE;
                } // invalid comparison
            } // integer parameter
            else
            { // error
                PrintString("NPC ACTIVITIES Dynamic Lair Error: Area:'"+GetName(GetArea(OBJECT_SELF))+"' object:'"+GetName(OBJECT_SELF)+"' Tag:'"+GetTag(OBJECT_SELF)+"' variable type conditional invalid '"+sS+"'");
                return FALSE;
            } // error
        } // variable
        else if (sS=="WEATHER")
        { // weather condition
            sParse=GetStringUpperCase(sParse);
            nN=GetWeather(GetArea(oEncounterWP));
            if (sS=="CLEAR")
            { // clear
                if (nN!=WEATHER_CLEAR) return FALSE;
            } // clear
            else if (sS=="RAINING")
            { // raining
                if (nN!=WEATHER_RAIN) return FALSE;
            } // raining
            else if (sS=="SNOWING")
            { // snowing
                if (nN!=WEATHER_SNOW) return FALSE;
            } // snowing
            else
            { // unknown
                PrintString("NPC ACTIVITIES Dynamic Lair Error: Area:'"+GetName(GetArea(OBJECT_SELF))+"' object:'"+GetName(OBJECT_SELF)+"' Tag:'"+GetTag(OBJECT_SELF)+"' weather conditional invalid '"+sParse+"'");
                return FALSE;
            } // unknown
        } // weather condition
        else if (sS=="DELAY")
        { // delay in game hours
            nN=GetLocalInt(oEncounterWP,"nNPCACTDelayEncounter"+IntToString(nEncounterNum));
            if ((NPCACT_DL_GetAbsoluteHour()-nN)<StringToInt(sParse)) return FALSE;
        } // delay in game hours
        else if (sS=="MAX")
        { // maximum number of creatures with specified tag
            sS=fnParse(sParse," ");
            sParse=fnRemoveParsed(sParse,sS," ");
            nN=StringToInt(sParse);
            nN=nN-1;
            if (nN>=0)
            { // valid
                oOb=GetObjectByTag(sS,nN);
                if (GetIsObjectValid(oOb)) return FALSE;
            } // valid
        } // maximum number of creatures with specified tag
    } // process all conditions
    return TRUE;
} // NPCACT_DL_ProcessConditionals()


object NPCACT_DL_List_GetFirst(object oLinkTo)
{ // PURPOSE: Return the first object in the linked list
    object oRet=OBJECT_INVALID;
    int nRoot;
    int nNext;
    int nPrev;
    object oOb;
    if (GetIsObjectValid(oLinkTo))
    { // return first node
        nRoot=GetLocalInt(oLinkTo,"nNPCACTDL_ListRoot");
        if (nRoot==0) return OBJECT_INVALID;
        oOb=GetLocalObject(oLinkTo,"oNPCACTDL_List"+IntToString(nRoot));
        NPCACT_DL_DEBUG("  NPCACT_DL_LIST_GetFirst("+GetName(oLinkTo)+"/"+GetTag(oLinkTo)+") Root:"+IntToString(nRoot));
        if (!GetIsObjectValid(oOb)||GetIsDead(oOb))
        { // invalid node
            nNext=GetLocalInt(oLinkTo,"nNPCACTDL_ListNext"+IntToString(nRoot));
            NPCACT_DL_DEBUG("    Invalid 1 - Tier 1    nNext="+IntToString(nNext));
            while(nNext!=0&&!GetIsObjectValid(oRet))
            { // next exists
                DeleteLocalObject(oLinkTo,"oNPCACTDL_List"+IntToString(nRoot));
                DeleteLocalInt(oLinkTo,"nNPCACTDL_ListRoot");
                SetLocalInt(oLinkTo,"nNPCACTDL_ListRoot",nNext);
                DeleteLocalInt(oLinkTo,"nNPCACTDL_ListPrev"+IntToString(nNext));
                nRoot=GetLocalInt(oLinkTo,"nNPCACTDL_ListRoot");
                oOb=GetLocalObject(oLinkTo,"oNPCACTDL_List"+IntToString(nRoot));
                NPCACT_DL_DEBUG("      nRoot:"+IntToString(nRoot)+"   nNext:"+IntToString(nNext));
                if (GetIsObjectValid(oOb)&&!GetIsDead(oOb))
                { // valid
                    NPCACT_DL_DEBUG("      FOUND");
                    oRet=oOb;
                } // valid
                else
                { // next
                    nNext=GetLocalInt(oLinkTo,"nNPCACTDL_ListNext"+IntToString(nRoot));
                } // next
            } // next exists
        } // invalid node
        else
        { // valid
            NPCACT_DL_DEBUG("      FOUND");
            oRet=oOb;
        } // valid
    } // return first node
    if (GetIsObjectValid(oRet)) SetLocalInt(oLinkTo,"nNPCACTDL_LastRead",GetLocalInt(oRet,"nNPCACTDL_ListPosition"));
    return oRet;
} // NPCACT_DL_List_GetFirst()


object NPCACT_DL_List_GetNext(object oLinkTo)
{ // PURPOSE: Return the next entry in the list on the object
    object oRet=OBJECT_INVALID;
    object oOb;
    int nN=GetLocalInt(oLinkTo,"nNPCACTDL_LastRead");
    int nNext;
    int nPrev;
    int nFound=0;
    if (!GetIsObjectValid(oLinkTo)) return OBJECT_INVALID;
    nNext=GetLocalInt(oLinkTo,"nNPCACTDL_ListNext"+IntToString(nN));
    NPCACT_DL_DEBUG("NPCACT_DL_List_GetNext("+GetName(oLinkTo)+"/"+GetTag(oLinkTo)+") nNext:"+IntToString(nNext));
    while(nNext!=0&&!GetIsObjectValid(oRet)&&nFound==0)
    { // find next
        nN=nNext;
        oOb=GetLocalObject(oLinkTo,"oNPCACTDL_List"+IntToString(nN));
        if (GetIsObjectValid(oOb)&&!GetIsDead(oOb))
        { // this is a valid object to return
            NPCACT_DL_DEBUG("   Found  ");
            oRet=oOb;
            nFound=nN;
        } // this is a valid object to return
        else
        { // invalid
            NPCACT_DL_DEBUG("    Remove invalid node");
            nNext=GetLocalInt(oLinkTo,"nNPCACTDL_ListNext"+IntToString(nN));
            if (nNext>0)
            { // valid
                nPrev=GetLocalInt(oLinkTo,"nNPCACTDL_ListPrev"+IntToString(nN));
                if (nPrev>0)
                { // valid previous
                    SetLocalInt(oLinkTo,"nNPCACTDL_ListNext"+IntToString(nPrev),nNext);
                    SetLocalInt(oLinkTo,"nNPCACTDL_ListPrev"+IntToString(nNext),nPrev);
                } // valid previous
                DeleteLocalInt(oLinkTo,"nNPCACTDL_ListNext"+IntToString(nN));
                DeleteLocalInt(oLinkTo,"nNPCACTDL_ListPrev"+IntToString(nN));
                DeleteLocalObject(oLinkTo,"oNPCACTDL_List"+IntToString(nN));
            } // valid
        } // invalid
        NPCACT_DL_DEBUG("    Loop nNext:"+IntToString(nNext));
    } // find next
    if (nFound>0) SetLocalInt(oLinkTo,"nNPCACTDL_LastRead",nFound);
    return oRet;
} // NPCACT_DL_List_GetNext()


void NPCACT_DL_List_Add(object oLinkTo,object oObject)
{ // PURPOSE: Add oObject into the linked list on oLinkTo
    object oRet=OBJECT_INVALID;
    int nRoot;
    int nNext;
    int nNew;
    object oOb;
    if (!GetIsObjectValid(oLinkTo)) return;
    NPCACT_DL_DEBUG("NPCACT_DL_List_Add("+GetName(oLinkTo)+","+GetName(oObject)+")");
    nRoot=GetLocalInt(oLinkTo,"nNPCACTDL_ListRoot");
    if (nRoot==0)
    { // new list
        SetLocalInt(oObject,"nNPCACTDL_ListPosition",1);
        SetLocalInt(oLinkTo,"nNPCACTDL_ListRoot",1);
        SetLocalObject(oLinkTo,"oNPCACTDL_List1",oObject);
    } // new list
    else
    { // add node
        nNext=GetLocalInt(oLinkTo,"nNPCACTDL_ListNext"+IntToString(nRoot));
        nNew=Random(999)+1;
        oOb=GetLocalObject(oLinkTo,"oNPCACTDL_List"+IntToString(nNew));
        while(GetIsObjectValid(oOb))
        { // find an empty slot
            nNew++;
            oOb=GetLocalObject(oLinkTo,"oNPCACTDL_List"+IntToString(nNew));
        } // find an empty slot
        SetLocalInt(oLinkTo,"nNPCACTDL_ListPrev"+IntToString(nRoot),nNew);
        SetLocalInt(oLinkTo,"nNPCACTDL_ListNext"+IntToString(nNew),nRoot);
        SetLocalInt(oLinkTo,"nNPCACTDL_ListRoot",nNew);
        SetLocalObject(oLinkTo,"oNPCACTDL_List"+IntToString(nNew),oObject);
        SetLocalInt(oObject,"nNPCACTDL_ListPosition",nNew);
    } // add node
} // NPCACT_DL_List_Add()


object NPCACT_DL_SpawnCreature(object oLinkTo,string sType,string sLocation,string sDespawn,object oDataWP)
{ // PURPOSE: Spawn a creature and add it to the specified object
    object oRet=OBJECT_INVALID;
    object oCreature;
    object oWP;
    string sS;
    string sParse;
    string sKey;
    string sName;
    string sTag;
    string sVTag;
    string sAppearance;
    string sPhenotype;
    string sHead;
    string sScripts;
    string sInts;
    string sStrings;
    string sItems;
    string sArmor;
    string sHelmet;
    string sWeapon;
    string sAmmo;
    string sFaction;
    string sAI;
    string sResRef;
    string sSettle;
    int nR;
    int nC;
    int nN;
    object oOb;
    if (GetIsObjectValid(oLinkTo)&&GetIsObjectValid(oDataWP))
    { // valid parameters
        NPCACT_DL_DEBUG("NPCACT_DL_SpawnCreature("+GetName(oLinkTo)+","+sType+","+sLocation+","+sDespawn+","+GetTag(oDataWP)+")");
        sKey=GetLocalString(oDataWP,"sEncounterType_"+sType);
        sResRef=fnParse(sKey);
        sKey=fnRemoveParsed(sKey,sResRef);
        if (GetStringLength(sResRef)>0)
        { // resref specified
            while(GetStringLength(sKey)>0)
            { // process optional parameters
                sParse=fnParse(sKey);
                NPCACT_DL_DEBUG("  sKey='"+sKey+"' sParse='"+sParse+"'");
                sKey=fnRemoveParsed(sKey,sParse);
                sS=fnParse(sParse," ");
                sParse=fnRemoveParsed(sParse,sS," ");
                sS=GetStringUpperCase(sS);
                NPCACT_DL_DEBUG("    sKey='"+sKey+"'  sS='"+sS+"'  sParse='"+sParse+"'");
                if (sS=="TAG") sTag=sParse;
                else if (sS=="VTAG")
                { // virtual tag
                    sVTag=sParse;
                    NPCACT_DL_DEBUG("      Virtual Tag:"+sVTag);
                } // virtual tag
                else if (sS=="NAME") sName=sParse;
                else if (sS=="SCRIPT") sScripts=sScripts+sParse+".";
                else if (sS=="ARMOR") sArmor=sParse;
                else if (sS=="HELMET") sHelmet=sParse;
                else if (sS=="WEAPON") sWeapon=sParse;
                else if (sS=="AMMO") sAmmo=sParse;
                else if (sS=="FACTION") sFaction=sParse;
                else if (sS=="AI") sAI=sParse;
                else if (sS=="SETTLE") sSettle=sParse;
                else if (sS=="RNAME")
                { // random name
                    sS=fnParse(sParse,"/");
                    sParse=fnRemoveParsed(sParse,sS,"/");
                    nR=Random(StringToInt(sS))+1;
                    nC=0;
                    sName="";
                    while(GetStringLength(sName)<1&&GetStringLength(sParse)>0)
                    { // pick random name
                        sS=fnParse(sParse,"/");
                        sParse=fnRemoveParsed(sParse,sS,"/");
                        nC++;
                        if (nC==nR) sName=sS;
                    } // pick random name
                    NPCACT_DL_DEBUG("      Random Name:"+sName);
                } // random name
                else if (sS=="APPEARANCE")
                { // random appearance
                    sS=fnParse(sParse,"/");
                    sParse=fnRemoveParsed(sParse,sS,"/");
                    nR=Random(StringToInt(sS))+1;
                    nC=0;
                    sAppearance="";
                    while(GetStringLength(sAppearance)<1&&GetStringLength(sParse)>0)
                    { // pick random appearance
                        sS=fnParse(sParse,"/");
                        sParse=fnRemoveParsed(sParse,sS,"/");
                        nC++;
                        if (nC==nR) sAppearance=sS;
                    } // pick random appearance
                    NPCACT_DL_DEBUG("      Random Appearance:"+sAppearance);
                } // random appearance
                else if (sS=="PHENOTYPE")
                { // random phenotype
                    sS=fnParse(sParse,"/");
                    sParse=fnRemoveParsed(sParse,sS,"/");
                    nR=Random(StringToInt(sS))+1;
                    nC=0;
                    sPhenotype="";
                    while(GetStringLength(sPhenotype)<1&&GetStringLength(sParse)>0)
                    { // pick random phenotype
                        sS=fnParse(sParse,"/");
                        sParse=fnRemoveParsed(sParse,sS,"/");
                        nC++;
                        if (nC==nR) sPhenotype=sS;
                    } // pick random phenotype
                    NPCACT_DL_DEBUG("      Random Phenotype:"+sPhenotype);
                } // random phenotype
                else if (sS=="HEAD")
                { // random head
                    sS=fnParse(sParse,"/");
                    sParse=fnRemoveParsed(sParse,sS,"/");
                    nR=Random(StringToInt(sS))+1;
                    nC=0;
                    sHead="";
                    while(GetStringLength(sAppearance)<1&&GetStringLength(sParse)>0)
                    { // pick random head
                        sS=fnParse(sParse,"/");
                        sParse=fnRemoveParsed(sParse,sS,"/");
                        nC++;
                        if (nC==nR) sHead=sS;
                    } // pick random head
                    NPCACT_DL_DEBUG("      Random Head:"+sHead);
                } // random head
                else if (sS=="INT")
                { // integer
                    sS=fnParse(sParse," ");
                    sParse=fnRemoveParsed(sParse,sS," ");
                    sInts=sInts+sS+"/"+sParse+".";
                } // integer
                else if (sS=="STRING")
                { // strings
                    sS=fnParse(sParse," ");
                    sParse=fnRemoveParsed(sParse,sS," ");
                    sStrings=sStrings+sS+"/"+sParse+".";
                } // strings
                else if (sS=="ITEM")
                { // items
                    sS=fnParse(sParse," ");
                    sParse=fnRemoveParsed(sParse,sS," ");
                    sItems=sItems+sS+"/"+sParse+".";
                } // items
            } // process optional parameters
          // Process parameters
          oWP=GetWaypointByTag(sLocation);
          if (!GetIsObjectValid(oWP)) oWP=oLinkTo;
          oCreature=CreateObject(OBJECT_TYPE_CREATURE,sResRef,GetLocation(oWP),FALSE,sTag);
          if (GetIsObjectValid(oCreature)) NPCACT_DL_List_Add(oLinkTo,oCreature);
          if (GetStringLength(sName)>0) SetName(oCreature,sName);
          if (GetStringLength(sAppearance)>0) SetCreatureAppearanceType(oCreature,StringToInt(sAppearance));
          if (GetStringLength(sPhenotype)>0) SetPhenoType(StringToInt(sPhenotype),oCreature);
          if (GetStringLength(sHead)>0) SetCreatureBodyPart(CREATURE_PART_HEAD,StringToInt(sHead),oCreature);
          if (GetStringLength(sFaction)>0)
          { // faction change
              oOb=GetObjectByTag(sFaction);
              if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
              { // proxy found
                  ChangeFaction(oCreature,oOb);
              } // proxy found
          } // faction change
          if (GetStringLength(sVTag)>0)
          { // virtual tagging
              SetLocalString(oCreature,"sGNBVirtualTag",sVTag);
          } // virtual tagging
          if (GetStringLength(sInts)>0)
          { // integers
              sKey=fnParse(sInts);
              while(GetStringLength(sInts)>0)
              { // set integers
                  sInts=fnRemoveParsed(sInts,sKey);
                  sS=fnParse(sKey,"/");
                  sParse=fnRemoveParsed(sKey,sS,"/");
                  SetLocalInt(oCreature,sS,StringToInt(sParse));
                  sKey=fnParse(sInts);
              } // set integers
          } // integers
          if (GetStringLength(sStrings)>0)
          { // strings
              sKey=fnParse(sStrings);
              while(GetStringLength(sStrings)>0)
              { // set integers
                  sStrings=fnRemoveParsed(sStrings,sKey);
                  sS=fnParse(sKey,"/");
                  sParse=fnRemoveParsed(sKey,sS,"/");
                  SetLocalString(oCreature,sS,sParse);
                  sKey=fnParse(sStrings);
              } // set integers
          } // strings
          if (GetStringLength(sItems)>0)
          { // items
              sKey=fnParse(sItems);
              while(GetStringLength(sItems)>0)
              { // set integers
                  sStrings=fnRemoveParsed(sItems,sKey);
                  sS=fnParse(sKey,"/");
                  sParse=fnRemoveParsed(sKey,sS,"/");
                  nC=0;
                  nN=NPCACT_DL_ProcessQuantity(sParse);
                  if (nN>5)
                  { // stack based
                      oOb=CreateItemOnObject(sS,oCreature,nN);
                  } // stack based
                  else
                  { // non-stack
                      while(nC<nN)
                      { // create items
                          nC++;
                          oOb=CreateItemOnObject(sS,oCreature);
                      } // create items
                  } // non-stack
                  sKey=fnParse(sItems);
              } // set integers
          } // items
          if (GetStringLength(sAI)>0)
          { // set AI
              sAI=GetStringUpperCase(sAI);
              if (sAI=="NORMAL") SetAILevel(oCreature,AI_LEVEL_NORMAL);
              else if (sAI=="DEFAULT") SetAILevel(oCreature,AI_LEVEL_DEFAULT);
              else if (sAI=="LOW") SetAILevel(oCreature,AI_LEVEL_LOW);
              else if (sAI=="HIGH") SetAILevel(oCreature,AI_LEVEL_HIGH);
              else
              { // error
                  PrintString("NPC ACTIVITIES Dynamic Lair Error: Area:'"+GetName(GetArea(oLinkTo))+"' object:'"+GetName(oLinkTo)+"' Tag:'"+GetTag(oLinkTo)+"' invalid AI setting '"+sAI+"'");
              } // error
          } // set AI
          if (GetStringLength(sArmor)>0)
          { // armor
              oOb=GetItemPossessedBy(oCreature,sArmor);
              AssignCommand(oCreature,ActionEquipItem(oOb,INVENTORY_SLOT_CHEST));
          } // armor
          if (GetStringLength(sHelmet)>0)
          { // helmet
              oOb=GetItemPossessedBy(oCreature,sHelmet);
              AssignCommand(oCreature,ActionEquipItem(oOb,INVENTORY_SLOT_HEAD));
          } // helmet
          if (GetStringLength(sWeapon)>0)
          { // weapon
              oOb=GetItemPossessedBy(oCreature,sWeapon);
              AssignCommand(oCreature,ActionEquipItem(oOb,INVENTORY_SLOT_RIGHTHAND));
          } // weapon
          if (GetStringLength(sAmmo)>0)
          { // ammo
              oOb=GetItemPossessedBy(oCreature,sAmmo);
              if (GetBaseItemType(oOb)==BASE_ITEM_ARROW) AssignCommand(oCreature,ActionEquipItem(oOb,INVENTORY_SLOT_ARROWS));
              else if (GetBaseItemType(oOb)==BASE_ITEM_BOLT) AssignCommand(oCreature,ActionEquipItem(oOb,INVENTORY_SLOT_BOLTS));
              else if (GetBaseItemType(oOb)==BASE_ITEM_BULLET) AssignCommand(oCreature,ActionEquipItem(oOb,INVENTORY_SLOT_BULLETS));
          } // ammo
          if (GetStringLength(sSettle)>0) SetLocalString(oCreature,"sNPCDL_Settle",sSettle);
          if (GetStringLength(sScripts)>0)
          { // scripts
              NPCACT_DL_DEBUG("    ExecuteScripts  '"+sScripts+"'");
              sKey=fnParse(sScripts);
              while(GetStringLength(sScripts)>0&&GetStringLength(sKey)>0)
              { // execute scripts
                  sScripts=fnRemoveParsed(sScripts,sKey);
                  NPCACT_DL_DEBUG("     Script: '"+sKey+"'");
                  DelayCommand((2.0+(IntToFloat(d20())/10.0)),ExecuteScript(sKey,oCreature));
                  sKey=fnParse(sScripts);
              } // execute scripts
          } // scripts
          SetLocalString(oCreature,"sNPCDL_Despawn",sDespawn);
          SetLocalInt(oCreature,"nNPCACT_SpawnTime",NPCACT_DL_GetAbsoluteHour());
          NPCACT_DL_DEBUG("   Resulting Creature '"+GetName(oCreature)+"' TAG:"+GetTag(oCreature)+"  VTAG:"+GetLocalString(oCreature,"sGNBVirtualTag"));
          oRet=oCreature;
        } // resref specified
        else
        { // error
            PrintString("NPC ACTIVITIES Dynamic Lair Error: Area:'"+GetName(GetArea(oLinkTo))+"' object:'"+GetName(oLinkTo)+"' Tag:'"+GetTag(oLinkTo)+"' spawn had no resref specified for type '"+sType+"'");
            return OBJECT_INVALID;
        } // error
    } // valid parameters
    return oRet;
} // NPCACT_DL_SpawnCreature()

void privateWrapReturn(object oRet)
{
}

void NPCACT_DL_HandleEncounter(object oEncounter)
{ // PURPOSE: Handle the encounter information stored on the object
  // and if need be spawn some creatures.
    object oCreature;
    object oOb;
    int nR;
    int nC;
    int nN;
    string sS;
    string sParse;
    string sType;
    string sQuantity;
    string sDespawn;
    string sLocation;
    int nMax;
    int nCurrent;
    if (!GetIsObjectValid(oEncounter)) return;
    nN=GetLocalInt(oEncounter,"nCheckFrequency");
    nC=GetLocalInt(oEncounter,"nLastEncounter");
    NPCACT_DL_DEBUG("NPCACT_DL_HandleEncounter("+GetName(oEncounter)+"/"+GetTag(oEncounter)+")");
    if ((NPCACT_DL_GetAbsoluteHour()-nC)<nN) return; // not enough time passed
    NPCACT_DL_DEBUG("    Enough time has passed for the encounter.");
    nMax=GetLocalInt(oEncounter,"nMaxPopulation");
    if (nMax<1)
    { // no max specified - error
        oOb=oEncounter;
        if (GetObjectType(oOb)==OBJECT_TYPE_WAYPOINT) oOb=GetArea(oOb);
        PrintString("NPC ACTIVITIES Dynamic Lair Error:  No maximum population nMaxPopulation specified in encounter area '"+GetName(oOb)+"'");
        return;
    } // no max specified - error
    nCurrent=0;
    oOb=NPCACT_DL_List_GetFirst(GetArea(oEncounter));
    while(GetIsObjectValid(oOb))
    { // count encounters
        nCurrent++;
        oOb=NPCACT_DL_List_GetNext(GetArea(oEncounter));
    } // count encounters
    NPCACT_DL_DEBUG("    Population:"+IntToString(nCurrent)+"/"+IntToString(nMax));
    if (nCurrent>=nMax) return; // max population already spawned
    nN=GetLocalInt(oEncounter,"nEncounterChance");
    nR=d100();
    if (nN>0&&nR>nN) return; // Encounter Percentage not met
    nR=d100();
    nC=0;
    nN=0;
    NPCACT_DL_DEBUG("    Percentage Roll:"+IntToString(nR));
    while(nC==0&&nR>0)
    { // find encounter
        nN++;
        sS=GetLocalString(oEncounter,"sEncounterConditions_"+IntToString(nN));
        nMax=GetLocalInt(oEncounter,"nEncounterPercentage_"+IntToString(nN));
        NPCACT_DL_DEBUG("       Check #"+IntToString(nN)+"  Percentage:"+IntToString(nMax)+" vs. Roll:"+IntToString(nR));
        if (nMax<1) nC=-1;
        if (nMax>=nR&&nMax>0)
        { // possibly valid
            NPCACT_DL_DEBUG("        Call Conditional Check.");
            if (NPCACT_DL_ProcessConditionals(sS,nN,oEncounter))
            { // conditions passed
                nC=nN;
            } // conditions passed
        } // possibly valid
        else
        { // subtract
            nR=nR-nMax;
        } // subtract
    } // find encounter
    if (nC>0)
    { // encounter type specified
        NPCACT_DL_DEBUG("  Spawn Encounter #:"+IntToString(nC));
        sS=GetLocalString(oEncounter,"sEncounter_"+IntToString(nC));
        sType=fnParse(sS,"/");
        sS=fnRemoveParsed(sS,sType,"/");
        sQuantity=fnParse(sS,"/");
        sS=fnRemoveParsed(sS,sQuantity,"/");
        sDespawn=fnParse(sS,"/");
        sLocation=fnRemoveParsed(sS,sDespawn,"/");
        nN=NPCACT_DL_ProcessQuantity(sQuantity);
        if (nN>(nMax-nCurrent)) nN=nMax-nCurrent;
        if (nN>0)
        { // spawn
            NPCACT_DL_DEBUG("    Okay to spawn: '"+sType+"'");
            nC=0;
            while(nN>nC)
            { // spawn
                nC++;
                DelayCommand(1.0+(IntToFloat(nC)*0.5),privateWrapReturn(NPCACT_DL_SpawnCreature(GetArea(oEncounter),sType,sLocation,sDespawn,oEncounter)));
            } // spawn
            SetLocalInt(oEncounter,"nLastEncounter",NPCACT_DL_GetAbsoluteHour());
        } // spawn
    } // encounter type specified
} // NPCACT_DL_HandleEncounter()


void NPCACT_DL_DEBUG(string sMsg)
{ // PURPOSE: Send debug messages
    if (DL_DEBUG_ON)
    { // message
        SendMessageToPC(GetFirstPC(),sMsg);
        PrintString(sMsg);
    } // message
} // NPCACT_DL_DEBUG()

//void main(){}
