//:://////////////////////////////////////////////////
//:: Created By:   Valerio Santinelli - tanis@mediacom.it
//:: Created On:   2002/08/09
//:://////////////////////////////////////////////////
/*
    Persistent World DataBase functions.
    Credits to E.J. Wilburn - zane@supernova.org for the original idea.
*/

// Get our persistent ID.
// If the ID is not in the ID list and bCreate is set
// to TRUE then we create a new ID and return it, otherwise return 0.
int GetID(string sKey, int bCreate = FALSE) {
    object oPWDBObjs = GetObjectByTag("PWDB_OBJECTS");

    int iID = GetLocalInt(oPWDBObjs, sKey);

    if (!iID && bCreate)
    {
        iID = GetLocalInt(oPWDBObjs, "COUNT") + 1;
        SetLocalInt(oPWDBObjs, "COUNT", iID);
        SetLocalInt(oPWDBObjs, sKey, iID);
        SetLocalString(oPWDBObjs, IntToString(iID), sKey);
    }

    return iID;
}

// Determine an Object's key.
string GetKey(object oTarget)
{
    string sKey;

    if (GetIsPC(oTarget))
        sKey = GetPCPlayerName(oTarget) + "," + GetName(oTarget);
    else
        sKey = GetTag(oTarget) + "," + GetName(oTarget);

    return sKey;
}

// Get a persistent var ID.
// If the var is not in the ID list and bCreate is TRUE
// then we create the ID and return it, otherwise return 0.
// iObjID is obtained from GetID
// sVarName is the Variable Name to retrieve.
int GetVarID(int iObjID, string sVarName, int bCreate = FALSE) {
    string sKey = IntToString(iObjID) + "_" + sVarName;
    object oPWDBVars = GetObjectByTag("PWDB_VALUES");

    int iID = GetLocalInt(oPWDBVars, sKey);

    if (!iID && bCreate)
    {
        iID = GetLocalInt(oPWDBVars, "COUNT") + 1;
        SetLocalInt(oPWDBVars, "COUNT", iID);
        SetLocalInt(oPWDBVars, sKey, iID);
        string sID = IntToString(iID);
        SetLocalString(oPWDBVars, sID + "_KEY", sKey);
        SetLocalString(oPWDBVars, sID + "_VARNAME", sVarName);
        SetLocalInt(oPWDBVars, sID + "_OWNER", iObjID);
        SetLocalInt(oPWDBVars, sID + "_CHANGED", 1);
    }

    return iID;
}

string GetPersistentString(object oTarget, string sName)
{
    // Get our object's persistent ID.
    int iObjID = GetID(GetKey(oTarget));
    if (!iObjID)
        return "";

    int iVarID = GetVarID(iObjID, "S" + sName);
    if (!iVarID)
        return "";

    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    return GetLocalString(oPWDBValues, IntToString(iVarID) + "_VALUE"); }

int GetPersistentInt(object oTarget, string sName)
{
    // Get our object's persistent ID.
    int iObjID = GetID(GetKey(oTarget));
    if (!iObjID)
        return 0;

    int iVarID = GetVarID(iObjID, "I" + sName);
    if (!iVarID)
        return 0;

    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    return GetLocalInt(oPWDBValues, IntToString(iVarID) + "_VALUE"); }

float GetPersistentFloat(object oTarget, string sName)
{
    // Get our object's persistent ID.
    int iObjID = GetID(GetKey(oTarget));
    if (!iObjID)
        return 0.0f;

    int iVarID = GetVarID(iObjID, "F" + sName);
    if (!iVarID)
        return 0.0f;

    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    return GetLocalFloat(oPWDBValues, IntToString(iVarID) + "_VALUE"); }

location GetPersistentLocation(object oTarget, string sName)
{
    // Get our object's persistent ID.
    int iObjID = GetID(GetKey(oTarget));
    int iVarID = GetVarID(iObjID, "L" + sName);
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    return GetLocalLocation(oPWDBValues, IntToString(iVarID) + "_VALUE"); }

