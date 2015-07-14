////////////////////////////////////////////////////////////////////////////////
// npcact_h_money - NPC ACTIVITIES 6.0 Custom Monetary System   Version 2.0
// By Deva Bryson Winblood.  12/2004    Non-Database version of this header
// Last Modified By: Deva Winblood  1/2005
////////////////////////////////////////////////////////////////////////////////
/*
    This header file contains all the functions needed to support a custom
    monetary system supporting an infinite variety of coins and multiple currencies.
    It can be used to convert between currencies like a money changer.  It also
    has functional support built in to support banking if that is your desire.
    These functions will also be supported and used by NPC ACTIVITIES 6.0
    Professions as needed.
*/

#include "npcact_aps"
#include "x2_inc_itemprop"

/////////////////////////
// CONSTANTS
/////////////////////////

const string DB_TABLE = "npcactcms";  // default database table to use

// for weight determination
  const int WR10 = IP_CONST_REDUCEDWEIGHT_10_PERCENT;
  const int WR20 = IP_CONST_REDUCEDWEIGHT_20_PERCENT;
  const int WR40 = IP_CONST_REDUCEDWEIGHT_40_PERCENT;
  const int WR60 = IP_CONST_REDUCEDWEIGHT_60_PERCENT;
  const int WR80 = IP_CONST_REDUCEDWEIGHT_80_PERCENT;
  const int WI5 = IP_CONST_WEIGHTINCREASE_5_LBS;
  const int WI10 = IP_CONST_WEIGHTINCREASE_10_LBS;
  const int WI15 = IP_CONST_WEIGHTINCREASE_15_LBS;
  const int WI30 = IP_CONST_WEIGHTINCREASE_30_LBS;
  const int WI50 = IP_CONST_WEIGHTINCREASE_50_LBS;
  const int WI100 = IP_CONST_WEIGHTINCREASE_100_LBS;

/////////////////////////
// STRUCTURES
/////////////////////////
struct stWeightEffects {
   int nWeightInc;
   int nWeightRed;
};

/////////////////////////
// P R O T O T Y P E S
/////////////////////////

// FILE: npcact_h_money                 FUNCTION: AddCoinType()
// This function will create a coin type for use by the custom monetary system.
// sName should be the name of the coin in all lower case.  EXAMPLES: silver,
// gold, shilling, etc.   sAbbreviation should be the abbreviated form of this
// name.  EXAMPLES: sp, gp, sh     nValue should be the value of this coin
// expressed in MUs (monetary units).  Remember, 1 MU should match the value
// of the absolute least value coin in a currency.  Each currency should have
// some coin type that is worth only 1 MU.  sResRef is the resref of an inventory
// item that represents this type of coin and will be used to drop, count, and
// do other types of coin related duties.  These items should prepared in such
// a way that using them activates an OnActivateItem script named npcact_it_coin.
// They should be set to PLOT, and IDENTIFIED and have a Cast Spell - Unique Spell
// with unlimited uses per day.  nCurrency can be used to specify differing currency
// systems so, that you may setup alternate money systems in other countries, and
// make merchants and such that only accept specific currencies.  If you do not
// need multiple currencies, then simply leave it at the default value of 1.
void AddCoinType(string sName,string sAbbreviation, int nValue, string sResRef, int nCurrency=1);

// FILE: npcact_h_money                 FUNCTION: SetGoldConversionType()
// When the alternate monetary system is in use you will no longer want gold to
// be handled as the default NWN system handles it.  For this reason the system
// needs to know what value gold should have in terms of MUs (monetary units) and
// which currency it should be in.  You will want to make sure you have used
// AddCoinType() to create a coin with that value in that currency.  You only need
// to set this once.  Once, it is set anytime a player acquires gold by some left
// over script the monetary system will kick in and give you the appropriate
// converted coins and will remove the bioware gold. If you need to know what
// monetary value to set the gold.  In 3rd edition D&D system it should be 100
// because, silver is 10, and copper is 1.  In 1st edition D&D system it would
// be 200 because, copper is 1, silver is 10, electrum is 100, etc.  If you
// are still confused then see the NPC ACTIVITIES 6.0 documentation for further
// details and explanations.
void SetGoldConversionType(int nValue, int nCurrency=1);

// FILE: npcact_h_money                 FUNCTION: DetermineCoinWeight()
// This function should be used if you want this system to make coins have
// weight. This function will handle the weight of the coins.   In the meantime,
// if this function is EVER used then it will set a coin weight value which
// will cause all coin related functions that take or give coins to call this
// function as appropriate when they occur.  If you wish to remove weight later
// in the module you would call this function and set nCoin1LB to 0. If
// bEncumbrance is set to TRUE then it will make the person unable to move if
// they reach maximum encumberance.  This will force them to drop something in
// order to move.  This is provided so, that a person will not be able to slowly
// move even if they are carrying more than they are allowed.
// If oObject is the module object it will set the default coin weight
// otherwise, this should be passed coin objects which it can add weight to
void DetermineCoinWeight(object oObject,int nCoin1LB=50,int bEncumbrance=FALSE);

// FILE: npcact_h_money                 FUNCTION: PricingMultiple()
// This function is used to set the base pricing multiplier.  The purpose is due
// to the fact that the value of gold is shifted.  A common value for gold is
// 100 in many systems.  So, something that cost 1 gold before should cost 100 Mus
// (Monetary Units).  The custom monetary system will check to see if a specific
// price for the item has been defined relevant to the monetary system.  If it has
// not then it will find out what the Bioware price for the item is and then
// multiply it by this multiple.  If you wanted to use standard prices but, use
// a custom monetary system then this multiplier is the only thing you would ever
// have to set.  It should generally be set to whatever the value of gold is in
// MUs.
void PricingMultiple(int nMultiple);

// FILE: npcact_h_money                 FUNCTION: SetPrice()
// This function enables you to specify the price in MUs (monetary units)
// of an item by its resref.  If you do not specify bUseDatabase then it will
// set this price as a local variable off of the module object.
// EXAMPLE: nw_it_torch001 is a torch resref.  It costs 1 gold in default bioware.
// Let's say we made the 3rd edition D&D monetary system where a gold is worth 100
// copper pieces and the Player's Handbook says a torch should cost 1 copper.
// Well a copper is worth 1 MU and a gold is 100MU.  If we do not specify the
// price then when the multiplier kicks in it will make the torch cost 100MU.
// If we do this:
// SetPrice("nw_it_torch001",1);
// Then the price for the item will now be set at 1 copper piece. Simple enough?
void SetPrice(string sResRef,int nPrice);

// FILE: npcact_h_money                 FUNCTION: GetCoins()
// This function will enable you to count the specific number of coins in a specified
// currency or to count all the coins in a currency. If sAbbreviation is set to
// ANY then it will count all coin types in that currency.  If bUseDatabase is set to
// TRUE it will read it from the database.  If bIncludeBank is set to TRUE then it will
// include any such coins the oObject might have in a bank account.
// EXAMPLE: nSilver=GetCoins(oPC,"sp");
int GetCoins(object oObject,string sAbbreviation="ANY",int nCurrency=1,int bIncludeBank=FALSE);

// FILE:npcact_h_money                  FUNCTION: GetWealth()
// This function will return how much wealth the oObject has expressed in MUs and
// tied to a specific currency.  If bIncludeBank is set to TRUE it will include any
// wealth the oObject may have in a bank account.
int GetWealth(object oObject,int nCurrency=1,int bIncludeBank=FALSE);

// FILE: npcact_h_money                 FUNCTION: GiveCoins()
// This function will give coins to the specified oObject in the amount
// specified in nAmount.   If sAbbreviation is "ANY" then it will assume that
// nAmount is an amount in MUs and will convert it to the appropriate coins to
// meet that amount.  Otherwise, it will give the nAmount of the type of coin
// specified.
// EXAMPLES: GiveCoins(oPC,126,"sp");    would give oPC 126 silver coins if that
// is what "sp" was defined is.  GiveCoins(oPC,126,"ANY");   would give oPC 126
// MUs which might translate to 1 gold, 2 silver, and 6 copper if you were using
// the 3rd Edition D&D Monetary system. This function should be used instead of
// Bioware's GiveGoldToCreature() but, it will also work with containers, stores,
// and other relevant objects that can contain wealth.
void GiveCoins(object oObject,int nAmount,string sAbbreviation="ANY",int nCurrency=1);

// FILE: npcact_h_money                 FUNCTION: TakeCoins()
// This function will cause the object that called the function to take the
// nAmount of coins from oTarget.  If bDestroy is set to TRUE it will destroy the
// coins it takes.  Otherwise, it will store them on the calling object if appropriate.
// If sAbbreviation is set to "ANY" then it will assume that nAmount is a value expressed
// in MUs and will take whatever coins are available to achieve this amount.  It will make
// change if need be.   For more details see GiveCoins() because, this function works
// similarly but, in the opposite direction.  This function should be used instead of
// Bioware's TakeGoldFromCreature();
// If bSilent is set to TRUE it will not tell the target that the coins were taken
void TakeCoins(object oTarget,int nAmount,string sAbbreviation="ANY",int nCurrency=1,int bDestroy=FALSE,int bSilent=FALSE);

