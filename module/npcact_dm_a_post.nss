// NPC ACTIVITIES 6.0 - DM Wand Conversation File
// By Deva Bryson Winblood    07/31/2004
// Return to POST
void main()
{
   object oTarget=GetLocalObject(GetPCSpeaker(),"oDMTarget");
   DeleteLocalObject(oTarget,"oDest");
   DeleteLocalObject(oTarget,"nGNBState");
   SetLocalString(oTarget,"sGNBDTag","00");
   DeleteLocalInt(oTarget,"nGNBASR");
   DeleteLocalInt(oTarget,"nGNBASC");
   AssignCommand(oTarget,ClearAllActions(TRUE));
}
