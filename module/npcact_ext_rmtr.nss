////////////////////////////////////////////////////////////////////////////////
// npcact_ext_RMTR - NPC ACTIVITIES 6.0  Remove Trap external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////

void main()
{
  float fDelay=0.2;
  int nDisarm;
  int nRadius;
  float fDist;
  int nDist;
  object oTrap;
  int nWork;
  if (GetHasSkill(SKILL_DISABLE_TRAP,OBJECT_SELF)==TRUE)
  { // has the skill
    oTrap =GetNearestObjectByTag("npcact_trap_invis",OBJECT_SELF,1);
    if (oTrap!=OBJECT_INVALID)
    { // !OI
      fDelay=8.0;
      nDisarm=GetLocalInt(oTrap,"nDisarm");
      nRadius=GetLocalInt(oTrap,"nRadius");
      fDist=GetDistanceBetween(OBJECT_SELF,oTrap);
      nDist=FloatToInt(fDist);
      if (nDist<nRadius*2&&nDist>nRadius)
      { // try to disarm it
        fDist=IntToFloat(nDist-nRadius);
        fDist=fDist+1.0;
        ActionMoveToObject(oTrap,FALSE,fDist);
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,5.0);
        nWork=d20()+GetSkillRank(SKILL_DISABLE_TRAP,OBJECT_SELF);
        if (nWork>=nDisarm)
        { // disarmed
         nWork=GetLocalInt(GetArea(oTrap),"nNPCACTTraps");
         nWork--;
         SetLocalInt(GetArea(oTrap),"nNPCACTTraps",nWork);
         DestroyObject(oTrap);
         ActionSpeakString("That trap is disabled.");
        } // disarmed
        else if (nWork<nDisarm-10)
        { // failed set it off
          ActionSpeakString("That wasn't right.");
          ExecuteScript(GetLocalString(oTrap,"sScript"),oTrap);
        } // failed set it off
        else
        { // didn't disarm
          ActionSpeakString("This trap is tough.  I haven't gotten rid of it.");
        } // didn't disarm
      } // try to disarm it
    } // !OI
  } // has the skill
  SetLocalFloat(OBJECT_SELF,"fDelay",fDelay);
}// NPCActionRemoveTrap()
