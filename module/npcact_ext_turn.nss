////////////////////////////////////////////////////////////////////////////////
// npcact_ext_turn - NPC ACTIVITIES 6.0  Turn Undead external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////

int fnCheckIsUndead(object oTarget)
{ // Test to see if undead
  int nRet=FALSE;
  if (GetClassByPosition(1,oTarget)==CLASS_TYPE_UNDEAD) nRet=TRUE;
  else if (GetClassByPosition(2,oTarget)==CLASS_TYPE_UNDEAD) nRet=TRUE;
  else if (GetClassByPosition(3,oTarget)==CLASS_TYPE_UNDEAD) nRet=TRUE;
  return nRet;
} //fnCheckIsUndead()

//-------------------------------------------------[ TURN ]------------------
void NPCActionTurnUndead()
{
  int nLoop=1;
  object oTarget=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  float fDelay=0.2;
  if (GetHasFeat(FEAT_TURN_UNDEAD,OBJECT_SELF))
  {// has turn undead
  while(oTarget!=OBJECT_INVALID&&GetDistanceBetween(oTarget,OBJECT_SELF)<=10.0)
  { //!OI
    if(fnCheckIsUndead(oTarget))
    { // It is an undead
      ActionMoveToObject(oTarget,TRUE,2.0);
      ActionUseFeat(FEAT_TURN_UNDEAD,oTarget);
      SetIsTemporaryEnemy(oTarget,OBJECT_SELF);
      SetIsTemporaryEnemy(OBJECT_SELF,oTarget);
      fDelay=fDelay+7.8;
    } // It is an undead
    nLoop++;
    oTarget=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } //!OI
  }// has turn undead
  SetLocalFloat(OBJECT_SELF,"fDelay",fDelay);
} // NPCActionTurnUndead()
