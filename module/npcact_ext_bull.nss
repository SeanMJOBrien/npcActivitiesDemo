////////////////////////////////////////////////////////////////////////////////
// npcact_ext_bull - NPC ACTIVITIES 6.0  Bully external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////


void main()
{ // Be a bully
  int nFound=FALSE;
  int nLoop=1;
  object oTarget;
  effect eKnockdown;
  SetLocalFloat(OBJECT_SELF,"fDelay",2.0);
  while(!nFound)
  { // while not found
    oTarget=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
    nLoop++;
    if (oTarget!=OBJECT_INVALID&&GetDistanceBetween(oTarget,OBJECT_SELF)<=8.0)
    { // !OI
     if (GetHitDice(OBJECT_SELF)>=GetHitDice(oTarget))
      nFound=TRUE;
    } // !OI
    else
     nFound=TRUE; // end of objects
  } // while not found
  if (oTarget!=OBJECT_INVALID)
  { // act on target
    SetLocalFloat(OBJECT_SELF,"fDelay",10.0);
    ActionMoveToObject(oTarget,TRUE,0.8);
    ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,3.0);
    eKnockdown=EffectKnockdown();
    AssignCommand(oTarget,ClearAllActions());
    DelayCommand(1.0,ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKnockdown,oTarget,3.0)));
  } // act on target
}// NPCActionBully()