// FILE: npcact_h_money                 FUNCTION: ConvertCoins()
// This function can be used to calculate how many of a certain type of coin to convert
// to a specific Monetary Unit value.  It also determines what % of the actual value is
// given back.  This way you can include a cut off the top for a money changer NPC.
// This function does not perform an action.  It returns a value that you can then use.
// EXAMPLE: Let's say I needed to convert silver pieces which have a MU value
// of 10 each into shell pieces which have an MU value of 25.   The money
// changer will do so but, keeps 10% as his fee.  I will convert 50 silver.
// nShells=ConvertCoins("sp",25,50,1,90);
// TakeCoins(oPC,"sp",50,1,FALSE,TRUE);
// GiveCoins(oPC,"sh",nShells,2,FALSE);
// The above 3 lines would find out how many shell pieces the money changer will
// give the player in exchange for 50 silver.   The second line takes the 50 silver and
// destroys it.  The final line gives the player the number of shell pieces that was
// determined in the first line.    Money Changer activity has occurred.
// NOTE: This function will return -1 if it encounters an error.
int ConvertCoins(int nAmount,string sAbbreviation,int nMUValue, int nCurrency=1,int nPercentage=100);

// FILE: npcact_h_money                 FUNCTION: GetCoinValue()
// This function will return the MU (monetary unit) value of the specified
// coin type within the specified nCurrency system.  It will return -1 if it
// does not find such a currency defined.
int GetCoinValue(string sAbbreviation,int nCurrency=1);

// FILE: npcact_h_money                 FUNCTION: GetPrice()
// This function will consult the pricing system and will return the price of
// the specified object in MUs (monetary units).  It will apply the appropriate
// markup as indicated.  If it is 100 then it will give the actual price.  If it
// is 80 then it will give the price 20% reduced.  If it wer 150 then it would
// give the price 50% marked up.  If it cannot find such an item it will return
// -1. If a merchant is specified it will check them for overrides to the price.
// If such a price exists and is set to -2 then it indicates the merchant will
// not buy or sell such an item.
int GetPrice(string sResRef,object oMerchant=OBJECT_INVALID,int nMarkup=100,int nStackSize=1);

// FILE: npcact_h_money                 FUNCTION: MoneyToString()
// This will return a string representation of a value in Mus as expressed in coin
// types of the specified currency.  EXAMPLE:
// sString=MoneyToString(237,1);  in the 3rd edition D&D rules would return.
// "2 gp, 3 sp, and 7 cp"   If bAbbreviate is set to FALSE it would return:
// "2 gold, 3 silver, and 7 copper".
string MoneyToString(int nAmount,int nCurrency=1,int bAbbreviate=TRUE);


// FILE: npcact_h_money                 FUNCTION: CreateCoins()
// This function will create coin items in the inventory of the object specified.
// This should NOT be used to give coins to a PC.  Use GiveCoins() for that
// if the object specified is OBJECT_INVALID then it will create them at the location
// specified. If bRandom is set to FALSE it will choose coins that are the best fit
// when "ANY" is specified.   If set to TRUE it will randomly pick coin types to
// add up to the amount.
void CreateCoins(object oObject,location lLocation,int nAmount,string sAbbreviation="ANY",int nCurrency=1,int bRandom=FALSE);

// FILE: npcact_h_money                 FUNCTION: DepositCoins()
// This will deposit nAmount of sAbbreviation coins in nCurrency into the
// bank account of oObject.  If sAbbreviation is set to ANY it will treat nAmount
// as a value expressed in Mus and will deposit appropriate coins to total this value.
void DepositCoins(object oObject, int nAmount,string sAbbreviation="ANY",int nCurrency=1);

// FILE: npcact_h_money                 FUNCTION: WithdrawCoins()
// This function will withdraw nAmount of sAbbreviation coins from the bank
// and if sAbbreviation is set to ANY it will treat the nAmount as an amount in
// MUs and will make appropriate coin conversions to achieve that value.
void WithdrawCoins(object oObject, int nAmount,string sAbbreviation="ANY",int nCurrency=1);

// FILE: npcact_h_money                 FUNCTION: SplitCoins()
// This function will enable you to break a pile of coins in your inventory into
// two piles where at least one of the piles will be of size nAmountToSplit.
void SplitCoins(object oObject,object oStartingPile,int nAmountToSplit);

// FILE: npcact_h_money                 FUNCTION: MergeCoins()
// This function will enable you to merge two piles of coins in an inventory
// into a single pile.  It only works with coins of the same type. The 2nd
// pile will be destroyed when the piles are merged.
void MergeCoins(object oObject,object oPile1,object oPile2);

// FILE: npcact_h_money                 FUNCTION: SetMasterCoinItem()
// This will inform the monetary system which item on a players inventory
// will actually be used to track the total amounts of the coins carried.
// It must always be a tag of an item that every PC will have at all
// times.  If the tag is set to "DB" then it will track these totals in
// the database instead of on an item in the inventory.  Keep in mind that
// locals stored on an object in a player's inventory are persistent as well.
void SetMasterCoinItem(string sTag);

// FILE: npcact_h_money                 FUNCTION: LoadMonetarySystem()
// This will load any coin types stored in a database file and set up the
// equivalent locals on the module object.  This function is provided since
// the functions in the monetary system will be likely called often and
// making a single GetLocal() is faster than calling a query then calling
// a get local to process the results of the query.  If you have setup a
// monetary system in your DB then you will need to call this function in
// your OnLoadModule() event and will need to customize it so, it properly
// loads your database.
void LoadMonetarySystem();

// FILE: npcact_h_money                 FUNCTION: GetWealthCarriedString()
// This function will return the wealth carried by the object expressed as
// an exact string.  If bAbbreviate is set to TRUE then it will use abbreviations
// when listing the amount of coins carried.
string GetWealthCarriedString(object oObject,int nCurrency=1,int bAbbreviate=FALSE);

// FILE: npcact_h_money                 FUNCTION: SetCurrencyName()
// This sets a name to be associated with this currency number which will be
// displayed when appropriate in game.  EXAMPLES: Imperial, American, Danish,
// Euros, etc.   I USED: Standard, and Elven in my test module.
void SetCurrencyName(string sName,int nCurrency=1);

// FILE: npcact_h_money                 FUNCTION: UnacquireCoins()
// This function is provided to be used in an OnUnacquire module event script
// you can call it for an object unacquired and this function will quickly test
// to see if it was a monetary system item.  If it is then it will make the
// needed adjustments to the money possessed by the oPC.  It will also set the
// oOwner flag back to OBJECT_INVALID.  This function will return TRUE if it
// was a monetary system item.  You can use the return value to test to see
// if your OnUnacquire script needs to do anything more or not.
int UnacquireCoins(object oItem,object oPC=OBJECT_SELF);

// FILE: npcact_h_money                 FUNCTION: AcquireCoins()
// This function is provided to be used in an OnAcquire module event script
// It will test to see if the item is a monetary item.  If it is and oOwner
// is not the same target it will increment the amount of money carried and
// then set oOwner.  If this function returns TRUE then the item was a monetary
// system item and has been handled and your OnAcquire script need not be
// further concerned with the item.
int AcquireCoins(object oItem,object oPC=OBJECT_SELF);

/////////////////////////
// Support Functions
// Functions in this section are only used by the other functions
// and do not need to be called external to this include file
//////////////////////////////////////////////////////////////////

int fnCheckIfCoinTypeExists(string sName,string sAbbreviation, int nValue, string sResRef, int nCurrency=1)
{ // PURPOSE: Checks to see if this coin has already been defined or if that
  // sResRef has already been used.  It will return 0 if nothing has been
  // defined.  It will return -1 if the ResRef is already in use.  It returns
  // the coin type number if it is already defined.
  int nRet=0;
  int nN;
  object oMod=GetModule();
  string sS;
  if (GetLocalInt(oMod,"nMSCoin"+sResRef+"_"+IntToString(nCurrency))>0) return -1;
  nN=1;
  sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
  while(GetStringLength(sS)>0)
  { // traverse coins
    if (sS==sName)
    { // name matches
      sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
      if (sS==sAbbreviation)
      { // abbreviation matches
        return nN;
      } // abbreviation matches
    } // name matches
    nN++;
    sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
  } // traverse coins
  return nRet;
} // fnCheckIfCoinTypeExists()

string fnGeneratePID(object oPC)
{ // PURPOSE: Generate PID for Database support
  string sRet=GetPCPublicCDKey(oPC)+GetPCPlayerName(oPC)+GetName(oPC);
  return sRet;
} // fnGeneratePID()

int fnLeastValuableCoin(int nCurrency=1)
{ // PURPOSE: return the least valuable coin in this currency
  int nN=1;
  object oMod=GetModule();
  int nLeast=9999999;
  int nRet=0;
  int nV;
  string sS;
  sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
  while(GetStringLength(sS)>0)
  { // check complete currency
    nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
    if (nV<nLeast)
    { // least
      nRet=nN;
      nLeast=nV;
    } // least
    nN++;
    sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
  } // check complete currency
  return nRet;
} // fnLeastValuableCoin()

int fnFindBestCoinFit(int nAmount,int nCurrency=1)
{ // PURPOSE: Return the number of the coin that best fits the specifed MU
  // nAmount
  int nRet=0;
  int nN;
  int nClosest=0;
  string sS;
  int nV;
  object oMod=GetModule();
  nN=1;
  sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
  while(GetStringLength(sS)>0)
  { // check all coin types
    nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
    if (nV>nClosest&&nV<=nAmount) { nClosest=nV; nRet=nN; }
    nN++;
    sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
  } // check all coin types
  return nRet;
} // fnFindBestCoindFit()

