////////////////////////////////////////////////////////////////////////////////
// lib_nais_tool - This is a library of common tool functions that might be used
// in other scripts.
// By Deva B. Winblood.  03/17/2007
////////////////////////////////////////////////////////////////////////////////


///////////////////
// CONSTANT
///////////////////


///////////////////
// PROTOTYPES
///////////////////


// FILE: lib_nais_tool              FUNCTION: lib_ForceEquip()
// This is a recursive function that will attempt to force oCreature to equip
// oItem in slot nSlot.  It will keep trying once per second until oItem does
// not exist or nCount is equal to nTimeOut attempts. This does not attempt to
// unequip any item already in slot.  This will abort if there is an item in
// that slot.
void lib_ForceEquip(object oCreature,object oItem,int nSlot,int nTimeOut=5,int nCount=0);


// FILE: lib_nais_tool              FUNCTION: lib_ParseString()
// This will parse the string sString based on sDelim delimiter.
string lib_ParseString(string sString,string sDelim="/");


// FILE: lib_nais_tool              FUNCTION: lib_RemoveParsed()
// This will remove sParsed from sString and make sure there is no dangling
// sDelim delimiter at the beginning of sString.
string lib_RemoveParsed(string sString,string sParsed,string sDelim="/");

// FILE: lib_nais_tool              FUNCTION: lib_ForceJump()
// Make sure oCreature arrives at oDest
void lib_ForceJump(object oCreature,object oDest,int nCount=0);


// FILE: lib_nais_tool              FUNCTION: lib_GetAlignmentString()
// This will return one of the following alignment strings for oCreature
// LG, NG, CG, LN, NN, CN, LE, NE, or CE
string lib_GetAlignmentString(object oCreature);


// FILE: lib_nais_tool              FUNCTION: lib_StripCreature()
// This will remove equipped non-creature item inventory, and all carried
// inventory, and gold.
void lib_StripCreature(object oCreature);


// FILE: lib_nais_tool     FUNCTION: lib_SetStringColor()
// This function will make sString be the specified color
// as specified in sRGB.  RGB is the Red, Green, and Blue
// components of the color.  Each color can have a value from
// 0 to 6.   A RED = "600"   A GREEN = "060"   A BLUE = "006"
// WHITE = "666"  BLACK = "000" and so forth.  You may also
// pass string constants as sRGB provided they are in the 3 digit
// RGB format.
string lib_SetStringColor(string sString,string sRGB);


///////////////////
// FUNCTIONS
///////////////////

void lib_ForceEquip(object oCreature,object oItem,int nSlot,int nTimeOut=5,int nCount=0)
{ // PURPOSE: To make sure oCreature equips oItem
    object oEquipped=GetItemInSlot(nSlot,oCreature);
    if (!GetIsObjectValid(oEquipped)&&GetIsObjectValid(oItem)&&nCount<nTimeOut)
    { // keep trying
        AssignCommand(oCreature,ClearAllActions(TRUE));
        AssignCommand(oCreature,ActionEquipItem(oItem,nSlot));
        DelayCommand(1.0,lib_ForceEquip(oCreature,oItem,nSlot,nTimeOut,nCount+1));
    } // keep trying
    else if (GetIsObjectValid(oEquipped)&&oItem!=oEquipped)
    { // another item was equipped
        PrintString("Error [lib_nais_tool] lib_ForceEquip: Item '"+GetName(oItem)+"' could not be equipped.  Another item already occupied that slot.");
    } // another item was equipped
    else if (nCount>=nTimeOut)
    { // it timed out
        PrintString("Error [lib_nais_tool] lib_ForceEquip: The function timed out after "+IntToString(nTimeOut)+" attempts for item '"+GetName(oItem)+"'.  Make sure the item is valid for that slot, the item can be equipped based on class, and the item is actually in the possession of the creature '"+GetName(oCreature)+"'.");
        if (GetItemPossessor(oItem)!=oCreature) PrintString("   Addendum to Error: The item was not in possession of the creature trying to equip it.");
    } // it timed out
} // lib_ForceEquip()


string lib_ParseString(string sString,string sDelim="/")
{ // PURPOSE: To strip the first part of string sString that occurs before
  // sDelim
    int nPos=0;
    string sRet="";
    string sVar=GetSubString(sString,nPos,1);
    while(nPos<GetStringLength(sString))
    { // positional string building
        if (sVar==sDelim) return sRet;
        sRet=sRet+sVar;
        nPos++;
        sVar=GetSubString(sString,nPos,1);
    } // positional string building
    return sRet;
} // lib_ParseString()


