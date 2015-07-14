////////////////////////////////////////////////////////////////////////////////
// lib_nais_var - This is the library for handling variables in a persistent
// mode in this module.   This interfaces with Knat's NBDE.
// By Deva B. Winblood.  03/17/2007
////////////////////////////////////////////////////////////////////////////////

#include "nbde_inc"
#include "lib_nais_tool"

///////////////////////
// CONSTANTS
///////////////////////


///////////////////////
// PROTOTYPES
///////////////////////


// FILE: lib_nais_var               FUNCTION: GetSkinObject()
// This function will return the skin being worn by oTarget.   If the skin does
// not exist it will create it.
object GetSkinObject(object oTarget);


// FILE: lib_nais_var               FUNCTION: SetSkinInt()
// This will set the integer sVar on the skin object on oTarget
void SetSkinInt(object oTarget,string sVar,int nVal);


// FILE: lib_nais_var               FUNCTION: GetSkinInt()
// This function will return the integer sVar on the skin object on oTarget
int GetSkinInt(object oTarget,string sVar);


// FILE: lib_nais_var               FUNCTION: SetSkinString()
// This will set the string sVar on the skin object on oTarget
void SetSkinString(object oTarget,string sVar,string sVal);


// FILE: lib_nais_var               FUNCTION: GetSkinString()
// This function will return the string sVar on the skin object on oTarget
string GetSkinString(object oTarget,string sVar);


// FILE: lib_nais_var               FUNCTION: SetSkinFloat()
// This will set the float sVar on the skin object on oTarget
void SetSkinFloat(object oTarget,string sVar,float fVal);


// FILE: lib_nais_var               FUNCTION: GetSkinFloat()
// This function will return the float sVar on the skin object on oTarget
float GetSkinFloat(object oTarget,string sVar);


// FILE: lib_nais_var               FUNCTION: DeleteSkinInt()
// This function will delete the sVar integer on the skin object on oTarget
void DeleteSkinInt(object oTarget,string sVar);


// FILE: lib_nais_var               FUNCTION: DeleteSkinString()
// This function will delete the sVar string on the skin object on oTarget
void DeleteSkinString(object oTarget,string sVar);


// FILE: lib_nais_var               FUNCTION: DeleteSkinFloat()
// This function will delete the sVar float on the skin object on oTarget
void DeleteSkinFloat(object oTarget,string sVar);


// FILE: lib_nais_var               FUNCTION: GetPCUID()
// This function will return a unique ID used for this player
string GetPCUID(object oPC);


///////////////////////
// FUNCTIONS
///////////////////////

object GetSkinObject(object oTarget)
{ // PURPOSE: To return and possibly create the skin object
    object oSkin=OBJECT_INVALID;
    if (GetIsObjectValid(oTarget)&&GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
    { // valid oTarget
        oSkin=GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);
        if (!GetIsObjectValid(oSkin))
        { // the skin needs to be created or see if in inventory
            oSkin=GetItemPossessedBy(oTarget,"base_skin");
            if (!GetIsObjectValid(oSkin))
            { // skin was not in inventory
                oSkin=CreateItemOnObject("base_skin",oTarget);
            } // skin was not in inventory
            lib_ForceEquip(oTarget,oSkin,INVENTORY_SLOT_CARMOUR);
        } // the skin needs to be created or see if in inventory
    } // valid oTarget
    return oSkin;
} // GetSkinObject()


void SetSkinInt(object oTarget,string sVar,int nVal)
{ // PURPOSE: To set the integer value on oSkin
    object oSkin=GetSkinObject(oTarget);
    if (GetIsObjectValid(oSkin))
    { // set value
        SetLocalInt(oSkin,sVar,nVal);
    } // set value
} // SetSkinInt()


void SetSkinString(object oTarget,string sVar,string sVal)
{ // PURPOSE: To set the string value on oSkin
    object oSkin=GetSkinObject(oTarget);
    if (GetIsObjectValid(oSkin))
    { // set value
        SetLocalString(oSkin,sVar,sVal);
    } // set value
} // SetSkinString()


void SetSkinFloat(object oTarget,string sVar,float fVal)
{ // PURPOSE: To set the float value on oSkin
    object oSkin=GetSkinObject(oTarget);
    if (GetIsObjectValid(oSkin))
    { // set value
        SetLocalFloat(oSkin,sVar,fVal);
    } // set value
} // SetSkinFloat()


int GetSkinInt(object oTarget,string sVar)
{ // PURPOSE: This will return the value of sVar on the oTarget skin oSkin
    object oSkin=GetSkinObject(oTarget);
    if (GetIsObjectValid(oSkin))
    { // skin exists
        return GetLocalInt(oSkin,sVar);
    } // skin exists
    return 0;
} // GetSkinInt()


string GetSkinString(object oTarget,string sVar)
{ // PURPOSE: This will return the value of sVar on the oTarget skin oSkin
    object oSkin=GetSkinObject(oTarget);
    if (GetIsObjectValid(oSkin))
    { // skin exists
        return GetLocalString(oSkin,sVar);
    } // skin exists
    return "";
} // GetSkinString()


float GetSkinFloat(object oTarget,string sVar)
{ // PURPOSE: This will return the value of sVar on the oTarget skin oSkin
    object oSkin=GetSkinObject(oTarget);
    if (GetIsObjectValid(oSkin))
    { // skin exists
        return GetLocalFloat(oSkin,sVar);
    } // skin exists
    return 0.0;
} // GetSkinFloat()


void DeleteSkinInt(object oTarget,string sVar)
{ // PURPOSE: To delete the variable sVar from the skin object on oTarget
    object oSkin=GetSkinObject(oTarget);
    if (GetIsObjectValid(oSkin))
    { // skin exists
        DeleteLocalInt(oSkin,sVar);
    } // skin exists
} // DeleteSkinInt()


void DeleteSkinString(object oTarget,string sVar)
{ // PURPOSE: To delete the variable sVar from the skin object on oTarget
    object oSkin=GetSkinObject(oTarget);
    if (GetIsObjectValid(oSkin))
    { // skin exists
        DeleteLocalString(oSkin,sVar);
    } // skin exists
} // DeleteSkinString()


void DeleteSkinFloat(object oTarget,string sVar)
{ // PURPOSE: To delete the variable sVar from the skin object on oTarget
    object oSkin=GetSkinObject(oTarget);
    if (GetIsObjectValid(oSkin))
    { // skin exists
        DeleteLocalInt(oSkin,sVar);
    } // skin exists
} // DeleteSkinFloat()


string GetPCUID(object oPC)
{ // PURPOSE: To return a unique identifier for this PC
    string sName;
    if (GetIsObjectValid(oPC))
    { // valid PC
        sName=GetPCPlayerName(oPC);
        if (GetStringLength(sName)>4)
        { // limit length
            sName=GetStringLeft(sName,2)+GetStringRight(sName,2);
        } // limit length
        return GetPCPublicCDKey(oPC)+GetName(oPC)+"_"+sName;
    } // valid PC
    return "";
} // GetPCUID()


//void main(){}
