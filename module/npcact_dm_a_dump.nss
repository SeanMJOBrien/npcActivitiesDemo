// NPC ACTIVITIES 6.0 - DM Wand Conversation File
// By Deva Bryson Winblood    07/31/2004
// DUMP
void fnMessage(object oPC,string sMsg)
{
  SendMessageToPC(oPC,sMsg);
  PrintString(sMsg);
} // fnMessage()

void main()
{
   object oTarget=GetLocalObject(GetPCSpeaker(),"oDMTarget");
   object oPC=GetPCSpeaker();
   string sS;
   int nN;
   float fF;
   object oO;
   string sMsg;
   sMsg="[NPC ACTIVITIES DM WAND - DUMP DATA Initiated by '"+GetName(oPC)+"']";
   fnMessage(oPC,sMsg);
   sMsg="===  NPC '"+GetName(oTarget)+"["+GetTag(oTarget)+"]' ===";
   fnMessage(oPC,sMsg);
   sMsg="=== in area '"+GetName(GetArea(oTarget))+"["+GetTag(GetArea(oTarget))+"]' ===";
   fnMessage(oPC,sMsg);
   nN=GetLocalInt(oTarget,"nGNBStateSpeed");
   sMsg="nGNBStateSpeed="+IntToString(nN)+"  nGNBDisabled=";
   nN=GetLocalInt(oTarget,"nGNBDisabled");
   if (nN==TRUE) sMsg=sMsg+"TRUE";
   else { sMsg=sMsg+"FALSE"; }
   fnMessage(oPC,sMsg);
   nN=GetLocalInt(oTarget,"nGNBState");
   sMsg="nGNBState="+IntToString(nN)+" '";
   if (nN==0) sMsg=sMsg+"Inititializtion'";
   else if (nN==1) sMsg=sMsg+"Choose Destination'";
   else if (nN==2) sMsg=sMsg+"Move to Destination'";
   else if (nN==3) sMsg=sMsg+"Wait for arrival at Destination'";
   else if (nN==4) sMsg=sMsg+"Process Waypoint'";
   else if (nN==5) sMsg=sMsg+"Interpret Command'";
   else if (nN==6) sMsg=sMsg+"Wait for Command To Complete'";
   else if (nN==7) sMsg=sMsg+"Pause Interval'";
   else { sMsg=sMsg+"UNKNOWN'"; }
   fnMessage(oPC,sMsg);
   fF=GetLocalFloat(oTarget,"fGNBPause");
   sMsg="fGNBPause="+FloatToString(fF)+" sGNBDTag='"+GetLocalString(oTarget,"sGNBDTag")+"'";
   fnMessage(oPC,sMsg);
   nN=GetLocalInt(oTarget,"nGNBRun");
   sMsg="nGNBRun="+IntToString(nN)+"  sGNBHours='"+GetLocalString(oTarget,"sGNBHours")+"'";
   fnMessage(oPC,sMsg);
   oO=GetLocalObject(oTarget,"oDest");
   if (GetIsObjectValid(oO))
   { // valid destination
     sMsg="oDest='["+GetTag(oO)+"]' in area '"+GetName(GetArea(oO))+"["+GetTag(GetArea(oO))+"]";
   } // valid destination
   else { sMsg="oDest='Not a valid destination'"; }
   fnMessage(oPC,sMsg);
   nN=GetLocalInt(oTarget,"nGNBProfessions");
   sMsg="nGNBProfessions="+IntToString(nN);
   nN=GetLocalInt(oTarget,"nGNBProcessing");
   sMsg=sMsg+"  nGNBProcessing="+IntToString(nN);
   nN=GetLocalInt(oTarget,"nGNBProfProc");
   sMsg=sMsg+"  nGNBProfProc="+IntToString(nN);
   fnMessage(oPC,sMsg);
   sMsg="sAct='"+GetLocalString(oTarget,"sAct")+"'";
   fnMessage(oPC,sMsg);
   sMsg="[===== END OF DUMP =====]";
   fnMessage(oPC,sMsg);
}
