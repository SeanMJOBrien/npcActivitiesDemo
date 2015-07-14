// NPC ACTIVITIES 6.0 - DM Wand Conversation File
// By Deva Bryson Winblood    07/31/2004
// RESET NPC
void main()
{
   object oTarget=GetLocalObject(GetPCSpeaker(),"oDMTarget");
   DeleteLocalObject(oTarget,"nGNBState");
   DeleteLocalInt(oTarget,"nGNBASR");
   DeleteLocalInt(oTarget,"nGNBASC");
   AssignCommand(oTarget,ClearAllActions(TRUE));
}
