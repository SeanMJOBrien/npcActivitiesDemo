////////////////////////////////////////////////////////////////////
// npcact_cp_m_pno - NPC ACTIVITIES 6.0 Professions Merchant
// Do not wish to sell the goods
// By Deva Bryson Winblood. 07/24/2005
////////////////////////////////////////////////////////////////////

void main()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    object oStore=GetLocalObject(oPC,"oMerchSellGoods");
    object oItem;
    object oNew;
    oItem=GetFirstItemInInventory(oStore);
    while(oItem!=OBJECT_INVALID)
    { // give stuff back
      oNew=CopyObject(oItem,GetLocation(oPC),oPC);
      DelayCommand(0.5,DestroyObject(oItem));
      oItem=GetNextItemInInventory(oStore);
    } // give stuff back
    DelayCommand(0.6,DestroyObject(oStore));
    AssignCommand(oPC,ClearAllActions(TRUE));
    DeleteLocalInt(oMe,"nProfMerchConvMode");
    AssignCommand(oPC,ActionStartConversation(oMe,"npcact_merchant",TRUE,FALSE));
}