struct stWeightEffects fnDetermineWeightEffects(int nWeight)
{ // PURPOSE: return what effects to apply
  struct stWeightEffects stRet;
  int nInc=0;
  int nRed=0;
  switch(nWeight)
  { // determine effects
    case 1: { nInc=WI5; nRed=WR80; break; }
    case 2: { nInc=WI5; nRed=WR60; break; }
    case 3: { nInc=WI5; nRed=WR40; break; }
    case 4: { nInc=WI5; nRed=WR20; break; }
    case 5: { nInc=WI5; nRed=0; break; }
    case 6: { nInc=WI10; nRed=WR40; break; }
    case 7: { nInc=WI10; nRed=WR40; break; }
    case 8: { nInc=WI10; nRed=WR20; break; }
    case 9: { nInc=WI10; nRed=WR10; break; }
    case 10: { nInc=WI10; nRed=0; break; }
    default: break;
  } // determine effects
  stRet.nWeightInc=nInc;
  stRet.nWeightRed=nRed;
  return stRet;
} // stWeightEffects()


int fnMaxCarry(object oPC)
{ // PURPOSE: Determine maximum carrying capacity in lbs
  int nSTR=GetAbilityScore(oPC,ABILITY_STRENGTH);
  switch (nSTR)
  { // return carrying capacity
    case 1: { return 10; }
    case 2: { return 20; }
    case 3: { return 30; }
    case 4: { return 40; }
    case 5: { return 50; }
    case 6: { return 60; }
    case 7: { return 70; }
    case 8: { return 80; }
    case 9: { return 90; }
    case 10: { return 100; }
    case 11: { return 115; }
    case 12: { return 130; }
    case 13: { return 150; }
    case 14: { return 175; }
    case 15: { return 200; }
    case 16: { return 230; }
    case 17: { return 260; }
    case 18: { return 300; }
    case 19: { return 350; }
    case 20: { return 400; }
    case 21: { return 460; }
    case 22: { return 520; }
    case 23: { return 600; }
    case 24: { return 700; }
    case 25: { return 800; }
    case 26: { return 920; }
    case 27: { return 1040; }
    case 28: { return 1200; }
    case 29: { return 1400; }
    case 30: { return 1600; }
    case 31: { return 1840; }
    case 32: { return 2080; }
    case 33: { return 2400; }
    case 34: { return 2800; }
    case 35: { return 3200; }
    case 36: { return 3680; }
    case 37: { return 4160; }
    case 38: { return 4800; }
    case 39: { return 5600; }
    case 40: { return 6400; }
    case 41: { return 7360; }
    case 42: { return 8320; }
    case 43: { return 9600; }
    case 44: { return 11200; }
    case 45: { return 12800; }
    case 46: { return 14720; }
    case 47: { return 16640; }
    case 48: { return 19200; }
    case 49: { return 22400; }
    case 50: { return 25600; }
    case 51: { return 29440; }
    case 52: { return 33280; }
    case 53: { return 38400; }
    case 54: { return 44800; }
    case 55: { return 51200; }
    case 56: { return 58880; }
    case 57: { return 66560; }
    case 58: { return 76800; }
    case 59: { return 89600; }
    case 60: { return 102400; }
    default: break;
  } // return carrying capacity
  return 102400;
} // fnMaxCarry()

void fnEncumbered(int nAmount,int bDelay=FALSE)
{ // PURPOSE: Lock the player into place until unencumbered
  object oMe=OBJECT_SELF;
  location lLoc=GetLocation(oMe);
  location lSaved=GetLocalLocation(oMe,"lEncumbered");
  int nWeight=(GetWeight(oMe)/10);
  int nMaxCarry=fnMaxCarry(oMe);
  int bEncumbered=GetLocalInt(oMe,"bEncumbered");
  float fD;
  effect eE;
  if (!bEncumbered||bDelay)
  { // okay
  //SendMessageToPC(oMe,"Weight:"+IntToString(nWeight)+" Capacity:"+IntToString(nMaxCarry));
  if (nMaxCarry<nWeight)
  { // encumbered
    eE=EffectMovementSpeedDecrease(99);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eE,oMe,6.1);
    if (!bEncumbered)
    { // save info
      SendMessageToPC(oMe,"You are carrying "+IntToString(nAmount)+" more pounds of weight than your maximum.  You cannot move.  Drop some items.");
      SetLocalLocation(oMe,"lEncumbered",lLoc);
      SetLocalInt(oMe,"bEncumbered",TRUE);
    } // save info
    else
    { // check for movement
      fD=GetDistanceBetweenLocations(lSaved,lLoc);
      if (fD>1.5)
      { // too far
        SendMessageToPC(oMe,"You are carrying too much weight and cannot move.");
        AssignCommand(oMe,JumpToLocation(lSaved));
      } // too far
    } // check for movement
    DelayCommand(6.0,fnEncumbered(nAmount,TRUE));
  } // encumbered
  else
  { // not encumbered
    DeleteLocalLocation(oMe,"lEncumbered");
    DeleteLocalInt(oMe,"bEncumbered");
  } // not encumbered
 } // okay
} // fnEncumbered()

void fnCheckEncumberance(object oPC)
{ // check encumberance
  int nWeight;
  int nN;
  if (GetIsPC(oPC))
    { // check encumbrance
      nWeight=(GetWeight(oPC)/10);
      nN=fnMaxCarry(oPC);
      if (nWeight>nN) AssignCommand(oPC,fnEncumbered(nWeight-nN));
    } // check encumbrance
} // fnCheckEncumberance()

int fnGetLeastValuableCoin(object oPC,int nCurrency=1)
{ // PURPOSE: Cause the NPC to spend least valuable coins first
  int nLeast=9999999;
  int nN;
  string sS;
  int nV;
  int nRet=0;
  object oMod=GetModule();
  nN=1;
  sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
  while(GetStringLength(sS)>0)
  { // check values
    nV=GetCoins(oPC,sS,nCurrency);
    if (nV>0)
    { // has this coin
      nV=GetCoinValue(sS,nCurrency);
      if (nV<nLeast)
      { // new least
        nLeast=nV;
        nRet=nN;
      } // new least
    } // has this coin
    nN++;
    sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
  } // check values
  return nRet;
} // fnGetLeastValuableCoin()

////////////////////////////
// F U N C T I O N S
////////////////////////////

////////////////
void AddCoinType(string sName,string sAbbreviation, int nValue, string sResRef, int nCurrency=1)
{ // PURPOSE: To Add coin type and currency information for use in the module
  object oMod=GetModule();
  int nN=fnCheckIfCoinTypeExists(sName,sAbbreviation,nValue,sResRef,nCurrency);
  string sS;
  if (nN==-1)
  { // error = resref in use
    SendMessageToPC(GetFirstPC(),"ERROR npcact_h_money AddCoinType(): ResRef '"+sResRef+"' for coin type is already in use by another coin.");
  } // error = restef in use
  else if (nN>0)
  { // error = coin type already defined
    SendMessageToPC(GetFirstPC(),"ERROR npcact_h_money AddCoinType(): Coin type is already defined '"+sName+"' abbreviation '"+sAbbreviation+"' Currency="+IntToString(nCurrency));
  } // error = coin type already defined
  nN=1;
  sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
  while(GetStringLength(sS)>0)
  { // find next coin append location
    nN++;
    sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
  } // find next coin append location
  SetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN),sName);
  SetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN),sAbbreviation);
  SetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN),nValue);
  SetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN),sResRef);
  SetLocalInt(oMod,"nMSCoin_R_"+sResRef+"_"+IntToString(nCurrency),nN);
  SetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency),nN);
  PrintString("npcact_h_money: Coin Added - "+sName+","+sAbbreviation+","+IntToString(nValue)+","+sResRef+"  Currency="+IntToString(nCurrency));
} // AddCoinType()


////////////////
void SetGoldConversionType(int nValue, int nCurrency=1)
{ // PURPOSE: This will set the conversion rates for Bioware gold from GetGold()
  object oMod=GetModule();
  SetLocalInt(oMod,"nMSCoinGoldValue",nValue);
  SetLocalInt(oMod,"nMSCoinGoldCurrency",nCurrency);
} // SetGoldConversionType()


////////////////
void SetMasterCoinItem(string sTag)
{ // PURPOSE: Will set what item on inventory should be used to track money
  // if it is DB then the money will be tracked on the database
  SetLocalString(GetModule(),"sMSCoinMasterTag",sTag);
} // SetMasterCoinItem()


////////////////
void PricingMultiple(int nMultiple)
{ // PURPOSE: Sets the pricing multiplier used when calculating prices from
  // the results returned by GetGoldPieceValue()
  SetLocalInt(GetModule(),"nMSPricingMultiple",nMultiple);
} // PricingMultiple()


////////////////
void SetPrice(string sResRef,int nPrice)
{ // PURPOSE: Set a specific price for an item
  SetLocalInt(GetModule(),"nMSPrice_"+sResRef,nPrice);
} // SetPrice()


////////////////
int GetCoinValue(string sAbbreviation,int nCurrency=1)
{ // PURPOSE: Return the value of a coin expressed in MUs
  int nRet=0;
  int nN;
  object oMod=GetModule();
  nN=GetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
  if (nN>0)
  { // coin exists
    nRet=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
  } // coin exists
  return nRet;
} // GetCoinValue()


