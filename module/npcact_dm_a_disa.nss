// NPC ACTIVITIES 6.0 - DM Wand Conversation File
// By Deva Bryson Winblood    07/31/2004
// Disable NPC ACTIVITIES
void fnVerifyStopped(object oTarget)
{ // PURPOSE: Make sure this NPC is NOT going anywhere
  if (GetLocalInt(oTarget,"nGNBDisabled")!=TRUE||GetCurrentAction(oTarget)==ACTION_MOVETOPOINT)
  { // still moving
    AssignCommand(oTarget,ClearAllActions(TRUE));
    SetLocalInt(oTarget,"nGNBDisabled",TRUE);
    DelayCommand(2.0,fnVerifyStopped(oTarget));
  } // still moving
} // fnVerifyStopped()

void main()
{
   object oTarget=GetLocalObject(GetPCSpeaker(),"oDMTarget");
   if (GetIsObjectValid(oTarget))
   {
     SetLocalInt(oTarget,"nGNBDisabled",TRUE);
     AssignCommand(oTarget,ClearAllActions(TRUE));
     DelayCommand(4.0,fnVerifyStopped(oTarget));
   }
}
