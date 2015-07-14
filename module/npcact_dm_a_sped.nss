// NPC ACTIVITIES 6.0 - DM Wand Conversation File
// By Deva Bryson Winblood    07/31/2004
// set speed
void main()
{
   object oTarget=GetLocalObject(GetPCSpeaker(),"oDMTarget");
   int nParm=GetLocalInt(GetPCSpeaker(),"nDMParm");
   int nSpeed=6;
   if (nParm<7) nSpeed=nParm;
   else if (nParm==7) nSpeed=8;
   else if (nParm==8) nSpeed=12;
   else if (nParm==9) nSpeed=18;
   SetLocalInt(oTarget,"nGNBStateSpeed",nSpeed);
   DeleteLocalInt(GetPCSpeaker(),"nDMParm");
}