///////////
int GetCoins(object oObject,string sAbbreviation="ANY",int nCurrency=1,int bIncludeBank=FALSE)
{ // PURPOSE: To return how many of a type of coin the object has
  int nRet=0;
  object oMod=GetModule();
  string sTag=GetLocalString(oMod,"sMSCoinMasterTag");
  int nN;
  string sS;
  object oOb;
  string sPID;
  if (sTag=="DB")
  { // database
    oOb=oObject;
    if (GetIsPC(oObject)) { sPID=fnGeneratePID(oObject); oOb=oMod; }
    if (sAbbreviation=="ANY")
    { // all coins
      nN=1;
      sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
      while(GetStringLength(sS)>0)
      { // look at all coins
        nRet=nRet+NPCGetPersistentInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,DB_TABLE);
        if (bIncludeBank)
        { // banking
          nRet=nRet+NPCGetPersistentInt(oOb,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,DB_TABLE);
        } // banking
        nN++;
        sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
      } // look at all coins
    } // all coins
    else
    { // specific coin
      nN=GetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
      if (nN>0)
      { // coin exists
        nRet=NPCGetPersistentInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,DB_TABLE);
        if (bIncludeBank)
        { // banking
          nRet=nRet+NPCGetPersistentInt(oOb,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,DB_TABLE);
        } // banking
      } // coin exists
    } // specific coin
  } // database
  else
  { // item with token storage system
    oOb=GetItemPossessedBy(oObject,sTag);
    if (oOb!=OBJECT_INVALID)
    { // object found
      if (sAbbreviation=="ANY")
      { // all coins
        nN=1;
        sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
        while(GetStringLength(sS)>0)
        { // look at all coins
          nRet=nRet+GetLocalInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
          if (bIncludeBank)
          { // banking
            nRet=nRet+GetLocalInt(oOb,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nN));
          } // banking
          nN++;
          sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
        } // look at all coins
      } // all coins
      else
      { // specific coin
        nN=GetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
        if (nN>0)
        { // coin defined
          nRet=GetLocalInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
          if (bIncludeBank)
          { // banking
            nRet=nRet+GetLocalInt(oOb,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nN));
          } // banking
        } // coin defined
      } // specific coin
    } // object found
    else
    { // error - Master coin Tag improperly defined or PC does not have required item
      SendMessageToPC(oObject,"ERROR: npcact_h_money GetCoins(): Either tag '"+sTag+"' is not properly defined with SetMasterCoinItem() or you do not possess the required object in your inventory!");
    } // error - Master coin Tag improperly defined or PC does not have required item
  } // item with token storage system
  return nRet;
} // GetCoins()


/////////
int GetWealth(object oObject,int nCurrency=1,int bIncludeBank=FALSE)
{ // PURPOSE: To return the wealth of the object expressed in MUs (monetary units)
  int nRet=0;
  int nN;
  int nV;
  string sS;
  object oMod=GetModule();
  nN=1;
  sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
  while(GetStringLength(sS)>0)
  { // count coins
    nV=GetCoins(oObject,sS,nCurrency,bIncludeBank);
    if (nV>0)
    { // has coins
      nV=nV*GetCoinValue(sS,nCurrency);
      nRet=nRet+nV;
    } // has coins
    nN++;
    sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
  } // count coins
  if (nN==1||nCurrency==0) { // custom monetary system for the currency not defined
    nRet=GetGold(oObject);
    if (nRet==0&&GetObjectType(oObject)==OBJECT_TYPE_CREATURE) { // check for gold items
      oMod=GetItemPossessedBy(oObject,"NW_IT_GOLD001");
      if (oMod!=OBJECT_INVALID) nRet=GetItemStackSize(oMod);
    } // check for gold items
  } // custom monetary system for the currency not defined
  return nRet;
} // GetWealth()


////////////
void GiveCoins(object oObject,int nAmount,string sAbbreviation="ANY",int nCurrency=1)
{ // PURPOSE: To give specific coins or to give nAmount MUs worth of coins
  object oMod=GetModule();
  object oMaster;
  object oItem;
  int nN;
  string sS;
  string sRes;
  object oOb;
  int nV;
  int nF;
  int nA;
  int nRemaining;
  string sPID;
  //SendMessageToPC(GetFirstPC(),"GiveCoins("+GetName(oObject)+","+IntToString(nAmount)+","+sAbbreviation+")");
  if (sAbbreviation=="ANY"&&nCurrency>0)
  { // give mix of coins to total up to MUs
    nRemaining=nAmount;
    nF=1;
    while(nRemaining>0&&nF!=0)
    { // give appropriate coins
      nF=fnFindBestCoinFit(nRemaining,nCurrency);
      if (nF!=0)
      { // give that coin type
        nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nF));
        nA=nRemaining/nV;
        nRemaining=nRemaining-(nA*nV);
        sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nF));
        GiveCoins(oObject,nA,sS,nCurrency);
      } // give that coin type
    } // give appropriate coins
  } // give mix of coins to total up to MUs
  else if (nCurrency>0)
  { // give nAmount of a specific coin type
    nN=GetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
    if (nN>0)
    { // coin type exists
      sRes=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
      if (GetStringLength(sRes)>0)
      { // resref defined
        oItem=GetItemPossessedBy(oObject,sRes);
        if (oItem==OBJECT_INVALID) { oItem=CreateItemOnObject(sRes,oObject);
                 SetLocalObject(oItem,"oOwner",oObject); }
        if (oItem!=OBJECT_INVALID)
        { // item created
          nV=GetLocalInt(oItem,"nCoins");
          nV=nV+nAmount;
          SetLocalInt(oItem,"nCoins",nV);
          if(GetLocalInt(oMod,"nMSCoins1LB")>0)
          { // track weight
            DetermineCoinWeight(oItem,GetLocalInt(oMod,"nMSCoins1LB"),GetLocalInt(oMod,"bMSCoinEncumberance"));
          } // track weight
          sRes=GetLocalString(oMod,"sMSCoinMasterTag");
          if (sRes=="DB")
          { // database
            oOb=oObject;
            if (GetIsPC(oObject)) { sPID=fnGeneratePID(oObject); oOb=oMod; }
            nV=NPCGetPersistentInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,DB_TABLE);
            nV=nV+nAmount;
            NPCSetPersistentInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,nV,0,DB_TABLE);
            sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
            SendMessageToPC(oObject,"Acquired "+IntToString(nAmount)+" "+sS+". You are carrying "+IntToString(nV)+".");
          } // database
          else
          { // local token system
            oMaster=GetItemPossessedBy(oObject,sRes);
            if (oMaster!=OBJECT_INVALID)
            { // item exists
              nV=GetLocalInt(oMaster,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
              nV=nV+nAmount;
              SetLocalInt(oMaster,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN),nV);
              sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
              SendMessageToPC(oObject,"Acquired "+IntToString(nAmount)+" "+sS+". You are carrying "+IntToString(nV)+".");
            } // item exists
            else
            { // error - master token item missing
              SendMessageToPC(oObject,"ERROR: npcact_h_money GiveCoins(): Either tag '"+sRes+"' is not properly defined with SetMasterCoinItem() or you do not possess the required object in your inventory!");
            } // error - master token item missing
          } // local token system
        } // item created
        else
        { // error - cannot create item
          SendMessageToPC(oObject,"ERROR - npcact_h_money GiveCoins(): Cannot create coin item with resref '"+sRes+"' for coin abbreviation type '"+sAbbreviation+"' and currency number="+IntToString(nCurrency)+"!");
        } // error - cannot create item
      } // resref defined
    } // coin type exists
  } // give nAmount of a specific coin type
  else
  { // custom monetary system not defined
    nV=GetObjectType(oObject);
    if (nV==OBJECT_TYPE_CREATURE||GetIsPC(oObject)==TRUE)
    { // give gold to creature
      GiveGoldToCreature(oObject,nAmount);
    } // give gold to creature
    else if (nV==OBJECT_TYPE_PLACEABLE)
    {// give gold to placeable
     oItem=CreateItemOnObject("nw_it_gold001",oObject,nAmount);
    }// give gold to placeable
    else if (nV==OBJECT_TYPE_STORE)
    {// give gold to store
     nV=GetStoreGold(oObject);
     nV=nV+nAmount;
     SetStoreGold(oObject,nV);
    }// give gold to store
  } // custom monetary system not defined
  //SendMessageToPC(GetFirstPC(),"Exit GiveCoins()");
} // GiveCoins()


