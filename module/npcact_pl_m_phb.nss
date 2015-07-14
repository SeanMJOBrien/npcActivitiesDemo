/////////////////////////////////////////////////////////////////////
// npcact_pl_m_phb - NPC ACTIVITIES 6.0 Professions Merchant
// OnHeartbeat for invisible sell to merchant placeable
// By Deva Bryson Winblood. 07/24/2005
/////////////////////////////////////////////////////////////////////

void main()
{
   object oMe=OBJECT_SELF;
   object oPC=GetLocalObject(oMe,"oPlayer");
   object oMerchant=GetLocalObject(oMe,"oMerchant");
   float fDist=GetDistanceBetween(oMe,oPC);
   int bDestroy=FALSE;
   object oItem;
   object oCopy;
   if (oPC==OBJECT_INVALID||GetIsDead(oPC)) bDestroy=TRUE;
   if (GetArea(oMe)!=GetArea(oPC)||fDist>3.0) bDestroy=TRUE;
   if (GetIsInCombat(oPC)) bDestroy=TRUE;
   if (bDestroy==TRUE)
   { // destroy object
     oItem=GetFirstItemInInventory(oMe);
     while(oItem!=OBJECT_INVALID)
     { // give items back
       if (oPC!=OBJECT_INVALID)
       { // give items back
         oCopy=CopyObject(oItem,GetLocation(oPC),oPC);
       } // give items back
       DelayCommand(0.5,DestroyObject(oItem));
       oItem=GetNextItemInInventory(oMe);
     } // give items back
     DelayCommand(0.6,DestroyObject(oMe));
     if (oPC!=OBJECT_INVALID)
     { // cleanup variables
       SendMessageToPC(oPC,"You got too far from the merchant.  Selling is cancelled!");
       DeleteLocalInt(oMerchant,"nProfMerchConvMode");
     } // cleanup variables
   } // destroy object
}