string lib_RemoveParsed(string sString,string sParsed,string sDelim="/")
{ // PURPOSE: To remove sParsed string from sString and if a dangling sDelim
  // delimiter remains at the beginning.  Remove those as well
    int nParsed=GetStringLength(sParsed);
    int nString=GetStringLength(sString);
    string sRet;
    if (nParsed>=nString) return "";
    else if (nParsed==0) return sString;
    else
    { // strip
        sRet=GetStringRight(sString,nString-nParsed);
        while(GetStringLeft(sRet,1)==sDelim)
        { // strip leading delimiters
            sRet=GetStringRight(sRet,GetStringLength(sRet)-1);
        } // strip leading delimiters
    } // strip
    return sRet;
} // lib_RemoveParsed()


void lib_ForceJump(object oCreature,object oDest,int nCount=0)
{ // PURPOSE: This will force oCreature to jump to oDest
    if (!GetIsObjectValid(oDest)||!GetIsObjectValid(oCreature)) return;
    if (nCount>9)
    { // fail
        SendMessageToPC(GetFirstPC(),"ERROR: lib_nais_tool - ForceJump Failed on Creature '"+GetName(oCreature)+"' in area '"+GetName(GetArea(oCreature))+"' to reach '"+GetTag(oDest)+"'");
        return;
    } // fail
    if (GetArea(oDest)!=GetArea(oCreature)||GetDistanceBetween(oDest,oCreature)>2.0)
    { // jump
        AssignCommand(oCreature,ClearAllActions(TRUE));
        AssignCommand(oCreature,JumpToObject(oDest));
        DelayCommand(1.0,lib_ForceJump(oCreature,oDest,nCount+1));
    } // jump
} // lib_ForceJump()


string lib_GetAlignmentString(object oCreature)
{ // PURPOSE: To return an alignment string
    string sRet="";
    int nAGE;
    int nALC;
    if (GetObjectType(oCreature)==OBJECT_TYPE_CREATURE)
    { // alignment
        nALC=GetAlignmentLawChaos(oCreature);
        nAGE=GetAlignmentGoodEvil(oCreature);
        if (nALC==ALIGNMENT_LAWFUL) sRet="L";
        else if (nALC==ALIGNMENT_CHAOTIC) sRet="C";
        else { sRet="N"; }
        if (nAGE==ALIGNMENT_GOOD) sRet=sRet+"G";
        else if (nAGE==ALIGNMENT_EVIL) sRet=sRet+"E";
        else { sRet=sRet+"N"; }
    } // alignment
    return sRet;
} // lib_GetAlignmentString();


void lib_StripCreature(object oCreature)
{ // PURPOSE: To remove creature inventory and gold
    object oItem;
    if (GetIsObjectValid(oCreature)&&GetObjectType(oCreature)==OBJECT_TYPE_CREATURE)
    { // valid oCreature
        oItem=GetFirstItemInInventory(oCreature);
        while(GetIsObjectValid(oItem))
        { // strip
            DelayCommand(0.5,DestroyObject(oItem));
            oItem=GetNextItemInInventory(oCreature);
        } // strip
        oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_BELT,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_BOOTS,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_CLOAK,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_HEAD,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_NECK,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_LEFTRING,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCreature);
        if (GetIsObjectValid(oItem))
        { // Destroy
            DestroyObject(oItem);
        } // Destroy
        TakeGoldFromCreature(GetGold(oCreature),oCreature,TRUE);
    } // valid oCreature
} // lib_StripCreature()


string lib_SetStringColor(string sString,string sRGB)
{ // PURPOSE: To convert sString to specified color
  // Original Scripter: Deva B. Winblood
  // Last Modified By: Deva B. Winblood   5/2/2006
  string sRGBVALUES=" fw®°Ìþ";
  string sColorEnd="</c>";
  string sRet;
  int nR=StringToInt(GetSubString(sRGB,0,1));
  int nG=StringToInt(GetSubString(sRGB,1,1));
  int nB=StringToInt(GetSubString(sRGB,2,1));
  if (nR>6) nR=6;
  if (nG>6) nG=6;
  if (nB>6) nB=6;
  sRet="<c"+GetSubString(sRGBVALUES,nR,1)+GetSubString(sRGBVALUES,nG,1);
  sRet=sRet+GetSubString(sRGBVALUES,nB,1)+">"+sString+sColorEnd;
  return sRet;
} // lib_SetStringColorColor()


//void main(){}
