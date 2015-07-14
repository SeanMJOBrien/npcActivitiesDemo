////////////////////////////////////////////////////////////////////////////////
// npcact_h_make - NPC ACTIVITIES 6.0 Make Functions
//------------------------------------------------------------------------------
// by Deva Bryson Winblood.
//------------------------------------------------------------------------------
// Last Modified by: Deva Bryson Winblood
// Last Modified Date: 05/31/2004
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
/////////////////////////
// PROTOTYPES
/////////////////////////

// FILE: npcact_h_make                FUNCTION: fnNPCACTMakeCreature()
// This function will create a creature with specified resref at the
// location of the NPC.
float fnNPCACTMakeCreature(string sCom);

// FILE: npcact_h_make                FUNCTION: fnNPCACTMakeItem()
// This function will create an item with the specified resref at the
// location of the NPC.
float fnNPCACTMakeItem(string sCom);

// FILE: npcact_h_make                FUNCTION: fnNPCACTMakePlaceable()
// This function will create a specified placeable ad location specified by
// the tag.
float fnNPCACTMakePlaceable(string sCom);

/////////////////////////
// FUNCTIONS
/////////////////////////

float fnNPCACTMakeCreature(string sCom)
{ // PURPOSE: To create a creature
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sRes=GetStringRight(sCom,GetStringLength(sCom)-1);
  object oCr=CreateObject(OBJECT_TYPE_CREATURE,sRes,GetLocation(OBJECT_SELF));
  return 0.0;
} // fnNPCACTMakeCreature()

float fnNPCACTMakeItem(string sCom)
{ // PURPOSE: To create a item
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sRes=GetStringRight(sCom,GetStringLength(sCom)-2);
  object oCr;
  location lLoc=GetLocation(OBJECT_SELF);
  object oWP=GetNearestObjectByTag("NPCACT_CREATE_HERE");
  if (GetDistanceBetween(oWP,OBJECT_SELF)<=3.0&&GetIsObjectValid(oWP)) lLoc=GetLocation(oWP);
  oCr=CreateObject(OBJECT_TYPE_ITEM,sRes,lLoc);
  return 0.0;
} // fnNPCACTMakeItem()

float fnNPCACTMakePlaceable(string sCom)
{ // PURPOSE: To create a placeable at specified location
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sParm=GetStringRight(sCom,GetStringLength(sCom)-2);
  string sRes=fnParse(sParm,"/");
  string sLoc=fnRemoveParsed(sParm,sRes,"/");
  object oLoc=GetObjectByTag(sLoc);
  object oPlc;
  if (GetIsObjectValid(oLoc))
  { // valid location
    oPlc=CreateObject(OBJECT_TYPE_PLACEABLE,sRes,GetLocation(oLoc));
  } // valid location
  return 0.0;
} // fnNPCACTMakePlaceable()

//void main(){}
