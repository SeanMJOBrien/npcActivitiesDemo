///////////////////////////////////////////////////////////////////////
// npcact_cp_m_byb - NPC ACTIVITIES 6.0 Profession Merchant
// Purchase the item
// By Deva Bryson Winblood. 07/11/2005
///////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"

void main()
{
   object oPC=GetPCSpeaker();
   object oMerchant=OBJECT_SELF;
   object oItem=GetLocalObject(oPC,"oMerchItem");
   int nPrice=GetLocalInt(oPC,"nProfMerchPrice");
   object oStorage=GetLocalObject(oPC,"oMerchStorage");
   int nItemNum=GetLocalInt(oItem,"nItemNum");
   object oStore;
   object oMaster=GetLocalObject(oItem,"oMaster");
   int nCurrency=GetLocalInt(oMerchant,"nProfMerchCurrency");
   int nN;
   int nM;
   DeleteLocalInt(oItem,"bInvalid");
   DeleteLocalInt(oItem,"nItemNum");
   DeleteLocalObject(oItem,"oMaster");
   DelayCommand(1.0,AssignCommand(oMerchant,TakeCoins(oPC,nPrice,"ANY",nCurrency,TRUE)));
   if (nItemNum==0)
   { // not a variable based
     nM=GetItemStackSize(oMaster);
     nN=GetItemStackSize(oItem);
     if (nM>nN)
     { // decrement master stack
       nN=nM-nN;
       SetItemStackSize(oMaster,nN);
     } // dectement master stack
     else
     { // destroy master
       DestroyObject(oMaster);
     } // destroy master
   } // not a variable based
   else
   { // variable based
     if (GetLocalInt(oMerchant,"bProfMerchInfinite"+IntToString(nItemNum))!=TRUE)
     { // decrement quantity
       nN=GetLocalInt(oMerchant,"nProfMerchInvQty"+IntToString(nItemNum));
       nN=nN-GetItemStackSize(oItem);
       if (nN<1) nN=0;
       SetLocalInt(oMerchant,"nProfMerchInvQty"+IntToString(nItemNum),nN);
     } // decrement quantity
   } // variable based
  DeleteLocalInt(oMerchant,"nProfMerchConvMode");
  DeleteLocalObject(oPC,"oMerchItem");
  oStore=MerchantCreateStore(oMerchant,oPC,0);
}
