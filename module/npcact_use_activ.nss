/////////////////////////////////////////////////////
// NPC ACTIVITIES 5.0 - OnUse Activate the item
//--------------------------------------------------
// By Deva Bryson Winblood.
// Also used with NPC ACTIVITIES 6.0 but, did not require modification
/////////////////////////////////////////////////////
// SCRIPT: npcact_use_activ
/////////////////////////////////////////////////////

void main()
{
  object oUser=GetLastUsedBy();
  if (oUser!=OBJECT_INVALID)
  { //!OI
    ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE,1.0,10.0);
    DelayCommand(10.0,ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE,1.0,1.0));
  } //!OI
}