////////////
void DetermineCoinWeight(object oObject,int nCoin1LB=50,int bEncumbrance=FALSE)
{ // PURPOSE: To handle coin weight on an object
  itemproperty iprop;
  int nCoins;
  struct stWeightEffects stWt;
  int nWeight;
  int nN;
  object oPC=GetItemPossessor(oObject);
  //SendMessageToPC(oPC,"Determining coin weight");
  if (oObject==GetModule())
  { // encumberance and weight settings
    SetLocalInt(GetModule(),"nMSCoins1LB",nCoin1LB);
    SetLocalInt(GetModule(),"bMSCoinEncumberance",bEncumbrance);
  } // encumberance and weight settings
  else if (GetObjectType(oObject)==OBJECT_TYPE_ITEM)
  { // calculate weight
    nCoins=GetLocalInt(oObject,"nCoins");
    IPRemoveAllItemProperties(oObject,DURATION_TYPE_PERMANENT);
    IPRemoveAllItemProperties(oObject,DURATION_TYPE_TEMPORARY);
    iprop=ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
    IPSafeAddItemProperty(oObject,iprop);
    if (nCoins>=nCoin1LB)
    { // weight should be tracked
      nWeight=nCoins/nCoin1LB;
      //SendMessageToPC(oPC,"Weight:"+IntToString(nWeight)+" lbs");
      if (nWeight>10)
      { // break the pile up
        DelayCommand(0.1,SplitCoins(oPC,oObject,nCoin1LB*10));
      } // break the pile up
      else
      { // valid weight
        stWt=fnDetermineWeightEffects(nWeight);
        iprop=ItemPropertyWeightIncrease(stWt.nWeightInc);
        DelayCommand(0.3,IPSafeAddItemProperty(oObject,iprop));
        iprop=ItemPropertyWeightReduction(stWt.nWeightRed);
        DelayCommand(0.3,IPSafeAddItemProperty(oObject,iprop));
      } // valid weight
    } // weight should be tracked
    if (bEncumbrance&&GetIsPC(oPC)) DelayCommand(0.4,fnCheckEncumberance(oPC));
  } // calculate weight
} // DetermineCoinWeight()


////////////
void SplitCoins(object oObject,object oStartingPile,int nAmountToSplit)
{ // PURPOSE: Split coin object oStartingPile on oObject into two piles
  // where at least one is of size nAmountToSplit
  int nN;
  object oItem;
  int nV;
  object oMod=GetModule();
  //SendMessageToPC(oObject,"Splitting a coin pile with new pile being "+IntToString(nAmountToSplit)+".");
  if (oStartingPile!=OBJECT_INVALID)
  { // valid
    nN=GetLocalInt(oStartingPile,"nCoins");
    if (nN>nAmountToSplit)
    { // valid split request
      oItem=CreateItemOnObject(GetResRef(oStartingPile),oObject);
      SetLocalObject(oItem,"oOwner",oObject);
      SetLocalInt(oItem,"nCoins",nAmountToSplit);
      nN=nN-nAmountToSplit;
      SetLocalInt(oStartingPile,"nCoins",nN);
      if(GetLocalInt(oMod,"nMSCoins1LB")>0)
      { // track weight
        DelayCommand(0.1,DetermineCoinWeight(oItem,GetLocalInt(oMod,"nMSCoins1LB"),GetLocalInt(oMod,"bMSCoinEncumberance")));
        DelayCommand(0.1,DetermineCoinWeight(oStartingPile,GetLocalInt(oMod,"nMSCoins1LB"),GetLocalInt(oMod,"bMSCoinEncumberance")));
      } // track weight
    } // valid split request
  } // valid
} // SplitCoins()

void fnDeletePiles(object oTarget,string sS)
{ // PURPOSE: Get rid of coin piles
  object oItem=GetItemPossessedBy(oTarget,sS);
  if (oItem!=OBJECT_INVALID)
  { // delete
    DestroyObject(oItem);
    DelayCommand(0.1,fnDeletePiles(oTarget,sS));
  } // delete
} // fnDeletePiles()

