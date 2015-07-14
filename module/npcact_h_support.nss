////////////////////////////////////////////////////////////////////////////////
// npcact_h_support - NPC ACTIVITIES 6.0 Support Functions
//------------------------------------------------------------------------------
// by Deva Bryson Winblood.
//------------------------------------------------------------------------------
// Last Modified by: Deva Bryson Winblood
// Last Modified Date: 06/01/2004
////////////////////////////////////////////////////////////////////////////////

/////////////////////////
// PROTOTYPES
/////////////////////////

// FILE: npcact_h_support              FUNCTION: fnIsAWeapon()
// This function will return TRUE is the item passed to the function
// is classed as a weapon.
int fnIsAWeapon(object oItem);

// FILE: npcact_h_support              FUNCTION: fnIsBespelled()
// This function will return TRUE if the object passed has spell effects
// on it.
int fnIsBespelled(object oObject);

/////////////////////////
// FUNCTIONS
/////////////////////////

int fnIsAWeapon(object oItem)
{ // PURPOSE: To determine whether the item passed to the
  // function can be classified as a weapon.
  // LAST MODIFIED BY: Deva Bryson Winblood
  int bRet=FALSE;
  int nBase=GetBaseItemType(oItem);
  if (GetWeaponRanged(oItem)==TRUE) bRet=TRUE;
  else
  { // further testing required
    if (nBase==BASE_ITEM_DAGGER||nBase==BASE_ITEM_DIREMACE||nBase==BASE_ITEM_DOUBLEAXE) bRet=TRUE;
    else if (nBase==BASE_ITEM_DWARVENWARAXE||nBase==BASE_ITEM_GREATAXE||nBase==BASE_ITEM_GREATSWORD) bRet=TRUE;
    else if (nBase==BASE_ITEM_HALBERD||nBase==BASE_ITEM_HANDAXE||nBase==BASE_ITEM_HEAVYFLAIL) bRet=TRUE;
    else if (nBase==BASE_ITEM_KAMA||nBase==BASE_ITEM_KATANA||nBase==BASE_ITEM_KUKRI) bRet=TRUE;
    else if (nBase==BASE_ITEM_LIGHTFLAIL||nBase==BASE_ITEM_LIGHTHAMMER||nBase==BASE_ITEM_LIGHTMACE) bRet=TRUE;
    else if (nBase==BASE_ITEM_LONGSWORD||nBase==BASE_ITEM_MAGICROD||nBase==BASE_ITEM_MAGICSTAFF) bRet=TRUE;
    else if (nBase==BASE_ITEM_MAGICWAND||nBase==BASE_ITEM_MORNINGSTAR||nBase==BASE_ITEM_QUARTERSTAFF) bRet=TRUE;
    else if (nBase==BASE_ITEM_RAPIER||nBase==BASE_ITEM_SCIMITAR||nBase==BASE_ITEM_SCYTHE) bRet=TRUE;
    else if (nBase==BASE_ITEM_SHORTSPEAR||nBase==BASE_ITEM_SHORTSWORD||nBase==BASE_ITEM_SICKLE) bRet=TRUE;
    else if (nBase==BASE_ITEM_TWOBLADEDSWORD||nBase==BASE_ITEM_WARHAMMER||nBase==BASE_ITEM_WHIP) bRet=TRUE;
  } // further testing required
  return bRet;
} // fnIsAWeapon()

int fnIsBespelled(object oObject)
{ // PURPOSE: This function will return TRUE if the object has spell effects on it
  // LAST MODIFIED BY: Deva Bryson Winblood
  int bRet=FALSE;
  effect eE=GetFirstEffect(oObject);
  while(GetIsEffectValid(eE)&&!bRet)
  { // test all effects
    if(GetEffectSpellId(eE)!=-1) bRet=TRUE;
    eE=GetNextEffect(oObject);
  } // test all effects
  return bRet;
} // fnIsBespelled()


//void main(){}
