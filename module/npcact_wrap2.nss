////////////////////////////////////////////////////////////////////////////////
// npcact_wrap2 - OnPerception Wrapper (works for NPC ACTIVITIES and RTSA
//==============================================================================
// By Deva Bryson Winblood.   NPC ACTIVITIES 6.0 & RTSA 2.0
////////////////////////////////////////////////////////////////////////////////
// sCRSPPerception - NPC ACTIVITIES Custom Script
// sRTSA_wrap2  - RTSA Custom Script
// nWrap_Mode   - 0 = NPC ACT then RTSA (both), 1= NPC ACT, 2 = RTSA, 3 = Bioware
//                4 = Henchmen Earlier, 5 = NPC ACTIVITIES Henchmen, 6 = both + Bioware,
//                7 = Jasperre's AI, 8 = CODI AI, 9 = Custom only or NULL
// nGNBCloseMode - 0 = Waypoints anywhere in the module, 1 = near waypoints only
//==========================================================================
// OnPerception modifiers
// These variables when set to TRUE will cause the perception script to be
// more choosy when reacting to perception events
// bGNBNoPerceiveEnemy
// bGNBNoPerceiveNeutral
// bGNBNoPerceiveFriend
// bGNBNoPerceiveNPC
// bGNBNoPerceivePC
void main()
{
     object oMe=OBJECT_SELF;
     string sCRSP=GetLocalString(oMe,"sCRSPPerception");
     string sRTSA=GetLocalString(oMe,"sRTSA_wrap2");
     int nMode=GetLocalInt(oMe,"nWrap_Mode");
     int nGNB=GetLocalInt(oMe,"nGNBCloseMode");
     string sWPName="POST_"+GetTag(oMe);
     string sDefault="nw_c2_default2";
     string sNPC_SCRIPT="npcact_script2"; // npc activities
     string sRTSA_SCRIPT="x2_def_percept"; // RTSA script
     string sX2Default="x2_def_percept";
     string sEarlyHench="nw_ch_ac2";
     string sNewHench="npcact_hench2";
     string sJASP="j_ai_onpercieve";
     string sCODI="no_ai_per";
     int nGNBDisabled=GetLocalInt(oMe,"nGNBDisabled");
     int bOkayToPerceive=TRUE;
     object oPerceived=GetLastPerceived();
     if (GetLocalInt(oMe,"bGNBNoPerceiveEnemy")==TRUE&&GetIsEnemy(oPerceived,oMe)==TRUE) bOkayToPerceive=FALSE;
     else if (GetLocalInt(oMe,"bGNBNoPerceiveNeutral")==TRUE&&GetIsNeutral(oPerceived,oMe)==TRUE) bOkayToPerceive=FALSE;
     else if (GetLocalInt(oMe,"bGNBNoPerceiveFriend")==TRUE&&GetIsFriend(oPerceived,oMe)==TRUE) bOkayToPerceive=FALSE;
     else if (GetLocalInt(oMe,"bGNBNoPerceiveNPC")==TRUE&&GetIsPC(oPerceived)==FALSE) bOkayToPerceive=FALSE;
     else if (GetLocalInt(oMe,"bGNBNoPerceivePC")==TRUE&&GetIsPC(oPerceived)==TRUE) bOkayToPerceive=FALSE;
     if (bOkayToPerceive)
     { // has passed filters
     if (nMode==0)
     { // both scripts
       if (sCRSP!=""||sRTSA!="")
       { // NPC ACT and RTSA enabled custom
         if (sCRSP!="") ExecuteScript(sCRSP,oMe);
         if (sRTSA!="") ExecuteScript(sRTSA,oMe);
       } // NPC ACT and RTSA enabled custom
       else if (((nGNB==0&&GetWaypointByTag(sWPName)!=OBJECT_INVALID)||(nGNB==1&&GetNearestObjectByTag(sWPName,oMe,1)!=OBJECT_INVALID))&&nGNBDisabled!=TRUE)
       { // NPC ACTIVITIES!!
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
    } // has passed filters
}
