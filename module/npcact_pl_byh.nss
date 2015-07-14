//////////////////////////////////////////////////////////////////////
// npcact_pl_byh = NPC ACTIVITIES 6.0 Professions Merchant
// OnHeartbeat to monitor distance of buyer so not run away with
// goods.
// By Deva Bryson Winblood. 07/10/2005
//////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"

//////////////////////////////
// PROTOTYPES
//////////////////////////////

object fnFindItem(object oPC);


////////////////////////////////////////////////// MAIN
void main()
{
    object oMe=OBJECT_SELF;
    object oPC=GetLocalObject(oMe,"oPlayer");
    float fDist=GetDistanceBetween(oMe,oPC);
    object oItem;
    int nV;
    int nO;
    float fMarkup;
    float fPrice;
    string sRes;
    //SendMessageToPC(oPC,"HEARTBEAT");
    if (oPC!=OBJECT_INVALID&&GetArea(oMe)==GetArea(oPC)&&fDist<=2.0)
    { // in range
    } // in range
    else
    { // cleanup
      if (oPC!=OBJECT_INVALID)
      { // purge unbought items
        if (fDist>2.0) SendMessageToPC(oPC,"Too far from the store!");
        AssignCommand(oPC,fnPurgeInvalids());
      } // purge unbought items
      DelayCommand(0.5,DestroyStore(oMe));
    } // cleanup
}
////////////////////////////////////////////////// MAIN

//////////////////////
// FUNCTIONS
//////////////////////
object fnFindItem(object oPC)
{ // PURPOSE: Find the item associated with Disturbed
  object oItem=GetFirstItemInInventory(oPC);
  while(oItem!=OBJECT_INVALID)
  { // traverse inventory
    if (GetLocalInt(oItem,"bInvalid")==TRUE) return oItem;
    oItem=GetNextItemInInventory(oPC);
  } // traverse inventory
  return OBJECT_INVALID;
} // fnFindItem()
