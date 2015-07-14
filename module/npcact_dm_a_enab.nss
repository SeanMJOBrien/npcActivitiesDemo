// NPC ACTIVITIES 6.0 - DM Wand Conversation File
// By Deva Bryson Winblood    07/31/2004
// Enable NPC ACTIVITIES
void main()
{
   object oTarget=GetLocalObject(GetPCSpeaker(),"oDMTarget");
   DeleteLocalInt(oTarget,"nGNBDisabled");
}
