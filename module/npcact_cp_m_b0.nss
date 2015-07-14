///////////////////////////////////////////////////////////////////////
// npcact_cp_m_b0 - NPC ACTIVITIES 6.0 Profession Merchant
// Do not want to purchase or cannot purchase the item
// By Deva Bryson Winblood. 07/11/2005
///////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"


void main()
{
  object oMe=OBJECT_SELF;
  object oPC=GetPCSpeaker();
  object oStore=GetLocalObject(oPC,"oProfMerchStore");
  object oItem=GetLocalObject(oPC,"oMerchItem");
  string sRes=GetResRef(oItem);
  int nStack=GetItemStackSize(oItem);
  int nCharges=GetItemCharges(oItem);
  int nItemNum=GetLocalInt(oItem,"nItemNum");
  DelayCommand(0.2,DestroyObject(oItem));
  DeleteLocalInt(oMe,"nProfMerchConvMode");
  DeleteLocalObject(oPC,"oMerchItem");
  oStore=MerchantCreateStore(oMe,oPC,0);
}
