////////////////////////////////////////////////////////////////////////////////
// npcact_wrap1 - OnHeartbeat Wrapper (works for NPC ACTIVITIES and RTSA
//==============================================================================
// By Deva Bryson Winblood.   NPC ACTIVITIES 6.0 & RTSA 2.0
////////////////////////////////////////////////////////////////////////////////
// sCRSPHB      - NPC ACTIVITIES Custom Script
// sRTSA_wrap1  - RTSA Custom Script
// nWrap_Mode   - 0 = NPC ACT then RTSA (both), 1= NPC ACT, 2 = RTSA, 3 = Bioware
//                4 = Henchmen Earlier, 5 = NPC ACTIVITIES Henchmen, 6 = both + Bioware,
//                7 = Jasperre's AI, 8 = CODI AI, 9 = Custom only or NULL
// nGNBCloseMode - 0 = Waypoints anywhere in the module, 1 = near waypoints only
void main()
{
    //Qlippoth - Follower heartbeat script START
object oSelf = OBJECT_SELF;
object oSpawner = GetLocalObject(oSelf, "MASTERD");
int nAction = GetCurrentAction(oSelf);
int bRun = TRUE;
if((nAction == ACTION_WAIT || nAction == ACTION_INVALID) && oSpawner != OBJECT_INVALID)
  {
  ClearAllActions();
  ActionMoveToObject(oSpawner,1,2.0);
  }      //Qlippoth - Follower heartbeat script END
     object oMe=OBJECT_SELF;
     string sCRSP=GetLocalString(oMe,"sCRSPHB");
     string sRTSA=GetLocalString(oMe,"sRTSA_wrap1");
     int nMode=GetLocalInt(oMe,"nWrap_Mode");
     int nGNB=GetLocalInt(oMe,"nGNBCloseMode");
     string sWPName="POST_"+GetTag(oMe);
     string sDefault="nw_c2_default1";
     string sNPC_SCRIPT="npcactivities6"; // npc activities 6.0
     string sRTSA_SCRIPT="x2_def_heartbeat"; // RTSA script
     string sX2Default="x2_def_heartbeat";
     string sEarlyHench="nw_ch_ac1";
     string sNewHench="npcact_hench1";
     string sJASP="j_ai_onheartbeat";
     string sCODI="no_ai_hrt";
     int nGNBDisabled=GetLocalInt(oMe,"nGNBDisabled");
     //if (GetTag(oMe)=="WREN") SendMessageToPC(GetFirstPC(),"wrapper(nMode="+IntToString(nMode)+" waypointname="+sWPName+")");
     if (nMode==0)
     { // both scripts
       if (sCRSP!=""||sRTSA!="")
       { // NPC ACT and RTSA enabled custom
         if (sCRSP!="") ExecuteScript(sCRSP,oMe);
         if (sRTSA!="") ExecuteScript(sRTSA,oMe);
       } // NPC ACT and RTSA enabled custom
       else if (((nGNB==0&&GetWaypointByTag(sWPName)!=OBJECT_INVALID)||(nGNB==1&&GetNearestObjectByTag(sWPName,oMe,1)!=OBJECT_INVALID))&&nGNBDisabled!=TRUE)
       { // NPC ACTIVITIES!!
         //if (GetTag(oMe)=="WREN") SendMessageToPC(GetFirstPC(),"  execute "+sNPC_SCRIPT);
         ExecuteScript(sNPC_SCRIPT,oMe);
       } // NPC ACTIVITIES!!
       else if (GetStringLength(GetLocalString(oMe,"sTeamID"))>0)
       { // RTSA
         ExecuteScript(sRTSA_SCRIPT,oMe);
       } // RTSA
       else
       { // default script
         ExecuteScript(sX2Default,oMe);
       } // default script
     } // both scripts
     else if (nMode==1)
     { // NPC ACTIVITIES
       if (sCRSP!="")
       { // custom
         ExecuteScript(sCRSP,oMe);
       } // custom
       else if (((nGNB==0&&GetWaypointByTag(sWPName)!=OBJECT_INVALID)||(nGNB==1&&GetNearestObjectByTag(sWPName,oMe,1)!=OBJECT_INVALID))&&nGNBDisabled!=TRUE)
       { // NPC ACTIVITIES!!
         ExecuteScript(sNPC_SCRIPT,oMe);
       } // NPC ACTIVITIES!!
       else
       { // default script
         ExecuteScript(sX2Default,oMe);
       } // default script
     } // NPC ACTIVITIES
     else if (nMode==2)
     { // RTSA
       if (sRTSA!="")
       { // custom
         ExecuteScript(sRTSA,oMe);
       } // custom
       else
       { // default
         ExecuteScript(sRTSA_SCRIPT,oMe);
       } // default
     } // RTSA
     else if (nMode==3)
     { // BIOWARE
       ExecuteScript(sX2Default,oMe);
     } // BIOWARE
     else if (nMode==4)
     { // Earlier style henchmen
       ExecuteScript(sEarlyHench,oMe);
     } // Earlier style henchmen
     else if (nMode==5)
     { // later style henchmen
       ExecuteScript(sNewHench,oMe);
     } // later style henchmen
     else if (nMode==6)
     { // both custom scripts followed by Biowares
       if (sCRSP!="") ExecuteScript(sCRSP,oMe);
       if (sRTSA!="") ExecuteScript(sRTSA,oMe);
       ExecuteScript(sX2Default,oMe);
     } // both custom scripts followed by Biowares
     else if (nMode==7)
     { // Jasperre's AI
       ExecuteScript(sJASP,oMe);
     } // Jasperre's AI
     else if (nMode==8)
     { // CODI AI
       ExecuteScript(sCODI,oMe);
     } // CODI AI
     else if (nMode==9)
     { // run only custom or NONE at all
       if (sCRSP!="") ExecuteScript(sCRSP,oMe);
       if (sRTSA!="") ExecuteScript(sRTSA,oMe);
     } // run only custom or NONE at all
}