object GetPersistentObject(object oTarget, string sName)
{
    // Get our object's persistent ID.
    int iObjID = GetID(GetKey(oTarget));
    if (!iObjID)
        return OBJECT_INVALID;

    int iVarID = GetVarID(iObjID, "O" + sName);
    if (!iVarID)
        return OBJECT_INVALID;

    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    return GetLocalObject(oPWDBValues, IntToString(iVarID) + "_VALUE"); }

void SetPersistentStringByKey(string sKey, string sName, string sValue, int bMarkChanged = TRUE) {
    // Get our object's persistent ID.
    int iObjID = GetID(sKey, TRUE);
    int iVarID = GetVarID(iObjID, "S" + sName, TRUE);
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalString(oPWDBValues, sVarID + "_VALUE", sValue);
    if (bMarkChanged)
    {
        SetLocalInt(oPWDBValues, sVarID + "_CHANGED", 1);
        SetLocalInt(oPWDBValues, "CHANGED", 1);
    }
    DeleteLocalInt(oPWDBValues, sVarID + "_DELETED");
}

void SetPersistentString(object oTarget, string sName, string sValue) {
    SetPersistentStringByKey(GetKey(oTarget), sName, sValue);
}

void SetPersistentIntByKey(string sKey, string sName, int iValue, int bMarkChanged = TRUE) {
    // Get our object's persistent ID.
    int iObjID = GetID(sKey, TRUE);
    int iVarID = GetVarID(iObjID, "I" + sName, TRUE);
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalInt(oPWDBValues, sVarID + "_VALUE", iValue);
    if (bMarkChanged)
    {
        SetLocalInt(oPWDBValues, sVarID + "_CHANGED", 1);
        SetLocalInt(oPWDBValues, "CHANGED", 1);
    }
    DeleteLocalInt(oPWDBValues, sVarID + "_DELETED");
}

void SetPersistentInt(object oTarget, string sName, int iValue) {
    SetPersistentIntByKey(GetKey(oTarget), sName, iValue);
}

void SetPersistentFloatByKey(string sKey, string sName, float fValue, int bMarkChanged = TRUE) {
    // Get our object's persistent ID.
    int iObjID = GetID(sKey, TRUE);
    int iVarID = GetVarID(iObjID, "F" + sName, TRUE);
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalFloat(oPWDBValues, sVarID + "_VALUE", fValue);
    if (bMarkChanged)
    {
        SetLocalInt(oPWDBValues, sVarID + "_CHANGED", 1);
        SetLocalInt(oPWDBValues, "CHANGED", 1);
    }
    DeleteLocalInt(oPWDBValues, sVarID + "_DELETED");
}

void SetPersistentFloat(object oTarget, string sName, float fValue) {
    SetPersistentFloatByKey(GetKey(oTarget), sName, fValue);
}

void SetPersistentLocationByKey(string sKey, string sName, location lValue, int bMarkChanged = TRUE) {
    // Get our object's persistent ID.
    int iObjID = GetID(sKey, TRUE);
    int iVarID = GetVarID(iObjID, "L" + sName, TRUE);
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalLocation(oPWDBValues, sVarID + "_VALUE", lValue);
    if (bMarkChanged)
    {
        SetLocalInt(oPWDBValues, sVarID + "_CHANGED", 1);
        SetLocalInt(oPWDBValues, "CHANGED", 1);
    }
    DeleteLocalInt(oPWDBValues, sVarID + "_DELETED");
}

void SetPersistentLocation(object oTarget, string sName, location lValue) {
    SetPersistentLocationByKey(GetKey(oTarget), sName, lValue); }

void SetPersistentObjectByKey(string sKey, string sName, object oValue, int bMarkChanged = TRUE) {
    // Get our object's persistent ID.
    int iObjID = GetID(sKey, TRUE);
    int iVarID = GetVarID(iObjID, "O" + sName, TRUE);
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalObject(oPWDBValues, sVarID + "_VALUE", oValue);
    if (bMarkChanged)
    {
        SetLocalInt(oPWDBValues, sVarID + "_CHANGED", 1);
        SetLocalInt(oPWDBValues, "CHANGED", 1);
    }
    DeleteLocalInt(oPWDBValues, sVarID + "_DELETED");
}

