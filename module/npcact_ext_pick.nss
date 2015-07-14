////////////////////////////////////////////////////////////////////////////////
// npcact_ext_pick - NPC ACTIVITIES 6.0  Pick Pockets external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////

void NPCACTPP(object oTarget)
{
  float fDist=GetDistanceBetween(oTarget,OBJECT_SELF);
  if (fDist<3.0&&fDist!=0.0)
  {
    int nCheck= (d20()+(GetSkillRank(SKILL_PICK_POCKET, OBJECT_SELF))) - (d20()+(GetSkillRank(SKILL_SPOT,oTarget)));
    if (nCheck>0)
    { // success
       TakeGoldFromCreature(Random(20)+1,oTarget,FALSE);
       if(GetIsPC(oTarget))
        DelayCommand(60.0,SendMessageToPC(oTarget,"You have been robbed."));
       ActionMoveAwayFromObject(oTarget,FALSE,20.0);
    } // success
    else if (nCheck<-2)
    { // failed and noticed
     if (GetIsPC(oTarget))
      SendMessageToPC(oTarget,GetName(OBJECT_SELF)+" attempted to pick your pocket.");
     else
      { // NPC noticed
        ActionMoveAwayFromObject(oTarget,TRUE,20.0);
        string sRandStatement="That's right run away you scoundrel!";
        switch(Random(4))
          { // switch
          case 0: sRandStatement="You thief!! Next time I see you I'll...";
           break;
          case 1: sRandStatement="Stop! That thief just tried to rob me.";
           break;
          case 2: sRandStatement="You highway robber! I'm warning the authorities about you.";
           default: break;
          }// switch
         AssignCommand(oTarget,ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,2.0));
         AssignCommand(oTarget,ActionSpeakString(sRandStatement));
      } // NPC Noticed
    } // failed and noticed
   }
} // NPCACTPP - PickPockets Support

void main()
{ // takes random 1-20 gold pieces
  object oTarget;
  int nLoop=1;
  float fDelay=0.2;
  //SendMessageToPC(GetFirstPC(),"PickPockets was called");
  if (GetHasSkill(SKILL_PICK_POCKET,OBJECT_SELF)!=0)
  { // has skill
  //SendMessageToPC(GetFirstPC(),"[====PICK POCKETS====]");
  while(nLoop<10)
  { // while
   oTarget=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
   if (oTarget!=OBJECT_INVALID&&GetDistanceBetween(oTarget,OBJECT_SELF)<=12.0)
   { // !OI
    //SendMessageToPC(GetFirstPC(),"[==TEST:"+GetName(oTarget)+"==]");
    if ((GetIsPC(oTarget))||(!GetFactionEqual(oTarget)))
      nLoop=12;
   } // !OI
   if (nLoop!=12) nLoop++;
  } // while
  if (nLoop==12)
  { // Found a victim
    //SendMessageToPC(GetFirstPC(),"Victim found");
    //ActionSpeakString("My victim is "+GetName(oTarget));
    fDelay=18.0;
    if(GetHasSkill(SKILL_HIDE,OBJECT_SELF))
     ActionUseSkill(SKILL_HIDE,OBJECT_SELF);
    ActionForceMoveToObject(oTarget,FALSE,0.5);
    ActionDoCommand(NPCACTPP(oTarget));
  } // Found a victim
 } // has skill
 SetLocalFloat(OBJECT_SELF,"fDelay",fDelay);
} // NPCActionPickPockets()
