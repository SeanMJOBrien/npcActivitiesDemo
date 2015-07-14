////////////////////////////////////////////////////////////////////////////////
// npcact_p_merch - NPC ACTIVITIES 6.0 Merchant Profession
// By Deva Bryson Winblood.  01/2005 and 02/2005
// Last Modified By: @@@ ERROR bProfessions not released@@@@
////////////////////////////////////////////////////////////////////////////////
// This is most likely the most complex of all the professions to be offered
// with NPC ACTIVITIES 6.0.   It offers a wealth of features and it is a critical
// element to making the custom monetary system viable.
////////////////////////////////////////////////////////////////////////////////
#include "npcact_h_prof"
#include "npcact_h_money"
#include "npcact_h_cconv"
////////////////////////////
// CONSTANTS
////////////////////////////


////////////////////////////
// PROTOTYPES
////////////////////////////


//////////////////////////////////////////////////////////////// MAIN
void main()
{
  object oMe=OBJECT_SELF;
  object oMod=GetModule();
  int nState=GetLocalInt(oMe,"nProfMerchState");
   int nSpeed=GetLocalInt(oMe,"nGNBStateSpeed");
   if(!nSpeed) nSpeed=GetLocalInt(GetModule(),"nGNBStateSpeed"); // 6/06/10 Peak
   if (nSpeed<1) nSpeed=6;
  int nCurrency=GetLocalInt(oMe,"nCurrency");
  int nN;
  float fF;
  object oOb;
  string sS;
  object oWP;
  location lLoc;
  int bLocStoreMode=GetLocalInt(oMe,"bProfMerchLocStore"); // Locations instead of waypoint destinations?
  int bCompleted=FALSE;
  int bDB=GetLocalInt(oMe,"bProfMerchDB"); // Use Database for Merchant settings
  fnDebug("npcact_p_merch entered");
  SetLocalInt(oMe,"bGNBProfessions",TRUE);  // corPeak 5/10
  SetLocalInt(oMe,"nGNBProfProc",1);
  SetLocalInt(oMe,"nGNBProfFail",3+nSpeed);
  if (!IsInConversation(oMe)&&!GetIsInCombat(oMe))
  { // okay to act normally
    switch(nState)
    { // Main Merchant Switch----------------------------------------------------
      case 0: { // setup state
        break;
      } // setup state
      case 1: { // move to pickup location
        break;
      } // move to pickup location
      case 2: { // pickup goods
        break;
      } // pickup goods
      case 3: { // move to work location
        break;
      } // move to work location
      case 4: { // do work
        break;
      } // do work
      case 5: { // go to restock location
        break;
      } // go to restock location
      case 6: { // restock
        break;
      } // restock
      case 7: { // follow person hired
        break;
      } // follow person hired
      case 8: { // collect wages
        break;
      } // collect wages
      case 9: { // liquidate stock
        break;
      } // liquidate stock
      case 10: { // cancel employment
        break;
      } // cancel employment
      case 11: { // despawn
        break;
      } // despawn
      case 12: { // return control to NPC ACTIVITIES
        break;
      } // return control to NPC ACTIVITIES
      default: { SetLocalInt(oMe,"nState",0); break; }
    } // Main Merchant Switch----------------------------------------------------
  } // Okay to act normally
  if (!bCompleted) DelayCommand(IntToFloat(nSpeed),ExecuteScript("npcact_p_merch",oMe));
  fnDebug("npcact_p_merch exited");
}
//////////////////////////////////////////////////////////////// MAIN

////////////////////////////
// FUNCTIONS
////////////////////////////
