////////////////////////////////////////////////////////////////////////////////
// NPCACT_AREA_ENT - This function should be called from an areas OnEnter event
// if there are going to be LAG4 NPCs in the area that need to be respawned when
// PCs enter the area.  NOTE: A waypoint tagged LAG4_RESPAWN_TEMP must be placed
// in the module somewhere for the creature to be initially spawned for TAG to
// be discovered.
//------------------------------------------------------------------------------
// By Deva Bryson Winblood.  06/22/2004
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
#include "npcactstackh"
/////////////////////
// PROTOTYPES
/////////////////////

////////////////////////////////////////////////////////////////////////// MAIN
void main()
{
  object oPC=GetEnteringObject();
  struct StackHeader stH=fnGetLocalStack("stLAG4");
  object oNPC;
  object oTemp=GetWaypointByTag("LAG4_RESPAWN_TEMP");
  string sStore;
  string sRes;
  int nCHP;
  int nHP;
  int nDmg;
  effect eEff;
  object oPost;
  if (GetIsPC(oPC)&&GetIsObjectValid(oTemp))
  { // PC and TEMP ok
    if (DEBUG_NPCACT_ON) SendMessageToPC(oPC,"LAG4 Area entered... respawning NPCs #:"+IntToString(stH.nNum));
    while(stH.nNum>0)
    { // items on the stack
      stH=fnPopStack(stH);
      sStore=stH.sRet;
      if (DEBUG_NPCACT_ON) SendMessageToPC(oPC,"    "+sStore);
      if (GetStringLength(sStore)>2)
      { // valid string returned
        sRes=fnParse(sStore,"/");
        sStore=fnRemoveParsed(sStore,sRes,"/");
        nCHP=StringToInt(sStore);
        oNPC=CreateObject(OBJECT_TYPE_CREATURE,sRes,GetLocation(oTemp));
        if (DEBUG_NPCACT_ON) SendMessageToPC(oPC,"    Created:"+sRes);
        if (GetIsObjectValid(oNPC))
        { // creature created
          oPost=GetNearestObjectByTag("POST_"+GetTag(oNPC),oPC,1);
          if (!GetIsObjectValid(oPost))
          { // try night
            oPost=GetNearestObjectByTag("NIGHT_"+GetTag(oNPC),oPC,1);
          } // try night
          if (!GetIsObjectValid(oPost))
          { // try day module wide
            oPost=GetWaypointByTag("POST_"+GetTag(oNPC));
          } // try day module wide
          if (!GetIsObjectValid(oPost))
          { // try night module wide
            oPost=GetWaypointByTag("NIGHT_"+GetTag(oNPC));
          } // try night module wide
          if (GetIsObjectValid(oPost))
          { // valid post
            nHP=GetCurrentHitPoints(oNPC);
            if (nHP>nCHP)
            { // need to adjust hit points
              nDmg=nHP-nCHP;
              eEff=EffectDamage(nDmg);
              ApplyEffectToObject(DURATION_TYPE_INSTANT,eEff,oNPC,1.0);
            } // need to adjust hit points
            if (DEBUG_NPCACT_ON) SendMessageToPC(oPC,"    Moved:"+GetTag(oNPC));
            AssignCommand(oNPC,JumpToObject(oPost));
          } // valid post
          else
          { // could not find post
            SendMessageToPC(oPC,"NPC ACTIVITIES 6.0 ERROR: Could not find a POST_"+GetTag(oNPC)+" to respawn a LAG4 NPC at.");
            DestroyObject(oNPC);
          } // could not find post
        } // creature created
      } // valid string returned
    } // items on the stack
  } // PC and TEMP ok
  else if (GetIsObjectValid(oTemp)==FALSE)
  {
    SendMessageToPC(oPC,"NPC ACTIVITIES 6.0 ERROR: Cannot find waypoint with tag 'LAG4_RESPAWN_TEMP'");
  }
}
////////////////////////////////////////////////////////////////////////// MAIN
