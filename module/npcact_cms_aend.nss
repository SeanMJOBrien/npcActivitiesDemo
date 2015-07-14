// npcact_cms_aend - end of selection process
#include "npcact_h_money"
void main()
{
   object oPC=GetPCSpeaker();
   int nMode=GetLocalInt(oPC,"nCMSMode");
   int nSelection=GetLocalInt(oPC,"nCMSSelection");
   object oTarget=GetLocalObject(oPC,"oCMSTarget");
   float fX=GetLocalFloat(oPC,"fCMSX");
   float fZ=GetLocalFloat(oPC,"fCMSZ");
   float fY=GetLocalFloat(oPC,"fCMSY");
   object oArea=GetLocalObject(oPC,"oCMSTargetArea");
   vector vVec;
   location lLoc;
   object oItem=GetLocalObject(oPC,"oCMSItem");
   object oItem2;
   int nN;
   int nCurrency=GetLocalInt(oItem,"nCurrency");
   object oMod=GetModule();
   string sS;
   vVec.x = fX;
   vVec.y = fY;
   vVec.z = fZ;
   lLoc=Location(oArea,vVec,0.0);
   DeleteLocalInt(oPC,"nCMSMode");
   DeleteLocalInt(oPC,"nCMSSelection");
   DeleteLocalObject(oPC,"oCMSTarget");
   DeleteLocalObject(oPC,"oCMSTargetArea");
   DeleteLocalFloat(oPC,"fCMSX");
   DeleteLocalFloat(oPC,"fCMSY");
   DeleteLocalFloat(oPC,"fCMSZ");
   switch(nMode)
   { // MODE SWITCH -----------------------------------
     case 1: { // split pile mode
       SplitCoins(oPC,oItem,nSelection);
       break;
     } // split pile mode
     case 2: { // give coins
       if (GetIsPC(oTarget))
       { // giving to another PC
         nN=GetLocalInt(oMod,"nMSCoin_R_"+GetResRef(oItem)+"_"+IntToString(nCurrency));
         sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
         AssignCommand(oTarget,TakeCoins(oPC,nSelection,sS,nCurrency));
         sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
         SendMessageToPC(oTarget,GetName(oPC)+" has given you "+IntToString(nSelection)+" "+sS+".");
       } // giving to another PC
       else
       { // giving to an NPC
         nN=GetLocalInt(oMod,"nMSCoin_R_"+GetResRef(oItem)+"_"+IntToString(nCurrency));
         sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
         TakeCoins(oPC,nSelection,sS,nCurrency,TRUE);
         CreateCoins(oTarget,lLoc,nSelection,sS,nCurrency);
       } // giving to an NPC
       break;
     } // give coins
     default: break;
   } // MODE SWITCH -----------------------------------
}