void SetPersistentObject(object oTarget, string sName, object oValue) {
    SetPersistentObjectByKey(GetKey(oTarget), sName, oValue);
}

void DeletePersistentString(object oTarget, string sName)
{
    int iObjID = GetID(GetKey(oTarget));
    if (!iObjID)
        return;
    int iVarID = GetVarID(iObjID, "S" + sName);
    if (!iVarID)
        return;
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalInt(oPWDBValues, sVarID + "_DELETED", 1);
    DeleteLocalString(oPWDBValues, sVarID + "_VALUE");
    SetLocalInt(oPWDBValues, "CHANGED", 1);
}

void DeletePersistentInt(object oTarget, string sName)
{
    int iObjID = GetID(GetKey(oTarget));
    if (!iObjID)
        return;
    int iVarID = GetVarID(iObjID, "I" + sName);
    if (!iVarID)
        return;
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalInt(oPWDBValues, sVarID + "_DELETED", 1);
    DeleteLocalInt(oPWDBValues, sVarID + "_VALUE");
    SetLocalInt(oPWDBValues, "CHANGED", 1);
}

void DeletePersistentFloat(object oTarget, string sName)
{
    int iObjID = GetID(GetKey(oTarget));
    if (!iObjID)
        return;
    int iVarID = GetVarID(iObjID, "F" + sName);
    if (!iVarID)
        return;
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalInt(oPWDBValues, sVarID + "_DELETED", 1);
    DeleteLocalFloat(oPWDBValues, sVarID + "_VALUE");
    SetLocalInt(oPWDBValues, "CHANGED", 1);
}

void DeletePersistentLocation(object oTarget, string sName)
{
    int iObjID = GetID(GetKey(oTarget));
    if (!iObjID)
        return;
    int iVarID = GetVarID(iObjID, "L" + sName);
    if (!iVarID)
        return;
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalInt(oPWDBValues, sVarID + "_DELETED", 1);
    DeleteLocalLocation(oPWDBValues, sVarID + "_VALUE");
    SetLocalInt(oPWDBValues, "CHANGED", 1);
}

void DeletePersistentObject(object oTarget, string sName)
{
    int iObjID = GetID(GetKey(oTarget));
    if (!iObjID)
        return;
    int iVarID = GetVarID(iObjID, "O" + sName);
    if (!iVarID)
        return;
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalInt(oPWDBValues, sVarID + "_DELETED", 1);
    DeleteLocalObject(oPWDBValues, sVarID + "_VALUE");
    SetLocalInt(oPWDBValues, "CHANGED", 1);
}

void DeletePersistentByKey(string sOwnerKey, string sVarKey)
{
    int iObjID = GetID(sOwnerKey);
    if (!iObjID)
        return;
    int iVarID = GetVarID(iObjID, sVarKey);
    if (!iVarID)
        return;
    object oPWDBValues = GetObjectByTag("PWDB_VALUES");
    string sVarID = IntToString(iVarID);
    SetLocalInt(oPWDBValues, sVarID + "_DELETED", 1);

    string sType = GetStringLeft(sVarKey, 1);
    if (sType == "S")
        DeleteLocalString(oPWDBValues, sVarID + "_VALUE");
    else if (sType == "I")
        DeleteLocalInt(oPWDBValues, sVarID + "_VALUE");
    else if (sType == "F")
        DeleteLocalFloat(oPWDBValues, sVarID + "_VALUE");
    else if (sType == "L")
        DeleteLocalLocation(oPWDBValues, sVarID + "_VALUE");
    else if (sType == "O")
        DeleteLocalObject(oPWDBValues, sVarID + "_VALUE");

    if (!GetLocalInt(oPWDBValues, "CHANGED"))
        SetLocalInt(oPWDBValues, "CHANGED", 2);
}