void TakeCoins(object oTarget,int nAmount,string sAbbreviation="ANY",int nCurrency=1,
               int bDestroy=FALSE,int bSilent=FALSE)
{ // PURPOSE: To Take coins from oTarget.
  object oMe=OBJECT_SELF;
  string sPID;
  string sS;
  int nN;
  int nH;
  int nV;
  object oItem;
  int nT;
  int nR;
  int nRemaining=nAmount;
  string sName;
  object oMod=GetModule();
  if (GetIsPC(oTarget)) sPID=fnGeneratePID(oTarget);
  sS=GetLocalString(oMod,"sMSCoinAbbr1_1");
  //SendMessageToPC(GetFirstPC(),"TakeCoins("+GetName(oTarget)+","+IntToString(nAmount)+")");
  if (sAbbreviation=="ANY"&&GetStringLength(sS)>0&&nCurrency!=0)
  { // any coin type - currency defined
    if (GetWealth(oTarget,nCurrency)>=nAmount)
    { // the target has sufficient wealth
      //SendMessageToPC(GetFirstPC()," Has sufficient wealth");
      nN=fnGetLeastValuableCoin(oTarget,nCurrency);
      if (nN>0)
      { // coin type found
        sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
        nV=GetCoinValue(sS,nCurrency);
        nH=GetCoins(oTarget,sS,nCurrency);
        sName=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
      } // coin type found
     if ((nV*nH)>nRemaining)
     { // worth more than owe
      //SendMessageToPC(GetFirstPC(),"  Worth more than");
      nT=nRemaining/nV;
      if (nT<1) nT=1;
      nR=(nT*nV)-nRemaining;
      if (!bDestroy) { DelayCommand(0.1,GiveCoins(oMe,nRemaining,"ANY",nCurrency)); }
      if (GetIsPC(oTarget)&&!bSilent) SendMessageToPC(oTarget,"Lost "+IntToString(nT)+" "+sName+".");
      sS=GetLocalString(oMod,"sMSCoinMasterTag");
      if (sS=="DB")
      { // database
        NPCSetPersistentInt(oMod,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,(nH-nT));
      } // database
      else
      { // token
        oItem=GetItemPossessedBy(oTarget,sS);
        SetLocalInt(oItem,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN),(nH-nT));
      } // token
      sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
      oItem=GetItemPossessedBy(oTarget,sS);
      DelayCommand(0.1,GiveCoins(oTarget,nR,"ANY",nCurrency));
      while(nT>0&&oItem!=OBJECT_INVALID)
      { // reduce coin amounts
        nR=GetLocalInt(oItem,"nCoins");
        if (nR>nT)
        { // finish it
          nR=nR-nT;
          nT=0;
          SetLocalInt(oItem,"nCoins",nR);
          nR=GetLocalInt(oMod,"nMSCoins1LB");
          if (nR>0)
          { // adjust weight
            DelayCommand(0.2,DetermineCoinWeight(oItem,nR,GetLocalInt(oMod,"bMSCoinEncumberance")));
          } // adjust weight
        } // finish it
        else
        { // less
          nT=nT-nR;
          DestroyObject(oItem);
          oItem=GetItemPossessedBy(oTarget,sS);
        } // less
      } // reduce coin amounts
     } // worth more than owe
     else
     { // worth equal to or less than owe
      //SendMessageToPC(GetFirstPC(),"  Worth equal to or less");
      nRemaining=nRemaining-(nV*nH);
      if (GetIsPC(oTarget)&&!bSilent) SendMessageToPC(oTarget,"Lost "+IntToString(nH)+" "+sName+".");
      if (!bDestroy) { DelayCommand(0.1,GiveCoins(oMe,nH,sS,nCurrency)); }
      sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
      //SendMessageToPC(GetFirstPC(),"  begin while delete piles");
      fnDeletePiles(oTarget,sS);
      //SendMessageToPC(GetFirstPC(),"  end while delete piles");
      sS=GetLocalString(oMod,"sMSCoinMasterTag");
      if (sS=="DB")
      { // database
        NPCSetPersistentInt(oMod,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,0);
      } // database
      else
      { // local token item
        oItem=GetItemPossessedBy(oTarget,sS);
        DeleteLocalInt(oItem,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
      } // local token item
      //SendMessageToPC(GetFirstPC(),"  Remaining:"+IntToString(nRemaining)+" recursion");
      if (nRemaining>0) DelayCommand(0.3,TakeCoins(oTarget,nRemaining,sAbbreviation,nCurrency,bDestroy,bSilent));
     } // worth equal to or less than owe
    } // the target has sufficient wealth
  } // any coin type - currency defined
  else if (GetStringLength(sS)>0&&nCurrency!=0)
  { // take a specific coin type
    nH=GetCoins(oTarget,sAbbreviation,nCurrency);
    nN=GetLocalInt(oMod,"sMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
    sName=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
    if (nH>=nAmount)
    { // has amount of coins specified
      nT=nAmount;
      nH=nH-nAmount;
      if (GetIsPC(oTarget)&&!bSilent) SendMessageToPC(oTarget,"Lost "+IntToString(nAmount)+" "+sName+".");
      sS=GetLocalString(oMod,"sMSCoinMasterTag");
      if (sS=="DB")
      { // database
        NPCSetPersistentInt(oMod,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,nH);
      } // database
      else
      { // local token item
        oItem=GetItemPossessedBy(oTarget,sS);
        if (nH==0) DeleteLocalInt(oItem,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
        else { SetLocalInt(oItem,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN),nH); }
      } // local token item
      sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
      oItem=GetItemPossessedBy(oTarget,sS);
      while(nT>0&&oItem!=OBJECT_INVALID)
      { // remove coins and handle weight
        nH=GetLocalInt(oItem,"nCoins");
        if (nH>nT)
        { // has more than enough
          nH=nH-nT;
          SetLocalInt(oItem,"nCoins",nH);
          nR=GetLocalInt(oMod,"nMSCoins1LB");
          if (nR>0)
          { // adjust weight
            DetermineCoinWeight(oItem,nR,GetLocalInt(oMod,"bMSCoinEncumberance"));
          } // adjust weight
        } // has more than enough
        else
        { // not enough
          DestroyObject(oItem);
          nT=nT-nH;
          oItem=GetItemPossessedBy(oTarget,sS);
        } // not enough
      } // remove coins and handle weight
    } // has amount of coins specified
    else
    {
      if (GetIsPC(oTarget)) SendMessageToPC(oTarget,GetName(oMe)+" tried to take more "+sName+" than you have.");
      if (GetIsPC(oMe)) SendMessageToPC(oMe,"You tried to take more "+sName+" from "+GetName(oTarget)+" than they have.");
    }
  } // take a specific coin type
  else
  { // Custom Monetary System not defined - use Bioware function
    AssignCommand(oMe,TakeGoldFromCreature(nAmount,oTarget,bDestroy));
  } // Custom Monetary System not defined - use Bioware function
  //SendMessageToPC(GetFirstPC(),"Exit TakeCoins()");
} // TakeCoins()


/////////
/*void TakeCoins(object oTarget,int nAmount,string sAbbreviation="ANY",int nCurrency=1,
               int bDestroy=FALSE,int bSilent=FALSE)
{ // PURPOSE: To Take coins from oTarget.
  object oMe=OBJECT_SELF;
  int nRemaining=nAmount;
  int nN;
  int nH;
  int nV;
  string sS;
  object oMod=GetModule();
  object oItem;
  string sPID;
  int nT;
  int nR;
  string sName;
  if (GetIsPC(oTarget)) sPID=fnGeneratePID(oTarget);
  sS=GetLocalString(oMod,"sMSCoinAbbr1_1");
  if (sAbbreviation=="ANY"&&GetStringLength(sS)>0&&nCurrency!=0)
  { // take any coin
    if (GetWealth(oTarget,nCurrency)>=nAmount)
    { // target has sufficient
      while(nRemaining>0)
      { // take coins
        nN=fnGetLeastValuableCoin(oTarget,nCurrency);
        if (nN>0)
        { // coin type found
          sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
          nV=GetCoinValue(sS,nCurrency);
          nH=GetCoins(oTarget,sS,nCurrency);
          sName=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
          if ((nV*nH)>nRemaining)
          { // coins are worth more than what is owed
            nT=nRemaining/nV;
            if (nT<1) nT=1;
            nR=(nT*nV)-nRemaining;
            nRemaining=0;
            if (!bDestroy) { GiveCoins(oMe,nRemaining,"ANY",nCurrency); }
            if (GetIsPC(oTarget)&&!bSilent) SendMessageToPC(oTarget,"Lost "+IntToString(nT)+" "+sName+".");
            sS=GetLocalString(oMod,"sMSCoinMasterTag");
            if (sS=="DB")
            { // database
              NPCSetPersistentInt(oMod,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,(nH-nT));
            } // database
            else
            { // token
              oItem=GetItemPossessedBy(oTarget,sS);
              SetLocalInt(oItem,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN),(nH-nT));
            } // token
            sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
            oItem=GetItemPossessedBy(oTarget,sS);
            GiveCoins(oTarget,nR,"ANY",nCurrency);
            while(nT>0&&oItem!=OBJECT_INVALID)
            { // reduce coin amounts
              nR=GetLocalInt(oItem,"nCoins");
              if (nR>nT)
              { // finish it
                nR=nR-nT;
                nT=0;
                SetLocalInt(oItem,"nCoins",nR);
                nR=GetLocalInt(oMod,"nMSCoins1LB");
                if (nR>0)
                { // adjust weight
                  DetermineCoinWeight(oItem,nR,GetLocalInt(oMod,"bMSCoinEncumberance"));
                } // adjust weight
              } // finish it
              else
              { // less
                nT=nT-nR;
                DelayCommand(0.2,DestroyObject(oItem));
              } // less
            } // reduce coin amounts
          } // coins are worth more than what is owed
          else
          { // is worth less
            nRemaining=nRemaining-(nV*nH);
            if (GetIsPC(oTarget)&&!bSilent) SendMessageToPC(oTarget,"Lost "+IntToString(nH)+" "+sName+".");
            if (!bDestroy) { GiveCoins(oMe,nH,sS,nCurrency); }
            sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
            oItem=GetItemPossessedBy(oTarget,sS);
            while(oItem!=OBJECT_INVALID)
            { // delete these coin piles
              DelayCommand(0.2,DestroyObject(oItem));
              oItem=GetItemPossessedBy(oTarget,sS);
            } // delete these coin piles
            sS=GetLocalString(oMod,"sMSCoinMasterTag");
            if (sS=="DB")
            { // database
              NPCSetPersistentInt(oMod,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,0);
            } // database
            else
            { // local token item
              oItem=GetItemPossessedBy(oTarget,sS);
              DeleteLocalInt(oItem,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
            } // local token item
          } // is worth less
        } // coin type found
      } // take coins
    } // target has sufficient
  } // take any coin
  else if (GetStringLength(sS)>0&&nCurrency!=0)
  { // take specific coin
    nH=GetCoins(oTarget,sAbbreviation,nCurrency);
    nN=GetLocalInt(oMod,"sMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
    sName=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
    if (nH>=nAmount)
    { // has amount of coins specified
      nT=nAmount;
      nH=nH-nAmount;
      if (GetIsPC(oTarget)&&!bSilent) SendMessageToPC(oTarget,"Lost "+IntToString(nAmount)+" "+sName+".");
      sS=GetLocalString(oMod,"sMSCoinMasterTag");
      if (sS=="DB")
      { // database
        NPCSetPersistentInt(oMod,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,nH);
      } // database
      else
      { // local token item
        oItem=GetItemPossessedBy(oTarget,sS);
        if (nH==0) DeleteLocalInt(oItem,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
        else { SetLocalInt(oItem,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN),nH); }
      } // local token item
      sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
      oItem=GetItemPossessedBy(oTarget,sS);
      while(nT>0&&oItem!=OBJECT_INVALID)
      { // remove coins and handle weight
        nH=GetLocalInt(oItem,"nCoins");
        if (nH>nT)
        { // has more than enough
          nH=nH-nT;
          SetLocalInt(oItem,"nCoins",nH);
          nR=GetLocalInt(oMod,"nMSCoins1LB");
          if (nR>0)
          { // adjust weight
            DetermineCoinWeight(oItem,nR,GetLocalInt(oMod,"bMSCoinEncumberance"));
          } // adjust weight
        } // has more than enough
        else
        { // not enough
          DestroyObject(oItem);
          nT=nT-nH;
          oItem=GetItemPossessedBy(oTarget,sS);
        } // not enough
      } // remove coins and handle weight
    } // has amount of coins specified
    else
    {
      if (GetIsPC(oTarget)) SendMessageToPC(oTarget,GetName(oMe)+" tried to take more "+sName+" than you have.");
      if (GetIsPC(oMe)) SendMessageToPC(oMe,"You tried to take more "+sName+" from "+GetName(oTarget)+" than they have.");
    }
  } // take specific coin
  else
  { // custom monetary system not defined
    AssignCommand(oMe,TakeGoldFromCreature(nAmount,oTarget,bDestroy));
  } // custom monetary system not defined
} // TakeCoins()  */


//////////////////
int ConvertCoins(int nAmount,string sAbbreviation,int nMUValue, int nCurrency=1,int nPercentage=100)
{ // PURPOSE: To provide a means to convert between currencies
  object oMod=GetModule();
  int nV;
  int nN;
  float fF;
  int nRet=0;
  nN=GetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
  if (nN>0)
  { // found coin type
    nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
    nV=nV*nAmount;
    if (nV>0)
    { // value determined
      nV=nV/nMUValue;
      if (nV>0)
      { // there is some value
        fF=IntToFloat(nPercentage)/100.0;
        fF=fF*IntToFloat(nV);
        nRet=FloatToInt(fF);
      } // there is some value
    } // value determined
  } // found coin type
  return nRet;
} // ConvertCoins()


///////////////////
void DepositCoins(object oObject, int nAmount,string sAbbreviation="ANY",int nCurrency=1)
{ // PURPOSE: Deposit coins into the bank
  object oMod=GetModule();
  string sMaster=GetLocalString(oMod,"sMSCoinMasterTag");
  int nN;
  string sS;
  int nV;
  int nH;
  int nR;
  int nLV;
  string sPID;
  object oItem;
  int nWealth;
  if (GetIsPC(oObject)) sPID=fnGeneratePID(oObject);
  nLV=fnLeastValuableCoin(nCurrency);
  nWealth=GetWealth(oObject,nCurrency);
  if (sAbbreviation=="ANY")
  { // mixture of coins
    nH=nWealth;
    if (nR<=nH)
    { // valid amount
      TakeCoins(oObject,nAmount,"ANY",nCurrency,TRUE);
      nN=nLV;
      nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
      if (nN>0)
      { // store least valuable coin in bank
        if (sMaster=="DB")
        { // database
          nH=NPCGetPersistentInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID);
          nH=nH+(nAmount/nV);
          NPCSetPersistentInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,nH,0,DB_TABLE);
        } // database
        else
        { // non-database
          oItem=GetItemPossessedBy(oObject,sMaster);
          if (oItem!=OBJECT_INVALID)
          { // token item found
            nH=GetLocalInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nN));
            nH=nH+(nAmount/nV);
            SetLocalInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nN),nH);
          } // token item found
        } // non-database
      } // store least valuable coin in bank
    } // valid amount
  } // mixture of coins
  else
  { // specific coin type
    nN=GetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
    if (nN>0)
    { // abbreviation matches known coin
      nV=GetCoinValue(sAbbreviation,nCurrency);
      nR=nV*nAmount;
      nV=nWealth/nV;
      if (nV>=nAmount)
      { // have enough
        if (sMaster=="DB")
        { // database
          nH=NPCGetPersistentInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nLV)+sPID);
          nH=nH+nR;
          NPCSetPersistentInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nLV)+sPID,nH,0,DB_TABLE);
        } // database
        else
        { // non-database
          oItem=GetItemPossessedBy(oObject,sMaster);
          if (oItem!=OBJECT_INVALID)
          { // token item found
            nH=GetLocalInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nLV));
            nH=nH+nR;
            SetLocalInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nLV),nH);
          } // token item found
         } // non-database
         TakeCoins(oObject,nAmount,sAbbreviation,nCurrency,TRUE);
       } // have enough
    } // abbreviation matches known coin
  } // specific coin type
} // DepositCoins()


