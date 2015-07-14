///////////////////////////////////////////////////////////////
// npcact_pl_byo - NPC ACTIVITIES 6.0 Profession Merchant
// Merchant Store OnOpen script
// By Deva Bryson Winblood. 7/09/2005
///////////////////////////////////////////////////////////////
#include "npcact_h_merch"



void main()
{
     object oMe=OBJECT_SELF;
     object oPC=GetLastOpenedBy();
     object oPlayer=GetLocalObject(oMe,"oPlayer");
     AssignCommand(oPC,fnPurgeInvalids());
     //SendMessageToPC(oPlayer,"OPENED by "+GetName(oPC));
     if (oPC!=oPlayer)
     { // not a valid opener
       AssignCommand(oPC,ClearAllActions(TRUE));
       DelayCommand(0.3,DestroyStore(oMe));
       SendMessageToPC(oPC,"You were not the one that object was intended for!");
     } // not a valid opener
}
