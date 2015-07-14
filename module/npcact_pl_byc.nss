///////////////////////////////////////////////////////////////////
// npcact_pl_byc - NPC ACTIVITIES 6.0 Professions Merchant
// On Close Merchant Store
// By Deva Bryson Winblood. 07/09/2005
///////////////////////////////////////////////////////////////////
#include "npcact_h_merch"

void main()
{
     object oMe=OBJECT_SELF;
     object oPC=GetLastClosedBy();
     object oMerchant=GetLocalObject(oMe,"oMerchant");
     object oPlayer=GetLocalObject(oMe,"oPlayer");
     object oItem=GetLocalObject(oPC,"oMerchItem");
     //SendMessageToPC(oPlayer," CLOSED by "+GetName(oPC));
     if (oItem==OBJECT_INVALID) AssignCommand(oPC,fnPurgeInvalids());
     DelayCommand(0.3,DestroyStore(oMe));
     if (oItem==OBJECT_INVALID) DeleteLocalInt(oMe,"nProfMerchConvMode");
     if (oPC==oPlayer)
     { // continue conversation
       AssignCommand(oPC,ClearAllActions(TRUE));
       AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",FALSE,FALSE));
     } // continue conversation

}
