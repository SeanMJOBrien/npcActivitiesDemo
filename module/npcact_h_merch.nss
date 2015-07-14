////////////////////////////////////////////////////////////////////////
// npcact_h_merch - NPC ACTIVITIES 6.0 Professions Merchant
// Header Support functions for complex merchant
// By Deva Bryson Winblood. 07/09/2005
////////////////////////////////////////////////////////////////////////
#include "npcact_h_money"
#include "npcactivitiesh"

//////////////////////
// PROTOTYPES
//////////////////////

// FILE: npcact_h_merch         FUNCTION: MerchantCreateStore()
// This function will create a store object owned by oMerchant
// that is accessed by oPlayer.  If nType is set to 0 then it will
// be a store from which the player may purchase items.  If nType is
// set to 1 then it is a chest the player may stick items for sell
// into.
object MerchantCreateStore(object oMerchant,object oPlayer,int nType=0);

// FILE: npcact_h_merch        FUNCTION: MerchantGetItemValues()
// This function will go through the container which can be a placeable
// a merchant, or a player.  It will look for items flagged as
// a transaction and will return the total base value before
// modifications of the items in MUs.  If bBuy is set to FALSE
// then it will assume these items are being sold.
int MerchantGetItemValues(object oContainer,object oMerchant,int bBuy=TRUE);

// FILE: npcact_h_merch        FUNCTION: DestroyStore()
// This function will destroy the contents of the store and then
// destroy the store itself.
void DestroyStore(object oStore);

// FILE: npcact_h_merch        FUNCTION: SetMerchantBan()
// This function will set a ban from this merchant for a specified
// number of hours.  If the hours are set to 0 then it will clear
// any ban.  IF the hours are set to -1 then the ban is permanent.
void SetMerchantBan(object oMerchant,object oPC,int nDuration=-1);

// FILE: npcact_h_merch        FUNCTION: GetMerchantBan()
// This function will return the ban level if any for the specified
// PC.  -1 = permanent, 0 = none, or specific hour must pass for ban
// to lift.
int GetMerchantBan(object oMerchant,object oPC);

// FILE: npcact_h_merch        FUNCTION: GetBanTime()
// This function will return a time in absolute hours.
// Hour+Day*24+month*24*30+year*24*30*360
int GetBanTime();

//////////////////////
// FUNCTIONS
//////////////////////

void fnDuplicateItem(object oWhere,object oItem)
{ // PURPOSE: So, we can delay the spawning of the inventory
  object oCopy;
  int nN;
  string sItem;
  sItem=GetResRef(oItem);
  nN=GetItemStackSize(oItem);
  oCopy=CreateItemOnObject(sItem,oWhere,nN);
  SetLocalObject(oCopy,"oMaster",oItem);
  nN=GetItemCharges(oItem);
  if (nN!=0) SetItemCharges(oCopy,nN);
  SetLocalInt(oCopy,"bInvalid",TRUE);
} // fnDuplicateItem()

object MerchantCreateStore(object oMerchant,object oPlayer,int nType=0)
{ // PURPOSE: Create the store objects for player interaction and cause
  // the player to interact with them.
  object oStore;
  object oWP;
  string sRes="npcact_pl_m_by";
  object oItem;
  object oCopy;
  string sS;
  string sT;
  int nL;
  int nC;
  int nN;
  string sItem;
  if (nType==1) sRes="npcact_pl_m_pu";
  oStore=CreateObject(OBJECT_TYPE_PLACEABLE,sRes,GetLocation(oPlayer),FALSE);
  SetLocalObject(oStore,"oMerchant",oMerchant);
  SetLocalObject(oStore,"oPlayer",oPlayer);
  if (nType==0)
  { // populate store
    sRes=GetLocalString(oMerchant,"sProfMerchContainer");
    if (sRes=="DB")
    { // database
    } // database
    else
    { // container
      oWP=GetObjectByTag(sRes);
      if (oWP!=OBJECT_INVALID&&GetHasInventory(oWP))
      { // store container found
        SetLocalObject(oStore,"oStorage",oWP);
        SetLocalObject(oPlayer,"oMerchStorage",oWP);
        oItem=GetFirstItemInInventory(oWP);
        while(oItem!=OBJECT_INVALID)
        { // traverse inventory
          DelayCommand(0.5,fnDuplicateItem(oStore,oItem));
          oItem=GetNextItemInInventory(oWP);
        } // traverse inventory
      } // store container found
    } // container
    // check for variable based inventory
    nC=1;
    sS=GetLocalString(oMerchant,"sMerchInvRes"+IntToString(nC));
    while(GetStringLength(sS)>0)
    { // traverse variable based inventory
      nN=GetLocalInt(oMerchant,"nProfMerchInvQty"+IntToString(nC));
      if (GetLocalInt(oMerchant,"bProfMerchInfinite"+IntToString(nC))==1) nN=6;
      sT=GetLocalString(oMerchant,"sProfMerchInvTag"+IntToString(nC));
      nL=1;
      while(nL<=nN)
      { // create objects
        oCopy=CreateItemOnObject(sS,oStore);
        if (GetTag(oCopy)!=sT&&GetStringLength(sT)>0)
        { // different tag
          oItem=oCopy;
          oCopy=CopyObject(oItem,GetLocation(oStore),oStore,sT);
          DelayCommand(0.5,DestroyObject(oItem));
        } // different tag
        SetLocalInt(oCopy,"nItemNum",nC);
        SetLocalInt(oCopy,"bInvalid",TRUE);
        nL++;
      } // create objects
      nC++;
      sS=GetLocalString(oMerchant,"sMerchInvRes"+IntToString(nC));
    } // traverse variable based inventory
  } // populate store
  // make player interact with store
  if (oPlayer!=OBJECT_INVALID&&GetIsPC(oPlayer)==TRUE&&oStore!=OBJECT_INVALID)
  {
   DelayCommand(0.2,AssignCommand(oPlayer,ClearAllActions(TRUE)));
   DelayCommand(0.21,AssignCommand(oPlayer,ActionInteractObject(oStore)));
  }
  return oStore;
} // MerchantCreateStore()

