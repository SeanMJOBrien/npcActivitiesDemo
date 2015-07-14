//////////////////////////////////////////////////////////////////////
// npcact_pl_m_pcl - NPC ACTIVITIES 6.0 Professions Merchant
// OnClose event for Sell to Merchant
// By Deva Bryson Winblood. 07/24/2005
//////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"
#include "npcact_h_colors"

int fnIsRestricted(object oMerchant,object oItem)
{ // PURPOSE: Returns TRUE if the item is restricted
  if (GetLocalInt(oItem,"nCurrency")>0) return TRUE;
  return FALSE;
} // fnIsRestricted()

void fnCheckInventory(object oMe,object oMerchant,object oPC,object oLastItem=OBJECT_INVALID,int nValue=0)
{ // PURPOSE: Recurse through inventory with delay
  object oItem;
  int nV;
  int nB;
  string sS;
  float fPrice;
  float fMarkup;
  if (oLastItem==OBJECT_INVALID) oItem=GetFirstItemInInventory(oMe);
  else { oItem=GetNextItemInInventory(oMe); }
  if (oItem!=OBJECT_INVALID)
  { // item exists
    nB=fnIsRestricted(oMerchant,oItem);
    if (nB==TRUE)
    { // restricted item
      nV=d4();
      if (nV==1) sS="I am not interested in "+GetName(oItem)+".";
      else if (nV==2) sS="I will not purchase "+GetName(oItem)+" please remove it.";
      else if (nV==3) sS="I have no interest in "+GetName(oItem)+".";
      else if (nV==4) sS="Notice, "+GetName(oItem)+" is worthless to me. Please remove it.";
      sS=ColorRGBString(sS,0,6,0);
      AssignCommand(oMerchant,SpeakString(sS));
      AssignCommand(oPC,ClearAllActions(TRUE));
      AssignCommand(oPC,ActionInteractObject(oMe));
    } // restricted item
    else
    { // not restricted
      nV=GetPrice(GetResRef(oItem),oMerchant,100,GetItemStackSize(oItem));
      fPrice=IntToFloat(nV);
      if (GetStolenFlag(oItem)==TRUE)
      { // stolen item
        nB=GetLocalInt(oMerchant,"nProfMerchBarterSBS");
        if (nB<1) nB=33;
        fMarkup=IntToFloat(nB)/100.0;
        fPrice=fPrice*fMarkup;
      } // stolen item
      else
      { // not stolen
        nB=GetLocalInt(oMerchant,"nProfMerchBarterSBN");
        if (nB<1) nB=75;
        fMarkup=IntToFloat(nB)/100.0;
        fPrice=fPrice*fMarkup;
      } // not stolen
      if (GetIdentified(oItem)!=TRUE)
      { // not identified.. -75% value
        fPrice=fPrice*0.25;
      } // not identified.. -75% value
      nV=FloatToInt(fPrice);
      DelayCommand(0.1,fnCheckInventory(oMe,oMerchant,oPC,oItem,nValue+nV));
    } // not restricted
  } // item exists
  else
  { // done - compute value
    SetLocalInt(oPC,"nMerchStartingPrice",nV);
    SetLocalInt(oPC,"nMerchCurrentPrice",nV);
    SetLocalObject(oPC,"oMerchSellGoods",oMe);
    SetLocalInt(oMerchant,"nProfMerchConvMode",3);
    nB=GetLocalInt(oMerchant,"nProfMerchMaxSpend");
    nV=nValue;
    if (nB>0&&nV>nB) nV=nB; // Maximum amount merchant will spend
    nB=GetLocalInt(oMerchant,"nProfMerchCurrency");
    sS=MoneyToString(nV,nB);
    nB=d4();
    if (nB==1) sS="Well, I can give you "+ColorRGBString(sS,0,6,0);
    else if (nB==2) sS="That all is worth "+ColorRGBString(sS,0,6,0);
    else if (nB==3) sS="For that I offer you "+ColorRGBString(sS,0,6,0);
    else if (nB==4) sS="I offer "+ColorRGBString(sS,0,6,0);
    SetLocalString(oPC,"sMerchSay",sS);
    AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",TRUE,FALSE));
  } // done - compute value
} // fnCheckInventory()


void main()
{
    object oMe=OBJECT_SELF;
    object oMerchant=GetLocalObject(oMe,"oMerchant");
    object oPlayer=GetLocalObject(oMe,"oPlayer");
    object oPC=GetLastOpenedBy();
    if (GetFirstItemInInventory(oMe)!=OBJECT_INVALID&&oPC==oPlayer)
    { // items exist
      fnCheckInventory(oMe,oMerchant,oPC);
    } // items exist
    else if (oPC==oPlayer)
    { // destroy
      DestroyObject(oMe);
      AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",TRUE,FALSE));
    } // destroy
}