// Save the persistent DB.  If bSaveNewOnly is set to TRUE then only the objects
// created since the module was last loaded will be saved, otherwise every
// object is saved.
void PWDBSave(int bSaveNewOnly) {
    object oPWDBObjs = GetObjectByTag("PWDB_OBJECTS");
    object oPWDBVars = GetObjectByTag("PWDB_VALUES");
    int iVarCount = GetLocalInt(oPWDBVars, "COUNT");
    int iCounter;
    string sID;
    string sType;
    string sVarName;
    string sFullVarName;
    int iObjID;
    string sOwnerKey;
    vector vPos;
    float fFacing;
    string sArea;
    location lLoc;
    int bDeleted;
    int bChanged;
    string sQuote = GetSubString(GetStringByStrRef(464), 13, 1);

    int iTotalChange = GetLocalInt(oPWDBVars, "CHANGED");
    WriteTimestampedLogEntry("CHANGED");
    PrintInteger(iTotalChange);
    PrintInteger(bSaveNewOnly);
    if (bSaveNewOnly && iTotalChange != 1)
        return;
    else if (!bSaveNewOnly && iTotalChange == 0)
        return;

    // Output the header to the log file.
    if (bSaveNewOnly)
    {
        WriteTimestampedLogEntry("************************** BEGIN PWDB SAVE CHANGED *******************************");
        PrintString("<script type='changed'>");
        PrintString("void PWDBLoadChanged()\n{");
    }
    else
    {
        WriteTimestampedLogEntry("************************** BEGIN PWDB SAVE ALL ***********************************");
        PrintString("<script type='all'>");
        PrintString("void PWDBLoad()\n{");
    }
    PrintString("    vector vPos;\n    location lLoc;");

    for (iCounter = 1; iCounter <= iVarCount; iCounter++)
    {
        sID = IntToString(iCounter);
        bChanged = GetLocalInt(oPWDBVars, sID + "_CHANGED");

        if (bSaveNewOnly && !bChanged)
            continue;

        sFullVarName = GetLocalString(oPWDBVars, sID + "_VARNAME");
        bDeleted = GetLocalInt(oPWDBVars, sID + "_DELETED");
        sType = GetStringLeft(sFullVarName, 1);
        sVarName = GetStringRight(sFullVarName, GetStringLength(sFullVarName) - 1);
        iObjID = GetLocalInt(oPWDBVars, sID + "_OWNER");
        sOwnerKey = GetLocalString(oPWDBObjs, IntToString(iObjID));

        if (sType == "S")
        {
            if (bSaveNewOnly && bDeleted)
            {
                PrintString("    DeletePersistentByKey(" + sQuote + sOwnerKey +
                sQuote + ", " + sQuote + sFullVarName + sQuote + ");");
            }
            else if ((!bSaveNewOnly || bChanged) && !bDeleted)
            {
                PrintString("    SetPersistentStringByKey(" + sQuote +
                sOwnerKey + sQuote + "," + sQuote + sVarName + sQuote + ", " + sQuote +
                GetLocalString(oPWDBVars, sID + "_VALUE") + sQuote + ", FALSE);");
            }

            if (!bSaveNewOnly && bChanged)
                DeleteLocalInt(oPWDBVars, sID + "_CHANGED");
        }
        else if (sType == "I")
        {
            if (bSaveNewOnly && bDeleted)
            {
                PrintString("    DeletePersistentByKey(" + sQuote + sOwnerKey +
                sQuote + ", " + sQuote + sFullVarName + sQuote + ");");
            }
            else if ((!bSaveNewOnly || bChanged) && !bDeleted)
            {
                PrintString("    SetPersistentIntByKey(" + sQuote + sOwnerKey +
                    sQuote + ", " + sQuote + sVarName + sQuote + ", " +
                    IntToString(GetLocalInt(oPWDBVars, sID + "_VALUE")) +
                    ", FALSE);");
            }

            if (!bSaveNewOnly && bChanged)
                DeleteLocalInt(oPWDBVars, sID + "_CHANGED");
        }
        else if (sType == "F")
        {
            if (bSaveNewOnly && bDeleted)
            {
                PrintString("    DeletePersistentByKey(" + sQuote + sOwnerKey +
                sQuote + ", " + sQuote + sFullVarName + sQuote + ");");
            }
            else if ((!bSaveNewOnly || bChanged) && !bDeleted)
            {
                PrintString("    SetPersistentFloatByKey(" + sQuote + sOwnerKey +
                sQuote + ", " + sQuote + sVarName + sQuote + ", " +
                FloatToString(GetLocalFloat(oPWDBVars, sID + "_VALUE")) +
                "f, FALSE);");
            }

            if (!bSaveNewOnly && bChanged)
                DeleteLocalInt(oPWDBVars, sID + "_CHANGED");
        }
        else if (sType == "L")
        {
            if (bSaveNewOnly && bDeleted)
            {
                PrintString("    DeletePersistentByKey(" + sQuote + sOwnerKey +
                sQuote + ", " + sQuote + sFullVarName + sQuote + ");");
            }
            else if ((!bSaveNewOnly || bChanged) && !bDeleted)
            {
                lLoc = GetLocalLocation(oPWDBVars, sID + "_VALUE");
                vPos = GetPositionFromLocation(lLoc);
                fFacing = GetFacingFromLocation(lLoc);
                sArea = GetTag(GetAreaFromLocation(lLoc));
                PrintString("    vPos.x = " + FloatToString(vPos.x) + "f;");
                PrintString("    vPos.y = " + FloatToString(vPos.y) + "f;");
                PrintString("    vPos.z = " + FloatToString(vPos.z) + "f;");
                PrintString("    lLoc = Location(GetObjectByTag(" + sQuote +
                sArea + sQuote + "), vPos, " + FloatToString(fFacing) + "f);");
                PrintString("    SetPersistentLocationByKey(" + sQuote +
                sOwnerKey + sQuote + ", " + sQuote + sVarName + sQuote + ", lLoc, FALSE);");
            }

            if (!bSaveNewOnly && bChanged)
                DeleteLocalInt(oPWDBVars, sID + "_CHANGED");
        }
        else if (sType == "O")
        {
            if (bSaveNewOnly && bDeleted)
            {
                PrintString("    DeletePersistentByKey(" + sQuote + sOwnerKey +
                sQuote + ", " + sQuote + sFullVarName + sQuote + ");");
            }
            else if ((!bSaveNewOnly || bChanged) && !bDeleted)
            {
                PrintString("    SetPersistentObjectByKey(" + sQuote +
                sOwnerKey + sQuote + ", " + sQuote + sVarName +
                sQuote + ", GetObjectByTag(" + sQuote +
                GetTag(GetLocalObject(oPWDBVars, sID + "_VALUE")) + sQuote + "), FALSE);");
            }

            if (!bSaveNewOnly && bChanged)
                DeleteLocalInt(oPWDBVars, sID + "_CHANGED");
        }
    }

    // Output the footer to the log file.
    PrintString("}");
    PrintString("</script>");
    WriteTimestampedLogEntry("************************** END PWDB SAVE *****************************************");

    if (bSaveNewOnly)
        SetLocalInt(oPWDBVars, "CHANGED", 2);
    else
        SetLocalInt(oPWDBVars, "CHANGED", 0);
}

// This should be run in the module'ss OnUnload event; it dumps the entire
// persistent DB to the log file in script format.
void PWDBSaveAll() {
    PWDBSave(FALSE);
}

// This should be run in the module'ss OnHeartBeat event and triggered every
// 10-15 minutes (more or less depending on how active your PW is).  It dumps
// all changed values since the module was loaded.  This is basically in case
// the module crashes before it has a chance to unload and call PWDBSaveAll.
// You should be able to use this script and the prior exit's script to get
// back up to date (or close).
void PWDBSaveChanged() {
    PWDBSave(TRUE);
}

