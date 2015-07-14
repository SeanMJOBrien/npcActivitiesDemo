////////////////////////////////////////////////////////////////////////////////
// npcact_aps - APS/NWNX Include replacement for NPC ACTIVITIES
// By Deva Bryson Winblood.  02/05/2005
////////////////////////////////////////////////////////////////////////////////
// Edit these function wrappers to make the script support whichever database
// system you would like it to.   It defaults to Bioware... but, nwnx/aps default
// support is available if you simply uncomment out those lines and comment the
// bioware lines out.

//#include "aps_include"   // uncomment this line out if you use this DB type

//////////////////////
// PROTOTYPES
//////////////////////

/////// WRAPPERS ////////////////////////////////////////////

// Set oObject's persistent string variable sVarName to sValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void NPCSetPersistentString(object oObject, string sVarName, string sValue, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent integer variable sVarName to iValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void NPCSetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent float variable sVarName to fValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void NPCSetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent location variable sVarName to lLocation
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
//   This function converts location to a string for storage in the database.
void NPCSetPersistentLocation(object oObject, string sVarName, location lLocation, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent vector variable sVarName to vVector
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
//   This function converts vector to a string for storage in the database.
void NPCSetPersistentVector(object oObject, string sVarName, vector vVector, int iExpiration = 0, string sTable = "pwdata");

// Get oObject's persistent string variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: ""
string NPCGetPersistentString(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent integer variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
int NPCGetPersistentInt(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent float variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
float NPCGetPersistentFloat(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent location variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
location NPCGetPersistentLocation(object oObject, string sVarname, string sTable = "pwdata");

// Get oObject's persistent vector variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
vector NPCGetPersistentVector(object oObject, string sVarName, string sTable = "pwdata");

// Delete persistent variable sVarName stored on oObject
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
void NPCDeletePersistentVariable(object oObject, string sVarName, string sTable = "pwdata");



//////////////////////
// FUNCTIONS
//////////////////////

/////////////////////////////////////////////////////////////////////
// WRAPPERS
/////////////////////////////////////////////////////////////////////

void NPCSetPersistentString(object oObject, string sVarName, string sValue, int iExpiration =
                         0, string sTable = "pwdata")
{
    // SetPersistentString(oObject,sVarName,sValue,iExpiration,sTable);
    SetCampaignString(GetName(GetModule())+sTable,sVarName,sValue,oObject);
}


string NPCGetPersistentString(object oObject, string sVarName, string sTable = "pwdata")
{
   // return GetPersistentString(oObject,sVarName,sTable);
   return GetCampaignString(GetName(GetModule())+sTable,sVarName,oObject);
}

void NPCSetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration =
                      0, string sTable = "pwdata")
{
    //SetPersistentString(oObject, sVarName, IntToString(iValue), iExpiration, sTable);
    SetCampaignInt(GetName(GetModule())+sTable,sVarName,iValue,oObject);
}

int NPCGetPersistentInt(object oObject, string sVarName, string sTable = "pwdata")
{
    //return StringToInt(NPCGetPersistentString(oObject, sVarName, sTable));
    return GetCampaignInt(GetName(GetModule())+sTable,sVarName,oObject);
}

void NPCSetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration =
                        0, string sTable = "pwdata")
{
    // SetPersistentString(oObject, sVarName, FloatToString(fValue), iExpiration, sTable);
    SetCampaignFloat(GetName(GetModule())+sTable,sVarName,fValue,oObject);
}

float NPCGetPersistentFloat(object oObject, string sVarName, string sTable = "pwdata")
{
    //return StringToFloat(NPCGetPersistentString(oObject, sVarName, sTable));
    return GetCampaignFloat(GetName(GetModule())+sTable,sVarName,oObject);
}

void NPCSetPersistentLocation(object oObject, string sVarName, location lLocation, int iExpiration =
                           0, string sTable = "pwdata")
{
    //SetPersistentString(oObject, sVarName, APSLocationToString(lLocation), iExpiration, sTable);
    SetCampaignLocation(GetName(GetModule())+sTable,sVarName,lLocation,oObject);
}

location NPCGetPersistentLocation(object oObject, string sVarName, string sTable = "pwdata")
{
    //return APSStringToLocation(NPCGetPersistentString(oObject, sVarName, sTable));
    return GetCampaignLocation(GetName(GetModule())+sTable,sVarName,oObject);
}

void NPCSetPersistentVector(object oObject, string sVarName, vector vVector, int iExpiration =
                         0, string sTable = "pwdata")
{
    //SetPersistentString(oObject, sVarName, APSVectorToString(vVector), iExpiration, sTable);
    SetCampaignVector(GetName(GetModule())+sTable,sVarName,vVector,oObject);
}

vector NPCGetPersistentVector(object oObject, string sVarName, string sTable = "pwdata")
{
    // return APSStringToVector(NPCGetPersistentString(oObject, sVarName, sTable));
    return GetCampaignVector(GetName(GetModule())+sTable,sVarName,oObject);
}

void NPCDeletePersistentVariable(object oObject, string sVarName, string sTable = "pwdata")
{
    // DeletePersistentVariable(oObject,sVarName,sTable);
    DeleteCampaignVariable(GetName(GetModule())+sTable,sVarName,oObject);
}

/////////////////////////////////////////////////////////////////
// END OF WRAPPERS
/////////////////////////////////////////////////////////////////



//void main(){}
