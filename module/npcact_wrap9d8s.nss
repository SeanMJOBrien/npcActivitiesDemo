////////////////////////////////////////////////////////////////////////////////
// npcact_wrap9 - OnSpawn Wrapper (works for NPC ACTIVITIES and RTSA
//==============================================================================
// By Deva Bryson Winblood.   NPC ACTIVITIES 6.0 & RTSA 2.0
// modified to call npcactivitiesspawn 6/08/10 - Peak
////////////////////////////////////////////////////////////////////////////////
// sCRSPSpawn - NPC ACTIVITIES Custom Script
// sRTSA_wrap9  - RTSA Custom Script
// nWrap_Mode   - 0 = NPC ACT then RTSA (both), 1= NPC ACT, 2 = RTSA, 3 = Bioware
//                4 = Henchmen Earlier, 5 = NPC ACTIVITIES Henchmen, 6 = both + Bioware,
//                7 = Jasperre's AI, 8 = CODI AI, 9 = Custom only or NULL
// nGNBCloseMode - 0 = Waypoints anywhere in the module, 1 = near waypoints only
//==============================================================================
// Special circumstance for this one.
// sCRSPDoes not function for Spawn scripts since they fire when first spawned
// Thus, custom script is defined on a waypoint.
// waypoint can have the tag <NPC tag>_SPAWNC or <npc resref>_SPAWNR
// If the name of the waypoint is NOT Waypoint then it will use the name as the
// script to run.  If the name is Waypoint then it will check the waypoint for
// a string variable named sSpawnScript.  That will be the script to run.
void main()
{
     object oMe=OBJECT_SELF;
     int iRace =  GetRacialType(OBJECT_SELF);
     int iGender = GetGender(OBJECT_SELF);

// ***** Give Random Weapon on Spawn In ***** //kalbaern 10/01/08
    object oItem;
    int nIntW;
    nIntW = d6();
    if (nIntW<=1)
    {CreateItemOnObject("nw_waxbt001", OBJECT_SELF); // Battleaxe //resref of weapon to give
    oItem = GetItemPossessedBy(OBJECT_SELF, "NW_WAXBT001"); //tag of same to make undroppable
    SetDroppableFlag(oItem, FALSE);}
    else if (nIntW<=2)
    {CreateItemOnObject("nw_wswls001", OBJECT_SELF); // Longsword
    oItem = GetItemPossessedBy(OBJECT_SELF, "NW_WSWLS001");
    SetDroppableFlag(oItem, FALSE);}
    else if (nIntW<=3)
    {CreateItemOnObject("nw_wblhw001", OBJECT_SELF); // Warhammer
    oItem = GetItemPossessedBy(OBJECT_SELF, "NW_WBLHW001");
    SetDroppableFlag(oItem, FALSE);}
    else if (nIntW<=4)
    {CreateItemOnObject("nw_wblms001", OBJECT_SELF); // Morningstar
    oItem = GetItemPossessedBy(OBJECT_SELF, "NW_WBLMS001");
    SetDroppableFlag(oItem, FALSE);}
    else if (nIntW<=5)
    {CreateItemOnObject("nw_wblfl001", OBJECT_SELF); // Light Flail
    oItem = GetItemPossessedBy(OBJECT_SELF, "NW_WBLF001");
    SetDroppableFlag(oItem, FALSE);}
    else if (nIntW<=6)
    {CreateItemOnObject("nw_wplhb001", OBJECT_SELF); // Halberd
    oItem = GetItemPossessedBy(OBJECT_SELF, "nw_WPLHB001");
    SetDroppableFlag(oItem, FALSE);}
// End random weapon

    ActionEquipMostDamagingMelee(); // Qlippoth equip most damaging

    SetCreatureBodyPart(CREATURE_PART_HEAD,Random(13)+1,OBJECT_SELF); // Qlippoth
    SetColor(OBJECT_SELF,COLOR_CHANNEL_SKIN,Random(6)+1); // Qlippoth
    SetColor(OBJECT_SELF,COLOR_CHANNEL_HAIR,Random(23)+1); // Qlippoth
    // Qlippoth - check for fatness, except if Elf or Dwarf female, appearance manual since I'm probably being specific about those.
         if (iRace!=RACIAL_TYPE_ELF || iRace!=RACIAL_TYPE_DWARF&&iGender==GENDER_FEMALE)
             {
             int iFatroll = d6();
             if (iFatroll==6)
                 {
                 if (GetLocalInt(OBJECT_SELF,"mounted")!=1) SetPhenoType(PHENOTYPE_BIG,OBJECT_SELF);
                 }
             }
     SetAILevel(oMe,AI_LEVEL_NORMAL); //Qlippoth, adding to keep NPC running at normal level even if no PCs in game.

     string sCRSP=GetLocalString(oMe,"sCRSPSpawn");
     string sRTSA=GetLocalString(oMe,"sRTSA_wrap9");
     int nMode=GetLocalInt(oMe,"nWrap_Mode");
     int nGNB=GetLocalInt(oMe,"nGNBCloseMode");
     string sWPName="POST_"+GetTag(oMe);
     string sDefault="nw_c2_default9";
     string sNPC_SCRIPT="npcact_spawn"; // npc activities
     string sRTSA_SCRIPT="x2_def_spawn"; // RTSA script
     string sX2Default="x2_def_spawn";
     string sEarlyHench="nw_ch_ac9";
     string sNewHench="npcact_hench9";
     string sJASP="j_ai_onspawn";
     string sCODI="x2_def_spawn";
     int nGNBDisabled=GetLocalInt(oMe,"nGNBDisabled");
     object oWP;
     if (nGNB==0)
     { // waypoints anywhere in module
       oWP=GetWaypointByTag(GetTag(oMe)+"_SPAWNC");
       if (oWP==OBJECT_INVALID) oWP=GetWaypointByTag(GetResRef(oMe)+"_SPAWNR");
       if (oWP!=OBJECT_INVALID)
       {
         if (GetName(oWP)=="Waypoint")
         { // get from variable on waypoint
           sCRSP=GetLocalString(oWP,"sSpawnScript");
           sRTSA=sCRSP;
         } // get from variable on waypoint
         else
         { // name of waypoint
           sCRSP=GetName(oWP);
           sRTSA=sCRSP;
         } // name of waypoint
       }
     } // waypoints anywhere in module
     else if (nGNB==1)
     { // waypoints near only
       oWP=GetNearestObjectByTag(GetTag(oMe)+"_SPAWNC",oMe,1);
       if (oWP==OBJECT_INVALID) oWP=GetNearestObjectByTag(GetResRef(oMe)+"_SPAWNR",oMe,1);
       if (oWP!=OBJECT_INVALID)
       {
         if (GetName(oWP)=="Waypoint")
         { // get from variable on waypoint
           sCRSP=GetLocalString(oWP,"sSpawnScript");
           sRTSA=sCRSP;
         } // get from variable on waypoint
         else
         { // name of waypoint
           sCRSP=GetName(oWP);
           sRTSA=sCRSP;
         } // name of waypoint
       }
     } // waypoints near only
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
       if (sCRSP!="") ExecuteScript(sCRSP,oMe);
       else { ExecuteScript(sJASP,oMe); }
     } // Jasperre's AI
     else if (nMode==8)
     { // CODI AI
       if (sCRSP!="") ExecuteScript(sCRSP,oMe);
       else { ExecuteScript(sCODI,oMe); }
     } // CODI AI
     else if (nMode==9)
     { // run only custom or NONE at all
       if (sCRSP!="") ExecuteScript(sCRSP,oMe);
       if (sRTSA!="") ExecuteScript(sRTSA,oMe);
     } // run only custom or NONE at all
}
