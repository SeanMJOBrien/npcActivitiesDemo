///////////////////////////////////////////////////////////////////////
// npcact_cp_m_pcr - NPC ACTIVITIES 6.0 Professions Merchant
// Create selling chest.
// By Deva Bryson Winblood. 07/24/2005
///////////////////////////////////////////////////////////////////////

void main()
{
   object oMerchant=OBJECT_SELF;
   object oPC=GetPCSpeaker();
   object oChest=CreateObject(OBJECT_TYPE_PLACEABLE,"npcact_pl_m_pu",GetLocation(oPC));
   if (oChest!=OBJECT_INVALID)
   { // chest created
     SetLocalObject(oChest,"oMerchant",oMerchant);
     SetLocalObject(oChest,"oPlayer",oPC);
     DelayCommand(0.5,AssignCommand(oPC,ClearAllActions(TRUE)));
     DelayCommand(0.6,AssignCommand(oPC,ActionInteractObject(oChest)));
   } // chest created
   else
   { // error
     AssignCommand(oMerchant,SpeakString("ERROR: npcact_cp_m_pcr : Could not create merchant selling chest!"));
   } // error
}
