/////////////////npcact_spawn/////////////////
// Purpose: to allow one-time setup conditions to be set
// Called by npcact_wrap9, the on-spawn wrapper
// Created 6/08/10 - Peak
#include "x0_i0_anims"
void main()
{
  object oMe=OBJECT_SELF;
  CheckIsCivilized();
  if(GetRacialType(oMe)==IP_CONST_RACIALTYPE_DWARF)
    SetAnimationCondition(NW_ANIM_FLAG_IS_CIVILIZED);
  if(GetAnimationCondition(NW_ANIM_FLAG_IS_CIVILIZED))
    if(GetLocalInt(oMe,"nGNBStateSpeed")>0)
      SetLocalInt(oMe,"nPKInherentStateSpeed",GetLocalInt(oMe,"nGNBStateSpeed"));
}