///////////////////
void WithdrawCoins(object oObject, int nAmount,string sAbbreviation="ANY",int nCurrency=1)
{ // PURPOSE: Withdraw coins from the bank
  object oMod=GetModule();
  string sMaster=GetLocalString(oMod,"sMSCoinMasterTag");
  int nN;
  string sS;
  int nV;
  int nH;
  int nR;
  string sPID;
  int nCV;
  object oItem;
  int nLV=fnLeastValuableCoin(nCurrency);
  if (GetIsPC(oObject)) sPID=fnGeneratePID(oObject);
  nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nLV));
  nH=GetWealth(oObject,nCurrency,TRUE)-GetWealth(oObject,nCurrency);
  if (sAbbreviation=="ANY")
  { // withdraw any coins
    if (nH>=nAmount)
    { // have that much wealth
      nH=nH-(nAmount/nV);
      if (sMaster=="DB")
      { // database
        NPCSetPersistentInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nLV)+sPID,nH,0,DB_TABLE);
      } // database
      else
      { // non-database
        oItem=GetItemPossessedBy(oObject,sMaster);
        if (oItem!=OBJECT_INVALID)
        { // token item exists
          SetLocalInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nLV),nH);
        } // token item exists
      } // non-database
      GiveCoins(oObject,nAmount,"ANY",nCurrency);
    } // have that much wealth
  } // withdraw any coins
  else
  { // withdraw specific
    nN=GetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
    if (nN>0)
    { // coin type exists
      nCV=GetCoinValue(sAbbreviation,nCurrency);
      nR=nCV*nAmount;
      if (nH>=nR)
      { // has that amount in bank
        nH=nH-(nR/nV);
        if (sMaster=="DB")
        { // database
          NPCSetPersistentInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nLV)+sPID,nH,0,DB_TABLE);
        } // database
        else
        { // non-database
          oItem=GetItemPossessedBy(oObject,sMaster);
          if (oItem!=OBJECT_INVALID)
          { // token item exists
            SetLocalInt(oMod,"nMSBank"+IntToString(nCurrency)+"_"+IntToString(nLV),nH);
          } // token item exists
        } // non-database
        GiveCoins(oObject,nAmount,sAbbreviation,nCurrency);
      } // has that amount in bank
    } // coin type exists
  } // withdraw specific
} // WithdrawCoins()


string GetWealthCarriedString(object oObject,int nCurrency=1,int bAbbreviate=FALSE)
{ // PURPOSE: Return the amount of wealth carried expressed in exact coin quantities
  string sRet="";
  object oMod=GetModule();
  string sMaster=GetLocalString(oMod,"sMSCoinMasterTag");
  object oItem=GetItemPossessedBy(oObject,sMaster);
  string sPID=fnGeneratePID(oObject);
  string sS;
  int nN;
  int nV;
  int nH;
  int nMUS;
  nN=1;
  if (bAbbreviate) sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
  else { sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN)); }
  //SendMessageToPC(oObject,"GWCS: "+IntToString(nN)+" "+sS);
  while(GetStringLength(sS)>0&&nCurrency!=0)
  { // check each coin type
    nH=0;
    nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
    if (sMaster=="DB")
    { // database
      nH=NPCGetPersistentInt(oMod,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,DB_TABLE);
    } // database
    else
    { // non-database
      if (oItem!=OBJECT_INVALID)
      { // token item found
        //SendMessageToPC(oObject,"   item exists");
        nH=GetLocalInt(oItem,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
      } // token item found
    } // non-database
    if (nH>0)
    { // has this coin
      nMUS=nMUS+(nH*nV);
      sRet=sRet+IntToString(nH)+" "+sS+", ";
    } // has this coin
    nN++;
    if (bAbbreviate) sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
    else { sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN)); }
    //SendMessageToPC(oObject,"GWCS: "+IntToString(nN)+" "+sS);
  } // check each coin type
  if (GetStringLength(sRet)>0)
  {
    sRet=GetStringLeft(sRet,GetStringLength(sRet)-2);
    sRet=sRet+". ";
  }
  sRet=sRet+"["+IntToString(nMUS)+" Monetary Units]";
  if (nCurrency==0) sRet=IntToString(GetGold(oObject))+" gold.";
  return sRet;
} // GetWealthCarriedString()


///////////////////
string MoneyToString(int nAmount,int nCurrency=1,int bAbbreviate=TRUE)
{ // PURPOSE: Return the monetary amount expressed as a string
  string sRet;
  int nRemaining=nAmount;
  string sS;
  object oMod=GetModule();
  int nV;
  int nN;
  if (nCurrency!=0)
  { // monetary system defined
  while(nRemaining>0)
  { // build the string
    nN=fnFindBestCoinFit(nRemaining,nCurrency);
    if (nN>0)
    { // coin type found
      nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
      if (bAbbreviate) sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
      else { sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN)); }
      nN=nRemaining/nV;
      nRemaining=nRemaining-(nN*nV);
      sRet=sRet+IntToString(nN)+" "+sS+", ";
    } // coin type found
    else { nRemaining=0; }
  } // build the string
  sRet=GetStringLeft(sRet,GetStringLength(sRet)-2);
  sRet=sRet+".";
  } // monetary system defined.
  else
  { // standard
    if (bAbbreviate) sRet=IntToString(nAmount)+" gp.";
    else { sRet=IntToString(nAmount)+" gold."; }
  } // standard
  return sRet;
} // MoneyToString()


///////////////////
void MergeCoins(object oObject,object oPile1,object oPile2)
{ // PURPOSE: Merge two piles of coins oPile2 will be destroyed
  object oMod=GetModule();
  int nN;
  if (oPile1!=OBJECT_INVALID&&oPile2!=OBJECT_INVALID&&oPile1!=oPile2)
  { // valid piles selected
    if (GetResRef(oPile1)==GetResRef(oPile2))
    { // match
      nN=GetLocalInt(oPile1,"nCoins")+GetLocalInt(oPile2,"nCoins");
      DestroyObject(oPile2);
      SetLocalInt(oPile1,"nCoins",nN);
      if(GetLocalInt(oMod,"nMSCoins1LB")>0) DetermineCoinWeight(oPile1,GetLocalInt(oMod,"nMSCoins1LB"),GetLocalInt(oMod,"bMSCoinEncumberance"));
    } // match
  } // valid piles selected
} // MergeCoins()


///////////////////
void CreateCoins(object oObject,location lLocation,int nAmount,string sAbbreviation="ANY",int nCurrency=1,int bRandom=FALSE)
{ // PURPOSE: Create a pile of coins at specified location
  int nRemaining=nAmount;
  object oMod=GetModule();
  int nN;
  int nV;
  int nR;
  object oItem;
  string sS;
  int nC=0;
  int nA;
  if (GetIsPC(oObject)==FALSE&&nCurrency!=0)
  { // not a PC
    if (oObject!=OBJECT_INVALID&&GetHasInventory(oObject))
    { // create coins in inventory of the object
      if (sAbbreviation!="ANY")
      { // specific coin
        nN=GetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
        if (nN>0)
        { // coin found
          sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
          oItem=CreateItemOnObject(sS,oObject);
          SetLocalInt(oItem,"nCoins",nAmount);
        } // coin found
      } // specific coin
      else
      { // misc coins
        nN=1;
        sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
        while(GetStringLength(sS)>0)
        { // count types
          nC++;
          nN++;
          sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
        } // count types
        nN=0;
        while(nRemaining>0)
        { // create misc coins
          if(bRandom) nN=Random(nC)+1;
          else { nN=fnFindBestCoinFit(nRemaining,nCurrency); }
          nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
          if (nV>nRemaining) { nN=fnFindBestCoinFit(nRemaining,nCurrency);nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN)); }
          nA=nRemaining/nV;
          if (bRandom) nA=Random(nA)+1;
          nRemaining=nRemaining-(nA*nV);
          sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
          oItem=CreateItemOnObject(sS,oObject);
          SetLocalInt(oItem,"nCoins",nA);
        } // create misc coins
      } // misc coins
    } // create coins in inventory of the object
    else
    { // create coins at location
      if (sAbbreviation!="ANY")
      { // specific coin
        nN=GetLocalInt(oMod,"nMSCoin_A_"+sAbbreviation+"_"+IntToString(nCurrency));
        if (nN>0)
        { // coin found
          sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
          oItem=CreateObject(OBJECT_TYPE_ITEM,sS,lLocation);
          SetLocalInt(oItem,"nCoins",nAmount);
        } // coin found
      } // specific coin
      else
      { // misc coins
        nN=1;
        sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
        while(GetStringLength(sS)>0)
        { // count types
          nC++;
          nN++;
          sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
        } // count types
        nN=0;
        while(nRemaining>0)
        { // create misc coins
          if(bRandom) nN=Random(nC)+1;
          else { nN=fnFindBestCoinFit(nRemaining,nCurrency); }
          nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
          if (nV>nRemaining) { nN=fnFindBestCoinFit(nRemaining,nCurrency);nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN)); }
          nA=nRemaining/nV;
          if (bRandom) nA=Random(nA)+1;
          nRemaining=nRemaining-(nA*nV);
          sS=GetLocalString(oMod,"sMSCoinResRef"+IntToString(nCurrency)+"_"+IntToString(nN));
          oItem=CreateObject(OBJECT_TYPE_ITEM,sS,lLocation);
          SetLocalInt(oItem,"nCoins",nA);
        } // create misc coins
      } // misc coins
    } // create coins at location
  } // not a PC
  else if (nCurrency==0&&GetIsPC(oObject)==FALSE)
  { // use standard system
    nV=GetObjectType(oObject);
    if (nV==OBJECT_TYPE_PLACEABLE&&GetHasInventory(oObject)==TRUE)
    { // placeable
      oItem=CreateItemOnObject("nw_it_gold001",oObject,nAmount);
    } // placeable
    else if (nV==OBJECT_TYPE_STORE)
    { // store
      nV=GetStoreGold(oObject);
      nV=nV+nAmount;
      SetStoreGold(oObject,nV);
    } // store
  } // use standard system
} // CreateCoins()

