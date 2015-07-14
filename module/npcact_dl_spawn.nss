////////////////////////////////////////////////////////////////////////////////
// npcact_dl_spawn - NPC ACTIVITIES Dynamic Lair - Spawn
//------------------------------------------------------------------------------
// Original Scripter: Deva B. Winblood    Scripted Date: 13-Nov-2006
//------------------------------------------------------------------------------
// Modified 09-Oct-2007 By Deva B. Winblood.   Settle overrides created
//------------------------------------------------------------------------------
// This script will check the population in the lair which is stored on the
// area object and if the population is less than nMaxPopulation on the waypoint
// the NPC is currently at it will process any SETTLE variables set upon them
// using the encounter system and spawn creatures.   If there is no settle
// variable defined it will spawn copies of this NPC.
// WAYPOINT VARIABLES:
// nMaxPopulation
// nRaidMark - at what population should raiders be produced
// sRaidTag - Virtual tag to give to raiders
// sRaidScript - Additional script to run upon a raider if needed
//------------------------------------------------------------------------------
// If the Settle waypoint has nMaxPopulation, and nRaidMark on the settle
// waypoint (e.g. Orc_Village) then this value will override the other.
////////////////////////////////////////////////////////////////////////////////
#include "npcact_h_dynamic"


void main()
{
     object oNPC=OBJECT_SELF;
     object oWP=GetLocalObject(oNPC,"oGNBArrived");
     int nMax=GetLocalInt(oWP,"nMaxPopulation");
     int nCurrent;
     int nRaid=GetLocalInt(oWP,"nRaidMark");
     string sRaidTag=GetLocalString(oWP,"sRaidTag");
     string sRaidScript=GetLocalString(oWP,"sRaidScript");
     string sSettle=GetLocalString(oNPC,"sNPCDL_Settle");
     string sWander=GetLocalString(oWP,"sWanderTag");
     string sS;
     string sParse;
     int nN;
     int nR;
     int nP;
     object oOb;
     object oSettle;
     object oArea=GetArea(oNPC);
     string sType;
     string sQuantity;
     string sDespawn;
     string sLocation;
     int nSpawn;
     if (GetStringLength(sSettle)>0)
     { // see if nMax and nRaid overrides
         oOb=GetWaypointByTag(sSettle);
         if (GetIsObjectValid(oOb))
         { // see if override
             nN=GetLocalInt(oOb,"nMaxPopulation");
             if (nN>0) nMax=nN;
             nN=GetLocalInt(oOb,"nRaidMark");
             if (nN>0) nRaid=nN;
         } // see if override
     } // see if nMax and nRaid overrides
     if (nMax>0)
     { // max exists
         NPCACT_DL_DEBUG("npcact_dl_spawn");
         nCurrent=0;
         oOb=NPCACT_DL_List_GetFirst(oArea);
         while(GetIsObjectValid(oOb)&&nCurrent<nMax)
         { // count
             nCurrent++;
             oOb=NPCACT_DL_List_GetNext(oArea);
         } // count
         if (nCurrent<nMax)
         { // okay to create
             if (GetStringLength(sSettle)>0)
             { // settle waypoint defined
                 oSettle=GetWaypointByTag(sSettle);
                 if (GetIsObjectValid(oSettle))
                 { // settle waypoint found
                     nR=d100(); // percentage roll
                     sLocation=GetTag(oWP);
                     nN=1;
                     nSpawn=0;
                     sS=GetLocalString(oSettle,"sSettler_"+IntToString(nN));
                     while(GetStringLength(sS)>0&&nSpawn==0)
                     { // find spawn type
                         nP=GetLocalInt(oSettle,"nPercentage_"+IntToString(nN));
                         if (nP>nR)
                         { // match
                             nSpawn=nN;
                         } // match
                         else
                         { // no match
                             nN++;
                             sS=GetLocalString(oSettle,"sSettler_"+IntToString(nN));
                         } // no match
                     } // find spawn type
                     if (nSpawn>0)
                     { // spawn type found
                         NPCACT_DL_DEBUG("   Spawn");
                         sS=GetLocalString(oSettle,"sSettler_"+IntToString(nSpawn));
                         sType=fnParse(sS,"/");
                         sQuantity=fnRemoveParsed(sS,sType,"/");
                         sDespawn="P";
                         nR=NPCACT_DL_ProcessQuantity(sQuantity);
                         if (nR>(nMax-nCurrent)) nR=nMax-nCurrent;
                         nN=0;
                         while(nN<nR)
                         { // spawn
                             nN++;
                             oOb=NPCACT_DL_SpawnCreature(oArea,sType,sLocation,sDespawn,oSettle);
                             if (!GetIsObjectValid(oOb))
                             { // failed to spawn
                                 PrintString("NPC ACTIVITIES Dynamic Lairs Area '"+GetName(oArea)+"' failed to spawn type '"+sType+"' stored on waypoint '"+GetTag(oSettle)+"'");
                                 return;
                             } // failed to spawn
                             if (GetStringLength(sWander)>0) SetLocalString(oOb,"sGNBVirtualTag",sWander);
                             if ((nCurrent+nN)>=nRaid)
                             { // raider
                                 SetAILevel(oOb,AI_LEVEL_NORMAL);
                                 if (GetStringLength(sRaidTag)>0) SetLocalString(oOb,"sGNBVirtualTag",sRaidTag);
                                 if (GetStringLength(sRaidScript)>0) ExecuteScript(sRaidScript,oOb);
                             } // raider
                         } // spawn
                     } // spawn type found
                     else
                     { // error
                         PrintString("NPC ACTIVITIES Dynamic Lairs  Area '"+GetName(oArea)+"' sSettler_# and percentages did not match on waypoint '"+GetTag(oSettle)+"'");
                     } // error
                 } // settle waypoint found
                 else
                 { // error
                     PrintString("NPC ACTIVITIES Dynamic Lairs  Area '"+GetName(oArea)+"' cannot find waypoint tagged '"+sSettle+"' for settling.");
                 } // error
             } // settle waypoint defined
             else
             { // create copies of myself
                 oOb=CreateObject(OBJECT_TYPE_CREATURE,GetResRef(oNPC),GetLocation(oNPC));
                 NPCACT_DL_List_Add(oArea,oOb);
                 if (GetStringLength(sWander)>0) SetLocalString(oOb,"sGNBVirtualTag",sWander);
                 if ((nCurrent+1)>nRaid)
                 { // raider
                     SetAILevel(oOb,AI_LEVEL_NORMAL);
                     if (GetStringLength(sRaidTag)>0) SetLocalString(oOb,"sGNBVirtualTag",sRaidTag);
                     if (GetStringLength(sRaidScript)>0) ExecuteScript(sRaidScript,oOb);
                 } // raider
                 if (GetLocalInt(oNPC,"bNPCDL_Possess")) ExecuteScript("npcact_dl_pos",oOb);
             } // create copies of myself
         } // okay to create
     } // max exists
     else
     { // error
         PrintString("NPC ACTIVITIES Dynamic Lair Area '"+GetName(oArea)+"' nMaxPopulation not defined on waypoint '"+GetTag(oWP)+"'");
     } // error
}