int MerchantGetItemValues(object oContainer,object oMerchant,int bBuy=TRUE)
{ // PURPOSE: Return a value in MUs
  int nMUs=0;
  int nV;
  object oItem=GetFirstItemInInventory(oContainer);
  while(oItem!=OBJECT_INVALID)
  { // items
    if (GetLocalInt(oItem,"bInvalid"))
    { // valid
      nV=GetPrice(GetResRef(oItem),oMerchant);
      nMUs=nMUs+nV;
    } // valid
    oItem=GetNextItemInInventory(oContainer);
  } // items
  return nMUs;
} // MerchantGetItemValues()

void DestroyStore(object oStore)
{ // PURPOSE: Cleanup the store
  object oItem;
  if (oStore!=OBJECT_INVALID&&GetHasInventory(oStore))
  { // destroy inventory
    oItem=GetFirstItemInInventory(oStore);
    while(oItem!=OBJECT_INVALID)
    { // destroy
      DelayCommand(0.1,DestroyObject(oItem));
      oItem=GetNextItemInInventory(oStore);
    } // destroy
  } // destroy inventory
  DelayCommand(0.3,DestroyObject(oStore));
} // DestroyStore();

int GetBanTime()
{ // PURPOSE: Return BAN time
  int nRet=GetTimeHour();
  nRet=nRet+(GetCalendarDay()*24);
  nRet=nRet+(GetCalendarMonth()*24*30);
  nRet=nRet+(GetCalendarYear()*24*30*360);
  return nRet;
} // GetBanTime()

void SetMerchantBan(object oMerchant,object oPC,int nDuration=-1)
{ // PURPOSE: Set BAN
  string sPID;
  int nTime;
  if (oPC!=OBJECT_INVALID&&GetIsPC(oPC)&&oMerchant!=OBJECT_INVALID)
  { // valid objects
    sPID=fnGeneratePID(oPC);
    nTime=nDuration;
    if (nTime<0) nTime=-1;
    if (nTime<0)
    { // permanent ban
      SetLocalInt(oMerchant,"nBannedPC_"+sPID,-1);
    } // permanent ban
    else if (nTime==0)
    { // remove ban
      DeleteLocalInt(oMerchant,"nBannedPC_"+sPID);
    } // remove ban
    else
    { // specific ban
      nTime=GetBanTime()+nDuration;
      SetLocalInt(oMerchant,"nBannedPC_"+sPID,nTime);
    } // specific ban
  } // valid objects
} // SetMerchantBan()

int GetMerchantBan(object oMerchant,object oPC)
{ // PURPOSE: Get Merchant Ban settings
  int nRet=0;
  string sPID;
  if (oMerchant!=OBJECT_INVALID&&oPC!=OBJECT_INVALID&&GetIsPC(oPC)==TRUE)
  { // valid
    sPID=fnGeneratePID(oPC);
    nRet=GetLocalInt(oMerchant,"nBannedPC_"+sPID);
  } // valid
  return nRet;
} // GetMerchantBan()

void fnPurgeInvalids()
{ // PURPOSE: Strip any bInvalid items from inventory
  object oMe=OBJECT_SELF;
  object oItem=GetFirstItemInInventory(oMe);
  while(oItem!=OBJECT_INVALID)
  { // purge
    if (GetLocalInt(oItem,"bInvalid")==TRUE) DelayCommand(0.3,DestroyObject(oItem));
    oItem=GetNextItemInInventory(oMe);
  } // purge
} // fnPurgeInvalids()

//void main(){}