void SetCurrencyName(string sName,int nCurrency=1)
{ // PURPOSE: Assign a name to a currency
  SetLocalString(GetModule(),"sMSCurrencyName"+IntToString(nCurrency),sName);
} // SetCurrencyName()

int UnacquireCoins(object oItem,object oPC=OBJECT_SELF)
{ // PURPOSE: To handle dropping or loss of coins
  int nN=1;
  string sS;
  int nCurrency=GetLocalInt(oItem,"nCurrency");
  object oMod=GetModule();
  int nV;
  int nCoins;
  string sTag=GetLocalString(oMod,"sMSCoinMasterTag");
  object oOb;
  string sPID;
  sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_1");
  while(GetStringLength(sS)>0&&GetLocalInt(oItem,"nCurrency")>0&&(sTag=="DB"||GetItemPossessedBy(oPC,sTag)!=OBJECT_INVALID))
  { // currency valid
    nN=GetLocalInt(oMod,"nMSCoin_R_"+GetResRef(oItem)+"_"+IntToString(nCurrency));
    if (nN>0&&GetLocalObject(oItem,"oOwner")==oPC)
    { // it is a coin type
      DeleteLocalObject(oItem,"oOwner");
      nCoins=GetLocalInt(oItem,"nCoins");
      if (sTag=="DB")
      { // database
        oOb=oPC;
        if (GetIsPC(oPC)) { sPID=fnGeneratePID(oPC); oOb=oMod; }
        nV=NPCGetPersistentInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,DB_TABLE);
        nV=nV-nCoins;
        NPCSetPersistentInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,nV,0,DB_TABLE);
      } // database
      else
      { // object
        oOb=GetItemPossessedBy(oPC,sTag);
        if (oOb!=OBJECT_INVALID)
        { // storage item found
          nV=GetLocalInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
          nV=nV-nCoins;
          SetLocalInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN),nV);
        } // storage item found
        else
        { // error
          SendMessageToPC(oPC,"ERROR: npcact_h_money UnacquireCoins(): Cannot find token item '"+sTag+"'!");
        } // error
      } // object
      return TRUE;
    } // it is a coin type
    nCurrency++;
    sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_1");
  } // currency valid
  return FALSE;
} // UnacquireCoins()

int AcquireCoins(object oItem,object oPC=OBJECT_SELF)
{ // PURPOSE: To handle OnAcquire of coin item
  int nN=1;
  string sS;
  int nCurrency=GetLocalInt(oItem,"nCurrency");
  object oMod=GetModule();
  int nV;
  int nCoins;
  string sTag=GetLocalString(oMod,"sMSCoinMasterTag");
  object oOb;
  string sPID;
  object oOwner=GetLocalObject(oItem,"oOwner");
  object oItem;
  // check to see if need thieving object
  if (GetSkillRank(SKILL_PICK_POCKET,oPC)>0&&GetIsPC(oPC))
  { // should have thieving abilities item
    oItem=GetItemPossessedBy(oPC,"npcact_it_thief");
    if (oItem==OBJECT_INVALID) oItem=CreateItemOnObject("npcact_it_thief",oPC,1);
  } // should have thieving abilities item
  sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_1");
  if (GetGold(oPC)>0&&(sTag=="DB"||GetItemPossessedBy(oPC,sTag)!=OBJECT_INVALID))
  { // deal with gold while here
    nV=GetGold(oPC);
    AssignCommand(oPC,TakeGoldFromCreature(nV,oPC,TRUE)); // gold is NOT used
    nN=GetLocalInt(oMod,"nMSCoinGoldCurrency");
    nV=nV*GetLocalInt(oMod,"nMSCoinGoldValue");
    GiveCoins(oPC,nV,"ANY",nN);
  } // deal with gold while here
  if (oOwner!=oPC&&GetLocalInt(oItem,"nCurrency")>0)
  { // not already owned
  while(GetStringLength(sS)>0)
  { // currency valid
    nN=GetLocalInt(oMod,"nMSCoin_R_"+GetResRef(oItem)+"_"+IntToString(nCurrency));
    if (nN>0)
    { // it is a coin type
      SetLocalObject(oItem,"oOwner",oPC);
      nCoins=GetLocalInt(oItem,"nCoins");
      if (sTag=="DB")
      { // database
        oOb=oPC;
        if (GetIsPC(oPC)) { sPID=fnGeneratePID(oPC); oOb=oMod; }
        nV=NPCGetPersistentInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,DB_TABLE);
        nV=nV+nCoins;
        NPCSetPersistentInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN)+sPID,nV,0,DB_TABLE);
      } // database
      else
      { // object
        oOb=GetItemPossessedBy(oPC,sTag);
        if (oOb!=OBJECT_INVALID)
        { // storage item found
          nV=GetLocalInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN));
          nV=nV+nCoins;
          SetLocalInt(oOb,"nMSCoin"+IntToString(nCurrency)+"_"+IntToString(nN),nV);
        } // storage item found
        else
        { // error
          SendMessageToPC(oPC,"ERROR: npcact_h_money UnacquireCoins(): Cannot find token item '"+sTag+"'!");
        } // error
      } // object
      if(GetLocalInt(oMod,"nMSCoins1LB")>0) DetermineCoinWeight(oItem,GetLocalInt(oMod,"nMSCoins1LB"),GetLocalInt(oMod,"bMSCoinEncumberance"));
      return TRUE;
    } // it is a coin type
    nCurrency++;
    sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_1");
  } // currency valid
  } // not already owned
  return FALSE;
} // AcquireCoins()

int GetPrice(string sResRef,object oMerchant=OBJECT_INVALID,int nMarkup=100,int nStackSize=1)
{ // PURPOSE: To get the price of the specified item
  object oMe=OBJECT_SELF;
  object oMod=GetModule();
  object oWP;
  object oItem;
  int nV;
  int nGPV;
  int nPrice;
  float fPrice;
  float fMarkup;
  int nRet=-1;
  if (oMerchant!=OBJECT_INVALID)
  { // merchant exists
    oItem=CreateItemOnObject(sResRef,oMerchant,nStackSize);
  } // merchant exists
  else
  { // merchant does not exist
    oItem=CreateObject(OBJECT_TYPE_ITEM,sResRef,GetLocation(oMe));
    SetItemStackSize(oItem,nStackSize);
  } // merchant does not exist
  if (oItem!=OBJECT_INVALID) { nGPV=GetGoldPieceValue(oItem); DestroyObject(oItem); }
  else { return -1; }
  //SendMessageToPC(GetFirstPC(),"GPV: "+IntToString(nGPV));
  nPrice=GetLocalInt(oMod,"nMSPrice_"+sResRef);
  nV=GetLocalInt(oMerchant,"nMSPrice_"+sResRef);
  if (nV>0) nPrice=nV;
  else if (nV==-2) nPrice=-2;
  nV=GetLocalInt(oMerchant,"nProfMerchInvRR"+sResRef);
  if (nV>0)
  { // listed item
    nV=GetLocalInt(oMerchant,"nProfMerchInvPrice"+IntToString(nV));
    if (nV>0) nPrice=nV;
    else if (nV==-2) nPrice=-2;
  } // listed item
  if (nPrice==0)
  { // convert GPV
    nV=1;
    if (GetLocalInt(oMod,"nMSPricingMultiple")>0) nV=GetLocalInt(oMod,"nMSPricingMultiple");
    nV=nGPV*nV;
    nPrice=nV;
  } // convert GPV
  if (nPrice>0)
  { // value
    fMarkup=IntToFloat(nMarkup);
    fMarkup=fMarkup/100.0; // convert to percentage
    fPrice=IntToFloat(nPrice);
    fPrice=fPrice*fMarkup;
    nPrice=FloatToInt(fPrice);
    //nPrice=nPrice*nStackSize;
  } // value
  nRet=nPrice;
  return nRet;
} // GetPrice()

//void main(){}
