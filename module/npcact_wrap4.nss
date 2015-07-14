////////////////////////////////////////////////////////////////////////////////
// npcact_wrap4 - OnConversation Wrapper (works for NPC ACTIVITIES and RTSA
//==============================================================================
// By Deva Bryson Winblood.   NPC ACTIVITIES 6.0 & RTSA 2.0
////////////////////////////////////////////////////////////////////////////////
// sCRSPConversation - NPC ACTIVITIES Custom Script
// sRTSA_wrap4  - RTSA Custom Script
// nWrap_Mode   - 0 = NPC ACT then RTSA (both), 1= NPC ACT, 2 = RTSA, 3 = Bioware
//                4 = Henchmen Earlier, 5 = NPC ACTIVITIES Henchmen, 6 = both + Bioware,
//                7 = Jasperre's AI, 8 = CODI AI, 9 = Custom only or NULL
// nGNBCloseMode - 0 = Waypoints anywhere in the module, 1 = near waypoints only
//==============================================================================
// This script has some special feature support.
// oGNBListenOnlyTo - can be used to specify an object so, will only listen to one source
// bGNBNoListenNPC - Do not listen to NPCs
// bGNBNoListenEnemy - Do not listen to enemies
// bGNBNoListenNeutral - Do not listen to neutral
// bGNBNoListenFriend - Do not listen to friends
// bGNBNoListenPC - Do not listen to PCs
void main()
{
     object oMe=OBJECT_SELF;
     string sCRSP=GetLocalString(oMe,"sCRSPConversation");
     string sRTSA=GetLocalString(oMe,"sRTSA_wrap4");
     int nMode=GetLocalInt(oMe,"nWrap_Mode");
     int nGNB=GetLocalInt(oMe,"nGNBCloseMode");
     string sWPName="POST_"+GetTag(oMe);
     string sDefault="nw_c2_default4";
     string sNPC_SCRIPT="nw_c2_default4"; // npc activities
     string sRTSA_SCRIPT="x2_def_onconv"; // RTSA script
     string sX2Default="x2_def_onconv";
     string sEarlyHench="nw_ch_ac4";
     string sNewHench="npcact_hench4";
     string sJASP="j_ai_onconversat";
     string sCODI="no_ai_cnv";
     int nGNBDisabled=GetLocalInt(oMe,"nGNBDisabled");
     object oSpeaker=GetLastSpeaker();
     object oOb=GetLocalObject(oMe,"oGNBListenOnlyTo");
     int bListenOkay=TRUE;
     if (oOb!=OBJECT_INVALID&&oOb!=oSpeaker) bListenOkay=FALSE;
     else if (GetLocalInt(oMe,"bGNBNoListenNPC")==TRUE&&GetIsPC(oSpeaker)==FALSE) bListenOkay=FALSE;
     else if (GetLocalInt(oMe,"bGNBNoListenPC")==TRUE&&GetIsPC(oSpeaker)==TRUE) bListenOkay=FALSE;
     else if (GetLocalInt(oMe,"bGNBNoListenEnemy")==TRUE&&GetIsEnemy(oSpeaker,oMe)==TRUE) bListenOkay=FALSE;
     else if (GetLocalInt(oMe,"bGNBNoListenNeutral")==TRUE&&GetIsNeutral(oSpeaker,oMe)==TRUE) bListenOkay=FALSE;
     else if (GetLocalInt(oMe,"bGNBNoListenFriend")==TRUE&&GetIsFriend(oSpeaker,oMe)==TRUE) bListenOkay=FALSE;
     if (bListenOkay)
     { // passed filters
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
    } // passed filters
}
