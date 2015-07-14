////////////////////////////////////////////////////////////////////////////////
// npcact_ext_heal - NPC ACTIVITIES 6.0  Heal external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////


void main()
{ // Heal other people
  int nLoop=1;
  object oHealee=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,1,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  effect eHeal;
  float fDelay=0.1;
  while(oHealee!=OBJECT_INVALID&&GetDistanceBetween(OBJECT_SELF,oHealee)<=5.0)
  { // test others for need of healing
   if (GetMaxHitPoints(oHealee)>GetCurrentHitPoints(oHealee))
   { // healing needed
     ActionMoveToObject(oHealee,FALSE,0.5);
     eHeal=EffectHeal(GetMaxHitPoints(oHealee)-GetCurrentHitPoints(oHealee));
     ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP,1.0,2.0);
     ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oHealee,1.5));
     fDelay=fDelay+10.0;
   } // healing needed
   nLoop++;
   oHealee=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,1,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // while
  SetLocalFloat(OBJECT_SELF,"fDelay",fDelay);
} // NPCActionHealOthers()

