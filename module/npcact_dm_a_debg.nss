// NPC ACTIVITIES 6.0 - DM Wand Conversation File
// By Deva Bryson Winblood    07/31/2004
// DEBUG

void fnDebugMessage(object oPC,object oT,int nCountDown)
{ // PURPOSE: To send debug messages on this NPC every second
  // until nCountDown = 0
  string sMsg;
  int nN;
  object oO;
  if (nCountDown>0)
  {
    sMsg="["+IntToString(nCountDown)+"] NPC:'"+GetName(oT)+"["+GetTag(oT)+"]' DEBUG";
    SendMessageToPC(oPC,sMsg);
    nN=GetLocalInt(oT,"nGNBState");
    sMsg="  nGNBState="+IntToString(nN)+"  sGNBDTag='"+GetLocalString(oT,"sGNBDTag")+"'";
    SendMessageToPC(oPC,sMsg);
    oO=GetLocalObject(oT,"oDest");
    if (GetIsObjectValid(oO))
    { // valid destination
      sMsg="  oDest='["+GetTag(oO)+"]' in area '"+GetName(GetArea(oO))+"["+GetTag(GetArea(oO))+"]'";
    } // valid destination
    else { sMsg="  oDest='UNKNOWN DESTINATION'"; }
    SendMessageToPC(oPC,sMsg);
    sMsg="  sAct='"+GetLocalString(oT,"sAct")+"'";
    SendMessageToPC(oPC,sMsg);
    DelayCommand(1.0,fnDebugMessage(oPC,oT,nCountDown-1));
  }
} // fnDebugMessage()


void main()
{
   object oPC=GetPCSpeaker();
   object oTarget=GetLocalObject(oPC,"oDMTarget");
   int nParm=GetLocalInt(oPC,"nDMParm");
   int nTime=20;
   if (nParm==2) nTime=40;
   else if (nParm==3) nTime=60;
   else if (nParm==4) nTime=120;
   else if (nParm==5) nTime=240;
   else if (nParm==6) nTime=360;
   fnDebugMessage(oPC,oTarget,nTime);
}
