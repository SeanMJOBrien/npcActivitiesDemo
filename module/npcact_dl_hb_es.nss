////////////////////////////////////////////////////////////////////////////////
// npcact_dl_hb_es - NPC ACTIVITIES Dynamic Lair - Heartbeat script for area or
//                   placeable.
//------------------------------------------------------------------------------
// Original Scripter: Deva B. Winblood      Scripted Date: 13-Nov-2006
//------------------------------------------------------------------------------
// PURPOSE: To handle the encounter system used with the dynamic lairs.   See
// the documentation that came with the script for complete details.
////////////////////////////////////////////////////////////////////////////////
#include "npcact_h_dynamic"

/////////////////////////
// PROTOTYPES
/////////////////////////


// FILE: npcact_dl_hb_es
// Despawn oObject as long as no PC can perceive it.  Otherwise move away from
// PC and try again in 18 seconds.
void fnDespawn(object oObject);


///////////////////////////////////////////////////////////////////[ MAIN ]/////
void main()
{
   object oEncounterObject=OBJECT_SELF;
   int nCount=GetLocalInt(oEncounterObject,"nNPCACTDL_HBCount");
   object oOb;
   object oArea=GetArea(oEncounterObject);
   string sDespawn;
   int nTime;
   int nN;
   int bDespawn;
   object oWP;
   if (!GetIsObjectValid(GetFirstPC())) return;
   if (nCount==1)
   { // clean area
       oWP=GetNearestObjectByTag("NPCACT_ENCOUNTER_DAY");
       if (GetIsNight()&&GetIsObjectValid(GetNearestObjectByTag("NPCACT_ENCOUNTER_NIGHT"))) oWP=GetNearestObjectByTag("NPCACT_ENCOUNTER_NIGHT");
       NPCACT_DL_DEBUG("Encounter Monitor AREA:"+GetName(GetArea(OBJECT_SELF))+" Cleanup");
       SetLocalInt(oEncounterObject,"nNPCACTDL_HBCount",2);
       nTime=NPCACT_DL_GetAbsoluteHour();
       oOb=NPCACT_DL_List_GetFirst(oArea);
       while(GetIsObjectValid(oOb))
       { // check to see if object needs to despawn
           sDespawn=GetLocalString(oOb,"sNPCDL_Despawn");
           sDespawn=GetStringUpperCase(sDespawn);
           if (GetStringLength(sDespawn)>0&&sDespawn!="P")
           { // a despawn condition exists
               bDespawn=FALSE;
               if (sDespawn=="R")
               { // raining
                   if (GetWeather(oArea)==WEATHER_RAIN) bDespawn=TRUE;
               } // raining
               else if (sDespawn=="C")
               { // clear weather
                   if (GetWeather(oArea)==WEATHER_CLEAR) bDespawn=TRUE;
               } // clear weather
               else if (sDespawn=="S")
               { // snowing
                   if (GetWeather(oArea)==WEATHER_SNOW) bDespawn=TRUE;
               } // snowing
               else if (sDespawn=="D")
               { // day
                   if (GetIsDay()) bDespawn=TRUE;
               } // day
               else if (sDespawn=="N")
               { // night
                   if (GetIsNight()) bDespawn=TRUE;
               } // night
               else
               { // hour
                   nN=StringToInt(sDespawn);
                   if(nTime-GetLocalInt(oOb,"nNPCACT_SpawnTime")>=nN) bDespawn=TRUE;
               } // hour
               if (bDespawn) DelayCommand(0.02,fnDespawn(oOb));
           } // a despawn condition exists
           oOb=NPCACT_DL_List_GetNext(oArea);
       } // check to see if object needs to despawn
   } // clean area
   else if (nCount>2)
   { // do encounter
       oWP=GetNearestObjectByTag("NPCACT_ENCOUNTER_DAY");
       if (GetIsNight()&&GetIsObjectValid(GetNearestObjectByTag("NPCACT_ENCOUNTER_NIGHT"))) oWP=GetNearestObjectByTag("NPCACT_ENCOUNTER_NIGHT");
       NPCACT_DL_DEBUG("Encounter Monitor AREA:"+GetName(GetArea(OBJECT_SELF))+" using waypoint:"+GetTag(oWP));
       DelayCommand(0.2,NPCACT_DL_HandleEncounter(oWP));
       DeleteLocalInt(oEncounterObject,"nNPCACTDL_HBCount");
   } // do encounter
   else
   { // only every 3 heartbeats to conserve CPU
       nCount++;
       NPCACT_DL_DEBUG("Encounter Monitor AREA:"+GetName(GetArea(OBJECT_SELF))+" nCount:"+IntToString(nCount));
       SetLocalInt(oEncounterObject,"nNPCACTDL_HBCount",nCount);
   } // only every 3 heartbeats to conserve CPU
}
///////////////////////////////////////////////////////////////////[ MAIN ]/////


/////////////////////////
// FUNCTIONS
/////////////////////////


void fnDespawn(object oObject)
{ // PURPOSE: To despawn a creature
    object oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oObject,1,CREATURE_TYPE_IS_ALIVE,TRUE);
    SetLocalInt(oObject,"nGNBDisabled",TRUE);
    if (!GetIsObjectValid(oPC)||!GetObjectSeen(oObject,oPC))
    { // despawn
        DestroyObject(oObject);
    } // despawn
    else
    { // wait
        DelayCommand(18.0,fnDespawn(oObject));
    } // wait
} // fnDespawn()


