///////////////////////////////////////////////////////////////////////
// npcact_pl_byd - NPC ACTIVITIES 6.0 Professions Merchant
// OnDisturbed for Merchant Store
// By Deva bryson Winblood. 07/11/2005
///////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"

void main()
{
   object oMe=OBJECT_SELF;
   object oMerchant=GetLocalObject(oMe,"oMerchant");
   object oPC=GetLastDisturbed();
   object oPlayer=GetLocalObject(oMe,"oPlayer");
   object oItem=GetModuleItemAcquired();
   object oCopy;
   string sRes;
   int nV;
   int nO;
   float fMarkup;
   float fPrice;
   int nBT=GetBaseItemType(oItem);
   string sPID=fnGeneratePID(oPlayer);
   if (oPC==oPlayer)
   { // delete counts
     DeleteLocalInt(oMerchant,"nICount_"+sPID);
     DeleteLocalInt(oMerchant,"nPCount_"+sPID);
   } // delete counts
   //SendMessageToPC(oPlayer,"DISTURBED by "+GetName(oPC));
   if (oItem!=OBJECT_INVALID&&GetModuleItemAcquiredBy()==oPC&&GetItemPossessor(oItem)==oPC&&oPlayer==oPC&&GetLocalInt(oItem,"bInvalid"))
   { // item exists
     SetLocalObject(oPC,"oMerchItem",oItem);
     /*if (nBT==BASE_ITEM_GEM||nBT==BASE_ITEM_GRENADE||nBT==BASE_ITEM_SCROLL||nBT==BASE_ITEM_POTIONS)
     { // break up stack
       nBT=GetItemStackSize(oItem);
       if (nBT>1)
       { // break up stack
         nBT=nBT-1;
         SetItemStackSize(oItem,1);
         oCopy=CreateItemOnObject(sRes,oMe,nBT);
         SetLocalInt(oCopy,"bInvalid",TRUE);
       } // break up stack
     } // break up stack  */
     sRes=GetResRef(oItem);
     nV=GetPrice(sRes,oMerchant,100,GetItemStackSize(oItem));
     //SendMessageToPC(oPC,"Looking for "+GetName(oItem)+" '"+sRes+"' returned:"+IntToString(nV)+" MUs.");
     if (nV>0)
     { // item found and has a price
       //SendMessageToPC(oPC,"Base Price of "+GetName(oItem)+" is "+IntToString(nV)+" MUs.");
       if (GetStolenFlag(oItem))
       { // stolen
         nO=GetLocalInt(oMerchant,"nProfMerchBarterSSS");
         if (nO==-1) { nV=-2; }
         else { // allowed to buy stolen goods
           if (nO>0)
           { // stolen price found
             fMarkup=IntToFloat(nO);
             fMarkup=fMarkup/100.0;
             fPrice=IntToFloat(nV)*fMarkup;
             nV=FloatToInt(fPrice);
           } // stolen price found
         } // allowed to buy stolen goods
       } // stolen
       else
       { // not stolen
         nO=GetLocalInt(oMerchant,"nProfMerchBarterSSN");
         if (nO==-1) { nV=-2; }
         else
         { // allowed to buy
           if (nO>0)
           { // price found
             fMarkup=IntToFloat(nO);
             fMarkup=fMarkup/100.0;
             fPrice=IntToFloat(nV)*fMarkup;
             nV=FloatToInt(fPrice);
           } // price found
         } // allowed to buy
       } // not stolen
       if (nV>=0)
       { // ok to sell
         if (nV==0) nV=1;
         nO=GetLocalInt(oMerchant,"nProfMerchCurrency");
         sRes="I see you are interested in the "+GetName(oItem)+"["+IntToString(GetItemStackSize(oItem))+"].  I'll let you have it for ";
         sRes=sRes+MoneyToString(nV,nO,FALSE);
         SetLocalInt(oPC,"nProfMerchPrice",nV);
         SetLocalInt(oMerchant,"nProfMerchConvMode",2);
         SetLocalObject(oPC,"oProfMerchStore",oMe);
         SetLocalString(oPC,"sProfMerchSays",sRes);
         //SendMessageToPC(oPC,"Trying to buy "+GetName(oItem)+" for "+IntToString(nV)+" MUs");
         //AssignCommand(oPC,ClearAllActions(TRUE));
         AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",FALSE,FALSE));
       } // ok to sell
       else
       { // not for sale
         SendMessageToPC(oPC,GetName(oItem)+" is not for sale!");
         DelayCommand(0.5,DestroyObject(oItem));
       } // not for sale
     } // item found and has a price
     else
     { // not for sale
       SendMessageToPC(oPC,GetName(oItem)+" is not for sale!");
       DelayCommand(0.5,DestroyObject(oItem));
     } // not for sale
   } // item exists
}

/*
oItem=fnFindItem(oPC);
      if (oItem!=OBJECT_INVALID)
      { // item chosen... activate proper conversation
        SetLocalObject(oPC,"oMerchItem",oItem);
        sRes=GetResRef(oItem);
        nV=GetPrice(sRes,oMe,100);
        nO=GetLocalInt(oMe,"nProfMerchMaxSpend");
        if (nV>0)
        { // found and has a price
          if (nO>0&&nV>nO) nV=nO;
          if (GetStolenFlag(oItem))
          { // item is stolen
            nO=GetLocalInt(oMe,"nProfMerchBarterSSS");
            if (nO==-1) { nV=-2; }
            else { // allowed to buy stolen goods
              if (nO>0)
              { // stolen price found
                fMarkup=IntToFloat(nO);
                fMarkup=fMarkup/100.0;
                fPrice=IntToFloat(nV)*fMarkup;
                nV=FloatToInt(fPrice);
              } // stolen price found
            } // allowed to buy stolen goods
          } // item is stolen
          else
          { // not stolen
            nO=GetLocalInt(oMe,"nProdMerchBarterSSN");
            if (nO==-1) { nV=-2; }
            else
            { // allowed to buy
              if (nO>0)
              { // price found
                fMarkup=IntToFloat(nO);
                fMarkup=fMarkup/100.0;
                fPrice=IntToFloat(nV)*fMarkup;
                nV=FloatToInt(fPrice);
              } // price found
            } // allowed to buy
          } // not stolen
        } // found and has a price
        if (nV==-2)
        { // not for sale
          SendMessageToPC(oPC,"That item is not for sale!!");
          DestroyObject(oItem);
        } // not for sale
        if (nV>0)
        { // item found and available for sale
          nO=GetLocalInt(oMe,"nProfMerchCurrency");
          sRes="I see you are interested in the "+GetName(oItem)+".  I'll let you have it for ";
          sRes=sRes+MoneyToString(nV,nO,FALSE);
          SetLocalInt(oPC,"nProfMerchConvMode",2);
          AssignCommand(oPC,ClearAllActions(TRUE));
          AssignCommand(oPC,ActionStartConversation(oMe,"npcact_merchant",FALSE,FALSE));
        } // item found and available for sale
      } // item chosen... activate proper conversation
*/

